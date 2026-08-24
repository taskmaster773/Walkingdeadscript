local RunService = game:GetService("RunService")

local POOL = 200
local running = true
local targets = {}
local pool = {}

for i = 1, POOL do
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Visible = false

    local tag = Drawing.new("Text")
    tag.Size = 14
    tag.Center = true
    tag.Outline = true
    tag.Color = Color3.fromRGB(255, 255, 255)
    tag.Text = "Zombie"
    tag.Visible = false

    pool[i] = { box = box, tag = tag }
end

task.spawn(function()
    while running do
        local out = {}
        for _, walker in ipairs(game.Workspace.AI.Walkers:GetChildren()) do
            local root = walker:FindFirstChild("HumanoidRootPart")
            local head = walker:FindFirstChild("Head")
            if root and head then
                out[#out + 1] = { root = root, head = head }
            end
        end
        targets = out
        task.wait(0.4)
    end
end)

local conn
conn = RunService.RenderStepped:Connect(function()
    local n = 0
    for _, t in ipairs(targets) do
        if n >= POOL then break end
        local top, v1 = WorldToScreen(t.head.Position + Vector3.new(0, 0.7, 0))
        local bot, v2 = WorldToScreen(t.root.Position - Vector3.new(0, 3.2, 0))
        if v1 and v2 then
            n = n + 1
            local e = pool[n]
            local h = bot.Y - top.Y
            local w = h * 0.5
            e.box.Position = Vector2.new(top.X - w * 0.5, top.Y)
            e.box.Size = Vector2.new(w, h)
            e.box.Visible = true
            e.tag.Position = Vector2.new(top.X, top.Y - 18)
            e.tag.Visible = true
        end
    end
    for i = n + 1, POOL do
        pool[i].box.Visible = false
        pool[i].tag.Visible = false
    end
end)
