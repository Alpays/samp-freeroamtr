/*
By Alpays 

Ekledigi Seyler:
	GivePlayerScore(oyuncuid, skor) -> Skor verir.
	SetPlayerMoney(oyuncuid, skor) -> Para belirler.
	AracIDKontrol(arac) -> Arac IDsini kontrol eder.
	Bellibirbolgedemi(oyuncuid, MaksimumX, MinimumX, MaksimumY, MinimumY) -> Oyuncu kare bir bolgenin icersindemi (Minigamelerde kullanmak icin)
*/

#include <a_samp>

#if !defined alpays_inc
#define alpays_inc

GivePlayerScore(playerid, score)
{
	SetPlayerScore(playerid, GetPlayerScore(playerid) + score);
}

SetPlayerMoney(playerid, miktar)
{
	GivePlayerMoney(playerid, -GetPlayerMoney(playerid));
	GivePlayerMoney(playerid, miktar);
}
	
AracIDKontrol(id)
{
	switch(id)
	{
	case 400..612:
	{
	    return 1;
	}
	}
	return 0;
}

Bellibirbolgedemi(playerid, MaksimumX, MinimumX, MaksimumY, MinimumY)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	if(x > MinimumX && x < MaksimumX && y > MinimumY && y < MaksimumY)
	{
		return 1;
	}
	else return 0;
}

Pickupyoket(pickupid)
{
	DestroyPickup(pickupid);
	pickupid = 0;
}

#endif
