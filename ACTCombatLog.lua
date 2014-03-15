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
--    time CODE:...
--
-- NOTE on Events to look at:
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
  -- EVENT_BEGIN_CAST
  -- EVENT_DELAY_CAST
  -- EVENT_END_CAST
  -- EVENT_SYNERGY_ABILITY_GAINED
  -- EVENT_SYNERGY_ABILITY_LOST
  -- EVENT_REVENGE_KILL

-- Global

ACTCombatLog = {}
ACTCombatLog.version = 0.01
ACTCombatLog.enabled = false

ACTCombatLog.Enable  = function() SetEnabled(true) end
ACTCombatLog.Disable = function() SetEnabled(false) end

ACTCombatLog.currentPlayer = nil
ACTCombatLog.currentZone = nil

-- Local

local Convert = GetEnumerations()

-- Fucntions

local function Start()

  ACTCombatLog.enabled = true

  EVENT_MANAGER:RegisterForEvent( 
    "ACTCombatLog", EVENT_PLAYER_ACTIVATED, ACTCombatLog.EventPlayerActivated )

  if IsPlayerActivated() then
    ACTCombatLog.EventPlayerActivated()
  end


  -- Combat
  EVENT_MANAGER:RegisterForEvent( 
    "ACTCombatLog", EVENT_COMBAT_EVENT, ACTCombatLog.EventCombat )

  -- Buffs / Debuffs
  EVENT_MANAGER:RegisterForEvent( 
    "ACTCombatLog", EVENT_EFFECTS_FULL_UPDATE,
    ACTCombatLog.EventEffectFullChanged )

  EVENT_MANAGER:RegisterForEvent( 
    "ACTCombatLog", EVENT_EFFECT_CHANGED, 
    ACTCombatLog.EventEffectChanged )

  -- Zone Changes
  EVENT_MANAGER:RegisterForEvent( 
    "ACTCombatLog", EVENT_ZONE_CHANGED, ACTCombatLog.EventPlayerActivated )

end

local function Stop()

  ACTCombatLog.enabled = false

  EVENT_MANAGER:UnregisterForEvent( "ACTCombatLog", EVENT_PLAYER_ACTIVATED )
  EVENT_MANAGER:UnregisterForEvent( "ACTCombatLog", EVENT_COMBAT_EVENT )
  EVENT_MANAGER:UnregisterForEvent( "ACTCombatLog", EVENT_EFFECTS_FULL_UPDATE )
  EVENT_MANAGER:UnregisterForEvent( "ACTCombatLog", EVENT_EFFECT_CHANGED )
  EVENT_MANAGER:UnregisterForEvent( "ACTCombatLog", EVENT_ZONE_CHANGED )

end

local function Initialize( self, addOnName )

  -- Only Init us...
  if addOnName ~= "ACTCombatLog" then return end

  local defaults = 
  {
    logging = true,
  }

  ACTCombatLog.savedVars = ZO_SavedVars:New(
    "ACTCombatLogVars",
    math.floor( ACTCombatLog.version * 100 ),
    nil, defaults, nil)

  SetupCombatChatChannel()

  if ACTCombatLog.savedVars.logging then
    Start()
  end

end

-- Write to the combat log...
local function Log(...)

  -- TODO: better way to do this?  
  --      Direct access to chat window?

  -- FIXME ':' is used in some abitily names...  need a fix.

  -- NOTE - d() does not get logged by /chatlog any more.
  -- d ( table.concat({...}, ':') )
 
  -- NOTE: Closes game due to message limit:
  -- SendChatMessage ( 
  --   table.concat({...}, ':'), 
  --   CHAT_CHANNEL_WHISPER,
  --   ACTCombatLog.currentPlayer)

  CHAT_SYSTEM:AddMessage( table.concat({...}, ':') )

end


function ACTCombatLog.EventPlayerActivated(...)

  local name = GetUnitName('player')
  local zone = GetUnitZone('player')

  if (name ~=  ACTCombatLog.currentPlayer) or 
     (zone ~= ACTCombatLog.currentZone) then

    ACTCombatLog.currentPlayer = name
    ACTCombatLog.currentZone = zone

    -- Either player character or zone changed.
    -- Also include a log file version for compatability checking in ACT.
    Log ( "*PLYR", name, zone,  ACTCombatLog.version)

  end

end

local function cleanPlayerName(name, nameType)

  if ( (nameType == COMBAT_UNIT_TYPE_PLAYER) or
       (nameType == COMBAT_UNIT_TYPE_OTHER) ) then

    return string.gsub( name , "%^.*", "")

  else
    return name
  end

end

-- EVENT_COMBAT_EVENT (integer result, bool isError, string abilityName, integer abilityGraphic, integer abilityActionSlotType, string sourceName, integer sourceType, string targetName, integer targetType, integer hitValue, integer powerType, integer damageType, bool log)

function ACTCombatLog.EventCombat(
  event, result , isError , abilityName, abilityGraphic, abilityActionSlotType,
  sourceName, sourceType, targetName, targetType, hitValue, powerType,
  damageType, log )

  -- NOTE Hope this is a reasonable first filter...
  if isError then return end

  -- TODO filter out what we can here...
  -- Right now filter to the player.
  -- Later have player/group/all options.
  if ((sourceType ~= COMBAT_UNIT_TYPE_PLAYER) and 
      (targetType ~= COMBAT_UNIT_TYPE_PLAYER) ) then return end

 -- result                    = ACTION_RESULT_* 
 -- abilityActionSlotType     = ACTION_SLOT_TYPE_*
 -- sourceType / tartgetType  = COMBAT_UNIT_TYPE_*
 -- powerType                 = POWERTYPE_*
 -- damageType                = DAMAGE_TYPE_*
 
  local r = Convert('ActionResult', result)
  -- local err = tostring(isError)
  local ast = Convert('ActionSlotType', abilityActionSlotType)
  local sn = cleanPlayerName(sourceName, sourceType)
  local st = Convert('CombatUnitType', sourceType)
  local tn = cleanPlayerName(targetName, targetType)
  local tt = Convert('CombatUnitType', targetType)
  local pt = Convert('PowerType', powerType)
  local dt = Convert('DamageType', damageType)
 
  -- NOTE: isError and log are both boolean and don't coerce to string
  --       So don't pass them directly to Log.  We shouldn't need them anyway.

  -- Dump combat events 
	Log( "*CMBT", r, abilityName, ast, sn, st, tn, tt, hitValue, pt, dt )

end

function ACTCombatLog.EventEffectFullChanged()

  -- Log ( "*EFFF" )

end

function ACTCombatLog.EventEffectChanged(changeType, effectSlot, effectName,
  unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType,
  abilityType, statusEffectType)

  -- Log ( "*EFFC", changeType, effectSlot, effectName, unitTag, beginTime,
  --       endTime, stackCount, buffType, effectType, abilityType, 
  --       statusEffectType )

end

function ACTCombatLog.EventSynergyGained(
  synergyBuffSlot, grantedAbilityName, beginTime, endTime, iconName)

  Log ( "*SYNG", "Gain", synergyBuffSlot, grantedAbilityName,
        beginTime, endTime, iconName )

end


function ACTCombatLog.EventSynergyLost(synergyBuffSlot)

  Log ( "*SYNG",  "Lost", synergyBuffSlot )

end

function ACTCombatLog.EventRevengeKill(killedPlayerName)

  Log( "*RVNG", killedPlayerName )

end


function SetupCombatChatChannel()
  -- JoinChatChannel??
  -- AddChatContainerTab
  -- SetChatContainerTabCategoryEnabled
  --
  -- Use LogChatText() or d() ???
  

end

local function SetLoggingState(active)
  if active then

    if not ACTCombatLog.savedVars.logging then
      ACTCombatLog.savedVars.logging = true
      Start()
    end

  else

    if ACTCombatLog.savedVars.logging then
      ACTCombatLog.savedVars.logging = false
      Stop()
    end

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

