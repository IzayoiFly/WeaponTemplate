#if defined _WPN_CONST_included
  #endinput
#endif
#define _WPN_CONST_included

// 最大武器量
#define MAXWEAPON			128

// 事件返回值
#define WPN_IGNORED			0
#define WPN_SUPERCEDE			1
#define WPN_HANDLED			2

// 获取武器序号的模板序号类型
#define SLOT_WEAPON			0
#define SLOT_KNIFE			1
#define SLOT_GRENADE			2

// 原版刀子攻击距离
#define DEFAULT_DISTANCE_SWING		48
#define DEFAULT_DISTANCE_STAB		32

// 机瞄状态
#define CLOSED				0
#define OPEN				1
#define ATOB				2
#define BTOA				3

// 最大金钱量
#define MAXMONEY			16000

// 购买限制设置
#define BUY_NORMALLY			0
#define BUY_CANNOT			1
#define BUY_EVERYWHERE			2

// BOT购买的Special Weapon
#define SW_VESTHELM			1
#define SW_DEFUSER			2
#define SW_HEGRENADE			3
#define SW_FLASHBANG			4
#define SW_SMOKEGRENADE			5

// 最大主武器id数
#define MAX_PRIM			18

// 最大副武器id数
#define MAX_SEC				6

// 伤害时的特殊标记
#define SPDMG_NORMAL			0
#define SPDMG_CANTHEADSHOT		(1<<0)
#define SPDMG_TEAMATTACK		(1<<1)

// CheckAttack的返回值
enum
{
	HIT_EMPTY = 0,
	HIT_PLAYER,
	HIT_ENTITY,
	HIT_WALL
}

// 伤害类型
enum
{
	DMGTYPE_SECTOR = 0,
	DMGTYPE_LINE,
	DMGTYPE_EXPLOSION,
	DMGTYPE_TOUCH
}

enum
{
	ANIM_IDLE = 0,
	ANIM_RELOAD,
	ANIM_DRAW,
	ANIM_SHOOT1,
	ANIM_SHOOT2,
	ANIM_SHOOT3,
	ANIM_START_RELOAD,
	ANIM_INSERT,
	ANIM_AFTER_RELOAD,
	ANIM_SIGHT_OPEN,
	ANIM_SIGHT_CLOSE,
	ANIM_DETACH_SILENCER,
	ANIM_ATTACH_SILENCER,
	ANIM_IDLE_SILENCED,
	ANIM_RELOAD_SILENCED,
	ANIM_DRAW_SILENCED,
	ANIM_SHOOT1_SILENCED,
	ANIM_SHOOT2_SILENCED,
	ANIM_SHOOT3_SILENCED,
	MAXANIMATION
}

enum
{
	KNIFE_ANIM_IDLE = 0,
	KNIFE_ANIM_SLASH1,
	KNIFE_ANIM_SLASH2,
	KNIFE_ANIM_DRAW,
	KNIFE_ANIM_STAB,
	KNIFE_ANIM_STABMISS,
	KNIFE_ANIM_MIDSLASH,
	KNIFE_ANIM_MIDSLASH_MISS,
	KNIFE_ANIM_SLASHBEGIN,
	KNIFE_ANIM_STABBEGIN,
	KNIFE_MAXANIMATION
}

enum
{
	e_iReloadMode = 0,				// 换弹模式，为1的话是M3那种换弹模式
	e_iWeaponSight,					// 机瞄模式，为1的话是开启右键机瞄
	e_iWeaponClip,					// 弹夹子弹
	e_iWeaponAmmo,					// 后备弹
	e_iWeaponCost,					// 价格
	e_iWeaponAmmoCost,				// 子弹价格
	e_iWeaponTeam,					// 购买队伍，1是T，2是CT，0是所有队伍
	e_iWeaponWModelBody,				// W模型子模型的序号（没有的话写0）
	MaxWeaponIntData				// 最大数量
}

enum
{
	e_fWeaponDamage = 0,				// 伤害倍数
	e_fWeaponSpeed,					// 射速
	e_fWeaponAimSpeed,				// 开镜射速
	e_fWeaponSilencedSpeed,				// 消音射速
	e_fWeaponRecoil,				// 后座
	e_fWeaponAimRecoil,				// 开镜后座
	e_fWeaponSilencedRecoil,			// 消音后座
	e_fWeaponAccuracy,				// 精确度
	e_fWeaponAimAccuracy,				// 开镜精确度
	e_fWeaponSilencedAccuracy,			// 消音精确度
	e_fWeaponReloadTime,				// 换弹时间
	e_fWeaponDrawTime,				// 掏出时间
	e_fWeaponMaxSpeed,				// 行走速度
	e_fWeaponAimMaxSpeed,				// 开镜行走速度
	e_fWeaponKnockBack,				// 击退
	e_fSightDistance,				// 镜头距离，开机瞄后的镜头拉近距离，数字越小，拉得越近
	e_fSightFrameRate,				// 镜头变化幅度，每刷新一次镜头时拉近的距离
	e_fSightOpenTime,				// 开启机瞄所需要的时间，建议和模型动作时间保持一致
	e_fSightCloseTime,				// 关闭机瞄所需要的时间，建议和模型动作时间保持一致
	e_fWeaponSilencedTime1,				// 开启消音所需要的时间，建议和模型动作时间保持一致
	e_fWeaponSilencedTime2,				// 关闭消音所需要的时间，建议和模型动作时间保持一致
	e_fWeaponFireSoundVolume,			// 武器开枪声音大小（0.0 <= 数值 <= 1.0）
	e_fWeaponSilenceFireSoundVolume,		// 武器消音开枪声音大小（0.0 <= 数值 <= 1.0）
	e_fShotgunStartReloadTime,			// 散弹换弹开始时间
	e_fShotgunAfterReloadTime,			// 散弹换弹结束时间
	MaxWeaponFloatData				// 最大数量
}

enum
{
	e_fKnifeSlashResetTime = 0,			// 轻击结束时间
	e_fKnifeSlashTime,				// 轻击延迟时间（不写延迟则是直接攻击）
	e_fKnifeSlashRange,				// 轻击距离
	e_fKnifeSlashAngle,				// 轻击角度
	e_fKnifeStabResetTime,				// 重击结束时间
	e_fKnifeStabTime,				// 重击延迟时间（不写延迟则是直接攻击）
	e_fKnifeStabRange,				// 重击距离
	e_fKnifeStabAngle,				// 重击角度
	e_fKnifeDrawTime,				// 掏出时间
	e_fKnifeDamage,					// 伤害倍数
	e_fKnifeDamage2,				// 重击伤害倍数
	e_fKnifeMaxSpeed,				// 行走速度
	e_fKnifeKnockBack,				// 击退
	e_fKnifeSoundVolume1,				// 击墙声音大小（0.0 <= 数值 <= 1.0）
	e_fKnifeSoundVolume2,				// 击空声音大小（0.0 <= 数值 <= 1.0）
	e_fKnifeSoundVolume3,				// 重击声音大小（0.0 <= 数值 <= 1.0）
	e_fKnifeSoundVolume4,				// 轻击声音1大小（0.0 <= 数值 <= 1.0）
	e_fKnifeSoundVolume5,				// 轻击声音2大小（0.0 <= 数值 <= 1.0）
	e_fKnifeSlashAngleOffset,			// 轻击角度判断间隔（建议值：5.0 <= 间隔 <= 轻击角度）
	e_fKnifeStabAngleOffset,			// 重击角度判断间隔（建议值：5.0 <= 间隔 <= 重击角度）
	e_fKnifeSlashHeight,				// 轻击高度（建议值：1.0 <= 高度 <= 50.0）
	e_fKnifeStabHeight,				// 重击高度（建议值：1.0 <= 高度 <= 50.0）
	e_fKnifeSlashHeightOffset,			// 轻击高度判断间隔（建议值：5.0 <= 间隔 <= 轻击高度）
	e_fKnifeStabHeightOffset,			// 重击高度判断间隔（建议值：5.0 <= 间隔 <= 重击高度）
	MaxKnifeFloatData				// 最大数量
}

enum
{
	wpn_iWeaponId = 0,			// 类型：int		介绍：武器ID（CSW_***）
	wpn_szWeaponList,			// 类型：string		介绍：武器SPR（weapon_***.txt）
	wpn_szKillSpr,				// 类型：string		介绍：杀敌SPR
	// ---------------------------------------------------------------------------------------
	// 以下几个修改时注意缓存
	// ---------------------------------------------------------------------------------------
	wpn_iExplodeSprId,			// 类型：int	介绍：爆炸SPR的id
	wpn_szPModel,				// 类型：string	介绍：P模型
	wpn_szVModel,				// 类型：string	介绍：V模型
	wpn_szWModel,				// 类型：string	介绍：W模型
	wpn_szSightModel,			// 类型：string	介绍：机瞄模型
	wpn_szSound1,				// 类型：string	介绍：开枪声音1、爆炸声音、刀子掏出声音
	wpn_szSound2,				// 类型：string	介绍：开枪声音2、刀子击墙声音
	wpn_szSound3,				// 类型：string	介绍：刀子击空声音
	wpn_szSound4,				// 类型：string	介绍：刀子重击声音
	wpn_szSound5,				// 类型：string	介绍：刀子轻击1声音
	wpn_szSound6,				// 类型：string	介绍：刀子轻击2声音
	// ---------------------------------------------------------------------------------------
	wpn_iReloadMode,			// 类型：int	介绍：换弹模式
	wpn_iSightMode,				// 类型：int	介绍：开启机瞄
	wpn_iClip,				// 类型：int	介绍：弹夹子弹
	wpn_iBPAmmo,				// 类型：int	介绍：备用子弹
	wpn_fDamage,				// 类型：float	介绍：伤害倍数
	wpn_fStabDamage,			// 类型：float	介绍：刀子重击伤害倍数
	wpn_fFireSpeed,				// 类型：float	介绍：射速
	wpn_fAimFireSpeed,			// 类型：float	介绍：开镜射速
	wpn_fSilencedFireSpeed,			// 类型：float	介绍：消音射速
	wpn_fRecoil,				// 类型：float	介绍：后座
	wpn_fAimRecoil,				// 类型：float	介绍：开镜后座
	wpn_fSilencedRecoil,			// 类型：float	介绍：消音后座
	wpn_fAccuracy,				// 类型：float	介绍：精确度
	wpn_fAimAccuracy,			// 类型：float	介绍：开镜精确度
	wpn_fSilencedAccuracy,			// 类型：float	介绍：消音精确度
	wpn_fSightDistance,			// 类型：float	介绍：镜头距离
	wpn_fSightFramerate,			// 类型：float	介绍：镜头变化幅度
	wpn_fSightOpenTime,			// 类型：float	介绍：开启速度
	wpn_fSightCloseTime,			// 类型：float	介绍：关闭速度
	wpn_fReloadTime,			// 类型：float	介绍：换弹时间
	wpn_fDrawTime,				// 类型：float	介绍：掏出时间
	wpn_fDetachSilencerTime,		// 类型：float	介绍：拆除消声器时间
	wpn_fAttachSilencerTime,		// 类型：float	介绍：安装消声器时间
	wpn_fSlashResetTime,			// 类型：float	介绍：轻击结束时间
	wpn_fSlashTime,				// 类型：float	介绍：轻击延迟时间
	wpn_fSlashRange,			// 类型：float	介绍：轻击距离
	wpn_fSlashAngle,			// 类型：float	介绍：轻击角度
	wpn_fStabResetTime,			// 类型：float	介绍：重击结束时间
	wpn_fStabTime,				// 类型：float	介绍：重击延迟时间
	wpn_fStabRange,				// 类型：float	介绍：重击距离
	wpn_fStabAngle,				// 类型：float	介绍：重击角度
	wpn_fExpTime,				// 类型：float	介绍：爆炸时间
	wpn_fExpRange,				// 类型：float	介绍：爆炸范围
	wpn_fMaxSpeed,				// 类型：float	介绍：武器最大速度
	wpn_fAimMaxSpeed,			// 类型：float	介绍：武器开镜最大速度
	wpn_fKnockBack,				// 类型：float	介绍：武器击退
	wpn_szCommand,				// 类型：string	介绍：购买命令
	wpn_iCost,				// 类型：int	介绍：价格
	wpn_iAmmoCost,				// 类型：int	介绍：子弹价格
	wpn_iTeam,				// 类型：int	介绍：购买队伍
	wpn_iWModelBody,			// 类型：int	介绍：W模型的子模型序号
	wpn_iAnimIdle,				// 类型：int	介绍：武器静止动作
	wpn_iAnimReload,			// 类型：int	介绍：武器换弹动作
	wpn_iAnimDraw,				// 类型：int	介绍：武器掏出动作
	wpn_iAnimShoot1,			// 类型：int	介绍：武器射击1动作
	wpn_iAnimShoot2,			// 类型：int	介绍：武器射击2动作
	wpn_iAnimShoot3,			// 类型：int	介绍：武器射击3动作
	wpn_iAnimStartReload,			// 类型：int	介绍：武器开始换弹动作
	wpn_iAnimInsert,			// 类型：int	介绍：武器插入子弹动作
	wpn_iAnimAfterReload,			// 类型：int	介绍：武器结束换弹动作
	wpn_iAnimSightOpen,			// 类型：int	介绍：开启机瞄动作
	wpn_iAnimSightClose,			// 类型：int	介绍：关闭机瞄动作
	wpn_iAnimSilencedIdle,			// 类型：int	介绍：武器消音静止动作
	wpn_iAnimSilencedReload,		// 类型：int	介绍：武器消音换弹动作
	wpn_iAnimSilencedDraw,			// 类型：int	介绍：武器消音掏出动作
	wpn_iAnimSilencedShoot1,		// 类型：int	介绍：武器消音射击1动作
	wpn_iAnimSilencedShoot2,		// 类型：int	介绍：武器消音射击2动作
	wpn_iAnimSilencedShoot3,		// 类型：int	介绍：武器消音射击3动作
	wpn_iAnimDetachSilencer,		// 类型：int	介绍：拆除消声器动作
	wpn_iAnimAttachSilencer,		// 类型：int	介绍：安装消声器动作
	wpn_iKnifeAnimIdle,			// 类型：int	介绍：刀子静止动作
	wpn_iKnifeAnimSlash1,			// 类型：int	介绍：刀子轻击1动作
	wpn_iKnifeAnimSlash2,			// 类型：int	介绍：刀子轻击2动作
	wpn_iKnifeAnimDraw,			// 类型：int	介绍：刀子掏出动作
	wpn_iKnifeAnimStab,			// 类型：int	介绍：刀子重击动作
	wpn_iKnifeAnimStabMiss,			// 类型：int	介绍：刀子重击miss动作
	wpn_iKnifeAnimMidslash,			// 类型：int	介绍：刀子轻击动作
	wpn_iKnifeAnimMidslashMiss,		// 类型：int	介绍：刀子轻击miss动作
	wpn_iKnifeAnimSlashBegin,		// 类型：int	介绍：刀子轻击延迟动作
	wpn_iKnifeAnimStabBegin,		// 类型：int	介绍：刀子重击延迟动作
	// ---------------------------------------------------------------------------------------
	// 下面这些我不知道能不能用上。。但是还是弄了几个
	// ---------------------------------------------------------------------------------------
	wpn_iUser1,				// 类型：int	介绍：储存整型数据
	wpn_iUser2,				// 类型：int	介绍：储存整型数据
	wpn_iUser3,				// 类型：int	介绍：储存整型数据
	wpn_iUser4,				// 类型：int	介绍：储存整型数据
	wpn_fUser1,				// 类型：float	介绍：储存浮点型数据
	wpn_fUser2,				// 类型：float	介绍：储存浮点型数据
	wpn_fUser3,				// 类型：float	介绍：储存浮点型数据
	wpn_fUser4,				// 类型：float	介绍：储存浮点型数据
	wpn_szUser1,				// 类型：string	介绍：储存字符串数据
	wpn_szUser2,				// 类型：string	介绍：储存字符串数据
	wpn_szUser3,				// 类型：string	介绍：储存字符串数据
	wpn_szUser4,				// 类型：string	介绍：储存字符串数据
	// ---------------------------------------------------------------------------------------
	wpn_iAmount,				// 类型：int	介绍：当前注册的武器数量（该参数不可更改 玩家id和武器序号参数被忽略）
	wpn_ID,					// 类型：int	介绍：获取当前武器的序号（该参数不可更改 玩家id填实体id，如果是模板注册则武器序号填模板序号，玩家id填武器slot：SLOT_WEAPON、SLOT_KNIFE、SLOT_GRENADE）
	wpn_iBloodColor,			// 类型：int	介绍：血液颜色（玩家id和武器序号参数被忽略）
	wpn_AllTeamBuy,				// 类型：int	介绍：武器所有队伍购买（玩家id和武器序号参数被忽略）
	wpn_SetBuy,				// 类型：int	介绍：购买限制设置（武器序号参数被忽略，一共三种：BUY_NORMALLY、BUY_CANNOT、BUY_EVERYWHERE，分别是正常购买，不能购买，任何地区购买）
	wpn_iUserSight,				// 类型：int	介绍：获取玩家的机瞄状态（该参数不可修改，武器序号参数被忽略）
	wpn_iBotMoney,				// 类型：int	介绍：获取或修改BOT的金钱（武器序号参数被忽略）
	// ---------------------------------------------------------------------------------------
	// CSSTE额外添加的
	// ---------------------------------------------------------------------------------------
	wpn_iGameWeaponBPAmmo,			// 类型：int	介绍：原版武器的最大后备弹药量（武器序号填武器类型CSW_*）
	wpn_fDamagePoint,			// 类型：float	介绍：攻击者的伤害倍数（武器序号参数被忽略）
	wpn_fKnockBackPoint,			// 类型：float	介绍：受害者的击退倍数（武器序号参数被忽略）
	wpn_iCurWeaponBPAmmo,			// 类型：int	介绍：添加的武器的当前后背弹药量
	wpn_iGameCurWeaponBPAmmo,		// 类型：int	介绍：原版武器的当前后背弹药量（武器序号填武器类型CSW_*）
	wpn_iUserMoney,				// 类型：int	介绍：玩家当前的金钱（获取时：武器序号参数被忽略；设置时：武器序号参数为1则显示添加了多少钱，为0时则不显示添加了多少钱）
	wpn_iMaxMoney,				// 类型：int	介绍：最大金钱数（玩家id和武器序号参数被忽略）
	wpn_fDamageVictimPoint,			// 类型：float	介绍：受害者的伤害倍数（武器序号参数被忽略）
	wpn_iAttackEntity,			// 类型：int	介绍：伤害的实体id（不建议使用！乱用会出现bug）
	wpn_iHitGroup,				// 类型：int	介绍：攻击者伤害到的位置（仅限于WPN_ExecuteAttack进行伤害时，该参数只能被修改，无法被获取）
	// ---------------------------------------------------------------------------------------
	wpn_fFireSoundVolume,			// 类型：float	介绍：开枪的声音大小，手雷爆炸的声音大小（取值：0.0 <= 数值 <= 1.0）
	wpn_fSilenceFireSoundVolume,		// 类型：float	介绍：武器消音状态下开枪声音大小（取值：0.0 <= 数值 <= 1.0）
	wpn_fKnifeSoundVolume1,			// 类型：float	介绍：击墙声音大小（0.0 <= 数值 <= 1.0）
	wpn_fKnifeSoundVolume2,			// 类型：float	介绍：击空声音大小（0.0 <= 数值 <= 1.0）
	wpn_fKnifeSoundVolume3,			// 类型：float	介绍：重击声音大小（0.0 <= 数值 <= 1.0）
	wpn_fKnifeSoundVolume4,			// 类型：float	介绍：轻击声音1大小（0.0 <= 数值 <= 1.0）
	wpn_fKnifeSoundVolume5,			// 类型：float	介绍：轻击声音2大小（0.0 <= 数值 <= 1.0）
	wpn_fShotgunStartReloadTime,		// 类型：float	介绍：散弹开始换弹的时间
	wpn_fShotgunAfterReloadTime,		// 类型：float	介绍：散弹结束换弹的时间
	wpn_fKnifeSlashAngleOffset,		// 类型：float	介绍：轻击角度判断间隔（建议值：5.0 <= 间隔 <= 轻击角度）
	wpn_fKnifeStabAngleOffset,		// 类型：float	介绍：重击角度判断间隔（建议值：5.0 <= 间隔 <= 重击角度）
	wpn_fKnifeSlashHeight,			// 类型：float	介绍：轻击高度（建议值：1.0 <= 高度 <= 50.0）
	wpn_fKnifeStabHeight,			// 类型：float	介绍：重击高度（建议值：1.0 <= 高度 <= 50.0）
	wpn_fKnifeSlashHeightOffset,		// 类型：float	介绍：轻击高度判断间隔（建议值：5.0 <= 间隔 <= 轻击高度）
	wpn_fKnifeStabHeightOffset,		// 类型：float	介绍：重击高度判断间隔（建议值：5.0 <= 间隔 <= 重击高度）
}