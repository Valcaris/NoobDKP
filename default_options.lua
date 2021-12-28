-- NoobDKP Options file

NoobDKP_color = "|cfff0ba3c"


-- maybe make a default table and a list of option names, then go through the
-- real option table by name. If not there, insert from default table?
if NOOBDKP_g_options == nil then
  NOOBDKP_g_options = {}

  NOOBDKP_g_options["admin_mode"] = false
  NOOBDKP_g_options["loot_table"] = false
  
  NOOBDKP_g_options["scroll_scale"] = 5
  
  -- score calculation options
  NOOBDKP_g_options["base_EP"] = 200
  NOOBDKP_g_options["base_GP"] = 200
  NOOBDKP_g_options["scale_EP"] = 100
  NOOBDKP_g_options["defaultGP"] = 50
  NOOBDKP_g_options["min_EP"] = 0
  NOOBDKP_g_options["decay_percent"] = 30

  -- gear options by inventory slot type
  NOOBDKP_g_options["INVTYPE_HEAD"] = 50
  NOOBDKP_g_options["INVTYPE_NECK"] = 50
  NOOBDKP_g_options["INVTYPE_SHOULDER"] = 50
  NOOBDKP_g_options["INVTYPE_CLOAK"] = 50
  NOOBDKP_g_options["INVTYPE_ROBE"] = 50
  NOOBDKP_g_options["INVTYPE_CHEST"] = 50
  NOOBDKP_g_options["INVTYPE_WRIST"] = 50
  NOOBDKP_g_options["INVTYPE_HAND"] = 50
  NOOBDKP_g_options["INVTYPE_WAIST"] = 50
  NOOBDKP_g_options["INVTYPE_LEGS"] = 50
  NOOBDKP_g_options["INVTYPE_FEET"] = 50
  NOOBDKP_g_options["INVTYPE_FINGER"] = 50
  NOOBDKP_g_options["INVTYPE_TRINKET"] = 100
  NOOBDKP_g_options["INVTYPE_2HWEAPON"] = 100
  NOOBDKP_g_options["INVTYPE_WEAPON"] = 100
  NOOBDKP_g_options["INVTYPE_SHIELD"] = 100
  NOOBDKP_g_options["INVTYPE_RANGED"] = 100
  NOOBDKP_g_options["INVTYPE_THROWN"] = 100
  NOOBDKP_g_options["INVTYPE_WEAPONMAINHAND"] = 100
  NOOBDKP_g_options["INVTYPE_WEAPONOFFHAND"] = 100
  NOOBDKP_g_options["INVTYPE_HOLDABLE"] = 100
  NOOBDKP_g_options["INVTYPE_RELIC"] = 0

  NOOBDKP_g_options["MARK"] = 150
  NOOBDKP_g_options["HC_MARK"] = 250

  NOOBDKP_g_options["HC_INVTYPE_HEAD"] = 200
  NOOBDKP_g_options["HC_INVTYPE_NECK"] = 200
  NOOBDKP_g_options["HC_INVTYPE_SHOULDER"] = 200
  NOOBDKP_g_options["HC_INVTYPE_CLOAK"] = 200
  NOOBDKP_g_options["HC_INVTYPE_ROBE"] = 200
  NOOBDKP_g_options["HC_INVTYPE_CHEST"] = 200
  NOOBDKP_g_options["HC_INVTYPE_WRIST"] = 200
  NOOBDKP_g_options["HC_INVTYPE_HAND"] = 200
  NOOBDKP_g_options["HC_INVTYPE_WAIST"] = 200
  NOOBDKP_g_options["HC_INVTYPE_LEGS"] = 200
  NOOBDKP_g_options["HC_INVTYPE_FEET"] = 200
  NOOBDKP_g_options["HC_INVTYPE_FINGER"] = 200
  NOOBDKP_g_options["HC_INVTYPE_TRINKET"] = 300
  NOOBDKP_g_options["HC_INVTYPE_2HWEAPON"] = 300
  NOOBDKP_g_options["HC_INVTYPE_WEAPON"] = 300
  NOOBDKP_g_options["HC_INVTYPE_SHIELD"] = 300
  NOOBDKP_g_options["HC_INVTYPE_RANGED"] = 300
  NOOBDKP_g_options["HC_INVTYPE_THROWN"] = 300
  NOOBDKP_g_options["HC_INVTYPE_WEAPONMAINHAND"] = 300
  NOOBDKP_g_options["HC_INVTYPE_WEAPONOFFHAND"] = 300
  NOOBDKP_g_options["HC_INVTYPE_HOLDABLE"] = 300
  NOOBDKP_g_options["HC_INVTYPE_RELIC"] = 0  
end