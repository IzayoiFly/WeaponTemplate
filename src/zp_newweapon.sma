/* Amxx编写头版 来自 Aperture Science Team【光圈科技战队】 */

#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>

#include <newweapon>
#include <zombieplague>

#define PLUGINNAME		"加枪模板 & ZP4.3 兼容插件"
#define VERSION			"1.0"
#define AUTHOR			"Fly"

#define AMMO_COST1		100
#define AMMO_COST2		100

// 购买子弹的道具id
new g_iAmmoId[2]

// 购买武器的道具id
new g_iItemId[MAXWEAPON]

public plugin_init()
{
	register_plugin(PLUGINNAME, VERSION, AUTHOR)
	register_forward(FM_PlayerPostThink, "fw_PlayerPostThink_Post", 1)

	// 取消所有玩家的购买
	for (new id = 1; id < 33; id ++) WPN_SetParamInt(0, id, wpn_SetBuy, BUY_CANNOT)

	// 注册两个购买子弹的道具
	g_iAmmoId[0] = zp_register_extra_item("主武器弹药", AMMO_COST1, ZP_TEAM_HUMAN)
	g_iAmmoId[1] = zp_register_extra_item("副武器弹药", AMMO_COST2, ZP_TEAM_HUMAN)

	// 将每把武器都注册为ZP道具，购买命令为empty的除外
	new iAmount = WPN_GetParamInt(0, 0, wpn_iAmount)
	new szWeaponName[64], szWeaponCmd[64], iCost
	for (new i = 1; i <= iAmount; i ++)
	{
		WPN_GetParamString(i, 1, wpn_szCommand, szWeaponCmd, charsmax(szWeaponCmd))
		if (!strcmp(szWeaponCmd, "empty") || !szWeaponCmd[0])
		continue

		WPN_GetParamString(i, 1, wpn_szUser1, szWeaponName, charsmax(szWeaponName))
		iCost = WPN_GetParamInt(i, 1, wpn_iCost)
		g_iItemId[i] = zp_register_extra_item(szWeaponName, iCost, ZP_TEAM_HUMAN)
	}
}

// 武器名字储存在wpn_szUser1里
public WPN_LoadFiles(iSlot, i, key[], value[])
{
	if (!strcmp(key, "武器名字"))
	{
		for (new id = 1; id < 33; id ++)
			WPN_SetParamString(i, id, wpn_szUser1, value)
	}
}

// 打断BOT的购买
public WPN_BotBuyWeapon(id)
{
	return WPN_SUPERCEDE
}

// debug处理，BOT如果使用弹药袋购买原版武器会导致游戏崩溃
public fw_PlayerPostThink_Post(id)
{
	if (!is_user_connected(id))
	return

	if (!is_user_bot(id))
	return

	if (zp_get_user_ammo_packs(id) > 0) zp_set_user_ammo_packs(id, 0)
}

public zp_extra_item_selected(id, itemid)
{
	new iEntity, i
	if (itemid == g_iAmmoId[0])
	{
		iEntity = get_pdata_cbase(id, 368)
		if (pev_valid(iEntity))
		{
			i = WPN_GetParamInt(0, iEntity, wpn_ID)
			WPN_GiveAmmo(id, iEntity, i, 1)
		}
		else return PLUGIN_HANDLED
	}
	else if (itemid == g_iAmmoId[1])
	{
		iEntity = get_pdata_cbase(id, 369)
		if (pev_valid(iEntity))
		{
			i = WPN_GetParamInt(0, iEntity, wpn_ID)
			WPN_GiveAmmo(id, iEntity, i, 1)
		}
		else return PLUGIN_HANDLED
	}
	else
	{
		new iAmount = WPN_GetParamInt(0, 0, wpn_iAmount)
		for (i = 1; i <= iAmount; i ++)
		{
			if (g_iItemId[i] != itemid)
			continue

			iEntity = WPN_GiveWeapon(id, i)
			WPN_GiveAmmo(id, iEntity, i, 1)
		}
	}
	return PLUGIN_CONTINUE
}