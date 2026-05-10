#define FILTERSCRIPT

#include <a_samp>


public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Filterscript: LOG Acildi.");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new textlog[120];
	new Oyuncu[MAX_PLAYER_NAME];
	GetPlayerName(playerid, Oyuncu, sizeof(Oyuncu));
	format(textlog,sizeof(textlog),"%s: %s",Oyuncu,text);
	print(textlog);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new komutlog[120];
	new Oyuncu[MAX_PLAYER_NAME];
	GetPlayerName(playerid, Oyuncu, sizeof(Oyuncu));
	format(komutlog,sizeof(komutlog),"%s adli oyuncu %s adli komutu kullandi!",Oyuncu,cmdtext);
	print(komutlog);
	return 0;
}


