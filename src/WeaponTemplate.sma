/* Amxx编写头版 来自 Aperture Science Team【光圈科技战队】 */

#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>
#include <wpn_const>
#include <xs>

#pragma semicolon 1

#define PLUGINNAME		"【AST】加枪模板"
#define VERSION			"1.38"
#define AUTHOR			"Fly"

#define KNIFE_COMMAND		"normal_knife"
#define VEST_COMMAND		"vest"
#define VESTHELM_COMMAND	"vesthelm"
#define DEFUSER_COMMAND		"defuser"
#define NVG_COMMAND		"nvgs"
#define EMPTY_COMMAND		"empty"

new const g_szGameWeaponClassName[][] = { "", "weapon_p228", "", "weapon_scout", "weapon_hegrenade", "weapon_xm1014", "weapon_c4", "weapon_mac10", "weapon_aug", "weapon_smokegrenade",
"weapon_elite", "weapon_fiveseven", "weapon_ump45", "weapon_sg550", "weapon_galil", "weapon_famas", "weapon_usp", "weapon_glock18", "weapon_awp", "weapon_mp5navy", "weapon_m249",
"weapon_m3", "weapon_m4a1", "weapon_tmp", "weapon_g3sg1", "weapon_flashbang", "weapon_deagle", "weapon_sg552", "weapon_ak47", "weapon_knife","weapon_p90" };

new const g_szGameWeaponBuyCommand[][] = { "", "p228", "", "scout", "hegren", "xm1014", "c4", "mac10", "aug", "sgren", "elites", "fn57", "ump45", "sg550", "galil", "famas", "usp",
"glock", "awp", "mp5", "m249", "m3", "m4a1", "tmp", "g3sg1", "flash", "deagle", "sg552", "ak47", "knife", "p90" };

new const g_szGameWeaponKillSPR[][] = { "", "p228", "", "scout", "grenade", "xm1014", "", "mac10", "aug", "", "elite", "fiveseven", "ump45", "sg550", "galil", "famas", "usp",
"glock18", "awp", "mp5navy", "m249", "m3", "m4a1", "tmp", "g3sg1", "flashbang", "deagle", "sg552", "ak47", "knife", "p90" };

new const g_szGameWeaponAmmoType[][] = { "", "357sig", "", "762nato", "", "buckshot", "", "45acp", "556nato", "", "9mm", "57mm", "45acp", "556nato", "556nato", "556nato", "45acp", "9mm", "338magnum",
"9mm", "556natobox", "buckshot", "556nato", "9mm", "762nato", "", "50ae", "556nato", "762nato", "", "57mm" };

new const g_iWeaponDefaultTeam[] = { 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 1, 2, 0, 2, 1, 2, 0, 0, 0, 0, 0, 0, 2, 2, 1, 0, 0, 1, 1, 0, 0 };

new const g_iWeaponDefaultCost[] = { -1, 600, -1, 2750, 300, 3000, 0, 1400, 3500, 300, 800, 750, 1700, 4200, 2000, 2250, 500, 400, 4750, 1500, 5750, 1700, 3100, 1250, 5000, 200, 650,
3500, 2500, 0, 2350 };

new const g_szGameWeaponAmmoId[] = { -1, 9, -1, 2, 12, 5, 14, 6, 4, 13, 10, 7, 6, 4, 4, 4, 6, 10, 1, 10, 3, 5, 4, 10, 2, 11, 8, 4, 2, 0, 7 };

new const g_szGameWeaponPosition[] = { -1, 1, -1, 0, 3, 0, 4, 0, 0, 3, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 3, 1, 0, 0, 2, 0 };

new const g_szGameWeaponSlot[] = { -1, 3, -1, 9, 1, 12, 3, 13, 14, 3, 5, 6, 15, 16, 17, 18, 4, 2, 2, 7, 4, 5, 6, 11, 3, 2, 1, 10, 1, 1, 8 };

new const g_szWeaponMaxBpammo[] = { -1, 52, -1, 90, 1, 32, 1, 100, 90, 1, 120, 100, 100, 90, 90, 90, 100, 120, 30, 120, 200, 32, 90, 120, 90, 2, 35, 90, 90, -1, 100 };

new const g_iPrimId[MAX_PRIM] = { CSW_SCOUT, CSW_XM1014, CSW_MAC10, CSW_AUG, CSW_UMP45, CSW_SG550, CSW_GALIL, CSW_FAMAS, CSW_AWP, CSW_MP5NAVY, CSW_M249, CSW_M3, CSW_M4A1, CSW_TMP,
CSW_G3SG1, CSW_SG552, CSW_AK47, CSW_P90 };

new const g_iPrimCost[MAX_PRIM] = { 80, 65, 25, 60, 25, 60, 60, 60, 125, 20, 60, 65, 60, 20, 80, 60, 80, 50 };

new const g_iPrimAmount[MAX_PRIM] = { 30, 8, 12, 30, 12, 30, 30, 30, 10, 30, 30, 8, 30, 30, 30, 30, 30, 50 };

new const g_iSecondId[MAX_SEC] = { CSW_P228, CSW_ELITE, CSW_FIVESEVEN, CSW_USP, CSW_GLOCK18, CSW_DEAGLE };

new const g_iSecondCost[MAX_SEC] = { 50, 20, 50, 25, 20, 40 };

new const g_iSecAmount[MAX_SEC] = { 13, 30, 50, 12, 30, 7 };

stock GUNSHOT_DECALS[] = { 41, 42, 43, 44, 45 };

new g_iWeaponAmount;
new g_iWeaponId[33][MAXWEAPON];
new g_szWeaponList[33][MAXWEAPON][64];
new g_szWeaponPModel[33][MAXWEAPON][64];
new g_szWeaponVModel[33][MAXWEAPON][64];
new g_szWeaponWModel[33][MAXWEAPON][64];
new g_szWeaponSPR[33][MAXWEAPON][64];
new g_szWeaponSound1[33][MAXWEAPON][64];
new g_szWeaponSound2[33][MAXWEAPON][64];
new g_szWeaponSound3[33][MAXWEAPON][64];
new g_szWeaponSound4[33][MAXWEAPON][64];
new g_szWeaponSound5[33][MAXWEAPON][64];
new g_szWeaponSound6[33][MAXWEAPON][64];
new g_iReloadMode[33][MAXWEAPON];
new g_iWeaponClip[33][MAXWEAPON];
new g_iWeaponAmmo[33][MAXWEAPON];
new Float:g_fWeaponDamage[33][MAXWEAPON];
new Float:g_fWeaponSpeed[33][MAXWEAPON];
new Float:g_fWeaponAimSpeed[33][MAXWEAPON];
new Float:g_fWeaponSilencedSpeed[33][MAXWEAPON];
new Float:g_fWeaponRecoil[33][MAXWEAPON];
new Float:g_fWeaponAimRecoil[33][MAXWEAPON];
new Float:g_fWeaponReloadTime[33][MAXWEAPON][3];
new g_szWeaponBuyCommand[33][MAXWEAPON][64];
new g_iWeaponCost[33][MAXWEAPON];
new g_iWeaponAnim[33][MAXWEAPON][MAXANIMATION];
new Float:g_fWeaponDrawTime[33][MAXWEAPON];
new Float:g_fGrenadeData[33][MAXWEAPON][3];
new g_iGrenadeSprId[33][MAXWEAPON];
new Float:g_fWeaponAimAccuracy[33][MAXWEAPON];
new Float:g_fWeaponAccuracy[33][MAXWEAPON];
new g_iWeaponTeam[33][MAXWEAPON];
new Float:g_fWeaponMaxSpeed[33][MAXWEAPON];
new Float:g_fWeaponKnockBack[33][MAXWEAPON];
new g_iWeaponTemplateSerialNumber[3][MAXWEAPON];
new g_iWeaponSight[33][MAXWEAPON];
new g_szWeaponVModelS[33][MAXWEAPON][64];
new Float:g_fSightDistance[33][MAXWEAPON];
new Float:g_fSightFrameRate[33][MAXWEAPON];
new Float:g_fSightOpenTime[33][MAXWEAPON];
new Float:g_fSightCloseTime[33][MAXWEAPON];
new Float:g_fWeaponSilencedTime[33][MAXWEAPON][2];
new Float:g_fWeaponSilencedRecoil[33][MAXWEAPON];
new Float:g_fWeaponSilencedAccuracy[33][MAXWEAPON];
new Float:g_fWeaponAimMaxSpeed[33][MAXWEAPON];
new g_iWeaponWModelBody[33][MAXWEAPON];
new g_iWeaponAmmoCost[33][MAXWEAPON];
new Float:g_fWeaponDamage2[33][MAXWEAPON];
new Float:g_fKnifeSlashResetTime[33][MAXWEAPON];
new Float:g_fKnifeSlashTime[33][MAXWEAPON];
new Float:g_fKnifeSlashRange[33][MAXWEAPON];
new Float:g_fKnifeStabResetTime[33][MAXWEAPON];
new Float:g_fKnifeStabTime[33][MAXWEAPON];
new Float:g_fKnifeStabRange[33][MAXWEAPON];
new g_iKnifeAnim[33][MAXWEAPON][KNIFE_MAXANIMATION];
new Float:g_fKnifeSlashAngle[33][MAXWEAPON];
new Float:g_fKnifeStabAngle[33][MAXWEAPON];
new g_iCurWeaponBPAmmo[33][MAXWEAPON];
new Float:g_fWeaponFireSoundVolume[33][MAXWEAPON];
new Float:g_fWeaponSilenceFireSoundVolume[33][MAXWEAPON];
new Float:g_fKnifeSoundVolume[33][MAXWEAPON][5];
new Float:g_fKnifeSlashAngleOffset[33][MAXWEAPON];
new Float:g_fKnifeStabAngleOffset[33][MAXWEAPON];
new Float:g_fKnifeSlashHeight[33][MAXWEAPON];
new Float:g_fKnifeStabHeight[33][MAXWEAPON];
new Float:g_fKnifeSlashHeightOffset[33][MAXWEAPON];
new Float:g_fKnifeStabHeightOffset[33][MAXWEAPON];

new g_iUser1[33][MAXWEAPON];
new g_iUser2[33][MAXWEAPON];
new g_iUser3[33][MAXWEAPON];
new g_iUser4[33][MAXWEAPON];
new Float:g_fUser1[33][MAXWEAPON];
new Float:g_fUser2[33][MAXWEAPON];
new Float:g_fUser3[33][MAXWEAPON];
new Float:g_fUser4[33][MAXWEAPON];
new g_szUser1[33][MAXWEAPON][64];
new g_szUser2[33][MAXWEAPON][64];
new g_szUser3[33][MAXWEAPON][64];
new g_szUser4[33][MAXWEAPON][64];

new Float:g_flDisableBuyTime;
new bool:g_IsInPrimaryAttack;
new Float:cl_fPushAngle[33][3];
new g_iClipAmmo[33];
new g_iTmpClip[33][MAXWEAPON];
new bool:g_fwBotForwardRegister;
new g_iKnifeAttack[33];
new g_iKnifeSlashMode[33];
new Float:g_fPlayerThink[33];
new spr_blood_spray;
new spr_blood_drop;
new g_iUserGrenadeId[33];
new g_iSmokeId;
new g_iBloodColor;
new g_iBlockBuy[33];
new g_iAllTeamBuy;
new SightMode[33];
new bool:Reload[33];
new Float:NextThink[33];
new bool:OldButton[33];
new bool:g_iRoundStart;
new g_iBotMoney[33];
new bool:g_iBotBuyWeapon[33];
new Float:g_fBotNextThink[33];
new g_iRound;
new g_iAttackerEntity[33];
new Float:g_fKnifeTempDamage[33];
new g_szGameWeaponMaxBpammo[32];
new g_iGameCurWeaponBPAmmo[33][32];
new Float:g_fDamagePoint[33];
new Float:g_fDamageVictimPoint[33];
new Float:g_fKnockBackPoint[33];
new g_iMaxMoney;
new g_iAttackHitGroup[33];
new bool:g_iRoundRestart;
new g_iEliteShotNumber[33];
new g_iUserKnifeAttack[33];
new Float:g_fUserDeploy[33][2];

new g_fwDummyResult;
new g_fwPrimaryPreAttackPre;
new g_fwPrimaryPreAttackPost;
new g_fwPrimaryPostAttackPre;
new g_fwPrimaryPostAttackPost;
new g_fwSecondaryPreAttackPre;
new g_fwSecondaryPreAttackPost;
new g_fwSecondaryPostAttackPre;
new g_fwSecondaryPostAttackPost;
new g_fwPrimaryAttackEndPre;
new g_fwPrimaryAttackEndPost;
new g_fwSecondaryAttackEndPre;
new g_fwSecondaryAttackEndPost;
new g_fwWeaponIdlePre;
new g_fwWeaponReloadPre;
new g_fwWeaponReloadPost;
new g_fwWeaponDraw;
new g_fwBuyWeaponPre;
new g_fwBuyWeaponPost;
new g_fwSetMaxSpeedPre;
new g_fwWeaponKnockBackPre;
new g_fwSpawnBlood;
new g_fwGrenadeExplode;
new g_fwGrenadeExplodePost;
new g_fwBotBuyWeapon;
new g_fwBotBuyWeaponPost;
new g_fwWeaponPostFrame;
new g_fwTakeDamage;
new g_fwLoadFiles;
new g_fwDeathMsg;

public plugin_init()
{
	register_plugin(PLUGINNAME, VERSION, AUTHOR);
	register_message(get_user_msgid("DeathMsg"), "Message_DeathMsg");
	register_message(get_user_msgid("TextMsg"), "Message_TextMsg");
	register_message(SVC_TEMPENTITY, "Message_TEMPENTITY");
	register_message(get_user_msgid("StatusIcon"), "Message_StatusIcon");
	register_event("CurWeapon", "Event_CurWeapon", "be", "1=1");
	register_event("HLTV", "Event_Round_Start", "a", "1=0", "2=0");
	register_logevent("Event_FreezeEnd", 2, "1=Round_Start");
	register_forward(FM_ClientCommand, "fw_ClientCommand");
	register_forward(FM_SetModel, "fw_SetModel");
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", 1);
	register_forward(FM_PlaybackEvent, "fw_PlaybackEvent");
	register_forward(FM_EmitSound, "fw_EmitSound");
	register_forward(FM_TraceLine, "fw_TraceLine");
	register_forward(FM_TraceHull, "fw_TraceHull");
	register_forward(FM_PlayerPostThink, "fw_PlayerPostThink_Post", 1);
	register_forward(FM_PlayerPreThink, "fw_PlayerPreThink");
	register_forward(FM_Think, "fw_Think_Post", 1);
	for (new i = 1; i < sizeof g_szGameWeaponClassName; i ++)
	{
		if (!g_szGameWeaponClassName[i][0])
		continue;

		RegisterHam(Ham_Item_AddToPlayer, g_szGameWeaponClassName[i], "HAM_Item_AddToPlayer_Post", 1);
		RegisterHam(Ham_Item_Deploy, g_szGameWeaponClassName[i], "HAM_Item_Deploy");
		RegisterHam(Ham_Item_Deploy, g_szGameWeaponClassName[i], "HAM_Item_Deploy_Post", 1);
		RegisterHam(Ham_Item_Holster, g_szGameWeaponClassName[i], "HAM_Item_Holster_Post", 1);
		RegisterHam(Ham_Weapon_PrimaryAttack, g_szGameWeaponClassName[i], "HAM_Weapon_PrimaryAttack");
		RegisterHam(Ham_Weapon_PrimaryAttack, g_szGameWeaponClassName[i], "HAM_Weapon_PrimaryAttack_Post", 1);
		RegisterHam(Ham_Weapon_SecondaryAttack, g_szGameWeaponClassName[i], "HAM_Weapon_SecondaryAttack");
		RegisterHam(Ham_Weapon_SecondaryAttack, g_szGameWeaponClassName[i], "HAM_Weapon_SecondaryAttack_Post", 1);
		RegisterHam(Ham_Item_PostFrame, g_szGameWeaponClassName[i], "HAM_Item_PostFrame");
		RegisterHam(Ham_Weapon_Reload, g_szGameWeaponClassName[i], "HAM_Weapon_Reload");
		RegisterHam(Ham_Weapon_Reload, g_szGameWeaponClassName[i], "HAM_Weapon_Reload_Post", 1);
		RegisterHam(Ham_Weapon_WeaponIdle, g_szGameWeaponClassName[i], "HAM_Weapon_WeaponIdle");
	}
	RegisterHam(Ham_Use, "func_tank", "HAM_UseStationary_Post", 1);
	RegisterHam(Ham_Use, "func_tankmortar", "HAM_UseStationary_Post", 1);
	RegisterHam(Ham_Use, "func_tankrocket", "HAM_UseStationary_Post", 1);
	RegisterHam(Ham_Use, "func_tanklaser", "HAM_UseStationary_Post", 1);
	RegisterHam(Ham_TakeDamage, "player", "HAM_TakeDamage");
	RegisterHam(Ham_TakeDamage, "player", "HAM_TakeDamage_Post", 1);
	RegisterHam(Ham_Killed, "player", "HAM_Killed_Post", 1);
	RegisterHam(Ham_Think, "grenade", "HAM_ThinkGrenade");
	RegisterHam(Ham_GiveAmmo, "player", "HAM_GiveAmmo");
	RegisterHam(Ham_Spawn, "player", "HAM_PlayerSpawn_Post", 1);
	RegisterHam(Ham_TraceAttack, "worldspawn", "HAM_TraceAttack_Post", 1);
	RegisterHam(Ham_TraceAttack, "func_breakable", "HAM_TraceAttack_Post", 1);
	RegisterHam(Ham_TraceAttack, "func_wall", "HAM_TraceAttack_Post", 1);
	RegisterHam(Ham_TraceAttack, "func_door", "HAM_TraceAttack_Post", 1);
	RegisterHam(Ham_TraceAttack, "func_door_rotating", "HAM_TraceAttack_Post", 1);
	RegisterHam(Ham_TraceAttack, "func_plat", "HAM_TraceAttack_Post", 1);
	RegisterHam(Ham_TraceAttack, "func_rotating", "HAM_TraceAttack_Post", 1);
	g_fwPrimaryPreAttackPre = CreateMultiForward("WPN_PrimaryPreAttack", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwPrimaryPreAttackPost = CreateMultiForward("WPN_PrimaryPreAttack_Post", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwPrimaryPostAttackPre = CreateMultiForward("WPN_PrimaryPostAttack", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwPrimaryPostAttackPost = CreateMultiForward("WPN_PrimaryPostAttack_Post", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwSecondaryPreAttackPre = CreateMultiForward("WPN_SecondaryPreAttack", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwSecondaryPreAttackPost = CreateMultiForward("WPN_SecondaryPreAttack_Post", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwSecondaryPostAttackPre = CreateMultiForward("WPN_SecondaryPostAttack", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwSecondaryPostAttackPost = CreateMultiForward("WPN_SecondaryPostAttack_Post", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwPrimaryAttackEndPre = CreateMultiForward("WPN_PrimaryAttackEnd", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwPrimaryAttackEndPost = CreateMultiForward("WPN_PrimaryAttackEnd_Post", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwSecondaryAttackEndPre = CreateMultiForward("WPN_SecondaryAttackEnd", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwSecondaryAttackEndPost = CreateMultiForward("WPN_SecondaryAttackEnd_Post", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwWeaponIdlePre = CreateMultiForward("WPN_WeaponIdle", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwWeaponReloadPre = CreateMultiForward("WPN_WeaponReload", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwWeaponReloadPost = CreateMultiForward("WPN_WeaponReload_Post", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwBuyWeaponPre = CreateMultiForward("WPN_BuyWeapon", ET_CONTINUE, FP_CELL, FP_STRING);
	g_fwBuyWeaponPost = CreateMultiForward("WPN_BuyWeapon_Post", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwWeaponDraw = CreateMultiForward("WPN_WeaponDraw", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwSetMaxSpeedPre = CreateMultiForward("WPN_WeaponMaxSpeed", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwWeaponKnockBackPre = CreateMultiForward("WPN_WeaponKnockBack", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL, FP_CELL, FP_FLOAT);
	g_fwSpawnBlood = CreateMultiForward("WPN_HookSpawnBlood", ET_CONTINUE, FP_CELL);
	g_fwGrenadeExplode = CreateMultiForward("WPN_HookGrenadeExplode", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwGrenadeExplodePost = CreateMultiForward("WPN_HookGrenadeExplode_Post", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL, FP_CELL);
	g_fwBotBuyWeapon = CreateMultiForward("WPN_BotBuyWeapon", ET_CONTINUE, FP_CELL);
	g_fwBotBuyWeaponPost = CreateMultiForward("WPN_BotBuyWeapon_Post", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwWeaponPostFrame = CreateMultiForward("WPN_WeaponPostFrame", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL);
	g_fwTakeDamage = CreateMultiForward("WPN_TakeDamage", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL, FP_FLOAT, FP_CELL);
	g_fwDeathMsg = CreateMultiForward("WPN_DeathMsg", ET_CONTINUE, FP_CELL, FP_CELL, FP_CELL, FP_STRING);
	for (new i = 0; i < sizeof g_szWeaponMaxBpammo; i ++) g_szGameWeaponMaxBpammo[i] = g_szWeaponMaxBpammo[i];
	for (new i = 1; i < 33; i ++) g_fDamagePoint[i] = 1.0;
	for (new i = 1; i < 33; i ++) g_fKnockBackPoint[i] = 1.0;
	for (new i = 1; i < 33; i ++) g_fDamageVictimPoint[i] = 1.0;
	for (new i = 1; i <= g_iWeaponAmount; i ++)
	{
		for (new id = 1; id < 33; id ++)
		{
			if (!g_fWeaponFireSoundVolume[id][i])
			{
				if (g_iWeaponId[id][i] == CSW_HEGRENADE) g_fWeaponFireSoundVolume[id][i] = 0.25;
				else g_fWeaponFireSoundVolume[id][i] = 0.35;
			}
			if (!g_fWeaponSilenceFireSoundVolume[id][i]) g_fWeaponSilenceFireSoundVolume[id][i] = ATTN_NORM;
			for (new j = 0; j < 5; j ++) if (!g_fKnifeSoundVolume[id][i][j]) g_fKnifeSoundVolume[id][i][j] = ATTN_NORM;
		}
	}
	g_fwBotForwardRegister = true;
	g_iBloodColor = 247;
	g_iMaxMoney = MAXMONEY;
}

public plugin_precache()
{
	new file[256], config[256];
	spr_blood_spray = engfunc(EngFunc_PrecacheModel, "sprites/bloodspray.spr");
	spr_blood_drop = engfunc(EngFunc_PrecacheModel, "sprites/blood.spr");
	g_iSmokeId = engfunc(EngFunc_PrecacheModel, "sprites/smokepuff.spr");
	g_flDisableBuyTime = get_gametime() + (get_cvar_float("mp_buytime") * 60.0);
	g_fwLoadFiles = CreateMultiForward("WPN_LoadFiles", ET_CONTINUE, FP_CELL, FP_CELL, FP_STRING, FP_STRING);
	get_localinfo("amxx_configsdir", config, charsmax(config));
	formatex(file, charsmax(file), "%s/newweapon.ini", config);
	if (file_exists(file)) LoadWeapon(file);
	formatex(file, charsmax(file), "%s/newknife.ini", config);
	if (file_exists(file)) LoadKnife(file);
	formatex(file, charsmax(file), "%s/newgrenade.ini", config);
	if (file_exists(file)) LoadGrenade(file);

	GUNSHOT_DECALS[0] = engfunc(EngFunc_DecalIndex, "{shot1");
	GUNSHOT_DECALS[1] = engfunc(EngFunc_DecalIndex, "{shot2");
	GUNSHOT_DECALS[2] = engfunc(EngFunc_DecalIndex, "{shot3");
	GUNSHOT_DECALS[3] = engfunc(EngFunc_DecalIndex, "{shot4");
	GUNSHOT_DECALS[4] = engfunc(EngFunc_DecalIndex, "{shot5");
}

public LoadWeapon(files[])
{
	new linedata[192], key[64], value[64];
	new file = fopen(files, "rt");
	while (file && !feof(file))
	{
		fgets(file, linedata, charsmax(linedata));
		replace(linedata, charsmax(linedata), "^n", "");

		if (!linedata[0] || linedata[0] == ';')
		continue;

		strtok(linedata, key, charsmax(key), value, charsmax(value), '=');
		trim(key);
		trim(value);
		if (!strcmp(key, "武器序号"))
		{
			g_iWeaponAmount ++;
			g_iWeaponTemplateSerialNumber[SLOT_WEAPON][str_to_num(value)] = g_iWeaponAmount;
			continue;
		}
		if (!strcmp(key, "类型")) for (new i = 1; i < 33; i ++) g_iWeaponId[i][g_iWeaponAmount] = weapon_str_to_csw(value);
		else if (!strcmp(key, "上弹模式")) for (new i = 1; i < 33; i ++) g_iReloadMode[i][g_iWeaponAmount] = str_to_num(value);
		else if (!strcmp(key, "开启机瞄"))
		{
			for (new i = 1; i < 33; i ++)
			{
				if (g_iWeaponId[i][g_iWeaponAmount] != CSW_G3SG1 && g_iWeaponId[i][g_iWeaponAmount] != CSW_SG550 &&
				g_iWeaponId[i][g_iWeaponAmount] != CSW_AWP && g_iWeaponId[i][g_iWeaponAmount] != CSW_SCOUT) g_iWeaponSight[i][g_iWeaponAmount] = str_to_num(value);
				else g_iWeaponSight[i][g_iWeaponAmount] = 0;
			}
		}
		else if (!strcmp(key, "子弹数")) for (new i = 1; i < 33; i ++) g_iWeaponClip[i][g_iWeaponAmount] = str_to_num(value);
		else if (!strcmp(key, "备用子弹数")) for (new i = 1; i < 33; i ++) g_iWeaponAmmo[i][g_iWeaponAmount] = str_to_num(value);
		else if (!strcmp(key, "伤害倍数")) for (new i = 1; i < 33; i ++) g_fWeaponDamage[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "武器射速")) for (new i = 1; i < 33; i ++) g_fWeaponSpeed[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "武器开镜射速")) for (new i = 1; i < 33; i ++) g_fWeaponAimSpeed[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "武器消音射速")) for (new i = 1; i < 33; i ++) g_fWeaponSilencedSpeed[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "武器后座")) for (new i = 1; i < 33; i ++) g_fWeaponRecoil[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "武器开镜后座")) for (new i = 1; i < 33; i ++) g_fWeaponAimRecoil[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "武器消音后座")) for (new i = 1; i < 33; i ++) g_fWeaponSilencedRecoil[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "武器准确度")) for (new i = 1; i < 33; i ++) g_fWeaponAccuracy[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "武器开镜准确度")) for (new i = 1; i < 33; i ++) g_fWeaponAimAccuracy[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "武器消音准确度")) for (new i = 1; i < 33; i ++) g_fWeaponSilencedAccuracy[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "开启消音时间")) for (new i = 1; i < 33; i ++) g_fWeaponSilencedTime[i][g_iWeaponAmount][0] = str_to_float(value);
		else if (!strcmp(key, "关闭消音时间")) for (new i = 1; i < 33; i ++) g_fWeaponSilencedTime[i][g_iWeaponAmount][1] = str_to_float(value);
		else if (!strcmp(key, "镜头距离")) for (new i = 1; i < 33; i ++) g_fSightDistance[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "镜头变化幅度")) for (new i = 1; i < 33; i ++) g_fSightFrameRate[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "开启速度")) for (new i = 1; i < 33; i ++) g_fSightOpenTime[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "关闭速度")) for (new i = 1; i < 33; i ++) g_fSightCloseTime[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "换弹时间")) for (new i = 1; i < 33; i ++) g_fWeaponReloadTime[i][g_iWeaponAmount][0] = str_to_float(value);
		else if (!strcmp(key, "散弹开始换弹时间")) for (new i = 1; i < 33; i ++) g_fWeaponReloadTime[i][g_iWeaponAmount][1] = str_to_float(value);
		else if (!strcmp(key, "散弹结束换弹时间")) for (new i = 1; i < 33; i ++) g_fWeaponReloadTime[i][g_iWeaponAmount][2] = str_to_float(value);
		else if (!strcmp(key, "掏出时间")) for (new i = 1; i < 33; i ++) g_fWeaponDrawTime[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "行走速度")) for (new i = 1; i < 33; i ++) g_fWeaponMaxSpeed[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "开镜行走速度")) for (new i = 1; i < 33; i ++) g_fWeaponAimMaxSpeed[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "击退力度")) for (new i = 1; i < 33; i ++) g_fWeaponKnockBack[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "价格")) for (new i = 1; i < 33; i ++) g_iWeaponCost[i][g_iWeaponAmount] = str_to_num(value);
		else if (!strcmp(key, "子弹价格")) for (new i = 1; i < 33; i ++) g_iWeaponAmmoCost[i][g_iWeaponAmount] = str_to_num(value);
		else if (!strcmp(key, "队伍")) for (new i = 1; i < 33; i ++) g_iWeaponTeam[i][g_iWeaponAmount] = str_to_num(value);
		else if (!strcmp(key, "HUD菜单")) for (new i = 1; i < 33; i ++) copy(g_szWeaponList[i][g_iWeaponAmount], charsmax(value), value);
		else if (!strcmp(key, "杀敌SPR")) for (new i = 1; i < 33; i ++) copy(g_szWeaponSPR[i][g_iWeaponAmount], charsmax(value), value);
		else if (!strcmp(key, "W模型子模型序号")) for (new i = 1; i < 33; i ++) g_iWeaponWModelBody[i][g_iWeaponAmount] = str_to_num(value);
		else if (!strcmp(key, "P模型"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponPModel[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheModel, value);
		}
		else if (!strcmp(key, "V模型"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponVModel[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheModel, value);
		}
		else if (!strcmp(key, "W模型"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponWModel[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheModel, value);
		}
		else if (!strcmp(key, "机瞄模型"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponVModelS[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheModel, value);
		}
		else if (!strcmp(key, "开枪声音1"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponSound1[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheSound, value);
		}
		else if (!strcmp(key, "开枪声音2"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponSound2[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheSound, value);
		}
		else if (!strcmp(key, "消音开枪声音1"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponSound3[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheSound, value);
		}
		else if (!strcmp(key, "消音开枪声音2"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponSound4[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheSound, value);
		}
		else if (!strcmp(key, "开枪声音大小")) for (new i = 1; i < 33; i ++) g_fWeaponFireSoundVolume[i][g_iWeaponAmount] = ((str_to_float(value) > 0.0)? ((1.0 - str_to_float(value)) > 0.0? (1.0 - str_to_float(value)) : 0.0) : 0.35);
		else if (!strcmp(key, "消音开枪声音大小")) for (new i = 1; i < 33; i ++) g_fWeaponSilenceFireSoundVolume[i][g_iWeaponAmount] = ((str_to_float(value) > 0.0)? ((1.0 - str_to_float(value)) > 0.0? (1.0 - str_to_float(value)) : 0.0) : ATTN_NORM);
		else if (!strcmp(key, "购买命令")) for (new i = 1; i < 33; i ++) copy(g_szWeaponBuyCommand[i][g_iWeaponAmount], charsmax(value), value);
		else if (!strcmp(key, "静止动作")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_IDLE] = str_to_num(value);
		else if (!strcmp(key, "换弹动作")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_RELOAD] = str_to_num(value);
		else if (!strcmp(key, "掏出动作")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_DRAW] = str_to_num(value);
		else if (!strcmp(key, "射击动作1")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_SHOOT1] = str_to_num(value);
		else if (!strcmp(key, "射击动作2")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_SHOOT2] = str_to_num(value);
		else if (!strcmp(key, "射击动作3")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_SHOOT3] = str_to_num(value);
		else if (!strcmp(key, "散弹换弹开始")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_START_RELOAD] = str_to_num(value);
		else if (!strcmp(key, "散弹换弹装弹")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_INSERT] = str_to_num(value);
		else if (!strcmp(key, "散弹换弹结束")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_AFTER_RELOAD] = str_to_num(value);
		else if (!strcmp(key, "机瞄开启动作")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_SIGHT_OPEN] = str_to_num(value);
		else if (!strcmp(key, "机瞄关闭动作")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_SIGHT_CLOSE] = str_to_num(value);
		else if (!strcmp(key, "消音开启动作")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_ATTACH_SILENCER] = str_to_num(value);
		else if (!strcmp(key, "消音关闭动作")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_DETACH_SILENCER] = str_to_num(value);
		else if (!strcmp(key, "消音静止动作")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_IDLE_SILENCED] = str_to_num(value);
		else if (!strcmp(key, "消音换弹动作")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_RELOAD_SILENCED] = str_to_num(value);
		else if (!strcmp(key, "消音掏出动作")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_DRAW_SILENCED] = str_to_num(value);
		else if (!strcmp(key, "消音射击动作1")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_SHOOT1_SILENCED] = str_to_num(value);
		else if (!strcmp(key, "消音射击动作2")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_SHOOT2_SILENCED] = str_to_num(value);
		else if (!strcmp(key, "消音射击动作3")) for (new i = 1; i < 33; i ++) g_iWeaponAnim[i][g_iWeaponAmount][ANIM_SHOOT3_SILENCED] = str_to_num(value);
		ExecuteForward(g_fwLoadFiles, g_fwDummyResult, SLOT_WEAPON, g_iWeaponAmount, key, value);
	}
	fclose(file);
}

public LoadKnife(files[])
{
	new linedata[192], key[64], value[64];
	new file = fopen(files, "rt");
	while (file && !feof(file))
	{
		fgets(file, linedata, charsmax(linedata));
		replace(linedata, charsmax(linedata), "^n", "");

		if (!linedata[0] || linedata[0] == ';')
		continue;

		strtok(linedata, key, charsmax(key), value, charsmax(value), '=');
		trim(key);
		trim(value);
		if (!strcmp(key, "武器序号"))
		{
			g_iWeaponAmount ++;
			g_iWeaponTemplateSerialNumber[SLOT_KNIFE][str_to_num(value)] = g_iWeaponAmount;
			for (new i = 1; i < 33; i ++) g_iWeaponId[i][g_iWeaponAmount] = CSW_KNIFE;
			continue;
		}
		if (!strcmp(key, "轻击结束时间")) for (new i = 1; i < 33; i ++) g_fKnifeSlashResetTime[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "轻击延迟时间")) for (new i = 1; i < 33; i ++) g_fKnifeSlashTime[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "轻击距离")) for (new i = 1; i < 33; i ++) g_fKnifeSlashRange[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "轻击角度")) for (new i = 1; i < 33; i ++) g_fKnifeSlashAngle[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "轻击角度判断间隔")) for (new i = 1; i < 33; i ++) g_fKnifeSlashAngleOffset[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "轻击高度")) for (new i = 1; i < 33; i ++) g_fKnifeSlashHeight[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "轻击高度判断间隔")) for (new i = 1; i < 33; i ++) g_fKnifeSlashHeightOffset[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "重击结束时间")) for (new i = 1; i < 33; i ++) g_fKnifeStabResetTime[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "重击延迟时间")) for (new i = 1; i < 33; i ++) g_fKnifeStabTime[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "重击距离")) for (new i = 1; i < 33; i ++) g_fKnifeStabRange[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "重击角度")) for (new i = 1; i < 33; i ++) g_fKnifeStabAngle[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "重击角度判断间隔")) for (new i = 1; i < 33; i ++) g_fKnifeStabAngleOffset[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "重击高度")) for (new i = 1; i < 33; i ++) g_fKnifeStabHeight[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "重击高度判断间隔")) for (new i = 1; i < 33; i ++) g_fKnifeStabHeightOffset[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "掏出时间")) for (new i = 1; i < 33; i ++) g_fWeaponDrawTime[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "伤害倍数")) for (new i = 1; i < 33; i ++) g_fWeaponDamage[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "重击伤害倍数")) for (new i = 1; i < 33; i ++) g_fWeaponDamage2[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "行走速度")) for (new i = 1; i < 33; i ++) g_fWeaponMaxSpeed[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "击退")) for (new i = 1; i < 33; i ++) g_fWeaponKnockBack[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "价格")) for (new i = 1; i < 33; i ++) g_iWeaponCost[i][g_iWeaponAmount] = str_to_num(value);
		else if (!strcmp(key, "队伍")) for (new i = 1; i < 33; i ++) g_iWeaponTeam[i][g_iWeaponAmount] = str_to_num(value);
		else if (!strcmp(key, "HUD菜单")) for (new i = 1; i < 33; i ++) copy(g_szWeaponList[i][g_iWeaponAmount], charsmax(value), value);
		else if (!strcmp(key, "杀敌SPR")) for (new i = 1; i < 33; i ++) copy(g_szWeaponSPR[i][g_iWeaponAmount], charsmax(value), value);
		else if (!strcmp(key, "P模型"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponPModel[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheModel, value);
		}
		else if (!strcmp(key, "V模型"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponVModel[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheModel, value);
		}
		else if (!strcmp(key, "掏出声音"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponSound1[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheSound, value);
		}
		else if (!strcmp(key, "击墙声音"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponSound2[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheSound, value);
		}
		else if (!strcmp(key, "击空声音"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponSound3[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheSound, value);
		}
		else if (!strcmp(key, "重击声音"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponSound4[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheSound, value);
		}
		else if (!strcmp(key, "轻击声音1"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponSound5[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheSound, value);
		}
		else if (!strcmp(key, "轻击声音2"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponSound6[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheSound, value);
		}
		else if (!strcmp(key, "击墙声音大小")) for (new i = 1; i < 33; i ++) g_fKnifeSoundVolume[i][g_iWeaponAmount][0] = ((str_to_float(value) > 0.0)? ((1.0 - str_to_float(value)) > 0.0? (1.0 - str_to_float(value)) : 0.0) : ATTN_NORM);
		else if (!strcmp(key, "击空声音大小")) for (new i = 1; i < 33; i ++) g_fKnifeSoundVolume[i][g_iWeaponAmount][1] = ((str_to_float(value) > 0.0)? ((1.0 - str_to_float(value)) > 0.0? (1.0 - str_to_float(value)) : 0.0) : ATTN_NORM);
		else if (!strcmp(key, "重击声音大小")) for (new i = 1; i < 33; i ++) g_fKnifeSoundVolume[i][g_iWeaponAmount][2] = ((str_to_float(value) > 0.0)? ((1.0 - str_to_float(value)) > 0.0? (1.0 - str_to_float(value)) : 0.0) : ATTN_NORM);
		else if (!strcmp(key, "轻击声音1大小")) for (new i = 1; i < 33; i ++) g_fKnifeSoundVolume[i][g_iWeaponAmount][3] = ((str_to_float(value) > 0.0)? ((1.0 - str_to_float(value)) > 0.0? (1.0 - str_to_float(value)) : 0.0) : ATTN_NORM);
		else if (!strcmp(key, "轻击声音2大小")) for (new i = 1; i < 33; i ++) g_fKnifeSoundVolume[i][g_iWeaponAmount][4] = ((str_to_float(value) > 0.0)? ((1.0 - str_to_float(value)) > 0.0? (1.0 - str_to_float(value)) : 0.0) : ATTN_NORM);
		else if (!strcmp(key, "购买命令")) for (new i = 1; i < 33; i ++) copy(g_szWeaponBuyCommand[i][g_iWeaponAmount], charsmax(value), value);
		else if (!strcmp(key, "静止动作")) for (new i = 1; i < 33; i ++) g_iKnifeAnim[i][g_iWeaponAmount][0] = str_to_num(value);
		else if (!strcmp(key, "轻击动作1")) for (new i = 1; i < 33; i ++) g_iKnifeAnim[i][g_iWeaponAmount][1] = str_to_num(value);
		else if (!strcmp(key, "轻击动作2")) for (new i = 1; i < 33; i ++) g_iKnifeAnim[i][g_iWeaponAmount][2] = str_to_num(value);
		else if (!strcmp(key, "掏出动作")) for (new i = 1; i < 33; i ++) g_iKnifeAnim[i][g_iWeaponAmount][3] = str_to_num(value);
		else if (!strcmp(key, "重击动作")) for (new i = 1; i < 33; i ++) g_iKnifeAnim[i][g_iWeaponAmount][4] = str_to_num(value);
		else if (!strcmp(key, "重击未击中动作")) for (new i = 1; i < 33; i ++) g_iKnifeAnim[i][g_iWeaponAmount][5] = str_to_num(value);
		else if (!strcmp(key, "轻击动作")) for (new i = 1; i < 33; i ++) g_iKnifeAnim[i][g_iWeaponAmount][6] = str_to_num(value);
		else if (!strcmp(key, "轻击未击中动作")) for (new i = 1; i < 33; i ++) g_iKnifeAnim[i][g_iWeaponAmount][7] = str_to_num(value);
		else if (!strcmp(key, "轻击开始动作")) for (new i = 1; i < 33; i ++) g_iKnifeAnim[i][g_iWeaponAmount][8] = str_to_num(value);
		else if (!strcmp(key, "重击开始动作")) for (new i = 1; i < 33; i ++) g_iKnifeAnim[i][g_iWeaponAmount][9] = str_to_num(value);
		ExecuteForward(g_fwLoadFiles, g_fwDummyResult, SLOT_KNIFE, g_iWeaponAmount, key, value);
	}
	fclose(file);
}

public LoadGrenade(files[])
{
	new linedata[192], key[64], value[64];
	new file = fopen(files, "rt");
	while (file && !feof(file))
	{
		fgets(file, linedata, charsmax(linedata));
		replace(linedata, charsmax(linedata), "^n", "");

		if (!linedata[0] || linedata[0] == ';')
		continue;

		strtok(linedata, key, charsmax(key), value, charsmax(value), '=');
		trim(key);
		trim(value);
		if (!strcmp(key, "武器序号"))
		{
			g_iWeaponAmount ++;
			g_iWeaponTemplateSerialNumber[SLOT_GRENADE][str_to_num(value)] = g_iWeaponAmount;
			for (new i = 1; i < 33; i ++) g_iWeaponId[i][g_iWeaponAmount] = CSW_HEGRENADE;
			continue;
		}
		if (!strcmp(key, "掏出时间")) for (new i = 1; i < 33; i ++) g_fWeaponDrawTime[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "爆炸时间")) for (new i = 1; i < 33; i ++) g_fGrenadeData[i][g_iWeaponAmount][1] = str_to_float(value);
		else if (!strcmp(key, "爆炸范围")) for (new i = 1; i < 33; i ++) g_fGrenadeData[i][g_iWeaponAmount][2] = str_to_float(value);
		else if (!strcmp(key, "伤害倍数")) for (new i = 1; i < 33; i ++) g_fWeaponDamage[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "行走速度")) for (new i = 1; i < 33; i ++) g_fWeaponMaxSpeed[i][g_iWeaponAmount] = str_to_float(value);
		else if (!strcmp(key, "价格")) for (new i = 1; i < 33; i ++) g_iWeaponCost[i][g_iWeaponAmount] = str_to_num(value);
		else if (!strcmp(key, "队伍")) for (new i = 1; i < 33; i ++) g_iWeaponTeam[i][g_iWeaponAmount] = str_to_num(value);
		else if (!strcmp(key, "HUD菜单")) for (new i = 1; i < 33; i ++) copy(g_szWeaponList[i][g_iWeaponAmount], charsmax(value), value);
		else if (!strcmp(key, "杀敌SPR")) for (new i = 1; i < 33; i ++) copy(g_szWeaponSPR[i][g_iWeaponAmount], charsmax(value), value);
		else if (!strcmp(key, "W模型子模型序号")) for (new i = 1; i < 33; i ++) g_iWeaponWModelBody[i][g_iWeaponAmount] = str_to_num(value);
		else if (!strcmp(key, "P模型"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponPModel[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheModel, value);
		}
		else if (!strcmp(key, "V模型"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponVModel[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheModel, value);
		}
		else if (!strcmp(key, "W模型"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponWModel[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheModel, value);
		}
		else if (!strcmp(key, "爆炸SPR"))
		{
			new iGrenadeSprId;
			if (value[0]) iGrenadeSprId = engfunc(EngFunc_PrecacheModel, value);
			for (new i = 1; i < 33; i ++) g_iGrenadeSprId[i][g_iWeaponAmount] = iGrenadeSprId;
		}
		else if (!strcmp(key, "爆炸声音"))
		{
			for (new i = 1; i < 33; i ++) copy(g_szWeaponSound1[i][g_iWeaponAmount], charsmax(value), value);
			if (value[0]) engfunc(EngFunc_PrecacheSound, value);
		}
		else if (!strcmp(key, "爆炸声音大小")) for (new i = 1; i < 33; i ++) g_fWeaponFireSoundVolume[i][g_iWeaponAmount] = ((str_to_float(value) > 0.0)? ((1.0 - str_to_float(value)) > 0.0? (1.0 - str_to_float(value)) : 0.0) : 0.25);
		else if (!strcmp(key, "购买命令")) for (new i = 1; i < 33; i ++) copy(g_szWeaponBuyCommand[i][g_iWeaponAmount], charsmax(value), value);
		ExecuteForward(g_fwLoadFiles, g_fwDummyResult, SLOT_GRENADE, g_iWeaponAmount, key, value);
	}
	fclose(file);
}

public plugin_natives()
{
	register_native("WPN_RegisterWeapon", "Native_RegisterWeapon");
	register_native("WPN_SetWeaponAnim", "Native_SetWeaponAnim");
	register_native("WPN_RegisterKnife", "Native_RegisterKnife");
	register_native("WPN_SetKnifeAnim", "Native_SetKnifeAnim");
	register_native("WPN_RegisterGrenade", "Native_RegisterGrenade");

	register_native("WPN_GetParamInt", "Native_GetParamInt", 1);
	register_native("WPN_GetParamFloat", "Native_GetParamFloat", 1);
	register_native("WPN_GetParamString", "Native_GetParamString");
	register_native("WPN_SetParamInt", "Native_SetParamInt", 1);
	register_native("WPN_SetParamFloat", "Native_SetParamFloat", 1);
	register_native("WPN_SetParamString", "Native_SetParamString");

	register_native("WPN_GiveWeapon", "Native_GiveWeapon", 1);
	register_native("WPN_ExecuteAttack", "Native_ExecuteAttack");
	register_native("WPN_SpawnBlood", "Native_SpawnBlood");
	register_native("WPN_FakeSmoke", "Native_FakeSmoke");
	register_native("WPN_GiveAmmo", "Native_GiveAmmo", 1);
}

public Native_RegisterWeapon(iPlugin, iParams)
{
	if (get_param(1) == CSW_KNIFE || get_param(1) == CSW_HEGRENADE || get_param(1) == CSW_FLASHBANG || get_param(1) == CSW_SMOKEGRENADE || get_param(1) == CSW_C4 || get_param(1) == CSW_VEST || get_param(1) == CSW_VESTHELM)
	return 0;

	new szWeaponList[64], szWeaponSPR[64], szWeaponModels[4][64], szWeaponSound[4][64], szWeaponBuyCommand[64], Float:fWeaponData[MaxWeaponFloatData], iWeaponData[MaxWeaponIntData];
	g_iWeaponAmount ++;
	get_array(2, iWeaponData, MaxWeaponIntData);
	get_array_f(3, fWeaponData, MaxWeaponFloatData);
	get_string(4, szWeaponList, charsmax(szWeaponList));
	get_string(5, szWeaponSPR, charsmax(szWeaponSPR));
	get_string(6, szWeaponModels[0], charsmax(szWeaponModels[]));
	get_string(7, szWeaponModels[1], charsmax(szWeaponModels[]));
	get_string(8, szWeaponModels[2], charsmax(szWeaponModels[]));
	get_string(9, szWeaponModels[3], charsmax(szWeaponModels[]));
	get_string(10, szWeaponSound[0], charsmax(szWeaponSound[]));
	get_string(11, szWeaponSound[1], charsmax(szWeaponSound[]));
	get_string(12, szWeaponSound[2], charsmax(szWeaponSound[]));
	get_string(13, szWeaponSound[3], charsmax(szWeaponSound[]));
	get_string(14, szWeaponBuyCommand, charsmax(szWeaponBuyCommand));
	for (new i = 1; i < 33; i ++)
	{
		g_iWeaponId[i][g_iWeaponAmount] = get_param(1);
		g_iReloadMode[i][g_iWeaponAmount] = iWeaponData[e_iReloadMode];
		if (get_param(1) != CSW_G3SG1 && get_param(1) != CSW_SG550 && get_param(1) != CSW_AWP && get_param(1) != CSW_SCOUT) g_iWeaponSight[i][g_iWeaponAmount] = iWeaponData[e_iWeaponSight];
		g_iWeaponClip[i][g_iWeaponAmount] = iWeaponData[e_iWeaponClip];
		g_iWeaponAmmo[i][g_iWeaponAmount] = iWeaponData[e_iWeaponAmmo];
		g_iWeaponCost[i][g_iWeaponAmount] = iWeaponData[e_iWeaponCost];
		g_iWeaponAmmoCost[i][g_iWeaponAmount] = iWeaponData[e_iWeaponAmmoCost];
		g_iWeaponTeam[i][g_iWeaponAmount] = iWeaponData[e_iWeaponTeam];
		g_iWeaponWModelBody[i][g_iWeaponAmount] = iWeaponData[e_iWeaponWModelBody];
		g_fWeaponDamage[i][g_iWeaponAmount] = Float:fWeaponData[e_fWeaponDamage];
		g_fWeaponSpeed[i][g_iWeaponAmount] = Float:fWeaponData[e_fWeaponSpeed];
		g_fWeaponAimSpeed[i][g_iWeaponAmount] = Float:fWeaponData[e_fWeaponAimSpeed];
		g_fWeaponSilencedSpeed[i][g_iWeaponAmount] = Float:fWeaponData[e_fWeaponSilencedSpeed];
		g_fWeaponRecoil[i][g_iWeaponAmount] = Float:fWeaponData[e_fWeaponRecoil];
		g_fWeaponAimRecoil[i][g_iWeaponAmount] = Float:fWeaponData[e_fWeaponAimRecoil];
		g_fWeaponSilencedRecoil[i][g_iWeaponAmount] = Float:fWeaponData[e_fWeaponSilencedRecoil];
		g_fWeaponAccuracy[i][g_iWeaponAmount] = Float:fWeaponData[e_fWeaponAccuracy];
		g_fWeaponAimAccuracy[i][g_iWeaponAmount] = Float:fWeaponData[e_fWeaponAimAccuracy];
		g_fWeaponSilencedAccuracy[i][g_iWeaponAmount] = Float:fWeaponData[e_fWeaponSilencedAccuracy];
		g_fWeaponReloadTime[i][g_iWeaponAmount][0] = Float:fWeaponData[e_fWeaponReloadTime];
		g_fWeaponReloadTime[i][g_iWeaponAmount][1] = Float:fWeaponData[e_fShotgunStartReloadTime];
		g_fWeaponReloadTime[i][g_iWeaponAmount][2] = Float:fWeaponData[e_fShotgunAfterReloadTime];
		g_fWeaponDrawTime[i][g_iWeaponAmount] = Float:fWeaponData[e_fWeaponDrawTime];
		g_fWeaponMaxSpeed[i][g_iWeaponAmount] = Float:fWeaponData[e_fWeaponMaxSpeed];
		g_fWeaponAimMaxSpeed[i][g_iWeaponAmount] = Float:fWeaponData[e_fWeaponAimMaxSpeed];
		g_fWeaponKnockBack[i][g_iWeaponAmount] = Float:fWeaponData[e_fWeaponKnockBack];
		g_fSightDistance[i][g_iWeaponAmount] = Float:fWeaponData[e_fSightDistance];
		g_fSightFrameRate[i][g_iWeaponAmount] = Float:fWeaponData[e_fSightFrameRate];
		g_fSightOpenTime[i][g_iWeaponAmount] = Float:fWeaponData[e_fSightOpenTime];
		g_fSightCloseTime[i][g_iWeaponAmount] = Float:fWeaponData[e_fSightCloseTime];
		g_fWeaponSilencedTime[i][g_iWeaponAmount][0] = Float:fWeaponData[e_fWeaponSilencedTime1];
		g_fWeaponSilencedTime[i][g_iWeaponAmount][1] = Float:fWeaponData[e_fWeaponSilencedTime2];
		g_fWeaponFireSoundVolume[i][g_iWeaponAmount] = Float:fWeaponData[e_fWeaponFireSoundVolume];
		g_fWeaponSilenceFireSoundVolume[i][g_iWeaponAmount] = Float:fWeaponData[e_fWeaponSilenceFireSoundVolume];
		copy(g_szWeaponList[i][g_iWeaponAmount], charsmax(szWeaponList), szWeaponList);
		copy(g_szWeaponSPR[i][g_iWeaponAmount], charsmax(szWeaponSPR), szWeaponSPR);
		copy(g_szWeaponPModel[i][g_iWeaponAmount], charsmax(szWeaponModels[]), szWeaponModels[0]);
		copy(g_szWeaponVModel[i][g_iWeaponAmount], charsmax(szWeaponModels[]), szWeaponModels[1]);
		copy(g_szWeaponWModel[i][g_iWeaponAmount], charsmax(szWeaponModels[]), szWeaponModels[2]);
		copy(g_szWeaponVModelS[i][g_iWeaponAmount], charsmax(szWeaponModels[]), szWeaponModels[3]);
		copy(g_szWeaponSound1[i][g_iWeaponAmount], charsmax(szWeaponSound[]), szWeaponSound[0]);
		copy(g_szWeaponSound2[i][g_iWeaponAmount], charsmax(szWeaponSound[]), szWeaponSound[1]);
		copy(g_szWeaponSound3[i][g_iWeaponAmount], charsmax(szWeaponSound[]), szWeaponSound[2]);
		copy(g_szWeaponSound4[i][g_iWeaponAmount], charsmax(szWeaponSound[]), szWeaponSound[3]);
		copy(g_szWeaponBuyCommand[i][g_iWeaponAmount], charsmax(szWeaponBuyCommand), szWeaponBuyCommand);
	}
	if (szWeaponModels[0][0]) engfunc(EngFunc_PrecacheModel, szWeaponModels[0]);
	if (szWeaponModels[1][0]) engfunc(EngFunc_PrecacheModel, szWeaponModels[1]);
	if (szWeaponModels[2][0]) engfunc(EngFunc_PrecacheModel, szWeaponModels[2]);
	if (szWeaponModels[3][0]) engfunc(EngFunc_PrecacheModel, szWeaponModels[3]);
	if (szWeaponSound[0][0]) engfunc(EngFunc_PrecacheSound, szWeaponSound[0]);
	if (szWeaponSound[1][0]) engfunc(EngFunc_PrecacheSound, szWeaponSound[1]);
	if (szWeaponSound[2][0]) engfunc(EngFunc_PrecacheSound, szWeaponSound[2]);
	if (szWeaponSound[3][0]) engfunc(EngFunc_PrecacheSound, szWeaponSound[3]);
	return g_iWeaponAmount;
}

public Native_SetWeaponAnim(iPlugin, iParams)
{
	new iShootAnim[3], iShotgunReload[3], iSilencedShootAnim[3];
	new i = get_param(1);
	get_array(5, iShootAnim, 3);
	get_array(6, iShotgunReload, 3);
	get_array(14, iSilencedShootAnim, 3);
	for (new id = 1; id < 33; id ++)
	{
		g_iWeaponAnim[id][i][ANIM_IDLE] = get_param(2);
		g_iWeaponAnim[id][i][ANIM_RELOAD] = get_param(3);
		g_iWeaponAnim[id][i][ANIM_DRAW] = get_param(4);
		g_iWeaponAnim[id][i][ANIM_SHOOT1] = iShootAnim[0];
		g_iWeaponAnim[id][i][ANIM_SHOOT2] = iShootAnim[1];
		g_iWeaponAnim[id][i][ANIM_SHOOT3] = iShootAnim[2];
		g_iWeaponAnim[id][i][ANIM_START_RELOAD] = iShotgunReload[0];
		g_iWeaponAnim[id][i][ANIM_INSERT] = iShotgunReload[1];
		g_iWeaponAnim[id][i][ANIM_AFTER_RELOAD] = iShotgunReload[2];
		g_iWeaponAnim[id][i][ANIM_SIGHT_OPEN] = get_param(7);
		g_iWeaponAnim[id][i][ANIM_SIGHT_CLOSE] = get_param(8);
		g_iWeaponAnim[id][i][ANIM_DETACH_SILENCER] = get_param(9);
		g_iWeaponAnim[id][i][ANIM_ATTACH_SILENCER] = get_param(10);
		g_iWeaponAnim[id][i][ANIM_IDLE_SILENCED] = get_param(11);
		g_iWeaponAnim[id][i][ANIM_RELOAD_SILENCED] = get_param(12);
		g_iWeaponAnim[id][i][ANIM_DRAW_SILENCED] = get_param(13);
		g_iWeaponAnim[id][i][ANIM_SHOOT1_SILENCED] = iSilencedShootAnim[0];
		g_iWeaponAnim[id][i][ANIM_SHOOT2_SILENCED] = iSilencedShootAnim[1];
		g_iWeaponAnim[id][i][ANIM_SHOOT3_SILENCED] = iSilencedShootAnim[2];
	}
}

public Native_RegisterKnife(iPlugin, iParams)
{
	new szWeaponList[64], szWeaponSPR[64], szWeaponModels[2][64], szWeaponSound[6][64], szWeaponBuyCommand[64], Float:fWeaponData[MaxKnifeFloatData];
	g_iWeaponAmount ++;
	get_string(1, szWeaponList, charsmax(szWeaponList));
	get_string(2, szWeaponSPR, charsmax(szWeaponSPR));
	get_string(3, szWeaponModels[0], charsmax(szWeaponModels[]));
	get_string(4, szWeaponModels[1], charsmax(szWeaponModels[]));
	get_string(5, szWeaponSound[0], charsmax(szWeaponSound[]));
	get_string(6, szWeaponSound[1], charsmax(szWeaponSound[]));
	get_string(7, szWeaponSound[2], charsmax(szWeaponSound[]));
	get_string(8, szWeaponSound[3], charsmax(szWeaponSound[]));
	get_string(9, szWeaponSound[4], charsmax(szWeaponSound[]));
	get_string(10, szWeaponSound[5], charsmax(szWeaponSound[]));
	get_string(12, szWeaponBuyCommand, charsmax(szWeaponBuyCommand));
	get_array_f(11, fWeaponData, MaxKnifeFloatData);
	for (new i = 1; i < 33; i ++)
	{
		g_iWeaponId[i][g_iWeaponAmount] = CSW_KNIFE;
		g_fKnifeSlashResetTime[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeSlashResetTime];
		g_fKnifeSlashTime[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeSlashTime];
		g_fKnifeSlashRange[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeSlashRange];
		g_fKnifeSlashAngle[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeSlashAngle];
		g_fKnifeSlashAngleOffset[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeSlashAngleOffset];
		g_fKnifeSlashHeight[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeSlashHeight];
		g_fKnifeSlashHeightOffset[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeSlashHeightOffset];
		g_fKnifeStabResetTime[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeStabResetTime];
		g_fKnifeStabTime[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeStabTime];
		g_fKnifeStabRange[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeStabRange];
		g_fKnifeStabAngle[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeStabAngle];
		g_fKnifeStabAngleOffset[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeStabAngleOffset];
		g_fKnifeStabHeight[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeStabHeight];
		g_fKnifeStabHeightOffset[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeStabHeightOffset];
		g_fWeaponDrawTime[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeDrawTime];
		g_fWeaponDamage[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeDamage];
		g_fWeaponDamage2[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeDamage2];
		g_fWeaponMaxSpeed[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeMaxSpeed];
		g_fWeaponKnockBack[i][g_iWeaponAmount] = Float:fWeaponData[e_fKnifeKnockBack];
		g_fKnifeSoundVolume[i][g_iWeaponAmount][0] = Float:fWeaponData[e_fKnifeSoundVolume1];
		g_fKnifeSoundVolume[i][g_iWeaponAmount][1] = Float:fWeaponData[e_fKnifeSoundVolume2];
		g_fKnifeSoundVolume[i][g_iWeaponAmount][2] = Float:fWeaponData[e_fKnifeSoundVolume3];
		g_fKnifeSoundVolume[i][g_iWeaponAmount][3] = Float:fWeaponData[e_fKnifeSoundVolume4];
		g_fKnifeSoundVolume[i][g_iWeaponAmount][4] = Float:fWeaponData[e_fKnifeSoundVolume5];
		g_iWeaponCost[i][g_iWeaponAmount] = get_param(13);
		g_iWeaponTeam[i][g_iWeaponAmount] = get_param(14);
		copy(g_szWeaponList[i][g_iWeaponAmount], charsmax(szWeaponList), szWeaponList);
		copy(g_szWeaponSPR[i][g_iWeaponAmount], charsmax(szWeaponSPR), szWeaponSPR);
		copy(g_szWeaponPModel[i][g_iWeaponAmount], charsmax(szWeaponModels[]), szWeaponModels[0]);
		copy(g_szWeaponVModel[i][g_iWeaponAmount], charsmax(szWeaponModels[]), szWeaponModels[1]);
		copy(g_szWeaponSound1[i][g_iWeaponAmount], charsmax(szWeaponSound[]), szWeaponSound[0]);
		copy(g_szWeaponSound2[i][g_iWeaponAmount], charsmax(szWeaponSound[]), szWeaponSound[1]);
		copy(g_szWeaponSound3[i][g_iWeaponAmount], charsmax(szWeaponSound[]), szWeaponSound[2]);
		copy(g_szWeaponSound4[i][g_iWeaponAmount], charsmax(szWeaponSound[]), szWeaponSound[3]);
		copy(g_szWeaponSound5[i][g_iWeaponAmount], charsmax(szWeaponSound[]), szWeaponSound[4]);
		copy(g_szWeaponSound6[i][g_iWeaponAmount], charsmax(szWeaponSound[]), szWeaponSound[5]);
		copy(g_szWeaponBuyCommand[i][g_iWeaponAmount], charsmax(szWeaponBuyCommand), szWeaponBuyCommand);
	}
	if (szWeaponModels[0][0]) engfunc(EngFunc_PrecacheModel, szWeaponModels[0]);
	if (szWeaponModels[1][0]) engfunc(EngFunc_PrecacheModel, szWeaponModels[1]);
	if (szWeaponSound[0][0]) engfunc(EngFunc_PrecacheSound, szWeaponSound[0]);
	if (szWeaponSound[1][0]) engfunc(EngFunc_PrecacheSound, szWeaponSound[1]);
	if (szWeaponSound[2][0]) engfunc(EngFunc_PrecacheSound, szWeaponSound[2]);
	if (szWeaponSound[3][0]) engfunc(EngFunc_PrecacheSound, szWeaponSound[3]);
	if (szWeaponSound[4][0]) engfunc(EngFunc_PrecacheSound, szWeaponSound[4]);
	if (szWeaponSound[5][0]) engfunc(EngFunc_PrecacheSound, szWeaponSound[5]);
	return g_iWeaponAmount;
}

public Native_SetKnifeAnim(iPlugin, iParams)
{
	new iWeaponAmount = get_param(1);
	for (new id = 1; id < 33; id ++) for (new i = 0; i < 10; i ++) g_iKnifeAnim[id][iWeaponAmount][i] = get_param(i + 2);
}

public Native_RegisterGrenade(iPlugin, iParams)
{
	new szWeaponList[64], szWeaponSPR[2][64], szWeaponModels[3][64], szWeaponSound[64], szWeaponBuyCommand[64], iGrenadeSprId;
	g_iWeaponAmount ++;
	get_string(1, szWeaponList, charsmax(szWeaponList));
	get_string(2, szWeaponSPR[0], charsmax(szWeaponSPR[]));
	get_string(3, szWeaponSPR[1], charsmax(szWeaponSPR[]));
	get_string(4, szWeaponModels[0], charsmax(szWeaponModels[]));
	get_string(5, szWeaponModels[1], charsmax(szWeaponModels[]));
	get_string(6, szWeaponModels[2], charsmax(szWeaponModels[]));
	get_string(7, szWeaponSound, charsmax(szWeaponSound));
	get_string(14, szWeaponBuyCommand, charsmax(szWeaponBuyCommand));
	if (szWeaponSPR[1][0]) iGrenadeSprId = engfunc(EngFunc_PrecacheModel, szWeaponSPR[1]);
	for (new i = 1; i < 33; i ++)
	{
		g_iWeaponId[i][g_iWeaponAmount] = CSW_HEGRENADE;
		g_fWeaponDrawTime[i][g_iWeaponAmount] = get_param_f(8);
		g_fGrenadeData[i][g_iWeaponAmount][1] = get_param_f(9);
		g_fGrenadeData[i][g_iWeaponAmount][2] = get_param_f(10);
		g_fWeaponMaxSpeed[i][g_iWeaponAmount] = get_param_f(11);
		g_fWeaponDamage[i][g_iWeaponAmount] = get_param_f(12);
		g_fWeaponFireSoundVolume[i][g_iWeaponAmount] = get_param_f(13);
		g_iWeaponCost[i][g_iWeaponAmount] = get_param(15);
		g_iWeaponTeam[i][g_iWeaponAmount] = get_param(16);
		g_iWeaponWModelBody[i][g_iWeaponAmount] = get_param(17);
		g_iGrenadeSprId[i][g_iWeaponAmount] = iGrenadeSprId;
		copy(g_szWeaponList[i][g_iWeaponAmount], charsmax(szWeaponList), szWeaponList);
		copy(g_szWeaponSPR[i][g_iWeaponAmount], charsmax(szWeaponSPR[]), szWeaponSPR[0]);
		copy(g_szWeaponPModel[i][g_iWeaponAmount], charsmax(szWeaponModels[]), szWeaponModels[0]);
		copy(g_szWeaponVModel[i][g_iWeaponAmount], charsmax(szWeaponModels[]), szWeaponModels[1]);
		copy(g_szWeaponWModel[i][g_iWeaponAmount], charsmax(szWeaponModels[]), szWeaponModels[2]);
		copy(g_szWeaponSound1[i][g_iWeaponAmount], charsmax(szWeaponSound), szWeaponSound);
		copy(g_szWeaponBuyCommand[i][g_iWeaponAmount], charsmax(szWeaponBuyCommand), szWeaponBuyCommand);
	}
	if (szWeaponModels[0][0]) engfunc(EngFunc_PrecacheModel, szWeaponModels[0]);
	if (szWeaponModels[1][0]) engfunc(EngFunc_PrecacheModel, szWeaponModels[1]);
	if (szWeaponModels[2][0]) engfunc(EngFunc_PrecacheModel, szWeaponModels[2]);
	if (szWeaponSound[0]) engfunc(EngFunc_PrecacheSound, szWeaponSound);
	return g_iWeaponAmount;
}

public Native_GiveWeapon(id, i)
{
	if (!is_user_alive(id))
	return 0;

	new iCurEntity = get_pdata_cbase(id, 373);
	new iEntity = GiveWeapon(id, g_szGameWeaponClassName[g_iWeaponId[id][i]], i);
	if (!pev_valid(iEntity))
	return 0;

	new iWeaponBitSum = (1<<CSW_KNIFE)|(1<<CSW_HEGRENADE)|(1<<CSW_SMOKEGRENADE)|(1<<CSW_FLASHBANG)|(1<<CSW_C4);
	new iSecWeaponBitSum = (1<<CSW_P228)|(1<<CSW_ELITE)|(1<<CSW_FIVESEVEN)|(1<<CSW_USP)|(1<<CSW_GLOCK18)|(1<<CSW_DEAGLE);

	// 是武器
	if (g_iWeaponId[id][i] != CSW_KNIFE && g_iWeaponId[id][i] != CSW_HEGRENADE)
	{
		// 两种设置clip，CurWeapon那里会发送消息隐藏弹夹
		if (g_iWeaponClip[id][i]) set_pdata_int(iEntity, 51, g_iWeaponClip[id][i], 4);
		else
		{
			set_pdata_int(iEntity, 51, g_iWeaponAmmo[id][i], 4);
			fm_cs_set_user_bpammo(id, g_iWeaponId[id][i], get_pdata_int(iEntity, 51, 4));
		}
	}
	ChangeWeaponList(id, iEntity);

	// 如果给的是刀子，且当前武器就是刀子
	if (get_pdata_int(iEntity, 43, 4) == CSW_KNIFE && pev_valid(iCurEntity) && get_pdata_int(iCurEntity, 43, 4) == CSW_KNIFE)
	{
		PlayAnim(id, g_iKnifeAnim[id][i][KNIFE_ANIM_DRAW]);
		engfunc(EngFunc_EmitSound, id, CHAN_WEAPON, g_szWeaponSound1[id][i], VOL_NORM, ATTN_NORM, 0, PITCH_NORM);
		set_pdata_float(id, 83, g_fWeaponDrawTime[id][i], 5);
		set_pev(id, pev_viewmodel2, g_szWeaponVModel[id][i]);
		set_pev(id, pev_weaponmodel2, g_szWeaponPModel[id][i]);
	}

	//给的是手雷，第二个判断没看懂
	if (get_pdata_int(iEntity, 43, 4) == CSW_HEGRENADE && iCurEntity != get_pdata_cbase(id, 373))
	{
		set_pev(id, pev_viewmodel2, g_szWeaponVModel[id][i]);
		set_pev(id, pev_weaponmodel2, g_szWeaponPModel[id][i]);
		set_pdata_float(iEntity, 48, g_fWeaponDrawTime[id][i], 4);
	}

	// 给的同种类型（CSW）的不同序号的武器的时候，debug处理
	else if (GetWeaponType(iEntity) != GetWeaponType(iCurEntity) && pev_valid(iCurEntity) && get_pdata_int(iCurEntity, 43, 4) == get_pdata_int(iEntity, 43, 4))
	{
		if ((1<<get_pdata_int(iEntity, 43, 4)) & iSecWeaponBitSum && !pev_valid(get_pdata_cbase(id, 368))) ExecuteHamB(Ham_Item_Deploy, iEntity);
		if (!((1<<get_pdata_int(iEntity, 43, 4)) & iSecWeaponBitSum) && !((1<<get_pdata_int(iCurEntity, 43, 4)) & iWeaponBitSum)) ExecuteHamB(Ham_Item_Deploy, iEntity);
	}
	return iEntity;
}

public Native_GetParamInt(i, id, value)
{
	switch (value)
	{
		case wpn_iWeaponId:return g_iWeaponId[id][i];
		case wpn_iExplodeSprId:return g_iGrenadeSprId[id][i];
		case wpn_iReloadMode:return g_iReloadMode[id][i];
		case wpn_iSightMode:return g_iWeaponSight[id][i];
		case wpn_iClip:return g_iWeaponClip[id][i];
		case wpn_iBPAmmo:return g_iWeaponAmmo[id][i];
		case wpn_iCost:return g_iWeaponCost[id][i];
		case wpn_iAmmoCost:return g_iWeaponAmmoCost[id][i];
		case wpn_iTeam:return g_iWeaponTeam[id][i];
		case wpn_iWModelBody:return g_iWeaponWModelBody[id][i];
		case wpn_iAnimIdle:return g_iWeaponAnim[id][i][ANIM_IDLE];
		case wpn_iAnimReload:return g_iWeaponAnim[id][i][ANIM_RELOAD];
		case wpn_iAnimDraw:return g_iWeaponAnim[id][i][ANIM_DRAW];
		case wpn_iAnimShoot1:return g_iWeaponAnim[id][i][ANIM_SHOOT1];
		case wpn_iAnimShoot2:return g_iWeaponAnim[id][i][ANIM_SHOOT2];
		case wpn_iAnimShoot3:return g_iWeaponAnim[id][i][ANIM_SHOOT3];
		case wpn_iAnimStartReload:return g_iWeaponAnim[id][i][ANIM_START_RELOAD];
		case wpn_iAnimInsert:return g_iWeaponAnim[id][i][ANIM_INSERT];
		case wpn_iAnimAfterReload:return g_iWeaponAnim[id][i][ANIM_AFTER_RELOAD];
		case wpn_iAnimSightOpen:return g_iWeaponAnim[id][i][ANIM_SIGHT_OPEN];
		case wpn_iAnimSightClose:return g_iWeaponAnim[id][i][ANIM_SIGHT_CLOSE];
		case wpn_iAnimSilencedIdle:return g_iWeaponAnim[id][i][ANIM_IDLE_SILENCED];
		case wpn_iAnimSilencedReload:return g_iWeaponAnim[id][i][ANIM_RELOAD_SILENCED];
		case wpn_iAnimSilencedDraw:return g_iWeaponAnim[id][i][ANIM_DRAW_SILENCED];
		case wpn_iAnimSilencedShoot1:return g_iWeaponAnim[id][i][ANIM_SHOOT1_SILENCED];
		case wpn_iAnimSilencedShoot2:return g_iWeaponAnim[id][i][ANIM_SHOOT2_SILENCED];
		case wpn_iAnimSilencedShoot3:return g_iWeaponAnim[id][i][ANIM_SHOOT3_SILENCED];
		case wpn_iAnimDetachSilencer:return g_iWeaponAnim[id][i][ANIM_DETACH_SILENCER];
		case wpn_iAnimAttachSilencer:return g_iWeaponAnim[id][i][ANIM_ATTACH_SILENCER];
		case wpn_iKnifeAnimIdle:return g_iKnifeAnim[id][i][KNIFE_ANIM_IDLE];
		case wpn_iKnifeAnimSlash1:return g_iKnifeAnim[id][i][KNIFE_ANIM_SLASH1];
		case wpn_iKnifeAnimSlash2:return g_iKnifeAnim[id][i][KNIFE_ANIM_SLASH2];
		case wpn_iKnifeAnimDraw:return g_iKnifeAnim[id][i][KNIFE_ANIM_DRAW];
		case wpn_iKnifeAnimStab:return g_iKnifeAnim[id][i][KNIFE_ANIM_STAB];
		case wpn_iKnifeAnimStabMiss:return g_iKnifeAnim[id][i][KNIFE_ANIM_STABMISS];
		case wpn_iKnifeAnimMidslash:return g_iKnifeAnim[id][i][KNIFE_ANIM_MIDSLASH];
		case wpn_iKnifeAnimMidslashMiss:return g_iKnifeAnim[id][i][KNIFE_ANIM_MIDSLASH_MISS];
		case wpn_iKnifeAnimSlashBegin:return g_iKnifeAnim[id][i][KNIFE_ANIM_SLASHBEGIN];
		case wpn_iKnifeAnimStabBegin:return g_iKnifeAnim[id][i][KNIFE_ANIM_STABBEGIN];
		case wpn_iUser1:return g_iUser1[id][i];
		case wpn_iUser2:return g_iUser2[id][i];
		case wpn_iUser3:return g_iUser3[id][i];
		case wpn_iUser4:return g_iUser4[id][i];
		case wpn_iAmount:return g_iWeaponAmount;
		case wpn_ID:
		{
			if (id < 3) return g_iWeaponTemplateSerialNumber[id][i];
			else return GetWeaponType(id);
		}
		case wpn_iBloodColor:return g_iBloodColor;
		case wpn_AllTeamBuy:return g_iAllTeamBuy;
		case wpn_SetBuy:return g_iBlockBuy[id];
		case wpn_iUserSight:return SightMode[id];
		case wpn_iBotMoney:return g_iBotMoney[id];
		case wpn_iGameWeaponBPAmmo:return g_szGameWeaponMaxBpammo[i];
		case wpn_iGameCurWeaponBPAmmo: return g_iGameCurWeaponBPAmmo[id][i];
		case wpn_iCurWeaponBPAmmo:return g_iCurWeaponBPAmmo[id][i];
		case wpn_iMaxMoney:return g_iMaxMoney;
		case wpn_iUserMoney:return get_pdata_int(id, 115, 5);
		case wpn_iAttackEntity:return g_iAttackerEntity[id];
	}
	return -1;
}

public Float:Native_GetParamFloat(i, id, value)
{
	if (!i)
	return -1.0;

	switch (value)
	{
		case wpn_fDamage:return g_fWeaponDamage[id][i];
		case wpn_fStabDamage:return g_fWeaponDamage2[id][i];
		case wpn_fFireSpeed:return g_fWeaponSpeed[id][i];
		case wpn_fAimFireSpeed:return g_fWeaponAimSpeed[id][i];
		case wpn_fSilencedFireSpeed:return g_fWeaponSilencedSpeed[id][i];
		case wpn_fRecoil:return g_fWeaponRecoil[id][i];
		case wpn_fAimRecoil:return g_fWeaponAimRecoil[id][i];
		case wpn_fSilencedRecoil:return g_fWeaponSilencedRecoil[id][i];
		case wpn_fAccuracy:return g_fWeaponAccuracy[id][i];
		case wpn_fAimAccuracy:return g_fWeaponAimAccuracy[id][i];
		case wpn_fSilencedAccuracy:return g_fWeaponSilencedAccuracy[id][i];
		case wpn_fSightDistance:return g_fSightDistance[id][i];
		case wpn_fSightFramerate:return g_fSightFrameRate[id][i];
		case wpn_fSightOpenTime:return g_fSightOpenTime[id][i];
		case wpn_fSightCloseTime:return g_fSightCloseTime[id][i];
		case wpn_fReloadTime:return g_fWeaponReloadTime[id][i][0];
		case wpn_fShotgunStartReloadTime:return g_fWeaponReloadTime[id][i][1];
		case wpn_fShotgunAfterReloadTime:return g_fWeaponReloadTime[id][i][2];
		case wpn_fDrawTime:return g_fWeaponDrawTime[id][i];
		case wpn_fDetachSilencerTime:return g_fWeaponSilencedTime[id][i][1];
		case wpn_fAttachSilencerTime:return g_fWeaponSilencedTime[id][i][0];
		case wpn_fSlashResetTime:return g_fKnifeSlashResetTime[id][i];
		case wpn_fSlashTime:return g_fKnifeSlashTime[id][i];
		case wpn_fSlashRange:return g_fKnifeSlashRange[id][i];
		case wpn_fSlashAngle:return g_fKnifeSlashAngle[id][i];
		case wpn_fStabResetTime:return g_fKnifeStabResetTime[id][i];
		case wpn_fStabTime:return g_fKnifeStabTime[id][i];
		case wpn_fStabRange:return g_fKnifeStabRange[id][i];
		case wpn_fStabAngle:return g_fKnifeStabAngle[id][i];
		case wpn_fExpTime:return g_fGrenadeData[id][i][1];
		case wpn_fExpRange:return g_fGrenadeData[id][i][2];
		case wpn_fMaxSpeed:return g_fWeaponMaxSpeed[id][i];
		case wpn_fAimMaxSpeed:return g_fWeaponAimMaxSpeed[id][i];
		case wpn_fKnockBack:return g_fWeaponKnockBack[id][i];
		case wpn_fUser1:return g_fUser1[id][i];
		case wpn_fUser2:return g_fUser2[id][i];
		case wpn_fUser3:return g_fUser3[id][i];
		case wpn_fUser4:return g_fUser4[id][i];
		case wpn_fDamagePoint:return g_fDamagePoint[id];
		case wpn_fKnockBackPoint:return g_fKnockBackPoint[id];
		case wpn_fDamageVictimPoint:return g_fDamageVictimPoint[id];
		case wpn_fFireSoundVolume:return g_fWeaponFireSoundVolume[id][i];
		case wpn_fSilenceFireSoundVolume:return g_fWeaponSilenceFireSoundVolume[id][i];
		case wpn_fKnifeSoundVolume1:return g_fKnifeSoundVolume[id][i][0];
		case wpn_fKnifeSoundVolume2:return g_fKnifeSoundVolume[id][i][1];
		case wpn_fKnifeSoundVolume3:return g_fKnifeSoundVolume[id][i][2];
		case wpn_fKnifeSoundVolume4:return g_fKnifeSoundVolume[id][i][3];
		case wpn_fKnifeSoundVolume5:return g_fKnifeSoundVolume[id][i][4];
		case wpn_fKnifeSlashAngleOffset:return g_fKnifeSlashAngleOffset[id][i];
		case wpn_fKnifeStabAngleOffset:return g_fKnifeStabAngleOffset[id][i];
		case wpn_fKnifeSlashHeight:return g_fKnifeSlashHeight[id][i];
		case wpn_fKnifeStabHeight:return g_fKnifeStabHeight[id][i];
		case wpn_fKnifeSlashHeightOffset:return g_fKnifeSlashHeightOffset[id][i];
		case wpn_fKnifeStabHeightOffset:return g_fKnifeStabHeightOffset[id][i];
	}
	return -1.0;
}

public Native_GetParamString(iPlugin, iParams)
{
	new i = get_param(1);
	new id = get_param(2);
	if (!i)
	return;

	switch (get_param(3))
	{
		case wpn_szWeaponList:set_string(4, g_szWeaponList[id][i], get_param(5));
		case wpn_szKillSpr:set_string(4, g_szWeaponSPR[id][i], get_param(5));
		case wpn_szPModel:set_string(4, g_szWeaponPModel[id][i], get_param(5));
		case wpn_szVModel:set_string(4, g_szWeaponVModel[id][i], get_param(5));
		case wpn_szWModel:set_string(4, g_szWeaponWModel[id][i], get_param(5));
		case wpn_szSightModel:set_string(4, g_szWeaponVModelS[id][i], get_param(5));
		case wpn_szSound1:set_string(4, g_szWeaponSound1[id][i], get_param(5));
		case wpn_szSound2:set_string(4, g_szWeaponSound2[id][i], get_param(5));
		case wpn_szSound3:set_string(4, g_szWeaponSound3[id][i], get_param(5));
		case wpn_szSound4:set_string(4, g_szWeaponSound4[id][i], get_param(5));
		case wpn_szSound5:set_string(4, g_szWeaponSound5[id][i], get_param(5));
		case wpn_szSound6:set_string(4, g_szWeaponSound6[id][i], get_param(5));
		case wpn_szCommand:set_string(4, g_szWeaponBuyCommand[id][i], get_param(5));
		case wpn_szUser1:set_string(4, g_szUser1[id][i], get_param(5));
		case wpn_szUser2:set_string(4, g_szUser2[id][i], get_param(5));
		case wpn_szUser3:set_string(4, g_szUser3[id][i], get_param(5));
		case wpn_szUser4:set_string(4, g_szUser4[id][i], get_param(5));
	}
}

public Native_SetParamInt(i, id, type, value)
{
	if (type == wpn_iBloodColor) g_iBloodColor = value;
	if (type == wpn_AllTeamBuy) g_iAllTeamBuy = value;
	if (type == wpn_SetBuy) g_iBlockBuy[id] = value;
	if (type == wpn_iBotMoney) g_iBotMoney[id] = value;
	if (type == wpn_iGameWeaponBPAmmo) g_szGameWeaponMaxBpammo[i] = value;
	if (type == wpn_iMaxMoney) g_iMaxMoney = value;
	if (type == wpn_iAttackEntity) g_iAttackerEntity[id] = value;
	if (type == wpn_iUserMoney) fm_set_user_money(id, value, i);
	if (type == wpn_iHitGroup) g_iAttackHitGroup[id] = value;
	if (!i)
	return;

	switch (type)
	{
		case wpn_iWeaponId:g_iWeaponId[id][i] = value;
		case wpn_iExplodeSprId:g_iGrenadeSprId[id][i] = value;
		case wpn_iReloadMode:g_iReloadMode[id][i] = value;
		case wpn_iSightMode:g_iWeaponSight[id][i] = value;
		case wpn_iClip:g_iWeaponClip[id][i] = value;
		case wpn_iBPAmmo:g_iWeaponAmmo[id][i] = value;
		case wpn_iCost:g_iWeaponCost[id][i] = value;
		case wpn_iAmmoCost:g_iWeaponAmmoCost[id][i] = value;
		case wpn_iTeam:g_iWeaponTeam[id][i] = value;
		case wpn_iWModelBody:g_iWeaponWModelBody[id][i] = value;
		case wpn_iAnimIdle:g_iWeaponAnim[id][i][ANIM_IDLE] = value;
		case wpn_iAnimReload:g_iWeaponAnim[id][i][ANIM_RELOAD] = value;
		case wpn_iAnimDraw:g_iWeaponAnim[id][i][ANIM_DRAW] = value;
		case wpn_iAnimShoot1:g_iWeaponAnim[id][i][ANIM_SHOOT1] = value;
		case wpn_iAnimShoot2:g_iWeaponAnim[id][i][ANIM_SHOOT2] = value;
		case wpn_iAnimShoot3:g_iWeaponAnim[id][i][ANIM_SHOOT3] = value;
		case wpn_iAnimStartReload:g_iWeaponAnim[id][i][ANIM_START_RELOAD] = value;
		case wpn_iAnimInsert:g_iWeaponAnim[id][i][ANIM_INSERT] = value;
		case wpn_iAnimAfterReload:g_iWeaponAnim[id][i][ANIM_AFTER_RELOAD] = value;
		case wpn_iAnimSightOpen:g_iWeaponAnim[id][i][ANIM_SIGHT_OPEN] = value;
		case wpn_iAnimSightClose:g_iWeaponAnim[id][i][ANIM_SIGHT_CLOSE] = value;
		case wpn_iAnimSilencedIdle:g_iWeaponAnim[id][i][ANIM_IDLE_SILENCED] = value;
		case wpn_iAnimSilencedReload:g_iWeaponAnim[id][i][ANIM_RELOAD_SILENCED] = value;
		case wpn_iAnimSilencedDraw:g_iWeaponAnim[id][i][ANIM_DRAW_SILENCED] = value;
		case wpn_iAnimSilencedShoot1:g_iWeaponAnim[id][i][ANIM_SHOOT1_SILENCED] = value;
		case wpn_iAnimSilencedShoot2:g_iWeaponAnim[id][i][ANIM_SHOOT2_SILENCED] = value;
		case wpn_iAnimSilencedShoot3:g_iWeaponAnim[id][i][ANIM_SHOOT3_SILENCED] = value;
		case wpn_iAnimDetachSilencer:g_iWeaponAnim[id][i][ANIM_DETACH_SILENCER] = value;
		case wpn_iAnimAttachSilencer:g_iWeaponAnim[id][i][ANIM_ATTACH_SILENCER] = value;
		case wpn_iKnifeAnimIdle:g_iKnifeAnim[id][i][KNIFE_ANIM_IDLE] = value;
		case wpn_iKnifeAnimSlash1:g_iKnifeAnim[id][i][KNIFE_ANIM_SLASH1] = value;
		case wpn_iKnifeAnimSlash2:g_iKnifeAnim[id][i][KNIFE_ANIM_SLASH2] = value;
		case wpn_iKnifeAnimDraw:g_iKnifeAnim[id][i][KNIFE_ANIM_DRAW] = value;
		case wpn_iKnifeAnimStab:g_iKnifeAnim[id][i][KNIFE_ANIM_STAB] = value;
		case wpn_iKnifeAnimStabMiss:g_iKnifeAnim[id][i][KNIFE_ANIM_STABMISS] = value;
		case wpn_iKnifeAnimMidslash:g_iKnifeAnim[id][i][KNIFE_ANIM_MIDSLASH] = value;
		case wpn_iKnifeAnimMidslashMiss:g_iKnifeAnim[id][i][KNIFE_ANIM_MIDSLASH_MISS] = value;
		case wpn_iKnifeAnimSlashBegin:g_iKnifeAnim[id][i][KNIFE_ANIM_SLASHBEGIN] = value;
		case wpn_iKnifeAnimStabBegin:g_iKnifeAnim[id][i][KNIFE_ANIM_STABBEGIN] = value;
		case wpn_iUser1:g_iUser1[id][i] = value;
		case wpn_iUser2:g_iUser2[id][i] = value;
		case wpn_iUser3:g_iUser3[id][i] = value;
		case wpn_iUser4:g_iUser4[id][i] = value;
		case wpn_iGameCurWeaponBPAmmo:g_iGameCurWeaponBPAmmo[id][i] = value;
		case wpn_iCurWeaponBPAmmo:g_iCurWeaponBPAmmo[id][i] = value;
	}
}

public Native_SetParamFloat(i, id, type, Float:value)
{
	if (type == wpn_fDamagePoint) g_fDamagePoint[id] = value;
	if (type == wpn_fKnockBackPoint) g_fKnockBackPoint[id] = value;
	if (type == wpn_fDamageVictimPoint) g_fDamageVictimPoint[id] = value;
	if (!i)
	return;

	switch (type)
	{
		case wpn_fDamage:g_fWeaponDamage[id][i] = value;
		case wpn_fStabDamage:g_fWeaponDamage2[id][i] = value;
		case wpn_fFireSpeed:g_fWeaponSpeed[id][i] = value;
		case wpn_fAimFireSpeed:g_fWeaponAimSpeed[id][i] = value;
		case wpn_fSilencedFireSpeed:g_fWeaponSilencedSpeed[id][i] = value;
		case wpn_fRecoil:g_fWeaponRecoil[id][i] = value;
		case wpn_fAimRecoil:g_fWeaponAimRecoil[id][i] = value;
		case wpn_fSilencedRecoil:g_fWeaponSilencedRecoil[id][i] = value;
		case wpn_fAccuracy:g_fWeaponAccuracy[id][i] = value;
		case wpn_fAimAccuracy:g_fWeaponAimAccuracy[id][i] = value;
		case wpn_fSilencedAccuracy:g_fWeaponSilencedAccuracy[id][i] = value;
		case wpn_fSightDistance:g_fSightDistance[id][i] = value;
		case wpn_fSightFramerate:g_fSightFrameRate[id][i] = value;
		case wpn_fSightOpenTime:g_fSightOpenTime[id][i] = value;
		case wpn_fSightCloseTime:g_fSightCloseTime[id][i] = value;
		case wpn_fReloadTime:g_fWeaponReloadTime[id][i][0] = value;
		case wpn_fShotgunStartReloadTime:g_fWeaponReloadTime[id][i][1] = value;
		case wpn_fShotgunAfterReloadTime:g_fWeaponReloadTime[id][i][2] = value;
		case wpn_fDrawTime:g_fWeaponDrawTime[id][i] = value;
		case wpn_fDetachSilencerTime:g_fWeaponSilencedTime[id][i][1] = value;
		case wpn_fAttachSilencerTime:g_fWeaponSilencedTime[id][i][0] = value;
		case wpn_fSlashResetTime:g_fKnifeSlashResetTime[id][i] = value;
		case wpn_fSlashTime:g_fKnifeSlashTime[id][i] = value;
		case wpn_fSlashRange:g_fKnifeSlashRange[id][i] = value;
		case wpn_fSlashAngle:g_fKnifeSlashAngle[id][i] = value;
		case wpn_fStabResetTime:g_fKnifeStabResetTime[id][i] = value;
		case wpn_fStabTime:g_fKnifeStabTime[id][i] = value;
		case wpn_fStabRange:g_fKnifeStabRange[id][i] = value;
		case wpn_fStabAngle:g_fKnifeStabAngle[id][i] = value;
		case wpn_fExpTime:g_fGrenadeData[id][i][1] = value;
		case wpn_fExpRange:g_fGrenadeData[id][i][2] = value;
		case wpn_fMaxSpeed:g_fWeaponMaxSpeed[id][i] = value;
		case wpn_fAimMaxSpeed:g_fWeaponAimMaxSpeed[id][i] = value;
		case wpn_fKnockBack:g_fWeaponKnockBack[id][i] = value;
		case wpn_fUser1:g_fUser1[id][i] = value;
		case wpn_fUser2:g_fUser2[id][i] = value;
		case wpn_fUser3:g_fUser3[id][i] = value;
		case wpn_fUser4:g_fUser4[id][i] = value;
		case wpn_fFireSoundVolume:g_fWeaponFireSoundVolume[id][i] = ((value > 0.0)? ((1.0 - value) > 0.0? (1.0 - value) : 0.0) : 0.35);
		case wpn_fSilenceFireSoundVolume:g_fWeaponSilenceFireSoundVolume[id][i] = ((value > 0.0)? ((1.0 - value) > 0.0? (1.0 - value) : 0.0) : ATTN_NORM);
		case wpn_fKnifeSoundVolume1:g_fKnifeSoundVolume[id][i][0] = ((value > 0.0)? ((1.0 - value) > 0.0? (1.0 - value) : 0.0) : ATTN_NORM);
		case wpn_fKnifeSoundVolume2:g_fKnifeSoundVolume[id][i][1] = ((value > 0.0)? ((1.0 - value) > 0.0? (1.0 - value) : 0.0) : ATTN_NORM);
		case wpn_fKnifeSoundVolume3:g_fKnifeSoundVolume[id][i][2] = ((value > 0.0)? ((1.0 - value) > 0.0? (1.0 - value) : 0.0) : ATTN_NORM);
		case wpn_fKnifeSoundVolume4:g_fKnifeSoundVolume[id][i][3] = ((value > 0.0)? ((1.0 - value) > 0.0? (1.0 - value) : 0.0) : ATTN_NORM);
		case wpn_fKnifeSoundVolume5:g_fKnifeSoundVolume[id][i][4] = ((value > 0.0)? ((1.0 - value) > 0.0? (1.0 - value) : 0.0) : ATTN_NORM);
		case wpn_fKnifeSlashAngleOffset:g_fKnifeSlashAngleOffset[id][i] = value;
		case wpn_fKnifeStabAngleOffset:g_fKnifeStabAngleOffset[id][i] = value;
		case wpn_fKnifeSlashHeight:g_fKnifeSlashHeight[id][i] = value;
		case wpn_fKnifeStabHeight:g_fKnifeStabHeight[id][i] = value;
		case wpn_fKnifeSlashHeightOffset:g_fKnifeSlashHeightOffset[id][i] = value;
		case wpn_fKnifeStabHeightOffset:g_fKnifeStabHeightOffset[id][i] = value;
	}
}

public Native_SetParamString(iPlugin, iParams)
{
	new szTempString[64];
	new i = get_param(1);
	new id = get_param(2);
	if (!i)
	return;

	switch (get_param(3))
	{
		case wpn_szWeaponList:
		{
			get_string(4, szTempString, charsmax(szTempString));
			copy(g_szWeaponList[id][i], charsmax(szTempString), szTempString);
		}
		case wpn_szKillSpr:
		{
			get_string(4, szTempString, charsmax(szTempString));
			copy(g_szWeaponSPR[id][i], charsmax(szTempString), szTempString);
		}
		case wpn_szPModel:
		{
			get_string(4, szTempString, charsmax(szTempString));
			copy(g_szWeaponPModel[id][i], charsmax(szTempString), szTempString);
		}
		case wpn_szVModel:
		{
			get_string(4, szTempString, charsmax(szTempString));
			copy(g_szWeaponVModel[id][i], charsmax(szTempString), szTempString);
		}
		case wpn_szWModel:
		{
			get_string(4, szTempString, charsmax(szTempString));
			copy(g_szWeaponWModel[id][i], charsmax(szTempString), szTempString);
		}
		case wpn_szSightModel:
		{
			get_string(4, szTempString, charsmax(szTempString));
			copy(g_szWeaponVModelS[id][i], charsmax(szTempString), szTempString);
		}
		case wpn_szSound1:
		{
			get_string(4, szTempString, charsmax(szTempString));
			copy(g_szWeaponSound1[id][i], charsmax(szTempString), szTempString);
		}
		case wpn_szSound2:
		{
			get_string(4, szTempString, charsmax(szTempString));
			copy(g_szWeaponSound2[id][i], charsmax(szTempString), szTempString);
		}
		case wpn_szSound3:
		{
			get_string(4, szTempString, charsmax(szTempString));
			copy(g_szWeaponSound3[id][i], charsmax(szTempString), szTempString);
		}
		case wpn_szSound4:
		{
			get_string(4, szTempString, charsmax(szTempString));
			copy(g_szWeaponSound4[id][i], charsmax(szTempString), szTempString);
		}
		case wpn_szSound5:
		{
			get_string(4, szTempString, charsmax(szTempString));
			copy(g_szWeaponSound5[id][i], charsmax(szTempString), szTempString);
		}
		case wpn_szSound6:
		{
			get_string(4, szTempString, charsmax(szTempString));
			copy(g_szWeaponSound6[id][i], charsmax(szTempString), szTempString);
		}
		case wpn_szCommand:
		{
			get_string(4, szTempString, charsmax(szTempString));
			copy(g_szWeaponBuyCommand[id][i], charsmax(szTempString), szTempString);
		}
		case wpn_szUser1:
		{
			get_string(4, szTempString, charsmax(szTempString));
			copy(g_szUser1[id][i], charsmax(szTempString), szTempString);
		}
		case wpn_szUser2:
		{
			get_string(4, szTempString, charsmax(szTempString));
			copy(g_szUser2[id][i], charsmax(szTempString), szTempString);
		}
		case wpn_szUser3:
		{
			get_string(4, szTempString, charsmax(szTempString));
			copy(g_szUser3[id][i], charsmax(szTempString), szTempString);
		}
		case wpn_szUser4:
		{
			get_string(4, szTempString, charsmax(szTempString));
			copy(g_szUser4[id][i], charsmax(szTempString), szTempString);
		}
	}
}

public Native_ExecuteAttack(iPlugin, iParams)
{
	new Float:fParam[6], Float:fOrigin[3];
	get_array_f(4, fParam, 6);
	get_array_f(5, fOrigin, 3);
	return CheckAttack(get_param(1), get_param(2), get_param(3), fParam, fOrigin, get_param(6), get_param(7));
}

public Native_SpawnBlood(iPlugin, iParams)
{
	new Float:vecOrigin[3];
	get_array_f(1, vecOrigin, 3);
	SpawnBlood(vecOrigin, get_param(2), get_param(3));
}

public Native_FakeSmoke(iPlugin, iParams)
{
	new Float:vecOrigin[3];
	get_array_f(1, vecOrigin, 3);
	FakeSmoke(vecOrigin);
}

public Native_GiveAmmo(id, iEntity, i, iFull)
{
	for (new iWpnID = 0; iWpnID < MAX_PRIM; iWpnID ++)
	{
		if (get_pdata_int(iEntity, 43, 4) == g_iPrimId[iWpnID])
		{
			if (!g_iWeaponClip[id][i])
			{
				if (i)
				{
					if (iFull) while (GivePriAmmo(id, iEntity, i, 1, 1, 0)) {}
					else GivePriAmmo(id, iEntity, i, 1, 1, 0);
				}
				else
				{
					if (iFull) while (GivePriAmmo(id, iEntity, i, 0, 1, 0)) {}
					else GivePriAmmo(id, iEntity, i, 0, 1, 0);
				}
			}
			else
			{
				if (iFull) while (GivePriAmmo(id, iEntity, i, 0, 1, 0)) {}
				else GivePriAmmo(id, iEntity, i, 0, 1, 0);
			}
		}
	}
	for (new iWpnID = 0; iWpnID < MAX_SEC; iWpnID ++)
	{
		if (get_pdata_int(iEntity, 43, 4) == g_iSecondId[iWpnID])
		{
			if (!g_iWeaponClip[id][i])
			{
				if (i)
				{
					if (iFull) while (GiveSecAmmo(id, iEntity, i, 1, 1, 0)) {}
					else GiveSecAmmo(id, iEntity, i, 1, 1, 0);
				}
				else
				{
					if (iFull) while (GiveSecAmmo(id, iEntity, i, 0, 1, 0)) {}
					else GiveSecAmmo(id, iEntity, i, 0, 1, 0);
				}
			}
			else
			{
				if (iFull) while (GiveSecAmmo(id, iEntity, i, 0, 1, 0)) {}
				else GiveSecAmmo(id, iEntity, i, 0, 1, 0);
			}
		}
	}
}

public Message_DeathMsg(msg_id, msg_dest, msg_entity)
{
	new szWeapon[32];
	new id = get_msg_arg_int(1);
	new victim = get_msg_arg_int(2);
	new headshot = get_msg_arg_int(3);
	get_msg_arg_string(4, szWeapon, charsmax(szWeapon));
	if (!id)
	{
		ExecuteForward(g_fwDeathMsg, g_fwDummyResult, id, victim, headshot, szWeapon);
		if (g_fwDummyResult == 1)
		return PLUGIN_HANDLED;

		return PLUGIN_CONTINUE;
	}

	// 手雷击杀图标
	if (!strcmp(szWeapon, "grenade"))
	{
		if (g_iUserGrenadeId[id])
		{
			set_msg_arg_string(4, g_szWeaponSPR[id][g_iUserGrenadeId[id]]);
			ExecuteForward(g_fwDeathMsg, g_fwDummyResult, id, victim, headshot, g_szWeaponSPR[id][g_iUserGrenadeId[id]]);
			if (g_fwDummyResult == 1)
			return PLUGIN_HANDLED;

			return PLUGIN_CONTINUE;
		}
		ExecuteForward(g_fwDeathMsg, g_fwDummyResult, id, victim, headshot, szWeapon);
		if (g_fwDummyResult == 1)
		return PLUGIN_HANDLED;

		return PLUGIN_CONTINUE;
	}

	// 取一下刀子攻击时的实体
	new iEntity, i;
	if (g_iAttackerEntity[id])
	{
		iEntity = g_iAttackerEntity[id];
		g_iAttackerEntity[id] = 0;
	}
	else
	{
		// debug处理，防止特殊击杀时出现武器击杀图标
		for (new j = 0; j < sizeof g_szGameWeaponKillSPR; j ++)
		{
			if (!g_szGameWeaponKillSPR[j][0])
			continue;

			if (strcmp(g_szGameWeaponKillSPR[j], szWeapon))
			continue;

			iEntity = get_pdata_cbase(id, 373);
		}
	}
	if (iEntity <= 0)
	{
		ExecuteForward(g_fwDeathMsg, g_fwDummyResult, id, victim, headshot, szWeapon);
		if (g_fwDummyResult == 1)
		return PLUGIN_HANDLED;

		return PLUGIN_CONTINUE;
	}
	i = GetWeaponType(iEntity);
	if (!i)
	{
		ExecuteForward(g_fwDeathMsg, g_fwDummyResult, id, victim, headshot, szWeapon);
		if (g_fwDummyResult == 1)
		return PLUGIN_HANDLED;

		return PLUGIN_CONTINUE;
	}
	set_msg_arg_string(4, g_szWeaponSPR[id][i]);
	ExecuteForward(g_fwDeathMsg, g_fwDummyResult, id, victim, headshot, g_szWeaponSPR[id][i]);
	if (g_fwDummyResult == 1)
	return PLUGIN_HANDLED;

	return PLUGIN_CONTINUE;
}

public Message_TextMsg(msg_id, msg_dest, msg_entity)
{
	new szTextMsg[32];
	get_msg_arg_string(2, szTextMsg, charsmax(szTextMsg));

	// 重置弹药
	if (!strcmp(szTextMsg, "#Game_will_restart_in") || !strcmp(szTextMsg, "#Game_Commencing")) g_iRoundRestart = true;
	return PLUGIN_CONTINUE;
}

public Message_TEMPENTITY(msg_id, msg_dest, msg_entity)
{
	if (!g_iBloodColor)
	return PLUGIN_CONTINUE;

	// 设置血液颜色
	if (get_msg_arg_int(1) == TE_BLOODSPRITE || get_msg_arg_int(1) == TE_BLOOD || get_msg_arg_int(1) == TE_BLOODSTREAM)
	{
		ExecuteForward(g_fwSpawnBlood, g_fwDummyResult, get_msg_arg_int(7));
		if (g_fwDummyResult == 1)
		return PLUGIN_HANDLED;

		set_msg_arg_int(7, ARG_BYTE, g_iBloodColor);
	}
	return PLUGIN_CONTINUE;
}

public Message_StatusIcon(msg_id, msg_dest, msg_entity)
{
	new szStatusName[33];
	get_msg_arg_string(2, szStatusName, charsmax(szStatusName));

	// 出现buyzone图标时说明BOT在购买区
	if (!strcmp(szStatusName, "buyzone"))
	{
		if (!is_user_connected(msg_entity))
		return PLUGIN_CONTINUE;

		if (!is_user_bot(msg_entity))
		return PLUGIN_CONTINUE;

		if (!g_iBotBuyWeapon[msg_entity])
		return PLUGIN_CONTINUE;

		g_fBotNextThink[msg_entity] = get_gametime() + 0.1;
	}
	return PLUGIN_CONTINUE;
}

public Event_CurWeapon(id)
{
	if (!is_user_alive(id))
	return;

	new iEntity = get_pdata_cbase(id, 373);
	new i = GetWeaponType(iEntity);
	if (i)
	{
		// 开镜时取消V模型
		if (fm_cs_get_user_zoom(id) == 2 || fm_cs_get_user_zoom(id) == 3) set_pev(id, pev_viewmodel2, "");

		// 设置模型
		else set_pev(id, pev_viewmodel2, g_szWeaponVModel[id][i]);
		set_pev(id, pev_weaponmodel2, g_szWeaponPModel[id][i]);

		// 无弹夹子弹的武器
		if (!g_iWeaponClip[id][i] && g_iWeaponId[id][i] != CSW_HEGRENADE && g_iWeaponId[id][i] != CSW_KNIFE)
		{
			fm_cs_set_user_bpammo(id, g_iWeaponId[id][i], get_pdata_int(iEntity, 51, 4));
			engfunc(EngFunc_MessageBegin, MSG_ONE, get_user_msgid("CurWeapon"), {0, 0, 0}, id);
			write_byte(1);
			write_byte(g_iWeaponId[id][i]);
			write_byte(-1);
			message_end();
			engfunc(EngFunc_MessageBegin, MSG_ONE, get_user_msgid("AmmoX"), {0, 0, 0}, id);
			write_byte(g_szGameWeaponAmmoId[g_iWeaponId[id][i]]);
			write_byte(get_pdata_int(iEntity, 51, 4));
			message_end();
		}

		// 机瞄V模型
		if (g_iWeaponSight[id][i] && SightMode[id] == OPEN) set_pev(id, pev_viewmodel2, g_szWeaponVModelS[id][i]);
	}
}

public Event_Round_Start()
{
	g_flDisableBuyTime = get_gametime() + (get_cvar_float("mp_buytime") * 60.0);
	g_iRoundStart = false;
	g_iRound ++;
	if (g_iRoundRestart)
	{
		g_iRoundRestart = false;
		for (new id = 1; id < 33; id ++)
		{
			for (new i = 1; i < MAXWEAPON; i ++) g_iCurWeaponBPAmmo[id][i] = 0;
			for (new i = 0; i < 32; i ++) g_iGameCurWeaponBPAmmo[id][i] = 0;
		}
	}
}

public Event_FreezeEnd()
{
	g_iRoundStart = true;
}

public fw_ClientCommand(id)
{
	new szCommand[64], szBuffer[64];
	read_argv(0, szCommand, charsmax(szCommand));
	if (!is_user_alive(id))
	return FMRES_IGNORED;

	if (!strcmp(szCommand, "buyammo1"))
	{
		ExecuteForward(g_fwBuyWeaponPre, g_fwDummyResult, id, szCommand);
		if (g_fwDummyResult == 1)
		return FMRES_SUPERCEDE;

		if (!CheckBuy(id))
		return FMRES_SUPERCEDE;

		new iEntity = get_pdata_cbase(id, 368);
		if (!pev_valid(iEntity))
		return FMRES_IGNORED;

		if (!g_iWeaponClip[id][GetWeaponType(iEntity)] && GetWeaponType(iEntity))
		{
			GivePriAmmo(id, iEntity, GetWeaponType(iEntity), 1, 0, 0);
			return FMRES_SUPERCEDE;
		}
		GivePriAmmo(id, iEntity, GetWeaponType(iEntity), 0, 0, 0);
		return FMRES_SUPERCEDE;
	}
	if (!strcmp(szCommand, "buyammo2"))
	{
		ExecuteForward(g_fwBuyWeaponPre, g_fwDummyResult, id, szCommand);
		if (g_fwDummyResult == 1)
		return FMRES_SUPERCEDE;

		if (!CheckBuy(id))
		return FMRES_SUPERCEDE;

		new iEntity = get_pdata_cbase(id, 369);
		if (!pev_valid(iEntity))
		return FMRES_IGNORED;

		if (!g_iWeaponClip[id][GetWeaponType(iEntity)] && GetWeaponType(iEntity))
		{
			GiveSecAmmo(id, iEntity, GetWeaponType(iEntity), 1, 0, 0);
			return FMRES_SUPERCEDE;
		}
		GiveSecAmmo(id, iEntity, GetWeaponType(iEntity), 0, 0, 0);
		return FMRES_SUPERCEDE;
	}
	if (!strcmp(szCommand, "primammo"))
	{
		ExecuteForward(g_fwBuyWeaponPre, g_fwDummyResult, id, szCommand);
		if (g_fwDummyResult == 1)
		return FMRES_SUPERCEDE;

		if (!CheckBuy(id))
		return FMRES_SUPERCEDE;

		new iEntity = get_pdata_cbase(id, 368);
		if (!pev_valid(iEntity))
		return FMRES_IGNORED;

		if (!g_iWeaponClip[id][GetWeaponType(iEntity)] && GetWeaponType(iEntity))
		{
			while (GivePriAmmo(id, iEntity, GetWeaponType(iEntity), 1, 0, 0)) {}
			return FMRES_SUPERCEDE;
		}
		while (GivePriAmmo(id, iEntity, GetWeaponType(iEntity), 0, 0, 0)) {}
		return FMRES_SUPERCEDE;
	}
	if (!strcmp(szCommand, "secammo"))
	{
		ExecuteForward(g_fwBuyWeaponPre, g_fwDummyResult, id, szCommand);
		if (g_fwDummyResult == 1)
		return FMRES_SUPERCEDE;

		if (!CheckBuy(id))
		return FMRES_SUPERCEDE;

		new iEntity = get_pdata_cbase(id, 369);
		if (!pev_valid(iEntity))
		return FMRES_IGNORED;

		if (!g_iWeaponClip[id][GetWeaponType(iEntity)] && GetWeaponType(iEntity))
		{
			while (GiveSecAmmo(id, iEntity, GetWeaponType(iEntity), 1, 0, 0)) {}
			return FMRES_SUPERCEDE;
		}
		while (GiveSecAmmo(id, iEntity, GetWeaponType(iEntity), 0, 0, 0)) {}
		return FMRES_SUPERCEDE;
	}
	if (!strcmp(szCommand, "shield"))
	return FMRES_SUPERCEDE;

	if (!strcmp(szCommand, KNIFE_COMMAND))
	{
		ExecuteForward(g_fwBuyWeaponPre, g_fwDummyResult, id, szCommand);
		if (g_fwDummyResult == 1)
		return FMRES_SUPERCEDE;

		if (!CheckBuy(id))
		return FMRES_SUPERCEDE;

		new iEntity = get_pdata_cbase(id, 373);
		new iEntity2 = GiveWeapon(id, "weapon_knife", 0);
		if (!pev_valid(iEntity)) iEntity = iEntity2;
		ChangeWeaponList(id, iEntity2);
		if (get_pdata_int(iEntity, 43, 4) == CSW_KNIFE)
		{
			ExecuteHamB(Ham_Item_Deploy, iEntity);
			PlayAnim(id, KNIFE_ANIM_DRAW);
			set_pdata_float(id, 83, 0.7, 5);
		}
		return FMRES_SUPERCEDE;
	}
	if (!strcmp(szCommand, VEST_COMMAND))
	{
		ExecuteForward(g_fwBuyWeaponPre, g_fwDummyResult, id, szCommand);
		if (g_fwDummyResult == 1)
		return FMRES_SUPERCEDE;

		if (!CheckBuy(id))
		return FMRES_SUPERCEDE;

		if (pev(id, pev_armorvalue) >= 100.0)
		return FMRES_SUPERCEDE;

		if (get_pdata_int(id, 115, 5) < 650)
		{
			client_print(id, print_center, "#Cstrike_TitlesTXT_Not_Enough_Money");
			return FMRES_SUPERCEDE;
		}
		set_pev(id, pev_armorvalue, 100.0);
		set_pdata_int(id, 112, 1);
		message_begin(MSG_ONE, get_user_msgid("ArmorType"), {0,0,0}, id);
		write_byte(0);
		message_end();
		fm_set_user_money(id, get_pdata_int(id, 115, 5) - 650);
		engfunc(EngFunc_EmitSound, id, CHAN_ITEM, "items/ammopickup2.wav", VOL_NORM, ATTN_NORM, (1<<0), PITCH_NORM);
		return FMRES_SUPERCEDE;
	}
	if (!strcmp(szCommand, VESTHELM_COMMAND))
	{
		ExecuteForward(g_fwBuyWeaponPre, g_fwDummyResult, id, szCommand);
		if (g_fwDummyResult == 1)
		return FMRES_SUPERCEDE;

		if (!CheckBuy(id))
		return FMRES_SUPERCEDE;

		if (pev(id, pev_armorvalue) >= 100.0 && get_pdata_int(id, 112) == 2)
		return FMRES_SUPERCEDE;

		if (get_pdata_int(id, 115, 5) < 1000 && pev(id, pev_armorvalue) < 100.0 || get_pdata_int(id, 115, 5) < 350 && pev(id, pev_armorvalue) >= 100.0)
		{
			client_print(id, print_center, "#Cstrike_TitlesTXT_Not_Enough_Money");
			return FMRES_SUPERCEDE;
		}
		if (get_pdata_int(id, 112) == 1) fm_set_user_money(id, get_pdata_int(id, 115, 5) - 350);
		else fm_set_user_money(id, get_pdata_int(id, 115, 5) - 1000);
		set_pev(id, pev_armorvalue, 100.0);
		set_pdata_int(id, 112, 2);
		message_begin(MSG_ONE, get_user_msgid("ArmorType"), {0,0,0}, id);
		write_byte(1);
		message_end();
		engfunc(EngFunc_EmitSound, id, CHAN_ITEM, "items/ammopickup2.wav", VOL_NORM, ATTN_NORM, (1<<0), PITCH_NORM);
		return FMRES_SUPERCEDE;
	}
	if (!strcmp(szCommand, DEFUSER_COMMAND))
	{
		ExecuteForward(g_fwBuyWeaponPre, g_fwDummyResult, id, szCommand);
		if (g_fwDummyResult == 1)
		return FMRES_SUPERCEDE;

		if (!CheckBuy(id))
		return FMRES_SUPERCEDE;

		new iEntity = -1, bool:iCanBuy;
		while ((iEntity = engfunc(EngFunc_FindEntityByString, iEntity, "classname", "func_bomb_target"))) iCanBuy = true;
		if (!iCanBuy)
		return FMRES_SUPERCEDE;

		if (get_pdata_int(id, 115, 5) < 200)
		{
			client_print(id, print_center, "#Cstrike_TitlesTXT_Not_Enough_Money");
			return FMRES_SUPERCEDE;
		}
		if (get_pdata_int(id, 114, 5) != 2)
		{
			client_print(id, print_center, "对于你的队伍来说还不能购买^"炸弹拆除装备^"。");
			return FMRES_SUPERCEDE;
		}
		set_pev(id, pev_body, 1);
		new iDefuseKitSkill = get_pdata_int(id, 193);
		if (iDefuseKitSkill & (1<<16))
		{
			client_print(id, print_center, "你已经有一个了。");
			return FMRES_SUPERCEDE;
		}
		else iDefuseKitSkill |= (1<<16);
		set_pdata_int(id, 193, iDefuseKitSkill);
		message_begin(MSG_ONE, get_user_msgid("StatusIcon"), {0,0,0}, id);
		write_byte(1);
		write_string("defuser");
		write_byte(0);
		write_byte(160);
		write_byte(0);
		message_end();
		fm_set_user_money(id, get_pdata_int(id, 115, 5) - 200);
		engfunc(EngFunc_EmitSound, id, CHAN_AUTO, "items/gunpickup2.wav", VOL_NORM, ATTN_NORM, 0, PITCH_NORM);
		return FMRES_SUPERCEDE;
	}
	if (!strcmp(szCommand, NVG_COMMAND))
	{
		ExecuteForward(g_fwBuyWeaponPre, g_fwDummyResult, id, szCommand);
		if (g_fwDummyResult == 1)
		return FMRES_SUPERCEDE;

		if (!CheckBuy(id))
		return FMRES_SUPERCEDE;

		if (get_pdata_int(id, 115, 5) < 1250)
		{
			client_print(id, print_center, "#Cstrike_TitlesTXT_Not_Enough_Money");
			return FMRES_SUPERCEDE;
		}
		new iNVGKit = get_pdata_int(id, 129);
		if (iNVGKit & (1<<0))
		{
			client_print(id, print_center, "你已经有一个了。");
			return FMRES_SUPERCEDE;
		}
		else iNVGKit |= (1<<0);
		set_pdata_int(id, 129, iNVGKit);
		fm_set_user_money(id, get_pdata_int(id, 115, 5) - 1250);
		return FMRES_SUPERCEDE;
	}
	for (new i = 0; i < sizeof g_szGameWeaponBuyCommand; i ++)
	{
		if (strcmp(szCommand, g_szGameWeaponBuyCommand[i]) || !g_szGameWeaponBuyCommand[i][0])
		continue;

		ExecuteForward(g_fwBuyWeaponPre, g_fwDummyResult, id, szCommand);
		if (g_fwDummyResult == 1)
		return FMRES_SUPERCEDE;

		if (!CheckBuy(id))
		return FMRES_SUPERCEDE;

		if (get_pdata_int(id, 114, 5) != g_iWeaponDefaultTeam[i] && g_iWeaponDefaultTeam[i] && !g_iAllTeamBuy)
		{
			client_print(id, print_center, "对于你的队伍来说还不能购买^"%s^"。", g_szGameWeaponBuyCommand[i]);
			return FMRES_SUPERCEDE;
		}
		if (get_pdata_int(id, 115, 5) < g_iWeaponDefaultCost[i])
		{
			client_print(id, print_center, "#Cstrike_TitlesTXT_Not_Enough_Money");
			return FMRES_SUPERCEDE;
		}
		if (!strcmp(szCommand, "hegren") || !strcmp(szCommand, "sgren"))
		{
			new iWeaponList = pev(id, pev_weapons);
			if (iWeaponList & (1<<i))
			{
				client_print(id, print_center, "#Cstrike_TitlesTXT_Cannot_Carry_Anymore");
				return FMRES_SUPERCEDE;
			}
		}
		else if (!strcmp(szCommand, "flash") && get_pdata_int(id, 387, 4) >= 2)
		{
			client_print(id, print_center, "#Cstrike_TitlesTXT_Cannot_Carry_Anymore");
			return FMRES_SUPERCEDE;
		}
		new iEntity = GiveWeapon(id, g_szGameWeaponClassName[i], 0);
		if (pev_valid(iEntity))
		{
			fm_set_user_money(id, get_pdata_int(id, 115, 5) - g_iWeaponDefaultCost[i]);
			if (fm_cs_get_user_bpammo(id, i) > g_szGameWeaponMaxBpammo[i]) fm_cs_set_user_bpammo(id, i, g_szGameWeaponMaxBpammo[i]);
			ExecuteForward(g_fwBuyWeaponPost, g_fwDummyResult, iEntity, id, 0);
		}
		return FMRES_SUPERCEDE;
	}
	for (new i = 1; i <= g_iWeaponAmount; i ++)
	{
		formatex(szBuffer, charsmax(szBuffer), "weapon_%s", g_szWeaponList[id][i]);
		if (!strcmp(szCommand, szBuffer)) engclient_cmd(id, g_szGameWeaponClassName[g_iWeaponId[id][i]]);
		if (strcmp(szCommand, g_szWeaponBuyCommand[id][i]) && g_szWeaponBuyCommand[id][i][0])
		continue;

		ExecuteForward(g_fwBuyWeaponPre, g_fwDummyResult, id, szCommand);
		if (g_fwDummyResult == 1)
		return FMRES_SUPERCEDE;

		if (!strcmp(szCommand, EMPTY_COMMAND))
		return FMRES_SUPERCEDE;

		if (!CheckBuy(id))
		return FMRES_SUPERCEDE;

		if (get_pdata_int(id, 114, 5) != g_iWeaponTeam[id][i] && g_iWeaponTeam[id][i])
		{
			client_print(id, print_center, "对于你的队伍来说还不能购买^"%s^"。", g_szWeaponList[id][i]);
			return FMRES_SUPERCEDE;
		}
		if (get_pdata_int(id, 115, 5) < g_iWeaponCost[id][i])
		{
			client_print(id, print_center, "#Cstrike_TitlesTXT_Not_Enough_Money");
			return FMRES_SUPERCEDE;
		}
		new iEntity = Native_GiveWeapon(id, i);
		if (pev_valid(iEntity))
		{
			fm_set_user_money(id, get_pdata_int(id, 115, 5) - g_iWeaponCost[id][i]);

			// 防止备弹超过上限
			if (fm_cs_get_user_bpammo(id, g_iWeaponId[id][i]) > g_iWeaponAmmo[id][i] && g_iWeaponId[id][i] != CSW_HEGRENADE && g_iWeaponId[id][i] != CSW_KNIFE) fm_cs_set_user_bpammo(id, g_iWeaponId[id][i], g_iWeaponAmmo[id][i]);
			ExecuteForward(g_fwBuyWeaponPost, g_fwDummyResult, iEntity, id, i);
		}
		return FMRES_SUPERCEDE;
	}
	return FMRES_IGNORED;
}

public fw_SetModel(iEntity, model[])
{
	if (!pev_valid(iEntity))
	return FMRES_IGNORED;

	new szClassName[33];
	pev(iEntity, pev_classname, szClassName, charsmax(szClassName));
	if (!strcmp(szClassName, "grenade"))
	{
		new id = pev(iEntity, pev_owner);
		if (!id)
		return FMRES_IGNORED;

		new iEntity2 = get_pdata_cbase(id, 373);
		if (iEntity2 < 0)
		return FMRES_IGNORED;

		new i = GetWeaponType(iEntity2);
		if (!i)
		return FMRES_IGNORED;

		set_pdata_int(iEntity, 11, i, 4);

		set_pev(iEntity, pev_dmgtime, get_gametime() + g_fGrenadeData[id][i][1]);
		engfunc(EngFunc_SetModel, iEntity, g_szWeaponWModel[id][i]);
		if (g_iWeaponWModelBody[id][i]) set_pev(iEntity, pev_body, g_iWeaponWModelBody[id][i]);
		return FMRES_SUPERCEDE;
	}
	if (strcmp(szClassName, "weaponbox"))
	return FMRES_IGNORED;

	// 通过weaponbox实体获取武器实体
	new iEntity2;
	for (new i = 0; i < 6; i ++) if ((iEntity2 = get_pdata_cbase(iEntity, 34 + i, 4)) > 0) break;
	if (iEntity2 <= 0)
	return FMRES_IGNORED;

	new i = GetWeaponType(iEntity2);
	if (!i)
	return FMRES_IGNORED;

	if (g_iWeaponId[pev(iEntity, pev_owner)][i] == CSW_HEGRENADE)
	{
		set_pev(iEntity, pev_nextthink, get_gametime() + 0.1);
		return FMRES_SUPERCEDE;
	}
	engfunc(EngFunc_SetModel, iEntity, g_szWeaponWModel[pev(iEntity, pev_owner)][i]);
	if (g_iWeaponWModelBody[pev(iEntity, pev_owner)][i]) set_pev(iEntity, pev_body, g_iWeaponWModelBody[pev(iEntity, pev_owner)][i]);
	return FMRES_SUPERCEDE;
}

public fw_UpdateClientData_Post(id, SendWeapons, CD_Handle)
{
	if (!is_user_alive(id))
	return;

	new iEntity = get_pdata_cbase(id, 373);
	if (!pev_valid(iEntity))
	return;

	new i = GetWeaponType(iEntity);
	if (!i)
	return;

	if (g_iWeaponId[id][i] == CSW_KNIFE)
	return;

	// 用于阻止客户端的开枪
	set_cd(CD_Handle, CD_flNextAttack, get_gametime() + 0.001);
}

public fw_PlaybackEvent(iFlags, id, iEvent, iDelay, Float:vecOrigin[3], Float:vecAngle[3], Float:flParam1, Float:flParam2, iParam1, iParam2, bParam1, bParam2)
{
	if (!is_user_connected(id))
	return FMRES_IGNORED;

	if (!g_IsInPrimaryAttack)
	return FMRES_IGNORED;

	new iEntity = get_pdata_cbase(id, 373);
	new i = GetWeaponType(iEntity);
	if (!i)
	return FMRES_IGNORED;

	if (g_iWeaponId[id][i] == CSW_KNIFE)
	return FMRES_IGNORED;

	new Float:flRecoil;
	if (fm_cs_get_user_zoom(id) != 1 || SightMode[id] == OPEN) flRecoil = g_fWeaponAimAccuracy[id][i];
	else if (fm_cs_get_user_zoom(id) == 1 && SightMode[id] != OPEN) flRecoil = g_fWeaponAccuracy[id][i];
	engfunc(EngFunc_PlaybackEvent, iFlags | FEV_HOSTONLY, id, iEvent, iDelay, vecOrigin, vecAngle, flParam1 * flRecoil, flParam2 * flRecoil, iParam1, iParam2, bParam1, bParam2);
	return FMRES_SUPERCEDE;
}

public fw_TraceLine(Float:vector_start[3], Float:vector_end[3], ignored_monster, id, handle)
{
	if (!is_user_connected(id))
	return FMRES_IGNORED;

	new iEntity = get_pdata_cbase(id, 373);
	if (!pev_valid(iEntity))
	return FMRES_IGNORED;

	new i = GetWeaponType(iEntity);
	if (g_IsInPrimaryAttack)
	{
		new Float:vecTemp[3], Float:vecDir[3];
		xs_vec_sub(vector_end, vector_start, vecDir);
		vecDir[0] /= 8192.0;
		vecDir[1] /= 8192.0;
		vecDir[2] /= 8192.0;
		global_get(glb_v_forward, vecTemp);
		xs_vec_sub(vecDir, vecTemp, vecDir);
		if (fm_cs_get_user_zoom(id) != 1 || SightMode[id] == OPEN) xs_vec_mul_scalar(vecDir, g_fWeaponAimAccuracy[id][i], vecDir);
		else if (fm_cs_get_user_zoom(id) == 1 && SightMode[id] != OPEN) xs_vec_mul_scalar(vecDir, g_fWeaponAccuracy[id][i], vecDir);
		else if ((get_pdata_int(iEntity, 74, 4) & (1<<2)) || (get_pdata_int(iEntity, 74, 4) & (1<<0))) xs_vec_mul_scalar(vecDir, g_fWeaponSilencedAccuracy[id][i], vecDir);
		else xs_vec_mul_scalar(vecDir, g_fWeaponAccuracy[id][i], vecDir);
		xs_vec_add(vecDir, vecTemp, vecDir);
		xs_vec_mul_scalar(vecDir, 8192.0, vecDir);
		xs_vec_add(vecDir, vector_start, vector_end);
		engfunc(EngFunc_TraceLine, vector_start, vector_end, ignored_monster, id, handle);
		return FMRES_SUPERCEDE;
	}
	if (get_pdata_int(iEntity, 43, 4) != CSW_KNIFE || !i)
	return FMRES_IGNORED;

	if ((g_fKnifeSlashTime[id][i] && g_fKnifeSlashAngle[id][i]) || (g_fKnifeStabTime[id][i] && g_fKnifeSlashAngle[id][i]))
	return FMRES_IGNORED;

	if (pev(id, pev_button) & IN_ATTACK)
	{
		pev(id, pev_v_angle, vector_end);
		angle_vector(vector_end, ANGLEVECTOR_FORWARD, vector_end);
		xs_vec_mul_scalar(vector_end, g_fKnifeSlashRange[id][i], vector_end);
		xs_vec_add(vector_start, vector_end, vector_end);
		engfunc(EngFunc_TraceLine, vector_start, vector_end, ignored_monster, id, handle);
	}
	else if (pev(id, pev_button) & IN_ATTACK2)
	{
		pev(id, pev_v_angle, vector_end);
		angle_vector(vector_end, ANGLEVECTOR_FORWARD, vector_end);
		xs_vec_mul_scalar(vector_end, g_fKnifeStabRange[id][i], vector_end);
		xs_vec_add(vector_start, vector_end, vector_end);
		engfunc(EngFunc_TraceLine, vector_start, vector_end, ignored_monster, id, handle);
	}
	return FMRES_SUPERCEDE;
}

public fw_TraceHull(Float:vector_start[3], Float:vector_end[3], ignored_monster, hull, id, handle)
{
	if (!is_user_connected(id))
	return FMRES_IGNORED;

	new iEntity = get_pdata_cbase(id, 373);
	if (!pev_valid(iEntity))
	return FMRES_IGNORED;

	new i = GetWeaponType(iEntity);
	if (get_pdata_int(iEntity, 43, 4) != CSW_KNIFE || !i)
	return FMRES_IGNORED;

	if ((g_fKnifeSlashTime[id][i] && g_fKnifeSlashAngle[id][i]) || (g_fKnifeStabTime[id][i] && g_fKnifeSlashAngle[id][i]))
	return FMRES_IGNORED;

	if (pev(id, pev_button) & IN_ATTACK)
	{
		pev(id, pev_v_angle, vector_end);
		angle_vector(vector_end, ANGLEVECTOR_FORWARD, vector_end);
		xs_vec_mul_scalar(vector_end, g_fKnifeSlashRange[id][i], vector_end);
		xs_vec_add(vector_start, vector_end, vector_end);
		engfunc(EngFunc_TraceHull, vector_start, vector_end, ignored_monster, hull, id, handle);
	}
	else if (pev(id, pev_button) & IN_ATTACK2)
	{
		pev(id, pev_v_angle, vector_end);
		angle_vector(vector_end, ANGLEVECTOR_FORWARD, vector_end);
		xs_vec_mul_scalar(vector_end, g_fKnifeStabRange[id][i], vector_end);
		xs_vec_add(vector_start, vector_end, vector_end);
		engfunc(EngFunc_TraceHull, vector_start, vector_end, ignored_monster, hull, id, handle);
	}
	return FMRES_SUPERCEDE;
}

public fw_EmitSound(id, channel, sample[], Float:volume, Float:attn, flags, pitch)
{
	if (!is_user_connected(id))
	return FMRES_IGNORED;

	new iEntity = get_pdata_cbase(id, 373);
	new i = GetWeaponType(iEntity);
	if (!equal(sample, "weapons/knife_", 14) || !i || get_pdata_int(iEntity, 43, 4) != CSW_KNIFE)
	return FMRES_IGNORED;

	new iAttack = g_iUserKnifeAttack[id];
	g_iUserKnifeAttack[id] = 0;
	if (sample[14] == 's' && sample[15] == 'l' && sample[16] == 'a')
	{
		engfunc(EngFunc_EmitSound, id, CHAN_WEAPON, g_szWeaponSound3[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][1], 0, PITCH_NORM);
		if (iAttack == 1) PlayAnim(id, g_iKnifeAnim[id][i][g_iKnifeSlashMode[id] + 1]);
		else PlayAnim(id, g_iKnifeAnim[id][i][KNIFE_ANIM_STABMISS]);
	}
	if (sample[14] == 'h' && sample[15] == 'i' && sample[16] == 't')
	{
		if (sample[17] == 'w')
		{
			engfunc(EngFunc_EmitSound, id, CHAN_WEAPON, g_szWeaponSound2[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][0], 0, PITCH_NORM);
			if (iAttack == 1) PlayAnim(id, g_iKnifeAnim[id][i][g_iKnifeSlashMode[id] + 1]);
			else PlayAnim(id, g_iKnifeAnim[id][i][KNIFE_ANIM_STAB]);
		}
		else
		{
			if (random_num(0, 1)) engfunc(EngFunc_EmitSound, id, CHAN_WEAPON, g_szWeaponSound5[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][3], 0, PITCH_NORM);
			else engfunc(EngFunc_EmitSound, id, CHAN_WEAPON, g_szWeaponSound6[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][4], 0, PITCH_NORM);
			PlayAnim(id, g_iKnifeAnim[id][i][g_iKnifeSlashMode[id] + 1]);
		}
	}
	if (sample[14] == 's' && sample[15] == 't' && sample[16] == 'a')
	{
		engfunc(EngFunc_EmitSound, id, CHAN_WEAPON, g_szWeaponSound4[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][2], 0, PITCH_NORM);
		PlayAnim(id, g_iKnifeAnim[id][i][KNIFE_ANIM_STAB]);
	}
	if (sample[14] == 'd' && sample[15] == 'e' && sample[16] == 'p') engfunc(EngFunc_EmitSound, id, CHAN_WEAPON, g_szWeaponSound1[id][i], VOL_NORM, ATTN_NORM, 0, PITCH_NORM);
	return FMRES_SUPERCEDE;
}

public fw_PlayerPostThink_Post(id)
{
	if (is_user_bot(id) && g_fwBotForwardRegister)
	{
		g_fwBotForwardRegister = false;
		RegisterHamFromEntity(Ham_TakeDamage, id, "HAM_TakeDamage");
		RegisterHamFromEntity(Ham_TakeDamage, id, "HAM_TakeDamage_Post", 1);
		RegisterHamFromEntity(Ham_Killed, id, "HAM_Killed_Post", 1);
		RegisterHamFromEntity(Ham_Spawn, id, "HAM_PlayerSpawn_Post", 1);
	}
	if (!is_user_alive(id))
	return;

	if (get_gametime() >= g_fBotNextThink[id] && g_fBotNextThink[id])
	{
		g_fBotNextThink[id] = 0.0;
		BotBuyWeaponEvent(id);
	}
	new iEntity;
	if (g_fPlayerThink[id] && get_gametime() - g_fPlayerThink[id] >= 0.0)
	{
		iEntity = get_pdata_cbase(id, 370);
		g_fPlayerThink[id] = 0.0;
		if (!pev_valid(iEntity))
		return;

		new i = GetWeaponType(iEntity);
		if (g_iKnifeAttack[id] == 1)
		{
			if (g_iKnifeAnim[id][i][KNIFE_ANIM_SLASHBEGIN])
			{
				g_iKnifeAttack[id] = 2;
				KnifeAttack(id, i, g_iKnifeAttack[id], iEntity);
				return;
			}
			else
			{
				ExecuteForward(g_fwPrimaryAttackEndPre, g_fwDummyResult, iEntity, id, i);
				if (g_fwDummyResult == 1)
				return;

				g_iKnifeAttack[id] = 2;
				g_fPlayerThink[id] = get_gametime() + g_fKnifeSlashResetTime[id][i];
				new Float:fRange = g_fKnifeSlashRange[id][i];
				new Float:fDamage = 15.0 * g_fWeaponDamage[id][i];
				new Float:fAngle = g_fKnifeSlashAngle[id][i];
				new Float:fOrigin[3];
				pev(id, pev_origin, fOrigin);
				new Float:fParam[6];
				fParam[0] = fRange;
				fParam[1] = fAngle;
				fParam[2] = g_fKnifeSlashAngleOffset[id][i];
				fParam[3] = g_fKnifeSlashHeight[id][i];
				fParam[4] = g_fKnifeSlashHeightOffset[id][i];
				fParam[5] = fDamage;
				new hit = CheckAttack(id, 0, iEntity, fParam, fOrigin, fAngle? DMGTYPE_SECTOR : DMGTYPE_LINE, SPDMG_NORMAL);
				if (hit == HIT_EMPTY) engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound3[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][1], 0, PITCH_NORM);
				if (hit == HIT_PLAYER)
				{
					if (g_iKnifeSlashMode[id]) engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound5[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][3], 0, PITCH_NORM);
					else engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound6[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][4], 0, PITCH_NORM);
				}
				if (hit == HIT_ENTITY || hit == HIT_WALL) engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound2[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][0], 0, PITCH_NORM);
				ExecuteForward(g_fwPrimaryAttackEndPost, g_fwDummyResult, iEntity, id, i);
				return;
			}
		}
		else if (g_iKnifeAttack[id] == 2)
		{
			g_iKnifeAttack[id] = 0;
			return;
		}
		else if (g_iKnifeAttack[id] == 3)
		{
			if (g_iKnifeAnim[id][i][KNIFE_ANIM_STABBEGIN])
			{
				g_iKnifeAttack[id] = 4;
				KnifeAttack(id, i, g_iKnifeAttack[id], iEntity);
				return;
			}
			else
			{
				ExecuteForward(g_fwSecondaryAttackEndPre, g_fwDummyResult, iEntity, id, i);
				if (g_fwDummyResult == 1)
				return;

				g_iKnifeAttack[id] = 4;
				g_fPlayerThink[id] = get_gametime() + g_fKnifeStabResetTime[id][i];
				new Float:fRange = g_fKnifeStabRange[id][i];
				new Float:fDamage = 65.0 * g_fWeaponDamage2[id][i];
				new Float:fAngle = g_fKnifeStabAngle[id][i];
				new Float:fOrigin[3];
				pev(id, pev_origin, fOrigin);
				new Float:fParam[6];
				fParam[0] = fRange;
				fParam[1] = fAngle;
				fParam[2] = g_fKnifeStabAngleOffset[id][i];
				fParam[3] = g_fKnifeStabHeight[id][i];
				fParam[4] = g_fKnifeStabHeightOffset[id][i];
				fParam[5] = fDamage;
				new hit = CheckAttack(id, 0, iEntity, fParam, fOrigin, fAngle? DMGTYPE_SECTOR : DMGTYPE_LINE, SPDMG_NORMAL);
				if (hit == HIT_EMPTY) engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound3[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][1], 0, PITCH_NORM);
				if (hit == HIT_PLAYER) engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound4[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][2], 0, PITCH_NORM);
				if (hit == HIT_ENTITY || hit == HIT_WALL) engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound2[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][0], 0, PITCH_NORM);
				ExecuteForward(g_fwSecondaryAttackEndPost, g_fwDummyResult, iEntity, id, i);
				return;
			}
		}
		else if (g_iKnifeAttack[id] == 4)
		{
			g_iKnifeAttack[id] = 0;
			return;
		}
	}
}

public fw_PlayerPreThink(id)
{
	if (!is_user_alive(id))
	return FMRES_IGNORED;

	if (!g_iRoundStart)
	return FMRES_IGNORED;

	new iEntity = get_pdata_cbase(id, 373);
	if (!pev_valid(iEntity))
	return FMRES_IGNORED;

	new i = GetWeaponType(iEntity);
	ExecuteForward(g_fwSetMaxSpeedPre, g_fwDummyResult, iEntity, id, i);
	if (g_fwDummyResult == 1)
	return FMRES_IGNORED;

	if (!i)
	return FMRES_IGNORED;

	if (fm_cs_get_user_zoom(id) == 1 && SightMode[id] != OPEN)
	{
		if (g_fWeaponMaxSpeed[id][i])
		{
			set_pev(id, pev_maxspeed, g_fWeaponMaxSpeed[id][i]);
			return FMRES_IGNORED;
		}
	}
	else if (fm_cs_get_user_zoom(id) != 1 || SightMode[id] == OPEN)
	{
		if (g_fWeaponAimMaxSpeed[id][i])
		{
			set_pev(id, pev_maxspeed, g_fWeaponAimMaxSpeed[id][i]);
			return FMRES_IGNORED;
		}
	}
	new Float:fMaxSpeed;
	ExecuteHam(Ham_CS_Item_GetMaxSpeed, iEntity, fMaxSpeed);
	set_pev(id, pev_maxspeed, fMaxSpeed);
	return FMRES_IGNORED;
}

public fw_Think_Post(iEntity)
{
	if (!pev_valid(iEntity))
	return;

	new szClassName[64];
	pev(iEntity, pev_classname, szClassName, charsmax(szClassName));
	if (strcmp(szClassName, "gunsmoke1"))
	return;

	new Float:fFrame, Float:fScale, Float:fNextThink, iNum, Float:fVelocity[3];
	pev(iEntity, pev_frame, fFrame);
	pev(iEntity, pev_scale, fScale);
	pev(iEntity, pev_iuser1, iNum);
	pev(iEntity, pev_velocity, fVelocity);
	fNextThink = 0.005;
	fFrame += 0.2;
	fScale += 0.01;
	if (iNum)
	{
		fVelocity[0] -= random_float(1.0, 5.0);
		fVelocity[1] -= random_float(1.0, 5.0);
	}
	else
	{
		fVelocity[0] += random_float(1.0, 5.0);
		fVelocity[1] += random_float(1.0, 5.0);
	}
	fFrame = floatmin(10.0, fFrame);
	fScale = floatmin(1.0, fScale);
	set_pev(iEntity, pev_frame, fFrame);
	set_pev(iEntity, pev_scale, fScale);
	set_pev(iEntity, pev_velocity, fVelocity);
	set_pev(iEntity, pev_nextthink, get_gametime() + fNextThink);
	if (fFrame == 10.0) engfunc(EngFunc_RemoveEntity, iEntity);
}

public HAM_Item_AddToPlayer_Post(iEntity, id)
{
	if (get_pdata_int(iEntity, 43, 4) == CSW_C4)
	return;

	ChangeWeaponList(id, iEntity);
}

public HAM_Item_Deploy(iEntity)
{
	new id = get_pdata_cbase(iEntity, 41, 4);
	new i = GetWeaponType(iEntity);
	if (!i)
	return HAM_IGNORED;

	// AWP无法设置切枪时间的bug
	g_fUserDeploy[id][0] = get_pdata_float(iEntity, 46);
	g_fUserDeploy[id][1] = get_pdata_float(iEntity, 47);
	return HAM_IGNORED;
}

public HAM_Item_Deploy_Post(iEntity)
{
	new id = get_pdata_cbase(iEntity, 41, 4);
	new i = GetWeaponType(iEntity);

	// 记录原版武器备弹
	if (!i)
	{
		new iWeapon = get_pdata_int(iEntity, 43, 4);
		new iWeaponBitSum = (1<<CSW_KNIFE)|(1<<CSW_HEGRENADE)|(1<<CSW_SMOKEGRENADE)|(1<<CSW_FLASHBANG)|(1<<CSW_C4);
		if (!((1<<iWeapon) & iWeaponBitSum)) fm_cs_set_user_bpammo(id, iWeapon, g_iGameCurWeaponBPAmmo[id][iWeapon]);
		return;
	}

	// 记录新武器备弹
	if (g_iWeaponId[id][i] != CSW_HEGRENADE && g_iWeaponId[id][i] != CSW_KNIFE) fm_cs_set_user_bpammo(id, g_iWeaponId[id][i], g_iCurWeaponBPAmmo[id][i]);
	ChangeWeaponList(id, iEntity);
	set_pev(id, pev_viewmodel2, g_szWeaponVModel[id][i]);
	set_pev(id, pev_weaponmodel2, g_szWeaponPModel[id][i]);
	if (g_iWeaponId[id][i] == CSW_KNIFE)
	{
		PlayAnim(id, g_iKnifeAnim[id][i][KNIFE_ANIM_DRAW]);
		engfunc(EngFunc_EmitSound, id, CHAN_WEAPON, g_szWeaponSound1[id][i], VOL_NORM, ATTN_NORM, 0, PITCH_NORM);
	}
	else if (g_iWeaponId[id][i] != CSW_HEGRENADE)
	{
		if ((get_pdata_int(iEntity, 74, 4) & (1<<2)) || (get_pdata_int(iEntity, 74, 4) & (1<<0))) PlayAnim(id, g_iWeaponAnim[id][i][ANIM_DRAW_SILENCED]);
		else PlayAnim(id, g_iWeaponAnim[id][i][ANIM_DRAW]);
	}
	set_pdata_float(id, 83, g_fWeaponDrawTime[id][i], 5);
	set_pdata_float(iEntity, 46, g_fUserDeploy[id][0]);
	set_pdata_float(iEntity, 47, g_fUserDeploy[id][1]);
	if (!g_iWeaponClip[id][i] && g_iWeaponId[id][i] != CSW_HEGRENADE && g_iWeaponId[id][i] != CSW_KNIFE)
	{
		fm_cs_set_user_bpammo(id, g_iWeaponId[id][i], get_pdata_int(iEntity, 51, 4));
		engfunc(EngFunc_MessageBegin, MSG_ONE, get_user_msgid("CurWeapon"), {0, 0, 0}, id);
		write_byte(1);
		write_byte(g_iWeaponId[id][i]);
		write_byte(-1);
		message_end();
		engfunc(EngFunc_MessageBegin, MSG_ONE, get_user_msgid("AmmoX"), {0, 0, 0}, id);
		write_byte(g_szGameWeaponAmmoId[g_iWeaponId[id][i]]);
		write_byte(get_pdata_int(iEntity, 51, 4));
		message_end();
	}
	else
	{
		engfunc(EngFunc_MessageBegin, MSG_ONE, get_user_msgid("CurWeapon"), {0, 0, 0}, id);
		write_byte(1);
		write_byte(g_iWeaponId[id][i]);
		write_byte(get_pdata_int(iEntity, 51, 4));
		message_end();
	}
	if (g_iWeaponSight[id][i])
	{
		set_pdata_int(id, 363, 90, 5);
		SightMode[id] = CLOSED;
		set_pdata_int(id, 361, get_pdata_int(id, 361) &~ (1<<6), 5);
		Reload[id] = false;
	}
	ExecuteForward(g_fwWeaponDraw, g_fwDummyResult, iEntity, id, i);
}

public HAM_Item_Holster_Post(iEntity)
{
	new id = get_pdata_cbase(iEntity, 41, 4);
	new i = GetWeaponType(iEntity);
	if (i && g_iWeaponSight[id][i])
	{
		set_pdata_int(id, 363, 90, 5);
		SightMode[id] = CLOSED;
		set_pdata_int(id, 361, get_pdata_int(id, 361) &~ (1<<6), 5);
		Reload[id] = false;
	}

	// 收起武器时记录备用子弹
	new iWeapon = get_pdata_int(iEntity, 43, 4);
	new iWeaponBitSum = (1<<CSW_KNIFE)|(1<<CSW_HEGRENADE)|(1<<CSW_SMOKEGRENADE)|(1<<CSW_FLASHBANG)|(1<<CSW_C4);
	if (!((1<<iWeapon) & iWeaponBitSum))
	{
		if (!i) g_iGameCurWeaponBPAmmo[id][iWeapon] = fm_cs_get_user_bpammo(id, iWeapon);
		else g_iCurWeaponBPAmmo[id][i] = fm_cs_get_user_bpammo(id, g_iWeaponId[id][i]);
	}
}

public HAM_Weapon_PrimaryAttack(iEntity)
{
	new id = get_pdata_cbase(iEntity, 41, 4);
	new i = GetWeaponType(iEntity);
	if (!i)
	return HAM_IGNORED;

	if (g_iWeaponId[id][i] == CSW_HEGRENADE)
	return HAM_IGNORED;

	if (g_iWeaponId[id][i] == CSW_KNIFE)
	{
		ExecuteForward(g_fwPrimaryPreAttackPre, g_fwDummyResult, iEntity, id, i);
		if (g_fwDummyResult == 1)
		return HAM_SUPERCEDE;

		if (!g_fKnifeSlashTime[id][i])
		{
			g_iKnifeSlashMode[id] = g_iKnifeSlashMode[id]? 0 : 1;
			g_fKnifeTempDamage[id] = g_fWeaponDamage[id][i];
			if (!g_iUserKnifeAttack[id]) g_iUserKnifeAttack[id] = 1;
			ExecuteForward(g_fwPrimaryPreAttackPost, g_fwDummyResult, iEntity, id, i);
			return HAM_IGNORED;
		}
		else
		{
			if (g_iKnifeAttack[id])
			return HAM_SUPERCEDE;

			g_iKnifeSlashMode[id] = g_iKnifeSlashMode[id]? 0 : 1;
			g_iKnifeAttack[id] = 1;
			KnifeAttack(id, i, g_iKnifeAttack[id], iEntity);
		}
		ExecuteForward(g_fwPrimaryPreAttackPost, g_fwDummyResult, iEntity, id, i);
		return HAM_SUPERCEDE;
	}
	ExecuteForward(g_fwPrimaryPreAttackPre, g_fwDummyResult, iEntity, id, i);
	if (g_fwDummyResult == 1)
	return HAM_SUPERCEDE;

	if (get_pdata_int(iEntity, 55)) set_pdata_int(iEntity, 55, 0);
	if (g_fwDummyResult == 2)
	{
		if (get_pdata_int(iEntity, 51, 4) <= 0)
		return HAM_IGNORED;

		new Float:push[3];
		push[1] = 0.0;
		push[2] = 0.0;
		if ((get_pdata_int(iEntity, 74, 4) & (1<<2)) || (get_pdata_int(iEntity, 74, 4) & (1<<0)))
		{
			if (random_num(0, 1)) engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound3[id][i], VOL_NORM, g_fWeaponSilenceFireSoundVolume[id][i], 0, PITCH_NORM);
			else engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound4[id][i], VOL_NORM, g_fWeaponSilenceFireSoundVolume[id][i], 0, PITCH_NORM);
		}
		else
		{
			if (random_num(0, 1)) engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound1[id][i], VOL_NORM, g_fWeaponFireSoundVolume[id][i], 0, PITCH_NORM);
			else engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound2[id][i], VOL_NORM, g_fWeaponFireSoundVolume[id][i], 0, PITCH_NORM);
		}
		if (fm_cs_get_user_zoom(id) != 1 || SightMode[id] == OPEN)
		{
			push[0] = -1.0 * g_fWeaponAimRecoil[id][i];
			set_pdata_float(id, 83, g_fWeaponAimSpeed[id][i], 5);
			set_pdata_float(iEntity, 46, g_fWeaponAimSpeed[id][i], 4);
		}
		else if (fm_cs_get_user_zoom(id) == 1 && SightMode[id] != OPEN)
		{
			push[0] = -1.0 * g_fWeaponRecoil[id][i];
			set_pdata_float(id, 83, g_fWeaponSpeed[id][i], 5);
			set_pdata_float(iEntity, 46, g_fWeaponSpeed[id][i], 4);
		}
		else if ((get_pdata_int(iEntity, 74, 4) & (1<<2)) || (get_pdata_int(iEntity, 74, 4) & (1<<0)))
		{
			push[0] = -1.0 * g_fWeaponSilencedRecoil[id][i];
			set_pdata_float(id, 83, g_fWeaponSilencedSpeed[id][i], 5);
			set_pdata_float(iEntity, 46, g_fWeaponSilencedSpeed[id][i], 4);
		}
		set_pev(id, pev_punchangle, push);
		if ((get_pdata_int(iEntity, 74, 4) & (1<<2)) || (get_pdata_int(iEntity, 74, 4) & (1<<0))) PlayAnim(id, g_iWeaponAnim[id][i][random_num(ANIM_SHOOT1_SILENCED, ANIM_SHOOT3_SILENCED)]);
		else if (g_iWeaponId[id][i] == CSW_ELITE)
		{
			if (!g_iEliteShotNumber[id])
			{
				PlayAnim(id, g_iWeaponAnim[id][i][ANIM_SHOOT1]);
				g_iEliteShotNumber[id] = 1;
			}
			else
			{
				PlayAnim(id, g_iWeaponAnim[id][i][ANIM_SHOOT2]);
				g_iEliteShotNumber[id] = 0;
			}
		}
		else PlayAnim(id, g_iWeaponAnim[id][i][random_num(ANIM_SHOOT1, ANIM_SHOOT3)]);
		if (get_pdata_int(iEntity, 51, 4) > 0)
		{
			ExecuteForward(g_fwPrimaryPostAttackPre, g_fwDummyResult, iEntity, id, i);
			if (g_fwDummyResult == 1)
			return HAM_SUPERCEDE;
		}
		set_pdata_int(iEntity, 51, get_pdata_int(iEntity, 51, 4) - 1, 4);
		ExecuteForward(g_fwPrimaryPostAttackPost, g_fwDummyResult, iEntity, id, i);
		return HAM_SUPERCEDE;
	}
	if (g_iWeaponId[id][i] == CSW_M3 || g_iWeaponId[id][i] == CSW_XM1014)
	{
		if (SightMode[id] == ATOB || SightMode[id] == BTOA)
		return HAM_SUPERCEDE;
	}
	g_IsInPrimaryAttack = true;
	pev(id, pev_punchangle, cl_fPushAngle[id]);
	g_iClipAmmo[id] = get_pdata_int(iEntity, 51, 4);
	ExecuteForward(g_fwPrimaryPreAttackPost, g_fwDummyResult, iEntity, id, i);
	return HAM_IGNORED;
}

public HAM_Weapon_SecondaryAttack(iEntity)
{
	new id = get_pdata_cbase(iEntity, 41, 4);
	new i = GetWeaponType(iEntity);
	if (!i)
	return HAM_IGNORED;

	if (g_iWeaponId[id][i] == CSW_HEGRENADE)
	return HAM_IGNORED;

	ExecuteForward(g_fwSecondaryPreAttackPre, g_fwDummyResult, iEntity, id, i);
	if (g_fwDummyResult == 1)
	return HAM_SUPERCEDE;

	if (g_iWeaponId[id][i] == CSW_KNIFE)
	{
		if (!g_fKnifeStabTime[id][i])
		{
			g_fKnifeTempDamage[id] = g_fWeaponDamage2[id][i];
			if (!g_iUserKnifeAttack[id]) g_iUserKnifeAttack[id] = 2;
			ExecuteForward(g_fwSecondaryPreAttackPost, g_fwDummyResult, iEntity, id, i);
			return HAM_IGNORED;
		}
		else
		{
			if (g_iKnifeAttack[id])
			return HAM_SUPERCEDE;

			g_iKnifeAttack[id] = 3;
			KnifeAttack(id, i, g_iKnifeAttack[id], iEntity);
		}
		ExecuteForward(g_fwSecondaryPreAttackPost, g_fwDummyResult, iEntity, id, i);
		return HAM_SUPERCEDE;
	}
	if (g_iWeaponSight[id][i])
	return HAM_SUPERCEDE;

	if (g_iWeaponId[id][i] == CSW_M4A1 || g_iWeaponId[id][i] == CSW_USP || g_iWeaponId[id][i] == CSW_FAMAS || g_iWeaponId[id][i] == CSW_GLOCK18)
	return HAM_SUPERCEDE;

	return HAM_IGNORED;
}

public HAM_Weapon_PrimaryAttack_Post(iEntity)
{
	new id = get_pdata_cbase(iEntity, 41, 4);
	new i = GetWeaponType(iEntity);
	if (!i)
	return;

	if (g_iWeaponId[id][i] == CSW_KNIFE)
	{
		if (!g_fKnifeSlashTime[id][i])
		{
			set_pdata_float(id, 83, g_fKnifeSlashResetTime[id][i], 5);
			set_pdata_float(iEntity, 46, g_fKnifeSlashResetTime[id][i], 4);
		}
		return;
	}
	if (!g_IsInPrimaryAttack)
	return;

	if (get_pdata_int(iEntity, 51, 4) > 0)
	{
		ExecuteForward(g_fwPrimaryPostAttackPre, g_fwDummyResult, iEntity, id, i);
		if (g_fwDummyResult == 1)
		return;
	}
	g_IsInPrimaryAttack = false;
	if (!g_iClipAmmo[id] || g_iClipAmmo[id] == get_pdata_int(iEntity, 51, 4))
	return;

	new Float:push[3];
	pev(id, pev_punchangle, push);
	xs_vec_sub(push, cl_fPushAngle[id], push);
	if ((get_pdata_int(iEntity, 74, 4) & (1<<2)) || (get_pdata_int(iEntity, 74, 4) & (1<<0)))
	{
		if (random_num(0, 1)) engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound3[id][i], VOL_NORM, g_fWeaponSilenceFireSoundVolume[id][i], 0, PITCH_NORM);
		else engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound4[id][i], VOL_NORM, g_fWeaponSilenceFireSoundVolume[id][i], 0, PITCH_NORM);
	}
	else
	{
		if (random_num(0, 1)) engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound1[id][i], VOL_NORM, g_fWeaponFireSoundVolume[id][i], 0, PITCH_NORM);
		else engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound2[id][i], VOL_NORM, g_fWeaponFireSoundVolume[id][i], 0, PITCH_NORM);
	}
	if ((fm_cs_get_user_zoom(id) != 1 || SightMode[id] == OPEN) && !((get_pdata_int(iEntity, 74, 4) & (1<<2)) || (get_pdata_int(iEntity, 74, 4) & (1<<0))))
	{
		xs_vec_mul_scalar(push, g_fWeaponAimRecoil[id][i], push);
		set_pdata_float(id, 83, g_fWeaponAimSpeed[id][i], 5);
		set_pdata_float(iEntity, 46, g_fWeaponAimSpeed[id][i], 4);
	}
	else if (fm_cs_get_user_zoom(id) == 1 && SightMode[id] != OPEN && !((get_pdata_int(iEntity, 74, 4) & (1<<2)) || (get_pdata_int(iEntity, 74, 4) & (1<<0))))
	{
		xs_vec_mul_scalar(push, g_fWeaponRecoil[id][i], push);
		set_pdata_float(id, 83, g_fWeaponSpeed[id][i], 5);
		set_pdata_float(iEntity, 46, g_fWeaponSpeed[id][i], 4);
	}
	else if ((get_pdata_int(iEntity, 74, 4) & (1<<2)) || (get_pdata_int(iEntity, 74, 4) & (1<<0)))
	{
		xs_vec_mul_scalar(push, g_fWeaponSilencedRecoil[id][i], push);
		set_pdata_float(id, 83, g_fWeaponSilencedSpeed[id][i], 5);
		set_pdata_float(iEntity, 46, g_fWeaponSilencedSpeed[id][i], 4);
	}
	xs_vec_add(push, cl_fPushAngle[id], push);
	set_pev(id, pev_punchangle, push);
	if ((get_pdata_int(iEntity, 74, 4) & (1<<2)) || (get_pdata_int(iEntity, 74, 4) & (1<<0))) PlayAnim(id, g_iWeaponAnim[id][i][random_num(ANIM_SHOOT1_SILENCED, ANIM_SHOOT3_SILENCED)]);
	else if (g_iWeaponId[id][i] == CSW_ELITE)
	{
		if (!g_iEliteShotNumber[id])
		{
			PlayAnim(id, g_iWeaponAnim[id][i][ANIM_SHOOT1]);
			g_iEliteShotNumber[id] = 1;
		}
		else
		{
			PlayAnim(id, g_iWeaponAnim[id][i][ANIM_SHOOT2]);
			g_iEliteShotNumber[id] = 0;
		}
	}
	else PlayAnim(id, g_iWeaponAnim[id][i][random_num(ANIM_SHOOT1, ANIM_SHOOT3)]);
	ExecuteForward(g_fwPrimaryPostAttackPost, g_fwDummyResult, iEntity, id, i);
}

public HAM_Weapon_SecondaryAttack_Post(iEntity)
{
	new id = get_pdata_cbase(iEntity, 41, 4);
	new i = GetWeaponType(iEntity);
	if (!i)
	return;

	ExecuteForward(g_fwSecondaryPostAttackPre, g_fwDummyResult, iEntity, id, i);
	if (g_fwDummyResult == 1)
	return;

	if (g_iWeaponId[id][i] == CSW_KNIFE)
	{
		if (!g_fKnifeStabTime[id][i])
		{
			set_pdata_float(id, 83, g_fKnifeStabResetTime[id][i], 5);
			set_pdata_float(iEntity, 47, g_fKnifeStabResetTime[id][i], 4);
		}
		return;
	}
	if (g_iWeaponId[id][i] == CSW_HEGRENADE)
	return;

	if (g_iWeaponSight[id][i])
	return;

	if (fm_cs_get_user_zoom(id) == 2 || fm_cs_get_user_zoom(id) == 3) set_pev(id, pev_viewmodel2, "");
	else
	{
		set_pev(id, pev_viewmodel2, g_szWeaponVModel[id][i]);
		PlayAnim(id, g_iWeaponAnim[id][i][ANIM_IDLE]);
	}
	if (g_iWeaponId[id][i] == CSW_M4A1 || g_iWeaponId[id][i] == CSW_USP)
	{
		if ((get_pdata_int(iEntity, 74, 4) & (1<<2)) || (get_pdata_int(iEntity, 74, 4) & (1<<0)))
		{
			if (g_iWeaponId[id][i] == CSW_M4A1) set_pdata_int(iEntity, 74, get_pdata_int(iEntity, 74, 4) &~ (1<<2), 4);
			else if (g_iWeaponId[id][i] == CSW_USP) set_pdata_int(iEntity, 74, get_pdata_int(iEntity, 74, 4) &~ (1<<0), 4);
			PlayAnim(id, g_iWeaponAnim[id][i][ANIM_DETACH_SILENCER]);
			set_pdata_float(iEntity, 46, g_fWeaponSilencedTime[id][i][1], 4);
			set_pdata_float(iEntity, 47, g_fWeaponSilencedTime[id][i][1], 4);
			set_pdata_float(iEntity, 48, g_fWeaponSilencedTime[id][i][1], 4);
			set_pdata_float(id, 83, g_fWeaponSilencedTime[id][i][1], 5);
		}
		else
		{
			if (g_iWeaponId[id][i] == CSW_M4A1) set_pdata_int(iEntity, 74, get_pdata_int(iEntity, 74, 4) | (1<<2), 4);
			else if (g_iWeaponId[id][i] == CSW_USP) set_pdata_int(iEntity, 74, get_pdata_int(iEntity, 74, 4) | (1<<0), 4);
			PlayAnim(id, g_iWeaponAnim[id][i][ANIM_ATTACH_SILENCER]);
			set_pdata_float(iEntity, 46, g_fWeaponSilencedTime[id][i][0], 4);
			set_pdata_float(iEntity, 47, g_fWeaponSilencedTime[id][i][0], 4);
			set_pdata_float(iEntity, 48, g_fWeaponSilencedTime[id][i][0], 4);
			set_pdata_float(id, 83, g_fWeaponSilencedTime[id][i][0], 5);
		}
	}
	ExecuteForward(g_fwSecondaryPostAttackPost, g_fwDummyResult, iEntity, id, i);
}

public HAM_Item_PostFrame(iEntity)
{
	new id = get_pdata_cbase(iEntity, 41, 4);
	new i = GetWeaponType(iEntity);
	if (!is_user_alive(id))
	return HAM_IGNORED;

	// 记录原版武器的换弹
	if (!i)
	{
		new iWeapon = get_pdata_int(iEntity, 43);
		new iWeaponBitSum = (1<<CSW_KNIFE)|(1<<CSW_HEGRENADE)|(1<<CSW_SMOKEGRENADE)|(1<<CSW_FLASHBANG)|(1<<CSW_C4);
		if (!((1<<iWeapon) & iWeaponBitSum))
		{
			if (iWeapon != CSW_M3 && iWeapon != CSW_XM1014)
			{
				if (get_pdata_int(iEntity, 54) && get_pdata_float(id, 83) <= 0.0)
					g_iGameCurWeaponBPAmmo[id][iWeapon] = fm_cs_get_user_bpammo(id, iWeapon);
			}
			else if (get_pdata_int(iEntity, 55) == 1 && get_pdata_float(iEntity, 48) <= 0.0)
				g_iGameCurWeaponBPAmmo[id][iWeapon] = fm_cs_get_user_bpammo(id, iWeapon);
		}
		return HAM_IGNORED;
	}
	ExecuteForward(g_fwWeaponPostFrame, g_fwDummyResult, iEntity, id, i);
	if (g_fwDummyResult == 1)
	return HAM_SUPERCEDE;

	if (g_iWeaponId[id][i] == CSW_KNIFE)
	return HAM_IGNORED;

	if (!g_iWeaponClip[id][i])
	return HAM_IGNORED;

	if (!Reload[id])
	{
		new iClipExtra = g_iWeaponClip[id][i];
		new Float:flNextAttack = get_pdata_float(id, 83, 5);
		new iBpAmmo = fm_cs_get_user_bpammo(id, g_iWeaponId[id][i]);
		new iClip = get_pdata_int(iEntity, 51, 4);
		new fInReload = get_pdata_int(iEntity, 54, 4);
		if (fInReload && flNextAttack <= 0.0 && !g_iReloadMode[id][i])
		{
			new j = min(iClipExtra - iClip, iBpAmmo);
			set_pdata_int(iEntity, 51, iClip + j, 4);
			fm_cs_set_user_bpammo(id, g_iWeaponId[id][i], iBpAmmo-j);
			g_iCurWeaponBPAmmo[id][i] = iBpAmmo-j;
			set_pdata_int(iEntity, 54, 0, 4);
			fInReload = 0;
		}
		if (g_iReloadMode[id][i])
		{
			new iButton = pev(id, pev_button);
			if (iButton & IN_ATTACK && get_pdata_float(iEntity, 46, 4) <= 0.0 && get_pdata_int(iEntity, 51, 4))
			return HAM_IGNORED;

			if (!get_pdata_int(iEntity, 51, 4) && fm_cs_get_user_bpammo(id, g_iWeaponId[id][i]))
			{
				set_pev(id, pev_button, iButton & ~IN_ATTACK);
				if (!get_pdata_int(iEntity, 55, 4) && !get_pdata_int(iEntity, 54, 4))
				{
					if (g_iWeaponSight[id][i] && SightMode[id] != CLOSED)
					{
						if (SightMode[id] != OPEN)
						return HAM_IGNORED;

						Reload[id] = true;
						BeginClosing(iEntity);
						return HAM_IGNORED;
					}
				}
			}
			new iTempClip;
			if (g_iWeaponId[id][i] == CSW_M3) iTempClip = 8;
			else if (g_iWeaponId[id][i] == CSW_XM1014) iTempClip = 7;
			if (iButton & IN_RELOAD && !fInReload && iTempClip)
			{
				if (g_iWeaponSight[id][i] && SightMode[id] != CLOSED)
				{
					if (SightMode[id] != OPEN)
					return HAM_IGNORED;

					Reload[id] = true;
					BeginClosing(iEntity);
					return HAM_IGNORED;
				}
				if (iClip >= iClipExtra) set_pev(id, pev_button, iButton & ~IN_RELOAD);
				else if (iClip == iTempClip)
				{
					if (!iBpAmmo)
					return HAM_IGNORED;

					if (g_iWeaponSight[id][i] && SightMode[id] != CLOSED)
					return HAM_IGNORED;

					// 子弹数和原版一样时，按R键装一发子弹，然后触发idle的装弹
					ShotgunReload(iEntity, iClipExtra, iClip, iBpAmmo, id, g_iWeaponId[id][i]);
				}
			}
		}
	}
	if (g_iWeaponSight[id][i])
	{
		if (get_pdata_int(iEntity, 54, 4) || get_pdata_int(iEntity, 55, 4))
		return HAM_IGNORED;

		if (get_pdata_float(iEntity, 47, 4) > 0.0)
		{
			new Float:fCurTime;
			global_get(glb_time, fCurTime);
			if (fCurTime <= NextThink[id])
			return FMRES_IGNORED;

			if (g_fSightFrameRate[id][i] <= 0.0 || g_fSightDistance[id][i] <= 0)
			return FMRES_IGNORED;

			new Float:valve = g_fSightFrameRate[id][i];
			if (valve < 1.0) valve = 1.0;
			if (SightMode[id] == ATOB)
			{
				set_pdata_int(id, 363, max(get_pdata_int(id, 363, 5)-floatround(valve), floatround(g_fSightDistance[id][i])), 5);
				NextThink[id] = fCurTime + g_fSightOpenTime[id][i]/((90.0-g_fSightDistance[id][i])/g_fSightFrameRate[id][i]);
			}
			else if (SightMode[id] == BTOA)
			{
				set_pdata_int(id, 363, min(get_pdata_int(id, 363, 5)+floatround(valve), 90));
				NextThink[id] = fCurTime + g_fSightCloseTime[id][i]/((90.0-g_fSightDistance[id][i])/g_fSightFrameRate[id][i]);
			}
			return FMRES_IGNORED;
		}
		if (SightMode[id] == ATOB)
		{
			OpeningEnd(iEntity);
			return FMRES_IGNORED;
		}
		if (SightMode[id] == BTOA)
		{
			ClosingEnd(iEntity);
			return FMRES_IGNORED;
		}
		new button = pev(id, pev_button);
		if (!(button & IN_ATTACK2))
		{
			OldButton[id] = false;
			return HAM_IGNORED;
		}
		if (OldButton[id])
		return HAM_SUPERCEDE;

		OldButton[id] = true;
		if ((button & IN_ATTACK))
		return HAM_SUPERCEDE;

		if (get_pdata_float(iEntity, 46, 4) > 0.0)
		return HAM_SUPERCEDE;

		if (SightMode[id] == CLOSED)
		{
			BeginOpening(iEntity);
			return HAM_SUPERCEDE;
		}
		BeginClosing(iEntity);
		return HAM_SUPERCEDE;
	}
	return HAM_IGNORED;
}

public HAM_Weapon_Reload(iEntity)
{
	new id = get_pdata_cbase(iEntity, 41, 4);
	new i = GetWeaponType(iEntity);
	if (!is_user_alive(id))
	return HAM_IGNORED;

	if (!i)
	return HAM_IGNORED;

	if (g_iWeaponId[id][i] == CSW_KNIFE)
	return HAM_IGNORED;

	if (!g_iWeaponClip[id][i])
	return HAM_SUPERCEDE;

	ExecuteForward(g_fwWeaponReloadPre, g_fwDummyResult, iEntity, id, i);
	if (g_fwDummyResult == 1)
	return HAM_SUPERCEDE;

	if (g_iWeaponSight[id][i] && SightMode[id] != CLOSED)
	{
		if (SightMode[id] != OPEN)
		return HAM_SUPERCEDE;

		Reload[id] = true;
		BeginClosing(iEntity);
		return HAM_SUPERCEDE;
	}
	new iBpAmmo = fm_cs_get_user_bpammo(id, g_iWeaponId[id][i]);
	new iClip = get_pdata_int(iEntity, 51, 4);
	new fInSpecReload = get_pdata_int(iEntity, 55, 4);

	// 在ShotgunReload里判断并设置换弹状态，fInSpecReload为2时忽略，使用原版的装填子弹
	if (g_iReloadMode[id][i])
	{
		if (fInSpecReload < 2 && (g_iWeaponId[id][i] == CSW_M3 || g_iWeaponId[id][i] == CSW_XM1014))
			ShotgunReload(iEntity, g_iWeaponClip[id][i], iClip, iBpAmmo, id, g_iWeaponId[id][i]);

		if (g_iWeaponId[id][i] != CSW_M3 && g_iWeaponId[id][i] != CSW_XM1014)
		{
			ShotgunReload(iEntity, g_iWeaponClip[id][i], iClip, iBpAmmo, id, g_iWeaponId[id][i]);
			return HAM_SUPERCEDE;
		}
	}
	new iClipExtra = g_iWeaponClip[id][i];
	g_iTmpClip[id][i] = -1;
	if (iBpAmmo <= 0)
	return HAM_SUPERCEDE;

	if (iClip >= iClipExtra)
	return HAM_SUPERCEDE;

	g_iTmpClip[id][i] = iClip;
	return HAM_IGNORED;
}

public HAM_Weapon_Reload_Post(iEntity)
{
	new id = get_pdata_cbase(iEntity, 41, 4);
	new i = GetWeaponType(iEntity);
	if (!is_user_alive(id))
	return;

	if (!i)
	return;

	if (g_iWeaponId[id][i] == CSW_KNIFE)
	return;

	ExecuteForward(g_fwWeaponReloadPost, g_fwDummyResult, iEntity, id, i);
	if (g_fwDummyResult == 1)
	return;

	if (g_iWeaponSight[id][i] && Reload[id])
	return;

	if (g_iWeaponSight[id][i] && SightMode[id] != CLOSED)
	return;

	new fInSpecReload = get_pdata_int(iEntity, 55, 4);
	if (g_iReloadMode[id][i])
	{
		if (fInSpecReload == 1) g_iCurWeaponBPAmmo[id][i] = fm_cs_get_user_bpammo(id, g_iWeaponId[id][i]);
		return;
	}
	if (!g_iWeaponClip[id][i])
	return;

	if (g_iTmpClip[id][i] == -1)
	return;

	set_pdata_int(iEntity, 51, g_iTmpClip[id][i], 4);
	set_pdata_float(iEntity, 48, g_fWeaponReloadTime[id][i][0], 4);
	set_pdata_float(id, 83, g_fWeaponReloadTime[id][i][0], 5);
	set_pdata_int(iEntity, 54, 1, 4);
	if ((get_pdata_int(iEntity, 74, 4) & (1<<2)) || (get_pdata_int(iEntity, 74, 4) & (1<<0))) PlayAnim(id, g_iWeaponAnim[id][i][ANIM_RELOAD_SILENCED]);
	else PlayAnim(id, g_iWeaponAnim[id][i][ANIM_RELOAD]);
}

public HAM_Weapon_WeaponIdle(iEntity)
{
	new id = get_pdata_cbase(iEntity, 41, 4);
	new i = GetWeaponType(iEntity);
	if (!is_user_alive(id))
	return HAM_IGNORED;

	if (!i)
	return HAM_IGNORED;

	ExecuteForward(g_fwWeaponIdlePre, g_fwDummyResult, iEntity, id, i);
	if (g_fwDummyResult == 1)
	return HAM_SUPERCEDE;

	if (g_iReloadMode[id][i])
	{
		if (get_pdata_float(iEntity, 48, 4) > 0.0)
		return HAM_IGNORED;

		if (Reload[id])
		return HAM_IGNORED;

		new iBpAmmo = fm_cs_get_user_bpammo(id, g_iWeaponId[id][i]);
		new iClip = get_pdata_int(iEntity, 51, 4);
		new fInSpecReload = get_pdata_int(iEntity, 55, 4);
		if (!iClip && !fInSpecReload)
		{
			if (g_iWeaponSight[id][i] && SightMode[id] != OPEN && SightMode[id] != CLOSED)
			return HAM_SUPERCEDE;

			return HAM_IGNORED;
		}
		if (g_iWeaponSight[id][i] && SightMode[id] != OPEN && SightMode[id] != CLOSED)
		return HAM_SUPERCEDE;

		new iTempClip;
		if (g_iWeaponId[id][i] == CSW_M3) iTempClip = 8;
		else if (g_iWeaponId[id][i] == CSW_XM1014) iTempClip = 7;
		if (fInSpecReload && iTempClip)
		{
			// 弹夹数和原版一样时继续换弹
			if (iClip < g_iWeaponClip[id][i] && iClip == iTempClip && iBpAmmo)
				ShotgunReload(iEntity, g_iWeaponClip[id][i], iClip, iBpAmmo, id, g_iWeaponId[id][i]);

			// 换弹结束
			else if (iClip == g_iWeaponClip[id][i])
			{
				PlayAnim(id, g_iWeaponAnim[id][i][ANIM_AFTER_RELOAD]);
				set_pdata_int(iEntity, 55, 0, 4);
				set_pdata_float(iEntity, 46, g_fWeaponReloadTime[id][i][2]);
				set_pdata_float(iEntity, 47, g_fWeaponReloadTime[id][i][2]);
				set_pdata_float(iEntity, 48, g_fWeaponReloadTime[id][i][2]);
				set_pdata_float(id, 83, g_fWeaponReloadTime[id][i][2]);
			}
		}
		else if (fInSpecReload && !iTempClip)
		{
			if (iClip < g_iWeaponClip[id][i] && iBpAmmo)
				ExecuteHamB(Ham_Weapon_Reload, iEntity);

			else if (iClip == g_iWeaponClip[id][i] || !iBpAmmo)
			{
				PlayAnim(id, g_iWeaponAnim[id][i][ANIM_AFTER_RELOAD]);
				set_pdata_int(iEntity, 55, 0, 4);
				set_pdata_float(iEntity, 46, g_fWeaponReloadTime[id][i][2]);
				set_pdata_float(iEntity, 47, g_fWeaponReloadTime[id][i][2]);
				set_pdata_float(iEntity, 48, g_fWeaponReloadTime[id][i][2]);
				set_pdata_float(id, 83, g_fWeaponReloadTime[id][i][2]);
			}
			return HAM_SUPERCEDE;
		}
	}
	if (get_pdata_float(iEntity, 48, 4) <= 0.0 && g_iWeaponId[id][i] != CSW_HEGRENADE && !get_pdata_int(iEntity, 55, 4) && !get_pdata_int(iEntity, 54, 4))
	{
		if (g_iWeaponId[id][i] == CSW_KNIFE) PlayAnim(id, g_iKnifeAnim[id][i][KNIFE_ANIM_IDLE]);
		else
		{
			if ((get_pdata_int(iEntity, 74, 4) & (1<<2)) || (get_pdata_int(iEntity, 74, 4) & (1<<0))) PlayAnim(id, g_iWeaponAnim[id][i][ANIM_IDLE_SILENCED]);
			else PlayAnim(id, g_iWeaponAnim[id][i][ANIM_IDLE]);
		}
		set_pdata_float(iEntity, 48, 20.0, 4);
		return HAM_SUPERCEDE;
	}
	return HAM_IGNORED;
}

public HAM_UseStationary_Post(iEntity, id, activator, use_type)
{
	if (!use_type && is_user_connected(id))
		Event_CurWeapon(id);
}

public HAM_TakeDamage(victim, inflictor, attacker, Float:damage, damage_type)
{
	if (!is_user_connected(attacker) || !is_user_connected(victim))
	return HAM_IGNORED;

	ExecuteForward(g_fwTakeDamage, g_fwDummyResult, victim, inflictor, attacker, damage, damage_type);
	if (g_fwDummyResult == 1)
	return HAM_SUPERCEDE;

	damage *= g_fDamagePoint[attacker] * g_fDamageVictimPoint[victim];
	new i = GetWeaponType(inflictor);
	if (damage_type & (1<<24))
	{
		if (!i)
		{
			SetHamParamFloat(4, damage);
			return HAM_IGNORED;
		}
		damage *= g_fWeaponDamage[attacker][i];
		new Float:fOrigin[3], Float:fOrigin2[3];
		pev(victim, pev_origin, fOrigin);
		pev(inflictor, pev_origin, fOrigin2);
		new Float:fDistance = get_distance_f(fOrigin, fOrigin2);
		damage -= damage * fDistance / g_fGrenadeData[attacker][i][2];
		if (damage <= 0.0) damage = 0.0;
		SetHamParamFloat(4, damage);
		return HAM_IGNORED;
	}
	if (attacker != inflictor)
	{
		if (i) g_iAttackerEntity[attacker] = inflictor;
		else
		{
			SetHamParamFloat(4, damage);
			return HAM_IGNORED;
		}
	}
	else
	{
		new iEntity = get_pdata_cbase(attacker, 373);
		if (iEntity <= 0)
		return HAM_IGNORED;

		i = GetWeaponType(iEntity);
		if (!i)
		{
			SetHamParamFloat(4, damage);
			return HAM_IGNORED;
		}
		g_iAttackerEntity[attacker] = iEntity;
	}
	if (g_iWeaponId[attacker][i] == CSW_KNIFE)
	{
		if (g_fKnifeTempDamage[attacker])
		{
			SetHamParamFloat(4, damage * g_fKnifeTempDamage[attacker]);
			g_fKnifeTempDamage[attacker] = 0.0;
		}
		return HAM_IGNORED;
	}
	SetHamParamFloat(4, damage * g_fWeaponDamage[attacker][i]);
	return HAM_IGNORED;
}

public HAM_TakeDamage_Post(victim, inflictor, attacker, Float:damage, damage_type)
{
	if (!is_user_connected(attacker) || !is_user_connected(victim))
	return;

	if (get_pdata_int(attacker, 114, 5) == get_pdata_int(victim, 114, 5))
	return;

	if (g_iAttackerEntity[attacker])
	{
		new Float:fHealth;
		pev(victim, pev_health, fHealth);
		if (fHealth - damage > 0.0) g_iAttackerEntity[attacker] = 0;
	}
	new iEntity = get_pdata_cbase(attacker, 373);
	if (iEntity <= 0)
	return;

	new i = GetWeaponType(iEntity);
	ExecuteForward(g_fwWeaponKnockBackPre, g_fwDummyResult, attacker, victim, inflictor, i, damage);
	if (g_fwDummyResult == 1)
	return;

	if (!i)
	return;

	new ducking = pev(victim, pev_flags) & (FL_DUCKING | FL_ONGROUND) == (FL_DUCKING | FL_ONGROUND);
	new Float:fOrigin[3], Float:fOrigin2[3], Float:fVelocity[3], Float:fVelocity2[3], Float:fKnockBack;
	pev(victim, pev_origin, fOrigin);
	pev(attacker, pev_origin, fOrigin2);
	pev(victim, pev_velocity, fVelocity2);
	if (ducking) fKnockBack = damage * g_fWeaponKnockBack[attacker][i] * 0.25 * g_fKnockBackPoint[victim];
	else fKnockBack = damage * g_fWeaponKnockBack[attacker][i] * g_fKnockBackPoint[victim];
	GetVelocityFromOrigin(fOrigin, fOrigin2, fKnockBack, fVelocity);
	fVelocity[2] = fVelocity2[2];
	set_pev(victim, pev_velocity, fVelocity);
}

public HAM_Killed_Post(id, iAttacker)
{
	if (!is_user_connected(id))
	return;

	// 死亡时剥夺所有子弹
	const PRIMARY_WEAPONS_BIT_SUM = (1<<CSW_SCOUT)|(1<<CSW_XM1014)|(1<<CSW_MAC10)|(1<<CSW_AUG)|(1<<CSW_UMP45)|(1<<CSW_SG550)|(1<<CSW_GALIL)|(1<<CSW_FAMAS)|(1<<CSW_AWP)|(1<<CSW_MP5NAVY)|(1<<CSW_M249)|(1<<CSW_M3)|(1<<CSW_M4A1)|(1<<CSW_TMP)|(1<<CSW_G3SG1)|(1<<CSW_SG552)|(1<<CSW_AK47)|(1<<CSW_P90);
	const SECONDARY_WEAPONS_BIT_SUM = (1<<CSW_P228)|(1<<CSW_ELITE)|(1<<CSW_FIVESEVEN)|(1<<CSW_USP)|(1<<CSW_GLOCK18)|(1<<CSW_DEAGLE);
	for (new i = 1; i < MAXWEAPON; i ++) g_iCurWeaponBPAmmo[id][i] = 0;
	for (new i = 0; i < 32; i ++) g_iGameCurWeaponBPAmmo[id][i] = 0;
	for (new i = 1; i < 31; i ++) if ((1<<i) & (PRIMARY_WEAPONS_BIT_SUM|SECONDARY_WEAPONS_BIT_SUM)) fm_cs_set_user_bpammo(id, i, 0);
}

public HAM_ThinkGrenade(iEntity)
{
	if (!pev_valid(iEntity))
	return HAM_IGNORED;

	new Float:fDmgTime, Float:fCurTime, Float:fOrigin[3], victim;
	pev(iEntity, pev_dmgtime, fDmgTime);
	fCurTime = get_gametime();
	if (fDmgTime > fCurTime)
	return HAM_IGNORED;

	new i = GetWeaponType(iEntity);
	if (!i)
	return HAM_IGNORED;

	ExecuteForward(g_fwGrenadeExplode, g_fwDummyResult, iEntity, pev(iEntity, pev_owner), i);
	if (g_fwDummyResult == 1)
	return HAM_SUPERCEDE;

	pev(iEntity, pev_origin, fOrigin);
	engfunc(EngFunc_MessageBegin, MSG_ALL, SVC_TEMPENTITY, fOrigin, 0);
	write_byte(TE_EXPLOSION);
	engfunc(EngFunc_WriteCoord, fOrigin[0]);
	engfunc(EngFunc_WriteCoord, fOrigin[1]);
	engfunc(EngFunc_WriteCoord, fOrigin[2] + 45.0);
	write_short(g_iGrenadeSprId[pev(iEntity, pev_owner)][i]);
	write_byte(25);
	write_byte(30);
	write_byte(TE_EXPLFLAG_NOSOUND);
	message_end();
	engfunc(EngFunc_MessageBegin, MSG_PAS, SVC_TEMPENTITY, fOrigin, 0);
	write_byte(TE_WORLDDECAL);
	engfunc(EngFunc_WriteCoord, fOrigin[0]);
	engfunc(EngFunc_WriteCoord, fOrigin[1]);
	engfunc(EngFunc_WriteCoord, fOrigin[2]);
	write_byte(engfunc(EngFunc_DecalIndex, "{scorch3"));
	message_end();
	engfunc(EngFunc_EmitSound, iEntity, CHAN_STATIC, g_szWeaponSound1[pev(iEntity, pev_owner)][i], VOL_NORM, g_fWeaponFireSoundVolume[pev(iEntity, pev_owner)][i], 0, PITCH_NORM);

	// 记录手雷的序号，给deathmsg用
	g_iUserGrenadeId[pev(iEntity, pev_owner)] = i;
	while ((victim = engfunc(EngFunc_FindEntityInSphere, victim, fOrigin, g_fGrenadeData[pev(iEntity, pev_owner)][i][2])) != 0)
	{
		if (!pev_valid(victim))
		continue;

		if (pev(victim, pev_solid) <= SOLID_NOT)
		continue;

		if (pev(victim, pev_takedamage) <= 0.0)
		continue;

		if (victim != pev(iEntity, pev_owner) && get_pdata_int(pev(iEntity, pev_owner), 114, 5) == get_pdata_int(victim, 114, 5) && !get_cvar_num("mp_friendlyfire"))
		continue;

		ExecuteHamB(Ham_TakeDamage, victim, iEntity, pev(iEntity, pev_owner), 100.0, (1<<24));
		ExecuteForward(g_fwGrenadeExplodePost, g_fwDummyResult, pev(iEntity, pev_owner), iEntity, victim, i);
	}
	g_iUserGrenadeId[pev(iEntity, pev_owner)] = 0;
	engfunc(EngFunc_RemoveEntity, iEntity);
	return HAM_SUPERCEDE;
}

// 其他方式获取的子弹
public HAM_GiveAmmo(id, iAmount, szAmmo[], iMax)
{
	new iEntity = get_pdata_cbase(id, 373);
	if (!pev_valid(iEntity))
	return HAM_IGNORED;

	strtolower(szAmmo);
	new const szSpecialAmmo[][] = { "hegrenade", "flashbang", "smokegrenade", "c4" };
	for (new ii = 0; ii < sizeof szSpecialAmmo; ii ++)
	{
		if (!strcmp(szAmmo, szSpecialAmmo[ii]))
		return HAM_IGNORED;
	}
	new i = GetWeaponType(iEntity);
	new iWeapon = get_pdata_int(iEntity, 43);
	new iWeaponBitSum = (1<<CSW_KNIFE)|(1<<CSW_HEGRENADE)|(1<<CSW_SMOKEGRENADE)|(1<<CSW_FLASHBANG)|(1<<CSW_C4);
	new iSecWeaponBitSum = (1<<CSW_P228)|(1<<CSW_ELITE)|(1<<CSW_FIVESEVEN)|(1<<CSW_USP)|(1<<CSW_GLOCK18)|(1<<CSW_DEAGLE);
	if (!strcmp(g_szGameWeaponAmmoType[iWeapon], szAmmo))
	{
		if (!((1<<iWeapon) & iSecWeaponBitSum) && !((1<<iWeapon) & iWeaponBitSum)) GivePriAmmo(id, iEntity, i, i? (g_iWeaponClip[id][i]? 0 : 1) : 0, 1, iAmount);
		else if ((1<<iWeapon) & iSecWeaponBitSum) GiveSecAmmo(id, iEntity, i, i? (g_iWeaponClip[id][i]? 0 : 1) : 0, 1, iAmount);
	}
	else
	{
		if (get_pdata_cbase(id, 368) == iEntity) iEntity = get_pdata_cbase(id, 369);
		else if (get_pdata_cbase(id, 369) == iEntity) iEntity = get_pdata_cbase(id, 368);
		else if (get_pdata_cbase(id, 368) != iEntity && get_pdata_cbase(id, 369) != iEntity)
		{
			new iEntity1 = get_pdata_cbase(id, 369);
			new iEntity2 = get_pdata_cbase(id, 368);
			if (pev_valid(iEntity1) && !strcmp(g_szGameWeaponAmmoType[get_pdata_int(iEntity1, 43)], szAmmo)) iEntity = iEntity1;
			if (pev_valid(iEntity2) && !strcmp(g_szGameWeaponAmmoType[get_pdata_int(iEntity2, 43)], szAmmo)) iEntity = iEntity2;
		}
		if (!pev_valid(iEntity))
		return HAM_SUPERCEDE;

		i = GetWeaponType(iEntity);
		iWeapon = get_pdata_int(iEntity, 43);
		if (!strcmp(g_szGameWeaponAmmoType[iWeapon], szAmmo))
		{
			if (!((1<<iWeapon) & iSecWeaponBitSum)) GivePriAmmo(id, iEntity, i, i? (g_iWeaponClip[id][i]? 0 : 1) : 0, 1, iAmount);
			else GiveSecAmmo(id, iEntity, i, i? (g_iWeaponClip[id][i]? 0 : 1) : 0, 1, iAmount);
		}
	}
	return HAM_SUPERCEDE;
}

public HAM_PlayerSpawn_Post(id)
{
	if (!is_user_alive(id))
	return;

	if (!is_user_bot(id))
	{
		new iEntity = get_pdata_cbase(id, 373);
		if (iEntity <= 0)
		return;

		new i = GetWeaponType(iEntity);
		if (!i)
		return;

		if (!g_iWeaponSight[id][i])
		return;

		if (SightMode[id] == CLOSED)
		return;

		ClosingEnd(iEntity);
		return;
	}
	if (!g_iRound)
	return;

	g_iBotBuyWeapon[id] = true;
	if (g_iBlockBuy[id] == BUY_NORMALLY) g_fBotNextThink[id] = 0.0;
	else if (g_iBlockBuy[id] == BUY_EVERYWHERE) g_fBotNextThink[id] = get_gametime() + 0.1;
	else g_iBotBuyWeapon[id] = false;
}

public HAM_TraceAttack_Post(iEntity, iAttacker, Float:flDamage, Float:fDir[3], ptr, iDamageType)
{
	if (!is_user_alive(iAttacker))
	return;

	new iEntity2 = get_pdata_cbase(iAttacker, 373);
	new i = GetWeaponType(iEntity2);
	if (!i)
	return;

	if (g_iWeaponId[iAttacker][i] == CSW_KNIFE)
	return;

	new Float:flEnd[3];
	get_tr2(ptr, TR_vecEndPos, flEnd);
	if (iEntity)
	{
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_DECAL);
		engfunc(EngFunc_WriteCoord, flEnd[0]);
		engfunc(EngFunc_WriteCoord, flEnd[1]);
		engfunc(EngFunc_WriteCoord, flEnd[2]);
		write_byte(GUNSHOT_DECALS[random_num(0, sizeof GUNSHOT_DECALS - 1)]);
		write_short(iEntity);
		message_end();
	}
	else
	{
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_WORLDDECAL);
		engfunc(EngFunc_WriteCoord, flEnd[0]);
		engfunc(EngFunc_WriteCoord, flEnd[1]);
		engfunc(EngFunc_WriteCoord, flEnd[2]);
		write_byte(GUNSHOT_DECALS[random_num(0, sizeof GUNSHOT_DECALS - 1)]);
		message_end();
	}
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_GUNSHOTDECAL);
	engfunc(EngFunc_WriteCoord, flEnd[0]);
	engfunc(EngFunc_WriteCoord, flEnd[1]);
	engfunc(EngFunc_WriteCoord, flEnd[2]);
	write_short(iAttacker);
	write_byte(GUNSHOT_DECALS[random_num(0, sizeof GUNSHOT_DECALS - 1)]);
	message_end();
	flEnd[2] += 5.0;
	FakeSmoke(flEnd);
}

public GiveWeapon(id, szClassName[], i)
{
	new iEntity = 0;
	if (!strcmp(szClassName, "weapon_knife"))
	{
		iEntity = get_pdata_cbase(id, 370);
		if (pev_valid(iEntity))
		{
			new iWeapon = GetWeaponType(iEntity);
			if (i == iWeapon)
			{
				client_print(id, print_center, "#Cstrike_Already_Own_Weapon");
				return 0;
			}
			message_begin(MSG_ONE, get_user_msgid("WeapPickup"), {0,0,0}, id);
			write_byte(CSW_KNIFE);
			message_end();
			engfunc(EngFunc_EmitSound, id, CHAN_AUTO, "items/gunpickup2.wav", VOL_NORM, ATTN_NORM, 0, PITCH_NORM);
			set_pdata_int(iEntity, 11, i, 4);
			return iEntity;
		}
	}
	else if (!strcmp(szClassName, "weapon_hegrenade"))
	{
		if (pev(id, pev_weapons) & (1<<CSW_HEGRENADE))
		{
			client_print(id, print_center, "#Cstrike_TitlesTXT_Cannot_Carry_Anymore");
			return 0;
		}
	}
	iEntity = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, szClassName));
	set_pdata_int(iEntity, 11, i, 4);
	new iSlot = ExecuteHam(Ham_Item_ItemSlot, iEntity);
	new iEntity2 = get_pdata_cbase(id, 365 + iSlot + 2);
	if (iEntity2 > 0)
	{
		new iWeapon = GetWeaponType(iEntity2);
		new szClassName2[32];
		pev(iEntity2, pev_classname, szClassName2, charsmax(szClassName2));
		if (iWeapon == i && i && iWeapon && iSlot != 4 || !i && !iWeapon && !strcmp(szClassName, szClassName2) && iSlot != 4)
		{
			engfunc(EngFunc_RemoveEntity, iEntity);
			client_print(id, print_center, "#Cstrike_Already_Own_Weapon");
			return 0;
		}
		if (iSlot < 3)
		{
			new szClassName2[32];
			pev(iEntity2, pev_classname, szClassName2, charsmax(szClassName2));
			engclient_cmd(id, "drop", szClassName2);
		}
	}
	new Float:fOrigin[3];
	pev(id, pev_origin, fOrigin);
	set_pev(iEntity, pev_origin, fOrigin);
	set_pev(iEntity, pev_spawnflags, SF_NORESPAWN);
	dllfunc(DLLFunc_Spawn, iEntity);
	dllfunc(DLLFunc_Touch, iEntity, id);
	return iEntity;
}

public GetWeaponType(iEntity)
{
	if (!pev_valid(iEntity))
	return 0;

	for (new i = 1; i <= g_iWeaponAmount; i ++) if (get_pdata_int(iEntity, 11, 4) == i) return i;
	return 0;
}

public CheckBuy(id)
{
	if (g_iBlockBuy[id] == BUY_CANNOT)
	return 0;

	if (g_iBlockBuy[id] == BUY_EVERYWHERE && is_user_alive(id))
	return 1;

	if (!is_user_alive(id))
	return 0;

	if (!(get_pdata_int(id, 235) & (1<<0)) && !is_user_bot(id))
	return 0;

	if (is_user_bot(id) && !g_iBotBuyWeapon[id])
	return 0;

	if (get_gametime() > g_flDisableBuyTime)
	{
		new szMessage[8];
		num_to_str(floatround(get_cvar_float("mp_buytime") * 60), szMessage, charsmax(szMessage));
		message_begin(MSG_ONE, get_user_msgid("TextMsg"), {0, 0, 0}, id);
		write_byte((1<<2));
		write_string("#Cant_buy");
		write_string(szMessage);
		message_end();
		return 0;
	}
	return 1;
}

public GivePriAmmo(id, iEntity, WpnId, iMode, iNative, iGiveAmount)
{
	new iMoney, iWeapons, iCost, iAmount, iAmmo, iWeapon, iMaxAmmo;
	iMoney = get_pdata_int(id, 115);
	iWeapons = pev(id, pev_weapons);
	iWeapon = get_pdata_int(iEntity, 43, 4);
	if (WpnId) iAmmo = g_iCurWeaponBPAmmo[id][WpnId];
	else iAmmo = g_iGameCurWeaponBPAmmo[id][iWeapon];
	iMaxAmmo = WpnId? g_iWeaponAmmo[id][WpnId] : g_szGameWeaponMaxBpammo[iWeapon];
	for (new i = 0; i < MAX_PRIM; i ++)
	{
		if (!iMode)
		{
			if (WpnId) iAmount = min(g_iWeaponClip[id][WpnId], 30);
			else iAmount = g_iPrimAmount[i];
		}
		else iAmount = 1;
		if (iGiveAmount) iAmount = iGiveAmount;
		if (WpnId) iCost = g_iWeaponAmmoCost[id][WpnId];
		else iCost = g_iPrimCost[i];
		if (iNative) iCost = 0;
		if (iWeapons & (1<<g_iPrimId[i]) && iMoney >= iCost)
		{
			if (iMode && get_pdata_int(iEntity, 51, 4) >= g_iWeaponAmmo[id][WpnId] && WpnId)
			return 0;

			if (!iMode && iAmmo >= g_iWeaponAmmo[id][WpnId] && WpnId)
			return 0;

			if (!WpnId && iAmmo >= g_szGameWeaponMaxBpammo[iWeapon])
			return 0;

			if (iAmmo + iAmount > iMaxAmmo) iAmount = iMaxAmmo - iAmmo;
			message_begin(MSG_ONE, get_user_msgid("AmmoPickup"), _, id);
			write_byte(g_szGameWeaponAmmoId[iWeapon]);
			write_byte(iAmount);
			message_end();
			engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, "items/9mmclip1.wav", VOL_NORM, ATTN_NORM, (1<<0), PITCH_NORM);
			iAmmo += iAmount;
			iMoney -= iCost;
			if (iMode) set_pdata_int(iEntity, 51, iAmmo, 4);
			if (get_pdata_cbase(id, 373) == iEntity) fm_cs_set_user_bpammo(id, iWeapon, iAmmo);
			if (!WpnId) g_iGameCurWeaponBPAmmo[id][iWeapon] = iAmmo;
			else g_iCurWeaponBPAmmo[id][WpnId] = iAmmo;
			fm_set_user_money(id, iMoney);
			return 1;
		}
	}
	return 0;
}

public GiveSecAmmo(id, iEntity, WpnId, iMode, iNative, iGiveAmount)
{
	new iMoney, iWeapons, iCost, iAmount, iAmmo, iWeapon, iMaxAmmo;
	iMoney = get_pdata_int(id, 115);
	iWeapons = pev(id, pev_weapons);
	iWeapon = get_pdata_int(iEntity, 43, 4);
	if (WpnId) iAmmo = g_iCurWeaponBPAmmo[id][WpnId];
	else iAmmo = g_iGameCurWeaponBPAmmo[id][iWeapon];
	iMaxAmmo = WpnId? g_iWeaponAmmo[id][WpnId] : g_szGameWeaponMaxBpammo[iWeapon];
	for (new i = 0; i < MAX_SEC; i ++)
	{
		if (!iMode)
		{
			if (WpnId) iAmount = min(g_iWeaponClip[id][WpnId], 30);
			else iAmount = g_iSecAmount[i];
		}
		else iAmount = 1;
		if (iGiveAmount) iAmount = iGiveAmount;
		if (WpnId) iCost = g_iWeaponAmmoCost[id][WpnId];
		else iCost = g_iSecondCost[i];
		if (iNative) iCost = 0;
		if (iWeapons & (1<<g_iSecondId[i]) && iMoney >= iCost)
		{
			if (iMode && get_pdata_int(iEntity, 51, 4) >= g_iWeaponAmmo[id][WpnId] && WpnId)
			return 0;

			if (!iMode && iAmmo >= g_iWeaponAmmo[id][WpnId] && WpnId)
			return 0;

			if (!WpnId && iAmmo >= g_szGameWeaponMaxBpammo[iWeapon])
			return 0;

			if (iAmmo + iAmount > iMaxAmmo) iAmount = iMaxAmmo - iAmmo;
			message_begin(MSG_ONE, get_user_msgid("AmmoPickup"), _, id);
			write_byte(g_szGameWeaponAmmoId[iWeapon]);
			write_byte(iAmount);
			message_end();
			engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, "items/9mmclip1.wav", VOL_NORM, ATTN_NORM, (1<<0), PITCH_NORM);
			iAmmo += iAmount;
			iMoney -= iCost;
			if (iMode) set_pdata_int(iEntity, 51, iAmmo, 4);
			if (get_pdata_cbase(id, 373) == iEntity) fm_cs_set_user_bpammo(id, iWeapon, iAmmo);
			if (!WpnId) g_iGameCurWeaponBPAmmo[id][iWeapon] = iAmmo;
			else g_iCurWeaponBPAmmo[id][WpnId] = iAmmo;
			fm_set_user_money(id, iMoney);
			return 1;
		}
	}
	return 0;
}

public ChangeWeaponList(id, iEntity)
{
	if (!pev_valid(iEntity))
	return;

	new i = GetWeaponType(iEntity);
	new WeaponListName[32], WpnId;
	formatex(WeaponListName, charsmax(WeaponListName), "weapon_%s", g_szWeaponList[id][i]);
	if (i) WpnId = g_iWeaponId[id][i];
	else WpnId = get_pdata_int(iEntity, 43, 4);
	message_begin(MSG_ONE, get_user_msgid("WeaponList"), {0,0,0}, id);
	if (i) write_string(WeaponListName);
	else write_string(g_szGameWeaponClassName[WpnId]);
	if (WpnId == CSW_KNIFE)
	{
		write_byte(-1);
		write_byte(-1);
	}
	else if (WpnId == CSW_HEGRENADE)
	{
		write_byte(g_szGameWeaponAmmoId[WpnId]);
		write_byte(g_szGameWeaponMaxBpammo[WpnId]);
	}
	else
	{
		write_byte(g_szGameWeaponAmmoId[WpnId]);
		if (i) write_byte(g_iWeaponAmmo[id][i]);
		else write_byte(g_szGameWeaponMaxBpammo[WpnId]);
	}
	write_byte(-1);
	write_byte(-1);
	write_byte(g_szGameWeaponPosition[WpnId]);
	write_byte(g_szGameWeaponSlot[WpnId]);
	write_byte(WpnId);
	message_end();
}

public ShotgunReload(iEntity, iMaxClip, iClip, iBpAmmo, id, WeaponId)
{
	new i = GetWeaponType(iEntity);
	if (iBpAmmo <= 0 || iMaxClip == iClip)
	return;

	if (get_pdata_float(iEntity, 46, 4) > 0.0)
	return;

	switch (get_pdata_int(iEntity, 55, 4))
	{
		case 0:
		{
			// 开始换弹
			PlayAnim(id, g_iWeaponAnim[id][i][ANIM_START_RELOAD]);
			set_pdata_int(iEntity, 55, 1, 4);
			set_pdata_float(id, 83, g_fWeaponReloadTime[id][i][1]);
			set_pdata_float(iEntity, 46, g_fWeaponReloadTime[id][i][1]);
			set_pdata_float(iEntity, 48, g_fWeaponReloadTime[id][i][1]);
			return;
		}
		case 1:
		{
			if (get_pdata_float(iEntity, 48, 4) > 0.0)
			return;

			// 装弹动作
			set_pdata_int(iEntity, 55, 2, 4);
			PlayAnim(id, g_iWeaponAnim[id][i][ANIM_INSERT]);
			set_pdata_float(iEntity, 46, g_fWeaponReloadTime[id][i][0]);
			set_pdata_float(iEntity, 48, g_fWeaponReloadTime[id][i][0]);
			set_pdata_float(id, 83, g_fWeaponReloadTime[id][i][0]);
		}
		default:
		{
			// 子弹+1
			set_pdata_int(iEntity, 51, iClip + 1, 4);
			fm_cs_set_user_bpammo(id, WeaponId, iBpAmmo - 1);
			g_iCurWeaponBPAmmo[id][i] = iBpAmmo - 1;
			set_pdata_int(iEntity, 55, 1, 4);
		}
	}
}

public KnifeAttack(id, i, style, iEntity)
{
	if (!is_user_alive(id))
	return;

	if (style == 1)
	{
		if (g_iKnifeAnim[id][i][KNIFE_ANIM_SLASHBEGIN])
		{
			PlayAnim(id, g_iKnifeAnim[id][i][KNIFE_ANIM_SLASHBEGIN]);
			set_pdata_float(iEntity, 46, g_fKnifeSlashTime[id][i], 4);
			set_pdata_float(iEntity, 47, g_fKnifeSlashTime[id][i], 4);
			set_pdata_float(iEntity, 48, g_fKnifeSlashTime[id][i], 4);
			set_pdata_float(id, 83, g_fKnifeSlashTime[id][i], 5);
			g_fPlayerThink[id] = get_gametime() + g_fKnifeSlashTime[id][i];
		}
		else
		{
			PlayAnim(id, g_iKnifeAnim[id][i][g_iKnifeSlashMode[id]+1]);
			set_pdata_float(iEntity, 46, g_fKnifeSlashTime[id][i]+g_fKnifeSlashResetTime[id][i], 4);
			set_pdata_float(iEntity, 47, g_fKnifeSlashTime[id][i]+g_fKnifeSlashResetTime[id][i], 4);
			set_pdata_float(iEntity, 48, g_fKnifeSlashTime[id][i]+g_fKnifeSlashResetTime[id][i], 4);
			set_pdata_float(id, 83, g_fKnifeSlashTime[id][i]+g_fKnifeSlashResetTime[id][i], 5);
			g_fPlayerThink[id] = get_gametime() + g_fKnifeSlashTime[id][i];
		}
	}
	else if (style == 2)
	{
		ExecuteForward(g_fwPrimaryAttackEndPre, g_fwDummyResult, iEntity, id, i);
		if (g_fwDummyResult == 1)
		return;

		new Float:fRange = g_fKnifeSlashRange[id][i];
		new Float:fDamage = 15.0 * g_fWeaponDamage[id][i];
		new Float:fAngle = g_fKnifeSlashAngle[id][i];
		new Float:fOrigin[3];
		pev(id, pev_origin, fOrigin);
		new Float:fParam[6];
		fParam[0] = fRange;
		fParam[1] = fAngle;
		fParam[2] = g_fKnifeSlashAngleOffset[id][i];
		fParam[3] = g_fKnifeSlashHeight[id][i];
		fParam[4] = g_fKnifeSlashHeightOffset[id][i];
		fParam[5] = fDamage;
		new hit = CheckAttack(id, 0, iEntity, fParam, fOrigin, fAngle? DMGTYPE_SECTOR : DMGTYPE_LINE, SPDMG_NORMAL);
		if (hit == HIT_EMPTY)
		{
			engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound3[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][1], 0, PITCH_NORM);
			if (g_iKnifeAnim[id][i][KNIFE_ANIM_SLASHBEGIN]) PlayAnim(id, g_iKnifeAnim[id][i][KNIFE_ANIM_MIDSLASH_MISS]);
		}
		if (hit == HIT_PLAYER)
		{
			if (g_iKnifeSlashMode[id]) engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound5[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][3], 0, PITCH_NORM);
			else engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound6[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][4], 0, PITCH_NORM);
			if (g_iKnifeAnim[id][i][KNIFE_ANIM_SLASHBEGIN]) PlayAnim(id, g_iKnifeAnim[id][i][g_iKnifeSlashMode[id]+1]);
		}
		if (hit == HIT_ENTITY || hit == HIT_WALL)
		{
			engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound2[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][0], 0, PITCH_NORM);
			if (g_iKnifeAnim[id][i][KNIFE_ANIM_SLASHBEGIN]) PlayAnim(id, g_iKnifeAnim[id][i][g_iKnifeSlashMode[id]+1]);
		}
		set_pdata_float(iEntity, 46, g_fKnifeSlashResetTime[id][i], 4);
		set_pdata_float(iEntity, 47, g_fKnifeSlashResetTime[id][i], 4);
		set_pdata_float(iEntity, 48, g_fKnifeSlashResetTime[id][i], 4);
		set_pdata_float(id, 83, g_fKnifeSlashResetTime[id][i], 5);
		g_fPlayerThink[id] = get_gametime() + g_fKnifeSlashResetTime[id][i];
		ExecuteForward(g_fwPrimaryAttackEndPost, g_fwDummyResult, iEntity, id, i);
	}
	else if (style == 3)
	{
		if (g_iKnifeAnim[id][i][KNIFE_ANIM_STABBEGIN])
		{
			PlayAnim(id, g_iKnifeAnim[id][i][KNIFE_ANIM_STABBEGIN]);
			set_pdata_float(iEntity, 46, g_fKnifeStabTime[id][i], 4);
			set_pdata_float(iEntity, 47, g_fKnifeStabTime[id][i], 4);
			set_pdata_float(iEntity, 48, g_fKnifeStabTime[id][i], 4);
			set_pdata_float(id, 83, g_fKnifeStabTime[id][i], 5);
			g_fPlayerThink[id] = get_gametime() + g_fKnifeStabTime[id][i];
		}
		else
		{
			PlayAnim(id, g_iKnifeAnim[id][i][KNIFE_ANIM_STAB]);
			set_pdata_float(iEntity, 46, g_fKnifeStabTime[id][i]+g_fKnifeStabResetTime[id][i], 4);
			set_pdata_float(iEntity, 47, g_fKnifeStabTime[id][i]+g_fKnifeStabResetTime[id][i], 4);
			set_pdata_float(iEntity, 48, g_fKnifeStabTime[id][i]+g_fKnifeStabResetTime[id][i], 4);
			set_pdata_float(id, 83, g_fKnifeStabTime[id][i]+g_fKnifeStabResetTime[id][i], 5);
			g_fPlayerThink[id] = get_gametime() + g_fKnifeStabTime[id][i];
		}
	}
	else if (style == 4)
	{
		ExecuteForward(g_fwSecondaryAttackEndPre, g_fwDummyResult, iEntity, id, i);
		if (g_fwDummyResult == 1)
		return;

		new Float:fRange = g_fKnifeStabRange[id][i];
		new Float:fDamage = 65.0 * g_fWeaponDamage2[id][i];
		new Float:fAngle = g_fKnifeStabAngle[id][i];
		new Float:fOrigin[3];
		pev(id, pev_origin, fOrigin);
		new Float:fParam[6];
		fParam[0] = fRange;
		fParam[1] = fAngle;
		fParam[2] = g_fKnifeStabAngleOffset[id][i];
		fParam[3] = g_fKnifeStabHeight[id][i];
		fParam[4] = g_fKnifeStabHeightOffset[id][i];
		fParam[5] = fDamage;
		new hit = CheckAttack(id, 0, iEntity, fParam, fOrigin, fAngle? DMGTYPE_SECTOR : DMGTYPE_LINE, SPDMG_NORMAL);
		if (hit == HIT_EMPTY)
		{
			engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound3[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][1], 0, PITCH_NORM);
			if (g_iKnifeAnim[id][i][KNIFE_ANIM_STABBEGIN]) PlayAnim(id, g_iKnifeAnim[id][i][KNIFE_ANIM_STABMISS]);
		}
		if (hit == HIT_PLAYER)
		{
			engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound4[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][2], 0, PITCH_NORM);
			if (g_iKnifeAnim[id][i][KNIFE_ANIM_STABBEGIN]) PlayAnim(id, g_iKnifeAnim[id][i][KNIFE_ANIM_STAB]);
		}
		if (hit == HIT_ENTITY || hit == HIT_WALL)
		{
			engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szWeaponSound2[id][i], VOL_NORM, g_fKnifeSoundVolume[id][i][0], 0, PITCH_NORM);
			if (g_iKnifeAnim[id][i][KNIFE_ANIM_STABBEGIN]) PlayAnim(id, g_iKnifeAnim[id][i][KNIFE_ANIM_STAB]);
		}
		set_pdata_float(iEntity, 46, g_fKnifeStabResetTime[id][i], 4);
		set_pdata_float(iEntity, 47, g_fKnifeStabResetTime[id][i], 4);
		set_pdata_float(iEntity, 48, g_fKnifeStabResetTime[id][i], 4);
		set_pdata_float(id, 83, g_fKnifeStabResetTime[id][i], 5);
		g_fPlayerThink[id] = get_gametime() + g_fKnifeStabResetTime[id][i];
		ExecuteForward(g_fwSecondaryAttackEndPost, g_fwDummyResult, iEntity, id, i);
	}
}

public CheckAttack(iAttacker, iVictim, iEntity, Float:fParam[6], Float:fOrigin[3], iDamageType, iSpecial)
{
	if (!pev_valid(iAttacker))
	return -1;

	new Float:fTargetOrigin[3], Float:fFraction, iHit, iPtr, szClassName[32], iHitWhat, Float:fHitOrigin[3], iHitGroup, bool:iAttacked[33], Float:fViewOfs[3];
	new Float:fRange = fParam[0];
	new Float:fAngle = fParam[1];
	new Float:fAngleOffset = fParam[2];
	new Float:fHeight = fParam[3];
	new Float:fHeightOffset = fParam[4];
	new Float:fDamage = fParam[5];
	new Float:fDistance = float(floatround(floattan(fAngle / 2.0, degrees) * fRange));
	new iii = floatround(fDistance * 2.0 / fAngleOffset);
	new iiii = floatround(fHeight / fHeightOffset);
	new Float:fCurTime = get_gametime();
	new Float:fRight, Float:fUp;
	new bool:iRight, bool:iUp;
	new iNumber[2];
	pev(iAttacker, pev_view_ofs, fViewOfs);
	xs_vec_add(fOrigin, fViewOfs, fOrigin);
	switch (iDamageType)
	{
		case DMGTYPE_SECTOR:
		{
			for (new ii = 0; ii <= iiii; ii ++)
			{
				iNumber[0] = 0;
				iRight = false;
				iUp = iUp? false : true;
				if (!iUp) iNumber[1] ++;
				for (new i = 0; i <= iii; i ++)
				{
					iRight = iRight? false : true;
					if (!iRight) iNumber[0] ++;
					fRight = (iRight? 1.0 : -1.0) * float(iNumber[0]) * fAngleOffset;
					fUp = (iUp? 1.0 : -1.0) * float(iNumber[1]) * fHeightOffset;
					get_position(iAttacker, fRange, fRight, fUp, fTargetOrigin);
					iPtr = create_tr2();
					engfunc(EngFunc_TraceLine, fOrigin, fTargetOrigin, DONT_IGNORE_MONSTERS, iAttacker, iPtr);
					get_tr2(iPtr, TR_flFraction, fFraction);
					get_tr2(iPtr, TR_vecEndPos, fHitOrigin);
					iHit = get_tr2(iPtr, TR_pHit);
					iHitGroup = get_tr2(iPtr, TR_iHitgroup);
					free_tr2(iPtr);
					if (fFraction >= 1.0 && iHitWhat == HIT_EMPTY) iHitWhat = HIT_EMPTY;
					else
					{
						if (pev_valid(iHit))
						{
							if (is_user_connected(iHit)) iHitWhat = HIT_PLAYER;
							else if (iHitWhat != HIT_PLAYER) iHitWhat = HIT_ENTITY;
							if (pev(iHit, pev_takedamage) <= 0.0)
							continue;

							if (is_user_connected(iHit))
							{
								if (iAttacked[iHit])
								continue;

								iAttacked[iHit] = true;
								ExecuteAttack(iAttacker, iHit, iEntity, fDamage, iHitGroup, iSpecial, iDamageType, fHitOrigin);
							}
							else
							{
								if (get_pdata_float(iHit, 15, 4) == fCurTime)
								continue;

								pev(iHit, pev_classname, szClassName, charsmax(szClassName));
								if (!strcmp(szClassName, "hostage_entity") || !strcmp(szClassName, "monster_scientist"))
								{
									iHitWhat = HIT_PLAYER;
									SpawnBlood(fHitOrigin, g_iBloodColor, floatround(fDamage));
								}
								set_pdata_float(iHit, 15, fCurTime, 4);
								ExecuteHamB(Ham_TakeDamage, iHit, iEntity, iAttacker, fDamage, DMG_NEVERGIB | DMG_BULLET);
							}
						}
						else if (iHitWhat != HIT_PLAYER && iHitWhat != HIT_ENTITY) iHitWhat = HIT_WALL;
					}
				}
			}
		}
		case DMGTYPE_LINE:
		{
			fm_get_aim_origin(iAttacker, fHitOrigin);
			iPtr = create_tr2();
			get_position(iAttacker, fRange, 0.0, 0.0, fTargetOrigin);
			engfunc(EngFunc_TraceLine, fOrigin, fTargetOrigin, DONT_IGNORE_MONSTERS, iAttacker, iPtr);
			iHit = get_tr2(iPtr, TR_pHit);
			iHitGroup = get_tr2(iPtr, TR_iHitgroup);
			get_tr2(iPtr, TR_flFraction, fFraction);
			get_tr2(iPtr, TR_vecEndPos, fHitOrigin);
			free_tr2(iPtr);
			if (fFraction >= 1.0) iHitWhat = HIT_EMPTY;
			else if (!pev_valid(iHit)) iHitWhat = HIT_WALL;
			if (pev_valid(iHit))
			{
				if (is_user_connected(iHit))
				{
					iHitWhat = HIT_PLAYER;
					ExecuteAttack(iAttacker, iHit, iEntity, fDamage, iHitGroup, iSpecial, iDamageType, fHitOrigin);
				}
				else
				{
					iHitWhat = HIT_ENTITY;
					if (pev(iHit, pev_takedamage))
					{
						pev(iHit, pev_classname, szClassName, charsmax(szClassName));
						if (!strcmp(szClassName, "hostage_entity") || !strcmp(szClassName, "monster_scientist"))
						{
							iHitWhat = HIT_PLAYER;
							SpawnBlood(fHitOrigin, g_iBloodColor, floatround(fDamage));
						}
						ExecuteHamB(Ham_TakeDamage, iHit, iEntity, iAttacker, fDamage, DMG_NEVERGIB | DMG_BULLET);
					}
				}
			}
		}
		case DMGTYPE_EXPLOSION:
		{
			while ((iHit = engfunc(EngFunc_FindEntityInSphere, iHit, fOrigin, fRange)) != 0)
			{
				if (!pev_valid(iHit))
				continue;

				if (pev(iHit, pev_solid) <= SOLID_NOT)
				continue;

				pev(iHit, pev_origin, fTargetOrigin);
				if (pev(iHit, pev_takedamage) <= 0.0)
				{
					if (iHitWhat != HIT_PLAYER) iHitWhat = HIT_ENTITY;
					continue;
				}
				if (is_user_connected(iHit))
				{
					iHitWhat = HIT_PLAYER;
					ExecuteAttack(iAttacker, iHit, iEntity, fDamage, iHitGroup, iSpecial, iDamageType, fOrigin);
				}
				else
				{
					iHitWhat = HIT_ENTITY;
					pev(iHit, pev_classname, szClassName, charsmax(szClassName));
					if (!strcmp(szClassName, "hostage_entity") || !strcmp(szClassName, "monster_scientist")) iHitWhat = HIT_PLAYER;
					ExecuteHamB(Ham_TakeDamage, iHit, iEntity, iAttacker, fDamage, DMG_NEVERGIB | DMG_BULLET);
				}
			}
		}
		case DMGTYPE_TOUCH:
		{
			iHit = iVictim;
			if (pev_valid(iHit))
			{
				if (is_user_connected(iHit))
				{
					iHitWhat = HIT_PLAYER;
					ExecuteAttack(iAttacker, iHit, iEntity, fDamage, iHitGroup, iSpecial, iDamageType, fOrigin);
				}
				else
				{
					iHitWhat = HIT_ENTITY;
					pev(iHit, pev_classname, szClassName, charsmax(szClassName));
					if (!strcmp(szClassName, "hostage_entity") || !strcmp(szClassName, "monster_scientist"))
					{
						iHitWhat = HIT_PLAYER;
						SpawnBlood(fOrigin, g_iBloodColor, floatround(fDamage));
					}
					ExecuteHamB(Ham_TakeDamage, iHit, iEntity, iAttacker, fDamage, DMG_NEVERGIB | DMG_BULLET);
				}
			}
			else iHitWhat = HIT_WALL;
		}
	}
	return iHitWhat;
}

public ExecuteAttack(iAttacker, iVictim, iEntity, Float:fDamage, iHitGroup, iSpecial, iDamageType, Float:fOrigin[3])
{
	if (pev(iVictim, pev_takedamage) <= 0.0)
	return 0;

	new iHit = iHitGroup;
	if (iSpecial & SPDMG_CANTHEADSHOT && iHit == HIT_HEAD) iHit = HIT_STOMACH;
	if (is_user_connected(iAttacker) && !(iSpecial & SPDMG_TEAMATTACK) && get_pdata_int(iAttacker, 114, 5) == get_pdata_int(iVictim, 114, 5) && !get_cvar_num("mp_friendlyfire"))
	return 0;

	if (iDamageType == DMGTYPE_SECTOR || iDamageType == DMGTYPE_LINE)
	{
		if (is_user_connected(iAttacker) && g_iAttackHitGroup[iAttacker]) iHit = g_iAttackHitGroup[iAttacker];
		switch (iHit)
		{
			case HIT_HEAD: fDamage *= 4.0;
			case HIT_STOMACH, HIT_CHEST: fDamage *= 1.5;
			case HIT_RIGHTARM, HIT_LEFTARM: fDamage *= 1.0;
			case HIT_RIGHTLEG, HIT_LEFTLEG: fDamage *= 0.75;
		}
		SpawnBlood(fOrigin, g_iBloodColor, floatround(fDamage));
	}
	set_pdata_int(iVictim, 75, iHit);
	ExecuteHamB(Ham_TakeDamage, iVictim, iEntity, iAttacker, fDamage, DMG_NEVERGIB | DMG_BULLET);
	return 1;
}

public BeginOpening(iEntity)
{
	new id = get_pdata_cbase(iEntity, 41, 4);
	new i = GetWeaponType(iEntity);
	set_pdata_float(iEntity, 46, g_fSightOpenTime[id][i], 4);
	set_pdata_float(iEntity, 47, g_fSightOpenTime[id][i], 4);
	set_pdata_float(iEntity, 48, g_fSightOpenTime[id][i], 4);
	SightMode[id] = ATOB;
	PlayAnim(id, g_iWeaponAnim[id][i][ANIM_SIGHT_OPEN]);
	set_pdata_int(id, 361, get_pdata_int(id, 361) | (1<<6), 5);
}

public BeginClosing(iEntity)
{
	new id = get_pdata_cbase(iEntity, 41, 4);
	new i = GetWeaponType(iEntity);
	set_pdata_float(iEntity, 46, g_fSightCloseTime[id][i], 4);
	set_pdata_float(iEntity, 47, g_fSightCloseTime[id][i], 4);
	set_pdata_float(iEntity, 48, g_fSightCloseTime[id][i], 4);
	set_pev(id, pev_viewmodel2, g_szWeaponVModel[id][i]);
	SightMode[id] = BTOA;
	PlayAnim(id, g_iWeaponAnim[id][i][ANIM_SIGHT_CLOSE]);
	set_pdata_int(id, 361, get_pdata_int(id, 361) &~ (1<<6), 5);
}

public OpeningEnd(iEntity)
{
	new id = get_pdata_cbase(iEntity, 41, 4);
	new i = GetWeaponType(iEntity);
	if (g_fSightDistance[id][i]) set_pdata_int(id, 363, floatround(g_fSightDistance[id][i]), 5);
	set_pev(id, pev_viewmodel2, g_szWeaponVModelS[id][i]);
	SightMode[id] = OPEN;
	PlayAnim(id, g_iWeaponAnim[id][i][ANIM_IDLE]);
}

public ClosingEnd(iEntity)
{
	new id = get_pdata_cbase(iEntity, 41, 4);
	new i = GetWeaponType(iEntity);
	set_pdata_int(id, 361, get_pdata_int(id, 361) &~ (1<<6), 5);
	set_pdata_int(id, 363, 90, 5);
	SightMode[id] = CLOSED;
	set_pev(id, pev_viewmodel2, g_szWeaponVModel[id][i]);
	PlayAnim(id, g_iWeaponAnim[id][i][ANIM_IDLE]);
	if (!Reload[id])
	return;

	Reload[id] = false;
	ExecuteHamB(Ham_Weapon_Reload, iEntity);
}

public FakeSmoke(Float:flEnd[3])
{
	new iEntity = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"));
	set_pev(iEntity, pev_movetype, MOVETYPE_FLY);
	set_pev(iEntity, pev_rendermode, kRenderTransAdd);
	set_pev(iEntity, pev_renderamt, 64.0);
	set_pev(iEntity, pev_rendercolor, { 128.0, 128.0, 128.0 });
	set_pev(iEntity, pev_scale, 0.5);
	set_pev(iEntity, pev_nextthink, get_gametime() + 0.05);
	set_pev(iEntity, pev_classname, "gunsmoke1");
	set_pev(iEntity, pev_modelindex, g_iSmokeId);
	set_pev(iEntity, pev_mins, Float:{-1.0, -1.0, -1.0});
	set_pev(iEntity, pev_maxs, Float:{1.0, 1.0, 1.0});
	set_pev(iEntity, pev_origin, flEnd);
	set_pev(iEntity, pev_gravity, 0.01);
	set_pev(iEntity, pev_solid, SOLID_TRIGGER);
	set_pev(iEntity, pev_frame, 0.0);
	new iNum = random_num(0, 1);
	new Float:X, Float:Y, Float:fVelocity[3];
	if (iNum)
	{
		X = random_float(10.0, 20.0);
		Y = random_float(10.0, 20.0);
	}
	else
	{
		X = random_float(-20.0, -10.0);
		Y = random_float(-20.0, -10.0);
	}
	xs_vec_set(fVelocity, X, Y, 50.0);
	set_pev(iEntity, pev_iuser1, iNum);
	set_pev(iEntity, pev_velocity, fVelocity);
}

public BotBuyWeaponEvent(id)
{
	if (!is_user_alive(id))
	return;

	if (!is_user_bot(id))
	return;

	if (g_iBotBuyWeapon[id])
	{
		new iEntity;
		g_iBotMoney[id] += get_pdata_int(id, 115, 5);
		if (g_iBotMoney[id] > g_iMaxMoney) g_iBotMoney[id] = g_iMaxMoney;
		fm_set_user_money(id, 0);
		ExecuteForward(g_fwBotBuyWeapon, g_fwDummyResult, id);
		if (g_fwDummyResult == 1)
		{
			g_iBotBuyWeapon[id] = false;
			return;
		}
		new iWeaponID[4][MAXWEAPON], iSlot[4], iWeapon[2], iSpecialWeapon[2];
		new szWeaponName[3][32] = { "weapon_hegrenade", "weapon_smokegrenade", "weapon_flashbang" };
		new iWeaponId[3] = { CSW_HEGRENADE, CSW_SMOKEGRENADE, CSW_FLASHBANG };
		new iWeaponCost[3] = { 300, 300, 200 };
		for (new i = 0; i < 2; i ++)
		{
			iEntity = get_pdata_cbase(id, 368 + i);
			if (pev_valid(iEntity)) iWeapon[i] = get_pdata_int(iEntity, 11, 4);
		}
		if (g_iBotMoney[id] >= 1000)
		{
			iSpecialWeapon[1] = SW_VESTHELM;
			iSpecialWeapon[0] = 0;
			ExecuteForward(g_fwBotBuyWeaponPost, g_fwDummyResult, id, iSpecialWeapon[0], iSpecialWeapon[1]);
			if (g_fwDummyResult != 1 && CheckBuy(id))
			{
				g_iBotMoney[id] -= 1000;
				set_pev(id, pev_armorvalue, 100.0);
				set_pdata_int(id, 112, 2);
				message_begin(MSG_ONE, get_user_msgid("ArmorType"), {0,0,0}, id);
				write_byte(1);
				message_end();
				engfunc(EngFunc_EmitSound, id, CHAN_ITEM, "items/ammopickup2.wav", VOL_NORM, ATTN_NORM, (1<<0), PITCH_NORM);
			}
		}
		if (g_iBotMoney[id] >= 200 && get_pdata_int(id, 114, 5) == 2)
		{
			iSpecialWeapon[1] = SW_DEFUSER;
			iSpecialWeapon[0] = 0;
			ExecuteForward(g_fwBotBuyWeaponPost, g_fwDummyResult, id, iSpecialWeapon[0], iSpecialWeapon[1]);
			new iEntity = -1, bool:iCanBuy;
			while ((iEntity = engfunc(EngFunc_FindEntityByString, iEntity, "classname", "func_bomb_target"))) iCanBuy = true;
			if (g_fwDummyResult != 1 && iCanBuy && CheckBuy(id))
			{
				set_pev(id, pev_body, 1);
				new iDefuseKitSkill = get_pdata_int(id, 193);
				if (!(iDefuseKitSkill & (1<<16)))
				{
					iDefuseKitSkill |= (1<<16);
					set_pdata_int(id, 193, iDefuseKitSkill);
					message_begin(MSG_ONE, get_user_msgid("StatusIcon"), {0,0,0}, id);
					write_byte(1);
					write_string("defuser");
					write_byte(0);
					write_byte(160);
					write_byte(0);
					message_end();
					g_iBotMoney[id] -= 200;
					engfunc(EngFunc_EmitSound, id, CHAN_AUTO, "items/gunpickup2.wav", VOL_NORM, ATTN_NORM, 0, PITCH_NORM);
				}
			}
		}
		for (new j = 0; j < 4; j ++)
		{
			for (new i = 1; i < MAXWEAPON; i ++)
			{
				if (i > g_iWeaponAmount)
				{
					if (iSlot[j])
					{
						new WpnId = iWeaponID[j][random_num(1, iSlot[j])];
						iSpecialWeapon[1] = 0;
						iSpecialWeapon[0] = WpnId;
						if (j == 3) iSpecialWeapon[1] = SW_HEGRENADE;
						ExecuteForward(g_fwBotBuyWeaponPost, g_fwDummyResult, id, iSpecialWeapon[0], iSpecialWeapon[1]);
						if (g_fwDummyResult != 1)
						{
							Native_GiveWeapon(id, WpnId);
							g_iBotMoney[id] -= g_iWeaponCost[id][WpnId];
							if (j < 2) fm_cs_set_user_bpammo(id, g_iWeaponId[id][WpnId], g_iWeaponAmmo[id][WpnId]);
						}
					}
					break;
				}
				if (!strcmp(g_szWeaponBuyCommand[id][i], EMPTY_COMMAND))
				continue;

				if (!CheckBuy(id))
				continue;

				if (get_pdata_int(id, 114, 5) != g_iWeaponTeam[id][i] && g_iWeaponTeam[id][i])
				continue;

				if (g_iBotMoney[id] < g_iWeaponCost[id][i])
				continue;

				if ( j == 0 && iWeapon[0] || j == 1 && iWeapon[1])
				continue;

				if (GetWeaponSlot(id, i, j + 1))
				{
					iSlot[j] ++;
					iWeaponID[j][iSlot[j]] = i;
				}
			}
		}
		for (new i = 0; i < 3; i ++)
		{
			if (g_iBotMoney[id] >= iWeaponCost[i])
			{
				if (pev(id, pev_weapons) & (1<<iWeaponId[i]))
				continue;

				if (!CheckBuy(id))
				continue;

				iSpecialWeapon[1] = SW_HEGRENADE + i;
				iSpecialWeapon[0] = 0;
				ExecuteForward(g_fwBotBuyWeaponPost, g_fwDummyResult, id, iSpecialWeapon[0], iSpecialWeapon[1]);
				if (g_fwDummyResult != 1)
				{
					GiveWeapon(id, szWeaponName[i], 0);
					g_iBotMoney[id] -= iWeaponCost[i];
				}
			}
		}
		if (!iSlot[0] && !iSlot[1] && !iWeapon[0] && !iWeapon[1])
		{
			fm_set_user_money(id, g_iBotMoney[id]);
			g_iBotMoney[id] = 0;
		}
		g_iBotBuyWeapon[id] = false;
	}
}

stock GetWeaponSlot(id, WpnID, slot)
{
	if (slot == 1) for (new i = 0; i < MAX_PRIM; i ++) if (g_iWeaponId[id][WpnID] == g_iPrimId[i]) return 1;
	if (slot == 2) for (new i = 0; i < MAX_SEC; i ++) if (g_iWeaponId[id][WpnID] == g_iSecondId[i]) return 1;
	if (slot == 3) if (g_iWeaponId[id][WpnID] == CSW_KNIFE) return 1;
	if (slot == 4) if (g_iWeaponId[id][WpnID] == CSW_HEGRENADE) return 1;
	return 0;
}

stock fm_set_user_money(id, iMoney, iFlash = 1)
{
	iMoney = min(iMoney, g_iMaxMoney);
	set_pdata_int(id, 115, iMoney, 5);
	message_begin(MSG_ONE, get_user_msgid("Money"), {0,0,0}, id);
	write_long(iMoney);
	write_byte(iFlash);
	message_end();
}

stock fm_cs_set_user_bpammo(id, iWeaponID, iAmount)
{
	new iOffset;
	switch (iWeaponID)
	{
		case CSW_AWP: iOffset = 377;
		case CSW_SCOUT, CSW_AK47, CSW_G3SG1: iOffset = 378;
		case CSW_M249: iOffset = 379;
		case CSW_M4A1, CSW_FAMAS, CSW_AUG, CSW_SG550, CSW_GALI, CSW_SG552: iOffset = 380;
		case CSW_M3,CSW_XM1014: iOffset = 381;
		case CSW_USP, CSW_UMP45, CSW_MAC10: iOffset = 382;
		case CSW_FIVESEVEN, CSW_P90: iOffset = 383;
		case CSW_DEAGLE: iOffset = 384;
		case CSW_P228: iOffset = 385;
		case CSW_GLOCK18, CSW_MP5NAVY, CSW_TMP, CSW_ELITE: iOffset = 386;
		case CSW_FLASHBANG: iOffset = 387;
		case CSW_HEGRENADE: iOffset = 388;
		case CSW_SMOKEGRENADE: iOffset = 389;
		case CSW_C4: iOffset = 390;
		default:
		{
			log_error(AMX_ERR_NATIVE, "Invalid weapon id %d", iWeaponID);
			return 0;
		}
	}
	return set_pdata_int(id, iOffset, iAmount);
}

stock fm_cs_get_user_bpammo(id, iWeaponID)
{
	new iOffset;
	switch (iWeaponID)
	{
		case CSW_AWP: iOffset = 377;
		case CSW_SCOUT, CSW_AK47, CSW_G3SG1: iOffset = 378;
		case CSW_M249: iOffset = 379;
		case CSW_M4A1, CSW_FAMAS, CSW_AUG, CSW_SG550, CSW_GALI, CSW_SG552: iOffset = 380;
		case CSW_M3,CSW_XM1014: iOffset = 381;
		case CSW_USP, CSW_UMP45, CSW_MAC10: iOffset = 382;
		case CSW_FIVESEVEN, CSW_P90: iOffset = 383;
		case CSW_DEAGLE: iOffset = 384;
		case CSW_P228: iOffset = 385;
		case CSW_GLOCK18, CSW_MP5NAVY, CSW_TMP, CSW_ELITE: iOffset = 386;
		case CSW_FLASHBANG: iOffset = 387;
		case CSW_HEGRENADE: iOffset = 388;
		case CSW_SMOKEGRENADE: iOffset = 389;
		case CSW_C4: iOffset = 390;
		default:
		{
			log_error(AMX_ERR_NATIVE, "Invalid weapon id %d", iWeaponID);
			return 0;
		}
	}
	return get_pdata_int(id, iOffset);
}

stock fm_cs_get_user_zoom(id)
{
	if (!is_user_connected(id))
	return 0;

	new iValue = get_pdata_int(id, 363);
	switch (iValue)
	{
		case 0x5A: return 1;
		case 0x28: return 2;
		case 0xF: return 3;
		case 0xA: return 3;
		case 0x37: return 4;
	}
	return 0;
}

stock PlayAnim(id, anim)
{
	set_pev(id, pev_weaponanim, anim);
	message_begin(MSG_ONE, SVC_WEAPONANIM, {0, 0, 0}, id);
	write_byte(anim);
	write_byte(pev(id, pev_body));
	message_end();
}

stock SpawnBlood(const Float:vecOrigin[3], iColor, iAmount)
{
	if (iAmount == 0)
	return;

	if (!iColor)
	return;

	ExecuteForward(g_fwSpawnBlood, g_fwDummyResult, iColor);
	if (g_fwDummyResult == 1)
	return;

	iAmount *= 2;
	if (iAmount > 255) iAmount = 255;
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vecOrigin);
	write_byte(TE_BLOODSPRITE);
	engfunc(EngFunc_WriteCoord, vecOrigin[0]);
	engfunc(EngFunc_WriteCoord, vecOrigin[1]);
	engfunc(EngFunc_WriteCoord, vecOrigin[2]);
	write_short(spr_blood_spray);
	write_short(spr_blood_drop);
	write_byte(iColor);
	write_byte(min(max(3, iAmount / 10), 16));
	message_end();
}

stock fm_get_aim_origin(id, Float:origin[3])
{
	new Float:start[3], Float:view_ofs[3], Float:dest[3];
	pev(id, pev_origin, start);
	pev(id, pev_view_ofs, view_ofs);
	xs_vec_add(start, view_ofs, start);
	pev(id, pev_v_angle, dest);
	engfunc(EngFunc_MakeVectors, dest);
	global_get(glb_v_forward, dest);
	xs_vec_mul_scalar(dest, 9999.0, dest);
	xs_vec_add(start, dest, dest);
	engfunc(EngFunc_TraceLine, start, dest, 0, id, 0);
	get_tr2(0, TR_vecEndPos, origin);
	return 1;
}

stock get_position(id, Float:forw, Float:right, Float:up, Float:vStart[])
{
	new Float:vOrigin[3], Float:vAngle[3], Float:vForward[3], Float:vRight[3], Float:vUp[3];
	pev(id, pev_origin, vOrigin);
	pev(id, pev_view_ofs, vUp);
	xs_vec_add(vOrigin, vUp, vOrigin);
	pev(id, pev_v_angle, vAngle);
	angle_vector(vAngle, ANGLEVECTOR_FORWARD, vForward);
	angle_vector(vAngle, ANGLEVECTOR_RIGHT, vRight);
	angle_vector(vAngle, ANGLEVECTOR_UP, vUp);
	vStart[0] = vOrigin[0] + vForward[0] * forw + vRight[0] * right + vUp[0] * up;
	vStart[1] = vOrigin[1] + vForward[1] * forw + vRight[1] * right + vUp[1] * up;
	vStart[2] = vOrigin[2] + vForward[2] * forw + vRight[2] * right + vUp[2] * up;
}

stock GetVelocityFromOrigin(Float:origin1[3], Float:origin2[3], Float:speed, Float:velocity[3])
{
	xs_vec_sub(origin1, origin2, velocity);
	new Float:valve = get_distance_f(origin1, origin2)/speed;
	xs_vec_div_scalar(velocity, valve, velocity);
}

stock weapon_str_to_csw(szWeaponName[])
{
	if (!strcmp(szWeaponName, "CSW_AWP")) return CSW_AWP;
	else if (!strcmp(szWeaponName, "CSW_SCOUT")) return CSW_SCOUT;
	else if (!strcmp(szWeaponName, "CSW_SG550")) return CSW_SG550;
	else if (!strcmp(szWeaponName, "CSW_G3SG1")) return CSW_G3SG1;
	else if (!strcmp(szWeaponName, "CSW_AK47")) return CSW_AK47;
	else if (!strcmp(szWeaponName, "CSW_M4A1")) return CSW_M4A1;
	else if (!strcmp(szWeaponName, "CSW_XM1014")) return CSW_XM1014;
	else if (!strcmp(szWeaponName, "CSW_MAC10")) return CSW_MAC10;
	else if (!strcmp(szWeaponName, "CSW_AUG")) return CSW_AUG;
	else if (!strcmp(szWeaponName, "CSW_UMP45")) return CSW_UMP45;
	else if (!strcmp(szWeaponName, "CSW_GALIL")) return CSW_GALIL;
	else if (!strcmp(szWeaponName, "CSW_FAMAS")) return CSW_FAMAS;
	else if (!strcmp(szWeaponName, "CSW_MP5NAVY")) return CSW_MP5NAVY;
	else if (!strcmp(szWeaponName, "CSW_MP5")) return CSW_MP5NAVY;
	else if (!strcmp(szWeaponName, "CSW_M249")) return CSW_M249;
	else if (!strcmp(szWeaponName, "CSW_M3")) return CSW_M3;
	else if (!strcmp(szWeaponName, "CSW_TMP")) return CSW_TMP;
	else if (!strcmp(szWeaponName, "CSW_SG552")) return CSW_SG552;
	else if (!strcmp(szWeaponName, "CSW_P90")) return CSW_P90;
	else if (!strcmp(szWeaponName, "CSW_DEAGLE")) return CSW_DEAGLE;
	else if (!strcmp(szWeaponName, "CSW_USP")) return CSW_USP;
	else if (!strcmp(szWeaponName, "CSW_USP45")) return CSW_USP;
	else if (!strcmp(szWeaponName, "CSW_GLOCK18")) return CSW_GLOCK18;
	else if (!strcmp(szWeaponName, "CSW_GLOCK")) return CSW_GLOCK18;
	else if (!strcmp(szWeaponName, "CSW_ELITE")) return CSW_ELITE;
	else if (!strcmp(szWeaponName, "CSW_FIVESEVEN")) return CSW_FIVESEVEN;
	else if (!strcmp(szWeaponName, "CSW_P228")) return CSW_P228;
	return 0;
}