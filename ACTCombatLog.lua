--
-- ACT Combat Log - LUA
--
-- Author:  @Lodur
-- Github:  www.github.com/nilsbrummond/ESO-ACT-CombatLogging
--
-- Usage Notes:   /combatlog      - toggle logging
--                /combatlog on   - turn on logging
--                /combatlog off  - turn off logging
--
--
-- Objectives
--  1. Log combat events to a file.
--      -- A file is required from use with ACT.
--  2. Combat log file to be human readable.
--      -- Much easier to debug and understand.
--  3. Minimize changes to log file based on changes from ESO.
--      -- No magic numbers
--      -- Hopefully ACT will be able to read older log files
--          even when ESO changes.
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

-- Global

ACTCombatLog = {}
ACTCombatLog.version = 0.01
ACTCombatLog.enabled = false

ACTCombatLog.Enable  = function() SetEnabled(true) end
ACTCombatLog.Disable = function() SetEnabled(false) end

-- Local

local 

local Enumerations = GetEnumerations()

local function Initialize( self, addOnName )

  -- Only Init us...
  if addOnName ~= "ACTCombatLog" then return end

  local defaults = 
  {
    logging = false,
  }

  ACTCombatLog.savedVars = ZO_SavedVars:New(
    "ACTCombatLogVars",
    math.floor( ACTCombatLog.version * 100 ),
    nil, defaults, nil)


  if ACTCombatLog.savedVars.logging then
    ACTCombatLog.Start()
  end
 

  ACTCombatLog.SetupCombatChatChannel()


  -- Combat
  EVENT_MANAGER:RegisterForEvent( 
    "ACTCombatLog", EVENT_COMBAT_EVENT, EventCombat )

  -- EVENT_UNIT_DEATH_STATE_CHANGED
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
  EVENT_MANAGER:RegisterForEvent( 
    "ACTCombatLog", EVENT_EFFECTS_FULL_UPDATE, EventFullEffectChanged )
  EVENT_MANAGER:RegisterForEvent( 
    "ACTCombatLog", EVENT_EFFECT_CHANGED, EventEffectChanged )

  
  -- Casting
  -- EVENT_BEGIN_CAST
  -- EVENT_DELAY_CAST
  -- EVENT_END_CAST

  -- Synergy
  EVENT_MANAGER:RegisterForEvent( 
    "ACTCombatLog", EVENT_SYNERGY_ABILITY_GAINED, EventSynergyGained )
  EVENT_MANAGER:RegisterForEvent( 
    "ACTCombatLog", EVENT_SYNERGY_ABILITY_LOST, EventSynergyLost )

  -- Revenge Kill
  EVENT_MANAGER:RegisterForEvent( 
    "ACTCombatLog", EVENT_REVENGE_KILL, EventRevengeKill )

  -- Zone Changes
  EVENT_MANAGER:RegisterForEvent( 
    "ACTCombatLog", EVENT_ZONE_CHANGED, EventZoneChanged )


  ACTCombatLog.enabled = true
end


-- Write to the combat log...
local function Log(type, ...)

  str = "[" .. type .. "]"
  for _,v in ipairs(arg) do
    str = str .. "[" .. v .. "]"
  end

  -- TODO better way to do this?
  d (str)

end


local function EventCombat(
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
	Log( "CMBT", eventCode , result , isError ,
       abilityName, abilityGraphic, abilityActionSlotType,
       sourceName, sourceType, targetName, targetType,
       hitValue, powerType, damageType, log )

  if isError then return end
  

end

local function EventEffectFullChanged()

  Log ( "EFFF" )

end

local function EventEffectChanged(changeType, effectSlot, effectName,
  unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType,
  abilityType, statusEffectType)

  Log ( "EFFC", changeType, effectSlot, effectName, unitTag, beginTime,
        endTime, stackCount, iconName, buffType, effectType, abilityType, 
        statusEffectType )

end

local function EventSynergyGained(
  synergyBuffSlot, grantedAbilityName, beginTime, endTime, iconName)

  Log ( "SYNG", "Gain", synergyBuffSlot, grantedAbilityName,
        beginTime, endTime, iconName)

end


local function EventSynergyLost(synergyBuffSlot)

  Log ( "SYNG",  "Lost", synergyBuffSlot )

end

local function EventRevengeKill(killedPlayerName)

  Log( "RVNG", killedPlayerName )

end


local function EventZoneChanged(zoneName, subZoneName, newSubzone)

  Log( "ZONE", zoneName, subZoneName, newSubzone )

end


local function SetupCombatChatChannel()
  -- JoinChatChannel??
  -- AddChatContainerTab
  -- SetChatContainerTabCategoryEnabled
  --
  -- Use LogChatText() or d() ???
  

end

local function SetLoggingState(active)
  if active then
    -- Register for events
    -- turn on /chatlog
  else
    -- turn off /chatlog
    -- Deregister for events

  end
end

local function CommandHandler(text)
  if text == "" then
    SetLoggingState(not loggingState)
  elseif text == "on" then
    SetLoggingState(true)
  elseif text == "off" then
    SetLoggingState(false)
  end
end

-- Init Hook --
EVENT_MANAGER:RegisterForEvent( 
  "ACTCombatLog", EVENT_ADD_ON_LOADED, Initialize )

-- Slash Commands --
SLASH_COMMANDS["/combatlog"] = CommandHandler
