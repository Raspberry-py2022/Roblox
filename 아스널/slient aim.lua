local plr = game.Players
local clinet = plr.LocalPlayer
local mouse = clinet:GetMouse()
local cam = workspace.CurrentCamera

local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

--Global variable
local g_variable = {
    Target = nil;
}

local getplayer = function()
    local Target = nil
    local max_distan = 100 -- 늘려주면 감지범위 늘어남

    for i,v in pairs(plr:GetPlayers()) do
        if v ~= clinet and v.Team ~= clinet.Team and v.Character ~= nil then
            local pos,onscreen = cam:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            local distan = (Vector2.new(pos.X,pos.Y) - uis:GetMouseLocation()).Magnitude

            if onscreen and distan < max_distan then
                Target = v
                max_distan = distan
            end
        end
    end

    return Target
end

--oldNmaecall

local RemoteName = utf8.char(8203, 72, 105, 116, 80, 97, 114, 116)

local onc
onc = hookmetamethod(game,"__namecall",function(self,...)
    local Args = { ... }
    if (getnamecallmethod() == "FireServer" and self.Name == RemoteName and g_variable.Target) then
        Args[1] = g_variable.Target.Character.HumanoidRootPart
    end

    return onc(self,unpack(Args))
end)

local lined = Drawing.new("Line")
lined.Color = Color3.fromRGB(255,255,255)
lined.From = cam.ViewportSize/2
lined.Thickness = 1
lined.Opacity = 1

local Nametag = Drawing.new("Text")
Nametag.Color = Color3.fromRGB(255,255,255)
Nametag.Size = 13

runService.RenderStepped:Connect(function(deltaTime)
    local Target = getplayer()
    g_variable.Target = Target

    if Target then
        local pos,onscreen = cam:WorldToViewportPoint(Target.Character.HumanoidRootPart.Position)
        lined.Visible = true
        Nametag.Visible = true
        lined.To = Vector2.new(pos.X,pos.Y)
        Nametag.Position = Vector2.new(pos.X,pos.Y - 10)
        Nametag.Text = Target.Name
        
    else
        lined.Visible = false
        Nametag.Visible = false
    end
end)
