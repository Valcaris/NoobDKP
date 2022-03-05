-- NoobDKP Options file

NoobDKP_color = "|cfff0ba3c"


-- maybe make a default table and a list of option names, then go through the
-- real option table by name. If not there, insert from default table?
if NOOBDKP_g_options == nil then
  NOOBDKP_g_options = {}

  NOOBDKP_g_options["admin_mode"] = false
  NOOBDKP_g_options["loot_table"] = false
  NOOBDKP_g_options["auto_EP"] = true
  
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

if NOOBDKP_g_boss_table == nil then
  NOOBDKP_g_boss_table = {}
  NOOBDKP_g_boss_table["Lord Marrowgar"] = 10
  NOOBDKP_g_boss_table["Lady Deathwhisper"] = 10
  --NOOBDKP_g_boss_table["Lord Marrowgar"] = 10 -- Gunship Battle
  NOOBDKP_g_boss_table["Deathbringer Saurfang"] = 10
  NOOBDKP_g_boss_table["Festergut"] = 10
  NOOBDKP_g_boss_table["Rotface"] = 10
  NOOBDKP_g_boss_table["Professor Putricide"] = 10
  NOOBDKP_g_boss_table["Prince Valanar"] = 10 -- Blood Prince Council
  NOOBDKP_g_boss_table["Blood-Queen Lana'thel"] = 10
  NOOBDKP_g_boss_table["Valithria Dreamwalker"] = 10
  NOOBDKP_g_boss_table["Sindragosa"] = 10
  NOOBDKP_g_boss_table["The Lich King"] = 50
  NOOBDKP_g_boss_table["Hallion"] = 50

  NOOBDKP_g_boss_table["Kobold Vermin"] = 1

end

if NOOBDKP_g_loot_table == nil then

  NOOBDKP_g_loot_table = {
    ["|cffa335ee|Hitem:50063:0:0:0:0:0:0:0:1|h[Lingering Illness]|h|r"] = {
      ["need"] = "Holy Priest, Disco Priest",
      ["greed"] = "Other casters",
    },
    ["|cffa335ee|Hitem:50793:0:0:0:0:0:0:0:1|h[Midnight Sun]|h|r"] = {
      ["need"] = "Resto Shaman, Holy Priest, Resto Druid",
      ["greed"] = "Other casters",
    },
    ["|cffa335ee|Hitem:50171:0:0:0:0:0:0:0:1|h[Shoulders of Frost-Tipped Thorns]|h|r"] = {
      ["need"] = "Resto Druid, Balance Druid",
      ["greed"] = "Other casters",
    },
    ["|cffa335ee|Hitem:50061:0:0:0:0:0:0:0:1|h[Holiday's Grace]|h|r"] = {
      ["need"] = "Holy Priests, Disco Priests",
      ["greed"] = "Other casters",
    },
    ["|cffa335ee|Hitem:50798:0:0:0:0:0:0:0:1|h[Ramaladni's Blade of Culling]|h|r"] = {
      ["need"] = "DPS",
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50783:0:0:0:0:0:0:0:1|h[Boots of the Frozen Seed]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50805:0:0:0:0:0:0:0:1|h[Mag'hari Chieftain's Staff]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50178:0:0:0:0:0:0:0:1|h[Bloodfall]|h|r"] = {
      ["need"] = "Ret Paladin, Cat Druid, Bear Druid",
      ["greed"] = "Warriors",
    },
    ["|cffa335ee|Hitem:50414:0:0:0:0:0:0:0:1|h[Might of Blight]|h|r"] = {
      ["need"] = "DPS DK, Warriors",
      ["greed"] = "Other Melee DPS",
    },
    ["|cffa335ee|Hitem:50413:0:0:0:0:0:0:0:1|h[Nerub'ar Stalker's Cord]|h|r"] = {
      ["need"] = "Hunters, Enhancement Shamans",
      ["greed"] = "Other DPS (mail only)",
    },
    ["|cffa335ee|Hitem:50040:0:0:0:0:0:0:0:1|h[Distant Land]|h|r"] = {
      ["need"] = "Cat Druid",
      ["greed"] = "Other DPS (staff only)",
    },
    ["|cffa335ee|Hitem:50351:0:0:0:0:0:0:0:1|h[Tiny Abomination in a Jar]|h|r"] = {
      ["need"] = "Ret Paladin, Assasin Rogue",
      ["greed"] = "Other Melee DPS",
    },
    ["|cffa335ee|Hitem:50016:0:0:0:0:0:0:0:1|h[Rib Spreader]|h|r"] = {
      ["need"] = "Assasin Rogue",
      ["greed"] = "Other Melee DPS (dagger only)",
    },
    ["|cffa335ee|Hitem:50781:0:0:0:0:0:0:0:1|h[Scourgelord's Baton]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50450:0:0:0:0:0:0:0:1|h[Leggings of Dubious Charms]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50808:0:0:0:0:0:0:0:1|h[Deathforged Legplates]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50776:0:0:0:0:0:0:0:1|h[Njorndar Bone Bow]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50177:0:0:0:0:0:0:0:1|h[Mail of Crimson Coins]|h|r"] = {
      ["need"] = "Resto Shaman",
      ["greed"] = "Other Casters (mail only)",
    },
    ["|cffa335ee|Hitem:50342:0:0:0:0:0:0:0:1|h[Whispering Fanged Skull]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50175:0:0:0:0:0:0:0:1|h[Crypt Keeper's Bracers]|h|r"] = {
      ["need"] = "Holy Paladin",
      ["greed"] = "Other Paladins",
    },
    ["|cffa335ee|Hitem:52026:0:0:0:0:0:0:0:1|h[Protector's Mark of Sanctification]|h|r"] = {
      ["need"] = "Hunter, Shaman, Warrior",
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50800:0:0:0:0:0:0:0:1|h[Hauberk of a Thousand Cuts]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50340:0:0:0:0:0:0:0:1|h[Muradin's Spyglass]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50069:0:0:0:0:0:0:0:1|h[Professor's Bloodied Smock]|h|r"] = {
      ["need"] = "Resto Druid, Balance Druid",
      ["greed"] = "Other Casters (leather only)",
    },
    ["|cffa335ee|Hitem:52027:0:0:0:0:0:0:0:1|h[Conqueror's Mark of Sanctification]|h|r"] = {
      ["need"] = "Paladin, Priest, Warlock",
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50789:0:0:0:0:0:0:0:1|h[Icecrown Rampart Bracers]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50421:0:0:0:0:0:0:0:1|h[Sindragosa's Cruel Claw]|h|r"] = {
      ["need"] = "Rogues, Cat Druids, Hunters",
      ["greed"] = "Other DPS",
    },
    ["|cffa335ee|Hitem:50791:0:0:0:0:0:0:0:1|h[Saronite Gargoyle Cloak]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50173:0:0:0:0:0:0:0:1|h[Shadow Silk Spindle]|h|r"] = {
      ["need"] = "Holy Paladin, Resto Shaman, Disco Priest",
      ["greed"] = "Other Casters and Healers",
    },
    ["|cffa335ee|Hitem:50030:0:0:0:0:0:0:0:1|h[Bloodsunder's Bracers]|h|r"] = {
      ["need"] = "Resto Shaman, Elemental Shaman",
      ["greed"] = "Holy Paladin",
    },
    ["|cffa335ee|Hitem:50787:0:0:0:0:0:0:0:1|h[Frost Giant's Cleaver]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50060:0:0:0:0:0:0:0:1|h[Faceplate of the Forgotten]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50071:0:0:0:0:0:0:0:1|h[Treads of the Wasteland]|h|r"] = {
      ["need"] = "Enhance Shaman, Hunters",
      ["greed"] = "Other DPS (mail only)",
    },
    ["|cffa335ee|Hitem:50180:0:0:0:0:0:0:0:1|h[Lana'thel's Chain of Flagellation]|h|r"] = {
      ["need"] = "DK DPS, Warriors, Retribution Paladins",
      ["greed"] = "Other DPS",
    },
    ["|cffa335ee|Hitem:50065:0:0:0:0:0:0:0:1|h[Icecrown Glacial Wall]|h|r"] = {
      ["need"] = "Paladin Tank, Warrior Tank",
      ["greed"] = "Others (shield only)",
    },
    ["|cffa335ee|Hitem:50806:0:0:0:0:0:0:0:1|h[Leggings of Unrelenting Blood]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50062:0:0:0:0:0:0:0:1|h[Plague Scientist's Boots]|h|r"] = {
      ["need"] = "All Cloth, Balance Druids, Element Shaman, Resto Shaman",
      ["greed"] = "Other casters",
    },
    ["|cffa335ee|Hitem:50807:0:0:0:0:0:0:0:1|h[Thaumaturge's Crackling Cowl]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50453:0:0:0:0:0:0:0:1|h[Ring of Rotting Sinew]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50226:0:0:0:0:0:0:0:1|h[Festergut's Acidic Blood]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50775:0:0:0:0:0:0:0:1|h[Corrupted Silverplate Leggings]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50186:0:0:0:0:0:0:0:1|h[Frostbrood Sapphire Ring]|h|r"] = {
      ["need"] = "Combat Rogue, Hunters, Warriors, Cat Druid",
      ["greed"] = "Other DPS",
    },
    ["|cffa335ee|Hitem:50762:0:0:0:0:0:0:0:1|h[Linked Scourge Vertebrae]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50763:0:0:0:0:0:0:0:1|h[Marrowgar's Scratching Choker]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:49919:0:0:0:0:0:0:0:1|h[Cryptmaker]|h|r"] = {
      ["need"] = "Warriors, Blood DK",
      ["greed"] = "Other DPS (2H Maces only)",
    },
    ["|cffa335ee|Hitem:50782:0:0:0:0:0:0:0:1|h[Sister's Handshrouds]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50790:0:0:0:0:0:0:0:1|h[Abomination's Bloody Ring]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:52025:0:0:0:0:0:0:0:1|h[Vanquisher's Mark of Sanctification]|h|r"] = {
      ["need"] = "Death Knights, Druids, Mages, Rogues",
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50170:0:0:0:0:0:0:0:1|h[Valanar's Other Signet Ring]|h|r"] = {
      ["need"] = "DPS Casters",
      ["greed"] = "Other Casters",
    },
    ["|cffa335ee|Hitem:50428:0:0:0:0:0:0:0:1|h[Royal Scepter of Terenas II]|h|r"] = {
      ["need"] = "Mace Casters",
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50179:0:0:0:0:0:0:0:1|h[Last Word]|h|r"] = {
      ["need"] = "All Tanks",
      ["greed"] = "Other DPS (2H only)",
    },
    ["|cffa335ee|Hitem:50059:0:0:0:0:0:0:0:1|h[Horrific Flesh Epaulets]|h|r"] = {
      ["need"] = "Elemental Shaman",
      ["greed"] = "Resto Shaman, Holy Paladin, Other healers",
    },
    ["|cffa335ee|Hitem:50072:0:0:0:0:0:0:0:1|h[Landsoul's Horned Greathelm]|h|r"] = {
      ["need"] = "Warrior DPS, Retribution Paladin",
      ["greed"] = "Other DPS (plate only)",
    },
    ["|cffa335ee|Hitem:50074:0:0:0:0:0:0:0:1|h[Royal Crimson Cloak]|h|r"] = {
      ["need"] = "All Tanks",
      ["greed"] = "Tank OS",
    },
    ["|cffa335ee|Hitem:50771:0:0:0:0:0:0:0:1|h[Frost Needle]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50426:0:0:0:0:0:0:0:1|h[Heaven's Fall, Kryss of a Thousand Lies]|h|r"] = {
      ["need"] = "Assasin Rogue",
      ["greed"] = "Other DPS (daggers only)",
    },
    ["|cffa335ee|Hitem:50786:0:0:0:0:0:0:0:1|h[Ghoul Commander's Cuirass]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50036:0:0:0:0:0:0:0:1|h[Belt of Broken Bones]|h|r"] = {
      ["need"] = "All Tanks",
      ["greed"] = "Tank OS",
    },
    ["|cffa335ee|Hitem:50185:0:0:0:0:0:0:0:1|h[Devium's Eternally Cold Ring]|h|r"] = {
      ["need"] = "All Tanks",
      ["greed"] = "Tank OS",
    },
    ["|cffa335ee|Hitem:50447:0:0:0:0:0:0:0:1|h[Harbinger's Bone Band]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50360:0:0:0:0:0:0:0:1|h[Phylactery of the Nameless Lich]|h|r"] = {
      ["need"] = "All DPS Casters",
      ["greed"] = "DPS OS",
    },
    ["|cffa335ee|Hitem:50779:0:0:0:0:0:0:0:1|h[Deathspeaker Zealot's Helm]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50354:0:0:0:0:0:0:0:1|h[Bauble of True Blood]|h|r"] = {
      ["need"] = "All Healers",
      ["greed"] = "Healer OS",
    },
    ["|cffa335ee|Hitem:50190:0:0:0:0:0:0:0:1|h[Grinning Skull Greatboots]|h|r"] = {
      ["need"] = "Warrior Tank, Paladin Tank, DK Tank",
      ["greed"] = "Other Plate wearers, Tank OS",
    },
    ["|cffa335ee|Hitem:50028:0:0:0:0:0:0:0:1|h[Trauma]|h|r"] = {
      ["need"] = "All Healers",
      ["greed"] = "Healer OS",
    },
    ["|cffa335ee|Hitem:50026:0:0:0:0:0:0:0:1|h[Helm of the Elder Moon]|h|r"] = {
      ["need"] = "Resto Druid, Balance Druid",
      ["greed"] = "Other casters (leather only)",
    },
    ["|cffa335ee|Hitem:50202:0:0:0:0:0:0:0:1|h[Snowstorm Helm]|h|r"] = {
      ["need"] = "Resto Shaman",
      ["greed"] = "Other casters (mail only)",
    },
    ["|cffa335ee|Hitem:50022:0:0:0:0:0:0:0:1|h[Dual-Bladed Pauldrons]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50797:0:0:0:0:0:0:0:1|h[Ice-Reinforced Vrykul Helm]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50785:0:0:0:0:0:0:0:1|h[Bracers of Dark Blessings]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50192:0:0:0:0:0:0:0:1|h[Scourge Reaver's Legplates]|h|r"] = {
      ["need"] = "Unholy DK",
      ["greed"] = "Other DPS (plate only)",
    },
    ["|cffa335ee|Hitem:50761:0:0:0:0:0:0:0:1|h[Citadel Enforcer's Claymore]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50792:0:0:0:0:0:0:0:1|h[Pauldrons of Lost Hope]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50183:0:0:0:0:0:0:0:1|h[Lungbreaker]|h|r"] = {
      ["need"] = "Assasin Rogue",
      ["greed"] = "Other DPS (dagger only)",
    },
    ["|cffa335ee|Hitem:50184:0:0:0:0:0:0:0:1|h[Keleseth's Seducer]|h|r"] = {
      ["need"] = "Combat Rogue, Enhance Shaman",
      ["greed"] = "Other DPS (fist only)",
    },
    ["|cffa335ee|Hitem:50024:0:0:0:0:0:0:0:1|h[Blightborne Warplate]|h|r"] = {
      ["need"] = "DK Tank, Warrior Tank, Paladin Tank",
      ["greed"] = "Tank OS",
    },
    ["|cffa335ee|Hitem:50759:0:0:0:0:0:0:0:1|h[Bone Warden's Splitter]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50452:0:0:0:0:0:0:0:1|h[Wodin's Lucky Necklace]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50429:0:0:0:0:0:0:0:1|h[Archus, Greatstaff of Antonidas]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50425:0:0:0:0:0:0:0:1|h[Oathbinder, Charge of the Ranger-General]|h|r"] = {
      ["need"] = "Bear DPS, Cat DPS, Hunters, Retribution Paladin",
      ["greed"] = "DPS OS (2H Only)",
    },
    ["|cffa335ee|Hitem:49997:0:0:0:0:0:0:0:1|h[Mithrios, Bronzebeard's Legacy]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50774:0:0:0:0:0:0:0:1|h[Coldwraith Bracers]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50012:0:0:0:0:0:0:0:1|h[Havoc's Call, Blade of Lordaeron Kings]|h|r"] = {
      ["need"] = "Frost DK, Enhance Shaman, Combat Rogue",
      ["greed"] = "Other DPS",
    },
    ["|cffa335ee|Hitem:50042:0:0:0:0:0:0:0:1|h[Gangrenous Leggings]|h|r"] = {
      ["need"] = "Combat Rogue",
      ["greed"] = "Other DPS (leather only)",
    },
    ["|cffa335ee|Hitem:50067:0:0:0:0:0:0:0:1|h[Astrylian's Sutured Cinch]|h|r"] = {
      ["need"] = "Rogues, Cat Druid, Bear Druid, Retribution Paladin",
      ["greed"] = "Other DPS (leather only)",
    },
    ["|cffa335ee|Hitem:50423:0:0:0:0:0:0:0:1|h[Sundial of Eternal Dusk]|h|r"] = {
      ["need"] = "Resto Druid, Holy Priest, Warlock",
      ["greed"] = "Other casters",
    },
    ["|cffa335ee|Hitem:50025:0:0:0:0:0:0:0:1|h[Seal of Many Mouths]|h|r"] = {
      ["need"] = "Bear Druid, Cat Druid, Retribution Paladin, Rogues, Enhance Shaman",
      ["greed"] = "Other DPS",
    },
    ["|cffa335ee|Hitem:50777:0:0:0:0:0:0:0:1|h[Handgrips of Frost and Sleet]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50778:0:0:0:0:0:0:0:1|h[Soulthief's Braided Belt]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50427:0:0:0:0:0:0:0:1|h[Bloodsurge, Kel'Thuzad's Blade of Agony]|h|r"] = {
      ["need"] = "Caster sword",
      ["greed"] = "Caster OS",
    },
    ["|cffa335ee|Hitem:50803:0:0:0:0:0:0:0:1|h[Saurfang's Cold-Forged Band]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50796:0:0:0:0:0:0:0:1|h[Bracers of Pale Illumination]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50788:0:0:0:0:0:0:0:1|h[Bone Drake's Enameled Boots]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50035:0:0:0:0:0:0:0:1|h[Black Bruise]|h|r"] = {
      ["need"] = "Enhance Shaman, Combat Rogue",
      ["greed"] = "Other DPS (fist only)",
    },
    ["|cffa335ee|Hitem:50449:0:0:0:0:0:0:0:1|h[Stiffened Corpse Shoulderpads]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50020:0:0:0:0:0:0:0:1|h[Raging Behemoth's Shoulderplates]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50804:0:0:0:0:0:0:0:1|h[Icecrown Spire Sandals]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50795:0:0:0:0:0:0:0:1|h[Cord of Dark Suffering]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50195:0:0:0:0:0:0:0:1|h[Noose of Malachite]|h|r"] = {
      ["need"] = "All Tanks",
      ["greed"] = "Tank OS",
    },
    ["|cffa335ee|Hitem:50416:0:0:0:0:0:0:0:1|h[Boots of the Funeral March]|h|r"] = {
      ["need"] = "Holy Paladin",
      ["greed"] = "Paladin OS",
    },
    ["|cffa335ee|Hitem:50187:0:0:0:0:0:0:0:1|h[Coldwraith Links]|h|r"] = {
      ["need"] = "DK, Warriors",
      ["greed"] = "Other DPS (plate only)",
    },
    ["|cffa335ee|Hitem:50019:0:0:0:0:0:0:0:1|h[Winding Sheet]|h|r"] = {
      ["need"] = "Unholy DK, Frost DK, Retribution Paladin",
      ["greed"] = "Other DPS",
    },
    ["|cffa335ee|Hitem:50472:0:0:0:0:0:0:0:1|h[Nightmare Ender]|h|r"] = {
      ["need"] = "Holy Priest, Disco Priest, Warlock",
      ["greed"] = "Other Casters (wand only)",
    },
    ["|cffa335ee|Hitem:50361:0:0:0:0:0:0:0:1|h[Sindragosa's Flawless Fang]|h|r"] = {
      ["need"] = "All Tanks",
      ["greed"] = "Tank OS",
    },
    ["|cffa335ee|Hitem:50417:0:0:0:0:0:0:0:1|h[Bracers of Eternal Dreaming]|h|r"] = {
      ["need"] = "Balance Druid, Resto Druid",
      ["greed"] = "Other casters",
    },
    ["|cffa335ee|Hitem:50037:0:0:0:0:0:0:0:1|h[Fleshrending Gauntlets]|h|r"] = {
      ["need"] = "Retribution Paladin, DK DPS",
      ["greed"] = "Other DPS (plate only)",
    },
    ["|cffa335ee|Hitem:50205:0:0:0:0:0:0:0:1|h[Frostbinder's Shredded Cape]|h|r"] = {
      ["need"] = "Other casters",
      ["greed"] = "Resto Druid, Holy Priest",
    },
    ["|cffa335ee|Hitem:50041:0:0:0:0:0:0:0:1|h[Leather of Stitched Scourge Parts]|h|r"] = {
      ["need"] = "Balance Druid, Resto Druid",
      ["greed"] = "Other casters (leather only)",
    },
    ["|cffa335ee|Hitem:50784:0:0:0:0:0:0:0:1|h[Deathspeaker Disciple's Belt]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50764:0:0:0:0:0:0:0:1|h[Shawl of Nerubian Silk]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:49981:0:0:0:0:0:0:0:1|h[Fal'inrush, Defender of Quel'thalas]|h|r"] = {
      ["need"] = "Hunters, Rogues, DPS Warriors",
      ["greed"] = "Other DPS (crossbow only)",
    },
    ["|cffa335ee|Hitem:50794:0:0:0:0:0:0:0:1|h[Neverending Winter]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50780:0:0:0:0:0:0:0:1|h[Chestguard of the Frigid Noose]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50068:0:0:0:0:0:0:0:1|h[Rigormortis]|h|r"] = {
      ["need"] = "DPS Casters",
      ["greed"] = "Caster OS",
    },
    ["|cffa335ee|Hitem:50033:0:0:0:0:0:0:0:1|h[Corpse-Impaling Spike]|h|r"] = {
      ["need"] = "Priests, Mages, Warlocks",
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50182:0:0:0:0:0:0:0:1|h[Blood Queen's Crimson Choker]|h|r"] = {
      ["need"] = "Holy Paladin, Resto Shaman, Disco Priest, Mage, Balance Druid, Element Shaman",
      ["greed"] = "Other Casters",
    },
    ["|cffa335ee|Hitem:50339:0:0:0:0:0:0:0:1|h[Sliver of Pure Ice]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50799:0:0:0:0:0:0:0:1|h[Scourge Stranglers]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffff8000|Hitem:50274:0:0:0:0:0:0:0:1|h[Shadowfrost Shard]|h|r"] = {
      ["need"] = "Paladin, Warrior, DK - MUST BE ON THE QUEST",
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50802:0:0:0:0:0:0:0:1|h[Gargoyle Spit Bracers]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50181:0:0:0:0:0:0:0:1|h[Dying Light]|h|r"] = {
      ["need"] = "Holy Priest, Resto Druid",
      ["greed"] = "Other Casters",
    },
    ["|cffa335ee|Hitem:50023:0:0:0:0:0:0:0:1|h[Bile-Encrusted Medallion]|h|r"] = {
      ["need"] = "All Tanks",
      ["greed"] = "Tank OS",
    },
    ["|cffa335ee|Hitem:50038:0:0:0:0:0:0:0:1|h[Carapace of Forgotten Kings]|h|r"] = {
      ["need"] = "Enhance Shaman, Hunters",
      ["greed"] = "Other DPS (mail only)",
    },
    ["|cffa335ee|Hitem:50174:0:0:0:0:0:0:0:1|h[Incarnadine Band of Mending]|h|r"] = {
      ["need"] = "Disco Priest",
      ["greed"] = "Other Healers and DPS Casters",
    },
    ["|cffa335ee|Hitem:50176:0:0:0:0:0:0:0:1|h[San'layn Ritualist Gloves]|h|r"] = {
      ["need"] = "Disco Priest",
      ["greed"] = "Other Healers and DPS Casters",
    },
    ["|cffa335ee|Hitem:50760:0:0:0:0:0:0:0:1|h[Bonebreaker Scepter]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50801:0:0:0:0:0:0:0:1|h[Blade-Scored Carapace]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50032:0:0:0:0:0:0:0:1|h[Death Surgeon's Sleeves]|h|r"] = {
      ["need"] = "Holy Priest, Disco Priest, Resto Druid",
      ["greed"] = "Other Healers and DPS Casters",
    },
    ["|cffa335ee|Hitem:50073:0:0:0:0:0:0:0:1|h[Geistlord's Punishment Sack]|h|r"] = {
      ["need"] = "Cat Druid, Rogues",
      ["greed"] = "Other Melee DPS (leather only)",
    },
    ["|cffa335ee|Hitem:50773:0:0:0:0:0:0:0:1|h[Cord of the Patronizing Practitioner]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50172:0:0:0:0:0:0:0:1|h[Sanguine Silk Robes]|h|r"] = {
      ["need"] = "Resto Druid, Holy Priest",
      ["greed"] = "Other Healers and Caster DPS",
    },
    ["|cff0070dd|Hitem:49908:0:0:0:0:0:0:0:1|h[Primordial Saronite]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50772:0:0:0:0:0:0:0:1|h[Ancient Skeletal Boots]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50021:0:0:0:0:0:0:0:1|h[Aldriana's Gloves of Secrecy]|h|r"] = {
      ["need"] = "Warriors, Frost DK, Cat Druid, Combat Rogue",
      ["greed"] = "Other DPS (leather only)",
    },
    ["|cffa335ee|Hitem:50444:0:0:0:0:0:0:0:1|h[Rowan's Rifle of Silver Bullets]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50199:0:0:0:0:0:0:0:1|h[Leggings of Dying Candles]|h|r"] = {
      ["need"] = "Holy Paladins",
      ["greed"] = "Paladin OS",
    },
    ["|cffa335ee|Hitem:50353:0:0:0:0:0:0:0:1|h[Dislodged Foreign Object]|h|r"] = {
      ["need"] = "DPS Casters",
      ["greed"] = "DPS Caster OS",
    },
    ["|cffa335ee|Hitem:50809:0:0:0:0:0:0:0:1|h[Soulcleave Pendant]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50056:0:0:0:0:0:0:0:1|h[Plaguebringer's Stained Pants]|h|r"] = {
      ["need"] = "Shadow Priest, Mages, Warlocks, Holy Paladin, Balance Druid",
      ["greed"] = "Other Casters",
    },
    ["|cffa335ee|Hitem:50064:0:0:0:0:0:0:0:1|h[Unclean Surgical Gloves]|h|r"] = {
      ["need"] = "Resto Shaman",
      ["greed"] = "Holy Paladin",
    },
    ["|cffa335ee|Hitem:50424:0:0:0:0:0:0:0:1|h[Memory of Malygos]|h|r"] = {
      ["need"] = "Resto Druid, Holy Priest",
      ["greed"] = "Other Healers and Caster DPS",
    },
    ["|cffa335ee|Hitem:50231:0:0:0:0:0:0:0:1|h[Rotface's Acidic Blood]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50027:0:0:0:0:0:0:0:1|h[Rot-Resistant Breastplate]|h|r"] = {
      ["need"] = "Holy Paladin",
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50070:0:0:0:0:0:0:0:1|h[Glorenzelg, High-Blade of the Silver Hand]|h|r"] = {
      ["need"] = "Warriors, DK DPS, Retribution Paladin",
      ["greed"] = "Other DPS (2H only)",
    },
    ["|cffa335ee|Hitem:50451:0:0:0:0:0:0:0:1|h[Belt of the Lonely Noble]|h|r"] = {
      ["need"] = {
      },
      ["greed"] = {
      },
    },
    ["|cffa335ee|Hitem:50188:0:0:0:0:0:0:0:1|h[Anub'ar Stalker's Gloves]|h|r"] = {
      ["need"] = "Retribution Paladin, Enhance Shaman",
      ["greed"] = "Other DPS (mail only)",
    },
    ["|cffa335ee|Hitem:50075:0:0:0:0:0:0:0:1|h[Taldaram's Plated Fists]|h|r"] = {
      ["need"] = "Warrior Tank, DK Tank, Paladin Tank",
      ["greed"] = "Tank OS",
    },
    ["|cffa335ee|Hitem:50418:0:0:0:0:0:0:0:1|h[Robe of the Waking Nightmare]|h|r"] = {
      ["need"] = "All DPS Casters",
      ["greed"] = "Other casters",
    },
  }  
end