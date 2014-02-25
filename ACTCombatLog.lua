--
-- Combat Log - LUA
--
-- Author:  @Lodur
-- Github:  www.github.com/nilsbrummond/ESO-Plugin-CombatLog
--
-- Usage Notes:   /combatlog      - toggle logging
--                /combatlog on   - turn on logging
--                /combatlog off  - turn off logging
--
--
-- 1. Create a chat tab for combat log messages.
-- 2. Use the /chatlog command to save chat to file
-- 3. Output log messages for:
--    zone changes
--    character changes (login)
--    combat messages
--    magika / stamina / ultimate pool changes
--    buff / debuffs - start/end/purged, etc...
--    Deaths
--    Synergy available
--
--    misses? 
--
--
-- Combat log format:
-- TBD - need more API info.
-- 
-- Possible:
-- CL:time:owner:source:target:event_type:ability_name:dmg_type:dmg:flags
--
--

CombatLog = {}
CombatLog.version = 0.01

local Enumerations = GetEnumerations()

CombatLog.Initialize = function( self, addOnName )

  -- Only Init us...
  if addOnName ~= "CombatLog" then return end

  local defaults = 
  {
    logging = false,
  }

  CombatLog.savedVars = ZO_SavedVars:New(
    "CombatLogVars",
    math.floor( CombatLog.version * 100 ),
    nil,
    defaults,
    nil)

  CombatLog.SetupCombatChatChannel()

  if CombatLog.savedVars.logging then
    CombatLog.Start()
  end

  -- Combat
  EVENT_MANAGER:RegisterForEvent( 
    "CombatLog", EVENT_COMBAT_EVENT, CombatLog.EventCombat )
  EVENT_MANAGER:RegisterForEvent( 
    "CombatLog", EVENT_UNIT_DEATH_STATE_CHANGED, CombatLog.EventUnitDeathState )
  -- EVENT_PLAYER_DEAD?
  -- EVENT_PLAYER_DEATH_INFO_UPDATE?

  -- EVENT_UNIT_ATTRIBUTE_VISUAL_ADDED
  -- EVENT_UNIT_ATTRIBUTE_VISUAL_REMOVED
  -- EVENT_UNIT_ATTRIBUTE_VISUAL_UPDATED
  -- EVENT_UNIT_FRAME_UPDATE
  -- EVENT_PLAYER_COMBAT_STATE
  -- EVENT_STEALTH_STATE_CHANGED
  
  -- EVENT_ACTIVE_WEAPON_PAIR_CHANGED ??

  -- Buffs / Debuffs
  
  -- EVENT_MANAGER:RegisterForEvent( 
  -- "CombatLog", EVENT_EFFECTS_FULL_UPDATE, CombatLog.EventEffectChanged )
  -- EVENT_MANAGER:RegisterForEvent( 
  -- "CombatLog", EVENT_EFFECT_CHANGED, CombatLog.EventEffectChanged )

  
  -- Casting
  EVENT_MANAGER:RegisterForEvent( 
    "CombatLog", EVENT_BEGIN_CAST, CombatLog.EventBeginCast )
  EVENT_MANAGER:RegisterForEvent( 
    "CombatLog", EVENT_DELAY_CAST, CombatLog.EventDelayCast )
  EVENT_MANAGER:RegisterForEvent( 
    "CombatLog", EVENT_END_CAST, CombatLog.EventEndCast )

  -- Synergy
  EVENT_MANAGER:RegisterForEvent( 
    "CombatLog", EVENT_SYNERGY_ABILITY_GAINED, CombatLog.EventSynergyGained )
  EVENT_MANAGER:RegisterForEvent( 
    "CombatLog", EVENT_SYNERGY_ABILITY_LOST, CombatLog.EventSynergyLost )

  -- Revenge Kill
  EVENT_MANAGER:RegisterForEvent( 
    "CombatLog", EVENT_REVENGE_KILL, CombatLog.EventRevengeKill )

  -- Zone Changes
  EVENT_MANAGER:RegisterForEvent( 
    "CombatLog", EVENT_ZONE_CHANGED, CombatLog.EventZoneChanged )


end

CombatLog.EventCombat = function(
  eventCode , result , isError ,
  abilityName, abilityGraphic, abilityActionSlotType,
  sourceName, sourceType, targetName, targetType,
  hitValue, powerType, damageType, log )

 -- result                    = ACTION_RESULT_* 
 -- abilityActionSlotType     = ACTION_SLOT_TYPE_*
 -- sourceType / tartgetType  = COMBAT_UNIT_TYPE_*
 -- powerType                 = POWERTYPE_*
 -- damageType                = DAMAGE_TYPE_*
 
  -- Dump combat events 
	d( "[" .. result .. "]," .. "[" .. abilityName .. "]," .. "[" .. sourceName .. "]," .. 
     "[" .. sourceType .. "]," .. "[" .. targetName .. "]," .. "[" .. targetType .. "]," .. 
     "[" .. hitValue .. "]," .. "[" .. abilityActionSlotType .. "]," .. "[" .. powerType .. "]," .. 
     "[" .. damageType .. "]" .. "[" .. log .. "]" )

  if isError then return end

  

end

CombatLog.SetupCombatChatChannel = function()
  -- JoinChatChannel??
  -- AddChatContainerTab
  -- SetChatContainerTabCategoryEnabled
  --
  -- Use LogChatText() or d() ???
  

end

CombatLog.SetLoggingState = function(active)
  if active then
    -- Register for events
    -- turn on /chatlog
  else
    -- turn off /chatlog
    -- Deregister for events

  end
end

CombatLog.CommandHandler = function(text)
  if text == "" then
    CombatLog.SetLoggingState(not CombatLog.loggingState)
  elseif text == "on" then
    CombatLog.SetLoggingState(true)
  elseif text == "off" then
    CombatLog.SetLoggingState(false)
  end
end

-- Init Hook --
EVENT_MANAGER:RegisterForEvent( 
  "CombatLog", EVENT_ADD_ON_LOADED, CombatLog.Initialize )

-- Slash Commands --
SLASH_COMMANDS["/combatlog"] = CombatLog.CommandHandler
