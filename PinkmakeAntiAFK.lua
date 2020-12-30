require("common.log")
module("Pinkmare AntiAFK", package.seeall, log.setup)

local _SDK = _G.CoreEx
local Console, ObjManager, EventManager, Geometry, Input, Renderer, Enums, Game = _SDK.Console, _SDK.ObjectManager, _SDK.EventManager, _SDK.Geometry, _SDK.Input, _SDK.Renderer, _SDK.Enums, _SDK.Game
local Menu, Orbwalker, Collision, Prediction, HealthPred = _G.Libs.NewMenu, _G.Libs.Orbwalker, _G.Libs.CollisionLib, _G.Libs.Prediction, _G.Libs.HealthPred
local DmgLib, ImmobileLib, Spell = _G.Libs.DamageLib, _G.Libs.ImmobileLib, _G.Libs.Spell
local SpellSlots, SpellStates = Enums.SpellSlots, Enums.SpellStates
local Spell = _G.Libs.Spell
local Vector  = Geometry.Vector
local BuffInst

local AntiAFK = {}
local LastPos
local LastMoveTime = 0
local MoveState = 0

function AntiAFK.LoadMenu()
    Menu.RegisterMenu("PinkmareAntiAFK", "Pinkmare AntiAFK", function()
       Menu.Checkbox("Enabled", "Enabled", false)
    end)
end

function AntiAFK.OnTick()
	if Menu.Get("Enabled") then
		local gameTime = Game.GetTime()
	
		if gameTime > LastMoveTime + 15 then
			local myPos = Player.Position
			if myPos ~= LastPos then
				LastPos = myPos
				LastMoveTime = gameTime
			else
				LastMoveTime = gameTime
				if MoveState == 0 then
					NewMove = Vector(myPos.x + 100, myPos.y + 100, myPos.z)
					LastPos = NewMove
					Input.MoveTo(NewMove)
					MoveState = 1
				else
					NewMove = Vector(myPos.x - 100, myPos.y - 100, myPos.z)
					LastPos = NewMove
					Input.MoveTo(NewMove)
					MoveState = 0
				end
			end
		end
	end
end

function AntiAFK.OnDraw()
	if Menu.Get("Enabled") then
		Renderer.DrawText(Player.Position:ToScreen(), {x=100,y=50}, "Anti AFK Enabled", 0x00FF00FF)
	end
end

function OnLoad()
    AntiAFK.LoadMenu()
    for eventName, eventId in pairs(Enums.Events) do
		if AntiAFK[eventName] then
			EventManager.RegisterCallback(eventId, AntiAFK[eventName])
        end
    end
	
	return true
end