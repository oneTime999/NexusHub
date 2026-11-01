if game.PlaceId ~= 73283852203739 then
	return
end

-- Luau / NexusHub_Professional.lua / Roblox client / Desenvolvido por onetime.999
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ProximityPromptService = game:GetService("ProximityPromptService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local GUI_NAME = "NexusHubInterface"
local IS_TOUCH = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local WIDTH = IS_TOUCH and 460 or 540
local HEIGHT = IS_TOUCH and 300 or 340
local HEADER = 40
local SIDEBAR = IS_TOUCH and 128 or 140

local previous = PlayerGui:FindFirstChild(GUI_NAME)
if previous then
	previous:Destroy()
end

local Theme = {
	Background = Color3.fromRGB(11, 12, 17),
	Panel = Color3.fromRGB(18, 20, 28),
	Card = Color3.fromRGB(25, 27, 37),
	CardHover = Color3.fromRGB(32, 35, 48),
	Track = Color3.fromRGB(48, 53, 70),
	Stroke = Color3.fromRGB(42, 46, 62),
	Text = Color3.fromRGB(236, 240, 250),
	TextDim = Color3.fromRGB(128, 136, 160),
	Success = Color3.fromRGB(0, 255, 170),
	Accent = Color3.fromRGB(0, 220, 255),
	Title = Enum.Font.GothamBold,
	Body = Enum.Font.Gotham,
	Mono = Enum.Font.Code,
}

local Presets = {
	{ Name = "CIANO", Color = Color3.fromRGB(0, 220, 255) },
	{ Name = "VIOLETA", Color = Color3.fromRGB(165, 95, 255) },
	{ Name = "CARMESIM", Color = Color3.fromRGB(255, 60, 90) },
	{ Name = "ESMERALDA", Color = Color3.fromRGB(0, 230, 150) },
	{ Name = "ÂMBAR", Color = Color3.fromRGB(255, 180, 50) },
}

local ModuleOrder = { "Parkour1", "Parkour2", "Parkour3", "Parkour4" }

local Parkour3Segments = {
	{
		Name = "Parkour3_Part1",
		Start = Vector3.new(389.138, 5.022, -897.743),
		End = Vector3.new(394.538, 5.022, -897.743),
		Height = 0.6,
		Width = 11.3,
		TopSurface = true,
	},
	{
		Name = "Parkour3_Link",
		Start = Vector3.new(383.738, 7.822, -897.743),
		End = Vector3.new(389.138, 5.022, -897.743),
		Height = 0.6,
		Width = 11.3,
		TopSurface = true,
	},
	{
		Name = "Parkour3_Part2A",
		Start = Vector3.new(383.738, 7.822, -897.743),
		End = Vector3.new(378.338, 9.422, -897.743),
		Height = 0.6,
		Width = 11.3,
		TopSurface = true,
	},
	{
		Name = "Parkour3_Part2B",
		Start = Vector3.new(378.338, 9.422, -897.743),
		End = Vector3.new(372.938, 11.622, -897.743),
		Height = 0.6,
		Width = 11.3,
		TopSurface = true,
	},
	{
		Name = "Parkour3_Part3",
		Start = Vector3.new(372.938, 11.222, -897.743),
		End = Vector3.new(288.883, 11.222, -897.743),
		Height = 0.6,
		Width = 11.3,
	},
}

local Parkour4Pillars = {
	{ X = 388.833, Top = 7.422 },
	{ X = 383.633, Top = 10.122 },
	{ X = 377.333, Top = 12.922 },
	{ X = 371.033, Top = 14.722 },
	{ X = 364.733, Top = 16.222 },
	{ X = 358.433, Top = 17.622 },
	{ X = 352.133, Top = 19.322 },
	{ X = 345.833, Top = 20.522 },
	{ X = 339.533, Top = 21.622 },
}

local Parkour4Segments = {
	{
		Name = "Parkour4_EntranceLink",
		Start = Vector3.new(392.538, 5.022, -855.838),
		End = Vector3.new(393.938, 5.022, -855.838),
		Height = 0.6,
		Width = 10.2,
		TopSurface = true,
	},
	{
		Name = "Parkour4_EntranceRamp",
		Start = Vector3.new(393.238, 5.022, -855.843),
		End = Vector3.new(388.833, 7.422, -855.843),
		Height = 0.6,
		Width = 1.4,
		TopSurface = true,
	},
}

for index = 1, #Parkour4Pillars - 1 do
	local from = Parkour4Pillars[index]
	local to = Parkour4Pillars[index + 1]

	table.insert(Parkour4Segments, {
		Name = "Parkour4_Step" .. index,
		Start = Vector3.new(from.X, from.Top, -855.843),
		End = Vector3.new(to.X, to.Top, -855.843),
		Height = 0.6,
		Width = 1.4,
		TopSurface = true,
	})
end

table.insert(Parkour4Segments, {
	Name = "Parkour4_Link",
	Start = Vector3.new(339.533, 21.622, -855.893),
	End = Vector3.new(335.433, 21.622, -855.893),
	Height = 0.6,
	Width = 1.4,
	TopSurface = true,
})

table.insert(Parkour4Segments, {
	Name = "Parkour4_Floor",
	Start = Vector3.new(335.433, 21.622, -855.843),
	End = Vector3.new(297.333, 21.622, -855.843),
	Height = 0.6,
	Width = 12.2,
	TopSurface = true,
})

table.insert(Parkour4Segments, {
	Name = "Parkour4_Final",
	Start = Vector3.new(298.033, 21.622, -855.843),
	End = Vector3.new(293.583, 27.022, -855.843),
	Height = 0.6,
	Width = 12.2,
	TopSurface = true,
})

local BridgeDefinitions = {
	Parkour1 = {
		DisplayName = "Parkour 01",
		Description = "Conecta os dois primeiros trechos do percurso.",
		Segments = {
			{
				Name = "Parkour1_Bridge1",
				Start = Vector3.new(157.383, 53.122, -897.793),
				End = Vector3.new(188.783, 53.122, -897.793),
				Height = 0.3,
				Width = 16.5,
			},
			{
				Name = "Parkour1_Bridge2",
				Start = Vector3.new(188.783, 53.122, -897.793),
				End = Vector3.new(245.282, 53.122, -897.793),
				Height = 0.3,
				Width = 16.5,
			},
		},
	},
	Parkour2 = {
		DisplayName = "Parkour 02",
		Description = "Abre uma travessia contínua em trecho único.",
		Segments = {
			{
				Name = "Parkour2_Bridge1",
				Start = Vector3.new(153.383, 13.222, -855.943),
				End = Vector3.new(251.833, 13.222, -855.944),
				Height = 0.4,
				Width = 14.2,
			},
		},
	},
	Parkour3 = {
		DisplayName = "Parkour 03",
		Description = "Reconstrói a rota com cinco trechos alinhados.",
		Segments = Parkour3Segments,
	},
	Parkour4 = {
		DisplayName = "Parkour 04",
		Description = "Monta a rota avançada com treze trechos.",
		Segments = Parkour4Segments,
	},
}

local PreviewMode = false

local function createBridgeSegment(name, startPos, endPos, heightY, widthZ, topSurface, preview)
	if startPos.X > endPos.X then
		startPos, endPos = endPos, startPos
	end

	local delta = endPos - startPos
	local length = math.sqrt(delta.X ^ 2 + delta.Y ^ 2)
	local angle = math.atan2(delta.Y, delta.X)
	local center = startPos:Lerp(endPos, 0.5)

	if topSurface then
		local normal = Vector3.new(-math.sin(angle), math.cos(angle), 0)
		center = center - normal * (heightY / 2)
	end

	local platform = Instance.new("Part")
	platform.Name = name
	platform.Size = Vector3.new(length, heightY, widthZ)
	platform.CFrame = CFrame.new(center) * CFrame.Angles(0, 0, angle)
	platform.Transparency = preview and 0.3 or 1
	if preview then
		platform.Color = Color3.fromRGB(255, 0, 0)
		platform.Material = Enum.Material.Neon
	end
	platform.Anchored = true
	platform.CanCollide = true
	platform.Parent = Workspace

	return platform
end

local BridgeManager = {
	Active = {},
}

function BridgeManager.Enable(key)
	local definition = BridgeDefinitions[key]
	if not definition then
		error("Unknown bridge: " .. tostring(key))
	end

	local existing = BridgeManager.Active[key]
	if existing then
		local healthy = #existing == #definition.Segments
		for _, part in ipairs(existing) do
			if not part or not part.Parent then
				healthy = false
				break
			end
		end
		if healthy then
			return
		end
		BridgeManager.Disable(key)
	end

	local parts = {}
	local ok, err = pcall(function()
		for _, segment in ipairs(definition.Segments) do
			table.insert(parts, createBridgeSegment(segment.Name, segment.Start, segment.End,
				segment.Height, segment.Width, segment.TopSurface, PreviewMode))
		end
	end)
	if not ok then
		for _, part in ipairs(parts) do
			pcall(function() part:Destroy() end)
		end
		error(err)
	end
	BridgeManager.Active[key] = parts
end

function BridgeManager.Rebuild(key)
	local wasActive = BridgeManager.Active[key] ~= nil
	if wasActive then
		BridgeManager.Disable(key)
		BridgeManager.Enable(key)
	end
end

function BridgeManager.Reconcile()
	for key, parts in pairs(BridgeManager.Active) do
		local healthy = #parts == #BridgeDefinitions[key].Segments
		for _, part in ipairs(parts) do
			if not part or not part.Parent then
				healthy = false
				break
			end
		end
		if not healthy then
			local ok, err = pcall(function() BridgeManager.Enable(key) end)
			if not ok then
				warn("[NexusHub] Could not restore " .. key .. ": " .. tostring(err))
			end
		end
	end
end

function BridgeManager.Disable(key)
	local parts = BridgeManager.Active[key]
	if not parts then
		return
	end

	for _, part in ipairs(parts) do
		part:Destroy()
	end

	BridgeManager.Active[key] = nil
end

function BridgeManager.Count()
	local count = 0
	for _ in pairs(BridgeManager.Active) do
		count += 1
	end
	return count
end

function BridgeManager.Clear()
	for key in pairs(BridgeManager.Active) do
		BridgeManager.Disable(key)
	end
end

local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")

local SETTINGS_FILE = "NexusHub_Settings.json"
local STATUS_TEXT = "SISTEMA ATIVO · V1.2 · BY ONETIME.999"
local ROW_HEIGHT = IS_TOUCH and 40 or 46
local SWITCH_HEIGHT = 40
local LIST_GAP = 10
local PAGE_HEADER = 34
local FOOTER_HEIGHT = 104
local TAB_HEIGHT = IS_TOUCH and 34 or 32
local TAB_GAP = 4
local TAB_TOP = 10
local CONTROL_SIZE = IS_TOUCH and 30 or 26
local SEGMENT_HEIGHT = IS_TOUCH and 32 or 28
local HEADER_BUTTON = IS_TOUCH and UDim2.fromOffset(86, 28) or UDim2.fromOffset(88, 24)
local BLUR_SIZE = 14

local Settings = {
	Preview = false,
	SavedBridges = {},
	AutoRestoreBridges = true,
	PerformanceMode = false,
	Accent = 1,
	Scale = 1,
	Particles = true,
	Scanline = true,
	Blur = false,
	Intro = true,
	ToggleKey = "RightControl",
	Gesture = true,
	ClickDelay = 1.5,
	TargetClicks = 100,
	AutoInteractInterval = 0.25,
	AutoInteractHold = 0.05,
	AutoInteractRange = 20,
	AutoInteractInstant = true,
}

local function loadSettings()
	local success, decoded = pcall(function()
		return HttpService:JSONDecode(readfile(SETTINGS_FILE))
	end)

	if success and type(decoded) == "table" then
		for key, value in pairs(decoded) do
			if Settings[key] ~= nil and type(value) == type(Settings[key]) then
				Settings[key] = value
			end
		end
	end
end

local function writeSettings()
	pcall(function()
		writefile(SETTINGS_FILE, HttpService:JSONEncode(Settings))
	end)
end

local saveToken = 0

local function saveSettings()
	saveToken += 1
	local token = saveToken
	task.delay(0.6, function()
		if token == saveToken then
			writeSettings()
		end
	end)
end

local function resolveKey(name)
	local success, keyCode = pcall(function()
		return Enum.KeyCode[name]
	end)
	if success and keyCode then
		return keyCode
	end
	return Enum.KeyCode.RightControl
end

loadSettings()
PreviewMode = Settings.Preview == true
if type(Settings.SavedBridges) ~= "table" then Settings.SavedBridges = {} end
Settings.Accent = math.clamp(math.floor(Settings.Accent), 1, #Presets)
Settings.Scale = math.clamp(Settings.Scale, 0.7, 1.2)
Settings.ClickDelay = math.clamp(Settings.ClickDelay, 0.1, 5.0)
Settings.TargetClicks = math.max(0, math.floor(Settings.TargetClicks))
Settings.AutoInteractInterval = math.clamp(Settings.AutoInteractInterval, 0.05, 3.0)
Settings.AutoInteractHold = math.clamp(Settings.AutoInteractHold, 0, 2.0)
Settings.AutoInteractRange = math.clamp(Settings.AutoInteractRange, 5, 50)
Theme.Accent = Presets[Settings.Accent].Color

local toggleKey = resolveKey(Settings.ToggleKey)

local previousBlur = Lighting:FindFirstChild("NexusHubBlur")
if previousBlur then
	previousBlur:Destroy()
end

local alive = true
local closing = false
local minimized = false
local visible = true
local bulkUpdate = false
local capturingKey = false
local introPlayed = false
local multiplier = Settings.Scale
local particlesEnabled = Settings.Particles
local glowTweens = {}
local connections = {}
local accentListeners = {}
local toastFrame = nil
local pointer = Vector2.zero

-- Variáveis do Auto Minigame
local autoMinigameActive = false
local autoMinigameReady = false
local selectedExercise = "Polichinelos"
local currentClickCount = 0
local isMobileTouch = UserInputService.TouchEnabled

local Localization = {
	["PARKOUR"] = { pt = "PARKOUR" },
	["MINIGAME"] = { pt = "EXERCÍCIOS" },
	["AUTO INTERACT"] = { pt = "INTERAGIR" },
	["AJUSTES"] = { pt = "AJUSTES" },
	["ROTAS DE PARKOUR"] = { pt = "ROTAS DE PARKOUR" },
	["TREINO AUTOMÁTICO"] = { pt = "TREINO AUTOMÁTICO" },
	["INTERAÇÃO AUTOMÁTICA"] = { pt = "INTERAÇÃO AUTOMÁTICA" },
	["APARÊNCIA E COMPORTAMENTO"] = { pt = "APARÊNCIA E COMPORTAMENTO" },
	["DESLIGAR TUDO"] = { pt = "DESLIGAR TUDO" },
	["LIGAR TUDO"] = { pt = "LIGAR TUDO" },
	["Parkour 01"] = { pt = "Parkour 01" },
	["Parkour 02"] = { pt = "Parkour 02" },
	["Parkour 03"] = { pt = "Parkour 03" },
	["Parkour 04"] = { pt = "Parkour 04" },
	["Parkour 01 · 2 trechos"] = { pt = "Parkour 01 · 2 trechos" },
	["Parkour 02 · trecho único"] = { pt = "Parkour 02 · trecho único" },
	["Parkour 03 · 5 trechos"] = { pt = "Parkour 03 · 5 trechos" },
	["Parkour 04 · 13 trechos"] = { pt = "Parkour 04 · 13 trechos" },
	["Desfoque do cenário"] = { pt = "Desfoque do cenário" },
	["Aplica um desfoque suave ao cenário atrás da janela."] = { pt = "Aplica um desfoque suave ao cenário atrás da janela." },
	["Partículas de fundo"] = { pt = "Partículas de fundo" },
	["Exibe partículas discretas no plano de fundo."] = { pt = "Exibe partículas discretas no plano de fundo." },
	["Linhas de varredura"] = { pt = "Linhas de varredura" },
	["Adiciona linhas animadas ao fundo da interface."] = { pt = "Adiciona linhas animadas ao fundo da interface." },
	["Tamanho da interface"] = { pt = "Tamanho da interface" },
	["Animação de entrada"] = { pt = "Animação de entrada" },
	["Exibe a animação de abertura ao iniciar o Nexus Hub."] = { pt = "Exibe a animação de abertura ao iniciar o Nexus Hub." },
	["Desempenho aprimorado"] = { pt = "Desempenho aprimorado" },
	["Reduz os efeitos visuais para priorizar a fluidez."] = { pt = "Reduz os efeitos visuais para priorizar a fluidez." },
	["Visualização do parkour"] = { pt = "Visualização do parkour" },
	["Destaca os trechos de parkour em vermelho para conferência visual."] = { pt = "Destaca os trechos de parkour em vermelho para conferência visual." },
	["Restaurar rotas"] = { pt = "Restaurar rotas" },
	["Reativa automaticamente as rotas salvas na sessão anterior."] = { pt = "Reativa automaticamente as rotas salvas na sessão anterior." },
	["Copiar posição"] = { pt = "Copiar posição" },
	["Copia as coordenadas atuais para a área de transferência."] = { pt = "Copia as coordenadas atuais para a área de transferência." },
	["Inspecionar peça apontada"] = { pt = "Inspecionar peça apontada" },
	["Lê nome, posição, tamanho e material da peça sob o cursor."] = { pt = "Lê nome, posição, tamanho e material da peça sob o cursor." },
	["Posição copiada."] = { pt = "Posição copiada." },
	["Área de transferência indisponível neste ambiente."] = { pt = "Área de transferência indisponível neste ambiente." },
	["Nenhuma peça válida foi selecionada."] = { pt = "Nenhuma peça válida foi selecionada." },
	["Dados da peça copiados."] = { pt = "Dados da peça copiados." },
	["PREFERÊNCIAS DO SISTEMA"] = { pt = "PREFERÊNCIAS DO SISTEMA" },
	["// ABOUT"] = { pt = "SOBRE O NEXUS HUB" },
	["Atalho por três dedos"] = { pt = "Atalho por três dedos" },
	["Use três dedos na tela para ocultar ou exibir a janela."] = { pt = "Use três dedos na tela para ocultar ou exibir a janela." },
	["CENTRALIZAR JANELA"] = { pt = "CENTRALIZAR JANELA" },
	["Tema aplicado · "] = { pt = "Tema aplicado · " },
	["Todas as rotas de parkour foram ativadas."] = { pt = "Todas as rotas de parkour foram ativadas." },
	["Todas as rotas de parkour foram desativadas."] = { pt = "Todas as rotas de parkour foram desativadas." },
	["Pular"] = { pt = "Polichinelos" },
	["Barras"] = { pt = "Barras" },
	["Flexões"] = { pt = "Flexões" },
	["Polichinelos"] = { pt = "Polichinelos" },
	["Ativar automação"] = { pt = "Ativar automação" },
	["Intervalo entre cliques"] = { pt = "Intervalo entre cliques" },
	["Limite de repetições"] = { pt = "Limite de repetições" },
	["Meta de "] = { pt = "Meta de " },
	[" repetições concluída."] = { pt = " repetições concluída." },
	["JANELA CENTRALIZADA"] = { pt = "JANELA CENTRALIZADA" },
	["SISTEMA ATIVO · V1.2"] = { pt = "SISTEMA ATIVO · V1.2" },
	["SISTEMA ATIVO · V1.2 · BY ONETIME.999"] = { pt = "SISTEMA ATIVO · V1.2 · BY ONETIME.999" },
	["ATIVAS "] = { pt = "ATIVAS " },
	[" · ATIVADO"] = { pt = " · ATIVADO" },
	[" · DESATIVADO"] = { pt = " · DESATIVADO" },
	["ATIVADO"] = { pt = "ATIVADO" },
	["DESATIVADO"] = { pt = "DESATIVADO" },
	["Character position is unavailable."] = { pt = "A posição do personagem não está disponível." },
	["PROGRESSO DO EXERCÍCIO"] = { pt = "PROGRESSO DO EXERCÍCIO" },
	["Automação do exercício"] = { pt = "Automação do exercício" },
	["Executa o exercício selecionado e acompanha o contador em tempo real."] = { pt = "Executa o exercício selecionado e acompanha o contador em tempo real." },
	["Intervalo das ações"] = { pt = "Intervalo das ações" },
	["Intervalo manual (segundos)"] = { pt = "Intervalo manual (segundos)" },
	["Define a pausa entre cada ação. Valores menores aceleram a execução."] = { pt = "Define a pausa entre cada ação. Valores menores aceleram a execução." },
	["Encerra a automação ao atingir o total definido. Use 0 para não impor um limite."] = { pt = "Encerra a automação ao atingir o total definido. Use 0 para não impor um limite." },
	["Exercício selecionado: "] = { pt = "Exercício selecionado: " },
	["Cor de destaque"] = { pt = "Cor de destaque" },
	["Tecla para ocultar"] = { pt = "Tecla para ocultar" },
	["ESCOLHA UM EXERCÍCIO"] = { pt = "ESCOLHA UM EXERCÍCIO" },
	["COR DE DESTAQUE"] = { pt = "COR DE DESTAQUE" },
	["ZERAR PROGRESSO"] = { pt = "ZERAR PROGRESSO" },
	["Não foi possível iniciar: o evento do exercício não está disponível."] = { pt = "Não foi possível iniciar: o evento do exercício não está disponível." },
	["Não foi possível iniciar o exercício selecionado."] = { pt = "Não foi possível iniciar o exercício selecionado." },
	["Aguardando o contador iniciar…"] = { pt = "Aguardando o contador iniciar…" },
	["Contador sincronizado. Automação iniciada."] = { pt = "Contador sincronizado. Automação iniciada." },
	["Automação do exercício desativada."] = { pt = "Automação do exercício desativada." },
	["Progresso zerado."] = { pt = "Progresso zerado." },
	["Intervalo definido: "] = { pt = "Intervalo definido: " },
	["Limite definido: "] = { pt = "Limite definido: " },
	["SEM LIMITE"] = { pt = "SEM LIMITE" },
	["TOQUE EM [N] OU USE 3 DEDOS · MOSTRAR/OCULTAR"] = { pt = "TOQUE EM [N] OU USE 3 DEDOS · MOSTRAR/OCULTAR" },
	["TECLA N OU ATALHO · MOSTRAR/OCULTAR"] = { pt = "TECLA N OU ATALHO · MOSTRAR/OCULTAR" },
	["TOQUE EM UMA ROTA PARA ALTERNAR"] = { pt = "TOQUE EM UMA ROTA PARA ALTERNAR" },
	["TECLAS 1–4 · ALTERNAR ROTAS"] = { pt = "TECLAS 1–4 · ALTERNAR ROTAS" },
	["ARRASTE A BARRA SUPERIOR PARA MOVER"] = { pt = "ARRASTE A BARRA SUPERIOR PARA MOVER" },
	["NEXUS HUB · V1.2"] = { pt = "NEXUS HUB · V1.2" },
	["// PLAYER DATA"] = { pt = "// DADOS DO JOGADOR" },
}

local function translate(value)
	if type(value) ~= "string" then return value end
	local entry = Localization[value]
	return entry and entry.pt or value
end

local function connect(signal, callback)
	local connection = signal:Connect(callback)
	table.insert(connections, connection)
	return connection
end

local function create(className, properties, children)
	local instance = Instance.new(className)
	local parent = nil
	if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
		instance.AutoLocalize = false
	end

	for property, value in pairs(properties or {}) do
		if property == "Parent" then
			parent = value
		else
			if property == "Text" and type(value) == "string" then
				instance[property] = translate(value)
				instance:SetAttribute("NexusTextKey", value)
			else
				instance[property] = value
			end
		end
	end

	for _, child in ipairs(children or {}) do
		child.Parent = instance
	end

	if parent then
		instance.Parent = parent
	end

	return instance
end

local function tween(instance, duration, goal, style, direction)
	local animation = TweenService:Create(
		instance,
		TweenInfo.new(duration, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out),
		goal
	)
	animation:Play()
	return animation
end

local function corner(radius)
	return create("UICorner", { CornerRadius = UDim.new(0, radius) })
end

local function circle()
	return create("UICorner", { CornerRadius = UDim.new(1, 0) })
end

local function stroke(parent, color, transparency)
	return create("UIStroke", {
		Color = color or Theme.Stroke,
		Thickness = 1,
		Transparency = transparency or 0.2,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent,
	})
end

local function textLabel(properties)
	local defaults = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoLocalize = false,
		Font = Theme.Body,
		TextColor3 = Theme.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
	}

	for property, value in pairs(properties) do
		defaults[property] = value
	end

	return create("TextLabel", defaults)
end

local function threeStops(first, second, third)
	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, first),
		ColorSequenceKeypoint.new(0.5, second),
		ColorSequenceKeypoint.new(1, third),
	})
end

local function accentAlt()
	local hue, saturation, value = Theme.Accent:ToHSV()
	return Color3.fromHSV((hue + 0.14) % 1, saturation, value)
end

local function bindAccent(callback)
	table.insert(accentListeners, callback)
	callback()
end

local function setAccent(color)
	Theme.Accent = color
	for _, callback in ipairs(accentListeners) do
		callback()
	end
end

local function fadeGradient(rotation)
	local gradient = create("UIGradient", {
		Rotation = rotation or 0,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.5, 0.15),
			NumberSequenceKeypoint.new(1, 1),
		}),
	})
	bindAccent(function()
		gradient.Color = threeStops(Theme.Accent, accentAlt(), Theme.Accent)
	end)
	return gradient
end

local function lockLocalization(root)
	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
			descendant.AutoLocalize = false
		end
	end
end

local screenGui = create("ScreenGui", {
	Name = GUI_NAME,
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 999,
})

local camera = Workspace.CurrentCamera

local function viewportSize()
	return camera and camera.ViewportSize or Vector2.new(1280, 720)
end

local function fitScale()
	local viewport = viewportSize()
	return math.min(1, (viewport.X * 0.94) / WIDTH, (viewport.Y * 0.9) / HEIGHT)
end

local function targetScale()
	return fitScale() * multiplier
end

local function centeredPosition()
	return UDim2.new(0.5, 0, 0.5, -HEIGHT * targetScale() / 2)
end

local blurEffect = create("BlurEffect", {
	Name = "NexusHubBlur",
	Size = 0,
	Parent = Lighting,
})

local function updateBlur()
	local enabled = Settings.Blur and not Settings.PerformanceMode and visible and not closing
	tween(blurEffect, 0.4, { Size = enabled and BLUR_SIZE or 0 }, Enum.EasingStyle.Quad)
end

connect(UserInputService.InputBegan, function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		pointer = Vector2.new(input.Position.X, input.Position.Y) + GuiService:GetGuiInset()
	elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
		pointer = UserInputService:GetMouseLocation()
	end
end)

local holder = create("Frame", {
	Name = "Holder",
	AnchorPoint = Vector2.new(0.5, 0),
	Position = centeredPosition(),
	Size = UDim2.fromOffset(WIDTH, HEIGHT),
	BackgroundTransparency = 1,
	Parent = screenGui,
})

local scale = create("UIScale", { Scale = targetScale(), Parent = holder })

local glowLayers = {}
for index = 1, 4 do
	local layer = create("Frame", {
		Name = "Glow" .. index,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, index * 12, 1, index * 12),
		BackgroundColor3 = Theme.Accent,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 0,
		Parent = holder,
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 14 + index * 6) }),
	})
	table.insert(glowLayers, { Frame = layer, Base = 0.86 + index * 0.03 })
end

bindAccent(function()
	for _, layer in ipairs(glowLayers) do
		layer.Frame.BackgroundColor3 = Theme.Accent
	end
end)

local main = create("CanvasGroup", {
	Name = "Main",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Theme.Background,
	BorderSizePixel = 0,
	GroupTransparency = 0,
	Parent = holder,
}, { corner(14) })

local borderStroke = create("UIStroke", {
	Color = Color3.new(1, 1, 1),
	Thickness = 1.6,
	ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	Parent = main,
})

local borderGradient = create("UIGradient", { Parent = borderStroke })

bindAccent(function()
	borderGradient.Color = threeStops(Theme.Accent, accentAlt(), Theme.Accent)
end)

local backdrop = create("Frame", {
	Name = "Backdrop",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Color3.new(1, 1, 1),
	BorderSizePixel = 0,
	ZIndex = 1,
	Parent = main,
})

local backdropGradient = create("UIGradient", { Rotation = 135, Parent = backdrop })

local gridLines = {}

for column = 1, math.floor(WIDTH / 40) do
	table.insert(
		gridLines,
		create("Frame", {
			Position = UDim2.fromOffset(column * 40, 0),
			Size = UDim2.new(0, 1, 1, 0),
			BackgroundColor3 = Theme.Accent,
			BackgroundTransparency = 0.95,
			BorderSizePixel = 0,
			Parent = backdrop,
		})
	)
end

for row = 1, math.floor(HEIGHT / 40) do
	table.insert(
		gridLines,
		create("Frame", {
			Position = UDim2.fromOffset(0, row * 40),
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = Theme.Accent,
			BackgroundTransparency = 0.95,
			BorderSizePixel = 0,
			Parent = backdrop,
		})
	)
end

bindAccent(function()
	backdropGradient.Color = ColorSequence.new(Theme.Background, Theme.Background:Lerp(Theme.Accent, 0.1))
	for _, line in ipairs(gridLines) do
		line.BackgroundColor3 = Theme.Accent
	end
end)

local particleLayer = create("Frame", {
	Name = "Partículas de fundo",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	ClipsDescendants = true,
	ZIndex = 2,
	Parent = main,
})

local scanline = create("Frame", {
	Name = "Linhas de varredura",
	Size = UDim2.new(1, 0, 0, 2),
	BackgroundColor3 = Theme.Accent,
	BackgroundTransparency = 0.8,
	BorderSizePixel = 0,
	Visible = Settings.Scanline,
	ZIndex = 3,
	Parent = main,
}, {
	create("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.5, 0),
			NumberSequenceKeypoint.new(1, 1),
		}),
	}),
})

bindAccent(function()
	scanline.BackgroundColor3 = Theme.Accent
end)

local function showToast(text, color)
	text = translate(text)
	if minimized or closing or not alive then
		return
	end

	if toastFrame then
		toastFrame:Destroy()
		toastFrame = nil
	end

	local centerX = SIDEBAR + (WIDTH - SIDEBAR) / 2

	local toast = create("Frame", {
		Name = "Toast",
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0, centerX, 1, 40),
		Size = UDim2.fromOffset(240, 28),
		BackgroundColor3 = Theme.Panel,
		BorderSizePixel = 0,
		ZIndex = 30,
		Parent = main,
	}, { corner(8) })

	stroke(toast, color, 0.15)

	create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 11, 0.5, 0),
		Size = UDim2.fromOffset(6, 6),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		ZIndex = 31,
		Parent = toast,
	}, { circle() })

	textLabel({
		Position = UDim2.fromOffset(26, 0),
		Size = UDim2.new(1, -32, 1, 0),
		Text = text,
		Font = Theme.Title,
		TextSize = 10,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 31,
		Parent = toast,
	})

	toastFrame = toast
	tween(toast, 0.4, { Position = UDim2.new(0, centerX, 1, -12) }, Enum.EasingStyle.Back)

	task.delay(2.2, function()
		if toastFrame ~= toast or not alive then
			return
		end

		local hide = tween(
			toast,
			0.3,
			{ Position = UDim2.new(0, centerX, 1, 40) },
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.In
		)
		hide.Completed:Connect(function()
			if toastFrame == toast then
				toastFrame = nil
			end
			toast:Destroy()
		end)
	end)
end

local topBar = create("Frame", {
	Name = "TopBar",
	Size = UDim2.new(1, 0, 0, HEADER),
	BackgroundColor3 = Theme.Panel,
	BackgroundTransparency = 0.25,
	BorderSizePixel = 0,
	ZIndex = 4,
	Parent = main,
})

create("Frame", {
	Name = "Line",
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.fromScale(0, 1),
	Size = UDim2.new(1, 0, 0, 1),
	BackgroundColor3 = Color3.new(1, 1, 1),
	BorderSizePixel = 0,
	ZIndex = 5,
	Parent = topBar,
}, { fadeGradient() })

local statusRing = create("Frame", {
	Name = "StatusRing",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0, 18, 0.5, 0),
	Size = UDim2.fromOffset(9, 9),
	BackgroundTransparency = 1,
	ZIndex = 5,
	Parent = topBar,
}, { circle() })

local statusRingStroke = create("UIStroke", {
	Color = Theme.Success,
	Thickness = 1,
	Parent = statusRing,
})

local statusOrb = create("Frame", {
	Name = "StatusOrb",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0, 18, 0.5, 0),
	Size = UDim2.fromOffset(9, 9),
	BackgroundColor3 = Theme.Success,
	BorderSizePixel = 0,
	ZIndex = 6,
	Parent = topBar,
}, { circle() })

local titleLabel = textLabel({
	Name = "Title",
	Position = UDim2.fromOffset(36, 5),
	Size = UDim2.new(1, -120, 0, 18),
	Font = Theme.Title,
	RichText = true,
	TextSize = 15,
	ZIndex = 5,
	Parent = topBar,
})

bindAccent(function()
	titleLabel.Text = string.format('NEXUS <font color="#%s">HUB</font>', Theme.Accent:ToHex())
end)

local subtitleLabel = textLabel({
	Name = "Subtitle",
	Position = UDim2.fromOffset(36, 23),
	Size = UDim2.new(1, -120, 0, 12),
	Text = STATUS_TEXT,
	Font = Theme.Mono,
	TextColor3 = Theme.TextDim,
	TextSize = 9,
	ZIndex = 5,
	Parent = topBar,
})

local function createBar(parent, width, rotation)
	return create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(width, 2),
		Rotation = rotation,
		BackgroundColor3 = Theme.TextDim,
		BorderSizePixel = 0,
		ZIndex = 7,
		Parent = parent,
	}, { circle() })
end

local function createControlButton(name, xOffset)
	return create("TextButton", {
		Name = name,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, xOffset, 0.5, 0),
		Size = UDim2.fromOffset(CONTROL_SIZE, CONTROL_SIZE),
		BackgroundColor3 = Theme.CardHover,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		ZIndex = 6,
		Parent = topBar,
	}, { corner(7) })
end

local function bindControlHover(button, hoverColor, icons)
	connect(button.MouseEnter, function()
		tween(button, 0.2, { BackgroundColor3 = hoverColor, BackgroundTransparency = 0.2 })
		for _, icon in ipairs(icons) do
			if icon:IsA("UIStroke") then
				tween(icon, 0.2, { Color = Theme.Text })
			else
				tween(icon, 0.2, { BackgroundColor3 = Theme.Text })
			end
		end
	end)

	connect(button.MouseLeave, function()
		tween(button, 0.2, { BackgroundTransparency = 1 })
		for _, icon in ipairs(icons) do
			if icon:IsA("UIStroke") then
				tween(icon, 0.2, { Color = Theme.TextDim })
			else
				tween(icon, 0.2, { BackgroundColor3 = Theme.TextDim })
			end
		end
	end)
end

local closeButton = createControlButton("Close", -10)
local closeBarA = createBar(closeButton, 13, 45)
local closeBarB = createBar(closeButton, 13, -45)
bindControlHover(closeButton, Color3.fromRGB(255, 70, 100), { closeBarA, closeBarB })

local minimizeButton = createControlButton("Minimize", -(CONTROL_SIZE + 16))
local minimizeBar = createBar(minimizeButton, 11, 0)
local restoreBox = create("Frame", {
	Name = "RestoreIcon",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(10, 10),
	BackgroundTransparency = 1,
	Visible = false,
	ZIndex = 7,
	Parent = minimizeButton,
}, { corner(2) })
local restoreStroke = create("UIStroke", {
	Color = Theme.TextDim,
	Thickness = 2,
	Parent = restoreBox,
})
bindControlHover(minimizeButton, Theme.CardHover, { minimizeBar, restoreStroke })

local body = create("Frame", {
	Name = "Body",
	Position = UDim2.fromOffset(0, HEADER),
	Size = UDim2.new(1, 0, 1, -HEADER),
	BackgroundTransparency = 1,
	ZIndex = 4,
	Parent = main,
})

local sidebar = create("Frame", {
	Name = "Sidebar",
	Size = UDim2.new(0, SIDEBAR, 1, 0),
	BackgroundColor3 = Theme.Panel,
	BackgroundTransparency = 0.45,
	BorderSizePixel = 0,
	ZIndex = 4,
	Parent = body,
})

create("Frame", {
	Name = "Line",
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.fromScale(1, 0),
	Size = UDim2.new(0, 1, 1, 0),
	BackgroundColor3 = Color3.new(1, 1, 1),
	BorderSizePixel = 0,
	ZIndex = 5,
	Parent = sidebar,
}, { fadeGradient(90) })

local tabArea = create("ScrollingFrame", {
	Name = "TabArea",
	Size = UDim2.new(1, 0, 1, -(FOOTER_HEIGHT + 4)),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = IS_TOUCH and 4 or 3,
	ScrollBarImageTransparency = 0.15,
	AutomaticCanvasSize = Enum.AutomaticSize.None,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	CanvasPosition = Vector2.new(0, 0),
	ScrollingDirection = Enum.ScrollingDirection.Y,
	ScrollingEnabled = true,
	ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
	Active = true,
	Selectable = false,
	ZIndex = 5,
	Parent = sidebar,
})

local tabIndicator = create("Frame", {
	Name = "Indicator",
	Position = UDim2.fromOffset(8, TAB_TOP),
	Size = UDim2.new(1, -16, 0, TAB_HEIGHT),
	BackgroundColor3 = Theme.Card,
	BorderSizePixel = 0,
	ZIndex = 5,
	Parent = tabArea,
}, { corner(8) })

local tabIndicatorBar = create("Frame", {
	Name = "Bar",
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 5, 0.5, 0),
	Size = UDim2.fromOffset(3, 16),
	BackgroundColor3 = Theme.Accent,
	BorderSizePixel = 0,
	ZIndex = 6,
	Parent = tabIndicator,
}, { circle() })

bindAccent(function()
	tabIndicator.BackgroundColor3 = Theme.Card:Lerp(Theme.Accent, 0.22)
	tabIndicatorBar.BackgroundColor3 = Theme.Accent
	tabArea.ScrollBarImageColor3 = Theme.Accent
end)

local tabLayout = create("UIListLayout", {
	Padding = UDim.new(0, TAB_GAP),
	SortOrder = Enum.SortOrder.LayoutOrder,
})

local tabList = create("Frame", {
	Name = "Tabs",
	Size = UDim2.new(1, -6, 0, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundTransparency = 1,
	ZIndex = 6,
	Parent = tabArea,
}, {
	create("UIPadding", {
		PaddingTop = UDim.new(0, TAB_TOP),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		PaddingBottom = UDim.new(0, 8),
	}),
	tabLayout,
})

-- Canvas calculado manualmente: não depende do AutomaticCanvasSize do executor.
local function refreshTabCanvas()
	local contentHeight = math.max(tabList.AbsoluteSize.Y, tabLayout.AbsoluteContentSize.Y + TAB_TOP + 8)
	tabArea.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
	local maxY = math.max(0, contentHeight - tabArea.AbsoluteWindowSize.Y)
	if tabArea.CanvasPosition.Y > maxY then
		tabArea.CanvasPosition = Vector2.new(0, maxY)
	end
end

connect(tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"), refreshTabCanvas)
connect(tabList:GetPropertyChangedSignal("AbsoluteSize"), refreshTabCanvas)
connect(tabArea:GetPropertyChangedSignal("AbsoluteWindowSize"), refreshTabCanvas)

-- Arraste manual por toque para que deslizar sobre um botão também role a lista.
local activeTabTouch = nil
local tabTouchStartY = 0
local tabTouchStartCanvasY = 0
local tabTouchMoved = false
local suppressTabClickUntil = 0

local function beginTabTouch(input)
	if input.UserInputType ~= Enum.UserInputType.Touch then return end
	activeTabTouch = input
	tabTouchStartY = input.Position.Y
	tabTouchStartCanvasY = tabArea.CanvasPosition.Y
	tabTouchMoved = false
end

local function finishTabTouch(input)
	if activeTabTouch ~= input then return end
	if tabTouchMoved then
		suppressTabClickUntil = os.clock() + 0.3
	end
	activeTabTouch = nil
	tabTouchMoved = false
end

connect(tabArea.InputBegan, beginTabTouch)
connect(UserInputService.InputChanged, function(input)
	if activeTabTouch and input == activeTabTouch then
		local deltaY = input.Position.Y - tabTouchStartY
		if math.abs(deltaY) >= 5 then
			tabTouchMoved = true
		end
		if tabTouchMoved then
			local maxY = math.max(0, tabArea.CanvasSize.Y.Offset - tabArea.AbsoluteWindowSize.Y)
			local nextY = math.clamp(tabTouchStartCanvasY - deltaY, 0, maxY)
			tabArea.CanvasPosition = Vector2.new(0, nextY)
		end
	end
end)
connect(UserInputService.InputEnded, finishTabTouch)

local sidebarFooter = create("Frame", {
	Name = "Footer",
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.fromScale(0, 1),
	Size = UDim2.new(1, 0, 0, FOOTER_HEIGHT),
	BackgroundTransparency = 1,
	ZIndex = 5,
	Parent = sidebar,
})

create("Frame", {
	Name = "Line",
	Size = UDim2.new(1, -1, 0, 1),
	BackgroundColor3 = Color3.new(1, 1, 1),
	BorderSizePixel = 0,
	ZIndex = 6,
	Parent = sidebarFooter,
}, { fadeGradient() })

local userCard = create("Frame", {
	Name = "UserCard",
	Position = UDim2.fromOffset(10, 8),
	Size = UDim2.new(1, -20, 0, 28),
	BackgroundTransparency = 1,
	ZIndex = 6,
	Parent = sidebarFooter,
})

local avatar = create("ImageLabel", {
	Name = "Avatar",
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.fromScale(0, 0.5),
	Size = UDim2.fromOffset(26, 26),
	BackgroundColor3 = Theme.Card,
	BorderSizePixel = 0,
	Image = "",
	ZIndex = 7,
	Parent = userCard,
}, { circle() })

local avatarStroke = stroke(avatar, Theme.Accent, 0.1)

bindAccent(function()
	avatarStroke.Color = Theme.Accent
end)

textLabel({
	Name = "DisplayName",
	Position = UDim2.fromOffset(33, 1),
	Size = UDim2.new(1, -33, 0, 13),
	Text = LocalPlayer.DisplayName,
	Font = Theme.Title,
	TextSize = 10,
	TextTruncate = Enum.TextTruncate.AtEnd,
	ZIndex = 7,
	Parent = userCard,
})

textLabel({
	Name = "UserName",
	Position = UDim2.fromOffset(33, 14),
	Size = UDim2.new(1, -33, 0, 11),
	Text = "@" .. LocalPlayer.Name,
	Font = Theme.Mono,
	TextColor3 = Theme.TextDim,
	TextSize = 8,
	TextTruncate = Enum.TextTruncate.AtEnd,
	ZIndex = 7,
	Parent = userCard,
})

task.spawn(function()
	local success, content = pcall(function()
		return Players:GetUserThumbnailAsync(
			LocalPlayer.UserId,
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size48x48
		)
	end)
	if success and alive then
		avatar.Image = content
	end
end)

local counterLabel = textLabel({
	Name = "Counter",
	Position = UDim2.fromOffset(12, 44),
	Size = UDim2.new(1, -16, 0, 12),
	Text = "ROTAS ATIVAS  0/" .. #ModuleOrder,
	Font = Theme.Mono,
	TextColor3 = Theme.TextDim,
	TextSize = 10,
	ZIndex = 6,
	Parent = sidebarFooter,
})

local statsLabel = textLabel({
	Name = "Stats",
	Position = UDim2.fromOffset(12, 57),
	Size = UDim2.new(1, -16, 0, 12),
	Text = "-- FPS  |  -- MS",
	Font = Theme.Mono,
	TextColor3 = Theme.TextDim,
	TextSize = 10,
	ZIndex = 6,
	Parent = sidebarFooter,
})

local hintPrimary = textLabel({
	Name = "HintPrimary",
	Position = UDim2.fromOffset(12, 71),
	Size = UDim2.new(1, -16, 0, 11),
	Font = Theme.Mono,
	TextColor3 = Theme.TextDim,
	TextSize = 9,
	TextTransparency = 0.3,
	ZIndex = 6,
	Parent = sidebarFooter,
})

local hintSecondary = textLabel({
	Name = "HintSecondary",
	Position = UDim2.fromOffset(12, 83),
	Size = UDim2.new(1, -16, 0, 11),
	Font = Theme.Mono,
	TextColor3 = Theme.TextDim,
	TextSize = 9,
	TextTransparency = 0.3,
	ZIndex = 6,
	Parent = sidebarFooter,
})

local function refreshHints()
	local touchMode = IS_TOUCH or UserInputService:GetLastInputType() == Enum.UserInputType.Touch

	if touchMode then
		hintPrimary.Text = Settings.Gesture and "3 DEDOS · OCULTAR" or "TOQUE EM [N] · OCULTAR"
		hintSecondary.Text = "DEV · ONETIME.999"
	else
		hintPrimary.Text = (toggleKey.Name:upper():gsub("CONTROL", "CTRL")) .. " · OCULTAR"
		hintSecondary.Text = "DEV · ONETIME.999"
	end
end
refreshHints()
connect(UserInputService.LastInputTypeChanged, refreshHints)

local pageHolder = create("Frame", {
	Name = "Pages",
	Position = UDim2.fromOffset(SIDEBAR, 0),
	Size = UDim2.new(1, -SIDEBAR, 1, 0),
	BackgroundTransparency = 1,
	ClipsDescendants = true,
	ZIndex = 4,
	Parent = body,
}, {
	create("UIPadding", {
		PaddingTop = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 8),
		PaddingBottom = UDim.new(0, 8),
	}),
})

local function ripple(target)
	local factor = scale.Scale
	local origin = (pointer - target.AbsolutePosition) / factor
	local diameter = math.max(target.AbsoluteSize.X, target.AbsoluteSize.Y) * 2 / factor

	local wave = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromOffset(origin.X, origin.Y),
		Size = UDim2.fromOffset(0, 0),
		BackgroundColor3 = Theme.Accent,
		BackgroundTransparency = 0.65,
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = target,
	}, { circle() })

	tween(wave, 0.6, { Size = UDim2.fromOffset(diameter, diameter), BackgroundTransparency = 1 }).Completed
		:Connect(function()
			wave:Destroy()
		end)
end

local function createPage(name, title)
	local container = create("CanvasGroup", {
		Name = name,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		GroupTransparency = 1,
		Visible = false,
		ZIndex = 4,
		Parent = pageHolder,
	})

	local header = create("Frame", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, PAGE_HEADER),
		BackgroundTransparency = 1,
		ZIndex = 4,
		Parent = container,
	})

	local pageIconData = {
		PARKOUR = { Image = "rbxassetid://6034687957", Fallback = "◇" },
		MINIGAME = { Image = "rbxassetid://6034754445", Fallback = "✦" },
		["AUTO INTERACT"] = { Image = "rbxassetid://6034754445", Fallback = "◎" },
		["COLETÁVEIS"] = { Image = "rbxassetid://6034754445", Fallback = "◆" },
		AJUSTES = { Image = "rbxassetid://6031280882", Fallback = "⚙" },
	}
	local pageIconInfo = pageIconData[name]
	if pageIconInfo then
		local pageIcon = create("ImageLabel", {
			Name = "PageIcon",
			Position = UDim2.fromOffset(1, math.floor((PAGE_HEADER - 15) / 2)),
			Size = UDim2.fromOffset(15, 15),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = pageIconInfo.Image,
			ImageColor3 = Theme.Accent,
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = 6,
			Parent = header,
		})
		bindAccent(function() pageIcon.ImageColor3 = Theme.Accent end)
	end

	textLabel({
		Name = "Title",
		Position = UDim2.fromOffset(pageIconInfo and 22 or 0, 0),
		Size = UDim2.new(name == "PARKOUR" and 0.42 or (name == "MINIGAME" and 0.58 or 0.78), pageIconInfo and -22 or 0, 1, 0),
		Text = title,
		Font = Theme.Mono,
		TextColor3 = Theme.TextDim,
		TextSize = 10,
		ZIndex = 4,
		Parent = header,
	})

	local scroll = create("ScrollingFrame", {
		Name = "Scroll",
		Position = UDim2.fromOffset(0, PAGE_HEADER + 6),
		Size = UDim2.new(1, 0, 1, -(PAGE_HEADER + 6)),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ZIndex = 4,
		Parent = container,
	}, {
		create("UIListLayout", {
			Padding = UDim.new(0, LIST_GAP),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		create("UIPadding", {
			PaddingTop = UDim.new(0, 2),
			PaddingLeft = UDim.new(0, 2),
			PaddingRight = UDim.new(0, 8),
			PaddingBottom = UDim.new(0, 6),
		}),
	})

	bindAccent(function()
		scroll.ScrollBarImageColor3 = Theme.Accent
	end)

	return { Container = container, Header = header, Scroll = scroll }
end

local function sectionLabel(parent, order, text)
	local container = create("Frame", {
		Name = text,
		LayoutOrder = order,
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		ZIndex = 4,
		Parent = parent,
	})

	textLabel({
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, 14),
		Text = text,
		Font = Theme.Mono,
		TextColor3 = Theme.TextDim,
		TextSize = IS_TOUCH and 11 or 10,
		ZIndex = 4,
		Parent = container,
	})

	return container
end

local function createSwitchRow(parent, order, title, description, height, initial, onChanged, routeSegments)
	local state = false
	local hasDescription = description ~= nil and description ~= ""
	local minRowHeight = IS_TOUCH and 86 or 82
	local rowHeight = hasDescription and math.max(height, minRowHeight) or height

	local row = create("Frame", {
		Name = title,
		LayoutOrder = order,
		Size = UDim2.new(1, 0, 0, rowHeight),
		BackgroundColor3 = Theme.Card,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 4,
		Parent = parent,
	}, { corner(8) })

	local rowStroke = stroke(row)

	local sheen = create("Frame", {
		Name = "Sheen",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 1,
		Parent = row,
	}, { corner(8) })

	local sheenGradient = create("UIGradient", {
		Rotation = 20,
		Offset = Vector2.new(-1, 0),
		Parent = sheen,
	})

	TweenService:Create(
		sheenGradient,
		TweenInfo.new(2.6, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, false),
		{ Offset = Vector2.new(1, 0) }
	):Play()

	local bar = create("Frame", {
		Name = "Bar",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.fromOffset(3, 0),
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		ZIndex = 3,
		Parent = row,
	}, { circle() })

	textLabel({
		Name = "Name",
		Position = UDim2.fromOffset(14, hasDescription and 7 or 0),
		Size = UDim2.new(1, -148, 0, hasDescription and 19 or rowHeight),
		Text = title,
		Font = Theme.Title,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 3,
		Parent = row,
	})

	if hasDescription then
		textLabel({
			Name = "Description",
			Position = UDim2.fromOffset(14, 30),
			Size = UDim2.new(1, -148, 0, rowHeight - 36),
			Text = description,
			Font = Theme.Body,
			TextColor3 = Theme.TextDim,
			TextSize = IS_TOUCH and 10 or 10,
			TextWrapped = true,
			TextYAlignment = Enum.TextYAlignment.Top,
			ZIndex = 3,
			Parent = row,
		})
	end

	local routeBars = {}
	local routeLabel = nil
	local routeMarker = nil
	local routeMotionTween = nil
	local routeStartPosition = UDim2.new(0, 4, 0.5, 0)

	if routeSegments then
		local segmentCount = math.clamp(math.floor(routeSegments), 1, 13)
		routeLabel = textLabel({
			Name = "RouteLabel",
			Position = UDim2.fromOffset(14, rowHeight - 27),
			Size = UDim2.new(0.55, -14, 0, 9),
			Text = string.format("TRAJETO  ·  %d %s", segmentCount, segmentCount == 1 and "TRECHO" or "TRECHOS"),
			Font = Theme.Mono,
			TextColor3 = Theme.TextDim,
			TextSize = 7,
			TextTruncate = Enum.TextTruncate.AtEnd,
			ZIndex = 4,
			Parent = row,
		})

		local routeTrack = create("Frame", {
			Name = "RouteTrack",
			Position = UDim2.new(0, 14, 0, rowHeight - 14),
			Size = UDim2.new(0.55, -14, 0, 4),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			ZIndex = 4,
			Parent = row,
		})
		local routeSegmentsHolder = create("Frame", {
			Name = "RouteSegments",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 4,
			Parent = routeTrack,
		}, {
			create("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 3),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
		})

		local segmentOffset = -((segmentCount - 1) * 3 / segmentCount)
		for segmentIndex = 1, segmentCount do
			local segmentBar = create("Frame", {
				Name = "RouteSegment" .. segmentIndex,
				LayoutOrder = segmentIndex,
				Size = UDim2.new(1 / segmentCount, segmentOffset, 1, 0),
				BackgroundColor3 = Theme.Track,
				BackgroundTransparency = 0.05,
				BorderSizePixel = 0,
				ZIndex = 4,
				Parent = routeSegmentsHolder,
			}, { corner(2) })
			table.insert(routeBars, segmentBar)
		end

		routeMarker = create("Frame", {
			Name = "RouteMarker",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = routeStartPosition,
			Size = UDim2.fromOffset(7, 7),
			BackgroundColor3 = Theme.TextDim,
			BackgroundTransparency = 0.12,
			BorderSizePixel = 0,
			ZIndex = 6,
			Parent = routeTrack,
		}, { circle() })
		local routeMarkerStroke = stroke(routeMarker, Theme.Accent, 0.15)
		routeMotionTween = TweenService:Create(
			routeMarker,
			TweenInfo.new(1.35, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
			{ Position = UDim2.new(1, -4, 0.5, 0) }
		)

		bindAccent(function()
			routeLabel.TextColor3 = state and Theme.Accent or Theme.TextDim
			routeMarker.BackgroundColor3 = state and Theme.Accent or Theme.TextDim
			routeMarkerStroke.Color = Theme.Accent
			for _, segmentBar in ipairs(routeBars) do
				segmentBar.BackgroundColor3 = state and Theme.Accent or Theme.Track
			end
		end)
	end

	local stateLabel = textLabel({
		Name = "State",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -58, 0.5, 0),
		Size = UDim2.fromOffset(68, 16),
		Text = "DESATIVADO",
		Font = Theme.Body,
		TextColor3 = Theme.TextDim,
		TextSize = 9,
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 3,
		Parent = row,
	})

	local track = create("Frame", {
		Name = "Track",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(38, 20),
		BackgroundColor3 = Theme.Track,
		BorderSizePixel = 0,
		ZIndex = 3,
		Parent = row,
	}, { circle() })

	local knob = create("Frame", {
		Name = "Knob",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 3, 0.5, 0),
		Size = UDim2.fromOffset(14, 14),
		BackgroundColor3 = Theme.Text,
		BorderSizePixel = 0,
		ZIndex = 4,
		Parent = track,
	}, { circle() })

	local hit = create("TextButton", {
		Name = "Hit",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 6,
		Parent = row,
	})

	bindAccent(function()
		local base = Theme.Card:Lerp(Theme.Accent, 0.3)
		local bright = Theme.Card:Lerp(Theme.Accent, 0.58)
		sheenGradient.Color = threeStops(base, bright, base)
		bar.BackgroundColor3 = Theme.Accent
		if routeLabel then
			routeLabel.TextColor3 = state and Theme.Accent or Theme.TextDim
		end
		if routeMarker then
			routeMarker.BackgroundColor3 = state and Theme.Accent or Theme.TextDim
		end
		for _, segmentBar in ipairs(routeBars) do
			segmentBar.BackgroundColor3 = state and Theme.Accent or Theme.Track
		end
		if state then
			track.BackgroundColor3 = Theme.Accent
			rowStroke.Color = Theme.Accent
		end
	end)

	local function pulse()
		local ring = create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(1, -31, 0.5, 0),
			Size = UDim2.fromOffset(20, 20),
			BackgroundTransparency = 1,
			ZIndex = 3,
			Parent = row,
		}, { circle() })

		local ringStroke = create("UIStroke", {
			Color = Theme.Accent,
			Thickness = 2,
			Parent = ring,
		})

		tween(ring, 0.6, { Size = UDim2.fromOffset(70, 70) })
		tween(ringStroke, 0.6, { Transparency = 1 }).Completed:Connect(function()
			ring:Destroy()
		end)
	end

	local function apply(newState, silent)
		state = newState

		tween(sheen, 0.4, { BackgroundTransparency = state and 0 or 1 })
		tween(track, 0.3, { BackgroundColor3 = state and Theme.Accent or Theme.Track })
		tween(knob, 0.35, {
			Position = state and UDim2.new(0, 21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
		}, Enum.EasingStyle.Back)
		tween(bar, 0.35, { Size = UDim2.fromOffset(3, state and rowHeight * 0.55 or 0) })
		tween(rowStroke, 0.3, { Color = state and Theme.Accent or Theme.Stroke, Transparency = state and 0.35 or 0.2 })
		tween(stateLabel, 0.3, { TextColor3 = state and Theme.Text or Theme.TextDim })
		for _, segmentBar in ipairs(routeBars) do
			tween(segmentBar, 0.25, {
				BackgroundColor3 = state and Theme.Accent or Theme.Track,
				BackgroundTransparency = state and 0 or 0.05,
			})
		end
		if routeLabel then
			tween(routeLabel, 0.25, { TextColor3 = state and Theme.Accent or Theme.TextDim })
		end
		if routeMarker and routeMotionTween then
			if state then
				routeMarker.BackgroundTransparency = 0
				routeMotionTween:Play()
			else
				routeMotionTween:Cancel()
				routeMarker.Position = routeStartPosition
				routeMarker.BackgroundTransparency = 0.2
			end
		end
		local stateTextKey = state and "ATIVADO" or "DESATIVADO"
		stateLabel:SetAttribute("NexusTextKey", stateTextKey)
		stateLabel.Text = translate(stateTextKey)

		if state and not silent then
			pulse()
		end

		if not silent then
			onChanged(state)
		end
	end

	connect(hit.MouseEnter, function()
		tween(row, 0.25, { BackgroundColor3 = Theme.CardHover })
		if not state then
			tween(rowStroke, 0.25, { Transparency = 0 })
		end
	end)

	connect(hit.MouseLeave, function()
		tween(row, 0.25, { BackgroundColor3 = Theme.Card })
		if not state then
			tween(rowStroke, 0.25, { Transparency = 0.2 })
		end
	end)

	connect(hit.MouseButton1Click, function()
		ripple(row)
		apply(not state)
	end)

	if initial then
		apply(true, true)
	end

	return {
		Set = function(value, silent)
			if value ~= state then
				apply(value, silent)
			end
		end,
		Get = function()
			return state
		end,
	}
end

local function createNumberInputRow(parent, order, title, description, initialValue, onCommit)
	local rowHeight = description and description ~= "" and (IS_TOUCH and 82 or 76) or ROW_HEIGHT
	local row = create("Frame", {
		Name = title,
		LayoutOrder = order,
		Size = UDim2.new(1, 0, 0, rowHeight),
		BackgroundColor3 = Theme.Card,
		BorderSizePixel = 0,
		ZIndex = 4,
		Parent = parent,
	}, { corner(8) })

	local rowStroke = stroke(row)

	textLabel({
		Name = "Name",
		Position = UDim2.fromOffset(14, 7),
		Size = UDim2.new(1, -110, 0, 19),
		Text = title,
		Font = Theme.Title,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 5,
		Parent = row,
	})

	textLabel({
		Name = "Description",
		Position = UDim2.fromOffset(14, 30),
		Size = UDim2.new(1, -110, 0, rowHeight - 35),
		Text = description,
		Font = Theme.Body,
		TextColor3 = Theme.TextDim,
		TextSize = 10,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		ZIndex = 5,
		Parent = row,
	})

	local boxHolder = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(72, 26),
		BackgroundColor3 = Theme.Panel,
		BorderSizePixel = 0,
		ZIndex = 5,
		Parent = row,
	}, { corner(6) })

	local boxStroke = stroke(boxHolder, Theme.Stroke, 0.2)

	local inputBox = create("TextBox", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = tostring(initialValue),
		PlaceholderText = "0",
		Font = Theme.Mono,
		TextSize = 11,
		TextColor3 = Theme.Accent,
		ClearTextOnFocus = false,
		ZIndex = 6,
		Parent = boxHolder,
	})

	bindAccent(function()
		inputBox.TextColor3 = Theme.Accent
	end)

	connect(inputBox.Focused, function()
		tween(boxStroke, 0.2, { Color = Theme.Accent, Transparency = 0 })
		tween(rowStroke, 0.2, { Color = Theme.Accent, Transparency = 0.35 })
	end)

	connect(inputBox.FocusLost, function()
		tween(boxStroke, 0.2, { Color = Theme.Stroke, Transparency = 0.2 })
		tween(rowStroke, 0.2, { Color = Theme.Stroke, Transparency = 0.2 })

		local num = tonumber(inputBox.Text)
		if num then
			local validated = onCommit(num)
			inputBox.Text = tostring(validated)
		else
			inputBox.Text = tostring(initialValue)
		end
	end)

	return {
		Row = row,
		SetValue = function(val)
			initialValue = val
			inputBox.Text = tostring(val)
		end,
	}
end

local function createButton(parent, order, text, primary, size, onClick, iconAsset, fallbackGlyph)
	local button = create("TextButton", {
		Name = text,
		LayoutOrder = order,
		Size = size,
		BackgroundColor3 = Theme.Card,
		AutoButtonColor = false,
		Text = text,
		TextXAlignment = iconAsset and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
		Font = Theme.Title,
		TextSize = 11,
		TextColor3 = Theme.TextDim,
		ClipsDescendants = true,
		ZIndex = 4,
		Parent = parent,
	}, { corner(8) })

	local buttonStroke = stroke(button)
	local iconFallback
	local iconImage
	if iconAsset then
		local iconY = math.max(0, math.floor(((size.Y.Offset > 0 and size.Y.Offset or 30) - 16) / 2))
		create("UIPadding", {
			PaddingLeft = UDim.new(0, 34),
			Parent = button,
		})
		iconFallback = textLabel({
			Name = "IconFallback",
			Position = UDim2.fromOffset(10, iconY - 1),
			Size = UDim2.fromOffset(18, 18),
			Text = fallbackGlyph or "✦",
			Font = Theme.Title,
			TextSize = 13,
			TextColor3 = primary and Theme.Accent or Theme.TextDim,
			TextXAlignment = Enum.TextXAlignment.Center,
			ZIndex = 5,
			Parent = button,
		})
		iconImage = create("ImageLabel", {
			Name = "Icon",
			Position = UDim2.fromOffset(11, iconY),
			Size = UDim2.fromOffset(16, 16),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = iconAsset,
			ImageColor3 = primary and Theme.Accent or Theme.TextDim,
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = 6,
			Parent = button,
		})
	end

	bindAccent(function()
		local selected = button:GetAttribute("NexusSelected") == true
		button.TextColor3 = primary and Theme.Accent or (selected and Theme.Text or Theme.TextDim)
		buttonStroke.Color = selected and Theme.Accent or (primary and Theme.Accent:Lerp(Theme.Card, 0.45) or Theme.Stroke)
		buttonStroke.Transparency = selected and 0.05 or 0.2
		if iconFallback then iconFallback.TextColor3 = (primary or selected) and Theme.Accent or Theme.TextDim end
		if iconImage then iconImage.ImageColor3 = (primary or selected) and Theme.Accent or Theme.TextDim end
	end)

	connect(button.MouseEnter, function()
		local selected = button:GetAttribute("NexusSelected") == true
		local hoverColor = selected and Theme.Card:Lerp(Theme.Accent, 0.2) or Theme.CardHover
		tween(button, 0.2, { BackgroundColor3 = hoverColor })
		tween(buttonStroke, 0.2, { Color = Theme.Accent, Transparency = 0 })
		if iconFallback then tween(iconFallback, 0.2, { TextColor3 = Theme.Accent }) end
		if iconImage then tween(iconImage, 0.2, { ImageColor3 = Theme.Accent }) end
		if not primary then
			tween(button, 0.2, { TextColor3 = Theme.Text })
		end
	end)

	connect(button.MouseLeave, function()
		local selected = button:GetAttribute("NexusSelected") == true
		local restingColor = selected and Theme.Card:Lerp(Theme.Accent, 0.14) or Theme.Card
		tween(button, 0.2, { BackgroundColor3 = restingColor })
		tween(buttonStroke, 0.2, {
			Color = selected and Theme.Accent or (primary and Theme.Accent:Lerp(Theme.Card, 0.45) or Theme.Stroke),
			Transparency = selected and 0.05 or 0.2,
		})
		if iconFallback then tween(iconFallback, 0.2, { TextColor3 = (primary or selected) and Theme.Accent or Theme.TextDim }) end
		if iconImage then tween(iconImage, 0.2, { ImageColor3 = (primary or selected) and Theme.Accent or Theme.TextDim }) end
		if not primary then
			tween(button, 0.2, { TextColor3 = selected and Theme.Text or Theme.TextDim })
		end
	end)

	connect(button.MouseButton1Click, function()
		ripple(button)
		onClick()
	end)

	return button
end

local function createSlider(parent, order, labelText, minValue, maxValue, step, initial, format, onCommit)
	local value = initial
	local dragging = false
	local startRatio = math.clamp((value - minValue) / (maxValue - minValue), 0, 1)

	local container = create("Frame", {
		Name = labelText,
		LayoutOrder = order,
		Size = UDim2.new(1, 0, 0, 48),
		BackgroundColor3 = Theme.Card,
		BorderSizePixel = 0,
		ZIndex = 4,
		Parent = parent,
	}, { corner(8) })

	stroke(container)

	textLabel({
		Name = "Label",
		Position = UDim2.fromOffset(14, 7),
		Size = UDim2.new(0.5, 0, 0, 14),
		Text = labelText,
		Font = Theme.Title,
		TextSize = 11,
		ZIndex = 5,
		Parent = container,
	})

	local valueLabel = textLabel({
		Name = "Value",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -14, 0, 7),
		Size = UDim2.new(0.5, -14, 0, 14),
		Text = format(value),
		Font = Theme.Mono,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 5,
		Parent = container,
	})

	local track = create("Frame", {
		Name = "Track",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 14, 1, -15),
		Size = UDim2.new(1, -28, 0, 6),
		BackgroundColor3 = Theme.Track,
		BorderSizePixel = 0,
		ZIndex = 5,
		Parent = container,
	}, { circle() })

	local fill = create("Frame", {
		Name = "Fill",
		Size = UDim2.fromScale(startRatio, 1),
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		ZIndex = 6,
		Parent = track,
	}, { circle() })

	local knob = create("Frame", {
		Name = "Knob",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(startRatio, 0, 0.5, 0),
		Size = UDim2.fromOffset(14, 14),
		BackgroundColor3 = Theme.Text,
		BorderSizePixel = 0,
		ZIndex = 7,
		Parent = track,
	}, { circle() })

	local hit = create("TextButton", {
		Name = "Hit",
		Position = UDim2.new(0, 8, 1, -32),
		Size = UDim2.new(1, -16, 0, 32),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 8,
		Parent = container,
	})

	bindAccent(function()
		fill.BackgroundColor3 = Theme.Accent
		valueLabel.TextColor3 = Theme.Accent
	end)

	local function setFromX(x)
		local ratio = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		value = minValue + math.floor(ratio * (maxValue - minValue) / step + 0.5) * step
		value = tonumber(string.format("%.2f", value))
		local snapped = math.clamp((value - minValue) / (maxValue - minValue), 0, 1)
		tween(fill, 0.08, { Size = UDim2.fromScale(snapped, 1) }, Enum.EasingStyle.Linear)
		tween(knob, 0.08, { Position = UDim2.new(snapped, 0, 0.5, 0) }, Enum.EasingStyle.Linear)
		valueLabel.Text = format(value)
	end

	connect(hit.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			setFromX(input.Position.X)
			tween(knob, 0.15, { Size = UDim2.fromOffset(18, 18) }, Enum.EasingStyle.Back)

			local changed
			changed = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					changed:Disconnect()
					tween(knob, 0.15, { Size = UDim2.fromOffset(14, 14) })
					onCommit(value)
				end
			end)
		end
	end)

	connect(UserInputService.InputChanged, function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			setFromX(input.Position.X)
		end
	end)

	return {
		Container = container,
		SetValue = function(newVal)
			value = math.clamp(newVal, minValue, maxValue)
			local snapped = math.clamp((value - minValue) / (maxValue - minValue), 0, 1)
			tween(fill, 0.15, { Size = UDim2.fromScale(snapped, 1) })
			tween(knob, 0.15, { Position = UDim2.new(snapped, 0, 0.5, 0) })
			valueLabel.Text = format(value)
		end,
	}
end

local tabs = {}
local pages = {}
local currentPage = nil

local function createTab(order, name, hasBadge, iconAsset, fallbackGlyph)
	local button = create("TextButton", {
		Name = name,
		LayoutOrder = order,
		Size = UDim2.new(1, 0, 0, TAB_HEIGHT),
		BackgroundColor3 = Theme.CardHover,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		ZIndex = 7,
		Parent = tabList,
	}, { corner(8) })

	local icon = create("ImageLabel", {
		Name = "Icon",
		Position = UDim2.fromOffset(8, math.floor((TAB_HEIGHT - 14) / 2)),
		Size = UDim2.fromOffset(14, 14),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = iconAsset or "",
		ImageColor3 = Theme.TextDim,
		ScaleType = Enum.ScaleType.Fit,
		ZIndex = 9,
		Parent = button,
	})

	local localizedName = (Localization[name] and Localization[name].pt) or name
	local label = textLabel({
		Name = "Label",
		Position = UDim2.fromOffset(27, 0),
		Size = UDim2.new(1, -51, 1, 0),
		Text = localizedName,
		Font = Theme.Title,
		TextSize = 9,
		TextColor3 = Theme.TextDim,
		TextTruncate = Enum.TextTruncate.None,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 8,
		Parent = button,
	})

	local badge = textLabel({
		Name = "Badge",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -6, 0.5, 0),
		Size = UDim2.fromOffset(16, 14),
		Text = hasBadge and "0" or "",
		Font = Theme.Mono,
		TextSize = 9,
		TextColor3 = Theme.TextDim,
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 8,
		Parent = button,
	})

	local active = false
	connect(button.InputBegan, beginTabTouch)

	bindAccent(function()
		icon.ImageColor3 = active and Theme.Accent or Theme.TextDim
	end)

	connect(button.MouseEnter, function()
		if not active then
			tween(button, 0.2, { BackgroundTransparency = 0.7 })
		end
	end)

	connect(button.MouseLeave, function()
		tween(button, 0.2, { BackgroundTransparency = 1 })
	end)

	local tab = { Button = button, Badge = badge, Order = order }

	function tab.SetActive(value)
		active = value
		tween(label, 0.25, { TextColor3 = value and Theme.Text or Theme.TextDim })
		tween(icon, 0.25, { ImageColor3 = value and Theme.Accent or Theme.TextDim })
		if value then
			tween(button, 0.2, { BackgroundTransparency = 1 })
		end
	end

	tabs[name] = tab
	return tab
end

local function selectPage(name)
	if currentPage == name then
		return
	end

	local first = currentPage == nil
	currentPage = name

	local selectedButton = tabs[name].Button
	local canvasY = tabArea.CanvasPosition.Y
	local buttonTop = selectedButton.AbsolutePosition.Y - tabArea.AbsolutePosition.Y + canvasY
	local buttonBottom = buttonTop + selectedButton.AbsoluteSize.Y
	local viewportHeight = tabArea.AbsoluteWindowSize.Y
	local nextCanvasY = canvasY
	if buttonTop < canvasY then
		nextCanvasY = buttonTop - 4
	elseif buttonBottom > canvasY + viewportHeight then
		nextCanvasY = buttonBottom - viewportHeight + 4
	end
	local maxCanvasY = math.max(0, tabArea.AbsoluteCanvasSize.Y - viewportHeight)
	tabArea.CanvasPosition = Vector2.new(0, math.clamp(nextCanvasY, 0, maxCanvasY))

	local targetPosition = UDim2.fromOffset(8, TAB_TOP + (tabs[name].Order - 1) * (TAB_HEIGHT + TAB_GAP))
	if first then
		tabIndicator.Position = targetPosition
	else
		tween(tabIndicator, 0.4, { Position = targetPosition }, Enum.EasingStyle.Back)
	end

	for pageName, page in pairs(pages) do
		local isTarget = pageName == name
		tabs[pageName].SetActive(isTarget)

		if isTarget then
			page.Container.Visible = true
			page.Container.GroupTransparency = 1
			page.Container.Position = UDim2.fromOffset(18, 0)
			tween(page.Container, 0.4, { Position = UDim2.fromOffset(0, 0), GroupTransparency = 0 })
		else
			page.Container.Visible = false
		end
	end
end

-- Ordem das abas: PARKOUR, MINIGAME, AUTO INTERACT, COLETÁVEIS e AJUSTES.
local bridgesTab = createTab(1, "PARKOUR", true, "rbxassetid://6034687957", "◇")
local minigameTab = createTab(2, "MINIGAME", true, "rbxassetid://6034754445", "✦")
local autoInteractTab = createTab(3, "AUTO INTERACT", true, "rbxassetid://6034754445", "◎")
local collectiblesTab = createTab(4, "COLETÁVEIS", false, "rbxassetid://6034754445", "◆")
local settingsTab = createTab(5, "AJUSTES", false, "rbxassetid://6031280882", "⚙")

task.defer(refreshTabCanvas)

connect(bridgesTab.Button.MouseButton1Click, function()
	if os.clock() < suppressTabClickUntil then return end
	selectPage("PARKOUR")
end)

connect(minigameTab.Button.MouseButton1Click, function()
	if os.clock() < suppressTabClickUntil then return end
	selectPage("MINIGAME")
end)

connect(autoInteractTab.Button.MouseButton1Click, function()
	if os.clock() < suppressTabClickUntil then return end
	selectPage("AUTO INTERACT")
end)

connect(collectiblesTab.Button.MouseButton1Click, function()
	if os.clock() < suppressTabClickUntil then return end
	selectPage("COLETÁVEIS")
end)

connect(settingsTab.Button.MouseButton1Click, function()
	if os.clock() < suppressTabClickUntil then return end
	selectPage("AJUSTES")
end)

local bridgesPage = createPage("PARKOUR", "ROTAS DE PARKOUR")
local minigamePage = createPage("MINIGAME", "TREINO AUTOMÁTICO")
local autoInteractPage = createPage("AUTO INTERACT", "INTERAÇÃO AUTOMÁTICA")
local collectiblesPage = createPage("COLETÁVEIS", "RECOMPENSAS DO MAPA")
local settingsPage = createPage("AJUSTES", "APARÊNCIA E COMPORTAMENTO")
pages.PARKOUR = bridgesPage
pages.MINIGAME = minigamePage
pages["AUTO INTERACT"] = autoInteractPage
pages["COLETÁVEIS"] = collectiblesPage
pages.AJUSTES = settingsPage

-- ==========================================
-- AUTO INTERACT · MONITORAMENTO E FORÇAMENTO EM LOOP DE PROXIMITY PROMPTS
-- ==========================================
do
	local autoInteractActive = false
	local interactionBusy = false
	local currentPrompt = nil
	local triggeredCount = 0
	local lastAttempt = setmetatable({}, { __mode = "k" })
	local promptCache = setmetatable({}, { __mode = "k" })
	local originalHoldDurations = setmetatable({}, { __mode = "k" })

	local infoCard = create("Frame", {
		Name = "AutoInteractInfo",
		LayoutOrder = 3,
		Size = UDim2.new(1, 0, 0, 48),
		BackgroundColor3 = Theme.Card,
		BorderSizePixel = 0,
		ZIndex = 4,
		Parent = autoInteractPage.Scroll,
	}, { corner(8) })
	stroke(infoCard)

	local statusValue = textLabel({
		Name = "AutoInteractStatus",
		Position = UDim2.fromOffset(14, 8),
		Size = UDim2.new(0.38, 0, 0, 14),
		Text = "DESATIVADO",
		Font = Theme.Mono,
		TextColor3 = Theme.TextDim,
		TextSize = 10,
		ZIndex = 5,
		Parent = infoCard,
	})

	local countValue = textLabel({
		Name = "AutoInteractCount",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -14, 0, 8),
		Size = UDim2.new(0.62, -14, 0, 14),
		Text = "0 próximos  ·  0 acionados",
		Font = Theme.Mono,
		TextColor3 = Theme.Accent,
		TextSize = 9,
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 5,
		Parent = infoCard,
	})

	local infoDescription = textLabel({
		Name = "AutoInteractDescription",
		Position = UDim2.fromOffset(14, 26),
		Size = UDim2.new(1, -28, 0, 14),
		Text = "Aguardando ativação do recurso.",
		Font = Theme.Body,
		TextColor3 = Theme.TextDim,
		TextSize = 9,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 5,
		Parent = infoCard,
	})

	bindAccent(function()
		countValue.TextColor3 = Theme.Accent
	end)

	local function updateAutoInteractInfo(nearbyCount, activeName)
		statusValue.Text = autoInteractActive and "ATIVADO" or "DESATIVADO"
		statusValue.TextColor3 = autoInteractActive and Theme.Success or Theme.TextDim
		countValue.Text = string.format("%d próximos  ·  %d acionados", nearbyCount or 0, triggeredCount)
		autoInteractTab.Badge.Text = tostring(triggeredCount)
		tween(autoInteractTab.Badge, 0.25, { TextColor3 = autoInteractActive and Theme.Success or Theme.TextDim })
		if autoInteractActive then
			if activeName and activeName ~= "" then
				infoDescription.Text = "Interagindo com: " .. activeName
			else
				infoDescription.Text = "Procurando ProximityPrompts próximos em tempo real..."
			end
		else
			infoDescription.Text = "Ative para forçar interações próximas automaticamente."
		end
	end

	local function registerPrompt(instance)
		if instance and instance:IsA("ProximityPrompt") then
			promptCache[instance] = true
			if originalHoldDurations[instance] == nil then
				pcall(function()
					originalHoldDurations[instance] = instance.HoldDuration
				end)
			end
		end
	end

	for _, descendant in ipairs(game:GetDescendants()) do
		registerPrompt(descendant)
	end

	connect(game.DescendantAdded, registerPrompt)
	connect(game.DescendantRemoving, function(instance)
		if instance and instance:IsA("ProximityPrompt") then
			promptCache[instance] = nil
			lastAttempt[instance] = nil
			originalHoldDurations[instance] = nil
		end
	end)

	connect(ProximityPromptService.PromptShown, function(prompt)
		registerPrompt(prompt)
	end)

	local function getCharacterPosition()
		local character = LocalPlayer.Character or Workspace:FindFirstChild(LocalPlayer.Name)
		if not character then
			return nil
		end

		local root = character:FindFirstChild("HumanoidRootPart")
			or character.PrimaryPart
			or character:FindFirstChild("UpperTorso")
			or character:FindFirstChild("Torso")
			or character:FindFirstChild("Head")
			or character:FindFirstChildWhichIsA("BasePart")

		if root and root:IsA("BasePart") then
			return root.Position
		end

		local ok, pivot = pcall(function()
			return character:GetPivot()
		end)
		if ok and pivot then
			return pivot.Position
		end

		return nil
	end

	local function getPromptWorldPosition(prompt)
		if not prompt or not prompt.Parent then
			return nil
		end

		local parent = prompt.Parent
		if parent:IsA("Attachment") then
			return parent.WorldPosition
		elseif parent:IsA("BasePart") then
			return parent.Position
		elseif parent:IsA("Model") then
			if parent.PrimaryPart then
				return parent.PrimaryPart.Position
			end
			local ok, pivot = pcall(function()
				return parent:GetPivot()
			end)
			if ok and pivot then
				return pivot.Position
			end
			local part = parent:FindFirstChildWhichIsA("BasePart", true)
			if part then
				return part.Position
			end
		end

		local attachment = prompt:FindFirstAncestorWhichIsA("Attachment")
		if attachment then
			return attachment.WorldPosition
		end

		local part = prompt:FindFirstAncestorWhichIsA("BasePart")
		if part then
			return part.Position
		end

		local model = prompt:FindFirstAncestorOfClass("Model")
		if model then
			local ok, pivot = pcall(function()
				return model:GetPivot()
			end)
			if ok and pivot then
				return pivot.Position
			end
			local subPart = model:FindFirstChildWhichIsA("BasePart", true)
			if subPart then
				return subPart.Position
			end
		end

		return nil
	end

	local function restoreHoldDurations()
		for prompt, origHold in pairs(originalHoldDurations) do
			if prompt and prompt.Parent then
				pcall(function()
					prompt.HoldDuration = origHold
				end)
			end
		end
	end

	local function triggerPrompt(prompt)
		if not prompt or not prompt.Parent or not prompt.Enabled then
			return false
		end

		local origHold = originalHoldDurations[prompt]
		if origHold == nil then
			pcall(function()
				origHold = prompt.HoldDuration
				originalHoldDurations[prompt] = origHold
			end)
		end

		if Settings.AutoInteractInstant then
			pcall(function()
				prompt.HoldDuration = 0
			end)
		end

		local firedWithExecutor = false
		if type(fireproximityprompt) == "function" then
			local ok = pcall(function()
				if Settings.AutoInteractInstant then
					fireproximityprompt(prompt, 0)
				else
					fireproximityprompt(prompt)
				end
			end)
			if ok then
				firedWithExecutor = true
			end
		end

		if not firedWithExecutor then
			local keyCode = prompt.KeyboardKeyCode
			local beganOk = pcall(function()
				prompt:InputHoldBegin()
			end)

			if not beganOk and keyCode and keyCode ~= Enum.KeyCode.Unknown then
				pcall(function()
					VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
				end)
			end

			local holdTime = 0
			if not Settings.AutoInteractInstant then
				local promptHold = 0
				pcall(function()
					promptHold = prompt.HoldDuration
				end)
				holdTime = math.max(promptHold, Settings.AutoInteractHold)
			else
				holdTime = math.max(0.02, Settings.AutoInteractHold)
			end

			if holdTime > 0 then
				local startClock = os.clock()
				while alive and autoInteractActive and prompt.Parent and prompt.Enabled and (os.clock() - startClock) < holdTime do
					task.wait(0.02)
				end
			end

			pcall(function()
				prompt:InputHoldEnd()
			end)
			if keyCode and keyCode ~= Enum.KeyCode.Unknown then
				pcall(function()
					VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
				end)
			end
		end

		return true
	end

	local function scanAndForcePrompts()
		local playerPos = getCharacterPosition()
		if not playerPos then
			updateAutoInteractInfo(0)
			return
		end

		local now = os.clock()
		local nearbyPrompts = {}

		for prompt in pairs(promptCache) do
			if prompt and prompt.Parent and prompt:IsDescendantOf(Workspace) then
				local ok, enabled, maxDist = pcall(function()
					return prompt.Enabled, prompt.MaxActivationDistance
				end)

				if ok and enabled then
					local promptPos = getPromptWorldPosition(prompt)
					if promptPos then
						local distance = (playerPos - promptPos).Magnitude
						local effectiveRange = math.max(Settings.AutoInteractRange, maxDist or 10)
						if distance <= effectiveRange and distance <= (maxDist + Settings.AutoInteractRange) then
							table.insert(nearbyPrompts, {
								Prompt = prompt,
								Distance = distance,
								MaxDist = maxDist or 10,
							})
						end
					end
				end
			else
				promptCache[prompt] = nil
			end
		end

		table.sort(nearbyPrompts, function(a, b)
			return a.Distance < b.Distance
		end)

		local nearbyCount = #nearbyPrompts
		local activeLabel = nil

		for _, item in ipairs(nearbyPrompts) do
			local prompt = item.Prompt
			if item.Distance <= math.max(item.MaxDist + 2, Settings.AutoInteractRange) then
				local lastTime = lastAttempt[prompt] or 0
				if (now - lastTime) >= Settings.AutoInteractInterval then
					lastAttempt[prompt] = now
					activeLabel = (prompt.ActionText ~= "" and prompt.ActionText)
						or (prompt.ObjectText ~= "" and prompt.ObjectText)
						or prompt.Name

					currentPrompt = prompt
					local success = triggerPrompt(prompt)
					currentPrompt = nil

					if success then
						triggeredCount += 1
					end
				end
			end
		end

		updateAutoInteractInfo(nearbyCount, activeLabel)
	end

	local function releaseCurrentPrompt()
		local prompt = currentPrompt
		currentPrompt = nil
		if prompt then
			pcall(function()
				prompt:InputHoldEnd()
			end)
		end
		restoreHoldDurations()
	end

	sectionLabel(autoInteractPage.Scroll, 1, "CONTROLE PRINCIPAL")
	createSwitchRow(
		autoInteractPage.Scroll,
		2,
		"Auto Interact",
		"Procura todos os ProximityPrompts do mapa em loop (incluindo novos) e força a interação quando você estiver perto.",
		IS_TOUCH and 86 or 82,
		false,
		function(state)
			autoInteractActive = state
			if not state then
				releaseCurrentPrompt()
			else
				for _, descendant in ipairs(Workspace:GetDescendants()) do
					registerPrompt(descendant)
				end
			end
			updateAutoInteractInfo(0)
			showToast(state and "Auto Interact ativado." or "Auto Interact desativado.", state and Theme.Success or Theme.TextDim)
		end
	)

	sectionLabel(autoInteractPage.Scroll, 4, "AJUSTES DE INTERAÇÃO")

	createSwitchRow(
		autoInteractPage.Scroll,
		5,
		"Interação instantânea",
		"Remove o tempo de segurar (HoldDuration = 0) para acionar o ProximityPrompt imediatamente ao encostar.",
		SWITCH_HEIGHT,
		Settings.AutoInteractInstant,
		function(state)
			Settings.AutoInteractInstant = state
			if not state then
				restoreHoldDurations()
			end
			saveSettings()
		end
	)

	createSlider(autoInteractPage.Scroll, 6, "Intervalo entre interações", 0.05, 3.0, 0.05, Settings.AutoInteractInterval, function(value)
		return string.format("%.2fs", value)
	end, function(value)
		Settings.AutoInteractInterval = value
		saveSettings()
	end)

	createSlider(autoInteractPage.Scroll, 7, "Tempo segurando (Hold)", 0, 2.0, 0.05, Settings.AutoInteractHold, function(value)
		return string.format("%.2fs", value)
	end, function(value)
		Settings.AutoInteractHold = value
		saveSettings()
	end)

	createSlider(autoInteractPage.Scroll, 8, "Alcance de detecção", 5, 50, 1, Settings.AutoInteractRange, function(value)
		return string.format("%d studs", math.floor(value + 0.5))
	end, function(value)
		Settings.AutoInteractRange = value
		saveSettings()
	end)

	task.spawn(function()
		local lastFullSweep = 0
		while alive do
			if autoInteractActive and not interactionBusy then
				interactionBusy = true
				if os.clock() - lastFullSweep >= 2.0 then
					lastFullSweep = os.clock()
					for _, desc in ipairs(Workspace:GetDescendants()) do
						if desc:IsA("ProximityPrompt") and not promptCache[desc] then
							registerPrompt(desc)
						end
					end
				end

				local ok, err = pcall(scanAndForcePrompts)
				if not ok then
					warn("[NexusHub] Auto Interact: " .. tostring(err))
				end
				interactionBusy = false
				task.wait(0.08)
			else
				task.wait(0.2)
			end
		end
		releaseCurrentPrompt()
	end)
end

-- ==========================================
-- COLETÁVEIS · MONEYBAG E PRESENTE DE PATENTE
-- ==========================================
do
    local moneyBagBusy = false
    local presentBusy = false
    local presentClaimAttempted = false

    local statusCard = create("Frame", {
        Name = "CollectiblesStatus",
        LayoutOrder = 1,
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0,
        ZIndex = 4,
        Parent = collectiblesPage.Scroll,
    }, { corner(8) })
    stroke(statusCard)

    local statusLabel = textLabel({
        Name = "CollectiblesStatusText",
        Position = UDim2.fromOffset(12, 8),
        Size = UDim2.new(1, -24, 1, -16),
        Text = "Presente: disponível para coleta. MoneyBag: coleta repetível.",
        Font = Theme.Body,
        TextColor3 = Theme.TextDim,
        TextSize = 10,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 5,
        Parent = statusCard,
    })

    local function setCollectibleStatus(message, color)
        statusLabel.Text = message
        statusLabel.TextColor3 = color or Theme.TextDim
    end

    local function findPromptInWorkspace(objectName)
        local target = Workspace:FindFirstChild(objectName)
            or Workspace:FindFirstChild(objectName, true)
        if not target then
            return nil, nil
        end

        local prompt
        if target:IsA("ProximityPrompt") then
            prompt = target
        else
            prompt = target:FindFirstChildWhichIsA("ProximityPrompt", true)
        end
        return target, prompt
    end

    local function getPromptPosition(prompt)
        if not prompt or not prompt.Parent then
            return nil
        end

        local parent = prompt.Parent
        if parent:IsA("Attachment") then
            return parent.WorldPosition
        elseif parent:IsA("BasePart") then
            return parent.Position
        end

        local attachment = prompt:FindFirstAncestorWhichIsA("Attachment")
        if attachment then
            return attachment.WorldPosition
        end

        local part = prompt:FindFirstAncestorWhichIsA("BasePart")
        if part then
            return part.Position
        end

        local model = prompt:FindFirstAncestorOfClass("Model")
        if model then
            local ok, pivot = pcall(function()
                return model:GetPivot()
            end)
            if ok and pivot then
                return pivot.Position
            end
        end
        return nil
    end

    local function teleportToPrompt(prompt)
        local position = getPromptPosition(prompt)
        if not position then
            return false
        end

        local character = LocalPlayer.Character
        if not character then
            return false
        end

        local root = character:FindFirstChild("HumanoidRootPart")
            or character.PrimaryPart
        if not root then
            return false
        end

        local destination = position + Vector3.new(0, 2.5, 0)
        local ok = pcall(function()
            character:PivotTo(CFrame.new(destination))
        end)
        return ok
    end

    local function forceCollectPrompt(prompt)
        if not prompt or not prompt.Parent then
            return false
        end
        if not prompt.Enabled then
            return false
        end

        local originalHold = prompt.HoldDuration
        pcall(function()
            prompt.HoldDuration = 0
        end)

        local fired = false
        if type(fireproximityprompt) == "function" then
            fired = pcall(function()
                fireproximityprompt(prompt, 0)
            end)
        end

        if not fired then
            local began = pcall(function()
                prompt:InputHoldBegin()
            end)
            if began then
                task.wait(math.max(0.05, originalHold or 0))
                fired = pcall(function()
                    prompt:InputHoldEnd()
                end)
            end
        end

        task.wait(0.15)
        pcall(function()
            if prompt and prompt.Parent then
                prompt.HoldDuration = originalHold
            end
        end)
        return fired
    end

    local function collectObject(objectName)
        local target, prompt = findPromptInWorkspace(objectName)
        if not target then
            showToast(objectName .. " não foi encontrado no Workspace.", Theme.TextDim)
            return false
        end
        if not prompt then
            showToast("ProximityPrompt não encontrado em " .. objectName .. ".", Theme.TextDim)
            return false
        end
        if not prompt.Enabled then
            showToast("A interação de " .. objectName .. " está indisponível.", Theme.TextDim)
            return false
        end
        if not teleportToPrompt(prompt) then
            showToast("Não foi possível teleportar até " .. objectName .. ".", Theme.TextDim)
            return false
        end

        task.wait(0.2)
        return forceCollectPrompt(prompt)
    end

    sectionLabel(collectiblesPage.Scroll, 0, "RECOMPENSAS DISPONÍVEIS")

    createButton(collectiblesPage.Scroll, 2, "COLETAR MONEYBAG", true, UDim2.new(1, 0, 0, 36), function()
        if moneyBagBusy then
            return
        end
        moneyBagBusy = true
        task.spawn(function()
            local ok, result = pcall(collectObject, "MoneyBag")
            if ok and result then
                showToast("Interação com MoneyBag enviada.", Theme.Success)
            elseif not ok then
                showToast("Falha ao interagir com MoneyBag.", Theme.TextDim)
            end
            moneyBagBusy = false
        end)
    end, "rbxassetid://6031094678", "$")

    local function collectPresent(resetFirst)
        if presentBusy then
            return
        end
        if presentClaimAttempted and not resetFirst then
            showToast("Presente já tentado nesta sessão. Use Resetar para tentar novamente.", Theme.TextDim)
            return
        end

        if resetFirst then
            presentClaimAttempted = false
        end

        presentBusy = true
        task.spawn(function()
            local ok, result = pcall(collectObject, "Presente_UpPatente")
            if ok and result then
                presentClaimAttempted = true
                setCollectibleStatus("Presente: tentativa enviada. Use o botão de reset para tentar coletar novamente.", Theme.Success)
                showToast("Interação com Presente_UpPatente enviada.", Theme.Success)
            elseif not ok then
                setCollectibleStatus("Não foi possível concluir a interação com o presente.", Theme.TextDim)
                showToast("Falha ao interagir com o presente.", Theme.TextDim)
            else
                setCollectibleStatus("Presente disponível quando o ProximityPrompt estiver ativo.", Theme.TextDim)
            end
            presentBusy = false
        end)
    end

    createButton(collectiblesPage.Scroll, 3, "COLETAR PRESENTE UP PATENTE", false, UDim2.new(1, 0, 0, 36), function()
        collectPresent(false)
    end, "rbxassetid://6031068421", "◆")

    createButton(collectiblesPage.Scroll, 4, "RESETAR E COLETAR PRESENTE NOVAMENTE", false, UDim2.new(1, 0, 0, 36), function()
        collectPresent(true)
    end, "rbxassetid://6031280882", "↻")

    sectionLabel(collectiblesPage.Scroll, 5, "COMPORTAMENTO")
    textLabel({
        Name = "CollectiblesDescription",
        LayoutOrder = 6,
        Size = UDim2.new(1, 0, 0, 48),
        Text = "MoneyBag pode ser acionado repetidamente. O presente é tentado uma vez por sessão; o botão de reset libera e executa uma nova tentativa. A aprovação da recompensa depende do servidor do jogo.",
        Font = Theme.Body,
        TextColor3 = Theme.TextDim,
        TextSize = 10,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 4,
        Parent = collectiblesPage.Scroll,
    })
end

-- ==========================================
-- LÓGICA DO AUTO MINIGAME + LEITOR OVERHEAD + BARRA DE PROGRESSO
-- ==========================================
local function forcarModoPC()
	task.spawn(function()
		task.wait(0.05)
		VirtualInputManager:SendMouseButtonEvent(10, 10, 0, true, game, 1)
		task.wait(0.02)
		VirtualInputManager:SendMouseButtonEvent(10, 10, 0, false, game, 1)
	end)
end

local function restaurarControlesMobile()
	if not isMobileTouch then
		return
	end

	task.spawn(function()
		task.wait(0.05)
		local touchGui = PlayerGui:FindFirstChild("TouchGui")
		if touchGui then
			touchGui.Enabled = true
			for _, descendant in ipairs(touchGui:GetDescendants()) do
				if descendant:IsA("GuiObject") then
					descendant.Visible = true
				end
			end
		end
		pcall(function()
			VirtualInputManager:SendTouchEvent(99, 0, 10, 10)
			task.wait(0.02)
			VirtualInputManager:SendTouchEvent(99, 2, 10, 10)
		end)
	end)
end

local function obterPulosAtuaisOverhead()
	local char = LocalPlayer.Character or Workspace:FindFirstChild(LocalPlayer.Name)
	if not char then
		return nil
	end

	local head = char:FindFirstChild("Head")
	local overhead = head and head:FindFirstChild("Overhead")
	local atividade = overhead and overhead:FindFirstChild("AtividadeFisica")
	local container = atividade and atividade:FindFirstChild("Container")
	local valObj = container and container:FindFirstChild("Value")

	if valObj then
		local ok, texto = pcall(function()
			return valObj.Text
		end)
		if ok and type(texto) == "string" then
			local numeroStr = string.match(texto, "%d+")
			if numeroStr then
				local numero = tonumber(numeroStr)
				if numero == 363479 then
					return 0
				end
				return numero
			end
		end
	end

	return nil
end

local progressCard = create("Frame", {
	Name = "ProgressCard",
	LayoutOrder = 0,
	Size = UDim2.new(1, 0, 0, 52),
	BackgroundColor3 = Theme.Card,
	BorderSizePixel = 0,
	ZIndex = 4,
	Parent = minigamePage.Scroll,
}, { corner(8) })
stroke(progressCard)

local progressTitleLabel = textLabel({
	Position = UDim2.fromOffset(14, 7),
	Size = UDim2.new(0.55, 0, 0, 14),
	Text = "PROGRESSO DO EXERCÍCIO",
	Font = Theme.Title,
	TextSize = 11,
	TextColor3 = Theme.Text,
	ZIndex = 5,
	Parent = progressCard,
})

local progressValueLabel = textLabel({
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -14, 0, 7),
	Size = UDim2.new(0.45, -14, 0, 14),
	Text = string.format("0 / %d (0%%)", Settings.TargetClicks),
	Font = Theme.Mono,
	TextSize = 11,
	TextColor3 = Theme.Accent,
	TextXAlignment = Enum.TextXAlignment.Right,
	ZIndex = 5,
	Parent = progressCard,
})

local progressBarTrack = create("Frame", {
	Name = "ProgressBarTrack",
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 14, 1, -10),
	Size = UDim2.new(1, -28, 0, 8),
	BackgroundColor3 = Theme.Track,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	ZIndex = 5,
	Parent = progressCard,
}, { circle() })

local progressBarFill = create("Frame", {
	Name = "ProgressBarFill",
	Size = UDim2.fromScale(0, 1),
	BackgroundColor3 = Theme.Accent,
	BorderSizePixel = 0,
	ZIndex = 6,
	Parent = progressBarTrack,
}, { circle() })

bindAccent(function()
	if not autoMinigameActive then
		progressBarFill.BackgroundColor3 = Theme.Accent
		progressValueLabel.TextColor3 = Theme.Accent
	end
end)

local function updateMinigameUI()
	local target = Settings.TargetClicks
	local ratio = 0

	if target > 0 then
		ratio = math.clamp(currentClickCount / target, 0, 1)
		local pct = math.floor(ratio * 100 + 0.5)
		progressValueLabel.Text = string.format("%d / %d (%d%%)", currentClickCount, target, pct)
	else
		ratio = currentClickCount > 0 and 1 or 0
		progressValueLabel.Text = string.format("%d / %s", currentClickCount, "SEM LIMITE")
	end

	tween(progressBarFill, 0.25, {
		Size = UDim2.fromScale(ratio, 1),
		BackgroundColor3 = (ratio >= 1 and target > 0) and Theme.Success or Theme.Accent,
	}, Enum.EasingStyle.Quad)

	progressValueLabel.TextColor3 = autoMinigameActive and Theme.Success or Theme.Accent
	minigameTab.Badge.Text = autoMinigameActive and tostring(currentClickCount) or "0"
	tween(minigameTab.Badge, 0.3, { TextColor3 = autoMinigameActive and Theme.Success or Theme.TextDim })
end

sectionLabel(minigamePage.Scroll, 1, "ESCOLHA UM EXERCÍCIO")
local exerciseButtons = {}

local function refreshSelectedExercise()
	for exerciseName, button in pairs(exerciseButtons) do
		local selected = exerciseName == selectedExercise
		button:SetAttribute("NexusSelected", selected)
		button.BackgroundColor3 = selected and Theme.Card:Lerp(Theme.Accent, 0.14) or Theme.Card
		button.TextColor3 = selected and Theme.Text or Theme.TextDim

		local outline = button:FindFirstChildOfClass("UIStroke")
		if outline then
			outline.Color = selected and Theme.Accent or Theme.Stroke
			outline.Transparency = selected and 0.05 or 0.2
			outline.Thickness = selected and 1.5 or 1
		end

		local marker = button:FindFirstChild("SelectedIndicator")
		if marker then
			marker.Visible = selected
			marker.BackgroundColor3 = Theme.Accent
		end

		local check = button:FindFirstChild("SelectedCheck")
		if check then
			check.Visible = selected
			check.TextColor3 = Theme.Accent
		end
	end
end

local function addExerciseChoice(order, exerciseName)
	local button = createButton(minigamePage.Scroll, order, exerciseName, false, UDim2.new(1, 0, 0, 34), function()
		selectedExercise = exerciseName
		refreshSelectedExercise()
		showToast("Exercício selecionado: " .. translate(selectedExercise), Theme.Accent)
	end)

	local marker = create("Frame", {
		Name = "SelectedIndicator",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 10, 0.5, 0),
		Size = UDim2.fromOffset(3, 18),
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 6,
		Parent = button,
	}, { corner(2) })

	local check = textLabel({
		Name = "SelectedCheck",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(18, 18),
		Text = "✓",
		Font = Theme.Title,
		TextSize = 14,
		TextColor3 = Theme.Accent,
		TextXAlignment = Enum.TextXAlignment.Center,
		Visible = false,
		ZIndex = 6,
		Parent = button,
	})

	exerciseButtons[exerciseName] = button
	return button
end

addExerciseChoice(2, "Polichinelos")
addExerciseChoice(3, "Flexões")
addExerciseChoice(4, "Barras")

bindAccent(refreshSelectedExercise)
refreshSelectedExercise()

local minigameToggle
minigameToggle = createSwitchRow(
	minigamePage.Scroll,
	5,
	"Automação do exercício",
	"Executa o exercício selecionado e acompanha o contador em tempo real.",
	ROW_HEIGHT,
	false,
	function(state)
		autoMinigameActive = state
		autoMinigameReady = false
		if state then
			currentClickCount = obterPulosAtuaisOverhead() or 0
			forcarModoPC()
			local remoteFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
			local exerciseRemote = remoteFolder and remoteFolder:FindFirstChild("Polichinelos")
			if not exerciseRemote or not exerciseRemote:IsA("RemoteEvent") then
				autoMinigameActive = false
				minigameToggle.Set(false, true)
				restaurarControlesMobile()
				showToast("Não foi possível iniciar: o evento do exercício não está disponível.", Theme.TextDim)
			else
				local ok = pcall(function()
					exerciseRemote:FireServer("Start", selectedExercise == "Barras" and "BarraFixa" or selectedExercise)
				end)
				if not ok then
					autoMinigameActive = false
					minigameToggle.Set(false, true)
					restaurarControlesMobile()
					showToast("Não foi possível iniciar o exercício selecionado.", Theme.TextDim)
				else
					showToast("Aguardando o contador iniciar…", Theme.Accent)
					task.spawn(function()
						local startedAt = os.clock()
						local observedInitialCount = false
						while alive and autoMinigameActive do
							local count = obterPulosAtuaisOverhead()
							if count ~= nil and count > 0 then
								observedInitialCount = true
							end
							local minimumWaitElapsed = os.clock() - startedAt >= 0.15
							if count == 0 and (observedInitialCount or minimumWaitElapsed) then
								currentClickCount = 0
								autoMinigameReady = true
								updateMinigameUI()
								showToast("Contador sincronizado. Automação iniciada.", Theme.Success)
								return
							end
							task.wait(0.03)
						end
					end)
				end
			end
		else
			autoMinigameReady = false
			restaurarControlesMobile()
			showToast("Automação do exercício desativada.", Theme.TextDim)
		end
		updateMinigameUI()
	end
)

local delaySlider
local delayInput

delaySlider = createSlider(
	minigamePage.Scroll,
	6,
	"Intervalo das ações",
	0.1,
	5.0,
	0.1,
	Settings.ClickDelay,
	function(value)
		return string.format("%.1fs", value)
	end,
	function(value)
		Settings.ClickDelay = value
		if delayInput then
			delayInput.SetValue(value)
		end
		saveSettings()
		showToast(string.format("Intervalo definido · %.1fs", value), Theme.Accent)
	end
)

delayInput = createNumberInputRow(
	minigamePage.Scroll,
	7,
	"Intervalo manual (segundos)",
	"Define a pausa entre cada ação. Valores menores aceleram a execução.",
	Settings.ClickDelay,
	function(num)
		local clamped = math.clamp(tonumber(string.format("%.2f", num)) or 1.5, 0.1, 5.0)
		Settings.ClickDelay = clamped
		delaySlider.SetValue(clamped)
		saveSettings()
		return clamped
	end
)

createNumberInputRow(
	minigamePage.Scroll,
	8,
	"Limite de repetições",
	"Encerra a automação ao atingir o total definido. Use 0 para não impor um limite.",
	Settings.TargetClicks,
	function(num)
		local valid = math.max(0, math.floor(num))
		Settings.TargetClicks = valid
		saveSettings()
		updateMinigameUI()
		showToast("Limite definido: " .. (valid > 0 and tostring(valid) or ("SEM LIMITE")), Theme.Accent)
		return valid
	end
)

local resetCountBtn = createButton(minigamePage.Header, 0, "ZERAR PROGRESSO", false, IS_TOUCH and UDim2.fromOffset(108, 28) or UDim2.fromOffset(112, 24), function()
	currentClickCount = 0
	updateMinigameUI()
	showToast("Progresso zerado.", Theme.Accent)
end)
resetCountBtn.AnchorPoint = Vector2.new(1, 0.5)
resetCountBtn.Position = UDim2.new(1, -4, 0.5, 0)
resetCountBtn.TextSize = 10

local function clicarNoBotao(botao)
	local guiInset = GuiService:GetGuiInset()
	local pos = botao.AbsolutePosition
	local size = botao.AbsoluteSize

	local centerX = pos.X + (size.X / 2)
	local centerY = pos.Y + (size.Y / 2) + guiInset.Y

	VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
	task.wait(0.02)
	VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
end

local function pressionarTecla(keyCode)
	VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
	task.wait(0.02)
	VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
end

local function processarBotaoMinigame(botao)
	local lbl = botao:FindFirstChild("TextLabel")
	if not lbl or not lbl:IsA("TextLabel") then
		return false
	end

	local texto = string.upper(string.gsub(lbl.Text, "%s+", ""))

	if texto == "TAP" then
		clicarNoBotao(botao)
		return true
	elseif texto == "E" then
		pressionarTecla(Enum.KeyCode.E)
		return true
	elseif texto == "Q" then
		pressionarTecla(Enum.KeyCode.Q)
		return true
	end

	return false
end

local function verificarMetaConcluida()
	if Settings.TargetClicks > 0 and currentClickCount >= Settings.TargetClicks then
		autoMinigameActive = false
		autoMinigameReady = false
		minigameToggle.Set(false, true)
		restaurarControlesMobile()
		updateMinigameUI()
		showToast(("Meta de " .. Settings.TargetClicks .. " repetições concluída."), Theme.Success)
		return true
	end
	return false
end

task.spawn(function()
	while alive do
		local pulosOverhead = obterPulosAtuaisOverhead()
		if pulosOverhead ~= nil and pulosOverhead ~= currentClickCount then
			currentClickCount = pulosOverhead
			updateMinigameUI()
			if autoMinigameActive and autoMinigameReady then
				verificarMetaConcluida()
			end
		end
		task.wait(0.1)
	end
end)

task.spawn(function()
	while alive do
		if autoMinigameActive and autoMinigameReady then
			local pulosOverhead = obterPulosAtuaisOverhead()
			if pulosOverhead ~= nil then
				currentClickCount = pulosOverhead
				updateMinigameUI()
				if verificarMetaConcluida() then
					task.wait(0.15)
					continue
				end
			end

			local executouAcao = false
			local minigameGui = PlayerGui:FindFirstChild("AtividadesFisicasMinigame")
			local screen = minigameGui and minigameGui:FindFirstChild("Screen")

			if screen and screen.Visible then
				for _, child in ipairs(screen:GetChildren()) do
					if not autoMinigameActive then
						break
					end
					if child:IsA("GuiObject") and child.Visible then
						if child.AbsoluteSize.X > 0 and child.AbsoluteSize.Y > 0 then
							if processarBotaoMinigame(child) then
								executouAcao = true

								task.wait(0.08)
								local novoValor = obterPulosAtuaisOverhead()
								if novoValor ~= nil then
									currentClickCount = novoValor
								end

								updateMinigameUI()
								verificarMetaConcluida()
								break
							end
						end
					end
				end
			end

			if executouAcao and autoMinigameActive then
				task.wait(math.max(0.05, Settings.ClickDelay - 0.08))
			else
				task.wait(0.08)
			end
		else
			task.wait(0.15)
		end
	end
end)

-- ==========================================
-- PÁGINA BRIDGES E SETTINGS ORIGINAIS + CRÉDITOS
-- ==========================================
local function updateCounter()
	local count = BridgeManager.Count()
	counterLabel.Text = string.format("ROTAS ATIVAS  %d/%d", count, #ModuleOrder)
	counterLabel.TextColor3 = Theme.Text
	tween(counterLabel, 0.5, { TextColor3 = count > 0 and Theme.Success or Theme.TextDim })
	bridgesTab.Badge.Text = tostring(count)
	tween(bridgesTab.Badge, 0.4, { TextColor3 = count > 0 and Theme.Success or Theme.TextDim })
end

local bridgeToggles = {}

local function handleToggle(key, state)
	local ok, err = pcall(function()
		if state then BridgeManager.Enable(key) else BridgeManager.Disable(key) end
	end)
	if not ok then
		warn("[NexusHub] Bridge operation failed: " .. tostring(err))
		if bridgeToggles[key] then bridgeToggles[key].Set(false, true) end
		showToast("Falha ao ativar a rota: " .. tostring(err), Color3.fromRGB(255, 80, 90))
		return
	end

	Settings.SavedBridges[key] = state and true or nil
	saveSettings()
	updateCounter()

	if not bulkUpdate then
		showToast(
			translate(BridgeDefinitions[key].DisplayName) .. (state and " · ATIVADO" or " · DESATIVADO"),
			state and Theme.Success or Theme.TextDim
		)
	end
end

for index, key in ipairs(ModuleOrder) do
	local definition = BridgeDefinitions[key]
	bridgeToggles[key] = createSwitchRow(
		bridgesPage.Scroll,
		index,
		definition.DisplayName,
		definition.Description,
		ROW_HEIGHT,
		false,
		function(state)
			handleToggle(key, state)
		end
	)
end

if Settings.AutoRestoreBridges then
	for _, key in ipairs(ModuleOrder) do
		if Settings.SavedBridges[key] == true then
			bridgeToggles[key].Set(true, true)
			local ok, err = pcall(function() BridgeManager.Enable(key) end)
			if not ok then warn("[NexusHub] Startup restore failed: " .. tostring(err)) end
		end
	end
	updateCounter()
end

task.spawn(function()
	while alive do
		task.wait(1)
		if alive then
			BridgeManager.Reconcile()
			updateCounter()
		end
	end
end)

local function setAllBridges(value)
	bulkUpdate = true
	for _, key in ipairs(ModuleOrder) do
		bridgeToggles[key].Set(value)
	end
	bulkUpdate = false

	showToast(
		value and "Todas as rotas de parkour foram ativadas." or "Todas as rotas de parkour foram desativadas.",
		value and Theme.Success or Theme.TextDim
	)
end

local allOffButton = createButton(bridgesPage.Header, 0, "DESATIVAR", false, HEADER_BUTTON, function()
	setAllBridges(false)
end)
allOffButton.AnchorPoint = Vector2.new(1, 0.5)
allOffButton.Position = UDim2.new(1, -4, 0.5, 0)
allOffButton.TextSize = 10

local allOnButton = createButton(bridgesPage.Header, 0, "ATIVAR TUDO", true, HEADER_BUTTON, function()
	setAllBridges(true)
end)
allOnButton.AnchorPoint = Vector2.new(1, 0.5)
allOnButton.Position = UDim2.new(1, -(HEADER_BUTTON.X.Offset + 10), 0.5, 0)
allOnButton.TextSize = 10

sectionLabel(settingsPage.Scroll, 6, "COR DE DESTAQUE")
for index, preset in ipairs(Presets) do
	local presetIndex = index
	local presetName = preset.Name
	local presetColor = preset.Color
	createButton(settingsPage.Scroll, 6 + presetIndex, "●  " .. presetName, false, UDim2.new(1, 0, 0, 30), function()
		Settings.Accent = presetIndex
		saveSettings()
		setAccent(presetColor)
		showToast("Tema aplicado · " .. presetName, Theme.Accent)
	end)
end

createSlider(settingsPage.Scroll, 12, "Tamanho da interface", 0.7, 1.2, 0.05, multiplier, function(value)
	return string.format("%d%%", math.floor(value * 100 + 0.5))
end, function(value)
	multiplier = value
	Settings.Scale = value
	saveSettings()
	tween(scale, 0.35, { Scale = targetScale() }, Enum.EasingStyle.Back)
end)

createSwitchRow(settingsPage.Scroll, 13, "Desfoque do cenário", "Aplica um desfoque suave ao cenário atrás da janela.", SWITCH_HEIGHT, Settings.Blur, function(state)
	Settings.Blur = state
	saveSettings()
	updateBlur()
end)

createSwitchRow(settingsPage.Scroll, 14, "Partículas de fundo", "Exibe partículas discretas no plano de fundo.", SWITCH_HEIGHT, Settings.Particles, function(state)
	particlesEnabled = state
	Settings.Particles = state
	saveSettings()
end)

createSwitchRow(settingsPage.Scroll, 15, "Linhas de varredura", "Adiciona linhas animadas ao fundo da interface.", SWITCH_HEIGHT, Settings.Scanline, function(state)
	scanline.Visible = state
	Settings.Scanline = state
	saveSettings()
end)

local keybindButton = nil

createSwitchRow(settingsPage.Scroll, 3, "Visualização do parkour", "Destaca os trechos de parkour em vermelho para conferência visual.", SWITCH_HEIGHT, Settings.Preview, function(state)
	Settings.Preview = state
	PreviewMode = state
	for _, key in ipairs(ModuleOrder) do BridgeManager.Rebuild(key) end
	saveSettings()
	showToast(state and "Prévia do parkour ativada." or "Prévia do parkour desativada.", state and Theme.Success or Theme.TextDim)
end)

createSwitchRow(settingsPage.Scroll, 4, "Restaurar rotas", "Reativa automaticamente as rotas salvas na sessão anterior.", SWITCH_HEIGHT, Settings.AutoRestoreBridges, function(state)
	Settings.AutoRestoreBridges = state
	saveSettings()
end)

createSwitchRow(settingsPage.Scroll, 5, "Desempenho aprimorado", "Reduz os efeitos visuais para priorizar a fluidez.", SWITCH_HEIGHT, Settings.PerformanceMode, function(state)
	Settings.PerformanceMode = state
	for _, layer in ipairs(glowLayers) do layer.Visible = not state end
	for _, line in ipairs(gridLines) do line.Visible = not state end
	statusOrb.Visible = not state
	statusRing.Visible = not state
	statusRingStroke.Enabled = not state
	particleLayer.Visible = not state
	scanline.Visible = not state and Settings.Scanline
	particlesEnabled = Settings.Particles and not state
	updateBlur()
	saveSettings()
end)
if Settings.PerformanceMode then
	for _, layer in ipairs(glowLayers) do layer.Visible = false end
	for _, line in ipairs(gridLines) do line.Visible = false end
	statusOrb.Visible = false
	statusRing.Visible = false
	statusRingStroke.Enabled = false
	particleLayer.Visible = false
	scanline.Visible = false
	particlesEnabled = false
end

sectionLabel(settingsPage.Scroll, 16, "PREFERÊNCIAS DO SISTEMA")

createSwitchRow(settingsPage.Scroll, 17, "Animação de entrada", "Exibe a animação de abertura ao iniciar o Nexus Hub.", SWITCH_HEIGHT, Settings.Intro, function(state)
	Settings.Intro = state
	saveSettings()
end)

if UserInputService.TouchEnabled then
	createSwitchRow(
		settingsPage.Scroll,
		18,
		"Atalho por três dedos",
		"Use três dedos na tela para ocultar ou exibir a janela.",
		SWITCH_HEIGHT,
		Settings.Gesture,
		function(state)
			Settings.Gesture = state
			saveSettings()
			refreshHints()
			showToast(
				state and "Atalho por três dedos ativado." or "Atalho por três dedos desativado.",
				state and Theme.Success or Theme.TextDim
			)
		end
	)
end

if not IS_TOUCH then
	keybindButton = createButton(settingsPage.Scroll, 19, "", false, UDim2.new(1, 0, 0, 32), function()
		capturingKey = true
		keybindButton.Text = "PRESSIONE UMA TECLA…  (ESC PARA CANCELAR)"
	end)
	keybindButton.Text = ("ATALHO PARA OCULTAR  ·  " .. toggleKey.Name:upper())
end

createButton(settingsPage.Scroll, 20, "CENTRALIZAR JANELA", false, UDim2.new(1, 0, 0, 32), function()
	tween(holder, 0.5, { Position = centeredPosition() }, Enum.EasingStyle.Back)
	showToast("JANELA CENTRALIZADA", Theme.Accent)
end)

-- ==========================================
-- SEÇÃO DE CRÉDITOS E DESENVOLVEDOR
-- Escopo isolado para não aumentar os registradores locais do bloco principal.
-- ==========================================
do
	local DEVELOPER_NAME = "onetime.999"
	sectionLabel(settingsPage.Scroll, 21, "CRÉDITOS E DESENVOLVIMENTO")

local creditsCard = create("Frame", {
	Name = "CreditsCard",
	LayoutOrder = 22,
	Size = UDim2.new(1, 0, 0, 68),
	BackgroundColor3 = Theme.Card,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	ZIndex = 4,
	Parent = settingsPage.Scroll,
}, { corner(8) })

local creditsStroke = stroke(creditsCard, Theme.Accent, 0.25)

local creditsAccentBar = create("Frame", {
	Name = "AccentBar",
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 0, 0.5, 0),
	Size = UDim2.new(0, 3, 1, -16),
	BackgroundColor3 = Theme.Accent,
	BorderSizePixel = 0,
	ZIndex = 5,
	Parent = creditsCard,
}, { circle() })

local devBadge = create("Frame", {
	Name = "DevBadge",
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -12, 0, 8),
	Size = UDim2.fromOffset(88, 18),
	BackgroundColor3 = Theme.Panel,
	BorderSizePixel = 0,
	ZIndex = 5,
	Parent = creditsCard,
}, { corner(6) })

local devBadgeStroke = stroke(devBadge, Theme.Accent, 0.3)

local devBadgeLabel = textLabel({
	Size = UDim2.fromScale(1, 1),
	Text = "CRIADOR OFICIAL",
	Font = Theme.Mono,
	TextSize = 8,
	TextColor3 = Theme.Accent,
	TextXAlignment = Enum.TextXAlignment.Center,
	ZIndex = 6,
	Parent = devBadge,
})

local devTitleLabel = textLabel({
	Name = "DevTitle",
	Position = UDim2.fromOffset(14, 8),
	Size = UDim2.new(1, -110, 0, 18),
	RichText = true,
	Font = Theme.Title,
	TextSize = 13,
	ZIndex = 5,
	Parent = creditsCard,
})

textLabel({
	Name = "DevRole",
	Position = UDim2.fromOffset(14, 28),
	Size = UDim2.new(1, -28, 0, 14),
	Text = "Arquitetura, Interface, Parkour & Auto Interact",
	Font = Theme.Body,
	TextColor3 = Theme.TextDim,
	TextSize = 10,
	ZIndex = 5,
	Parent = creditsCard,
})

textLabel({
	Name = "DevFooter",
	Position = UDim2.fromOffset(14, 46),
	Size = UDim2.new(1, -28, 0, 13),
	Text = "NEXUS HUB PROFESSIONAL  ·  EDIÇÃO EXCLUSIVA",
	Font = Theme.Mono,
	TextColor3 = Theme.TextDim,
	TextSize = 9,
	ZIndex = 5,
	Parent = creditsCard,
})

bindAccent(function()
	creditsStroke.Color = Theme.Accent
	creditsAccentBar.BackgroundColor3 = Theme.Accent
	devBadgeStroke.Color = Theme.Accent
	devBadgeLabel.TextColor3 = Theme.Accent
	devTitleLabel.Text = string.format('Desenvolvido por <font color="#%s">%s</font>', Theme.Accent:ToHex(), DEVELOPER_NAME)
end)

createButton(settingsPage.Scroll, 23, "COPIAR DISCORD / TAG · ONETIME.999", true, UDim2.new(1, 0, 0, 32), function()
	local copied = false
	if type(setclipboard) == "function" then
		local ok = pcall(function()
			setclipboard(DEVELOPER_NAME)
		end)
		copied = ok
	elseif type(toclipboard) == "function" then
		local ok = pcall(function()
			toclipboard(DEVELOPER_NAME)
		end)
		copied = ok
	end

	if copied then
		showToast("Tag copiada: " .. DEVELOPER_NAME, Theme.Success)
	else
		showToast("Desenvolvido por " .. DEVELOPER_NAME, Theme.Accent)
	end
end)
end -- fim do escopo isolado dos créditos

sectionLabel(settingsPage.Scroll, 24, "SOBRE O NEXUS HUB")

local aboutCard = create("Frame", {
	Name = "About",
	LayoutOrder = 25,
	Size = UDim2.new(1, 0, 0, 82),
	BackgroundColor3 = Theme.Card,
	BorderSizePixel = 0,
	ZIndex = 4,
	Parent = settingsPage.Scroll,
}, { corner(8) })

stroke(aboutCard)

local aboutLines = {
	{ Text = "NEXUS HUB · V1.2", Font = Theme.Title, Size = 11, Color = Theme.Text },
	{ Text = "DESENVOLVIDO POR ONETIME.999", Font = Theme.Mono, Size = 9, Color = Theme.Success },
	{ Text = IS_TOUCH and "TOQUE EM [N] OU USE 3 DEDOS · MOSTRAR/OCULTAR" or "TECLA N OU ATALHO · MOSTRAR/OCULTAR", Font = Theme.Mono, Size = 9, Color = Theme.TextDim },
	{ Text = IS_TOUCH and "TOQUE · ALTERNAR" or "TECLAS 1–4 · ALTERNAR ROTAS", Font = Theme.Mono, Size = 9, Color = Theme.TextDim },
	{ Text = "ARRASTE A BARRA SUPERIOR PARA MOVER", Font = Theme.Mono, Size = 9, Color = Theme.TextDim },
}

for index, line in ipairs(aboutLines) do
	textLabel({
		Position = UDim2.fromOffset(14, 8 + (index - 1) * 14),
		Size = UDim2.new(1, -28, 0, 13),
		Text = line.Text,
		Font = line.Font,
		TextSize = line.Size,
		TextColor3 = line.Color,
		ZIndex = 5,
		Parent = aboutCard,
	})
end

local function stopGlowPulse()
	for _, glowTween in ipairs(glowTweens) do
		glowTween:Cancel()
	end
	table.clear(glowTweens)
end

local function startGlowPulse()
	if not alive or not visible then
		return
	end
	stopGlowPulse()
	for _, layer in ipairs(glowLayers) do
		local glowTween = TweenService:Create(
			layer.Frame,
			TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
			{ BackgroundTransparency = layer.Base + 0.05 }
		)
		glowTween:Play()
		table.insert(glowTweens, glowTween)
	end
end

local function scrambleText(target, finalText, duration)
	if target and target.Parent then
		target.Text = finalText
	end
end

local function playIntro()
	if introPlayed or not Settings.Intro then
		introPlayed = true
		return
	end
	introPlayed = true

	local splash = create("CanvasGroup", {
		Name = "Splash",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		Active = true,
		ZIndex = 60,
		Parent = main,
	}, { corner(14) })

	textLabel({
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, -30),
		Size = UDim2.new(1, 0, 0, 34),
		Text = string.format('NEXUS <font color="#%s">HUB</font>', Theme.Accent:ToHex()),
		Font = Theme.Title,
		RichText = true,
		TextSize = 28,
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 61,
		Parent = splash,
	})

	local status = textLabel({
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 2),
		Size = UDim2.new(1, 0, 0, 14),
		Text = "INICIANDO O NEXUS HUB",
		Font = Theme.Mono,
		TextColor3 = Theme.TextDim,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 61,
		Parent = splash,
	})

	local track = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 24),
		Size = UDim2.fromOffset(200, 4),
		BackgroundColor3 = Theme.Track,
		BorderSizePixel = 0,
		ZIndex = 61,
		Parent = splash,
	}, { circle() })

	local fill = create("Frame", {
		Size = UDim2.fromScale(0, 1),
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		ZIndex = 62,
		Parent = track,
	}, { circle() })

	textLabel({
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 46),
		Size = UDim2.new(1, 0, 0, 14),
		Text = "Desenvolvido por onetime.999",
		Font = Theme.Mono,
		TextColor3 = Theme.Accent,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 61,
		Parent = splash,
	})

	local duration = 1.3
	local messages = { "INICIANDO O NEXUS HUB", "PREPARANDO PARKOUR", "CARREGANDO AUTO INTERACT", "DESENVOLVIDO POR ONETIME.999" }

	tween(fill, duration, { Size = UDim2.fromScale(1, 1) }, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

	task.spawn(function()
		for _, message in ipairs(messages) do
			if not alive then
				return
			end
			status.Text = message
			task.wait(duration / #messages)
		end

		if not alive then
			return
		end

		local fade = tween(splash, 0.45, { GroupTransparency = 1 })
		fade.Completed:Wait()
		splash:Destroy()
	end)
end

local function playOpen()
	stopGlowPulse()
	holder.Visible = true
	scale.Scale = targetScale() * 0.85
	main.GroupTransparency = 1

	for _, layer in ipairs(glowLayers) do
		layer.Frame.BackgroundTransparency = 1
		tween(layer.Frame, 0.5, { BackgroundTransparency = layer.Base })
	end

	tween(scale, 0.55, { Scale = targetScale() }, Enum.EasingStyle.Back)
	tween(main, 0.4, { GroupTransparency = 0 })
	scrambleText(subtitleLabel, STATUS_TEXT, 0.7)
	updateBlur()

	task.delay(0.6, startGlowPulse)
end

local function playHide(onFinished)
	stopGlowPulse()
	tween(scale, 0.3, { Scale = targetScale() * 0.85 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

	for _, layer in ipairs(glowLayers) do
		tween(layer.Frame, 0.3, { BackgroundTransparency = 1 })
	end

	local fade = tween(main, 0.3, { GroupTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	fade.Completed:Connect(function()
		if onFinished then
			onFinished()
		end
	end)
end

local launcher = create("TextButton", {
	Name = "Launcher",
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -10, 0.4, 0),
	Size = UDim2.fromOffset(IS_TOUCH and 38 or 34, IS_TOUCH and 38 or 34),
	BackgroundColor3 = Theme.Panel,
	BackgroundTransparency = 0.1,
	AutoButtonColor = false,
	Text = "N",
	Font = Theme.Title,
	TextSize = 15,
	TextColor3 = Theme.Accent,
	ZIndex = 20,
	Parent = screenGui,
}, { circle() })

local launcherStroke = create("UIStroke", {
	Color = Theme.Accent,
	Thickness = 1.5,
	Parent = launcher,
})

bindAccent(function()
	launcher.TextColor3 = Theme.Accent
	launcherStroke.Color = Theme.Accent
end)

local launcherToken = 0

local function setLauncherVisible(value)
	launcherToken += 1
	local token = launcherToken

	if value then
		launcher.Visible = true
		tween(launcher, 0.3, { BackgroundTransparency = 0.1, TextTransparency = 0 })
		tween(launcherStroke, 0.3, { Transparency = 0 })
	else
		tween(launcher, 0.25, { BackgroundTransparency = 1, TextTransparency = 1 })
		local fade = tween(launcherStroke, 0.25, { Transparency = 1 })
		fade.Completed:Connect(function()
			if token == launcherToken then
				launcher.Visible = false
			end
		end)
	end
end

local function setVisible(value, withLauncher)
	if closing or value == visible then
		return
	end
	visible = value

	if value then
		setLauncherVisible(true)
		playOpen()
	else
		if withLauncher then
			setLauncherVisible(false)
		end
		updateBlur()
		playHide(function()
			if not visible then
				holder.Visible = false
			end
		end)
	end
end

local function setMinimized(value)
	if closing then
		return
	end
	minimized = value

	minimizeBar.Visible = not value
	restoreBox.Visible = value

	if value then
		local collapse = tween(holder, 0.4, { Size = UDim2.fromOffset(WIDTH, HEADER) })
		collapse.Completed:Connect(function()
			if minimized then
				body.Visible = false
			end
		end)
	else
		body.Visible = true
		tween(holder, 0.45, { Size = UDim2.fromOffset(WIDTH, HEIGHT) }, Enum.EasingStyle.Back)
	end
end

local function destroyInterface()
	if closing then
		return
	end
	closing = true
	alive = false
	if autoMinigameActive then
		autoMinigameActive = false
		autoMinigameReady = false
		restaurarControlesMobile()
	end

	BridgeManager.Clear()
	saveToken += 1
	writeSettings()
	updateBlur()

	playHide(function()
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		table.clear(connections)
		blurEffect:Destroy()
		screenGui:Destroy()
	end)
end

connect(launcher.MouseButton1Click, function()
	setVisible(not visible)
end)

connect(closeButton.MouseButton1Click, destroyInterface)

connect(minimizeButton.MouseButton1Click, function()
	setMinimized(not minimized)
end)

local numberKeys = {
	[Enum.KeyCode.One] = 1,
	[Enum.KeyCode.Two] = 2,
	[Enum.KeyCode.Three] = 3,
	[Enum.KeyCode.Four] = 4,
}

connect(UserInputService.InputBegan, function(input, processed)
	if capturingKey and input.UserInputType == Enum.UserInputType.Keyboard then
		capturingKey = false

		if input.KeyCode ~= Enum.KeyCode.Escape and input.KeyCode ~= Enum.KeyCode.Unknown then
			toggleKey = input.KeyCode
			Settings.ToggleKey = input.KeyCode.Name
			saveSettings()
			showToast(("ATALHO PARA OCULTAR  ·  " .. toggleKey.Name:upper()), Theme.Accent)
		end

		if keybindButton then
			keybindButton.Text = ("ATALHO PARA OCULTAR  ·  " .. toggleKey.Name:upper())
		end
		refreshHints()
		return
	end

	if processed or closing then
		return
	end

	if input.KeyCode == toggleKey then
		setVisible(not visible, true)
		return
	end

	local moduleIndex = numberKeys[input.KeyCode]
	if moduleIndex and visible then
		local key = ModuleOrder[moduleIndex]
		local toggle = key and bridgeToggles[key]
		if toggle then
			toggle.Set(not toggle.Get())
		end
	end
end)

if camera then
	connect(camera:GetPropertyChangedSignal("ViewportSize"), function()
		if visible and not closing then
			tween(scale, 0.3, { Scale = targetScale() })
		end
	end)
end

local dragging = false
local dragStart = Vector2.zero
local dragOrigin = Vector2.zero
local dragStartPosition = holder.Position

connect(topBar.InputBegan, function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = Vector2.new(input.Position.X, input.Position.Y)
		dragOrigin = holder.AbsolutePosition
		dragStartPosition = holder.Position

		local changed
		changed = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				changed:Disconnect()
			end
		end)
	end
end)

connect(UserInputService.InputChanged, function(input)
	if not dragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart

		local boundsPosition = screenGui.AbsolutePosition
		local boundsSize = screenGui.AbsoluteSize
		local size = holder.AbsoluteSize

		local minX = boundsPosition.X - dragOrigin.X
		local maxX = boundsPosition.X + boundsSize.X - size.X - dragOrigin.X
		local minY = boundsPosition.Y - dragOrigin.Y
		local maxY = boundsPosition.Y + boundsSize.Y - HEADER * scale.Scale - dragOrigin.Y

		local deltaX = math.clamp(delta.X, math.min(0, minX, maxX), math.max(0, minX, maxX))
		local deltaY = math.clamp(delta.Y, math.min(0, minY, maxY), math.max(0, minY, maxY))

		holder.Position = UDim2.new(
			dragStartPosition.X.Scale,
			dragStartPosition.X.Offset + deltaX,
			dragStartPosition.Y.Scale,
			dragStartPosition.Y.Offset + deltaY
		)
	end
end)

local GESTURE_FINGERS = 3
local GESTURE_WINDOW = 0.3
local GESTURE_HOLD = 0.4
local GESTURE_COOLDOWN = 0.9

local touchStarts = {}
local gestureReady = true

local function touchIsDown(touch)
	return touchStarts[touch] ~= nil
		and touch.UserInputState ~= Enum.UserInputState.End
		and touch.UserInputState ~= Enum.UserInputState.Cancel
end

connect(UserInputService.InputBegan, function(input)
	if input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	local now = os.clock()
	touchStarts[input] = now

	if not Settings.Gesture or closing or not gestureReady then
		return
	end

	local group = {}
	for touch, startedAt in pairs(touchStarts) do
		if now - startedAt <= GESTURE_WINDOW and touchIsDown(touch) then
			table.insert(group, touch)
		end
	end

	if #group < GESTURE_FINGERS then
		return
	end

	gestureReady = false

	task.delay(GESTURE_HOLD, function()
		local held = alive and not closing and Settings.Gesture

		for _, touch in ipairs(group) do
			if not touchIsDown(touch) then
				held = false
				break
			end
		end

		if held then
			dragging = false
			setVisible(not visible, true)
		end

		task.delay(GESTURE_COOLDOWN, function()
			gestureReady = true
		end)
	end)
end)

connect(UserInputService.InputEnded, function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		touchStarts[input] = nil
	end
end)

local frameCount = 0
local frameTime = 0

connect(RunService.RenderStepped, function(deltaTime)
	if not Settings.PerformanceMode then
		borderGradient.Rotation = (borderGradient.Rotation + deltaTime * 70) % 360
	end

	frameCount += 1
	frameTime += deltaTime

	if frameTime >= 0.5 then
		local fps = math.floor(frameCount / frameTime + 0.5)
		local ping = 0

		pcall(function()
			ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
		end)

		statsLabel.Text = string.format("%d FPS  |  %d MS", fps, ping)

		if fps >= 45 then
			statsLabel.TextColor3 = Theme.Success
		elseif fps >= 25 then
			statsLabel.TextColor3 = Color3.fromRGB(255, 180, 50)
		else
			statsLabel.TextColor3 = Color3.fromRGB(255, 70, 100)
		end

		frameCount = 0
		frameTime = 0
	end
end)

TweenService:Create(
	statusOrb,
	TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
	{ BackgroundTransparency = 0.55 }
):Play()

TweenService:Create(
	statusRing,
	TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, false),
	{ Size = UDim2.fromOffset(22, 22) }
):Play()

TweenService:Create(
	statusRingStroke,
	TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, false),
	{ Transparency = 1 }
):Play()

TweenService:Create(
	scanline,
	TweenInfo.new(3.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, false),
	{ Position = UDim2.fromScale(0, 1) }
):Play()

local function spawnParticle()
	if minimized or not visible or not particlesEnabled or Settings.PerformanceMode then
		return
	end

	local size = math.random(2, 4)
	local lifetime = math.random(40, 80) / 10
	local horizontal = math.random()

	local particle = create("Frame", {
		Size = UDim2.fromOffset(size, size),
		Position = UDim2.new(horizontal, 0, 1, 6),
		BackgroundColor3 = math.random() > 0.5 and Theme.Accent or accentAlt(),
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		ZIndex = 1,
		Parent = particleLayer,
	}, { circle() })

	tween(particle, lifetime, {
		Position = UDim2.new(horizontal, 0, 0, -8),
		BackgroundTransparency = 1,
	}, Enum.EasingStyle.Linear)

	task.delay(lifetime + 0.1, function()
		particle:Destroy()
	end)
end

task.spawn(function()
	while alive do
		spawnParticle()
		task.wait(0.35)
	end
end)

lockLocalization(screenGui)
screenGui.Parent = PlayerGui
selectPage("PARKOUR")
playOpen()
playIntro()