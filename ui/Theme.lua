-- =============================================================================
-- FarmBuddy - Tema e kit de widgets
-- =============================================================================
-- Todas as janelas do FarmBuddy usam os construtores deste arquivo. Cada
-- widget registra uma função de "pintura" que lê as cores do tema atual;
-- trocar tema/fonte só precisa chamar FarmBuddyTheme:Apply().
--
-- Widgets são feitos do zero (sem templates da Blizzard) para funcionar
-- igual no Retail, Classic e Forever.
-- =============================================================================

local L = FarmBuddyL

FarmBuddyTheme = {}
local T = FarmBuddyTheme

local WHITE = "Interface\\Buttons\\WHITE8x8"
local BACKDROP_TEMPLATE = BackdropTemplateMixin and "BackdropTemplate" or nil
local BASE_FONT_SIZE = 13

-- -----------------------------------------------------------------------------
-- Paletas
-- -----------------------------------------------------------------------------
local function hex(h)
    return tonumber(h:sub(2, 3), 16) / 255, tonumber(h:sub(4, 5), 16) / 255, tonumber(h:sub(6, 7), 16) / 255
end

local function palette(p)
    local out = {}
    for role, value in pairs(p) do
        out[role] = { hex(value) }
    end
    return out
end

T.themes = {
    blizzard = palette({
        bg = "#16120d", header = "#0e0b08", panel = "#0f0c08", border = "#a8843a",
        borderDim = "#3a2c16", borderMid = "#5a4320", accent = "#ffd100", text = "#e8dcc0",
        muted = "#a89a7c", white = "#ffffff", btn = "#7a170c", btnText = "#ffd100",
        btnBorder = "#c9a24a", secondary = "#241b10", selected = "#2a2014", hover = "#221a10",
        corner = "#ffd100", input = "#000000", good = "#3fd65a", warn = "#ffb02e", bar = "#e0a800",
    }),
    dark = palette({
        bg = "#1b1d22", header = "#121317", panel = "#15171b", border = "#3b4250",
        borderDim = "#2a2e36", borderMid = "#3b4250", accent = "#e0b84f", text = "#d8dce3",
        muted = "#8b93a1", white = "#ffffff", btn = "#2d3340", btnText = "#e0b84f",
        btnBorder = "#4a5263", secondary = "#23262d", selected = "#2a2f39", hover = "#22252c",
        corner = "#3b4250", input = "#0f1013", good = "#4cc764", warn = "#e8a33a", bar = "#e0b84f",
    }),
    parchment = palette({
        bg = "#e8d9b5", header = "#cdb88a", panel = "#f2e7cc", border = "#7a5a2a",
        borderDim = "#c4ad7f", borderMid = "#a88a55", accent = "#6b3a12", text = "#3b2a14",
        muted = "#6e5a3c", white = "#2a1d0e", btn = "#7a1a0e", btnText = "#ffe9a8",
        btnBorder = "#4a2a0a", secondary = "#dcc9a0", selected = "#d4bd8a", hover = "#e0cfa6",
        corner = "#7a5a2a", input = "#fbf5e6", good = "#2e7d32", warn = "#a35a00", bar = "#8a5a12",
    }),
}
T.themeOrder = { "blizzard", "dark", "parchment" }
T.themeLabels = { blizzard = "Blizzard", dark = "Dark", parchment = "Parchment" }

-- -----------------------------------------------------------------------------
-- Configurações de aparência (globais da conta, não por personagem)
-- -----------------------------------------------------------------------------
local DEFAULTS = { theme = "blizzard", font = "default", fontSize = BASE_FONT_SIZE, scale = 100, opacity = 95 }

function T:GetSettings()
    FarmBuddyDB.appearance = FarmBuddyDB.appearance or {}
    local s = FarmBuddyDB.appearance
    for k, v in pairs(DEFAULTS) do
        if s[k] == nil then s[k] = v end
    end
    if not self.themes[s.theme] then s.theme = DEFAULTS.theme end
    return s
end

function T:GetPalette()
    return self.themes[self:GetSettings().theme] or self.themes.blizzard
end

function T:Color(role)
    local c = self:GetPalette()[role] or self.themes.blizzard[role] or { 1, 1, 1 }
    return c[1], c[2], c[3]
end

function T:ColorHex(role)
    local r, g, b = self:Color(role)
    return string.format("ff%02x%02x%02x", r * 255, g * 255, b * 255)
end

-- -----------------------------------------------------------------------------
-- Fontes (do jogo + LibSharedMedia, se houver)
-- -----------------------------------------------------------------------------
local fontList
function T:GetFonts()
    if fontList then return fontList end
    local defaultPath = "Fonts\\FRIZQT__.TTF"
    if GameFontNormal and GameFontNormal.GetFont then
        defaultPath = GameFontNormal:GetFont() or defaultPath
    end
    fontList = {
        { key = "default", label = L["Game default"], path = defaultPath },
        { key = "friz", label = "Friz Quadrata", path = "Fonts\\FRIZQT__.TTF" },
        { key = "arialn", label = "Arial Narrow", path = "Fonts\\ARIALN.TTF" },
        { key = "morpheus", label = "Morpheus", path = "Fonts\\MORPHEUS.TTF" },
        { key = "skurri", label = "Skurri", path = "Fonts\\SKURRI.TTF" },
    }
    local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)
    if LSM then
        local known = {}
        for _, f in ipairs(fontList) do known[f.path:lower()] = true end
        for _, name in ipairs(LSM:List("font") or {}) do
            local path = LSM:Fetch("font", name, true)
            if path and not known[path:lower()] then
                known[path:lower()] = true
                table.insert(fontList, { key = "lsm:" .. name, label = name, path = path })
            end
        end
    end
    return fontList
end

function T:GetFontPath()
    local key = self:GetSettings().font
    for _, f in ipairs(self:GetFonts()) do
        if f.key == key then return f.path end
    end
    return self:GetFonts()[1].path
end

-- Fontes do LSM podem ser registradas depois do login: recarrega a lista
function T:RefreshFontList()
    fontList = nil
end

-- -----------------------------------------------------------------------------
-- Registro de pintura
-- -----------------------------------------------------------------------------
local painters = setmetatable({}, { __mode = "k" })
local windows = setmetatable({}, { __mode = "k" })
local changeCallbacks = {}

-- Espessura de borda em pixels físicos inteiros (mínimo 1). Com escala de UI
-- menor que 1, uma borda de "1 unidade" vira menos de 1 pixel e o jogo
-- arredonda alguns lados para zero; isto garante que todos os lados apareçam.
function T:PixelSize(frame, units)
    local _, physH = GetPhysicalScreenSize()
    if not physH or physH <= 0 then return units or 1 end
    local scale = frame:GetEffectiveScale()
    local px = math.max(1, math.floor((units or 1) * scale * physH / 768 + 0.5))
    return px * 768 / physH / scale
end

-- (Re)aplica o backdrop com a borda em pixels inteiros. Só refaz o
-- SetBackdrop quando a espessura muda (ele zera as cores).
function T:ApplyEdge(frame, units, withBg)
    local e = self:PixelSize(frame, units)
    if frame.fbEdgeSize ~= e then
        frame.fbEdgeSize = e
        frame:SetBackdrop({
            bgFile = withBg and WHITE or nil, edgeFile = WHITE, edgeSize = e,
            insets = { left = e, right = e, top = e, bottom = e },
        })
    end
end

function T:Register(obj, paintFn)
    painters[obj] = paintFn
    paintFn(obj)
    return obj
end

function T:Repaint(obj)
    local fn = painters[obj]
    if fn then fn(obj) end
end

function T:OnChange(callback)
    table.insert(changeCallbacks, callback)
end

function T:Apply()
    -- Escala antes da pintura: a espessura das bordas depende dela
    local s = self:GetSettings()
    for win in pairs(windows) do
        win:SetScale(s.scale / 100)
    end
    for obj, fn in pairs(painters) do
        fn(obj)
    end
    for _, cb in ipairs(changeCallbacks) do
        pcall(cb)
    end
end

-- Aplica fonte + cor numa FontString, acompanhando tema e tamanho
function T:Text(fs, size, role, flags)
    fs.fbSize = size or BASE_FONT_SIZE
    fs.fbRole = role or "text"
    fs.fbFlags = flags or ""
    return self:Register(fs, function(f)
        local s = T:GetSettings()
        local finalSize = math.max(8, f.fbSize + (s.fontSize - BASE_FONT_SIZE))
        if not f:SetFont(T:GetFontPath(), finalSize, f.fbFlags) then
            f:SetFont("Fonts\\FRIZQT__.TTF", finalSize, f.fbFlags)
        end
        if f.fbRole then
            f:SetTextColor(T:Color(f.fbRole))
        end
    end)
end

function T:SetTextRole(fs, role)
    fs.fbRole = role
    self:Repaint(fs)
end

function T:CreateText(parent, size, role, layer, flags)
    local fs = parent:CreateFontString(nil, layer or "OVERLAY")
    self:Text(fs, size, role, flags)
    fs:SetJustifyH("LEFT")
    return fs
end

-- Backdrop sólido: fundo + borda com papéis de cor
function T:Backdrop(frame, bgRole, borderRole, edge, bgAlphaFn)
    frame.fbBg = bgRole
    frame.fbBorder = borderRole
    frame.fbEdgeUnits = edge or 1
    return self:Register(frame, function(f)
        T:ApplyEdge(f, f.fbEdgeUnits, true)
        local r, g, b = T:Color(f.fbBg)
        f:SetBackdropColor(r, g, b, bgAlphaFn and bgAlphaFn() or 1)
        if f.fbBorder then
            f:SetBackdropBorderColor(T:Color(f.fbBorder))
        else
            f:SetBackdropBorderColor(0, 0, 0, 0)
        end
    end)
end

function T:SetBackdropRoles(frame, bgRole, borderRole)
    frame.fbBg = bgRole
    frame.fbBorder = borderRole
    self:Repaint(frame)
end

function T:CreatePanel(parent, bgRole, borderRole)
    local f = CreateFrame("Frame", nil, parent, BACKDROP_TEMPLATE)
    self:Backdrop(f, bgRole or "panel", borderRole or "borderDim")
    return f
end

function T:CreateColorTexture(parent, role, layer, alpha)
    local tex = parent:CreateTexture(nil, layer or "ARTWORK")
    tex.fbRole = role
    tex.fbAlpha = alpha or 1
    return self:Register(tex, function(t)
        local r, g, b = T:Color(t.fbRole)
        t:SetColorTexture(r, g, b, t.fbAlpha)
    end)
end

function T:SetTextureRole(tex, role, alpha)
    tex.fbRole = role
    if alpha then tex.fbAlpha = alpha end
    self:Repaint(tex)
end

-- -----------------------------------------------------------------------------
-- Tooltip simples
-- -----------------------------------------------------------------------------
function T:AttachTooltip(widget, title, subtitle)
    widget:HookScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(title)
        if subtitle then GameTooltip:AddLine(subtitle, 0.7, 0.7, 0.7, true) end
        GameTooltip:Show()
    end)
    widget:HookScript("OnLeave", function() GameTooltip:Hide() end)
end

-- -----------------------------------------------------------------------------
-- Janela
-- -----------------------------------------------------------------------------
-- Retorna o frame; o conteúdo vai em frame.body (abaixo do header).
function T:CreateWindow(name, width, height, title)
    local f = CreateFrame("Frame", name, UIParent, BACKDROP_TEMPLATE)
    f:SetSize(width, height)
    f:SetPoint("CENTER")
    f:SetFrameStrata("MEDIUM")
    f:SetToplevel(true)
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:Hide()

    self:Backdrop(f, "bg", "border", 2, function()
        return T:GetSettings().opacity / 100
    end)

    -- Linha interna (dá o relevo da moldura)
    local inner = CreateFrame("Frame", nil, f, BACKDROP_TEMPLATE)
    inner:SetPoint("TOPLEFT", 2, -2)
    inner:SetPoint("BOTTOMRIGHT", -2, 2)
    self:Register(inner, function(i)
        T:ApplyEdge(i, 1, false)
        i:SetBackdropBorderColor(T:Color("borderDim"))
    end)

    -- Losangos nos cantos
    for _, point in ipairs({ "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT" }) do
        local holder = CreateFrame("Frame", nil, f)
        holder:SetSize(12, 12)
        holder:SetPoint("CENTER", f, point, 0, 0)
        holder:SetFrameLevel(f:GetFrameLevel() + 5)
        local outline = self:CreateColorTexture(holder, "borderMid", "ARTWORK")
        outline:SetSize(10, 10)
        outline:SetPoint("CENTER")
        outline:SetRotation(math.rad(45))
        local gem = self:CreateColorTexture(holder, "corner", "OVERLAY")
        gem:SetSize(7, 7)
        gem:SetPoint("CENTER")
        gem:SetRotation(math.rad(45))
    end

    -- Header
    local header = CreateFrame("Frame", nil, f, BACKDROP_TEMPLATE)
    header:SetPoint("TOPLEFT", 2, -2)
    header:SetPoint("TOPRIGHT", -2, -2)
    header:SetHeight(36)
    header:SetBackdrop({ bgFile = WHITE })
    self:Register(header, function(h) h:SetBackdropColor(T:Color("header")) end)

    local headerLine = self:CreateColorTexture(header, "borderMid", "BORDER")
    headerLine:SetPoint("BOTTOMLEFT")
    headerLine:SetPoint("BOTTOMRIGHT")
    headerLine:SetHeight(1)

    local titleText = self:CreateText(header, 15, "accent", "OVERLAY", "")
    titleText:SetPoint("LEFT", 14, 0)
    titleText:SetShadowOffset(1, -1)
    titleText:SetShadowColor(0, 0, 0, 1)
    titleText:SetText(title or "")

    local closeButton = self:CreateIconButton(header, "Interface\\AddOns\\FarmBuddy\\icon\\close.png", 26, 18, L["Close"])
    closeButton:SetPoint("RIGHT", -6, 0)
    closeButton:SetScript("OnClick", function() f:Hide() end)

    local body = CreateFrame("Frame", nil, f)
    body:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, 0)
    body:SetPoint("BOTTOMRIGHT", -2, 2)

    f.header = header
    f.title = titleText
    f.closeButton = closeButton
    f.body = body

    -- ESC fecha a janela
    if name then
        table.insert(UISpecialFrames, name)
    end

    windows[f] = true
    f:SetScale(self:GetSettings().scale / 100)
    return f
end

-- Separador vertical do header
function T:CreateHeaderDivider(header)
    local d = self:CreateColorTexture(header, "borderDim", "ARTWORK")
    d:SetSize(1, 18)
    return d
end

-- -----------------------------------------------------------------------------
-- Botões
-- -----------------------------------------------------------------------------
function T:CreateIconButton(parent, texture, size, iconSize, tooltip, subtitle)
    local b = CreateFrame("Button", nil, parent, BACKDROP_TEMPLATE)
    b:SetSize(size or 26, size or 26)
    b.fbHover = false
    self:Register(b, function(btn)
        T:ApplyEdge(btn, 1, true)
        if btn.fbHover then
            local r, g, bb = T:Color("secondary")
            btn:SetBackdropColor(r, g, bb, 1)
            btn:SetBackdropBorderColor(T:Color("borderMid"))
        else
            btn:SetBackdropColor(0, 0, 0, 0)
            btn:SetBackdropBorderColor(0, 0, 0, 0)
        end
    end)
    local icon = b:CreateTexture(nil, "ARTWORK")
    icon:SetSize(iconSize or 18, iconSize or 18)
    icon:SetPoint("CENTER")
    icon:SetTexture(texture)
    b.icon = icon
    b:SetScript("OnEnter", function(self) self.fbHover = true; T:Repaint(self) end)
    b:SetScript("OnLeave", function(self) self.fbHover = false; T:Repaint(self) end)
    if tooltip then self:AttachTooltip(b, tooltip, subtitle) end
    return b
end

-- kind: "primary" (vermelho Blizzard) ou "secondary" (discreto)
function T:CreateButton(parent, text, width, height, kind)
    local b = CreateFrame("Button", nil, parent, BACKDROP_TEMPLATE)
    b:SetSize(width or 90, height or 28)
    b.fbKind = kind or "primary"
    b.fbHover = false

    local shine = b:CreateTexture(nil, "ARTWORK")
    shine:SetPoint("TOPLEFT", 1, -1)
    shine:SetPoint("TOPRIGHT", -1, -1)
    shine:SetHeight(1)
    shine:SetColorTexture(1, 1, 1, 0.18)
    b.shine = shine

    local label = self:CreateText(b, b.fbKind == "primary" and 13 or 12, "text")
    label:SetPoint("CENTER")
    label:SetJustifyH("CENTER")
    label:SetShadowOffset(1, -1)
    label:SetShadowColor(0, 0, 0, 0.9)
    label:SetText(text or "")
    b.label = label

    self:Register(b, function(btn)
        T:ApplyEdge(btn, 1, true)
        local primary = btn.fbKind == "primary"
        local r, g, bb = T:Color(primary and "btn" or "secondary")
        local boost = btn.fbHover and btn:IsEnabled() and 0.12 or 0
        btn:SetBackdropColor(math.min(1, r + boost), math.min(1, g + boost), math.min(1, bb + boost), 1)
        btn:SetBackdropBorderColor(T:Color(primary and "btnBorder" or "borderMid"))
        btn.shine:SetShown(primary)
        T:SetTextRole(btn.label, primary and "btnText" or "text")
        btn:SetAlpha(btn:IsEnabled() and 1 or 0.45)
    end)

    b:SetScript("OnEnter", function(self) self.fbHover = true; T:Repaint(self) end)
    b:SetScript("OnLeave", function(self) self.fbHover = false; T:Repaint(self) end)
    b:SetScript("OnEnable", function(self) T:Repaint(self) end)
    b:SetScript("OnDisable", function(self) T:Repaint(self) end)

    function b:SetLabel(t) self.label:SetText(t) end
    return b
end

-- Botão de seção (sidebar) com estado selecionado
function T:CreateNavButton(parent, height)
    local b = CreateFrame("Button", nil, parent, BACKDROP_TEMPLATE)
    b:SetHeight(height or 34)
    b.fbSelected = false
    b.fbHover = false
    self:Register(b, function(btn)
        T:ApplyEdge(btn, 1, true)
        if btn.fbSelected then
            btn:SetBackdropColor(T:Color("selected"))
            btn:SetBackdropBorderColor(T:Color("border"))
        elseif btn.fbHover then
            btn:SetBackdropColor(T:Color("hover"))
            btn:SetBackdropBorderColor(0, 0, 0, 0)
        else
            btn:SetBackdropColor(0, 0, 0, 0)
            btn:SetBackdropBorderColor(0, 0, 0, 0)
        end
        if btn.OnPaint then btn:OnPaint() end
    end)
    b:SetScript("OnEnter", function(self) self.fbHover = true; T:Repaint(self) end)
    b:SetScript("OnLeave", function(self) self.fbHover = false; T:Repaint(self) end)
    function b:SetSelected(v) self.fbSelected = v and true or false; T:Repaint(self) end
    return b
end

-- Aba pendurada embaixo da janela (estilo janela de personagem)
function T:CreateTab(parent, text)
    local b = CreateFrame("Button", nil, parent, BACKDROP_TEMPLATE)
    local label = self:CreateText(b, 13, "muted")
    label:SetPoint("CENTER", 0, 1)
    label:SetJustifyH("CENTER")
    label:SetText(text)
    b.label = label
    b:SetSize(math.max(80, label:GetStringWidth() + 32), 30)
    b.fbSelected = false
    self:Register(b, function(tab)
        T:ApplyEdge(tab, 2, true)
        if tab.fbSelected then
            tab:SetBackdropColor(T:Color("header"))
            tab:SetBackdropBorderColor(T:Color("border"))
            T:SetTextRole(tab.label, "accent")
            tab:SetHeight(30)
        else
            tab:SetBackdropColor(T:Color("secondary"))
            tab:SetBackdropBorderColor(T:Color("borderMid"))
            T:SetTextRole(tab.label, "muted")
            tab:SetHeight(26)
        end
    end)
    function b:SetSelected(v) self.fbSelected = v and true or false; T:Repaint(self) end
    return b
end

-- -----------------------------------------------------------------------------
-- Checkbox / radio
-- -----------------------------------------------------------------------------
function T:CreateCheckbox(parent, text, isRadio)
    local cb = CreateFrame("CheckButton", nil, parent, BACKDROP_TEMPLATE)
    cb:SetSize(14, 14)
    self:Register(cb, function(c)
        T:ApplyEdge(c, 1, true)
        c:SetBackdropColor(T:Color("input"))
        c:SetBackdropBorderColor(T:Color(c:IsEnabled() and "borderMid" or "borderDim"))
        c:SetAlpha(c:IsEnabled() and 1 or 0.5)
    end)

    if isRadio then
        cb:SetCheckedTexture("Interface\\Buttons\\WHITE8x8")
        local dot = cb:GetCheckedTexture()
        dot:ClearAllPoints()
        dot:SetPoint("TOPLEFT", 3, -3)
        dot:SetPoint("BOTTOMRIGHT", -3, 3)
        self:Register(dot, function(t) t:SetVertexColor(T:Color("accent")) end)
    else
        cb:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
        local checked = cb:GetCheckedTexture()
        checked:ClearAllPoints()
        checked:SetPoint("CENTER")
        checked:SetSize(20, 20)
        checked:SetDesaturated(true)
        self:Register(checked, function(t) t:SetVertexColor(T:Color("accent")) end)
    end

    local label = self:CreateText(cb, 12, "text")
    label:SetPoint("LEFT", cb, "RIGHT", 7, 0)
    cb.label = label

    function cb:SetLabel(t)
        self.label:SetText(t or "")
        self:SetHitRectInsets(0, -(self.label:GetStringWidth() + 8), -3, -3)
    end
    cb:SetLabel(text)

    cb:SetScript("OnEnable", function(self) T:Repaint(self); self.label:SetAlpha(1) end)
    cb:SetScript("OnDisable", function(self) T:Repaint(self); self.label:SetAlpha(0.5) end)
    return cb
end

-- -----------------------------------------------------------------------------
-- Campo de texto
-- -----------------------------------------------------------------------------
function T:CreateEditBox(parent, width, height, size)
    local eb = CreateFrame("EditBox", nil, parent, BACKDROP_TEMPLATE)
    eb:SetSize(width or 120, height or 26)
    eb:SetAutoFocus(false)
    eb:SetTextInsets(8, 8, 0, 0)
    self:Backdrop(eb, "input", "borderMid")
    self:Text(eb, size or 13, "text")
    eb:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    eb:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    return eb
end

-- Caixa de texto multilinha com rolagem (para strings de export/import)
function T:CreateTextArea(parent, width, height)
    local box = self:CreatePanel(parent, "input", "borderMid")
    box:SetSize(width, height)

    local scroll = CreateFrame("ScrollFrame", nil, box)
    scroll:SetPoint("TOPLEFT", 6, -6)
    scroll:SetPoint("BOTTOMRIGHT", -6, 6)

    local eb = CreateFrame("EditBox", nil, scroll)
    eb:SetMultiLine(true)
    eb:SetAutoFocus(false)
    eb:SetWidth(width - 14)
    eb:SetFont(ChatFontNormal and ChatFontNormal:GetFont() or "Fonts\\ARIALN.TTF", 11, "")
    self:Register(eb, function(e) e:SetTextColor(T:Color("text")) end)
    eb:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    eb:SetScript("OnCursorChanged", function(_, _, y, _, h)
        local offset = scroll:GetVerticalScroll()
        local visible = scroll:GetHeight()
        y = -y
        if y < offset then
            scroll:SetVerticalScroll(y)
        elseif y + h > offset + visible then
            scroll:SetVerticalScroll(y + h - visible)
        end
    end)
    scroll:SetScrollChild(eb)
    scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel", function(self, delta)
        local max = math.max(0, eb:GetHeight() - self:GetHeight())
        self:SetVerticalScroll(math.min(max, math.max(0, self:GetVerticalScroll() - delta * 20)))
    end)
    box:SetScript("OnMouseDown", function() eb:SetFocus() end)
    box.editBox = eb
    return box
end

-- -----------------------------------------------------------------------------
-- Slider
-- -----------------------------------------------------------------------------
function T:CreateSlider(parent, width, minV, maxV, step)
    local s = CreateFrame("Slider", nil, parent)
    s:EnableMouse(true)
    s:SetOrientation("HORIZONTAL")
    s:SetSize(width, 16)
    s:SetMinMaxValues(minV, maxV)
    s:SetValueStep(step or 1)
    if s.SetObeyStepOnDrag then s:SetObeyStepOnDrag(true) end

    local track = self:CreateColorTexture(s, "input", "BACKGROUND")
    track:SetPoint("LEFT", 0, 0)
    track:SetPoint("RIGHT", 0, 0)
    track:SetHeight(6)

    local trackBorder = CreateFrame("Frame", nil, s, BACKDROP_TEMPLATE)
    trackBorder:SetPoint("LEFT", -1, 0)
    trackBorder:SetPoint("RIGHT", 1, 0)
    trackBorder:SetHeight(8)
    self:Register(trackBorder, function(tb)
        T:ApplyEdge(tb, 1, false)
        tb:SetBackdropBorderColor(T:Color("borderMid"))
    end)

    local thumb = self:CreateColorTexture(s, "accent", "OVERLAY")
    thumb:SetSize(10, 16)
    s:SetThumbTexture(thumb)
    return s
end

-- -----------------------------------------------------------------------------
-- Dropdown (menu próprio, sem UIDropDownMenu)
-- -----------------------------------------------------------------------------
local openMenu
-- getItems() → { {value=, label=}, ... }; onSelect(value)
function T:CreateDropdown(parent, width, getItems, getValue, onSelect)
    local dd = CreateFrame("Button", nil, parent, BACKDROP_TEMPLATE)
    dd:SetSize(width, 28)
    self:Backdrop(dd, "input", "borderMid")

    local text = self:CreateText(dd, 12, "text")
    text:SetPoint("LEFT", 9, 0)
    text:SetPoint("RIGHT", -24, 0)
    text:SetWordWrap(false)
    dd.text = text

    -- Texto cortado: mostra completo no tooltip
    local function TruncatedTooltip(owner, fs)
        if fs:IsTruncated() then
            GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
            GameTooltip:AddLine(fs:GetText(), 1, 1, 1)
            GameTooltip:Show()
        end
    end
    dd:SetScript("OnEnter", function(self) TruncatedTooltip(self, self.text) end)
    dd:SetScript("OnLeave", function() GameTooltip:Hide() end)

    local arrow = dd:CreateTexture(nil, "OVERLAY")
    arrow:SetSize(14, 14)
    arrow:SetPoint("RIGHT", -6, 0)
    arrow:SetTexture("Interface\\Buttons\\Arrow-Down-Up")
    self:Register(arrow, function(a) a:SetVertexColor(T:Color("accent")) end)

    -- Menu fica no UIParent para não ser cortado por áreas com rolagem
    local menu = CreateFrame("Frame", nil, UIParent, BACKDROP_TEMPLATE)
    menu:SetFrameStrata("FULLSCREEN_DIALOG")
    menu:SetPoint("TOPLEFT", dd, "BOTTOMLEFT", 0, -2)
    menu:SetWidth(width)
    menu:EnableMouse(true)
    self:Backdrop(menu, "header", "border")
    menu:Hide()

    local scroll = CreateFrame("ScrollFrame", nil, menu)
    scroll:SetPoint("TOPLEFT", 2, -2)
    scroll:SetPoint("BOTTOMRIGHT", -2, 2)
    local child = CreateFrame("Frame", nil, scroll)
    child:SetWidth(width - 4)
    scroll:SetScrollChild(child)
    scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel", function(self, delta)
        local max = math.max(0, child:GetHeight() - self:GetHeight())
        self:SetVerticalScroll(math.min(max, math.max(0, self:GetVerticalScroll() - delta * 24)))
    end)

    local rows = {}
    local ROW_H = 22

    function dd:Refresh()
        local value = getValue()
        for _, item in ipairs(getItems()) do
            if item.value == value then
                self.text:SetText(item.label)
                return
            end
        end
        self.text:SetText("")
    end

    local function BuildMenu()
        local items = getItems()
        local value = getValue()
        for i, item in ipairs(items) do
            local row = rows[i]
            if not row then
                row = T:CreateNavButton(child, ROW_H)
                row:SetPoint("TOPLEFT", 0, -(i - 1) * ROW_H)
                row:SetPoint("RIGHT", child, "RIGHT", 0, 0)
                row.text = T:CreateText(row, 12, "text")
                row.text:SetPoint("LEFT", 8, 0)
                row.text:SetPoint("RIGHT", -8, 0)
                row.text:SetWordWrap(false)
                row:HookScript("OnEnter", function(self) TruncatedTooltip(self, self.text) end)
                row:HookScript("OnLeave", function() GameTooltip:Hide() end)
                rows[i] = row
            end
            row.text:SetText(item.label)
            row:SetSelected(item.value == value)
            row:SetScript("OnClick", function()
                menu:Hide()
                onSelect(item.value)
                dd:Refresh()
            end)
            row:Show()
        end
        for i = #items + 1, #rows do rows[i]:Hide() end
        child:SetHeight(#items * ROW_H)
        menu:SetHeight(math.min(#items, 10) * ROW_H + 4)
        scroll:SetVerticalScroll(0)
    end

    dd:SetScript("OnClick", function()
        if menu:IsShown() then
            menu:Hide()
            return
        end
        if openMenu and openMenu ~= menu then openMenu:Hide() end
        menu:SetScale(dd:GetEffectiveScale() / UIParent:GetEffectiveScale())
        BuildMenu()
        menu:Show()
        openMenu = menu
    end)
    dd:SetScript("OnHide", function() menu:Hide() end)

    dd.menu = menu
    dd:Refresh()
    return dd
end

-- -----------------------------------------------------------------------------
-- Área com rolagem (roda do mouse + barra fina)
-- -----------------------------------------------------------------------------
function T:CreateScrollArea(parent)
    local scroll = CreateFrame("ScrollFrame", nil, parent)
    local child = CreateFrame("Frame", nil, scroll)
    child:SetSize(1, 1)
    scroll:SetScrollChild(child)
    scroll.child = child

    local bar = CreateFrame("Slider", nil, scroll)
    bar:EnableMouse(true)
    bar:SetOrientation("VERTICAL")
    bar:SetWidth(6)
    bar:SetPoint("TOPRIGHT", scroll, "TOPRIGHT", 0, -2)
    bar:SetPoint("BOTTOMRIGHT", scroll, "BOTTOMRIGHT", 0, 2)
    bar:SetMinMaxValues(0, 0)
    bar:SetValue(0)
    local thumb = self:CreateColorTexture(bar, "borderMid", "OVERLAY")
    thumb:SetSize(6, 30)
    bar:SetThumbTexture(thumb)
    bar:SetScript("OnValueChanged", function(_, v) scroll:SetVerticalScroll(v) end)
    scroll.bar = bar

    local function UpdateRange()
        local max = math.max(0, child:GetHeight() - scroll:GetHeight())
        bar:SetMinMaxValues(0, max)
        bar:SetShown(max > 0)
        if scroll:GetVerticalScroll() > max then
            bar:SetValue(max)
        end
        local ratio = scroll:GetHeight() / math.max(1, child:GetHeight())
        thumb:SetHeight(math.max(20, math.min(1, ratio) * scroll:GetHeight()))
    end
    scroll.UpdateRange = UpdateRange
    scroll:SetScript("OnSizeChanged", function(self, w)
        child:SetWidth(w)
        UpdateRange()
    end)

    scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel", function(_, delta)
        local _, max = bar:GetMinMaxValues()
        bar:SetValue(math.min(max, math.max(0, bar:GetValue() - delta * 30)))
    end)

    function scroll:SetContentHeight(h)
        child:SetHeight(math.max(1, h))
        UpdateRange()
    end
    return scroll
end

-- -----------------------------------------------------------------------------
-- Blocos de estatística e dinheiro
-- -----------------------------------------------------------------------------
local GOLD_ICON = "Interface\\MoneyFrame\\UI-GoldIcon"
-- Ícone de moeda inline para usar dentro de textos
T.COIN = "|T" .. GOLD_ICON .. ":0:0:2:0|t"

function T:CreateStatBox(parent, label, valueSize)
    local box = self:CreatePanel(parent, "panel", "borderDim")
    local l = self:CreateText(box, 11, "muted")
    l:SetPoint("TOPLEFT", 9, -7)
    l:SetText(label)
    local v = self:CreateText(box, valueSize or 18, "white")
    v:SetPoint("TOPLEFT", l, "BOTTOMLEFT", 0, -4)
    local coin = box:CreateTexture(nil, "OVERLAY")
    coin:SetSize(11, 11)
    coin:SetTexture(GOLD_ICON)
    coin:SetPoint("LEFT", v, "RIGHT", 4, 0)
    coin:Hide()
    box.label = l
    box.value = v
    box.coin = coin
    function box:SetValue(text, showCoin)
        self.value:SetText(text)
        self.coin:SetShown(showCoin and true or false)
    end
    return box
end

-- Texto de ouro com ícone de moeda ao lado
function T:CreateGoldText(parent, size, role)
    local fs = self:CreateText(parent, size or 12, role or "text")
    local coin = parent:CreateTexture(nil, "OVERLAY")
    coin:SetSize(10, 10)
    coin:SetTexture(GOLD_ICON)
    coin:SetPoint("LEFT", fs, "RIGHT", 3, 0)
    fs.coin = coin
    return fs
end

-- Formata cobre em ouro inteiro com separador de milhar
function T:FormatGold(copper)
    local gold = math.floor((copper or 0) / 10000)
    local s = tostring(gold)
    local formatted = s:reverse():gsub("(%d%d%d)", "%1,"):reverse()
    if formatted:sub(1, 1) == "," then formatted = formatted:sub(2) end
    return formatted
end

-- hh:mm:ss
function T:FormatClock(seconds)
    seconds = math.max(0, math.floor(seconds or 0))
    return string.format("%02d:%02d:%02d", math.floor(seconds / 3600), math.floor((seconds % 3600) / 60), seconds % 60)
end

-- Cor do nome do item por qualidade; itens comuns usam a cor de texto do tema
function T:QualityColor(quality)
    if quality and quality ~= 1 and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[quality] then
        local c = ITEM_QUALITY_COLORS[quality]
        return c.r, c.g, c.b
    end
    return self:Color("white")
end

-- Recalcula as bordas quando a escala da interface ou a resolução mudam
-- (e uma vez ao entrar no mundo, quando a escala final já foi aplicada)
local scaleWatcher = CreateFrame("Frame")
scaleWatcher:RegisterEvent("UI_SCALE_CHANGED")
scaleWatcher:RegisterEvent("DISPLAY_SIZE_CHANGED")
scaleWatcher:RegisterEvent("PLAYER_ENTERING_WORLD")
scaleWatcher:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
    T:Apply()
end)
