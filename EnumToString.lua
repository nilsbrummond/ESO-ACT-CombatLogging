
--
-- constants to strings.
--

function GetEnumerations()
  local E = {
    ["ActionResult"] = {
      [ACTION_RESULT_ABILITY_ON_COOLDOWN]   = "AbilityOnCooldown",
      [ACTION_RESULT_ABSORBED]              = "Absorbed",
      [ACTION_RESULT_BAD_TARGET]            = "BadTarget",
      [ACTION_RESULT_BEGIN]                 = "Begin",
      [ACTION_RESULT_BEGIN_CHANNEL]         = "BeginChannel",
      [ACTION_RESULT_BLADETURN]             = "Bladeturn",
      [ACTION_RESULT_BLOCKED]               = "Blocked",
      [ACTION_RESULT_BLOCKED_DAMAGE]        = "BlockedDamage",
      [ACTION_RESULT_BUFF]                  = "Buff",
      [ACTION_RESULT_BUSY]                  = "Busy",
      [ACTION_RESULT_CANNOT_USE]            = "CannotUse",
      [ACTION_RESULT_CANT_SEE_TARGET]       = "CantSeeTarget",
      [ACTION_RESULT_CASTER_DEAD]           = "CasterDead",
      [ACTION_RESULT_COMPLETE]              = "Complete",
      [ACTION_RESULT_CRITICAL_DAMAGE]       = "CriticalDamage",
      [ACTION_RESULT_CRITICAL_HEAL]         = "CriticalHeal",
      [ACTION_RESULT_DAMAGE]                = "Damage",
      [ACTION_RESULT_DAMAGE_SHIELDED]       = "DamageShielded",
      [ACTION_RESULT_DEBUFF]                = "Debuff",
      [ACTION_RESULT_DEFENDED]              = "Defended",
      [ACTION_RESULT_DIED]                  = "Died",
      [ACTION_RESULT_DIED_XP]               = "DiedXP",
      [ACTION_RESULT_DISARMED]              = "Disarmed",
      [ACTION_RESULT_DISORIENTED]           = "Disoriented",
      [ACTION_RESULT_DODGED]                = "Dodged",
      [ACTION_RESULT_DOT_TICK]              = "DotTick",
      [ACTION_RESULT_DOT_TICK_CRITICAL]     = "DotTickCritical",
      [ACTION_RESULT_EFFECT_FADED]          = "EffectFaded",
      [ACTION_RESULT_EFFECT_GAINED]         = "EffectGained",
      [ACTION_RESULT_EFFECT_GAINED_DURATION] = "EffectGainedDuration",
      [ACTION_RESULT_FAILED]                = "Failed",
      [ACTION_RESULT_FAILED_REQUIREMENTS]   = "FailedRequirements",
      [ACTION_RESULT_FAILED_SIEGE_CREATION_REQUIREMENTS] = "FailedSiegeCreationRequirements",
      [ACTION_RESULT_FALLING]               = "Falling",
      [ACTION_RESULT_FALL_DAMAGE]           = "FallDamage",
      [ACTION_RESULT_FEARED]                = "Feared",
      [ACTION_RESULT_GRAVEYARD_DISALLOWED_IN_INSTANCE] = "GraveyardDisallowedInInstance",
      [ACTION_RESULT_GRAVEYARD_TOO_CLOSE]   = "GraveyardTooClose",
      [ACTION_RESULT_HEAL]                  = "Heal",
      [ACTION_RESULT_HOT_TICK]              = "HotTick",
      [ACTION_RESULT_HOT_TICK_CRITICAL]     = "HotTickCritical",
      [ACTION_RESULT_IMMUNE]                = "Immune",
      [ACTION_RESULT_INSUFFICIENT_RESOURCE] = "InsufficientResource",
      [ACTION_RESULT_INTERCEPTED]           = "Intercepted",
      [ACTION_RESULT_INTERRUPT]             = "Interrupt",
      [ACTION_RESULT_INVALID]               = "Invalid",
      [ACTION_RESULT_INVALID_FIXTURE]       = "InvalidFixture",
      [ACTION_RESULT_INVALID_TERRAIN]       = "InvalidTerrain",
      [ACTION_RESULT_IN_COMBAT]             = "InCombat",
      [ACTION_RESULT_IN_ENEMY_KEEP]         = "InEnemyKeep",
      [ACTION_RESULT_KILLING_BLOW]          = "KillingBlow",
      [ACTION_RESULT_LEVITATED]             = "Levitated",
      [ACTION_RESULT_LINKED_CAST]           = "LinkedCast",
      [ACTION_RESULT_MISS]                  = "Miss",
      [ACTION_RESULT_MISSING_EMPTY_SOUL_GEM] = "MissingEmptySoulGem",
      [ACTION_RESULT_MISSING_FILLED_SOUL_GEM] = "MissingFilledSoulGem",
      [ACTION_RESULT_MOUNTED]               = "Mounted",
      [ACTION_RESULT_MUST_BE_IN_OWN_KEEP]   = "MustBeInOwnKeep",
      [ACTION_RESULT_NOT_ENOUGH_INVENTORY_SPACE] = "NotEnoughInventorySpace",
      [ACTION_RESULT_NO_LOCATION_FOUND]     = "NoLocationFound",
      [ACTION_RESULT_NO_RAM_ATTACKABLE_TARGET_WITHIN_RANGE] = "NoRamAttackableTargetWithinRange",
      [ACTION_RESULT_NPC_TOO_CLOSE]         = "NPCTooClose",
      [ACTION_RESULT_OFFBALANCE]            = "Offbalance",
      [ACTION_RESULT_PACIFIED]              = "Pacified",
      [ACTION_RESULT_PARRIED]               = "Parried",
      [ACTION_RESULT_PARTIAL_RESIST]        = "PartialResist",
      [ACTION_RESULT_POWER_DRAIN]           = "PowerDrain",
      [ACTION_RESULT_POWER_ENERGIZE]        = "PowerEnergize",
      [ACTION_RESULT_PRECISE_DAMAGE]        = "PreciseDamage",
      [ACTION_RESULT_QUEUED]                = "Queued",
      [ACTION_RESULT_RAM_ATTACKABLE_TARGETS_ALL_DESTROYED] = "RamAttackableTargetsAllDestroyed",
      [ACTION_RESULT_RAM_ATTACKABLE_TARGETS_ALL_OCCUPIED] = "RamAttackableTargetsAllOccupied",
      [ACTION_RESULT_REFLECTED]             = "Reflected",
      [ACTION_RESULT_REINCARNATING]         = "Reincarnating",
      [ACTION_RESULT_RESIST]                = "Resist",
      [ACTION_RESULT_RESURRECT]             = "Resurrect",
      [ACTION_RESULT_ROOTED]                = "Rooted",
      [ACTION_RESULT_SIEGE_LIMIT]           = "SiegeLimit",
      [ACTION_RESULT_SIEGE_TOO_CLOSE]       = "SiegeTooClose",
      [ACTION_RESULT_SILENCED]              = "Silenced",
      [ACTION_RESULT_SPRINTING]             = "Sprinting",
      [ACTION_RESULT_STAGGERED]             = "Staggered",
      [ACTION_RESULT_STUNNED]               = "Stunned",
      [ACTION_RESULT_SWIMMING]              = "Swimming",
      [ACTION_RESULT_TARGET_DEAD]           = "TargetDead",
      [ACTION_RESULT_TARGET_NOT_IN_VIEW]    = "TargetNotInView",
      [ACTION_RESULT_TARGET_NOT_PVP_FLAGGED] = "TargetNotPvpFlagged",
      [ACTION_RESULT_TARGET_OUT_OF_RANGE]   = "TargetOutOfRange",
      [ACTION_RESULT_TARGET_TOO_CLOSE]      = "TargetTooClose",
      [ACTION_RESULT_UNEVEN_TERRAIN]        = "UnevenTerrain",
      [ACTION_RESULT_WEAPONSWAP]            = "Weaponswap",
      [ACTION_RESULT_WRECKING_DAMAGE]       = "WreckingDamage",
      [ACTION_RESULT_WRONG_WEAPON]          = "WrongWeapon"
    },
    
    ["ActionSlotType"] = {
      [ACTION_SLOT_TYPE_BLOCK]          = "Block",
      [ACTION_SLOT_TYPE_HEAVY_ATTACK]   = "HeavyAttack",
      [ACTION_SLOT_TYPE_LIGHT_ATTACK]   = "LightAttack",
      [ACTION_SLOT_TYPE_NORMAL_ABILITY] = "NormalAbility",
      [ACTION_SLOT_TYPE_OTHER]          = "Other",
      [ACTION_SLOT_TYPE_ULTIMATE]       = "Ultimate",
      [ACTION_SLOT_TYPE_WEAPON_ATTACK]  = "WeaponAttack"
    },

    ["CombatUnitType"] = {
      [COMBAT_UNIT_TYPE_GROUP]      = "Group",
      [COMBAT_UNIT_TYPE_NONE]       = "None",
      [COMBAT_UNIT_TYPE_OTHER]      = "Other",
      [COMBAT_UNIT_TYPE_PLAYER]     = "Player",
      [COMBAT_UNIT_TYPE_PLAYER_PET] = "Pet"
    },

    ["PowerType"] = {
      [POWERTYPE_FINESSE]       = "Finesse",
      [POWERTYPE_HEALTH]        = "Health",
      [POWERTYPE_INVALID]       = "Invalid",
      [POWERTYPE_MAGICKA]       = "Magicka",
      [POWERTYPE_MOUNT_STAMINA] = "MountStamina",
      [POWERTYPE_STAMINA]       = "Stamina",
      [POWERTYPE_ULTIMATE]      = "Ultimate",
      [POWERTYPE_WEREWOLF]      = "Werewolf"
    },

    ["DamageType"] = {
      [DAMAGE_TYPE_COLD]        = "Cold",
      [DAMAGE_TYPE_DISEASE]     = "Disease",
      [DAMAGE_TYPE_DROWN]       = "Drown",
      [DAMAGE_TYPE_EARTH]       = "Earth",
      [DAMAGE_TYPE_FIRE]        = "Fire",
      [DAMAGE_TYPE_GENERIC]     = "Generic",
      [DAMAGE_TYPE_MAGIC]       = "Magic",
      [DAMAGE_TYPE_NONE]        = "None",
      [DAMAGE_TYPE_OBLIVION]    = "Oblivion",
      [DAMAGE_TYPE_PHYSICAL]    = "Physical",
      [DAMAGE_TYPE_POISON]      = "Poison",
      [DAMAGE_TYPE_SHOCK]       = "Shock"
    }
  }

  return function(type, enum)
    local e = E[type]
    if e == nil then 
      return type .. enum
    else
      local v =  e[enum]
      if v == nil then 
        return type .. enum
      else
        return v
      end
    end
  end
end
