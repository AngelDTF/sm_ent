#include <sdkhooks>
#include <sdktools>
#include <sourcemod>

#pragma newdecls required
#pragma semicolon 1

public Plugin myinfo =
{
	name        = "[~] SM_Ent Functions",
	author      = "Angel Bot [Owner of DemonstrationTF]",
	description = "Proper entity functions (like ent_fire) for servers",
	version     = "0.1",
	url         = "https://steamcommunity.com/id/101smech101"
}

public void OnPluginStart()
{
	RegAdminCmd("sm_ent_fire", Ent_Fire, ADMFLAG_CHEATS);
}

public Action Ent_Fire(int client, int args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_ent_fire <target> [action] [value]");
		return Plugin_Handled;
	}

	const int size = 64;
	char strArg1[size], strArg2[size], strArg3[size];
	GetCmdArg(1, strArg1, size);
	GetCmdArg(2, strArg2, size);
	GetCmdArg(3, strArg3, size);

	int targets[2049];
	for (int i = 0; i < sizeof(targets); i++) targets[i] = -1;
	if (StrEqual(strArg1, "!picker")) targets[0] = GetClientAimTarget(client, false);
	else if (StrEqual(strArg1, "!self")) targets[0] = client;
	else
	{
		int i = 0, ent = -1;
		while ((ent = FindEntityByClassname(ent, "*")) != -1)
		{
			if (IsValidEdict(ent))
			{
				char strClassName[128], strEntName[128];
				GetEntityClassname(ent, strClassName, sizeof(strClassName));
				GetEntPropString(ent, Prop_Data, "m_iName", strEntName, sizeof(strEntName));

				if (StrEqual(strArg1, strClassName) || StrEqual(strArg1, strEntName))
				{
					targets[i] = ent;
					i++;
				}
			}
		}
	}
	for (int i = 0; i < sizeof(targets) && targets[i] != -1; i++)
	{
		if (args >= 3)
		{
			if (StrEqual(strArg3, "!player")) SetVariantEntity(client);
			else SetVariantString(strArg3);
		}
		else SetVariantString("");
		AcceptEntityInput(targets[i], strArg2, client);
	}
	return Plugin_Handled;
}
