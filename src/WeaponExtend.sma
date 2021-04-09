/* Amxx编写头版 来自 Aperture Science Team【光圈科技战队】 */

/**
 * 武器伤害值
 * 攻击方式
 * 1.飞行道具：
	抛射物模型（路径，可使用spr或者mdl）
	抛射物播放速率
	抛射物缩放
	抛射物亮度
	抛射物重力（小数，0.0 ~ 1.0）
	飞行速度
	飞行高度修正（Z轴初速度）
	伤害类型
		1. 碰撞爆炸
		2. 延迟爆炸
		3. 碰撞伤害
		4. 范围碰撞伤害
	爆炸SPR
	爆炸SPR播放速率（0.0 ~ 1.0）
	爆炸SPR缩放（0.0 ~ 1.0）
	爆炸SPR高度修正
	爆炸声音（0. 关闭，1. 自定义爆炸声音，2. 默认爆炸声音）
	爆炸声音路径
	爆炸特效（1或0，是否开启原版的爆炸特效，比如火花，黑烟，亮光，地上的黑洞）
	伤害半径
	存在时间（单位秒，0为不限飞行时间）
	延迟时间（单位秒）
	抛射物拖尾（1或0）
	抛射物拖尾颜色R
	抛射物拖尾颜色G
	抛射物拖尾颜色B
	抛射物拖尾透明度
	拖尾间隔SPR（路径，类似RPG火箭拖尾的白烟，不添加该属性即为关闭该功能）
	拖尾间隔时间（单位秒）
	拖尾间隔SPR播放速率（0.0 ~ 1.0）
	拖尾间隔SPR缩放（0.0 ~ 1.0）
	拖尾间隔SPR高度修正
	追踪模式（0. 关闭追踪，1. 准星追踪，2. 自动追踪敌人）
	追踪检测距离
	抛射物附带SPR（路径，不添加该属性即为关闭该功能）
	抛射物附带SPR播放速率（0.0 ~ 1.0）
	抛射物附带SPR缩放（0.0 ~ 1.0）
	抛射物发光（1或0）
	抛射物发光半径
	抛射物发光颜色R
	抛射物发光颜色G
	抛射物发光颜色B
 * 2. 范围攻击
	伤害半径
	伤害距离
	
 */

/**
 * 抛射物：
 * iuser1：保存被伤害过的玩家
 * iuser2：抛射物类型
 * iuser3：总帧数
 * iuser4：额外的SPR实体
 * 额外的SPR实体：
 * iuser1：总帧数
 */

#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>
#include <newweapon>
#include <offset>
#include <xs>

#pragma semicolon 1

#define PLUGINNAME		"Weapon Extend Template"
#define VERSION			"2.2"
#define AUTHOR			"Izayoi Fly"

#define WEAPON_ID		ammo_buckshot

#define WPNTYPE_PROJECTILE	1
#define WPNTYPE_AOE_DAMAGE	2

#define PROJECTILE_MODEL	1
#define PROJECTILE_SPRITE	2

#define DAMAGETYPE_TOUCH_EXP	1
#define DAMAGETYPE_DELAY_EXP	2
#define DAMAGETYPE_TOUCH	3
#define DAMAGETYPE_AOE_TOUCH	4

#define DMGSOUND_NONE		0
#define DMGSOUND_CUSTOM		1
#define DMGSOUND_DEFAULT	2

#define TRACEMODE_NONE		0
#define TRACEMODE_AIM		1
#define TRACEMODE_AUTO		2

#define WPN_PROJECTILE_NAME	"wpn_projectile"
#define WPN_PROJECTILE_EXTRA	"wpn_projectile_extra"

new g_iInfoTarget;
new g_iEnvSprite;
new g_sprBeamFollow;

new g_iWeaponAttackMode[33][MAXWEAPON];			// 攻击方式
new g_iWeaponDamageType[33][MAXWEAPON];			// 伤害类型
new g_iProjectileExplodeSprite[33][MAXWEAPON];		// 爆炸SPR
new g_iProjectileExplodeSound[33][MAXWEAPON];		// 爆炸声音
new g_iProjectileExplodeEffect[33][MAXWEAPON];		// 爆炸特效
new g_iProjectileHasTail[33][MAXWEAPON];		// 抛射物拖尾
new g_iProjectileTailColor[33][MAXWEAPON][4];		// 抛射物拖尾颜色
new g_iProjectileTailSprite[33][MAXWEAPON];		// 拖尾间隔SPR
new g_iProjectileTraceMode[33][MAXWEAPON];		// 追踪模式
new g_iProjectileGlow[33][MAXWEAPON];			// 抛射物发光
new g_iProjectileGlowColor[33][MAXWEAPON][3];		// 抛射物发光颜色
new g_iProjectileGlowRadius[33][MAXWEAPON];		// 抛射物发光半径
new Float:g_fWeaponDamage[33][MAXWEAPON];		// 武器伤害值
new Float:g_fProjectileFramerate[33][MAXWEAPON];	// 抛射物播放速率
new Float:g_fProjectileScale[33][MAXWEAPON];		// 抛射物缩放
new Float:g_fProjectileBrightness[33][MAXWEAPON];	// 抛射物亮度
new Float:g_fProjectileGravity[33][MAXWEAPON];		// 抛射物重力
new Float:g_fProjectileFlySpeed[33][MAXWEAPON];		// 飞行速度
new Float:g_fProjectileHeightOfs[33][MAXWEAPON];	// 飞行高度修正
new Float:g_fProjectileExpFramerate[33][MAXWEAPON];	// 爆炸SPR播放速率
new Float:g_fProjectileExpScale[33][MAXWEAPON];		// 爆炸SPR缩放
new Float:g_fProjectileExpHeightOfs[33][MAXWEAPON];	// 爆炸SPR高度修正
new Float:g_fProjectileDamageRadius[33][MAXWEAPON];	// 伤害半径
new Float:g_fProjectileDuration[33][MAXWEAPON];		// 存在时间
new Float:g_fProjectileDelay[33][MAXWEAPON];		// 延迟时间
new Float:g_fProjectileTailTime[33][MAXWEAPON];		// 拖尾间隔时间
new Float:g_fProjectileTailFramerate[33][MAXWEAPON];	// 拖尾间隔SPR播放速率
new Float:g_fProjectileTailScale[33][MAXWEAPON];	// 拖尾间隔SPR缩放
new Float:g_fProjectileTailHeightOfs[33][MAXWEAPON];	// 拖尾间隔SPR高度修正
new Float:g_fProjectileTraceRadius[33][MAXWEAPON];	// 追踪检测距离
new Float:g_fExtraSpriteFramerate[33][MAXWEAPON];	// 抛射物附带SPR播放速率
new Float:g_fExtraSpriteScale[33][MAXWEAPON];		// 抛射物附带SPR缩放
new g_szProjectileModel[33][MAXWEAPON][64];		// 抛射物模型
new g_szProjectileExplodeSound[33][MAXWEAPON][64];	// 爆炸声音路径
new g_szProjectileExtraSprite[33][MAXWEAPON][64];	// 抛射物附带SPR

public plugin_init()
{
	register_plugin(PLUGINNAME, VERSION, AUTHOR);
	register_event("HLTV", "Event_RoundStart", "a", "1=0", "2=0");
	register_forward(FM_Think, "fw_Think_Post", 1);
	register_forward(FM_Touch, "fw_Touch_Post", 1);
	g_iInfoTarget = engfunc(EngFunc_AllocString, "info_target");
	g_iEnvSprite = engfunc(EngFunc_AllocString, "env_sprite");
	WPN_SetParamInt(0, 1, wpn_SetBuy, BUY_EVERYWHERE);
}

public WPN_LoadFiles(iSlot, i, key[], value[])
{
	g_sprBeamFollow = engfunc(EngFunc_PrecacheModel, "sprites/laserbeam.spr");

	if (!strcmp(key, "攻击方式")) for (new id = 1; id < 33; id ++) g_iWeaponAttackMode[id][i] = str_to_num(value);
	else if (!strcmp(key, "武器伤害值")) for (new id = 1; id < 33; id ++) g_fWeaponDamage[id][i] = str_to_float(value);
	else if (!strcmp(key, "抛射物模型"))
	{
		for (new id = 1; id < 33; id ++) copy(g_szProjectileModel[id][i], charsmax(g_szProjectileModel[][]), value);
		engfunc(EngFunc_PrecacheModel, value);
	}
	else if (!strcmp(key, "抛射物播放速率")) for (new id = 1; id < 33; id ++) g_fProjectileFramerate[id][i] = str_to_float(value);
	else if (!strcmp(key, "抛射物缩放")) for (new id = 1; id < 33; id ++) g_fProjectileScale[id][i] = str_to_float(value);
	else if (!strcmp(key, "抛射物亮度")) for (new id = 1; id < 33; id ++) g_fProjectileBrightness[id][i] = str_to_float(value);
	else if (!strcmp(key, "抛射物重力")) for (new id = 1; id < 33; id ++) g_fProjectileGravity[id][i] = str_to_float(value);
	else if (!strcmp(key, "飞行速度")) for (new id = 1; id < 33; id ++) g_fProjectileFlySpeed[id][i] = str_to_float(value);
	else if (!strcmp(key, "飞行高度修正")) for (new id = 1; id < 33; id ++) g_fProjectileHeightOfs[id][i] = str_to_float(value);
	else if (!strcmp(key, "伤害类型")) for (new id = 1; id < 33; id ++) g_iWeaponDamageType[id][i] = str_to_num(value);
	else if (!strcmp(key, "爆炸SPR"))
	{	
		new iSprite = engfunc(EngFunc_PrecacheModel, value);
		for (new id = 1; id < 33; id ++) g_iProjectileExplodeSprite[id][i] = iSprite;
	}
	else if (!strcmp(key, "爆炸SPR播放速率")) for (new id = 1; id < 33; id ++) g_fProjectileExpFramerate[id][i] = str_to_float(value);
	else if (!strcmp(key, "爆炸SPR缩放")) for (new id = 1; id < 33; id ++) g_fProjectileExpScale[id][i] = str_to_float(value);
	else if (!strcmp(key, "爆炸SPR高度修正")) for (new id = 1; id < 33; id ++) g_fProjectileExpHeightOfs[id][i] = str_to_float(value);
	else if (!strcmp(key, "爆炸声音")) for (new id = 1; id < 33; id ++) g_iProjectileExplodeSound[id][i] = str_to_num(value);
	else if (!strcmp(key, "爆炸声音路径"))
	{
		for (new id = 1; id < 33; id ++) copy(g_szProjectileExplodeSound[id][i], charsmax(g_szProjectileExplodeSound[][]), value);
		engfunc(EngFunc_PrecacheSound, value);
	}
	else if (!strcmp(key, "爆炸特效")) for (new id = 1; id < 33; id ++) g_iProjectileExplodeEffect[id][i] = str_to_num(value);
	else if (!strcmp(key, "伤害半径")) for (new id = 1; id < 33; id ++) g_fProjectileDamageRadius[id][i] = str_to_float(value);
	else if (!strcmp(key, "存在时间")) for (new id = 1; id < 33; id ++) g_fProjectileDuration[id][i] = str_to_float(value);
	else if (!strcmp(key, "延迟时间")) for (new id = 1; id < 33; id ++) g_fProjectileDelay[id][i] = str_to_float(value);
	else if (!strcmp(key, "抛射物拖尾")) for (new id = 1; id < 33; id ++) g_iProjectileHasTail[id][i] = str_to_num(value);
	else if (!strcmp(key, "抛射物拖尾颜色R")) for (new id = 1; id < 33; id ++) g_iProjectileTailColor[id][i][0] = str_to_num(value);
	else if (!strcmp(key, "抛射物拖尾颜色G")) for (new id = 1; id < 33; id ++) g_iProjectileTailColor[id][i][1] = str_to_num(value);
	else if (!strcmp(key, "抛射物拖尾颜色B")) for (new id = 1; id < 33; id ++) g_iProjectileTailColor[id][i][2] = str_to_num(value);
	else if (!strcmp(key, "抛射物拖尾透明度")) for (new id = 1; id < 33; id ++) g_iProjectileTailColor[id][i][3] = str_to_num(value);
	else if (!strcmp(key, "拖尾间隔SPR"))
	{
		new iSprite = engfunc(EngFunc_PrecacheModel, value);
		for (new id = 1; id < 33; id ++) g_iProjectileTailSprite[id][i] = iSprite;
	}
	else if (!strcmp(key, "拖尾间隔时间")) for (new id = 1; id < 33; id ++) g_fProjectileTailTime[id][i] = str_to_float(value);
	else if (!strcmp(key, "拖尾间隔SPR播放速率")) for (new id = 1; id < 33; id ++) g_fProjectileTailFramerate[id][i] = str_to_float(value);
	else if (!strcmp(key, "拖尾间隔SPR缩放")) for (new id = 1; id < 33; id ++) g_fProjectileTailScale[id][i] = str_to_float(value);
	else if (!strcmp(key, "拖尾间隔SPR高度修正")) for (new id = 1; id < 33; id ++) g_fProjectileTailHeightOfs[id][i] = str_to_float(value);
	else if (!strcmp(key, "追踪模式")) for (new id = 1; id < 33; id ++) g_iProjectileTraceMode[id][i] = str_to_num(value);
	else if (!strcmp(key, "追踪检测距离")) for (new id = 1; id < 33; id ++) g_fProjectileTraceRadius[id][i] = str_to_float(value);
	else if (!strcmp(key, "抛射物附带SPR"))
	{
		for (new id = 1; id < 33; id ++) copy(g_szProjectileExtraSprite[id][i], charsmax(g_szProjectileExtraSprite[][]), value);
		engfunc(EngFunc_PrecacheModel, value);
	}
	else if (!strcmp(key, "抛射物附带SPR播放速率")) for (new id = 1; id < 33; id ++) g_fExtraSpriteFramerate[id][i] = str_to_float(value);
	else if (!strcmp(key, "抛射物附带SPR缩放")) for (new id = 1; id < 33; id ++) g_fExtraSpriteScale[id][i] = str_to_float(value);
	else if (!strcmp(key, "抛射物发光")) for (new id = 1; id < 33; id ++) g_iProjectileGlow[id][i] = str_to_num(value);
	else if (!strcmp(key, "抛射物发光半径")) for (new id = 1; id < 33; id ++) g_iProjectileGlowRadius[id][i] = str_to_num(value);
	else if (!strcmp(key, "抛射物发光颜色R")) for (new id = 1; id < 33; id ++) g_iProjectileGlowColor[id][i][0] = str_to_num(value);
	else if (!strcmp(key, "抛射物发光颜色G")) for (new id = 1; id < 33; id ++) g_iProjectileGlowColor[id][i][1] = str_to_num(value);
	else if (!strcmp(key, "抛射物发光颜色B")) for (new id = 1; id < 33; id ++) g_iProjectileGlowColor[id][i][2] = str_to_num(value);
}

public Event_RoundStart()
{
	new iEntity = -1;
	while ((iEntity = engfunc(EngFunc_FindEntityByString, iEntity, "globalname", WPN_PROJECTILE_NAME))) engfunc(EngFunc_RemoveEntity, iEntity);
	while ((iEntity = engfunc(EngFunc_FindEntityByString, iEntity, "globalname", WPN_PROJECTILE_EXTRA))) engfunc(EngFunc_RemoveEntity, iEntity);
}

public WPN_PrimaryPreAttack(iEntity, id, i)
{
	if (g_iWeaponAttackMode[id][i] == WPNTYPE_PROJECTILE)
	return WPN_HANDLED;

	return WPN_IGNORED;
}

public WPN_PrimaryPostAttack_Post(iEntity, id, i)
{
	if (g_iWeaponAttackMode[id][i] == WPNTYPE_PROJECTILE)
	{
		new szWeaponName[64];
		WPN_GetParamString(i, id, wpn_szKillSpr, szWeaponName, charsmax(szWeaponName));

		new Float:fStartOrigin[3], Float:fTargetOrigin[3];
		get_position(id, 40.0, 0.0, 0.0, fStartOrigin);
		fm_get_aim_origin(id, fTargetOrigin);
		CreateProjectile(id, i, szWeaponName, fStartOrigin, fTargetOrigin);
	}
}

public fw_Think_Post(iEntity)
{
	if (!pev_valid(iEntity))
	return;

	new szGlobalName[64];
	pev(iEntity, pev_globalname, szGlobalName, charsmax(szGlobalName));
	if (strcmp(szGlobalName, WPN_PROJECTILE_NAME))
	return;

	new Float:fOrigin[3], Float:fTargetOrigin[3], Float:fVelocity[3];
	new Float:fFrame, Float:fFrameRate;
	pev(iEntity, pev_origin, fOrigin);
	new iOwner = pev(iEntity, pev_owner);
	new i = get_pdata_int(iEntity, WEAPON_ID);
	set_pev(iEntity, pev_nextthink, get_gametime() + 0.01);
	new iSprEnt = pev(iEntity, pev_iuser4);
	if (pev_valid(iSprEnt))
	{
		pev(iSprEnt, pev_frame, fFrame);
		pev(iSprEnt, pev_framerate, fFrameRate);
		set_pev(iSprEnt, pev_frame, fFrame + (0.2 * fFrameRate));
		if (floatround(fFrame) >= pev(iSprEnt, pev_iuser1)) set_pev(iSprEnt, pev_frame, 0.0);
	}

	// SPR播放
	if (pev(iEntity, pev_iuser2) == PROJECTILE_SPRITE)
	{
		pev(iEntity, pev_frame, fFrame);
		pev(iEntity, pev_framerate, fFrameRate);
		set_pev(iEntity, pev_frame, fFrame + (0.2 * fFrameRate));
		if (floatround(fFrame) >= pev(iEntity, pev_iuser3)) set_pev(iEntity, pev_frame, 0.0);
	}

	// 延迟时间
	new Float:fDmgTime;
	new Float:fParam[6];
	pev(iEntity, pev_dmgtime, fDmgTime);
	if (g_iWeaponDamageType[iOwner][i] == DAMAGETYPE_DELAY_EXP && get_gametime() > fDmgTime)
	{
		new iExplodeFlag = 0;
		if (!g_iProjectileExplodeEffect[iOwner][i]) iExplodeFlag |= (TE_EXPLFLAG_NODLIGHTS|TE_EXPLFLAG_NOPARTICLES);
		else
		{
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
			write_byte(TE_WORLDDECAL);
			engfunc(EngFunc_WriteCoord, fOrigin[0]);
			engfunc(EngFunc_WriteCoord, fOrigin[1]);
			engfunc(EngFunc_WriteCoord, fOrigin[2]);
			write_byte(random_num(46, 48));
			message_end();
		}
		if (g_iProjectileExplodeSound[iOwner][i] != DMGSOUND_DEFAULT)
		{
			iExplodeFlag |= TE_EXPLFLAG_NOSOUND;
			if (g_iProjectileExplodeSound[iOwner][i] == DMGSOUND_CUSTOM)
				engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szProjectileExplodeSound[iOwner][i], VOL_NORM, ATTN_NORM, 0, PITCH_NORM);
		}
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_EXPLOSION);
		engfunc(EngFunc_WriteCoord, fOrigin[0]);
		engfunc(EngFunc_WriteCoord, fOrigin[1]);
		engfunc(EngFunc_WriteCoord, fOrigin[2] + g_fProjectileExpHeightOfs[iOwner][i]);
		write_short(g_iProjectileExplodeSprite[iOwner][i]);
		write_byte(floatround(g_fProjectileExpScale[iOwner][i] * 10.0));
		write_byte(floatround(g_fProjectileExpFramerate[iOwner][i] * 10.0));
		write_byte(iExplodeFlag);
		message_end();

		fParam[0] = g_fProjectileDamageRadius[iOwner][i];
		fParam[5] = g_fWeaponDamage[iOwner][i];
		WPN_ExecuteAttack(iOwner, 0, iEntity, fParam, fOrigin, DMGTYPE_EXPLOSION, SPDMG_CANTHEADSHOT);
		if (pev_valid(iSprEnt)) engfunc(EngFunc_RemoveEntity, iSprEnt);
		engfunc(EngFunc_RemoveEntity, iEntity);
		return;
	}

	// 范围碰撞伤害
	if (g_iWeaponDamageType[iOwner][i] == DAMAGETYPE_AOE_TOUCH)
	{
		new Float:fTargetOrigin[3];
		for (new id = 1; id < 33; id ++)
		{
			if (!is_user_alive(id))
			continue;

			pev(id, pev_origin, fTargetOrigin);
			if (get_distance_f(fOrigin, fTargetOrigin) > g_fProjectileDamageRadius[iOwner][i])
			continue;

			if (pev(iEntity, pev_iuser1) & (1<<id))
			continue;

			if (get_pdata_int(id, m_iTeam) == get_pdata_int(iOwner, m_iTeam))
			continue;

			new iUser1 = pev(iEntity, pev_iuser1);
			iUser1 |= (1<<id);
			set_pev(iEntity, pev_iuser1, iUser1);
			fParam[5] = g_fWeaponDamage[iOwner][i];
			WPN_ExecuteAttack(iOwner, id, iEntity, fParam, fOrigin, DMGTYPE_TOUCH, SPDMG_CANTHEADSHOT);
		}
	}

	// 存在时间
	new Float:fUser4;
	pev(iEntity, pev_fuser4, fUser4);
	if (get_gametime() > fUser4 && fUser4 > 0.0)
	{
		if (pev_valid(iSprEnt)) engfunc(EngFunc_RemoveEntity, iSprEnt);
		engfunc(EngFunc_RemoveEntity, iEntity);
		return;
	}

	// 拖尾间隔SPR
	new Float:fUser1;
	pev(iEntity, pev_fuser1, fUser1);
	if (get_gametime() > fUser1 && fUser1)
	{
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_EXPLOSION);
		engfunc(EngFunc_WriteCoord, fOrigin[0]);
		engfunc(EngFunc_WriteCoord, fOrigin[1]);
		engfunc(EngFunc_WriteCoord, fOrigin[2] + g_fProjectileTailHeightOfs[iOwner][i]);
		write_short(g_iProjectileTailSprite[iOwner][i]);
		write_byte(floatround(g_fProjectileTailScale[iOwner][i] * 10.0));
		write_byte(floatround(g_fProjectileTailFramerate[iOwner][i] * 10.0));
		write_byte(TE_EXPLFLAG_NODLIGHTS|TE_EXPLFLAG_NOSOUND|TE_EXPLFLAG_NOPARTICLES);
		message_end();
		set_pev(iEntity, pev_fuser1, get_gametime() + g_fProjectileTailTime[iOwner][i]);
	}

	// 抛射物发光
	new Float:fUser2;
	pev(iEntity, pev_fuser2, fUser2);
	if (get_gametime() > fUser2 && fUser2)
	{
		engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, fOrigin, 0);
		write_byte(TE_DLIGHT);
		engfunc(EngFunc_WriteCoord, fOrigin[0]);
		engfunc(EngFunc_WriteCoord, fOrigin[1]);
		engfunc(EngFunc_WriteCoord, fOrigin[2]);
		write_byte(g_iProjectileGlowRadius[iOwner][i] / 10);
		write_byte(g_iProjectileGlowColor[iOwner][i][0]);
		write_byte(g_iProjectileGlowColor[iOwner][i][1]);
		write_byte(g_iProjectileGlowColor[iOwner][i][2]);
		write_byte(1);
		write_byte(0);
		message_end();

		engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, fOrigin, 0);
		write_byte(TE_ELIGHT);
		write_short(iEntity);
		engfunc(EngFunc_WriteCoord, fOrigin[0]);
		engfunc(EngFunc_WriteCoord, fOrigin[1]);
		engfunc(EngFunc_WriteCoord, fOrigin[2]);
		engfunc(EngFunc_WriteCoord, 10.0);
		write_byte(g_iProjectileGlowColor[iOwner][i][0]);
		write_byte(g_iProjectileGlowColor[iOwner][i][1]);
		write_byte(g_iProjectileGlowColor[iOwner][i][2]);
		write_byte(2);
		engfunc(EngFunc_WriteCoord, 0.0);
		message_end();

		set_pev(iEntity, pev_fuser2, get_gametime() + 0.01);
	}

	new iTarget = pev(iEntity, pev_euser1);
	if (g_iProjectileTraceMode[iOwner][i] == TRACEMODE_AUTO)
	{
		new Float:fMaxDis = 99999.0;
		new iTempTarget;
		if (!is_user_alive(iTarget))
		{
			for (new iPlayer = 1; iPlayer < 33; iPlayer ++)
			{
				if (!is_user_alive(iPlayer))
				continue;

				if (get_pdata_int(iOwner, m_iTeam) == get_pdata_int(iPlayer, m_iTeam))
				continue;

				pev(iPlayer, pev_origin, fTargetOrigin);
				if (is_wall_between_points(fOrigin, fTargetOrigin, iEntity))
				continue;

				if (get_distance_f(fOrigin, fTargetOrigin) < fMaxDis)
				{
					fMaxDis = get_distance_f(fOrigin, fTargetOrigin);
					iTempTarget = iPlayer;
				}
			}
			if (fMaxDis <= g_fProjectileTraceRadius[iOwner][i])
				set_pev(iEntity, pev_euser1, iTempTarget);
		}
		else
		{
			pev(iTarget, pev_origin, fTargetOrigin);
			get_speed_vector(fOrigin, fTargetOrigin, g_fProjectileFlySpeed[iOwner][i], fVelocity);
			EntityTurn(iEntity, fTargetOrigin);
			set_pev(iEntity, pev_velocity, fVelocity);
		}
	}
	else if (g_iProjectileTraceMode[iOwner][i] == TRACEMODE_AIM)
	{
		fm_get_aim_origin(iOwner, fTargetOrigin);
		get_speed_vector(fOrigin, fTargetOrigin, g_fProjectileFlySpeed[iOwner][i], fVelocity);
		EntityTurn(iEntity, fTargetOrigin);
		set_pev(iEntity, pev_velocity, fVelocity);
	}
}

public fw_Touch_Post(iEntity, id)
{
	if (!pev_valid(iEntity))
	return;

	new szGlobalName[64], szGlobalName2[64];
	pev(iEntity, pev_globalname, szGlobalName, charsmax(szGlobalName));
	if (strcmp(szGlobalName, WPN_PROJECTILE_NAME))
	return;

	if (pev_valid(id))
	{
		pev(id, pev_globalname, szGlobalName2, charsmax(szGlobalName2));
		if (!strcmp(szGlobalName, szGlobalName2))
		return;
	}

	new Float:fOrigin[3];
	new Float:fParam[6];
	pev(iEntity, pev_origin, fOrigin);
	new iOwner = pev(iEntity, pev_owner);
	new i = get_pdata_int(iEntity, WEAPON_ID);
	new iSprEnt = pev(iEntity, pev_iuser4);

	// 碰撞爆炸
	if (g_iWeaponDamageType[iOwner][i] == DAMAGETYPE_TOUCH_EXP)
	{
		new iExplodeFlag = 0;
		if (!g_iProjectileExplodeEffect[iOwner][i]) iExplodeFlag |= (TE_EXPLFLAG_NODLIGHTS|TE_EXPLFLAG_NOPARTICLES);
		else
		{
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
			write_byte(TE_WORLDDECAL);
			engfunc(EngFunc_WriteCoord, fOrigin[0]);
			engfunc(EngFunc_WriteCoord, fOrigin[1]);
			engfunc(EngFunc_WriteCoord, fOrigin[2]);
			write_byte(random_num(46, 48));
			message_end();
		}
		if (g_iProjectileExplodeSound[iOwner][i] != DMGSOUND_DEFAULT)
		{
			iExplodeFlag |= TE_EXPLFLAG_NOSOUND;
			if (g_iProjectileExplodeSound[iOwner][i] == DMGSOUND_CUSTOM)
				engfunc(EngFunc_EmitSound, iEntity, CHAN_WEAPON, g_szProjectileExplodeSound[iOwner][i], VOL_NORM, ATTN_NORM, 0, PITCH_NORM);
		}
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_EXPLOSION);
		engfunc(EngFunc_WriteCoord, fOrigin[0]);
		engfunc(EngFunc_WriteCoord, fOrigin[1]);
		engfunc(EngFunc_WriteCoord, fOrigin[2] + g_fProjectileExpHeightOfs[iOwner][i]);
		write_short(g_iProjectileExplodeSprite[iOwner][i]);
		write_byte(floatround(g_fProjectileExpScale[iOwner][i] * 10.0));
		write_byte(floatround(g_fProjectileExpFramerate[iOwner][i] * 10.0));
		write_byte(iExplodeFlag);
		message_end();

		fParam[0] = g_fProjectileDamageRadius[iOwner][i];
		fParam[5] = g_fWeaponDamage[iOwner][i];
		WPN_ExecuteAttack(iOwner, 0, iEntity, fParam, fOrigin, DMGTYPE_EXPLOSION, SPDMG_CANTHEADSHOT);
		if (pev_valid(iSprEnt)) engfunc(EngFunc_RemoveEntity, iSprEnt);
	}
	else if (g_iWeaponDamageType[iOwner][i] == DAMAGETYPE_TOUCH)
	{
		fParam[5] = g_fWeaponDamage[iOwner][i];
		WPN_ExecuteAttack(iOwner, id, iEntity, fParam, fOrigin, DMGTYPE_TOUCH, SPDMG_CANTHEADSHOT);
	}
	if (pev_valid(iSprEnt)) engfunc(EngFunc_RemoveEntity, iSprEnt);
	engfunc(EngFunc_RemoveEntity, iEntity);
}

public CreateProjectile(id, i, szClassName[], Float:fOrigin[3], Float:fTargetOrigin[3])
{
	new iEntityType = 0;
	new iEntity = FM_NULLENT;
	new Float:fAngles[3], Float:fVelocity[3];

	// 抛射物模型
	if (CheckSuffix(g_szProjectileModel[id][i], "mdl") || CheckSuffix(g_szProjectileModel[id][i], "MDL"))
	{
		iEntityType = PROJECTILE_MODEL;
		iEntity = engfunc(EngFunc_CreateNamedEntity, g_iInfoTarget);
	}
	else if (CheckSuffix(g_szProjectileModel[id][i], "spr") || CheckSuffix(g_szProjectileModel[id][i], "SPR"))
	{
		iEntityType = PROJECTILE_SPRITE;
		iEntity = engfunc(EngFunc_CreateNamedEntity, g_iEnvSprite);
	}
	else return FM_NULLENT;

	if (!pev_valid(iEntity))
	return FM_NULLENT;

	engfunc(EngFunc_SetModel, iEntity, g_szProjectileModel[id][i]);

	// 抛射物重力
	if (g_fProjectileGravity[id][i] == 0.0) set_pev(iEntity, pev_movetype, MOVETYPE_FLY);
	else set_pev(iEntity, pev_movetype, MOVETYPE_TOSS);
	set_pev(iEntity, pev_gravity, g_fProjectileGravity[id][i]);

	// 飞行速度 & 飞行高度修正
	get_speed_vector(fOrigin, fTargetOrigin, g_fProjectileFlySpeed[id][i], fVelocity);
	if (g_fProjectileGravity[id][i] > 0.0) fVelocity[2] += g_fProjectileHeightOfs[id][i];
	set_pev(iEntity, pev_velocity, fVelocity);

	// 延迟时间
	if (g_iWeaponDamageType[id][i] == DAMAGETYPE_DELAY_EXP)
		set_pev(iEntity, pev_dmgtime, get_gametime() + g_fProjectileDelay[id][i]);

	// 存在时间
	if (g_fProjectileDuration[id][i] > 0.0)
		set_pev(iEntity, pev_fuser4, get_gametime() + g_fProjectileDuration[id][i]);

	// 其他设置
	pev(id, pev_v_angle, fAngles);
	fAngles[0] *= -1.0;
	set_pdata_int(iEntity, WEAPON_ID, i);
	set_pev(iEntity, pev_solid, SOLID_TRIGGER);
	set_pev(iEntity, pev_classname, szClassName);
	set_pev(iEntity, pev_globalname, WPN_PROJECTILE_NAME);
	set_pev(iEntity, pev_origin, fOrigin);
	set_pev(iEntity, pev_angles, fAngles);
	set_pev(iEntity, pev_owner, id);
	set_pev(iEntity, pev_mins, Float:{ -1.0, -1.0, -1.0 });
	set_pev(iEntity, pev_maxs, Float:{ 1.0, 1.0, 1.0 });
	set_pev(iEntity, pev_nextthink, get_gametime() + 0.01);
	set_pev(iEntity, pev_iuser2, iEntityType);
	set_pev(iEntity, pev_framerate, g_fProjectileFramerate[id][i]);
	if (iEntityType == PROJECTILE_SPRITE)
	{
		set_pev(iEntity, pev_rendermode, kRenderTransAdd);
		set_pev(iEntity, pev_renderamt, g_fProjectileBrightness[id][i]);
		set_pev(iEntity, pev_rendercolor, { 255.0, 255.0, 255.0 });
		set_pev(iEntity, pev_scale, g_fProjectileScale[id][i]);
		new iModelIndex = engfunc(EngFunc_ModelIndex, g_szProjectileModel[id][i]);
		new iFrames = engfunc(EngFunc_ModelFrames, iModelIndex);
		set_pev(iEntity, pev_iuser3, iFrames);
	}
	else set_pev(iEntity, pev_animtime, get_gametime());

	// 抛射物拖尾
	if (g_iProjectileHasTail[id][i])
	{
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_BEAMFOLLOW);
		write_short(iEntity);
		write_short(g_sprBeamFollow);
		write_byte(10);
		write_byte(3);
		write_byte(g_iProjectileTailColor[id][i][0]);
		write_byte(g_iProjectileTailColor[id][i][1]);
		write_byte(g_iProjectileTailColor[id][i][2]);
		write_byte(g_iProjectileTailColor[id][i][3]);
		message_end();
	}

	// 拖尾间隔SPR
	if (g_iProjectileTailSprite[id][i] > 0)
		set_pev(iEntity, pev_fuser1, get_gametime() + g_fProjectileTailTime[id][i]);

	// 抛射物附带SPR
	if (g_szProjectileExtraSprite[id][i][0])
	{
		new iSprEnt = engfunc(EngFunc_CreateNamedEntity, g_iEnvSprite);
		set_pev(iSprEnt, pev_globalname, WPN_PROJECTILE_EXTRA);
		set_pev(iSprEnt, pev_movetype, MOVETYPE_FOLLOW);
		set_pev(iSprEnt, pev_rendermode, kRenderTransAdd);
		set_pev(iSprEnt, pev_renderamt, 255.0);
		set_pev(iSprEnt, pev_rendercolor, { 255.0, 255.0, 255.0 });
		set_pev(iSprEnt, pev_aiment, iEntity);
		set_pev(iSprEnt, pev_framerate, g_fExtraSpriteFramerate[id][i]);
		set_pev(iSprEnt, pev_scale, g_fExtraSpriteScale[id][i]);
		engfunc(EngFunc_SetModel, iSprEnt, g_szProjectileExtraSprite[id][i]);
		new iModelIndex = engfunc(EngFunc_ModelIndex, g_szProjectileExtraSprite[id][i]);
		new iFrames = engfunc(EngFunc_ModelFrames, iModelIndex);
		set_pev(iSprEnt, pev_iuser1, iFrames);
		set_pev(iEntity, pev_iuser4, iSprEnt);
	}

	// 抛射物发光
	if (g_iProjectileGlow[id][i])
	{
		engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, fOrigin, 0);
		write_byte(TE_DLIGHT);
		engfunc(EngFunc_WriteCoord, fOrigin[0]);
		engfunc(EngFunc_WriteCoord, fOrigin[1]);
		engfunc(EngFunc_WriteCoord, fOrigin[2]);
		write_byte(g_iProjectileGlowRadius[id][i] / 10);
		write_byte(g_iProjectileGlowColor[id][i][0]);
		write_byte(g_iProjectileGlowColor[id][i][1]);
		write_byte(g_iProjectileGlowColor[id][i][2]);
		write_byte(1);
		write_byte(0);
		message_end();

		engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, fOrigin, 0);
		write_byte(TE_ELIGHT);
		write_short(iEntity);
		engfunc(EngFunc_WriteCoord, fOrigin[0]);
		engfunc(EngFunc_WriteCoord, fOrigin[1]);
		engfunc(EngFunc_WriteCoord, fOrigin[2]);
		engfunc(EngFunc_WriteCoord, 10.0);
		write_byte(g_iProjectileGlowColor[id][i][0]);
		write_byte(g_iProjectileGlowColor[id][i][1]);
		write_byte(g_iProjectileGlowColor[id][i][2]);
		write_byte(2);
		engfunc(EngFunc_WriteCoord, 0.0);
		message_end();

		set_pev(iEntity, pev_fuser2, get_gametime() + 0.01);
	}

	return iEntity;
}

stock get_speed_vector(const Float:origin1[3],const Float:origin2[3],Float:speed, Float:new_velocity[3])
{
	new_velocity[0] = origin2[0] - origin1[0];
	new_velocity[1] = origin2[1] - origin1[1];
	new_velocity[2] = origin2[2] - origin1[2];
	new Float:num = floatsqroot(speed*speed / (new_velocity[0]*new_velocity[0] + new_velocity[1]*new_velocity[1] + new_velocity[2]*new_velocity[2]));
	new_velocity[0] *= num;
	new_velocity[1] *= num;
	new_velocity[2] *= num;
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

stock bool:CheckSuffix(szFileName[], szSuffix[])
{
	new szPrefix[128], szBuffer[128], szBuffer2[128];
	formatex(szBuffer, charsmax(szBuffer), "%s", szFileName);
	while (contain(szBuffer, ".") != -1)
	{
		formatex(szBuffer2, charsmax(szBuffer2), "%s", szBuffer);
		strtok(szBuffer2, szPrefix, charsmax(szPrefix), szBuffer, charsmax(szBuffer), '.');
	}
	if (!strcmp(szBuffer, szSuffix))
	return true;

	return false;
}

stock EntityTurn(iEntity, Float:fTarget[3])
{
	new Float:fOrigin[3], Float:fTempOrigin[3];
	pev(iEntity, pev_origin, fOrigin);
	fTempOrigin[0] = fTarget[0] - fOrigin[0];
	fTempOrigin[1] = fTarget[1] - fOrigin[1];
	fTempOrigin[2] = fTarget[2] - fOrigin[2];
	new Float:fLength = vector_length(fTempOrigin);
	fOrigin[0] = fTempOrigin[0] / fLength;
	fOrigin[1] = fTempOrigin[1] / fLength;
	fOrigin[2] = fTempOrigin[2] / fLength;
	vector_to_angle(fOrigin, fTempOrigin);
	if (fTempOrigin[1] > 180.0) fTempOrigin[1] -= 360.0;
	if (fTempOrigin[1] < -180.0) fTempOrigin[1] += 360.0;
	if (fTempOrigin[1] == 180.0 || fTempOrigin[1] == -180.0) fTempOrigin[1] = -179.999999;
	set_pev(iEntity, pev_angles, fTempOrigin);
}

stock is_wall_between_points(Float:start[3], Float:end[3], ignore_ent)
{
	new ptr = create_tr2();
	engfunc(EngFunc_TraceLine, start, end, IGNORE_MONSTERS, ignore_ent, ptr);
	static Float:EndPos[3];
	get_tr2(ptr, TR_vecEndPos, EndPos);
	free_tr2(ptr);
	return floatround(get_distance_f(end, EndPos));
}