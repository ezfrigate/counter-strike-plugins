#include < amxmodx >
#define MAX_PLAYERS 32

new g_bWarRestricted = false;
new g_iSteamIDs[MAX_PLAYERS][32]; // Assuming a maximum of 32 steam ID characters

// Function to be called when the plugin is loaded
public plugin_init()
{
    register_plugin("War Lock Plugin", "1.0", "SB");
    register_clcmd("lockwar", "cmd_restrictwar", ADMIN_CHAT, "startRestrict");
    register_clcmd("unlockwar", "cmd_unrestrictwar", ADMIN_CHAT, "stopRestrict");


    // Hook the client_connect function
    register_event("ClientConnect", "client_connect", "a", "1=0");
}

// Function to add a Steam ID to the global array
public AddSteamIDToRestrictionArray(id[])
{
    new index = 0;
    while (index < MAX_PLAYERS)
    {
        if (g_iSteamIDs[index][0] == 0)
        {
            format(g_iSteamIDs[index], strlen(g_iSteamIDs[index]), "%s", id);
            break;
        }
        index++;
    }
}

// Function to clear the global array
public ClearRestrictionArray()
{
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        g_iSteamIDs[i][0] = 0;
    }
}

// Function to check if a player's Steam ID is in the array
public IsSteamIDRestricted(id[])
{
    new index = 0;
    while (index < MAX_PLAYERS)
    {
        if (equal(g_iSteamIDs[index], id, false))
            return true;

        index++;
    }
    return false;
}

// AMXX command to add a player's Steam ID to the restriction array
public cmd_restrictwar(id)
{
    g_bWarRestricted = true;
    if (g_bWarRestricted)
    {
        new steamid[32];
        get_user_authid(id, steamid, sizeof(steamid));
        AddSteamIDToRestrictionArray(steamid);
        client_print(id, print_chat, "Your Steam ID (%s) has been added to the war list.", steamid);
        client_print(id, print_chat, "Ab bhadvo ko aane do late.");
    }
    return PLUGIN_HANDLED;
}

// AMXX command to clear the restriction array
public cmd_unrestrictwar(id)
{
    g_bWarRestricted = false;
    ClearRestrictionArray();
    client_print(id, print_chat, "The lock list has been cleared.");
    return PLUGIN_HANDLED;
}

// Function to be called when a player connects
public client_connect(id)
{
    new steamid[32];
    get_user_authid(id, steamid, sizeof(steamid));

    if (g_bWarRestricted && !IsSteamIDRestricted(steamid))
    {
        client_print(id, print_center, "You are not allowed to join due to war lock.");
        client_cmd(id, "disconnect");
    }
    return PLUGIN_CONTINUE;
}