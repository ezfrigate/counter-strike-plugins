#include <amxmodx>
#include <engine>

new const g_MaxPlayers = 32;

new g_bRestrictAccess = 0;
new g_SteamIDs[g_MaxPlayers][STEAM_ID_LENGTH + 1];

// Plugin initialization
public plugin_init()
{
    register_plugin("SteamID Access Control", "1.3", "SB");

    register_clcmd("enablerr", "EnableAccessCommand");
    register_clcmd("disablerr", "DisableAccessCommand");
    register_event("PlayerConnect", "PlayerConnect_EventHandler", "a");
    register_event("SelectMenu", "SelectMenu_EventHandler", "b");
}

// EnableAccess command
public EnableAccessCommand(id)
{
    if (!is_user_admin(id))
    {
        client_print(id, print_chat, "You don't have permission to use this command.");
        return PLUGIN_HANDLED;
    }

    g_bRestrictAccess = 1;

    for (new i = 1; i <= get_playersnum(); i++)
    {
        new szSteamID[STEAM_ID_LENGTH];
        get_user_info(i, infosteamid, szSteamID, sizeof(szSteamID));

        copy(szSteamID, g_SteamIDs[i], sizeof(g_SteamIDs[i]));
    }

    client_print(id, print_chat, "Access restricted to players with Steam IDs.");
    return PLUGIN_HANDLED;
}

// DisableAccess command
public DisableAccessCommand(id)
{
    if (!is_user_admin(id))
    {
        client_print(id, print_chat, "You don't have permission to use this command.");
        return PLUGIN_HANDLED;
    }

    g_bRestrictAccess = 0;

    for (new i = 1; i <= get_playersnum(); i++)
    {
        g_SteamIDs[i][0] = '\0';
    }

    client_print(id, print_chat, "Access restriction lifted.");
    return PLUGIN_HANDLED;
}

// PlayerConnect event handler
public PlayerConnect_EventHandler(id)
{
    if (g_bRestrictAccess)
    {
        new szSteamID[STEAM_ID_LENGTH];
        get_user_info(id, infosteamid, szSteamID, sizeof(szSteamID));

        for (new i = 1; i <= get_playersnum(); i++)
        {
            if (equal(g_SteamIDs[i], szSteamID, true))
            {
                return PLUGIN_CONTINUE;
            }
        }

        client_cmd(id, "menuselect %d", MENU_TEAM_SPECT);
        client_print(id, print_chat, "You are not allowed to join a team.");
        return PLUGIN_HANDLED;
    }

    return PLUGIN_CONTINUE;
}

// SelectMenu event handler
public SelectMenu_EventHandler(id, menu, item)
{
    if (g_bRestrictAccess && (menu == MENU_TEAM))
    {
        client_cmd(id, "menuselect %d", MENU_TEAM_SPECT);
        return PLUGIN_HANDLED;
    }

    return PLUGIN_CONTINUE;
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/
