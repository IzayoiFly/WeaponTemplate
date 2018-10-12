#if defined _NEWWEAPON_included
  #endinput
#endif
#define _NEWWEAPON_included

// ===========================<额外的inc>=========================== //
#include <wpn_const>

// ===========================<功能接口>=========================== //
// 介绍：注册一个主武器或副武器
// 参数信息：
// 	iWeaponId：武器ID（CSW_***）
// 	iWeaponData：武器整数型参数，具体看wpn_const.inc
//	fWeaponData：武器浮点型参数，具体看wpn_const.inc
// 	szWeaponList：武器SPR（weapon_***.txt）
// 	szKillSPR：杀敌SPR
// 	szWeaponPModel：P模型
// 	szWeaponVModel：V模型
// 	szWeaponWModel：W模型
// 	szWeaponVModelSight：机瞄V模型
// 	szFireSound1：开枪声音1
// 	szFireSound2：开枪声音2
// 	szSilenceFireSound1：消音状态开枪声音1
// 	szSilenceFireSound2：消音状态开枪声音2
// 	szCommand：购买命令
// 返回值：武器序号
native WPN_RegisterWeapon(iWeaponId, iWeaponData[MaxWeaponIntData], Float:fWeaponData[MaxWeaponFloatData], szWeaponList[], szKillSPR[], szWeaponPModel[], szWeaponVModel[], szWeaponWModel[], szWeaponVModelSight[], szFireSound1[], szFireSound2[], szSilenceFireSound1[], szSilenceFireSound2[], szCommand[])

// 介绍：设置武器的动作
// 参数信息：
//	i：武器序号
//	IDLE：武器静止动作
//	RELOAD：武器换弹动作
//	DRAW：武器掏出动作
//	SHOOT：三个武器射击动作，如果武器类型是CSW_ELITE的话那么SHOOT[0]为左攻击，SHOOT[1]为右攻击（左手状态。。。=。=），SHOOT[2]被忽略
//	RELOADMODE：分别是ANIM_START_RELOAD（开始填弹）, ANIM_INSERT（填弹）, ANIM_AFTER_RELOAD（结束填弹）
//	SIGHT_OPEN：开启机瞄的动作
//	SIGHT_CLOSE：关闭机瞄的动作
//	DETACH_SILENCER：关闭消音的动作
//	ATTACH_SILENCER：开启消音的动作
//	IDLE_SILENCED：消音状态下的静止动作
//	RELOAD_SILENCED：消音状态下的换弹动作
//	DRAW_SILENCED：消音状态下的掏出动作
//	SHOOT_SILENCED：消音状态下的三个武器射击动作
// 返回值：无
native WPN_SetWeaponAnim(i, IDLE, RELOAD, DRAW, SHOOT[3], RELOADMODE[3], SIGHT_OPEN, SIGHT_CLOSE, DETACH_SILENCER, ATTACH_SILENCER, IDLE_SILENCED, RELOAD_SILENCED, DRAW_SILENCED, SHOOT_SILENCED[3])

// 介绍：注册一个近身武器
// 参数信息：
//	szWeaponList：武器SPR（weapon_***.txt）
//	szKillSPR：杀敌SPR
//	szWeaponPModel：P模型
//	szWeaponVModel：V模型
//	szKnifeSound1：掏出声音
//	szKnifeSound2：击墙声音
//	szKnifeSound3：击空声音
//	szKnifeSound4：重击声音
//	szKnifeSound5：轻击1声音
//	szKnifeSound6：轻击2声音
//	fKnifeData：刀子浮点型参数，具体看wpn_const.inc
//	szCommand：购买命令
//	iCost：价格
//	iTeam：购买队伍，1是T，2是CT，0是所有队伍
// 返回值：武器序号
native WPN_RegisterKnife(szWeaponList[], szKillSPR[], szWeaponPModel[], szWeaponVModel[], szKnifeSound1[], szKnifeSound2[], szKnifeSound3[], szKnifeSound4[], szKnifeSound5[], szKnifeSound6[], Float:fKnifeData[MaxKnifeFloatData], szCommand[], iCost, iTeam)

// 介绍：设置近身武器的动作
// 参数信息：
//	i：武器序号
//	IDLE：静止动作
//	SLASH1：轻击动作1
//	SLASH2：轻击动作2
//	DRAW：掏出动作
//	STAB：重击动作
//	STABMISS：重击miss动作
//	MIDSLASH：轻击动作
//	MIDSLASHMISS：轻击miss动作
//	SLASHBEGIN：轻击延迟动作
//	STABBEGIN：重击延迟动作
// 返回值：无
native WPN_SetKnifeAnim(i, IDLE, SLASH1, SLASH2, DRAW, STAB, STABMISS, MIDSLASH, MIDSLASHMISS, SLASHBEGIN, STABBEGIN)

// 介绍：注册一个投掷武器
// 参数信息：
//	szWeaponList：武器SPR（weapon_***.txt）
//	szKillSPR：杀敌SPR
//	szExplodeSPR：爆炸SPR
//	szWeaponPModel：P模型
//	szWeaponVModel：V模型
//	szWeaponWModel：W模型
//	szExplodeSound：爆炸声音
//	fDrawTime：掏出时间
//	fExplodeTime：爆炸时间
//	fRange：爆炸半径
//	fMaxSpeed：行走速度
//	fDamage：伤害倍数
//	fExplodeSoundVolume：爆炸声音大小（0.0 <= 数值 <= 1.0）
//	szCommand：购买命令
//	iCost：价格
//	iTeam：购买队伍，1是T，2是CT，0是所有队伍
//	iWModelBody：W模型子模型的序号（没有的话写0）
// 返回值：武器序号
native WPN_RegisterGrenade(szWeaponList[], szKillSPR[], szExplodeSPR[], szWeaponPModel[], szWeaponVModel[], szWeaponWModel[], szExplodeSound[], Float:fDrawTime, Float:fExplodeTime, Float:fRange, Float:fMaxSpeed, Float:fDamage, Float:fExplodeSoundVolume, szCommand[], iCost, iTeam, iWModelBody)

// 介绍：给玩家武器
// 参数信息：
//	id：玩家id
//	i：武器序号
// 返回值：武器实体id（iEntity）
native WPN_GiveWeapon(id, i)

// 介绍：获取武器的参数
// 参数信息：
//	i：武器序号
//	id：玩家id
//	iType：要获取的类型（参考wpn_const.inc）
//	szReturn，iLen：将获取的内容存储到长度为len的字符串szReturn里
// 返回值：要获取的值
native WPN_GetParamInt(i, id, iType)
native Float:WPN_GetParamFloat(i, id, iType)
native WPN_GetParamString(i, id, iType, szReturn[], iLen)

// 介绍：设置武器的参数
// 参数信息：
//	i：武器序号
//	id：玩家id
//	iType：要设置的类型（参考wpn_const.inc）
//	iValue，fValue，szValue：要设置的值
// 返回值：无
native WPN_SetParamInt(i, id, iType, iValue)
native WPN_SetParamFloat(i, id, iType, Float:fValue)
native WPN_SetParamString(i, id, iType, szValue[])

// 介绍：执行一次攻击
// 参数信息：
//	iAttacker：攻击者id
//	iVictim：受害者id
//	iEntity：攻击者使用的实体id
//	fParam：浮点型参数
//		fParam[0]：距离
//		fParam[1]：角度（建议值：60.0 <= 角度 <= 120.0）
//		fParam[2]：角度搜索间隔（建议值：20.0左右，最低为1.0）
//		fParam[3]：高度（建议值：1.0 <= 高度 <= 50.0）
//		fParam[4]：高度搜索间隔（建议值：5.0 <= 高度 <= 15.0）
//		fParam[5]：伤害值
//	fOrigin：坐标
//	iDamageType：伤害类型
//	iSpecial：特殊标记
// 备注：
//	当伤害类型为DMGTYPE_SECTOR或者DMGTYPE_LINE时，坐标为玩家坐标；DMGTYPE_EXPLOSION和DMGTYPE_TOUCH可以填实体坐标
//	受害者id只有在伤害类型为DMGTYPE_TOUCH时才会用到，其他类型可以为0
// 返回值：
//	HIT_PLAYER	击中玩家（人质也为HIT_PLAYER）
//	HIT_ENTITY	击中实体
//	HIT_WALL	击中worldspawn
//	HIT_EMPTY	未击中
native WPN_ExecuteAttack(iAttacker, iVictim, iEntity, Float:fParam[6], Float:fOrigin[3], iDamageType, iSpecial)

// 介绍：生成血
// 参数信息：
//	fOrigin：坐标
//	iColor：颜色
//	iAmount：数量
// 返回值：无
native WPN_SpawnBlood(Float:fOrigin[3], iColor, iAmount)

// 介绍：生成烟雾
// 参数信息：
//	fOrigin：坐标
// 返回值：无
native WPN_FakeSmoke(Float:fOrigin[3])

// 介绍：补给子弹
// 参数信息：
//	id：玩家id
//	iEntity：武器实体id
//	i：武器序号
//	iFull：是否补满
// 返回值：无
native WPN_GiveAmmo(id, iEntity, i, iFull)

// ===========================<事件接口>=========================== //

// 介绍：左键pre攻击事件
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断左键攻击
//	WPN_HANDLED：打断左键攻击并执行一次假攻击
forward WPN_PrimaryPreAttack(iEntity, id, i)

// 介绍：左键pre攻击事件post
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：无
forward WPN_PrimaryPreAttack_Post(iEntity, id, i)

// 介绍：左键post攻击事件
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断左键post攻击
forward WPN_PrimaryPostAttack(iEntity, id, i)

// 介绍：左键post攻击事件post
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：无
forward WPN_PrimaryPostAttack_Post(iEntity, id, i)

// 介绍：右键pre攻击事件
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断右键攻击
forward WPN_SecondaryPreAttack(iEntity, id, i)

// 介绍：右键pre攻击事件post
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：无
forward WPN_SecondaryPreAttack_Post(iEntity, id, i)

// 介绍：右键post攻击事件
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断右键post攻击
forward WPN_SecondaryPostAttack(iEntity, id, i)

// 介绍：右键post攻击事件post
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：无
forward WPN_SecondaryPostAttack_Post(iEntity, id, i)

// 介绍：刀子轻击延迟结束事件（未攻击）
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断左键结束攻击
forward WPN_PrimaryAttackEnd(iEntity, id, i)

// 介绍：刀子轻击延迟结束post事件（已攻击）
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：无
forward WPN_PrimaryAttackEnd_Post(iEntity, id, i)

// 介绍：刀子重击延迟结束事件（未攻击）
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断右键结束攻击
forward WPN_SecondaryAttackEnd(iEntity, id, i)

// 介绍：刀子重击延迟结束post事件（已攻击）
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：无
forward WPN_SecondaryAttackEnd_Post(iEntity, id, i)

// 介绍：武器的Idle事件
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断idle事件
forward WPN_WeaponIdle(iEntity, id, i)

// 介绍：武器的postframe事件
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断postframe事件
forward WPN_WeaponPostFrame(iEntity, id, i)

// 介绍：武器的Reload事件
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断Reload事件
forward WPN_WeaponReload(iEntity, id, i)

// 介绍：武器的Reload Post事件
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断Reload Post事件
forward WPN_WeaponReload_Post(iEntity, id, i)

// 介绍：武器的Draw事件
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：无
forward WPN_WeaponDraw(iEntity, id, i)

// 介绍：购买武器Pre事件（未购买）
// 参数信息：
//	id：玩家id
//	szCommand：命令
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断购买事件
forward WPN_BuyWeapon(id, const szCommand[])

// 介绍：购买武器Post事件（已购买）
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：无
forward WPN_BuyWeapon_Post(iEntity, id, i)

// 介绍：设置最大速度Pre事件
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断设置速度事件；建议设置速度在这里，设置pev_maxspeed之后再打断
forward WPN_WeaponMaxSpeed(iEntity, id, i)

// 介绍：设置击退Pre事件
// 参数信息：
//	attacker：攻击者id
//	victim：受害者id
//	inflictor：攻击实体id
//	i：武器序号
//	damage：伤害值
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断击退事件；建议设置击退在这里，设置pev_velocity之后再打断
forward WPN_WeaponKnockBack(attacker, victim, inflictor, i, Float:damage)

// 介绍：产生血液事件
// 参数信息：
//	iColor：血液颜色
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断生成血液事件
forward WPN_HookSpawnBlood(iColor)

// 介绍：手雷爆炸Pre事件
// 参数信息：
//	iEntity：武器实体id
//	id：玩家id
//	i：武器序号
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断手雷爆炸事件；建议写特殊手雷在这里，写完特效（duang）后打断
forward WPN_HookGrenadeExplode(iEntity, id, i)

// 介绍：手雷爆炸Post事件
// 参数信息：
//	id：玩家id
//	iEntity：武器实体id
//	victim：受害者id
//	i：武器序号
// 可使用返回值：无
forward WPN_HookGrenadeExplode_Post(id, iEntity, victim, i)

// 介绍：BOT购买武器Pre事件
// 参数信息：
//	id：BOT id
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断BOT购买所有武器事件
forward WPN_BotBuyWeapon(id)

// 介绍：BOT购买武器Post事件
// 参数信息：
//	id：BOT id
//	i：武器序号
//	iSpecialWeapon：特殊武器序号（参考wpn_const.inc）
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断BOT购买某个武器事件
forward WPN_BotBuyWeapon_Post(id, i, iSpecialWeapon)

// 介绍：伤害事件
// 参数信息：
//	和Ham_TakeDamage一样就不用介绍了。。
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断伤害事件
forward WPN_TakeDamage(victim, inflictor, attacker, Float:damage, damage_type)

// 介绍：读入数据事件
// 参数信息：
//	iSlot：模板slot
//	i：武器序号
//	key：键
//	value：值
// 可使用返回值：无
forward WPN_LoadFiles(iSlot, i, key[], value[])

// 介绍：DeathMsg事件
// 参数信息：
//	attacker：攻击者id
//	victim：受害者id
//	headshot：是否爆头
//	szWeapon：击杀spr（如果是新枪那么是新枪的spr，不是原版spr）
// 可使用返回值：
//	WPN_IGNORED：正常返回
//	WPN_SUPERCEDE：打断DeathMsg消息
forward WPN_DeathMsg(attacker, victim, headshot, szWeapon[])