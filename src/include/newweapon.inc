/**************************************************************************

Weapon Template v1.38

作者: IzayoiFly

日期: 2018-11-16

描述: 用模板方式添加一些新武器

**************************************************************************/

#if defined _NEWWEAPON_included
  #endinput
#endif
#define _NEWWEAPON_included

// ===========================<额外的inc>=========================== //
#include <wpn_const>

// ===========================<功能接口>=========================== //

/**
 * 注册一个主武器或副武器
 * 
 * @param iWeaponId		武器ID（CSW_***）
 * @param iWeaponData		武器整数型参数，具体看wpn_const.inc
 * @param fWeaponData		武器浮点型参数，具体看wpn_const.inc
 * @param szWeaponList		武器SPR（weapon_***.txt）
 * @param szKillSPR		杀敌SPR
 * @param szWeaponPModel	P模型
 * @param szWeaponVModel	V模型
 * @param szWeaponWModel	W模型
 * @param szWeaponVModelSight	机瞄V模型
 * @param szFireSound1		开枪声音1
 * @param szFireSound2		开枪声音2
 * @param szSilenceFireSound1	消音状态开枪声音1
 * @param szSilenceFireSound2	消音状态开枪声音2
 * @param szCommand		购买命令
 * 
 * @return			武器序号
 */
native WPN_RegisterWeapon(iWeaponId, iWeaponData[MaxWeaponIntData], Float:fWeaponData[MaxWeaponFloatData], szWeaponList[], szKillSPR[],
szWeaponPModel[], szWeaponVModel[], szWeaponWModel[], szWeaponVModelSight[], szFireSound1[], szFireSound2[], szSilenceFireSound1[],
szSilenceFireSound2[], szCommand[]);

/**
 * 设置武器的动作
 * 
 * @param i			武器序号
 * @param IDLE			武器静止动作
 * @param RELOAD		武器换弹动作
 * @param DRAW			武器掏出动作
 * @param SHOOT			三个武器射击动作，如果武器类型是CSW_ELITE的话那么SHOOT[0]为左攻击，SHOOT[1]为右攻击（左手状态。。。=。=），SHOOT[2]被忽略
 * @param RELOADMODE		分别是ANIM_START_RELOAD（开始填弹）, ANIM_INSERT（填弹）, ANIM_AFTER_RELOAD（结束填弹）
 * @param SIGHT_OPEN		开启机瞄的动作
 * @param SIGHT_CLOSE		关闭机瞄的动作
 * @param DETACH_SILENCER	关闭消音的动作
 * @param ATTACH_SILENCER	开启消音的动作
 * @param IDLE_SILENCED		消音状态下的静止动作
 * @param RELOAD_SILENCED	消音状态下的换弹动作
 * @param DRAW_SILENCED		消音状态下的掏出动作
 * @param SHOOT_SILENCED	消音状态下的三个武器射击动作
 * 
 * @return			无
 */
native WPN_SetWeaponAnim(i, IDLE, RELOAD, DRAW, SHOOT[3], RELOADMODE[3], SIGHT_OPEN, SIGHT_CLOSE, DETACH_SILENCER, ATTACH_SILENCER,
IDLE_SILENCED, RELOAD_SILENCED, DRAW_SILENCED, SHOOT_SILENCED[3]);

/**
 * 注册一个近身武器
 * 
 * @param szWeaponList		武器SPR（weapon_***.txt）
 * @param szKillSPR		杀敌SPR
 * @param szWeaponPModel	P模型
 * @param szWeaponVModel	V模型
 * @param szKnifeSound1		掏出声音
 * @param szKnifeSound2		击墙声音
 * @param szKnifeSound3		击空声音
 * @param szKnifeSound4		重击声音
 * @param szKnifeSound5		轻击1声音
 * @param szKnifeSound6		轻击2声音
 * @param fKnifeData		刀子浮点型参数，具体看wpn_const.inc
 * @param szCommand		购买命令
 * @param iCost			价格
 * @param iTeam			购买队伍，1是T，2是CT，0是所有队伍
 * 
 * @return			武器序号
 */
native WPN_RegisterKnife(szWeaponList[], szKillSPR[], szWeaponPModel[], szWeaponVModel[], szKnifeSound1[], szKnifeSound2[],
szKnifeSound3[], szKnifeSound4[], szKnifeSound5[], szKnifeSound6[], Float:fKnifeData[MaxKnifeFloatData], szCommand[], iCost, iTeam);

/**
 * 设置近身武器的动作
 * 
 * @param i			武器序号
 * @param IDLE			静止动作
 * @param SLASH1		轻击动作1
 * @param SLASH2		轻击动作2
 * @param DRAW			掏出动作
 * @param STAB			重击动作
 * @param STABMISS		重击miss动作
 * @param MIDSLASH		轻击动作
 * @param MIDSLASHMISS		轻击miss动作
 * @param SLASHBEGIN		轻击延迟动作
 * @param STABBEGIN		重击延迟动作
 * 
 * @return			无
 */
native WPN_SetKnifeAnim(i, IDLE, SLASH1, SLASH2, DRAW, STAB, STABMISS, MIDSLASH, MIDSLASHMISS, SLASHBEGIN, STABBEGIN);

/**
 * 注册一个投掷武器
 * 
 * @param szWeaponList		武器SPR（weapon_***.txt）
 * @param szKillSPR		杀敌SPR
 * @param szExplodeSPR		爆炸SPR
 * @param szWeaponPModel	P模型
 * @param szWeaponVModel	V模型
 * @param szWeaponWModel	W模型
 * @param szExplodeSound	爆炸声音
 * @param fDrawTime		掏出时间
 * @param fExplodeTime		爆炸时间
 * @param fRange		爆炸半径
 * @param fMaxSpeed		行走速度
 * @param fDamage		伤害倍数
 * @param fExplodeSoundVolume	爆炸声音大小（0.0 <= 数值 <= 1.0）
 * @param szCommand		购买命令
 * @param iCost			价格
 * @param iTeam			购买队伍，1是T，2是CT，0是所有队伍
 * @param iWModelBody		W模型子模型的序号（没有的话写0）
 * 
 * @return			武器序号
 */
native WPN_RegisterGrenade(szWeaponList[], szKillSPR[], szExplodeSPR[], szWeaponPModel[], szWeaponVModel[], szWeaponWModel[],
szExplodeSound[], Float:fDrawTime, Float:fExplodeTime, Float:fRange, Float:fMaxSpeed, Float:fDamage, Float:fExplodeSoundVolume,
szCommand[], iCost, iTeam, iWModelBody);

/**
 * 给玩家武器
 * 
 * @param id			玩家id
 * @param i			武器序号
 * @return			武器实体id（iEntity）
 */
native WPN_GiveWeapon(id, i);

/**
 * 获取武器的参数
 * 
 * @param i			武器序号
 * @param id			玩家id
 * @param iType			要获取的类型（参考wpn_const.inc）
 * @param szReturn		将获取的内容存储到szReturn里
 * @param iLen			字符串的长度
 * 
 * @return			要获取的值
 */
native WPN_GetParamInt(i, id, iType);
native Float:WPN_GetParamFloat(i, id, iType);
native WPN_GetParamString(i, id, iType, szReturn[], iLen);

/**
 * 设置武器的参数
 * 
 * @param i			武器序号
 * @param id			玩家id
 * @param iType			要设置的类型（参考wpn_const.inc）
 * @param iValue		要设置的值
 * @param fValue		要设置的值
 * @param szValue		要设置的值
 * 
 * @return			无
 */
native WPN_SetParamInt(i, id, iType, iValue);
native WPN_SetParamFloat(i, id, iType, Float:fValue);
native WPN_SetParamString(i, id, iType, szValue[]);

/**
 * 执行一次攻击
 * 
 * @note: 
 * 当伤害类型为DMGTYPE_SECTOR或者DMGTYPE_LINE时，坐标为玩家坐标；DMGTYPE_EXPLOSION和DMGTYPE_TOUCH可以填实体坐标
 * 受害者id只有在伤害类型为DMGTYPE_TOUCH时才会用到，其他类型可以为0

 * @param iAttacker		攻击者id
 * @param iVictim		受害者id
 * @param iEntity		攻击者使用的实体id
 * @param fParam[0]		距离
 * @param fParam[1]		角度（建议值：60.0 <= 角度 <= 120.0）
 * @param fParam[2]		角度搜索间隔（建议值：20.0左右，最低为1.0）
 * @param fParam[3]		高度（建议值：1.0 <= 高度 <= 50.0）
 * @param fParam[4]		高度搜索间隔（建议值：5.0 <= 高度 <= 15.0）
 * @param fParam[5]		伤害值
 * @param fOrigin		坐标
 * @param iDamageType		伤害类型
 * @param iSpecial		特殊标记
 * 
 * @return HIT_PLAYER		击中玩家（人质也为HIT_PLAYER）
 * @return HIT_ENTITY		击中实体
 * @return HIT_WALL		击中worldspawn
 * @return HIT_EMPTY		未击中
 */
native WPN_ExecuteAttack(iAttacker, iVictim, iEntity, Float:fParam[6], Float:fOrigin[3], iDamageType, iSpecial);

/**
 * 生成血
 * 
 * @param fOrigin		坐标
 * @param iColor		颜色
 * @param iAmount		数量
 * 
 * @return 			无
 */
native WPN_SpawnBlood(Float:fOrigin[3], iColor, iAmount);

/**
 * 生成烟雾
 * 
 * @param fOrigin		坐标
 * 
 * @return			无
 */
native WPN_FakeSmoke(Float:fOrigin[3]);

/**
 * 补给子弹
 * 
 * @param id			玩家id
 * @param iEntity		武器实体id
 * @param i			武器序号
 * @param iFull			是否补满
 * 
 * @return			无
 */
native WPN_GiveAmmo(id, iEntity, i, iFull);

// ===========================<事件接口>=========================== //

/**
 * 左键pre攻击事件
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 * @return WPN_IGNORED		正常返回
 * @return WPN_SUPERCEDE	打断左键攻击
 * @return WPN_HANDLED		打断左键攻击并执行一次假攻击
 */
forward WPN_PrimaryPreAttack(iEntity, id, i);

/**
 * 左键pre攻击事件post
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 */
forward WPN_PrimaryPreAttack_Post(iEntity, id, i);

/**
 * 左键post攻击事件
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 * @return WPN_IGNORED：正常返回
 * @return WPN_SUPERCEDE：打断左键post攻击
 */
forward WPN_PrimaryPostAttack(iEntity, id, i);

/**
 * 左键post攻击事件post
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 */
forward WPN_PrimaryPostAttack_Post(iEntity, id, i);

/**
 * 右键pre攻击事件
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 * @return WPN_IGNORED		正常返回
 * @return WPN_SUPERCEDE	打断右键攻击
 */
forward WPN_SecondaryPreAttack(iEntity, id, i);

/**
 * 右键pre攻击事件post
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 */
forward WPN_SecondaryPreAttack_Post(iEntity, id, i);

/**
 * 右键post攻击事件
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 * @return WPN_IGNORED		正常返回
 * @return WPN_SUPERCEDE	打断右键post攻击
 */
forward WPN_SecondaryPostAttack(iEntity, id, i);

/**
 * 右键post攻击事件post
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 */
forward WPN_SecondaryPostAttack_Post(iEntity, id, i);

/**
 * 刀子轻击延迟结束事件（未攻击）
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 * @return WPN_IGNORED		正常返回
 * @return WPN_SUPERCEDE	打断左键结束攻击
 */
forward WPN_PrimaryAttackEnd(iEntity, id, i);

/**
 * 刀子轻击延迟结束post事件（已攻击）
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 */
forward WPN_PrimaryAttackEnd_Post(iEntity, id, i);

/**
 * 刀子重击延迟结束事件（未攻击）
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 * @return WPN_IGNORED		正常返回
 * @return WPN_SUPERCEDE	打断右键结束攻击
 */
forward WPN_SecondaryAttackEnd(iEntity, id, i);

/**
 * 刀子重击延迟结束post事件（已攻击）
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 */
forward WPN_SecondaryAttackEnd_Post(iEntity, id, i);

/**
 * 武器的Idle事件
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 * @return WPN_IGNORED		正常返回
 * @return WPN_SUPERCEDE	打断idle事件
 */
forward WPN_WeaponIdle(iEntity, id, i);

/**
 * 武器的postframe事件
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 * @return WPN_IGNORED		正常返回
 * @return WPN_SUPERCEDE	打断postframe事件
 */
forward WPN_WeaponPostFrame(iEntity, id, i);

/**
 * 武器的Reload事件
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 * @return WPN_IGNORED		正常返回
 * @return WPN_SUPERCEDE	打断Reload事件
 */
forward WPN_WeaponReload(iEntity, id, i);

/**
 * 武器的Reload Post事件
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 * @return WPN_IGNORED		正常返回
 * @return WPN_SUPERCEDE	打断Reload Post事件
 */
forward WPN_WeaponReload_Post(iEntity, id, i);

/**
 * 武器的Draw事件
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 */
forward WPN_WeaponDraw(iEntity, id, i);

/**
 * 购买武器Pre事件（未购买）
 * 
 * @param id			玩家id
 * @param szCommand		命令
 * 
 * @return WPN_IGNORED		正常返回
 * @return WPN_SUPERCEDE	打断购买事件
 */
forward WPN_BuyWeapon(id, const szCommand[]);

/**
 * 购买武器Post事件（已购买）
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 */
forward WPN_BuyWeapon_Post(iEntity, id, i);

/**
 * 设置最大速度Pre事件
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 * @return WPN_IGNORED		正常返回
 * @return WPN_SUPERCEDE	打断设置速度事件；建议设置速度在这里，设置pev_maxspeed之后再打断
 */
forward WPN_WeaponMaxSpeed(iEntity, id, i);

/**
 * 设置击退Pre事件
 * 
 * @param attacker		攻击者id
 * @param victim		受害者id
 * @param inflictor		攻击实体id
 * @param i			武器序号
 * @param damage		伤害值
 * 
 * @return WPN_IGNORED		正常返回
 * @return WPN_SUPERCEDE	打断击退事件；建议设置击退在这里，设置pev_velocity之后再打断
 */
forward WPN_WeaponKnockBack(attacker, victim, inflictor, i, Float:damage);

/**
 * 产生血液事件
 * 
 * @param iColor		血液颜色
 * 
 * @return WPN_IGNORED		正常返回
 * @return WPN_SUPERCEDE	打断生成血液事件
 */
forward WPN_HookSpawnBlood(iColor);

/**
 * 手雷爆炸Pre事件
 * 
 * @param iEntity		武器实体id
 * @param id			玩家id
 * @param i			武器序号
 * 
 * @return WPN_IGNORED		正常返回
 * @return WPN_SUPERCEDE	打断手雷爆炸事件；建议写特殊手雷在这里，写完特效（duang）后打断
 */
forward WPN_HookGrenadeExplode(iEntity, id, i);

/**
 * 手雷爆炸Post事件
 * 
 * @param id			玩家id
 * @param iEntity		武器实体id
 * @param victim		受害者id
 * @param i			武器序号
 * 
 */
forward WPN_HookGrenadeExplode_Post(id, iEntity, victim, i);

/**
 * BOT购买武器Pre事件
 * 
 * @param id			BOT id
 * 
 * @return WPN_IGNORED		正常返回
 * @return WPN_SUPERCEDE	打断BOT购买所有武器事件
 */
forward WPN_BotBuyWeapon(id);

/**
 * BOT购买武器Post事件
 * 
 * @param id			BOT id
 * @param i			武器序号
 * @param iSpecialWeapon	特殊武器序号（参考wpn_const.inc）
 * 
 * @return WPN_IGNORED		正常返回
 * @return WPN_SUPERCEDE	打断BOT购买某个武器事件
 */
forward WPN_BotBuyWeapon_Post(id, i, iSpecialWeapon);

/**
 * 伤害事件
 * 
 * @param victim		受害者id
 * @param inflictor		攻击者实体
 * @param attacker		攻击者id
 * @param damage		伤害值
 * @param damage_type		伤害类型
 * 
 * @return WPN_IGNORED：正常返回
 * @return WPN_SUPERCEDE：打断伤害事件
 */
forward WPN_TakeDamage(victim, inflictor, attacker, Float:damage, damage_type);

/**
 * 读入数据事件
 * 
 * @param iSlot			模板slot
 * @param i			武器序号
 * @param key			键
 * @param value			值
 * 
 */
forward WPN_LoadFiles(iSlot, i, key[], value[]);

/**
 * DeathMsg事件
 * 
 * @param attacker		攻击者id
 * @param victim		受害者id
 * @param headshot		是否爆头
 * @param szWeapon		击杀spr（如果是新枪那么是新枪的spr，不是原版spr）
 * 
 * @return WPN_IGNORED		正常返回
 * @return WPN_SUPERCEDE	打断DeathMsg消息
 */
forward WPN_DeathMsg(attacker, victim, headshot, szWeapon[]);