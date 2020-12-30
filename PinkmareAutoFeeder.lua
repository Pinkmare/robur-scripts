require("common.log")
module("Pinkmare AutoFeeder", package.seeall, log.setup)

local _SDK = _G.CoreEx
local Console, ObjManager, EventManager, Geometry, Input, Renderer, Enums, Game = _SDK.Console, _SDK.ObjectManager, _SDK.EventManager, _SDK.Geometry, _SDK.Input, _SDK.Renderer, _SDK.Enums, _SDK.Game
local Menu, Orbwalker, Collision, Prediction, HealthPred = _G.Libs.NewMenu, _G.Libs.Orbwalker, _G.Libs.CollisionLib, _G.Libs.Prediction, _G.Libs.HealthPred
local DmgLib, ImmobileLib, Spell = _G.Libs.DamageLib, _G.Libs.ImmobileLib, _G.Libs.Spell
local SpellSlots, SpellStates = Enums.SpellSlots, Enums.SpellStates
local Spell = _G.Libs.Spell
local Vector  = Geometry.Vector

local AutoFeeder = {}
local LastMoveTime = 0

function AutoFeeder.LoadMenu()
    Menu.RegisterMenu("PinkmareAutoFeeder", "Pinkmare AutoFeeder", function()
       Menu.Checkbox("Enabled", "Enabled", false)
    end)
end

local GetSpawnPosition = function()
    return Player.TeamId == 100 and Vector(14302, 172, 14387) or Vector(415, 182, 415)
end

function AutoFeeder.OnTick()
	if Menu.Get("Enabled") then		
		if Player.IsAlive then
			local SpawnPos = GetSpawnPosition()
			local gameTime = Game.GetTime()
			if gameTime > LastMoveTime + 1 then
				Input.MoveTo(SpawnPos)
				LastMoveTime = gameTime
			end
		end
	end
end

function AutoFeeder.OnDraw()
	if Menu.Get("Enabled") then
		Renderer.DrawText(Player.Position:ToScreen(), {x=100,y=50}, "Auto Feeder Enabled", 0x00FF00FF)
	end
end

function OnLoad()
    AutoFeeder.LoadMenu()
    for eventName, eventId in pairs(Enums.Events) do
		if AutoFeeder[eventName] then
			EventManager.RegisterCallback(eventId, AutoFeeder[eventName])
        end
    end
	
	return true
end