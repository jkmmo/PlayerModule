local Player = {}
Player.__index = Player
local UserInput = game:GetService("UserInputService")

function Player.new()
	local self = setmetatable({},Player)
	self.Animations = {}
	self.Player = game.Players.LocalPlayer
	self.AutoUpdate = false
	self.Character = self:GetCharacter()
	self.HumanoidRootPart = self:GetRootPart()
	self.Humanoid = self:GetHumanoid()
	self.Mouse = self.Player:GetMouse()
	return self
end

function Player:LoadAnimation(Animation)
	if Animation:IsA("Animation") then
		self.Animations[tostring(Animation)] = self.Humanoid:LoadAnimation(Animation)
	else
		warn(tostring(Animation).." Is not an valid animation")
	end
end

function Player:PlayAnimation(Animation,Event,End)
	local Connect1
	local Connect2
	if self.Animations[Animation] then
		local Animin = self.Animations[Animation]
		Animin:Play()
		if Event then
			Connect1 = Animin:GetMarkerReachedSignal(Event[1]):Connect(function()
				Connect1:Disconnect()
				Event[2]()
			end)
		end
		if End then
			Connect2 = Animin.Stopped:Connect(function()
				Connect2:Disconnect()
				End[1]()
			end)
		end
	end
	return
end

function Player:GetCharacter()
	repeat wait() until self.Player.Character ~= nil
	self.Character = self.Player.Character
	return self.Player.Character
end

function Player:GetRootPart()
	local Hrp = self.Character:WaitForChild("HumanoidRootPart")
	self.HumanoidRootPart = Hrp
	return Hrp
end

function Player:GetHumanoid()
	local Hum = self.Character:WaitForChild("Humanoid")
	self.Humanoid = Hum
	return Hum
end

function Player:Update()
	self.Character = self:GetCharacter()
	self.HumanoidRootPart = self:GetRootPart()
	self.Humanoid = self:GetHumanoid()
end

function Player:UserInput(Callback,Input,TargetKey)
	if Input == "Began" then
		if TargetKey ~= nil then
			UserInput.InputBegan:Connect(function(_Input,Typing)
				if not Typing then
					if _Input.KeyCode == TargetKey then
						Callback()
					end
				end
			end)
		elseif TargetKey == nil then
			UserInput.InputBegan:Connect(Callback)
		end
	elseif Input == "Ended" then
		if TargetKey ~= nil then
			UserInput.InputEnded:Connect(function(_Input,Typing)
				if not Typing then
					if _Input.KeyCode == TargetKey then
						Callback()
					end
				end
			end)
		elseif TargetKey == nil then
			UserInput.InputEnded:Connect(Callback)
		end
	end
end

return Player
