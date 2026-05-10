/*

Alpay's Freeroam | 2020 
Samp Sürümü: 0.3.7

Yapýmcýlar:
	Alpays Gamemode, "../Kutuphane" includeleri, Mapler ve Log filterscripti
	denizcicocuk Fuar mapi


Gereken pluginler

	sscanf2
	whirlpool
	FCNPC


Gereken includeler
	a_samp
	a_actor
	sscanf2
	zcmd
	mSelection
	FCNPC
	Alpays
	renkler


Özellikleri
----------
43 NPC (30 NPC,10 FCNPC,3 Aktör)
10 Yarýþ
8 Ölüm Maçý
4 Takýmlý Ölüm Maçý
3 Derbi
3 Stunt
Stunt,Fuar mapleri
Sýnýrsýz Nitro Gökkuþaðý silah menüsü gibi bir çok freeroam özelliði
-----------

*/


/* Ýncludeler */
#include <a_samp>
#include <a_actor>
#include <sscanf2>
#include <zcmd.inc>
#include <mSelection.inc>
#include <FCNPC>

/* Bu oyunmodunun includeleri! */
#include "../Kutuphane/alpays.inc"
#include "../Kutuphane/renkler.inc"

native WP_Hash(buffer[], len, const str[]);

enum Oyuncu
{
 //Kaydedilen þeyler 
 Hesap_ID,
 Hesap_Adi[MAX_PLAYER_NAME],
 Hesap_Sifre[129],
 Hesap_Admin,
 Para,
 Skor,
 Oldurmeler,
 Olumler,
 Yariskazanma,
 Tomkazanma,

 //Kaydedilmeyenler
 bool:tp,
 derbiarac,
 nitro,
 gokkusagi,
 spawn,
 skin,
 arac,
 oyunmodu,
 spree,
 Yaris_SahilCP,
 Yaris_KoyTuruCP,
 Yaris_VinewoodCP,
 Yaris_LSOtoyolCP,
 Yaris_LVYarisiCP,
 Yaris_ColCP,
 Yaris_DenizkenariCP,
 Yaris_SanFierroCP,
 Yaris_UcagayetisCP,
 Yaris_SanAndreasCP,
 tamir
};

enum
{
	LS,
	SF,
	LV
};

enum //Iþýnlanma menüsü
{
	i_grove,
	i_sfgaraj,
	i_fourdragon,
	i_dag,
	i_area69,
	i_locolow,
	i_transfender,
	i_wheelarc
};

forward Yaris_Sahil_Baslat();
forward Yaris_KoyTuru_Baslat();
forward Yaris_Vinewood_Baslat();
forward Yaris_LSOtoyol_Baslat();
forward Yaris_LVYarisi_Baslat();
forward Yaris_Col_Baslat();
forward Yaris_Denizkenari_Baslat();
forward Yaris_SanFierro_Baslat();
forward Yaris_Ucagayetis_Baslat();
forward Yaris_SanAndreas_Baslat();

forward SaatAyar();
forward Gokkusagi(playerid);

forward TOM_CeteSavasi_Baslat();
forward TOM_CeteSavasi_Kapat(sebep);
forward TOM_CeteSavasi_ZamanDolumu();
forward TOM_CeteSavasi_Pickupolustur();

forward TOM_LSSavasi_Baslat();
forward TOM_LSSavasi_Kapat(sebep);
forward TOM_LSSavasi_ZamanDolumu();
forward TOM_LSSavasi_Pickupolustur();

forward TOM_Lunapark_Baslat();
forward TOM_Lunapark_Kapat(sebep);
forward TOM_Lunapark_ZamanDolumu();
forward TOM_Lunapark_Pickupolustur();


forward TOM_Gemi_Baslat();
forward TOM_Gemi_Kapat(sebep);
forward TOM_Gemi_ZamanDolumu();
forward TOM_Gemi_Pickupolustur();

forward tamirSure(playerid);

#define Arac_Diyalog 		1
#define Silah_Diyalog		2
#define Isinlanma_Diyalog 	3
#define Esya_Diyalog 		4
#define Anim_Diyalog 		5
#define Dovus_Diyalog		6
#define Olummaci_Diyalog 	7
#define Yaris_Diyalog 		8
#define Tom_Diyalog 		9
#define Spawn_Diyalog 		10
#define Derbi_Diyalog 		11
#define Komut_Diyalog 		12
#define Stunt_Diyalog 		13
#define Kayit_Diyalog 		14
#define Giris_Diyalog 		15
#define Istatistik_Diyalog  16
#define Ban_Diyalog         17
#define Mg_Diyalog          18
#define Gorev_Diyalog       19

main()
{
	print("--------------------------------------");
	print("Freeroam modu yuklendi yapimci: Alpays");
	print("--------------------------------------");
}


//Oyun Modlarý oyuncu için
#define Freeroam 			0

#define OM_Istasyon 		1
#define OM_Minigun 			2
#define OM_TekVurus 		3
#define OM_Grove 			4
#define OM_Area69 			5
#define OM_Pier69 			6
#define OM_Rpg 				7
#define OM_Jetpack 			8

#define Yaris_Sahil 		9
#define Yaris_KoyTuru 		10
#define Yaris_Vinewood 		11
#define Yaris_LSOtoyol 		12
#define Yaris_LVYarisi 		13
#define Yaris_Col 		  	14
#define Yaris_Denizkenari 	15
#define Yaris_SanFierro 	16
#define Yaris_Ucagayetis    17
#define Yaris_SanAndreas    18

#define TOM_CeteSavasi      19
#define TOM_LSSavasi        20
#define TOM_Lunapark        21
#define TOM_Gemi            22

#define Derbi_Hava 			23
#define Derbi_Hava2 		24
#define Derbi_Hava3 		25

#define Gorev_Saldiri       27
#define Gorev_Area69        28




//Takýmlý Ölüm maçý takýmlarý
#define Takim_Grove 	1 			//Çete Savaþý
#define Takim_Ballas 	2 			//Çete Savaþý
#define Takim_Mavi 		3 			//LS Savaþý
#define Takim_Kirmizi 	4 			//LS Savaþý
#define Takim_Beyaz 	5 			//Lunapark Savaþý
#define Takim_Siyah 	6 			//Lunapark Savaþý
#define Takim_Aztecas   7           //Gemi
#define Takim_Vagos     8           //Gemi


//Takýmlý Ölüm Maçý - Kapatma
#define TOM_CeteSavasi_Azkisi 1
#define TOM_CeteSavasi_Grove_Kazan 2 
#define TOM_CeteSavasi_Ballas_Kazan 3
#define TOM_CeteSavasi_Cikis 4
#define TOM_CeteSavasi_Berabere 5

#define TOM_LSSavasi_Azkisi 1
#define TOM_LSSavasi_Mavi_Kazan 2
#define TOM_LSSavasi_Kirmizi_Kazan 3
#define TOM_LSSavasi_Cikis 4
#define TOM_LSSavasi_Berabere 5

#define TOM_Lunapark_Azkisi 1
#define TOM_Lunapark_Beyaz_Kazan 2
#define TOM_Lunapark_Siyah_Kazan 3
#define TOM_Lunapark_Cikis 4
#define TOM_Lunapark_Berabere 5

#define TOM_Gemi_Azkisi 1
#define TOM_Gemi_Aztecas_Kazan 2
#define TOM_Gemi_Vagos_Kazan   3
#define TOM_Gemi_Cikis 4
#define TOM_Gemi_Berabere 5



#define Yaris_Parasi 	3500
#define Tom_Parasi 		2500


//Takýmlý Ölüm Maçý sýnýrlar

#define Tom_Cetesavasi_MaxX 	2539
#define Tom_Cetesavasi_MaxY 	-1469
#define Tom_Cetesavasi_MinX 	2337
#define Tom_Cetesavasi_MinY 	-1756


#define Tom_LSSavasi_MaxX 		1339
#define Tom_LSSavasi_MaxY 		-1055
#define Tom_LSSavasi_MinX 		795
#define Tom_LSSavasi_MinY 		-1279


#define Tom_Lunapark_MaxX 		421
#define Tom_Lunapark_MaxY 		-1780
#define Tom_Lunapark_MinX 		339
#define Tom_Lunapark_MinY 		-2095


#define Tom_Gemi_MaxX 			-1470
#define Tom_Gemi_MaxY 			146
#define Tom_Gemi_MinX 			-1600
#define Tom_Gemi_MinY 			39



new stat[MAX_PLAYERS][Oyuncu];

new spreemsj[MAX_PLAYER_NAME];

new Yaris_Sahil_Kazanan[MAX_PLAYER_NAME];
new Yaris_Sahil_Sayi = 0;
new bool:Yaris_SahilDurum = false;

new Yaris_KoyTuru_Kazanan[MAX_PLAYER_NAME];
new Yaris_KoyTuru_Sayi = 0;
new bool:Yaris_KoyTuruDurum = false;

new Yaris_Vinewood_Kazanan[MAX_PLAYER_NAME];
new Yaris_Vinewood_Sayi = 0;
new bool:Yaris_VinewoodDurum = false;

new Yaris_LSOtoyol_Kazanan[MAX_PLAYER_NAME];
new Yaris_LSOtoyol_Sayi = 0;
new bool:Yaris_LSOtoyolDurum = false;

new Yaris_LVYarisi_Kazanan[MAX_PLAYER_NAME];
new Yaris_LVYarisi_Sayi = 0;
new bool:Yaris_LVYarisiDurum = false;

new Yaris_Col_Kazanan[MAX_PLAYER_NAME];
new Yaris_Col_Sayi = 0;
new bool:Yaris_ColDurum = false;

new Yaris_Denizkenari_Kazanan[MAX_PLAYERS];
new Yaris_Denizkenari_Sayi = 0;
new bool:Yaris_DenizkenariDurum = false;

new oyuncu[MAX_PLAYER_NAME];

new Yaris_SanFierro_Kazanan[MAX_PLAYER_NAME];
new Yaris_SanFierro_Sayi = 0;
new bool:Yaris_SanFierroDurum = false;

new Yaris_Ucagayetis_Kazanan[MAX_PLAYER_NAME];
new Yaris_Ucagayetis_Sayi = 0;
new bool:Yaris_Ucagayetis_Durum = false;

new Yaris_SanAndreas_Kazanan[MAX_PLAYER_NAME];
new Yaris_SanAndreas_Sayi = 0;
new bool:Yaris_SanAndreas_Durum = false;

new Aktor1;
new Aktor2;

new strings[256];

new Saat = 12;
new minigun;

new bool:TOM_CeteSavasi_Durum = false;
new TOM_CeteSavasi_Grove_Sayi = 0;
new TOM_CeteSavasi_Ballas_Sayi = 0;
new TOM_CeteSavasi_Grove_Alan;
new TOM_CeteSavasi_Ballas_Alan;
new TOM_CeteSavasi_Grove_Skor = 0;
new TOM_CeteSavasi_Ballas_Skor = 0;
new TOM_CeteSavasi_TIMELIMIT;
new TOM_CeteSavasi_Pickup;

new bool:TOM_LSSavasi_Durum = false;
new TOM_LSSavasi_Mavi_Sayi = 0;
new TOM_LSSavasi_Kirmizi_Sayi = 0;
new TOM_LSSavasi_Mavi_Skor = 0;
new TOM_LSSavasi_Kirmizi_Skor = 0;
new TOM_LSSavasi_TIMELIMIT;
new TOM_LSSavasi_Pickup;

new bool:TOM_Lunapark_Durum = false;
new TOM_Lunapark_Beyaz_Sayi = 0;
new TOM_Lunapark_Siyah_Sayi = 0;
new TOM_Lunapark_Beyaz_Skor = 0;
new TOM_Lunapark_Siyah_Skor = 0;
new TOM_Lunapark_TIMELIMIT;
new TOM_Lunapark_Pickup;

new bool:TOM_Gemi_Durum = false;
new TOM_Gemi_Aztecas_Sayi = 0;
new TOM_Gemi_Vagos_Sayi = 0;
new TOM_Gemi_Aztecas_Skor = 0;
new TOM_Gemi_Vagos_Skor = 0;
new TOM_Gemi_TIMELIMIT;
new TOM_Gemi_Pickup;

new bool:Gorev_Saldiri_Durum = false;
new Gorev_Saldiri_Sayi = 0;




new Float:LSSpawn[9][3] =
{
	{2780.7102,		-1990.5017,		13.0074},
	{2639.7659,		-1637.0486,		10.3363},
	{2348.5671,		-1380.5153,		23.4499},
	{2173.8799,		-1010.6321,		62.4191},
	{2415.8013,		-1972.1516,		13.0406},
	{937.2268,		-1856.3602,		10.2302},
	{367.6178,		-2022.6868,		7.2968},
	{405.2184,		-1468.4705,		30.5574},
	{235.3810,		-1512.8159,		20.4539}
};

new Float:SFSpawn[8][3] =
{
	{-2050.6958,	-570.8620,		29.0686},
	{-2244.9619,	-367.3235,		51.0156},
	{-2020.2419,	151.2994,		28.4754},
	{-1982.0525,	828.7509,		45.4453},
	{-1891.1873,	826.0076,		35.1719},
	{-1700.9873,	1182.6050,		24.9029},
	{-1704.1649,	1339.5544,		7.1812},
	{-2591.1069,	1361.5331,		7.1561}
};

new Float:LVSpawn[7][3] =
{
	{1585.3081,		1128.9324,		10.6719},
	{2039.7557,		1076.3168,		10.6719},
	{2036.6128,		1694.4423,		10.8203},
	{2207.8977,		1899.4304,		10.8203},
	{2365.1094,		2039.5631,		10.8234},
	{2533.9392,		2401.8428,		10.8203},
	{2044.7877,		2445.8613,		10.8203}
};

new Float:OMSpawn[][3] =
{
	{1773.7684,		-1987.6083,		14.1172},
	{1705.7181,		-1984.4268,		14.1172},
	{1717.9344,		-1979.1232,		14.1172},
	{1731.2491,		-1995.3058,		14.1172},
	{1710.5522,		-1955.4841,		13.5391}
};

new Float:OM_MinigunSpawn[][3] =
{
	{1801.6034,		-1042.5261,		23.9609},
	{1784.5841,		-1060.4088,		23.9609},
	{1755.2096,		-1027.1208,		23.9609},
	{1730.5012,		-1060.1425,		23.9439},
	{1734.9963,		-1028.7130,		23.9631}
};

new Float:OM_TekVurusSpawn[][3] =
{
	{2768.9453,		476.0178,		8.2898},
	{2766.5010,		424.4140,		8.2898},
	{2763.8540,		438.0545,		8.2905},
	{2764.8516,		505.8633,		8.2898}
};

new Float:OM_GroveSpawn[][3] =
{
	{2512.6873,		-1674.0555,		13.5101},
	{2493.7427,		-1683.5809,		13.3381},
	{2472.0791,		-1683.3831,		13.4718},
	{2454.2686,		-1660.7185,		13.3047},
	{2461.6550,		-1649.5725,		13.4550}
};

new Float:OM_Area69Spawn[][3] =
{
	{211.7612,		1875.6068,		13.1470},
	{176.0318,		1917.8450,		18.0920},
	{162.2884,		1930.5018,		33.8984},
	{249.0086,		1819.9437,		17.6406},
	{129.4318,		1828.3265,		17.6481}
};

new Float:OM_Pier69Spawn[][3] =
{
	{-1689.8203,	1362.7197,		9.8047},
	{-1653.8142,	1408.0144,		9.8047},
	{-1649.4897,	1394.1301,		7.1722},
	{-1620.9651,	1412.6469,		7.1853},
	{-1644.2031,	1424.9827,		7.1875}
};

new Float:OM_RpgSpawn[][3] =
{
	{133.6470,		1428.3624,		26.2464},
	{134.2324,		1455.2440,		25.8400},
	{162.6639,		1430.0212,		25.7918},
	{165.0027,		1394.0267,		26.1328},
	{166.0374,		1360.0060,		26.1013},
	{194.9760,		1396.3077,		43.0946}
};

new Float:OM_JetpackSpawn[][3] =
{
	{1550.9363,		-1341.5157,		329.4572},
	{1553.6727,		-1354.4387,		329.4586},
	{1544.2930,		-1372.4508,		329.4598}
};

new Float:Yaris_SahilCheckpoint[][3] =
{
	{985.1191,		-1839.7731,		12.6132},
	{889.0772,		-1826.0104,		11.9923},
	{793.2543,		-1814.8268,		13.0234},
	{711.8596,		-1808.0729,		12.4652},
	{649.6800,		-1822.4023,		6.0625},
	{469.6898,		-1778.3766,		5.7667},
	{378.2703,		-1805.9252,		7.8380},
	{369.3548,		-1752.4718,		14.7700},
	{338.6484,		-1645.6605,		33.1044},
	{235.3608,		-1592.1362,		33.0623},
	{245.0674,		-1495.2792,		23.6258},
	{162.7481,		-1569.8494,		12.1592},
	{359.6483,		-1713.0724,		6.7716},
	{573.6464,		-1721.9388,		13.3031},
	{819.7515,		-1781.8362,		13.5706},
	{1017.7310,		-1824.1813,		14.0327},
	{1027.7310,		-1824.1813,		14.0327}
};

new Float:Yaris_KoyTuruCheckpoint[][3] =
{
	{649.9267,-615.2240,16.3359},
	{616.3447,-652.8931,19.1058},
	{416.1348,-596.4702,35.8788},
	{350.4990,-806.8483,11.9376},
	{281.8703,-965.2130,42.6618},
	{166.0396,-1187.2957,52.2934},
	{134.0490,-1341.1470,48.7509},
	{130.5829,-1455.4453,26.3836},
	{70.2888,-1530.9740,4.9444},
	{-60.8134,-1602.2988,2.7986},
	{-254.5096,-1743.0277,4.3264},
	{-269.5432,-1964.5570,28.9856},
	{-361.0889,-2162.1255,43.9161},
	{-567.7667,-2165.2473,38.4446},
	{-711.9224,-2330.3560,34.8035},
	{-820.6198,-2448.8354,71.1233},
	{-980.3450,-2359.9568,66.2137},
	{-1188.4403,-2355.2600,19.4914},
	{-1329.6847,-2187.2627,21.8212},
	{-1521.3716,-2153.6143,3.0763},
	{-1850.1685,-2099.7832,59.0961},
	{-1983.5516,-2114.6865,74.9740},
	{-2096.7986,-2234.9509,30.6370},
	{-2145.6692,-2304.5771,30.4765},
	{-2165.4607,-2390.4321,30.4688},
	{-2165.4607,-2390.4321,30.4688}
};

new Float:Yaris_VinewoodCheckpoint[][3] =
{
	{2656.8235,		-1674.2639,		10.7129},
	{2645.4863,		-1512.1123,		27.7525},
	{2567.2117,		-1443.2106,		34.4738},
	{2401.5281,		-1440.6499,		23.7086},
	{2240.0884,		-1384.1520,		23.6684},
	{2072.5625,		-1372.8689,		23.6494},
	{2069.5310,		-1142.5593,		23.5716},
	{1956.7267,		-1047.2866,		23.8851},
	{1864.4894,		-1115.5432,		23.5142},
	{1799.5922,		-1176.4729,		23.4756},
	{1583.0654,		-1160.5286,		23.7398},
	{1460.8671,		-1033.4977,		23.4877},
	{1366.4387,		-1011.7442,		26.6761},
	{1367.2007,		-850.6106,		43.5065},
	{1333.5909,		-829.0890,		58.6150},
	{1392.5787,		-813.5514,		74.5712}
	
};

new Float:Yaris_LSOtoyolCheckpoint[][3] =
{
	{1335.0100,		-2467.5129,		13.0063},
	{1365.7314,		-2627.4438,		12.9986},
	{2150.1401,		-2634.3145,		13.0913},
	{2161.3445,		-2465.2300,		12.9980},
	{2374.7524,		-2193.5825,		13.1709},
	{2737.3044,		-2166.8147,		10.5536},
	{2831.9631,		-2021.0863,		10.6705},
	{2826.9141,		-1818.0135,		10.5006},
	{2884.3901,		-1381.0122,		10.7178},
	{2851.6580,		-1039.4841,		23.0478},
	{2872.8862,		-764.0831,		10.4579},
	{2811.0732,		-441.5939,		20.4787},
	{2738.7520,		-164.1484,		31.5776},
	{2755.9739,		183.3640,		21.7054},
	{2560.4751,		292.7530,		29.6485},
	{2431.9895,		315.5753,		32.2305},
	{2173.5552,		316.0216,		32.7111},
	{1703.2948,		277.6486,		18.2851},
	{1600.3009,		330.4985,		20.7575},
	{1657.8741,		308.3699,		29.8699},
	{1644.3004,		218.1211,		30.4132},
	{1626.8246,		17.0939,		36.3526},
	{1668.0652,		-214.3685,		38.6918},
	{1685.4053,		-362.9899,		42.4244},
	{1705.0140,		-582.7169,		36.9047},
	{1603.0071,		-1653.0439,		28.2337}
};

new Float:Yaris_LVYarisiCheckpoint[][3] =
{
	{2058.4766,		1128.7747,		10.5656},
	{2064.7944,		1337.3491,		10.5666},
	{2058.2124,		1452.0975,		10.5721},
	{2051.1174,		1697.2371,		10.5660},
	{2122.8147,		1870.8347,		10.5669},
	{2126.3135,		2013.5479,		10.5664},
	{2158.9197,		2137.5374,		10.5666},
	{2339.3391,		2135.7534,		10.5767},
	{2445.7207,		2134.4734,		10.5668},
	{2490.5540,		2149.3765,		10.5662},
	{2389.0947,		2150.9160,		10.5663},
	{2355.7734,		2196.0073,		10.5859},
	{2291.7654,		2264.8298,		10.6515},
	{2276.6921,		2409.4644,		10.5747},
	{2218.0583,		2454.0840,		10.6052},
	{2082.6750,		2455.4287,		10.5668},
	{2029.8281,		2495.2319,		10.5670},
	{2028.4896,		2588.4871,		12.7417},
	{2108.0798,		2608.0554,		8.0746},
	{2278.9185,		2606.7581,		6.6491},
	{2470.4119,		2597.5593,		5.2660},
	{2586.5249,		2536.1023,		5.4621},
	{2662.3672,		2441.4275,		6.6392},
	{2704.8638,		2298.8643,		6.6293},
	{2705.8359,		2139.5027,		6.6424},
	{2705.8501,		1990.7739,		6.6265},
	{2705.8513,		1894.8556,		6.6298},
	{2708.0605,		1611.5757,		6.6332},
	{2707.2905,		1358.7832,		6.6294},
	{2531.5603,		952.4716,		10.5670},
	{2428.9583,		1009.7348,		10.7024},
	{2404.0759,		1073.0337,		10.5659},
	{2347.4263,		1008.6292,		10.5662},
	{2205.1399,		973.5914,		10.5666},
	{2048.5132,		978.2726,		10.4880},
	{2033.8092,		1006.1196,		10.7153},
	{2033.8092,		1006.1196,		10.7153}
};

new Float:Yaris_ColCheckpoint[][3] =
{
	{594.9819,1283.1222,11.4809},
	{527.8485,1244.3224,12.4056},
	{447.9624,1213.8706,16.2706},
	{367.9319,1212.5111,20.6541},
	{343.5542,1230.0568,9.6859},
	{322.2323,1317.7712,10.3321},
	{376.2879,1504.5763,9.8064},
	{437.0883,1618.9188,16.6850},
	{544.7233,1688.6184,10.4103},
	{641.0807,1759.2260,4.4962},
	{659.2682,1861.9846,5.1406},
	{664.0988,1999.4924,7.4710},
	{623.7698,2285.7751,27.7452},
	{526.2351,2343.6118,30.2068},
	{426.9619,2374.5276,25.6896},
	{245.7032,2287.0698,24.1167},
	{99.6320,2296.9006,19.7336},
	{-76.8574,2361.5630,18.2178},
	{-260.1936,2516.7253,32.3852},
	{-386.5623,2583.7480,40.7706},
	{-414.6783,2681.9653,55.5907},
	{-375.1987,2686.3787,64.0192},
	{-302.4577,2636.0332,62.8624},
	{-239.2365,2636.1094,62.3330},
	{-194.5961,2706.4968,62.2136},
	{-218.7638,2738.5991,62.3567},
	{-218.7638,2738.5991,62.3567}
};

new Float:Yaris_DenizkenariCheckpoint[][3] =
{
	{-2613.7781,-2426.8640,17.0508},
	{-2547.8328,-2593.7781,30.8212},
	{-2448.8235,-2677.3767,44.7230},
	{-2180.3987,-2766.3948,35.5753},
	{-1856.2107,-2687.9934,53.9158},
	{-1648.1499,-2735.1807,46.7585},
	{-1523.8654,-2806.3611,46.6586},
	{-1354.9287,-2888.7625,54.1613},
	{-1212.6978,-2875.6150,66.5350},
	{-961.6674,-2850.6968,67.6075},
	{-762.2924,-2769.7651,74.3991},
	{-602.8052,-2749.5303,67.3100},
	{-299.1419,-2809.5574,55.3704},
	{-222.5497,-2846.4514,41.9063},
	{-41.8176,-2823.9189,39.8473},
	{6.8104,-2637.6711,39.9703},
	{-204.6102,-2328.1851,28.3278},
	{-349.2752,-2020.3312,27.3680},
	{-368.3648,-1966.6075,27.9200},
	{-331.3483,-1790.5624,17.9523},
	{-193.8327,-1547.6862,14.8731},
	{12.2874,-1348.8640,10.0833}	
};

new Float:Yaris_SanFierroCheckpoint[][3] =
{
	{-2681.1807,1638.4686,65.9594},
	{-2677.4138,1444.8466,55.1338},
	{-2668.8120,1224.1300,55.1339},
	{-2567.7458,1200.8510,46.7377},
	{-2456.5693,1316.7964,14.1421},
	{-2361.6809,1372.3864,6.8200},
	{-2182.9944,1331.1010,6.7418},
	{-2024.5072,1323.5673,7.0064},
	{-1889.1362,1332.9050,6.7444},
	{-1767.6322,1343.4441,6.7430},
	{-1656.1005,1236.7815,6.7419},
	{-1579.9095,979.6249,6.7419},
	{-1603.0416,844.6151,7.2419},
	{-1725.5861,846.1013,24.4371},
	{-1794.1876,894.2245,24.4450},
	{-1861.0414,924.7263,35.5103},
	{-2017.2432,926.3765,45.1335},
	{-2043.1637,943.5447,50.9481},
	{-2058.7058,919.5842,56.8227},
	{-2077.6062,953.6326,63.4832},
	{-2099.7771,955.2391,70.8274},
	{-2118.5898,962.2067,75.7607},
	{-2136.8474,948.7576,79.5543},
	{-2142.3486,851.4157,71.7133},
	{-2144.0310,682.6035,66.2413},
	{-2144.7734,604.5693,49.6465},
	{-2144.9646,495.9396,34.7184},
	{-2147.4272,349.2423,34.8748},
	{-2082.2034,317.5245,34.7184},
	{-2008.4211,163.1465,27.2419},
	{-2007.5876,63.3102,29.0898},
	{-2029.1443,-66.3652,34.9546}
};

new Float:Yaris_UcagayetisCheckpoint[14][3] =
{
	{539.3495,		-1588.9255,		15.7132},
	{729.1704,		-1584.7404,		13.9651},
	{880.2903,		-1576.3071,		13.0887},
	{1135.2816,		-1573.6124,		13.0098},
	{1315.1097,		-1540.5994,		13.0927},
	{1380.8959,		-1407.2892,		13.0888},
	{1454.3362,		-1476.9872,		13.0578},
	{1494.2126,		-1594.7931,		13.0888},
	{1580.1466,		-1728.8281,		13.0885},
	{1826.0483,		-1745.7722,		13.0878},
	{1961.7661,		-1787.9487,		13.0891},
	{1960.9023,		-2104.2578,		13.0912},
	{1923.5687,		-2432.0771,		13.2451},
	{1661.1556,		-2489.4590,		13.2605}
};

new Float:Yaris_SanAndreasCheckpoint[47][3] =
{
	{2476.3486,		-1732.5863,		13.2241},
	{2243.9868,		-1732.3575,		13.2256},
	{2133.1301,		-1752.4916,		13.2416},
	{1789.5886,		-1732.5649,		13.2246},
	{1553.7482,		-1732.3754,		13.2264},
	{1174.8347,		-1712.0209,		13.4417},
	{976.5820,		-1787.0175,		13.9285},
	{561.1529,		-1718.9524,		12.9909,},
	{194.5956,		-1613.7850,		14.2606},
	{50.5427,		-1527.7549,		5.0641},
	{-131.4349,		-1449.4851,		2.5347},
	{-85.2849,		-1100.9529,		3.5650},
	{-298.9123,		-874.1380,		46.6112},
	{-520.4567,		-893.4806,		54.7019},
	{-726.9355,		-1006.8685,		74.9738},
	{-993.2583,		-1010.3545,		94.2238},
	{-1348.0085,	-813.1562,		77.0951},
	{-1761.3467,	-661.1788,		20.8745},
	{-1823.5277,	-462.9719,		14.8033},
	{-1836.9244,	-214.8685,		17.8436},
	{-1797.8723,	-19.4900,		14.7636},
	{-1762.2292,	297.7135,		7.2919},
	{-1703.1665,	485.9873,		38.0983},
	{-1422.5148,	810.3095,		47.0809},
	{-1073.3708,	1159.8469,		38.3116},
	{-957.9497,		1092.9412,		27.2243},
	{-885.2266,		835.3983,		19.3384},
	{-654.4401,		655.7953,		16.4785},
	{-268.2684,		554.6541,		15.9336},
	{31.5075,		633.9308,		7.2964},
	{458.5168,		724.0848,		5.6560},
	{862.4254,		693.2942,		11.6276},
	{1224.9049,		826.2540,		8.6986},
	{1706.0394,		832.3629,		8.1800},
	{1776.6818,		726.5260,		13.8090},
	{1619.3312,		164.4523,		34.6945},
	{1666.2905,		-154.8330,		35.8586},
	{1682.9994,		-359.0328,		43.0304},
	{1709.8800,		-696.7695,		46.0684},
	{1739.1960,		-891.4622,		55.5556},
	{1990.6270,		-1023.8275,		34.6888},
	{2215.2014,		-1127.0302,		25.5586},
	{2301.2581,		-1246.6180,		23.6887},
	{2370.6587,		-1339.3501,		23.6755},
	{2429.7297,		-1487.0641,		23.6701},
	{2429.5542,		-1685.0587,		20.9353},
	{2519.6709,		-1733.8226,		13.2261}
};

new Float:TOM_CeteSavasi_Grove_Spawn[5][3] =
{
	{2490.0813,		-1682.0491,		13.3363},
	{2476.5103,		-1725.9650,		13.5547},
	{2455.7317,		-1739.5336,		13.6267},
	{2488.4385,		-1658.0883,		13.3548},
	{2500.7476,		-1662.8101,		13.3674}
};

new Float:TOM_CeteSavasi_Ballas_Spawn[5][3] =
{
	{2416.7219,		-1537.2860,		24.0000},
	{2414.4685,		-1545.4954,		23.9925},
	{2402.7927,		-1535.4463,		24.0000},
	{2389.7964,		-1504.0050,		23.8349},
	{2436.1685,		-1558.4980,		24.0000}
};

new Float:TOM_LSSavasi_Mavi_Spawn[5][3] =
{
	{1015.7406,		-1125.0565,		23.8559},
	{1026.8308,		-1124.3275,		23.8787},
	{1004.1902,		-1160.8197,		23.8594},
	{971.3913,		-1154.1521,		23.6859},
	{929.9370,		-1115.5623,		24.1168}
};

new Float:TOM_LSSavasi_Kirmizi_Spawn[5][3] =
{
	{1159.1177,		-1130.9967,		23.6563},
	{1214.1300,		-1128.2488,		24.0854},
	{1216.0074,		-1164.4124,		23.0699},
	{1254.8314,		-1155.6384,		23.8281},
	{1256.3068,		-1134.7198,		23.6563}
};

new Float:TOM_Lunapark_Beyaz_Spawn[5][3] =
{
	{365.0057,	-2056.8591,		15.4032},
	{380.9879,	-2057.1323,		10.7060},
	{396.0032,	-2081.1536,		7.8301},
	{364.3741,	-2008.1372,		7.8359},
	{377.5732,	-1978.6515,		7.8359}
};

new Float:TOM_Lunapark_Siyah_Spawn[5][3] =
{
	{376.7429,		-1924.3406,		7.8301},
	{362.8978,		-1942.8766,		7.8359},
	{393.0816,		-1926.0376,		10.2500},
	{376.0402,		-1880.3206,		7.8359},
	{378.4003,		-1959.6235,		7.8359}
};

new Float:TOM_Gemi_Aztecas_Spawn[6][4] =
{
	{-1584.5721,	55.4427,	17.3281,	321.6517},
	{-1576.7539,	50.3995,	17.3281,	315.0717},
	{-1570.8165,	39.4635,	17.3281,	219.7449},
	{-1561.8234,	46.9289,	17.3281,	311.6249},
	{-1567.3413,	53.7824,	17.3281,	315.3849},
	{-1575.7826,	61.8523,	17.3281,	319.1450}
};

new Float:TOM_Gemi_Vagos_Spawn[6][4] =
{
	{-1479.5276,	139.8289,	18.7734,	134.2766},
	{-1483.9169,	141.8732,	18.7734,	134.2766},
	{-1488.8430,	147.9770,	18.7734,	134.2766},
	{-1498.2401,	138.8138,	17.3281,	134.2766},
	{-1493.6228,	133.1518,	17.3281,	132.3966},
	{-1486.8922,	128.1300,	17.3281,	136.4700}
};




new Float:TOM_CeteSavasi_Pickup_Spawn[6][3] =
{
	{2498.1536,		-1648.1313,		13.5540},
	{2463.2546,		-1688.9039,		13.5154},
	{2458.9358,		-1739.4066,		13.5969},
	{2421.8057,		-1633.7479,		27.6302},
	{2449.8613,		-1551.0950,		23.9980},
	{2400.3018,		-1515.4200,		23.8401}
};


new Float:TOM_LSSavasi_Pickup_Spawn[5][3] =
{
	{1034.9546,		-1125.3779,		23.8946},
	{1122.6454,		-1128.5723,		23.8047},
	{1167.8748,		-1156.7943,		23.8281},
	{1057.9385,		-1161.2759,		23.7087},
	{1003.2377,		-1161.0281,		23.8594}
};


new Float:TOM_Lunapark_Pickup_Spawn[5][3] =
{
	{375.8243,		-1953.0215,		7.8359},
	{362.3633,		-1993.7006,		7.8359},
	{392.1655,		-2045.0469,		7.8359},
	{366.3669,		-2059.9946,		15.3986},
	{382.3745,		-1911.3424,		10.6172}
};

new Float:TOM_Gemi_Pickup_Spawn[8][3] =
{
	{-1553.4539,	80.4358,	19.1329},
	{-1519.5874,	98.1322,	19.2761},
	{-1512.4287,	129.6474,	18.3040},
	{-1489.1056,	122.5465,	18.3711},
	{-1529.9934,	79.2858,	18.0066},
	{-1522.6194,	112.0672,	18.2154},
	{-1566.1244,	39.1631,	18.4307},
	{-1537.1034,	111.6697,	17.3281}
};

new Float:Derbi_Hava_Spawn[][4] = //4 = X,Y,Z,AÇI
{
	{345.0259,		3044.7239,		210.9602,	1.1051},
	{357.5015,		3097.5569,		231.5875,	267.8201},
	{360.8665,		3057.4978,		210.9466,	85.9923},
	{288.0751,		3057.4995,		210.9766,	90.1135},
	{276.2600,		3016.5383,		210.8073,	271.4182}
};

new Float:Derbi_Hava2_Spawn[][4] =
{
	{2703.4380,		3114.4150,		202.9812,	89.4696},
	{2648.6929,		3018.7122,		210.7003,	90.0890},
	{2640.1038,		3100.2388,		210.7708,	271.5010},
	{2640.9546,		3133.2688,		229.9773,	184.0048}
};

new Float:Derbi_Hava3_Spawn[][4] =
{
	{3030.6777,		562.6380,		318.3238,	358.1605},
	{3030.9890,		644.3398,		318.2685,	179.5707},
	{2952.2283,		565.2781,		318.1887,	359.5862},
	{2949.9011,		666.3128,		318.6569,	82.2522}
};


new mesajlar[][] =
{
	"->Komut Listesine bakmak icin /komutlar",
	"->/istatistik [oyuncu] ile baskalarinin istatistigine bakabilirsiniz.",
	"->'H' Tusuna basarak aracinizi tamir edebilirsiniz.",
	"->'N' Tusuna basarak aracinizi cevirebilirsiniz.",
	"->Nitronun bitmesinden biktinizmi? /nitro komudunu kullanin.",
	"->/spawn Komudunu kullanarak oldugunuzde hangi sehirde dogucaginizi secebilirsiniz.",
	"->Freeroama geri donmek icin girdiginiz oyuna tekrar tikliyarak cikabilirsiniz.",
	"->Birinin size isinlanmasini onlemek icin /tpkapat yazin.",
	"->Death Evade yapmak banlanmaniza neden olabilir.",
	"->Minigunlarin nerde spawnlandigini gormek icin /mgspawnlari komutunu kullanin."
};

new Derbi_HavaAraclari[][] = //Hava Derbilerinde Spawnlanýcak araç modelleri
{
	{400}, //Landstalker
	{402}, //Buffalo
	{412}, //Voodoo
	{413}, //Pony
	{415}, //Cheetah
	{416}, //Ambulans
	{411}, //Ýnfernus
	{427}, //Enforcer
	{433}, //Barracks
	{437}, //Coach
	{448}, //Pizza Boy
	{475}, //Sabre
	{478}, //Walton
	{495}, //Sandking
	{494}, //Hotring Racer
	{498}, //Box Ville
	{506}, //Super GT
	{522}, //Nrg 500
	{406}, //Dumper
	{597}, //San Fierro Polis Arabasý
	{557} //Monster Truck

};


new Float:minigunspawn[6][3] =
{
	{-2052.7886,	303.7173,		41.9922}, //San Fierro CJin garajýnýn karþýsýndaki inþaat
	{2494.3206,		-1701.0105,		23.6858}, //Cjin annesinin evinin çatýsý
	{2116.5786,		986.9136,		10.8203}, //Four dragonsun karþýsýndaki otopark
	{204.4888,		1873.3770,		13.1470}, //Area69
	{-2376.7336,	-1624.6862,		492.7576}, //Dað
	{1554.9504,		-1348.7140,		329.4609} //Los santosdaki en büyük gökdelen
};

//mSelection Listeleri 

new skinlistesi = mS_INVALID_LISTID;

new Ucak = mS_INVALID_LISTID;
new Motor = mS_INVALID_LISTID;
new Bot = mS_INVALID_LISTID;
new Donusturulebilir = mS_INVALID_LISTID;
new Helikopter = mS_INVALID_LISTID;
new Endustri = mS_INVALID_LISTID;
new Lowrider = mS_INVALID_LISTID;
new OffRoad = mS_INVALID_LISTID;
new Belediye = mS_INVALID_LISTID;
new RC = mS_INVALID_LISTID;
new Klasik = mS_INVALID_LISTID;
new Spor = mS_INVALID_LISTID;
new StationWagon = mS_INVALID_LISTID;
new Yuk = mS_INVALID_LISTID;
new Diger = mS_INVALID_LISTID;

new saat = 0;
new dakika = 0;



public OnPlayerSpawn(playerid)
{
	if(stat[playerid][skin] != 1000) SetPlayerSkin(playerid,stat[playerid][skin]);
	if(IsPlayerNPC(playerid))
	{
          new npc_name[24];
          SetPlayerColor(playerid, Renk_Gri);
          GetPlayerName(playerid,npc_name,sizeof(npc_name));
          if(!strcmp(npc_name,"Y_1",false))
          {
               SetPlayerSkin(playerid, 107);
               SetPlayerVirtualWorld(playerid, -1);
          }
          if(!strcmp(npc_name,"Y_2",false))
          {
          	SetPlayerSkin(playerid, 177);
          }
          if(!strcmp(npc_name,"Y_3",false))
          {
          	SetPlayerSkin(playerid, 45);
          }
          if(!strcmp(npc_name,"Y_4",false))
          {
          	SetPlayerSkin(playerid, 163);
          }
          if(!strcmp(npc_name,"Y_5",false))
          {
          	SetPlayerSkin(playerid, 2);
          }
          if(!strcmp(npc_name,"Y_6"))
          {
          	SetPlayerSkin(playerid, 7);
          }
          if(!strcmp(npc_name,"Y_7"))
          {
          	SetPlayerSkin(playerid, 127);
          }
          if(!strcmp(npc_name,"Y_8"))
          {
          	SetPlayerSkin(playerid, 1);
          }
          if(!strcmp(npc_name,"Y_9"))
          {
          	SetPlayerSkin(playerid, 3);
          }
          if(!strcmp(npc_name,"Y_10"))
          {
          	SetPlayerSkin(playerid, 8);
          }
          if(!strcmp(npc_name,"Y_11"))
          {
          	SetPlayerSkin(playerid, 19);
          }
          if(!strcmp(npc_name,"TrenSoforu", false))
          {
			PutPlayerInVehicle(playerid, 81, 0);
          }
          return 1;
     }
	if(stat[playerid][oyunmodu] == Freeroam)
	{
		if(stat[playerid][spawn] == LS)
		{
			new rand = random(sizeof(LSSpawn));
			SetPlayerPos(playerid, LSSpawn[rand][0],LSSpawn[rand][1], LSSpawn[rand][2]);
		}
		if(stat[playerid][spawn] == SF)
		{
			new rand = random(sizeof(SFSpawn));
			SetPlayerPos(playerid, SFSpawn[rand][0], SFSpawn[rand][1], SFSpawn[rand][2]);
		}
		if(stat[playerid][spawn] == LV)
		{
			new rand = random(sizeof(LVSpawn));
			SetPlayerPos(playerid, LVSpawn[rand][0], LVSpawn[rand][1], LVSpawn[rand][2]);	
		}
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 30, 9999);
		GivePlayerWeapon(playerid, 29, 9999);
		GivePlayerWeapon(playerid, 25, 9999);
		GivePlayerWeapon(playerid, 24, 9999);
	}
	if(stat[playerid][oyunmodu] == TOM_CeteSavasi && TOM_CeteSavasi_Durum == true)
	{
		if(GetPlayerTeam(playerid) == Takim_Grove)
		{
			SetPlayerSkin(playerid, 107);
			new rand = random(sizeof(TOM_CeteSavasi_Grove_Spawn));
			SetPlayerPos(playerid, TOM_CeteSavasi_Grove_Spawn[rand][0], TOM_CeteSavasi_Grove_Spawn[rand][1], TOM_CeteSavasi_Grove_Spawn[rand][2]);
			GivePlayerWeapon(playerid,31,999);
			GivePlayerWeapon(playerid,29,999);
			GivePlayerWeapon(playerid,25,999);
		}
		if(GetPlayerTeam(playerid) == Takim_Ballas)
		{
			SetPlayerSkin(playerid, 102);
			new rand = random(sizeof(TOM_CeteSavasi_Ballas_Spawn));
			SetPlayerPos(playerid, TOM_CeteSavasi_Ballas_Spawn[rand][0], TOM_CeteSavasi_Ballas_Spawn[rand][1], TOM_CeteSavasi_Ballas_Spawn[rand][2]);
			GivePlayerWeapon(playerid,31,999);
			GivePlayerWeapon(playerid,29,999);
			GivePlayerWeapon(playerid,26,999);
		}
	}
	if(stat[playerid][oyunmodu] == TOM_LSSavasi && TOM_LSSavasi_Durum == true) //Biri Takýmlý ölüm maçý baþlamadan öldürürse spawnlamamasý için
	{
		SendClientMessage(playerid,Renk_Sari,"[TOM]5 Dakika sure dolana kadar en cok puani almaya calis");
		if(GetPlayerTeam(playerid) == Takim_Mavi) 
		{
				ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid,31,1029);
				GivePlayerWeapon(playerid,23,999);
				GivePlayerWeapon(playerid,8,999);
				SetPlayerSkin(playerid,173);
				new rand = random(sizeof(TOM_LSSavasi_Mavi_Spawn));
				SetPlayerPos(playerid, TOM_LSSavasi_Mavi_Spawn[rand][0], TOM_LSSavasi_Mavi_Spawn[rand][1], TOM_LSSavasi_Mavi_Spawn[rand][2]);
		}
		if(GetPlayerTeam(playerid) == Takim_Kirmizi)
		{
					ResetPlayerWeapons(playerid);
					GivePlayerWeapon(playerid,31,1029);
					GivePlayerWeapon(playerid,22,999);
					GivePlayerWeapon(playerid,4,999);
					SetPlayerSkin(playerid,19);
					new rand = random(sizeof(TOM_LSSavasi_Kirmizi_Spawn));
					SetPlayerPos(playerid, TOM_LSSavasi_Kirmizi_Spawn[rand][0], TOM_LSSavasi_Kirmizi_Spawn[rand][1], TOM_LSSavasi_Kirmizi_Spawn[rand][2]);
		}
	}
	if(stat[playerid][oyunmodu] == TOM_Lunapark && TOM_Lunapark_Durum == true)
	{
		SendClientMessage(playerid, Renk_Sari,"[TOM]5 Dakika sure dolana kadar en cok puani almaya calis");
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid,29,1029);
		GivePlayerWeapon(playerid,25,999);
		GivePlayerWeapon(playerid,8,999);
		GivePlayerWeapon(playerid,34,999);
		if(GetPlayerTeam(playerid) == Takim_Beyaz)
		{
			SetPlayerSkin(playerid, 83);
			new rand = random(sizeof(TOM_Lunapark_Beyaz_Spawn));
			SetPlayerPos(playerid, TOM_Lunapark_Beyaz_Spawn[rand][0], TOM_Lunapark_Beyaz_Spawn[rand][1], TOM_Lunapark_Beyaz_Spawn[rand][2]);
		}
		if(GetPlayerTeam(playerid) == Takim_Siyah)
		{
			SetPlayerSkin(playerid, 82);
			new rand = random(sizeof(TOM_Lunapark_Siyah_Spawn));
			SetPlayerPos(playerid, TOM_Lunapark_Siyah_Spawn[rand][0], TOM_Lunapark_Siyah_Spawn[rand][1], TOM_Lunapark_Siyah_Spawn[rand][2]);
		}
	}
	if(stat[playerid][oyunmodu] == TOM_Gemi)
	{
		SendClientMessage(playerid, Renk_Sari,"[TOM]5 Dakika sure dolana kadar en cok puani almaya calis");
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 30, 1029);
		GivePlayerWeapon(playerid, 33, 1029);
		GivePlayerWeapon(playerid, 25, 999);
		GivePlayerWeapon(playerid, 9, 1);
		if(GetPlayerTeam(playerid) == Takim_Aztecas)
		{
		    SetPlayerSkin(playerid, 116);
		    new rand = random(sizeof(TOM_Gemi_Aztecas_Spawn));
		    SetPlayerPos(playerid, TOM_Gemi_Aztecas_Spawn[rand][0], TOM_Gemi_Aztecas_Spawn[rand][1], TOM_Gemi_Aztecas_Spawn[rand][2]);
		    SetPlayerFacingAngle(playerid, TOM_Gemi_Aztecas_Spawn[rand][3]);
		}
		if(GetPlayerTeam(playerid) == Takim_Vagos)
		{
		    SetPlayerSkin(playerid, 110);
		    new rand = random(sizeof(TOM_Gemi_Vagos_Spawn));
		    SetPlayerPos(playerid, TOM_Gemi_Vagos_Spawn[rand][0], TOM_Gemi_Vagos_Spawn[rand][1], TOM_Gemi_Vagos_Spawn[rand][2]);
		    SetPlayerFacingAngle(playerid, TOM_Gemi_Vagos_Spawn[rand][3]);
		}
	}
	if(stat[playerid][oyunmodu] == OM_Istasyon)
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, OM_Istasyon);
		new rand = random(sizeof(OMSpawn));
		SetPlayerPos(playerid, OMSpawn[rand][0], OMSpawn[rand][1], OMSpawn[rand][2]);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 26, 999);
		GivePlayerWeapon(playerid, 30, 999);
		GivePlayerWeapon(playerid, 32, 999);
	}
	if(stat[playerid][oyunmodu] == OM_Rpg)
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, OM_Rpg);
		new rand = random(sizeof(OM_RpgSpawn));
		SetPlayerPos(playerid, OM_RpgSpawn[rand][0], OM_RpgSpawn[rand][1], OM_RpgSpawn[rand][2]);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 35, 999);
	}
	if(stat[playerid][oyunmodu] == OM_Jetpack)
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, OM_Jetpack);
		new rand = random(sizeof(OM_JetpackSpawn));
		SetPlayerPos(playerid, OM_JetpackSpawn[rand][0], OM_JetpackSpawn[rand][1], OM_JetpackSpawn[rand][2]);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 28, 999);
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
	}
	if(stat[playerid][oyunmodu] == OM_Minigun)
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, OM_Minigun);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 38, 99999);
		new rand = random(sizeof(OM_MinigunSpawn));
		SetPlayerPos(playerid, OM_MinigunSpawn[rand][0], OM_MinigunSpawn[rand][1], OM_MinigunSpawn[rand][2]);
	}
	if(stat[playerid][oyunmodu] == OM_TekVurus)
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, OM_TekVurus);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 23, 999);
		new rand = random(sizeof(OM_TekVurusSpawn));
		SetPlayerHealth(playerid, 10.0);
		SetPlayerPos(playerid, OM_TekVurusSpawn[rand][0], OM_TekVurusSpawn[rand][1], OM_TekVurusSpawn[rand][2]);
	}
	if(stat[playerid][oyunmodu] == OM_Grove)
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, OM_Grove);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid,31, 999);
		GivePlayerWeapon(playerid,34, 999);
		GivePlayerWeapon(playerid,27, 999);
		new rand = random(sizeof(OM_GroveSpawn));
		SetPlayerPos(playerid, OM_GroveSpawn[rand][0], OM_GroveSpawn[rand][1], OM_GroveSpawn[rand][2]);
	}
	if(stat[playerid][oyunmodu] == OM_Area69)
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, OM_Area69);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 31, 999);
		GivePlayerWeapon(playerid, 33, 999);
		GivePlayerWeapon(playerid, 29, 999);
		new rand = random(sizeof(OM_Area69Spawn));
		SetPlayerPos(playerid, OM_Area69Spawn[rand][0], OM_Area69Spawn[rand][1], OM_Area69Spawn[rand][2]);
	}
	if(stat[playerid][oyunmodu] == OM_Pier69)
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, OM_Pier69);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 30, 999);
		GivePlayerWeapon(playerid, 28, 999);
		GivePlayerWeapon(playerid, 18, 10);
		new rand = random(sizeof(OM_Pier69Spawn));
		SetPlayerPos(playerid, OM_Pier69Spawn[rand][0], OM_Pier69Spawn[rand][1], OM_Pier69Spawn[rand][2]);
	}
	return 1;
}

new DB: Database;
new DB: Banlar;


public OnGameModeInit()
{

	if((Database = db_open("kayit.db")) == DB: 0)
	{
	    print("Kayit Veritabani ile baglanti kurulamadi.");
	}
	else
	{
	    db_query(Database, "PRAGMA synchronous = OFF");
	    db_query(Database, "CREATE TABLE IF NOT EXISTS hesaplar (hesapid INTEGER PRIMARY KEY AUTOINCREMENT, hesapadi VARCHAR(24) COLLATE NOCASE, sifre VARCHAR(129), admin INTEGER DEFAULT 0 NOT NULL, para INTEGER DEFAULT 0 NOT NULL, skor INTEGER DEFAULT 0 NOT NULL, oldurme INTEGER DEFAULT 0 NOT NULL, olum INTEGER DEFAULT 0 NOT NULL, yariskazanma INTEGER DEFAULT 0 NOT NULL, tomkazanma INTEGER DEFAULT 0 NOT NULL)");
	}
	if((Banlar = db_open("banlilar.db")) == DB: 0)
	{
	    print("Ban Veritabani ile baglanti kurulamadi.");
	}
	else
	{
	    db_query(Banlar, "PRAGMA synchronous = OFF");
	    db_query(Banlar, "CREATE TABLE IF NOT EXISTS banlihesaplar (hesapadi VARCHAR(24))");

	}
	

	//Grove street
	CreateObject(14467, 2491.49609, -1668.73865, 14.92245,   0.00000, 0.00000, 324.76782, 100.0);
	CreateObject(14781, 2430.17041, -1642.73035, 13.36039,   0.00000, 0.00000, 0.40604);
	CreateObject(19580, 2512.12622, -1681.73511, 12.52470,   0.00000, 0.00000, 0.00000);
	CreateObject(1550, 2514.87427, -1682.64966, 12.73299,   0.00000, 0.00000, 0.00000);
	CreateObject(1550, 2514.52856, -1682.20398, 12.79243,   0.00000, 0.00000, 0.00000);
	CreateObject(19335, 2462.35449, -1689.75989, 97.30324,   0.00000, 0.00000, 0.00000);
	CreateObject(1010, 2438.28491, -1646.31689, 13.38549,   0.00000, 0.00000, 0.00000);
	CreateObject(1346, 2463.29639, -1652.91650, 13.81313,   0.00000, 0.00000, 5.31171);
	CreateObject(18659, 2498.53516, -1689.83032, 14.36152,   0.00000, 0.00000, 273.54327);
	
	//San Fierro limanýndaki gemi
	CreateObject(2768, -1547.31091, 65.70712, 16.45747,   0.00000, 0.00000, 0.00000);
	CreateObject(2036, -1550.42554, 70.22960, 18.14889,   0.00000, 0.00000, 0.00000);
	CreateObject(19580, -1539.25928, 86.80653, 16.41310,   0.00000, 0.00000, 0.00000);
	CreateObject(1550, -1548.94312, 93.96942, 16.71095,   0.00000, 0.00000, 0.00000);
	CreateObject(1550, -1549.22107, 93.54316, 16.73332,   0.00000, 0.00000, 0.00000);
	CreateObject(2769, -1536.40576, 101.71980, 17.92791,   0.00000, 0.00000, 0.00000);
	CreateObject(1550, -1503.75818, 106.69267, 16.71339,   0.00000, 0.00000, 0.00000);
	CreateObject(1271, -1562.21741, 81.01665, 16.62393,   0.00000, 0.00000, 45.40477);
	CreateObject(2890, -1553.14294, 66.56170, 16.19128,   0.00000, 0.00000, 314.58231);
	CreateObject(3593, -1505.80701, 140.45607, 16.76777,   0.00000, 0.00000, 318.84354);
	CreateObject(1220, -1493.78638, 112.03194, 16.77083,   0.00000, 0.00000, 14.85980);
	CreateObject(960, -1522.56067, 112.02989, 16.81472,   0.00000, 0.00000, 0.00000);
	CreateObject(18248, -1572.14563, 62.34057, 24.39796,   0.00000, 0.00000, 0.00000);
	CreateObject(13591, -1491.72021, 122.04700, 16.31119,   0.00000, 0.00000, 0.00000);
	CreateObject(12957, -1530.18884, 79.00824, 17.13474,   0.00000, 0.00000, 0.00000);
	CreateObject(3594, -1566.56421, 38.86785, 16.93185,   0.00000, 0.00000, 313.72806);
	CreateObject(932, -1598.61938, 51.35993, 16.28635,   0.00000, 0.00000, 62.32223);
	CreateObject(2905, -1519.72522, 106.20272, 16.32655,   0.00000, 0.00000, 0.00000);
	CreateObject(1265, -1473.54443, 149.16373, 18.83518,   0.00000, 0.00000, 359.27863);
	CreateObject(1328, -1473.51428, 149.26839, 18.17298,   0.00000, 0.00000, 0.00000);


	Derbi_Hava_MapAyarla();
	Derbi_Hava2_MapAyarla();
	Derbi_Hava3_MapAyarla();
	
	Inis_MapAyarla();
	Inis2_MapAyarla();
	Stuntadasi_Map();
	
	Ev_Map();
	
	minigunolustur();
	
	denizinpartibase(); //Credits to denizcicocuk
	
	
	Aktor1 = CreateActor(270, 2520.2637,-1673.4072,14.7715,89.1537); //Grove Streette bir Sweet
	Aktor2 = CreateActor(271, 2489.4470,-1647.7242,14.0772,175.3212); //Grove Streette bir Ryder
    ApplyActorAnimation(Aktor1, "ped", "phone_talk", 4.1, 1, 1, 1, 1, 1);
	ApplyActorAnimation(Aktor2, "ped", "phone_talk", 4.1, 1, 1, 1, 1, 1);
	SetTimer("ServerKontrol", 4000, true);

	
	Ucak = LoadModelSelectionMenu("Arac/Ucak.txt");
	Motor = LoadModelSelectionMenu("Arac/Motor.txt");
	Bot = LoadModelSelectionMenu("Arac/Bot.txt");
	Donusturulebilir = LoadModelSelectionMenu("Arac/Donusturulebilir.txt");
	Helikopter = LoadModelSelectionMenu("Arac/Helikopter.txt");
	Endustri = LoadModelSelectionMenu("Arac/Endustri.txt");
	Lowrider = LoadModelSelectionMenu("Arac/Lowrider.txt");
	OffRoad = LoadModelSelectionMenu("Arac/OffRoad.txt");
	Belediye = LoadModelSelectionMenu("Arac/Belediye.txt");
	RC = LoadModelSelectionMenu("Arac/RC.txt");
	Klasik = LoadModelSelectionMenu("Arac/Klasik.txt");
	Spor = LoadModelSelectionMenu("Arac/Spor.txt");
	StationWagon = LoadModelSelectionMenu("Arac/StationWagon.txt");
	Yuk = LoadModelSelectionMenu("Arac/Yuk.txt");
	Diger = LoadModelSelectionMenu("Arac/Diger.txt");
	
	skinlistesi = LoadModelSelectionMenu("skinler.txt");
	
	SetTimer("SaatAyar", 1000, true);
	SetGameModeText("Alpay's Freeroam v1.2");

	ConnectNPC("Y_1", "y_1");
	ConnectNPC("Y_2", "y_2");
	ConnectNPC("Y_3", "y_3");
	ConnectNPC("Y_4", "y_4");
	ConnectNPC("Y_5", "y_5");
	ConnectNPC("Y_6", "y_6");
	ConnectNPC("Y_7", "y_7");
	ConnectNPC("Y_8", "y_8");
	ConnectNPC("Y_9", "y_9");
	ConnectNPC("Y_10", "y_10");
	ConnectNPC("Y_11", "y_11");
	
	ConnectNPC("TrenSoforu", "a_5");

	/* Gangzone Oluþturulunca herkese gösterilmez GangZoneShowForPlayer(playerid,gangadi,renk) ile gösterilir */
	TOM_CeteSavasi_Grove_Alan = GangZoneCreate(2402,-1757,2538,-1629);
 	TOM_CeteSavasi_Ballas_Alan = GangZoneCreate(2383,-1635,2441,-1478);

	AddPlayerClass(0, 1958.33, 1343.12, 15.36, 269.15, 26, 36, 28, 150, 31, 999); 
 	AddPlayerClass(280, 1958.33, 1343.12, 15.36, 269.15, 26, 36, 28, 150, 31, 999);
  	AddPlayerClass(288, 1958.33, 1343.12, 15.36, 269.15, 26, 36, 28, 150, 31, 999);
   	AddPlayerClass(299, 1958.33, 1343.12, 15.36, 269.15, 26, 36, 28, 150, 31, 999);
   	AddPlayerClass(298, 1958.33, 1343.12, 15.36, 269.15, 26, 36, 28, 150, 31, 999);
    AddPlayerClass(179, 1958.33, 1343.12, 15.36, 269.15, 26, 36, 28, 150, 31, 999);
    AddPlayerClass(45, 1958.33, 1343.12, 15.36, 269.15, 26, 36, 28, 150, 31, 999);
    AddPlayerClass(83, 1958.33, 1343.12, 15.36, 269.15, 26, 36, 28, 150, 31, 999);
    AddPlayerClass(106, 1958.33, 1343.12, 15.36, 269.15, 26, 36, 28, 150, 31, 999);
    
	
	
	AddStaticPickup(372, 2, 2528.4595,-1678.4264,19.9302, 0);
	AddStaticPickup(349, 2, 2482.4060,-1689.9423,13.5149, 0);
	AddStaticPickup(371, 2, -2231.2886,-1739.5519,481.4733, 0);
	AddStaticPickup(1240, 2, 2017.8906,-1430.8619,13.5429, 0);
	AddStaticPickup(1240, 2, -2675.8010,606.6646,14.4545, 0);
	AddStaticPickup(370, 2, 268.4138,1883.3087,-30.0938, 0); //Area69 Jetpack Pickupu

	//Yarýþda kullanýlan araçlar
	AddStaticVehicle(522,1077.0348,-1849.1119,12.9556,90.4027,33,168); // motospawn
	AddStaticVehicle(522,1074.8101,-1854.7354,12.9601,89.0182,33,168); // motospawn
	AddStaticVehicle(522,1090.0740,-1854.9941,12.9552,89.0184,33,168); // motospawn
	AddStaticVehicle(522,1091.0313,-1850.8690,12.9506,86.7540,33,168); // motospawn
	AddStaticVehicle(522,1098.9108,-1850.2220,12.9541,87.0586,33,168); // motospawn
	AddStaticVehicle(522,1099.0853,-1855.3566,12.9556,91.5855,33,168); // motospawn
	
	AddStaticVehicle(402,644.5322,-579.5090,16.0191,180.2306,1,1); // koyturu
	AddStaticVehicle(402,638.6627,-579.2821,16.0192,176.9374,1,1); // koyturu
	AddStaticVehicle(402,639.3431,-566.5627,16.0191,176.9373,1,1); // koyturu
	AddStaticVehicle(402,644.3209,-566.0817,16.0193,177.0128,1,1); // koyturu
	AddStaticVehicle(402,644.9137,-554.7156,16.0192,177.0129,1,1); // koyturu
	AddStaticVehicle(402,639.2882,-554.1249,16.0189,180.3671,1,1); // koyturu

	AddStaticVehicle(541,2783.0913,-1876.1929,9.5204,92.0379,1,6); // vinewood
	AddStaticVehicle(541,2781.8435,-1863.2699,9.5154,90.9160,1,40); // vinewood
	AddStaticVehicle(541,2783.3491,-1852.5532,9.5198,90.4242,1,2); // vinewood
	AddStaticVehicle(541,2792.5896,-1852.4843,9.5600,90.4562,1,0); // vinewood
	AddStaticVehicle(541,2792.5676,-1863.2296,9.5546,90.4183,1,3); // vinewood
	AddStaticVehicle(541,2793.3477,-1873.4344,9.5587,89.3405,1,29); // vinewood

	AddStaticVehicle(451,1350.4674,-2344.1003,13.0820,177.4743,112,240); // otoyol
	AddStaticVehicle(451,1344.1124,-2343.2585,13.0855,179.7729,112,240); // otoyol
	AddStaticVehicle(451,1334.9912,-2344.9895,13.0826,181.5433,112,240); // otoyol
	AddStaticVehicle(451,1328.7069,-2344.4338,13.0821,179.5244,112,240); // otoyol
	AddStaticVehicle(451,1331.6019,-2337.6001,13.0891,177.3784,112,240); // otoyol
	AddStaticVehicle(451,1347.2091,-2337.1838,13.0878,176.2123,112,240); // otoyol

	AddStaticVehicle(480,2045.4655,908.8571,7.9765,1.6222,112,240); // lv
	AddStaticVehicle(480,2051.0674,908.1318,7.9359,1.7820,112,240); // lv
	AddStaticVehicle(480,2051.5100,893.8704,7.3036,1.7860,112,240); // lv
	AddStaticVehicle(480,2045.3661,894.0620,7.3106,359.7407,112,240); // lv
	AddStaticVehicle(480,2045.3131,881.9445,6.8602,359.7481,112,240); // lv
	AddStaticVehicle(480,2051.8640,882.5525,6.8828,358.5849,112,240); // lv

	AddStaticVehicle(468,641.5343,1308.0078,11.4574,121.6451,216,89); // col
	AddStaticVehicle(468,639.1046,1311.7781,11.4581,118.3304,86,166); // col
	AddStaticVehicle(468,643.9964,1314.4154,11.4506,118.3307,86,166); // col
	AddStaticVehicle(468,646.0249,1311.4917,11.4583,123.4379,122,242); // col
	AddStaticVehicle(468,651.9923,1315.0546,11.4647,123.5240,122,242); // col
	AddStaticVehicle(468,649.6691,1318.3744,11.4701,117.5611,86,166); // col

	AddStaticVehicle(415,-2568.7307,-2303.9648,13.0807,104.8502,223,28); // deniz
	AddStaticVehicle(415,-2567.3406,-2309.8667,13.1340,102.2321,7,176); // deniz
	AddStaticVehicle(415,-2556.4812,-2307.6462,14.1594,91.1334,7,176); // deniz
	AddStaticVehicle(415,-2556.9124,-2302.8989,14.0890,93.2065,223,28); // deniz
	AddStaticVehicle(415,-2539.1738,-2301.9270,14.8962,93.2052,223,28); // deniz
	AddStaticVehicle(415,-2538.3689,-2307.9836,14.9073,88.5599,7,176); // deniz

	AddStaticVehicle(506,-2686.2759,1737.5234,67.6999,179.8964,18,175); // sf
	AddStaticVehicle(506,-2692.3862,1737.9049,67.6960,174.2227,110,240); // sf
	AddStaticVehicle(506,-2692.8662,1747.9492,67.7622,177.8410,110,240); // sf
	AddStaticVehicle(506,-2686.3184,1747.9476,67.7551,180.0918,18,175); // sf
	AddStaticVehicle(506,-2686.3218,1756.6373,67.7895,180.0761,18,175); // sf
	AddStaticVehicle(506,-2692.5398,1756.4888,67.7964,178.0032,110,240); // sf
	
	AddStaticVehicle(411,431.2584,-1582.9434,25.1736,271.1310,175,9); // ucagayetis
	AddStaticVehicle(411,431.5405,-1593.6134,25.1691,268.9992,112,130); // ucagayetis
	AddStaticVehicle(411,411.7238,-1593.2676,26.4843,268.9988,112,130); // ucagayetis
	AddStaticVehicle(411,411.8417,-1583.5127,26.4835,271.5210,175,9); // ucagayetis
	AddStaticVehicle(411,398.2925,-1583.8729,27.9223,271.5319,175,9); // ucagayetis
	AddStaticVehicle(411,398.7962,-1593.0510,27.8609,268.9623,112,130); // ucagayetis
	
	AddStaticVehicle(429,2578.0027,-1735.3180,13.2209,88.0122,112,170); // san
	AddStaticVehicle(429,2578.2759,-1729.8538,13.2211,87.9321,128,242); // san
	AddStaticVehicle(429,2591.5193,-1735.1755,13.2210,89.5492,128,90); // san
	AddStaticVehicle(429,2590.9883,-1729.3478,13.2209,94.6079,240,52); // san
	AddStaticVehicle(429,2603.8933,-1729.4349,12.4306,89.6926,88,179); // san
	AddStaticVehicle(429,2603.7588,-1734.8939,12.4426,88.7494,85,212); // san
	
	SetVehicleVirtualWorld(1, Yaris_Sahil);
	SetVehicleVirtualWorld(2, Yaris_Sahil);
	SetVehicleVirtualWorld(3, Yaris_Sahil);
	SetVehicleVirtualWorld(4, Yaris_Sahil);
	SetVehicleVirtualWorld(5, Yaris_Sahil);
	SetVehicleVirtualWorld(6, Yaris_Sahil);
    SetVehicleVirtualWorld(7, Yaris_KoyTuru);
    SetVehicleVirtualWorld(8, Yaris_KoyTuru);
    SetVehicleVirtualWorld(9, Yaris_KoyTuru);
    SetVehicleVirtualWorld(10, Yaris_KoyTuru);
    SetVehicleVirtualWorld(11, Yaris_KoyTuru);
    SetVehicleVirtualWorld(12, Yaris_KoyTuru);
    SetVehicleVirtualWorld(13, Yaris_Vinewood);
    SetVehicleVirtualWorld(14, Yaris_Vinewood);
    SetVehicleVirtualWorld(15, Yaris_Vinewood);
    SetVehicleVirtualWorld(16, Yaris_Vinewood);
    SetVehicleVirtualWorld(17, Yaris_Vinewood);
    SetVehicleVirtualWorld(18, Yaris_Vinewood);
    SetVehicleVirtualWorld(19, Yaris_LSOtoyol);
    SetVehicleVirtualWorld(20, Yaris_LSOtoyol);
    SetVehicleVirtualWorld(21, Yaris_LSOtoyol);
    SetVehicleVirtualWorld(22, Yaris_LSOtoyol);
    SetVehicleVirtualWorld(23, Yaris_LSOtoyol);
    SetVehicleVirtualWorld(24, Yaris_LSOtoyol);
    SetVehicleVirtualWorld(25, Yaris_LVYarisi);
    SetVehicleVirtualWorld(26, Yaris_LVYarisi);
    SetVehicleVirtualWorld(27, Yaris_LVYarisi);
    SetVehicleVirtualWorld(28, Yaris_LVYarisi);
    SetVehicleVirtualWorld(29, Yaris_LVYarisi);
    SetVehicleVirtualWorld(30, Yaris_LVYarisi);
    SetVehicleVirtualWorld(31, Yaris_Col);
    SetVehicleVirtualWorld(32, Yaris_Col);
    SetVehicleVirtualWorld(33, Yaris_Col);
    SetVehicleVirtualWorld(34, Yaris_Col);
    SetVehicleVirtualWorld(35, Yaris_Col);
    SetVehicleVirtualWorld(36, Yaris_Col);
    SetVehicleVirtualWorld(37, Yaris_Denizkenari);
    SetVehicleVirtualWorld(38, Yaris_Denizkenari);
    SetVehicleVirtualWorld(39, Yaris_Denizkenari);
    SetVehicleVirtualWorld(40, Yaris_Denizkenari);
    SetVehicleVirtualWorld(41, Yaris_Denizkenari);
    SetVehicleVirtualWorld(42, Yaris_Denizkenari);
    SetVehicleVirtualWorld(43, Yaris_SanFierro);
    SetVehicleVirtualWorld(44, Yaris_SanFierro);
    SetVehicleVirtualWorld(45, Yaris_SanFierro);
    SetVehicleVirtualWorld(46, Yaris_SanFierro);
    SetVehicleVirtualWorld(47, Yaris_SanFierro);
    SetVehicleVirtualWorld(48, Yaris_SanFierro);
    SetVehicleVirtualWorld(49, Yaris_Ucagayetis);
    SetVehicleVirtualWorld(50, Yaris_Ucagayetis);
    SetVehicleVirtualWorld(51, Yaris_Ucagayetis);
 	SetVehicleVirtualWorld(52, Yaris_Ucagayetis);
    SetVehicleVirtualWorld(53, Yaris_Ucagayetis);
    SetVehicleVirtualWorld(54, Yaris_Ucagayetis);
    SetVehicleVirtualWorld(55, Yaris_SanAndreas);
    SetVehicleVirtualWorld(56, Yaris_SanAndreas);
    SetVehicleVirtualWorld(57, Yaris_SanAndreas);
    SetVehicleVirtualWorld(58, Yaris_SanAndreas);
    SetVehicleVirtualWorld(59, Yaris_SanAndreas);
    SetVehicleVirtualWorld(60, Yaris_SanAndreas);

	//Takýmlý Ölüm Maçý [ÇeteSavaþý] Araçlarý
	AddStaticVehicle(492,2508.2610,-1668.4021,13.1707,181.5676,86,26); // GROVE //82 ID
	AddStaticVehicle(492,2470.7451,-1670.8813,13.1023,7.6359,86,26); // GROVE
	AddStaticVehicle(468,2447.0671,-1728.2185,13.2145,90.7047,86,53); // GROVE
	AddStaticVehicle(445,2417.2004,-1713.7616,13.6391,0.2885,86,35); // GROVE
	AddStaticVehicle(420,2503.6240,-1753.1650,13.1784,1.1313,86,1); // GROVE
	AddStaticVehicle(522,2390.0623,-1484.5088,23.4034,264.2619,147,147); // BALLAS
	AddStaticVehicle(419,2407.3047,-1527.8011,23.6267,270.5679,147,147); // BALLAS
	AddStaticVehicle(419,2417.2417,-1537.4938,23.7975,90.3302,147,147); // BALLAS
	AddStaticVehicle(405,2438.6077,-1586.0458,24.7621,180.4477,147,147); // BALLAS
	AddStaticVehicle(474,2402.3208,-1509.1132,23.6790,179.8107,147,147); // BALLAS
	SetVehicleVirtualWorld(61,TOM_CeteSavasi);
	SetVehicleVirtualWorld(62,TOM_CeteSavasi);
	SetVehicleVirtualWorld(63,TOM_CeteSavasi);
	SetVehicleVirtualWorld(64,TOM_CeteSavasi);
	SetVehicleVirtualWorld(65,TOM_CeteSavasi);
	SetVehicleVirtualWorld(66,TOM_CeteSavasi);
	SetVehicleVirtualWorld(67,TOM_CeteSavasi);
	SetVehicleVirtualWorld(68,TOM_CeteSavasi);
	SetVehicleVirtualWorld(69,TOM_CeteSavasi);
	SetVehicleVirtualWorld(70,TOM_CeteSavasi);

	//Takýmlý Ölüm Maçý [LSSavaþý] Araçlarý
	AddStaticVehicle(522,1233.8765,-1156.9459,23.1186,87.9406,3,8); // 
	AddStaticVehicle(522,1207.8904,-1161.9712,23.0411,23.1237,3,8); // 
	AddStaticVehicle(522,1212.5613,-1132.6772,23.5275,131.8241,3,8); // 
	AddStaticVehicle(522,1147.5211,-1137.6748,23.2293,81.3515,3,8); // 
	AddStaticVehicle(522,1119.7345,-1164.0890,23.1118,13.8992,3,8); // 
	
	AddStaticVehicle(522,1050.8972,-1162.6228,23.2779,1.4340,162,8); // 
	AddStaticVehicle(522,1028.5128,-1118.6691,23.4456,180.5040,162,8); // 
	AddStaticVehicle(522,955.4587,-1127.7891,23.3802,174.9089,162,8); // 
	AddStaticVehicle(522,1008.6971,-1156.2229,23.4014,267.3353,162,8); // 
	AddStaticVehicle(522,1047.6753,-1134.3269,23.3895,270.5922,162,8); // 

	//Araçlarýn Virtual Worldlerini hýzlý ayarlar
	for(new LSArac = 71; LSArac < 81; LSArac++)
	{
	SetVehicleVirtualWorld(LSArac,TOM_LSSavasi);
	}
	
	
	AddStaticVehicle(537,2198.5625,-1740.8069,14.9745,181.5718,183,22); // Tren


	


	
	//Los Santosdaki Araçlar
	AddStaticVehicle(461,2494.6680,-1659.3395,12.9034,89.5360,53,1); // 
	AddStaticVehicle(461,2492.7612,-1657.3759,12.9462,86.2654,53,1); // 
	AddStaticVehicle(536,2502.7305,-1751.7941,13.1462,359.3672,12,1); // 
	AddStaticVehicle(540,2618.3040,-1726.3230,11.5664,89.3239,42,42); // 
	AddStaticVehicle(541,2437.4702,-1627.6301,27.1489,179.8213,58,8); // 
	AddStaticVehicle(575,2392.1116,-1487.7809,23.4281,270.9229,25,96); // 
	AddStaticVehicle(581,2390.8638,-1510.3376,23.4321,269.8729,58,1); // 
	AddStaticVehicle(581,2436.0315,-1546.7900,23.4991,174.4327,58,1); // 
	AddStaticVehicle(581,2549.9116,-1737.6652,13.0987,66.6993,58,1); // 
	AddStaticVehicle(602,2507.2004,-1664.3978,13.2113,27.0109,69,1); // 

	sfaracolustur();
	lvaracolustur();
	

	//Packer
 	AddStaticVehicle(443,-2269.9900,867.5128,67.0851,181.0708,20,1); // 
	AddStaticVehicle(443,-2270.2236,645.3643,49.9257,179.1668,24,1); // 
	AddStaticVehicle(443,-297.3506,-1155.0436,31.9502,143.8799,20,1); // 
	AddStaticVehicle(443,1915.1484,-1957.8840,14.1803,90.3173,24,1); // 

	
	
	return 1;
}


public OnPlayerConnect(playerid)
{
	TogglePlayerClock(playerid, 1);
    RemoveBuildingForPlayer(playerid, 1498, 2485.6797, -1644.1094, 13.2578, 0.25); // Grove streetteki evin kapýsý

	/* Denizin basesi  */
    RemoveBuildingForPlayer(playerid, 647, 1546.6016, -1664.6250, 14.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1546.8672, -1658.3438, 14.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1547.5703, -1661.0313, 13.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 1869.0547, -1876.6328, 11.5391, 0.25);

	/* Parti base */
    RemoveBuildingForPlayer(playerid, 1226, 1774.7578, -1901.5391, 16.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1806.4297, -1901.8281, 16.3750, 0.25);

	/* Grove base */
	RemoveBuildingForPlayer(playerid, 762, 2446.5547, -1681.0703, 12.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 3593, 2457.8672, -1679.6719, 12.9453, 0.25);
	
	new SQ[128];
	GetPlayerName( playerid, oyuncu, sizeof(oyuncu) );
	new DBResult: BanResult;
	format(SQ, sizeof(SQ),"SELECT 'sebep' FROM banlihesaplar WHERE hesapadi = '%q' LIMIT 1",oyuncu);
	BanResult = db_query(Banlar, SQ);
	if(db_num_rows(BanResult))
	{
		new bandiyalog[200];
		db_get_field_assoc(BanResult, "sebep", SQ,32);
		format(bandiyalog, sizeof(bandiyalog),"Sunucudan banlandin!\nYardim icin:Alpays#1174");
		ShowPlayerDialog(playerid, Ban_Diyalog, DIALOG_STYLE_MSGBOX, "Banlandin", bandiyalog, "TAMAM", "TMM");
	}
	else
	{
	SetPlayerColor(playerid, Renk_Beyaz);
	if(!IsPlayerNPC(playerid))
	{
	format(strings, sizeof(strings), "%s sunucuya giris yapti!", oyuncu);
	SendClientMessageToAll(Renk_Mavi, strings);
	}
	new
	    tmp[Oyuncu];
	stat[playerid] = tmp;
 	stat[playerid][skin] = 1000;
 	stat[playerid][spawn] = LS;
 	stat[playerid][tp] = true;
 	stat[playerid][nitro] = 1;
	stat[playerid][tamir] = 1;
 	GetPlayerName(playerid, stat[playerid][Hesap_Adi], MAX_PLAYER_NAME);
 	
 	new
 	    Query[82],
 	    DBResult: Result;
 	    
	format(Query, sizeof Query, "SELECT sifre FROM hesaplar WHERE hesapadi = '%q' LIMIT 1", stat[playerid][Hesap_Adi]);
	Result = db_query(Database, Query);
	
	if(db_num_rows(Result))
	{
	    db_get_field_assoc(Result, "sifre", stat[playerid][Hesap_Sifre], 129);
	    ShowPlayerDialog(playerid, Giris_Diyalog, DIALOG_STYLE_PASSWORD, "Giris Yapma", "Sunucuda oynamak icin lutfen sifrenizi asagiya girin.", "Giris Yap", "Cik");
	}
	else
	{
		ShowPlayerDialog(playerid, Kayit_Diyalog, DIALOG_STYLE_PASSWORD, "Kayit Olma", "Sunucuda kayitli degilsiniz lutfen oynamak icin kayit olun", "Kayit ol", "Cik");
	}
	db_free_result(Result);

 	
 	oyuncumapicon(playerid);
 	}
	return 1;
}

public OnPlayerDisconnect(playerid,reason)
{
	new Query[256];
	format(Query, sizeof Query, "UPDATE hesaplar SET admin = %d, para = %d, skor = %d, oldurme = %d, olum = %d, yariskazanma = %d, tomkazanma = %d WHERE hesapid = %d", stat[playerid][Hesap_Admin], GetPlayerMoney(playerid), GetPlayerScore(playerid), stat[playerid][Oldurmeler], stat[playerid][Olumler], stat[playerid][Yariskazanma], stat[playerid][Tomkazanma], stat[playerid][Hesap_ID]);
	db_query(Database, Query);
	
	
	if(stat[playerid][oyunmodu] == TOM_CeteSavasi)
	{
		if(GetPlayerTeam(playerid) == Takim_Grove) 
		{
			TOM_CeteSavasi_Grove_Sayi--;
			if(TOM_CeteSavasi_Grove_Sayi < 1) TOM_CeteSavasi_Kapat(TOM_CeteSavasi_Cikis);
		}
		if(GetPlayerTeam(playerid) == Takim_Ballas)
		{
			TOM_CeteSavasi_Ballas_Sayi--;
			if(TOM_CeteSavasi_Ballas_Sayi < 1) TOM_CeteSavasi_Kapat(TOM_CeteSavasi_Cikis);
		}
	}
	if(stat[playerid][oyunmodu] == TOM_LSSavasi)
	{
		if(GetPlayerTeam(playerid) == Takim_Mavi)
		{
			TOM_LSSavasi_Mavi_Sayi--;
			if(TOM_LSSavasi_Mavi_Sayi < 1 ) TOM_LSSavasi_Kapat(TOM_LSSavasi_Cikis);
		}
		if (GetPlayerTeam(playerid) == Takim_Kirmizi)
		{
			TOM_LSSavasi_Kirmizi_Sayi--;
			if(TOM_LSSavasi_Kirmizi_Sayi < 1) TOM_LSSavasi_Kapat(TOM_LSSavasi_Cikis);
		}
		
	}
	if(stat[playerid][oyunmodu] == Yaris_Sahil)
	{
	    Yaris_Sahil_Sayi--;
	    if(Yaris_Sahil_Sayi < 1) Yaris_Sahil_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_KoyTuru)
	{
	    Yaris_KoyTuru_Sayi--;
	    if(Yaris_KoyTuru_Sayi < 1) Yaris_KoyTuru_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_Vinewood)
	{
	    Yaris_Vinewood_Sayi--;
	    if(Yaris_Vinewood_Sayi < 1) Yaris_Vinewood_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_LSOtoyol)
	{
	    Yaris_LSOtoyol_Sayi--;
	    if(Yaris_LSOtoyol_Sayi < 1) Yaris_LSOtoyol_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_LVYarisi)
	{
	    Yaris_LVYarisi_Sayi--;
	    if(Yaris_LVYarisi_Sayi < 1) Yaris_LVYarisi_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_Col)
	{
	    Yaris_Col_Sayi--;
		if(Yaris_Col_Sayi < 1) Yaris_Col_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_Denizkenari)
	{
	    Yaris_Denizkenari_Sayi--;
	    if(Yaris_Denizkenari_Sayi < 1) Yaris_Denizkenari_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_SanFierro)
	{
	    Yaris_SanFierro_Sayi--;
	    if(Yaris_SanFierro_Sayi < 1) Yaris_SanFierro_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_Ucagayetis)
	{
	    Yaris_Ucagayetis_Sayi--;
	    if(Yaris_Ucagayetis_Sayi < 1) Yaris_Ucagayetis_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_SanAndreas)
	{
	    Yaris_SanAndreas_Sayi--;
	    if(Yaris_SanAndreas_Sayi < 1 ) Yaris_SanAndreas_Kapat();
	}
	DestroyVehicle(stat[playerid][derbiarac]);
	DestroyVehicle(stat[playerid][arac]);			
	GetPlayerName(playerid,oyuncu,sizeof(oyuncu));
	format(strings, sizeof(strings), "%s sunucudan cikis yapti!", oyuncu);
	SendClientMessageToAll(Renk_Mavi, strings);

	new
	    tmp[Oyuncu];
	stat[playerid] = tmp;
	
	
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1543.9204,-1349.2300,329.4698);
	SetPlayerCameraPos(playerid, 1543.9874,-1357.1290,329.4678);
	SetPlayerCameraLookAt(playerid, 1543.9783, -1356.1572, 329.4646);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(stat[playerid][oyunmodu] == Yaris_Sahil)
	{
	    stat[playerid][oyunmodu] = Freeroam;
		SetPlayerVirtualWorld(playerid, Freeroam);
	    Yaris_Sahil_Sayi--;
	    if(Yaris_Sahil_Sayi < 1) Yaris_Sahil_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_KoyTuru)
	{
	    stat[playerid][oyunmodu] = Freeroam;
	    SetPlayerVirtualWorld(playerid, Freeroam);
	    Yaris_KoyTuru_Sayi--;
	    if(Yaris_KoyTuru_Sayi < 1) Yaris_KoyTuru_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_Vinewood)
	{
	    stat[playerid][oyunmodu] = Freeroam;
	    SetPlayerVirtualWorld(playerid, Freeroam);
	    Yaris_Vinewood_Sayi--;
	    if(Yaris_Vinewood_Sayi < 1) Yaris_Vinewood_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_LSOtoyol)
	{
	    stat[playerid][oyunmodu] = Freeroam;
	    SetPlayerVirtualWorld(playerid, Freeroam);
	    Yaris_LSOtoyol_Sayi--;
	    if(Yaris_LSOtoyol_Sayi < 1) Yaris_LSOtoyol_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_LVYarisi)
	{
	    stat[playerid][oyunmodu] = Freeroam;
	    SetPlayerVirtualWorld(playerid, Freeroam);
	    Yaris_LVYarisi_Sayi--;
	    if(Yaris_LVYarisi_Sayi < 1) Yaris_LVYarisi_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_Col)
	{
	    stat[playerid][oyunmodu] = Freeroam;
	    SetPlayerVirtualWorld(playerid, Freeroam);
	    Yaris_Col_Sayi--;
		if(Yaris_Col_Sayi < 1) Yaris_Col_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_Denizkenari)
	{
	    stat[playerid][oyunmodu] = Freeroam;
	    SetPlayerVirtualWorld(playerid, Freeroam);
	    Yaris_Denizkenari_Sayi--;
	    if(Yaris_Denizkenari_Sayi < 1) Yaris_Denizkenari_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_SanFierro)
	{
	    stat[playerid][oyunmodu] = Freeroam;
	    SetPlayerVirtualWorld(playerid, Freeroam);
	    Yaris_SanFierro_Sayi--;
	    if(Yaris_SanFierro_Sayi < 1) Yaris_SanFierro_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_Ucagayetis)
	{
	    stat[playerid][oyunmodu] = Freeroam;
	    SetPlayerVirtualWorld(playerid, Freeroam);
	    Yaris_Ucagayetis_Sayi--;
	    if(Yaris_Ucagayetis_Sayi < 1) Yaris_Ucagayetis_Kapat();
	}
	if(stat[playerid][oyunmodu] == Yaris_SanAndreas)
	{
		stat[playerid][oyunmodu] = Freeroam;
		SetPlayerVirtualWorld(playerid, Freeroam);
	    Yaris_SanAndreas_Sayi--;
	    if(Yaris_SanAndreas_Sayi < 1 ) Yaris_SanAndreas_Kapat();
	}
    if(killerid != INVALID_PLAYER_ID && !FCNPC_IsValid(playerid) && !FCNPC_IsValid(killerid))
    {
	   	SendDeathMessage(killerid, playerid, reason);
    	stat[killerid][Oldurmeler]++;
     	stat[killerid][spree]++;
        if(stat[killerid][spree] == 3)
        {
        	GetPlayerName(killerid,spreemsj,sizeof(spreemsj));
        	format(strings,sizeof(strings),"[Kombo] %s Ust Uste %i Kill aldi odulu: 2500$ !",spreemsj,stat[killerid][spree]);
        	GivePlayerMoney(killerid, 2500);
        	SendClientMessageToAll(Renk_Yesil, strings);
        }
        else if(stat[killerid][spree] == 5)
        {
        	GetPlayerName(killerid,spreemsj,sizeof(spreemsj));
        	format(strings,sizeof(strings),"[Kombo] %s Ust Uste %i Kill aldi odulu: 5000$ !",spreemsj,stat[killerid][spree]);
        	GivePlayerMoney(killerid, 5000);
        	SendClientMessageToAll(Renk_Yesil, strings);
        }
        else if(stat[killerid][spree] == 7)
        {
        	GetPlayerName(killerid,spreemsj,sizeof(spreemsj));
        	format(strings,sizeof(strings),"[Kombo] %s Ust Uste %i Kill aldi odulu: Zirh ve Can yenilenmesi !",spreemsj,stat[killerid][spree]);
			SetPlayerHealth(killerid, 100.0);
			SetPlayerArmour(killerid, 100.5);
        	SendClientMessageToAll(Renk_Yesil, strings);
        }
        else if(stat[killerid][spree] > 7)
        {
        	GetPlayerName(killerid,spreemsj,sizeof(spreemsj));
        	format(strings,sizeof(strings),"[Kombo] %s Ust Uste %i Kill aldi !",spreemsj,stat[killerid][spree]);
        	SendClientMessageToAll(Renk_Yesil, strings);
        }
        GivePlayerMoney(killerid, 350);
        if(stat[killerid][oyunmodu] == TOM_CeteSavasi)
        {
        	if(GetPlayerTeam(killerid) == Takim_Grove) 
        	{
        	TOM_CeteSavasi_Grove_Skor++;
        	format(strings,sizeof(strings),"[TOM]Bir balla oldurerek Takimina skor kazandirdin takimin skoru: %i!",TOM_CeteSavasi_Grove_Skor);
        	SendClientMessage(killerid, Renk_AltinSarisi, strings);
        	}
        	else
        	{
        	TOM_CeteSavasi_Ballas_Skor++;
        	format(strings,sizeof(strings),"[TOM]Bir Grovelu oldurerek Takimina skor kazandirdin takimin skoru: %i!",TOM_CeteSavasi_Ballas_Skor);
        	SendClientMessage(killerid, Renk_AltinSarisi, strings);
        	}
        }
        if(stat[killerid][oyunmodu] == TOM_LSSavasi)
        {
        	if(GetPlayerTeam(killerid) == Takim_Mavi)
        	{
        		TOM_LSSavasi_Mavi_Skor++;
        		format(strings,sizeof(strings),"[TOM]Bir Kirmizili oldurerek Takimina skor kazandirdin takimin skoru: %i!",TOM_LSSavasi_Mavi_Skor);
        		SendClientMessage(killerid, Renk_AltinSarisi, strings);
        	}
        	else
        	{
        		TOM_LSSavasi_Kirmizi_Skor++;
        		format(strings,sizeof(strings),"[TOM]Bir Mavili oldurerek Takimina skor kazandirdin takimin skoru: %i!",TOM_LSSavasi_Kirmizi_Skor);
        		SendClientMessage(killerid, Renk_AltinSarisi, strings);
        	}
        }
        if(stat[killerid][oyunmodu] == TOM_Lunapark)
        {
        	if(GetPlayerTeam(killerid) == Takim_Beyaz)
        	{
        		TOM_Lunapark_Beyaz_Skor++;
        		format(strings,sizeof(strings),"[TOM]Bir siyahli oldurerek Takimina skor kazandirdin takiminin skoru: %i",TOM_Lunapark_Beyaz_Skor);
        		SendClientMessage(killerid, Renk_AltinSarisi, strings);
        	}
        	else
        	{
        		TOM_Lunapark_Siyah_Skor++;
        		format(strings,sizeof(strings),"[TOM]Bir beyazli oldurerek Takimina skor kazandirdin takiminin skoru: %i",TOM_Lunapark_Siyah_Skor);
        		SendClientMessage(killerid, Renk_AltinSarisi, strings);
        	}
        }
        if(stat[killerid][oyunmodu] == TOM_Gemi)
        {
            if(GetPlayerTeam(killerid) == Takim_Aztecas)
            {
                TOM_Gemi_Aztecas_Skor++;
                format(strings,sizeof(strings),"[TOM]Vagoslu birini oldurerek Takimina skor  kazandirdin takiminin skoru: %i",TOM_Gemi_Aztecas_Skor);
                SendClientMessage(killerid, Renk_AltinSarisi, strings);
            }
			else
			{
			    TOM_Gemi_Vagos_Skor++;
			    format(strings,sizeof(strings),"[TOM]Aztecasli birini oldurerek Takimina skor kazandirdin takiminin skoru: %i",TOM_Gemi_Vagos_Skor);
			    SendClientMessage(killerid, Renk_AltinSarisi, strings);
			}
        }
        
    }
    stat[playerid][spree] = 0;
    stat[playerid][Olumler]++; 
	switch(stat[killerid][oyunmodu])
	{
		case Yaris_Sahil:
		{
			GivePlayerMoney(killerid, -500000);
			SetPlayerHealth(killerid, 0.0);
			SendClientMessage(killerid, Renk_AcikKirmizi, "Belki bidaha yaristayken adam vurmazsin!");
		}
		case Yaris_KoyTuru:
		{
			GivePlayerMoney(killerid, -500000);
			SetPlayerHealth(killerid, 0.0);
			SendClientMessage(killerid, Renk_AcikKirmizi, "Belki bidaha yaristayken adam vurmazsin!");
		}
		case Yaris_Vinewood:
		{
			GivePlayerMoney(killerid, -500000);
			SetPlayerHealth(killerid, 0.0);
			SendClientMessage(killerid, Renk_AcikKirmizi, "Belki bidaha yaristayken adam vurmazsin!");
		}
		case Yaris_LSOtoyol:
		{
			GivePlayerMoney(killerid, -500000);
			SetPlayerHealth(killerid, 0.0);
			SendClientMessage(killerid, Renk_AcikKirmizi, "Belki bidaha yaristayken adam vurmazsin!");
		}
		case Yaris_LVYarisi:
		{
			GivePlayerMoney(killerid, -500000);
			SetPlayerHealth(killerid, 0.0);
			SendClientMessage(killerid, Renk_AcikKirmizi, "Belki bidaha yaristayken adam vurmazsin!");
		}
		case Yaris_Col:
		{
			GivePlayerMoney(killerid, -500000);
			SetPlayerHealth(killerid, 0.0);
			SendClientMessage(killerid, Renk_AcikKirmizi, "Belki bidaha yaristayken adam vurmazsin!");
		}
	}
	return 1;
}

CMD:kill(playerid, params[]) 
{
	SetPlayerHealth(playerid, 0);
    SendClientMessage(playerid, Renk_Mavi, "Allah rahmet eylesin :(");
    return 1;
}

CMD:cek(playerid, params[])
{
	new ID;
	if(stat[playerid][Hesap_Admin] > 0)
	{
		if(sscanf(params, "u", ID) ) SendClientMessage(playerid, Renk_AcikKirmizi, "Kullanim: /cek [oyuncu]");
		else
		{
		    new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			SetPlayerPos(ID, x + 3.2, y, z);
			new cek[60], isim[MAX_PLAYER_NAME];
			GetPlayerName(playerid, isim, sizeof isim);
			format(cek, sizeof cek,"%s adli yetkili seni yanina cekti!",isim);
			SendClientMessage(ID, Renk_Sari, cek);
		}
	}
}


CMD:isinlanma(playerid, params[])
{
	if (stat[playerid][oyunmodu] == Freeroam)
	{
	ShowPlayerDialog(playerid, Isinlanma_Diyalog, DIALOG_STYLE_LIST, "Isinlanma", "Grove Street\nSan Fierro Garaji\nFour Dragons\nDag\nArea69\nLocolow CO\nTransfender\nWheel Arc.", "Git", "Cik");
	}
	else SendClientMessage(playerid, Renk_Kirmizi, "Freeroamda olman gerek!");
}

CMD:tamir(playerid, params[])
{
	if(stat[playerid][tamir] == 1)
	{
		RepairVehicle(GetPlayerVehicleID(playerid));
		stat[playerid][tamir] = 0;
		SetTimerEx("tamirSure", 600, true, "i", playerid);
	}
	else {
	    SendClientMessage(playerid, Renk_Kirmizi, "Tamir etmek icin 30 saniye beklemelisin!");
	}
}

public tamirSure(playerid)
{
	stat[playerid][tamir] = 1;
}

CMD:komutlar(playerid, params[])
{
	new komutdi[900];
	strcat(komutdi, ""DiRenk_Yesil"Minigame Komutlari\n"DiRenk_Beyaz"/olummaci /tom /yaris /derbi...\n");
	strcat(komutdi, ""DiRenk_Yesil"Araba Komutlari\n"DiRenk_Beyaz"/gokkusagi /sinirsiznitro /tamir /aracrengi /paintjob...\n");
	strcat(komutdi, ""DiRenk_Yesil"Genel Komutlar\n"DiRenk_Beyaz"/kill /v /esya /silah /anim /dovusstilleri /skin /istatistik /spawn /isinlanma\n/tp /soncp /isinlanma /tpkapat /silahlarisifirla\n");
	strcat(komutdi, ""DiRenk_Yesil"Admin Komutlari\n"DiRenk_Beyaz"/ban /unban /kick /skorbelirle /parabelirle /skorver /paraver /cek /aracolustur /can /hava");
	ShowPlayerDialog(playerid, Komut_Diyalog, DIALOG_STYLE_MSGBOX, ""DiRenk_Kirmizi"Komutlar", komutdi, "Tamam", "Cik");
}



CMD:silah(playerid, params[])
{
	if (stat[playerid][oyunmodu] == Freeroam)
	{
	SendClientMessage(playerid, -1, "Silah Menusunu actin!");
	ShowPlayerDialog(playerid, Silah_Diyalog, DIALOG_STYLE_LIST, "Silahlar", "9mm\nSusturuculu\nDeagle\nShotgun\nSawn Off\nCombat Shotgun\nMicro SMG\nMp5\nAk47\nM4\nTec9\nCountry Rifle\nSniper", "Al", "Cik");
	}
	else SendClientMessage(playerid, Renk_Kirmizi, "Freeroamda olman gerek!");
}

CMD:mgspawnlari(playerid, params[])
{
	ShowPlayerDialog(playerid, Mg_Diyalog, DIALOG_STYLE_MSGBOX, ""DiRenk_Kirmizi"Minigun Spawnlari", "1.Cjin garajinin karsisindaki insaatta\n2.Grove Streetteki evin catisinda.\n3.Four Dragonsun karsisindaki otoparkda\n4.Area69da\n5.Dagda\n6.Los Santosdaki gokdelende", "Tamam", "" );
}

CMD:paintjob(playerid, params[])
{
	new paintjob;
	if(sscanf(params, "i", paintjob)) SendClientMessage(playerid, Renk_AcikKirmizi, "Kullanim: /paintjob [0-2] (Paintjobu silmek icin 3 yazin)");
	else if(IsPlayerInAnyVehicle(playerid))
	{
	    new araba;
	    araba = GetPlayerVehicleID(playerid);
	    if(GetVehicleModel(araba) == 483  || GetVehicleModel(araba) == 534 || GetVehicleModel(araba) == 535 || GetVehicleModel(araba) == 536 || GetVehicleModel(araba) == 558 || GetVehicleModel(araba) == 559 || GetVehicleModel(araba) == 560 || GetVehicleModel(araba) == 561 || GetVehicleModel(araba) == 562 || GetVehicleModel(araba) == 565 || GetVehicleModel(araba) == 567 || GetVehicleModel(araba) == 575)
	    {
	       	ChangeVehiclePaintjob(araba, paintjob);
			SendClientMessage(playerid, Renk_Yesil, "Aracin paintjobu degistirildi!");
	    }
	    else
	    {
	 	   return SendClientMessage(playerid, Renk_AcikKirmizi, "Kullandigin arabanin paintjob secenegi yok!");
	    }
	}
	else SendClientMessage(playerid, Renk_AcikKirmizi, "Aracda olman gerek!");
	return 1;
}


CMD:tp(playerid, params[])
{
	new ID;
	new isinlanmamesaj[65];
	new isinlanmamesaj2[65];
	new oyuncu2[MAX_PLAYER_NAME];
	if(sscanf(params, "u", ID)) SendClientMessage(playerid, Renk_AcikKirmizi, "[Hata]Kullanim: /tp [oyuncuid]");
	else if(stat[playerid][oyunmodu] != Freeroam) SendClientMessage(playerid, Renk_AcikKirmizi, "[Hata]Freeroamda olman gerek!");
	else if(stat[ID][oyunmodu] != Freeroam) SendClientMessage(playerid, Renk_AcikKirmizi, "[Hata]Isinlanmaya calistigin oyuncu Freeroamda degil!");
	else if(!IsPlayerConnected(ID)) return SendClientMessage(playerid, Renk_AcikKirmizi, "[Hata]Bu oyuncu sunucuda degil!");
	else if(IsPlayerNPC(ID) && stat[playerid][Hesap_Admin] < 5) SendClientMessage(playerid, Renk_AcikKirmizi, "[Hata]Npclere isinlanamazsin!");
	else if(stat[ID][tp] == false && stat[playerid][Hesap_Admin] < 5) SendClientMessage(playerid, Renk_AcikKirmizi, "[Hata] Oyuncu isinlanma ozelligini kapamis!");
	else if(playerid == ID) return SendClientMessage(playerid, Renk_AcikKirmizi, "[Hata]Kendine isinlanamazsin!");
	else if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) SendClientMessage(playerid, Renk_AcikKirmizi, "[Hata]Araci surmen gerekiyor");
	else
	{
		new Float:x, Float:y, Float:z;
		if(IsPlayerInAnyVehicle(playerid) == 1 && GetPlayerInterior(ID) == 0)
		{
			new tparac;
			tparac = GetPlayerVehicleID(playerid);
			GetPlayerPos(ID,x,y,z);
			SetVehiclePos(tparac,x + 3,y,z);
			PutPlayerInVehicle(playerid, tparac, 0);
			GetPlayerName(ID,oyuncu,sizeof(oyuncu));
			GetPlayerName(playerid,oyuncu2,sizeof(oyuncu2));
			format(isinlanmamesaj, sizeof(isinlanmamesaj),"%s Adli oyuncuya isinlandin!",oyuncu);
			format(isinlanmamesaj2, sizeof(isinlanmamesaj2),"%s Adli oyuncu sana isinlandi!",oyuncu2);
			GameTextForPlayer(playerid, isinlanmamesaj, 2000, 6);
			GameTextForPlayer(ID, isinlanmamesaj2, 2000, 6);
			
		}
		else if(!IsPlayerInAnyVehicle(playerid))
		{
			GetPlayerPos(ID,x,y,z);
			SetPlayerPos(playerid,x + 1.5,y,z);
			SetPlayerInterior(playerid, GetPlayerInterior(ID));
			GetPlayerName(ID,oyuncu,sizeof(oyuncu));
			GetPlayerName(playerid,oyuncu2,sizeof(oyuncu2));
			format(isinlanmamesaj, sizeof(isinlanmamesaj),"%s Adli oyuncuya isinlandin!",oyuncu);
			format(isinlanmamesaj2, sizeof(isinlanmamesaj2),"%s Adli oyuncu sana isinlandi!",oyuncu2);
			GameTextForPlayer(playerid, isinlanmamesaj, 2000, 6);
			GameTextForPlayer(ID, isinlanmamesaj2, 2000, 6);
		}
		else
		{
		    SendClientMessage(playerid,Renk_AcikKirmizi, "Isinlanmaya calistigin kisi bir binanin icinde aracdan inmen gerek!");
		}
	}
	return 1;
}

CMD:esya(playerid, params[])
{
	if (stat[playerid][oyunmodu] == Freeroam)
	{
	SendClientMessage(playerid, -1, "Esya Menusunu actin!");
	ShowPlayerDialog(playerid, Esya_Diyalog, DIALOG_STYLE_LIST, "Esyalar", "Kamera\nParasut\nSpray\nBaston\nCicek\nMusta\nGolf Sopasi\nJop\nBicak\nBeyzbol Sopasi\nKurek\nKatana\nTestere", "Al", "Cik");
	}
	else SendClientMessage(playerid, Renk_Kirmizi, "Freeroamda olman gerek!");
}

CMD:ban(playerid, params[])
{
	new ID;
	if(IsPlayerAdmin(playerid) || stat[playerid][Hesap_Admin] == 5)
	{
	    if(sscanf (params, "u", ID))
	    {
	        SendClientMessage(playerid, Renk_AcikKirmizi, "Kullanim: /ban [oyuncu]");
		}
	    else
	    {
	        if(!IsPlayerConnected(ID)) SendClientMessage(playerid,Renk_AcikKirmizi, "Bu oyuncu online degil!");
			new Query[128];
			GetPlayerName( ID, oyuncu, sizeof(oyuncu) );
			new DBResult: Result;
			format(Query, sizeof(Query),"SELECT hesapadi FROM banlihesaplar WHERE hesapadi = '%s' LIMIT 1",oyuncu);
			Result = db_query(Banlar, Query);
			if(db_num_rows(Result))
			{
			    SendClientMessage(playerid, Renk_AcikKirmizi, "Bu oyuncu zaten banli!");
			}
			else
			{
				new q[150];
				format(q,sizeof(q),"INSERT INTO banlihesaplar( hesapadi ) VALUES ('%q')",oyuncu);
				Kick(ID);
				SendClientMessage(playerid, Renk_AcikKirmizi, "Oyuncu banlandi!");
				db_query(Banlar, q);
			}
			db_free_result(Result);
	    }
	} else SendClientMessage(playerid, Renk_AcikKirmizi, "Bir oyuncuyu banlamak icin admin olman gerek!");
}

CMD:unban(playerid, params[])
{
	new ID[24];
	if(IsPlayerAdmin(playerid) || stat[playerid][Hesap_Admin] == 5)
	{
	    if(sscanf(params, "s[24]", ID)) SendClientMessage(playerid, Renk_AcikKirmizi, "Kullanim: /unban [oyuncu]");
	    else
	    {
			new Query[128];
			new DBResult: Result;
			format(Query, sizeof(Query),"SELECT hesapadi FROM banlihesaplar WHERE hesapadi = '%s' LIMIT 1",ID);
			Result = db_query(Banlar, Query);
			if(db_num_rows(Result))
			{
				new q[128];
				format(q, sizeof q, "DELETE FROM banlihesaplar WHERE hesapadi = '%s'", ID);
				SendClientMessage(playerid, Renk_AcikKirmizi, "Oyuncunun bani kaldirildi!");
				Result = db_query(Banlar, q);
			}
			else SendClientMessage(playerid, Renk_AcikKirmizi, "Boyle bir oyuncu bulunamadi!");
			db_free_result(Result);
	    }

	} else SendClientMessage(playerid,Renk_AcikKirmizi, "Bu komutu kullanmak icin admin olman gerek!");
}

CMD:anim(playerid, params[])
{
	ShowPlayerDialog(playerid, Anim_Diyalog, DIALOG_STYLE_LIST, "Animasyonlar", "Dans\nDans2\nSarhos\nOturma\nTelefon", "Uygula", "Cik");
}

CMD:dovusstilleri(playerid, params[])
{
	ShowPlayerDialog(playerid, Dovus_Diyalog, DIALOG_STYLE_LIST, "Dovus Stilleri", "Normal\nBox\nKungFu\nKneehead\nGrabkick\nElbow", "Uygula", "Cik");
}

CMD:olummaci(playerid, params[])
{
	ShowPlayerDialog(playerid, Olummaci_Diyalog, DIALOG_STYLE_LIST, "Olum Maclari", "01 Istasyon \n02 Minigun Cilginligi\n03 Tek Vurus\n04 Grove Savasi\n05 Area69\n06 Pier69\n07 Rpg\n08 Jetpack", "Katil/Cik", "Menuden Cik");
}

CMD:yaris(playerid, params[])
{
	ShowPlayerDialog(playerid, Yaris_Diyalog, DIALOG_STYLE_LIST, "Yarislar", "01 Sahil\n02 Koy Turu\n03 Vinewooda Dogru\n04 LS Otoyolu\n05 Las Venturas Yarisi\n06 Col\n07 Deniz Kenari\n08 San Fierro\n09 Ucaga Yetis\n10 San Andreas", "Katil/Cik", "Menuden Cik");
}

CMD:gorev(playerid, params[])
{
	ShowPlayerDialog(playerid, Gorev_Diyalog, DIALOG_STYLE_LIST, "Gorevler", "01 Saldiri\n02 Area69", "Katil/Cik", "Menuden Cik");
}

CMD:tom(playerid, params[])
{
	ShowPlayerDialog(playerid, Tom_Diyalog, DIALOG_STYLE_LIST, "Takimli Olum Maclari", "01 Grove vs Ballas\n02 Los Santos\n03 Lunapark\n04 Gemi", "Katil/Cik", "Menuden Cik" );
}

CMD:skin(playerid, params[])
{
	if(stat[playerid][oyunmodu] == Freeroam && IsPlayerInAnyVehicle(playerid) == 0)
	{
		 ShowModelSelectionMenu(playerid, skinlistesi, "Skinler");
	} else SendClientMessage(playerid, Renk_AcikKirmizi, "Freeroamda ve Araba disinda olman gerek!");
	
}


CMD:istatistik(playerid, params[])
{
	new istatistik[900];
	new istatistikdialog[900];
	new ID;
	if(sscanf (params, "u", ID))
	{
		GetPlayerName(playerid, oyuncu, sizeof(oyuncu));
		format(istatistik,sizeof(istatistik),"\n"DiRenk_Yesil"Adin: "DiRenk_Beyaz"%s\n", oyuncu);
		strcat(istatistikdialog, istatistik);
		format(istatistik,sizeof(istatistik),""DiRenk_Yesil"Skorun: "DiRenk_Beyaz"%i\n"DiRenk_Yesil"Paran: "DiRenk_Beyaz"%i\n",GetPlayerScore(playerid),GetPlayerMoney(playerid));
		strcat(istatistikdialog, istatistik);
		format(istatistik,sizeof(istatistik),""DiRenk_Yesil"Yaris Kazanmalarin: "DiRenk_Beyaz"%i\n"DiRenk_Yesil"Tom Kazanmalarin: "DiRenk_Beyaz"%i\n"DiRenk_Yesil"Tom Rutben: "DiRenk_Beyaz"%s\n",stat[playerid][Yariskazanma],stat[playerid][Tomkazanma],Tom_Rutbe(playerid));
		strcat(istatistikdialog, istatistik);
		format(istatistik,sizeof(istatistik),""DiRenk_Yesil"Oldurmelerin: "DiRenk_Beyaz"%i\n"DiRenk_Yesil"Olumlerin: "DiRenk_Beyaz"%i\n"DiRenk_Yesil"Suanki aldigin ust uste kill sayin: "DiRenk_Beyaz"%i\n",stat[playerid][Oldurmeler],stat[playerid][Olumler],stat[playerid][spree]);
		strcat(istatistikdialog, istatistik);
		format(istatistik,sizeof(istatistik),""DiRenk_Yesil"Admin seviyen: "DiRenk_Beyaz"%i\n\n",stat[playerid][Hesap_Admin]);
		strcat(istatistikdialog, istatistik);
		ShowPlayerDialog(playerid, Istatistik_Diyalog, DIALOG_STYLE_MSGBOX, ""DiRenk_Kirmizi"Istatistikler", istatistikdialog, "Tamam", "Cik");
	}
	else
	{
		GetPlayerName(ID, oyuncu, sizeof(oyuncu));
		format(istatistik,sizeof(istatistik),"\n"DiRenk_Yesil"Adi: "DiRenk_Beyaz"%s\n", oyuncu);
		strcat(istatistikdialog, istatistik);
		format(istatistik,sizeof(istatistik),""DiRenk_Yesil"Skoru: "DiRenk_Beyaz"%i\n"DiRenk_Yesil"Parasi: "DiRenk_Beyaz"%i\n",GetPlayerScore(ID),GetPlayerMoney(ID));
		strcat(istatistikdialog, istatistik);
		format(istatistik,sizeof(istatistik),""DiRenk_Yesil"Yaris Kazanmalari: "DiRenk_Beyaz"%i\n"DiRenk_Yesil"Tom Kazanmalari: "DiRenk_Beyaz"%i\n"DiRenk_Yesil"Tom Rutbesi: "DiRenk_Beyaz"%s\n",stat[ID][Yariskazanma],stat[ID][Tomkazanma],Tom_Rutbe(ID));
		strcat(istatistikdialog, istatistik);
		format(istatistik,sizeof(istatistik),""DiRenk_Yesil"Oldurmeleri: "DiRenk_Beyaz"%i\n"DiRenk_Yesil"Olumleri: "DiRenk_Beyaz"%i\n"DiRenk_Yesil"Suanki aldigi ust uste kill sayisi: "DiRenk_Beyaz"%i\n",stat[ID][Oldurmeler],stat[ID][Olumler],stat[ID][spree]);
		strcat(istatistikdialog, istatistik);
		format(istatistik,sizeof(istatistik),""DiRenk_Yesil"Admin seviyesi: "DiRenk_Beyaz"%i\n\n",stat[ID][Hesap_Admin]);
		strcat(istatistikdialog, istatistik);
		ShowPlayerDialog(playerid, Istatistik_Diyalog, DIALOG_STYLE_MSGBOX, ""DiRenk_Kirmizi"Istatistikler", istatistikdialog, "Tamam", "Cik");
	}
}
CMD:gokkusagi(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid) == 0) SendClientMessage(playerid,Renk_AcikKirmizi, "Aracda olman gerek!");
	else{
	if(stat[playerid][gokkusagi] == 0)
	{
		stat[playerid][gokkusagi] = SetTimerEx("Gokkusagi", 600, true, "i", playerid);
		GameTextForPlayer(playerid, "~r~G~y~O~p~K~g~K~r~U~w~S~y~A~p~G~y~I ~w~Acildi", 5000, 6);
	}
	else 
	{
		KillTimer(stat[playerid][gokkusagi]);
		stat[playerid][gokkusagi] = 0;
		GameTextForPlayer(playerid, "~r~Gokkusagi Modu Kapatildi!", 5000, 6);
	}
	}
}

CMD:v(playerid, params[])
{
	if(stat[playerid][oyunmodu] == Freeroam) ShowPlayerDialog(playerid, Arac_Diyalog, DIALOG_STYLE_LIST, ""DiRenk_Kirmizi"Arac Kategorisi", "Ucak\nMotor\nBot\nDonusturulebilir\nHelikopter\nEndustri\nLowrider\nOff Road\nBelediye\nRC\nKlasik Arabalar\nSpor Arabalar\nStation Wagon\nYuk\nDiger", "Sec", "Vazgectim");
	else SendClientMessage(playerid, Renk_AcikKirmizi, "Freeroamda olman gerek!");
	return 1;
}

CMD:koordinat(playerid, params[])
{
	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	GetPlayerFacingAngle(playerid, a);
	} else GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	format(strings,sizeof(strings), "Koordinatin: X:%f Y:%f Z:%f A:%f",x,y,z,a);
	SendClientMessage(playerid, Renk_Yesil, strings);
}

CMD:sinirsiznitro(playerid, params[])
{
	if(stat[playerid][oyunmodu] != Freeroam) GameTextForPlayer(playerid, "~r~Freeroamda olman gerek!", 3000, 6);
	else if(stat[playerid][nitro] == 0)
	{
		stat[playerid][nitro] = 1;
		GameTextForPlayer(playerid, "~p~Nitro ~w~Acildi!", 3000, 6);
	}
	else
	{
		new narac = GetPlayerVehicleID(playerid);
		RemoveVehicleComponent(narac, 1010);
		stat[playerid][nitro] = 0;
		GameTextForPlayer(playerid, "~r~Nitro kapatildi!", 3000, 6);
	}
}



CMD:spawn(playerid, params[])
{
	ShowPlayerDialog(playerid, Spawn_Diyalog, DIALOG_STYLE_LIST, ""DiRenk_Kirmizi"Spawn Noktalari", ""DiRenk_Yesil"Los Santos\n"DiRenk_Yesil"San Fierro\n"DiRenk_Yesil"Las Venturas", "Sec", "Cik");
}

CMD:derbi(playerid, params[])
{
	ShowPlayerDialog(playerid, Derbi_Diyalog, DIALOG_STYLE_LIST, ""DiRenk_Kirmizi"Derbiler", ""DiRenk_Yesil"01 Hava Derbisi 1\n"DiRenk_Yesil"02 Hava Derbisi 2\n"DiRenk_Yesil"03 Hava Derbisi 3", "Katil/Cik", "Menuden Cik");
}

CMD:stuntlar(playerid, params[])
{
	if(stat[playerid][oyunmodu] == Freeroam)
	{
		ShowPlayerDialog(playerid, Stunt_Diyalog, DIALOG_STYLE_LIST, ""DiRenk_Kirmizi"Stunt Isinlanmalari", ""DiRenk_Yesil"Inis\n"DiRenk_Yesil"Inis2\n"DiRenk_Yesil"Stunt Adasi", "Isinlan", "Cik");
		
	} else GameTextForPlayer(playerid, "~r~Freeroamda Olman gerek!", 3000, 6);
}

CMD:adminlevel(playerid, params[])
{
	if(stat[playerid][Hesap_Admin] == 5 || IsPlayerAdmin(playerid))
	{
		new ID, level;
		if(sscanf(params, "ui", ID, level)) SendClientMessage(playerid, Renk_AcikKirmizi, "Kullanim: /adminlevel [Oyuncu] [Level]");
		else if(level < 1 || level > 5) SendClientMessage(playerid, Renk_AcikKirmizi, "Admin Leveli 1-5 arasi olmak zorundadir!");
		else if(ID == INVALID_PLAYER_ID) SendClientMessage(playerid, Renk_AcikKirmizi, "Bu oyuncu sunucuya bagli degil!");
		else
		{
		    stat[ID][Hesap_Admin] = level;
			GetPlayerName(playerid, oyuncu,sizeof(oyuncu));
			format(strings,sizeof(strings),"Admin levelin %s tarafindan %i yapildi!",oyuncu,stat[ID][Hesap_Admin]);
			SendClientMessage(ID, Renk_Sari, strings);
			GetPlayerName(ID, oyuncu, sizeof(oyuncu));
			format(strings,sizeof(strings),"%s Adli oyuncunun admin seviyesini %i yaptin.",oyuncu,level);
			SendClientMessage(playerid, Renk_Sari, strings);
		}
	}
	else SendClientMessage(playerid, Renk_AcikKirmizi, "Bu komudu kullanmak icin Admin olman gerek!");
}

CMD:kick(playerid, params[])
{
	if(stat[playerid][Hesap_Admin] > 0 || IsPlayerAdmin(playerid))
	{
	    new ID;
	    if(sscanf(params, "u", ID)) SendClientMessage(playerid, Renk_AcikKirmizi, "Kullanim /kick [oyuncuid]");
	    else
	    {
	        Kick(ID);
	    }
	}
}

CMD:hava(playerid, params[])
{
    if(stat[playerid][Hesap_Admin] >= 2 || IsPlayerAdmin(playerid))
    {
        new hava;
        GetPlayerName(playerid, oyuncu, sizeof(oyuncu));
		if(sscanf(params, "i", hava)) return SendClientMessage(playerid, Renk_AcikKirmizi, "Kullanim: /hava <id>");
		format(strings, sizeof(strings),"Yetkili %s havayi %i yapti!",oyuncu,hava);
		for(new i = 0; i < GetMaxPlayers(); i++)
		{
		    SetPlayerWeather(i, hava);
			SendClientMessage(i, Renk_AcikKirmizi, strings);
		}

	}
}



CMD:paraver(playerid, params[])
{
	if(stat[playerid][Hesap_Admin] == 5 || IsPlayerAdmin(playerid))
	{
		new ID;
		new miktar;
		if(sscanf(params, "ui", ID, miktar)) SendClientMessage(playerid, Renk_AcikKirmizi, "Kullanim: /paraver [oyuncu] [miktar]");
		else
		{
		    GivePlayerMoney(ID,miktar);
		    GetPlayerName(playerid, oyuncu, sizeof(oyuncu));
			format(strings,sizeof(strings),"%s adli yetkili size %i kadar para verdi!",oyuncu,miktar);
			SendClientMessage(ID,Renk_Yesil,strings);
  			GetPlayerName(ID, oyuncu, sizeof(oyuncu));
			format(strings,sizeof(strings),"%s adli oyuncuya %i kadar para verdiniz!",oyuncu,miktar);
			SendClientMessage(playerid,Renk_Yesil,strings);
		}
	} else SendClientMessage(playerid, Renk_AcikKirmizi, "Bu komutu kullanmak icin gerekli yetkiye sahip degilsin!");
}

CMD:skorver(playerid, params[])
{
	if(stat[playerid][Hesap_Admin] == 5 || IsPlayerAdmin(playerid))
	{
		new ID;
		new miktar;
		if(sscanf(params, "ui", ID, miktar)) SendClientMessage(playerid, Renk_AcikKirmizi, "Kullanim: /skorver [oyuncu] [miktar]");
		else
		{
		    GivePlayerScore(ID, miktar);
		    GetPlayerName(playerid, oyuncu, sizeof(oyuncu));
			format(strings,sizeof(strings),"%s adli yetkili size %i kadar skor verdi!",oyuncu,miktar);
			SendClientMessage(ID,Renk_Yesil,strings);
  			GetPlayerName(ID, oyuncu, sizeof(oyuncu));
			format(strings,sizeof(strings),"%s adli oyuncuya %i kadar skor verdiniz!",oyuncu,miktar);
			SendClientMessage(playerid,Renk_Yesil,strings);
		}
	} else SendClientMessage(playerid, Renk_AcikKirmizi, "Bu komutu kullanmak icin gerekli yetkiye sahip degilsin!");
}

CMD:parabelirle(playerid, params[])
{
	if(stat[playerid][Hesap_Admin] == 5 || IsPlayerAdmin(playerid))
	{
		new ID;
		new miktar;
		if(sscanf(params, "ui", ID, miktar)) SendClientMessage(playerid, Renk_AcikKirmizi, "Kullanim: /parabelirle [oyuncu] [miktar]");
		else
		{
		    SetPlayerMoney(ID,miktar);
		    GetPlayerName(playerid, oyuncu, sizeof(oyuncu));
			format(strings,sizeof(strings),"%s adli yetkili paranizi %i yapti!",oyuncu,miktar);
			SendClientMessage(ID,Renk_Yesil,strings);
  			GetPlayerName(ID, oyuncu, sizeof(oyuncu));
			format(strings,sizeof(strings),"%s adli oyuncunun parasini %i yaptiniz !",oyuncu,miktar);
			SendClientMessage(playerid,Renk_Yesil,strings);
		}
	} else SendClientMessage(playerid, Renk_AcikKirmizi, "Bu komutu kullanmak icin gerekli yetkiye sahip degilsin!");
}


CMD:skorbelirle(playerid, params[])
{
	if(stat[playerid][Hesap_Admin] == 5 || IsPlayerAdmin(playerid))
	{
	    new ID;
	    new miktar;

	    if(sscanf(params, "ui", ID, miktar)) SendClientMessage(playerid, Renk_AcikKirmizi, "Kullanim: /skorbelirle [oyuncu] [miktar]");
		else
		{
		    SetPlayerScore(ID, miktar);
		    GetPlayerName(playerid, oyuncu, sizeof(oyuncu));
			format(strings,sizeof(strings),"%s adli yetkili skorunuzu %i yapti!",oyuncu,miktar);
			SendClientMessage(ID,Renk_Yesil,strings);
  			GetPlayerName(ID, oyuncu, sizeof(oyuncu));
			format(strings,sizeof(strings),"%s adli oyuncunun skorunu %i yaptiniz !",oyuncu,miktar);
			SendClientMessage(playerid,Renk_Yesil,strings);
		}

	}
}

CMD:aracolustur(playerid, params[])
{
	if(stat[playerid][Hesap_Admin] > 2 || IsPlayerAdmin(playerid))
	{
	    new ID;
	    if(sscanf(params, "i", ID)) SendClientMessage(playerid, Renk_AcikKirmizi, "Kullanim: /aracolustur [AracId]");
	    else
		{
			new araba;
		    new Float:x, Float:y, Float:z, Float:a;
		    GetPlayerPos(playerid,x,y,z);
		    GetPlayerFacingAngle(playerid, a);
		    new renk[2];
		    renk[0] = random(255) + 1;
		    renk[1] = random(255) + 1;
		    if(AracIDKontrol(ID))
		    {
		    araba = CreateVehicle(ID, x + 5, y, z, a, renk[0], renk[1], -1);
		    SetVehicleVirtualWorld(araba, GetPlayerVirtualWorld(playerid));
		    SendClientMessage(playerid, Renk_Mavi, "Arac olusturuldu");
			} else SendClientMessage(playerid, Renk_AcikKirmizi, "Yazdigin Arac IDsi bulunamadi duzgun bir Arac IDsi yaz.");
		}
	} else SendClientMessage(playerid, Renk_AcikKirmizi, "Bu komutu kullanmak icin gerekli yetkiye sahip degilsin");
}

CMD:can(playerid, params[])
{
	if(stat[playerid][Hesap_Admin] > 2 || IsPlayerAdmin(playerid))
	{
		new ID;
		new can;
	    if(sscanf(params, "ui", ID, can)) return SendClientMessage(playerid, Renk_AcikKirmizi, "Kullanim: /can <oyuncu> <miktar>");
	    SetPlayerHealth(ID, can);
	    GetPlayerName(playerid, oyuncu, sizeof(oyuncu));
	    format(strings, sizeof(strings), "%s adli yetkili canini %i olarak belirledi!", oyuncu, can);
	    SendClientMessage(ID, Renk_Yesil, strings );
	    GetPlayerName(ID, oyuncu, sizeof(oyuncu));
	    format(strings, sizeof(strings), "%s adli oyuncunun canini %i olarak belirledin!", oyuncu, can);
	    SendClientMessage(playerid, Renk_Yesil, strings );
	}
}

CMD:tpkapat(playerid, params[])
{
	if(stat[playerid][tp] == true)
	{
	    stat[playerid][tp] = false;
	    SendClientMessage(playerid, Renk_AcikKirmizi, "Diger oyuncular yanina isinlanamicak bu komudu tekrar yazarak isinlanmayi tekrar acabilirsin!");
	}
	else if(stat[playerid][tp] == false)
	{
	    stat[playerid][tp] = true;
	    SendClientMessage(playerid, Renk_AcikKirmizi, "Diger oyuncular artik yanina isinlanabilir!");
	}
}

CMD:silahlarisifirla(playerid, params[])
{
	ResetPlayerWeapons(playerid);
	GameTextForPlayer(playerid, "~y~Silahlarini sifirladin!", 3000, 6);
}

CMD:aracrengi(playerid, params[])
{
	new renk;
	new renk2;
	if(sscanf(params, "ii", renk, renk2)) SendClientMessage(playerid, Renk_AcikKirmizi, "Kullanim: /aracrengi [renkno] [ikincirenkno]");
	else
	{
	    ChangeVehicleColor(GetPlayerVehicleID(playerid), renk, renk2);
	    GameTextForPlayer(playerid, "~y~Aracin rengi degistirildi!", 3000, 6);
	}
}




CMD:soncp(playerid, params[])
{
new cparac;
new Float:aci;
cparac = GetPlayerVehicleID(playerid);
GetVehicleZAngle(cparac, aci);
SetVehicleZAngle(cparac, aci);
switch (stat[playerid][oyunmodu])
{
	case Yaris_Sahil:
	{
		SetVehiclePos(cparac,Yaris_SahilCheckpoint[stat[playerid][Yaris_SahilCP] - 1 ][0],Yaris_SahilCheckpoint[stat[playerid][Yaris_SahilCP] - 1][1],Yaris_SahilCheckpoint[stat[playerid][Yaris_SahilCP] - 1 ][2]);
	}
	case Yaris_KoyTuru:
	{
		SetVehiclePos(cparac,Yaris_KoyTuruCheckpoint[stat[playerid][Yaris_KoyTuruCP] - 1 ][0],Yaris_KoyTuruCheckpoint[stat[playerid][Yaris_KoyTuruCP] - 1][1],Yaris_KoyTuruCheckpoint[stat[playerid][Yaris_KoyTuruCP] - 1 ][2]);
	}
	case Yaris_Vinewood:
	{
		SetVehiclePos(cparac,Yaris_VinewoodCheckpoint[stat[playerid][Yaris_VinewoodCP] - 1 ][0],Yaris_VinewoodCheckpoint[stat[playerid][Yaris_VinewoodCP] - 1 ][1],Yaris_VinewoodCheckpoint[stat[playerid][Yaris_VinewoodCP] - 1 ][2]);
	}
	case Yaris_LSOtoyol:
	{
		SetVehiclePos(cparac,Yaris_LSOtoyolCheckpoint[stat[playerid][Yaris_LSOtoyolCP] - 1 ][0],Yaris_LSOtoyolCheckpoint[stat[playerid][Yaris_LSOtoyolCP] - 1 ][1],Yaris_LSOtoyolCheckpoint[stat[playerid][Yaris_LSOtoyolCP] - 1][2]);
	}
	case Yaris_LVYarisi:
	{

		SetVehiclePos(cparac,Yaris_LVYarisiCheckpoint[stat[playerid][Yaris_LVYarisiCP] - 1 ][0],Yaris_LVYarisiCheckpoint[stat[playerid][Yaris_LVYarisiCP] - 1 ][1],Yaris_LVYarisiCheckpoint[stat[playerid][Yaris_LVYarisiCP] - 1 ][2]);
	}
	case Yaris_Col:
	{
		SetVehiclePos(cparac,Yaris_ColCheckpoint[stat[playerid][Yaris_ColCP] - 1][0],Yaris_ColCheckpoint[stat[playerid][Yaris_ColCP] - 1][1],Yaris_ColCheckpoint[stat[playerid][Yaris_ColCP] - 1][2]);
	}
	case Yaris_Denizkenari:
	{
		SetVehiclePos(cparac,Yaris_DenizkenariCheckpoint[stat[playerid][Yaris_DenizkenariCP] - 1 ][0],Yaris_DenizkenariCheckpoint[stat[playerid][Yaris_DenizkenariCP] - 1 ][1],Yaris_DenizkenariCheckpoint[stat[playerid][Yaris_DenizkenariCP] - 1 ][2]);
	}
	case Yaris_SanFierro:
	{
		SetVehiclePos(cparac, Yaris_SanFierroCheckpoint[stat[playerid][Yaris_SanFierroCP] - 1][0], Yaris_SanFierroCheckpoint[stat[playerid][Yaris_SanFierroCP] - 1 ][1],Yaris_SanFierroCheckpoint[stat[playerid][Yaris_SanFierroCP] - 1 ][2]);
	}
	case Yaris_Ucagayetis:
	{
	    SetVehiclePos(cparac, Yaris_UcagayetisCheckpoint[stat[playerid][Yaris_UcagayetisCP] - 1][0], Yaris_UcagayetisCheckpoint[stat[playerid][Yaris_UcagayetisCP] - 1 ][1],Yaris_UcagayetisCheckpoint[stat[playerid][Yaris_UcagayetisCP] - 1 ][2]);
	}
	case Yaris_SanAndreas:
	{
	    SetVehiclePos(cparac, Yaris_SanAndreasCheckpoint[stat[playerid][Yaris_SanAndreasCP] - 1][0], Yaris_SanAndreasCheckpoint[stat[playerid][Yaris_SanAndreasCP] - 1 ][1],Yaris_SanAndreasCheckpoint[stat[playerid][Yaris_SanAndreasCP] - 1 ][2]);
	}
		
}
PutPlayerInVehicle(playerid, cparac, 0);
}







public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if (response){
		switch(dialogid)
		{
		    case Ban_Diyalog:
		    {
				return(Kick(playerid));
		    }
			case Arac_Diyalog:
			{
				switch(listitem)
				{
					case 0:
					{
					ShowModelSelectionMenu(playerid, Ucak, "Ucak");
					}
					case 1:
					{
					ShowModelSelectionMenu(playerid, Motor, "Motor");
					}
					case 2:
					{
					ShowModelSelectionMenu(playerid, Bot, "Bot");
					}
					case 3:
					{
					ShowModelSelectionMenu(playerid, Donusturulebilir, "Donusturulebilir");
					}
					case 4:
					{
					ShowModelSelectionMenu(playerid, Helikopter, "Helikopter");
					}
					case 5:
					{
					ShowModelSelectionMenu(playerid, Endustri, "Endustri");
					}
					case 6:
					{
					ShowModelSelectionMenu(playerid, Lowrider, "Lowrider");
					}
					case 7:
					{
					ShowModelSelectionMenu(playerid, OffRoad, "OffRoad");
					}
					case 8:
					{
					ShowModelSelectionMenu(playerid, Belediye, "Belediye");
					}
					case 9:
					{
					ShowModelSelectionMenu(playerid, RC, "RC");
					}
					case 10:
					{
					ShowModelSelectionMenu(playerid, Klasik, "Klasik");
					}
					case 11:
					{
					ShowModelSelectionMenu(playerid, Spor, "Spor Arabalar");
					}
					case 12:
					{
					ShowModelSelectionMenu(playerid, StationWagon, "StationWagon");
					}
					case 13:
					{
					ShowModelSelectionMenu(playerid, Yuk, "Yuk");
					}
					case 14:
					{
					ShowModelSelectionMenu(playerid, Diger, "Diger");
					}
				}
			}
			case Silah_Diyalog:
			{
				switch(listitem)
				{
					case 0:
					{
						GivePlayerWeapon(playerid,22, 999);
					}
					case 1:
					{
						GivePlayerWeapon(playerid,23, 999);
					}
					case 2:
					{
						GivePlayerWeapon(playerid,24, 999);
					}
					case 3:
					{
						GivePlayerWeapon(playerid,25, 999);
					}
					case 4:
					{
						GivePlayerWeapon(playerid,26, 999);
					}
					case 5:
					{
						GivePlayerWeapon(playerid,27, 999);
					}
					case 6:
					{
						GivePlayerWeapon(playerid,28, 999);
					}
					case 7:
					{
						GivePlayerWeapon(playerid,29, 999);
					}
					case 8:
					{
						GivePlayerWeapon(playerid,30, 999);
					}
					case 9:
					{
						GivePlayerWeapon(playerid,31, 999);
					}
					case 10:
					{
						GivePlayerWeapon(playerid,32, 999);
					}
					case 11:
					{
						GivePlayerWeapon(playerid,33, 999);
					}
					case 12:
					{
						GivePlayerWeapon(playerid,34, 999);
					}

				}
			}
			case Isinlanma_Diyalog:
			{
				switch(listitem)
				{
				case 0:
				{
					isinlan(playerid,i_grove);
				}
				case 1:
				{
					isinlan(playerid,i_sfgaraj);
				}
				case 2:
				{
					isinlan(playerid,i_fourdragon);
				}
				case 3:
				{
					isinlan(playerid,i_dag);
				}
				case 4:
				{
					isinlan(playerid,i_area69);
				}
				case 5:
				{
					isinlan(playerid,i_locolow);
				}
				case 6:
				{
					isinlan(playerid,i_transfender);
				}
				case 7:
				{
					isinlan(playerid,i_wheelarc);
				}
				}
			}
			case Esya_Diyalog:
			{
				switch(listitem)
				{ 
					case 0:
					{
						GivePlayerWeapon(playerid,43,999);
					}
					case 1:
					{
						GivePlayerWeapon(playerid,46,999);
					}
					case 2:
					{
						GivePlayerWeapon(playerid,41,999);
					}
					case 3:
					{
						GivePlayerWeapon(playerid,15,1);
					}
					case 4:
					{
						GivePlayerWeapon(playerid,14,1);
					}
					case 5:
					{
						GivePlayerWeapon(playerid,1,1);
					}
					case 6:
					{
						GivePlayerWeapon(playerid,2,1);
					}
					case 7:
					{
						GivePlayerWeapon(playerid,3,1);
					}
					case 8:
					{
						GivePlayerWeapon(playerid,4,1);
					}
					case 9:
					{
						GivePlayerWeapon(playerid,5,1);
					}
					case 10:
					{
						GivePlayerWeapon(playerid,6,1);
					}
					case 11:
					{
						GivePlayerWeapon(playerid,8,1);
					}
					case 12:
					{
						GivePlayerWeapon(playerid,9,1);
	
					}
				}
			}
			case Anim_Diyalog:
			{
				switch(listitem)
				{
					case 0:
					{
						ApplyAnimation(playerid, "DANCING", "dnce_M_e", 4.1, 1, 1, 1, 1, 1, 1);
					}
					case 1:
					{
						ApplyAnimation(playerid, "DANCING", "dnce_M_d", 4.1, 1, 1, 1, 1, 1, 1);
					}
					case 2:
					{
						ApplyAnimation(playerid, "ped", "WALK_DRUNK", 4.1, 1, 1, 1, 1, 1, 1);
					}
					case 3:
					{
						ApplyAnimation(playerid, "BEACH", "ParkSit_M_loop", 4.1, 1, 1, 1, 1, 1, 1);
					}
					case 4:
					{
						ApplyAnimation(playerid, "ped", "phone_talk", 4.1, 1, 1, 1, 1, 1, 1);
					}
				}
			}
			case Dovus_Diyalog:
			{
				switch(listitem)
				{
					case 0:
					{
						SetPlayerFightingStyle (playerid, FIGHT_STYLE_NORMAL);
					}
					case 1:
					{
						SetPlayerFightingStyle (playerid, FIGHT_STYLE_BOXING);
					}
					case 2:
					{
						SetPlayerFightingStyle (playerid, FIGHT_STYLE_KUNGFU);
					}
					case 3:
					{
						SetPlayerFightingStyle (playerid, FIGHT_STYLE_KNEEHEAD);
					}
					case 4:
					{
						SetPlayerFightingStyle (playerid, FIGHT_STYLE_GRABKICK);
					}
					case 5:
					{
						SetPlayerFightingStyle (playerid, FIGHT_STYLE_ELBOW);
					}
				}
			}
			case Olummaci_Diyalog:
			{
				switch(listitem)
				{
					case 0:
					{
							if(stat[playerid][oyunmodu] == Freeroam)
							{
								stat[playerid][oyunmodu] = OM_Istasyon;
								GameTextForPlayer(playerid, "Istasyon", 5000, 1);
								SetPlayerVirtualWorld(playerid, OM_Istasyon);
								SetPlayerInterior(playerid, 0);
								new rand = random(sizeof(OMSpawn));
								ResetPlayerWeapons(playerid);
								GivePlayerWeapon(playerid, 26, 999);
								GivePlayerWeapon(playerid, 30, 999);
								GivePlayerWeapon(playerid, 32, 999);
								SetPlayerPos(playerid, OMSpawn[rand][0], OMSpawn[rand][1], OMSpawn[rand][2]);
							}
							else if(stat[playerid][oyunmodu] == OM_Istasyon)
							{
								stat[playerid][oyunmodu] = Freeroam;
								SendClientMessage(playerid, Renk_Yesil, "Olum macindan basariyla ciktin");
								SetPlayerVirtualWorld(playerid, 0);
								SetPlayerInterior(playerid, 0);
							}
							else GameTextForPlayer(playerid, "~r~Freeroamda olman gerek!", 3000, 6);
					}
					case 1:
					{
							if(stat[playerid][oyunmodu] == Freeroam)
							{
								stat[playerid][oyunmodu] = OM_Minigun;
								GameTextForPlayer(playerid, "Minigun Cilginligi", 5000, 1);
								SetPlayerVirtualWorld(playerid, OM_Minigun);
								SetPlayerInterior(playerid, 0);
								new rand = random(sizeof(OM_MinigunSpawn));
								ResetPlayerWeapons(playerid);
								GivePlayerWeapon(playerid, 38, 999);
								SetPlayerPos(playerid, OM_MinigunSpawn[rand][0], OM_MinigunSpawn[rand][1], OM_MinigunSpawn[rand][2]);
								
							}
							else if(stat[playerid][oyunmodu] == OM_Minigun)
							{
							    ResetPlayerWeapons(playerid);
								stat[playerid][oyunmodu] = Freeroam;
								SendClientMessage(playerid, Renk_Yesil, "Olum macindan ciktin");
								SetPlayerVirtualWorld(playerid, 0);
								SetPlayerInterior(playerid, 0);
							}
							else GameTextForPlayer(playerid, "~r~Freeroamda olman gerek!", 3000, 6);
					}
					case 2:
					{
							if(stat[playerid][oyunmodu] == Freeroam)
							{
								stat[playerid][oyunmodu] = OM_TekVurus;
								GameTextForPlayer(playerid, "Tek Vurus", 5000, 1);
								SetPlayerVirtualWorld(playerid, OM_TekVurus);
								SetPlayerInterior(playerid, 0);
								new rand = random(sizeof(OM_TekVurusSpawn));
								ResetPlayerWeapons(playerid);
								GivePlayerWeapon(playerid,23, 999);
								SetPlayerHealth(playerid, 10.0);
								SetPlayerPos(playerid, OM_TekVurusSpawn[rand][0], OM_TekVurusSpawn[rand][1], OM_TekVurusSpawn[rand][2]);
							}
							else if(stat[playerid][oyunmodu] == OM_TekVurus)
							{
								stat[playerid][oyunmodu] = Freeroam;
								SendClientMessage(playerid, Renk_Yesil, "Olum macindan ciktin");
								SetPlayerVirtualWorld(playerid, 0);
								SetPlayerInterior(playerid, 0);
							}
							else GameTextForPlayer(playerid, "~r~Freeroamda olman gerek!", 3000, 6);
					}
					case 3:
					{
							if(stat[playerid][oyunmodu] == Freeroam)
							{
								stat[playerid][oyunmodu] = OM_Grove;
								GameTextForPlayer(playerid, "Grove Savasi", 5000, 1);
								SetPlayerVirtualWorld(playerid, OM_Grove);
								SetPlayerInterior(playerid, 0);
								new rand = random(sizeof(OM_GroveSpawn));
								ResetPlayerWeapons(playerid);
								GivePlayerWeapon(playerid,31, 999);
								GivePlayerWeapon(playerid,34, 999);
								GivePlayerWeapon(playerid,27, 999);
								SetPlayerPos(playerid, OM_GroveSpawn[rand][0], OM_GroveSpawn[rand][1], OM_GroveSpawn[rand][2]);
								
							}
							else if(stat[playerid][oyunmodu] == OM_Grove)
							{
								stat[playerid][oyunmodu] = Freeroam;
								SendClientMessage(playerid, Renk_Yesil, "Olum Macindan Ciktin");
								SetPlayerVirtualWorld(playerid, Freeroam);
								SetPlayerInterior(playerid, 0);
						
							}
							else GameTextForPlayer(playerid, "~r~Freeroamda olman gerek!", 3000, 6);
					}
					case 4:
					{
							if(stat[playerid][oyunmodu] == Freeroam)
							{
								stat[playerid][oyunmodu] = OM_Area69;
								GameTextForPlayer(playerid, "Area69", 5000, 1);
								SetPlayerInterior(playerid, 0);
								SetPlayerVirtualWorld(playerid, OM_Area69);
								ResetPlayerWeapons(playerid);
								GivePlayerWeapon(playerid, 31, 999);
								GivePlayerWeapon(playerid, 33, 999);
								GivePlayerWeapon(playerid, 29, 999);
								new rand = random(sizeof(OM_Area69Spawn));
								SetPlayerPos(playerid, OM_Area69Spawn[rand][0], OM_Area69Spawn[rand][1], OM_Area69Spawn[rand][2]);
							}
							else if(stat[playerid][oyunmodu] == OM_Area69)
							{
								stat[playerid][oyunmodu] = Freeroam;
								SendClientMessage(playerid, Renk_Yesil, "Olum Macindan Ciktin");
								SetPlayerVirtualWorld(playerid, Freeroam);
								SetPlayerInterior(playerid, 0);
							}
							else GameTextForPlayer(playerid, "~r~Freeroamda olman gerek!", 3000, 6);
					}
					case 5:
					{
							if(stat[playerid][oyunmodu] == Freeroam)
							{
								stat[playerid][oyunmodu] = OM_Pier69;
								GameTextForPlayer(playerid, "Pier69", 5000, 1);
								SetPlayerInterior(playerid, 0);
								SetPlayerVirtualWorld(playerid, OM_Pier69);
								ResetPlayerWeapons(playerid);
								GivePlayerWeapon(playerid, 30, 999);
								GivePlayerWeapon(playerid, 28, 999);
								GivePlayerWeapon(playerid, 18, 10);
								new rand = random(sizeof(OM_Pier69Spawn));
								SetPlayerPos(playerid, OM_Pier69Spawn[rand][0], OM_Pier69Spawn[rand][1], OM_Pier69Spawn[rand][2]);
							}
							else if(stat[playerid][oyunmodu] == OM_Pier69)
							{
								stat[playerid][oyunmodu] = Freeroam;
								SendClientMessage(playerid, Renk_Yesil, "Olum Macindan Ciktin");
								SetPlayerVirtualWorld(playerid, Freeroam);
								SetPlayerInterior(playerid, 0);
							}
							else GameTextForPlayer(playerid, "~r~Freeroamda olman gerek!", 3000, 6);
					}
					case 6:
					{
						if(stat[playerid][oyunmodu] == Freeroam)
						{
							stat[playerid][oyunmodu] = OM_Rpg;
							GameTextForPlayer(playerid, "Rpg", 5000, 1);
							SetPlayerInterior(playerid, 0);
							SetPlayerVirtualWorld(playerid, OM_Rpg);
							ResetPlayerWeapons(playerid);
							GivePlayerWeapon(playerid, 35, 999);
							new rand = random(sizeof(OM_RpgSpawn));
							SetPlayerPos(playerid, OM_RpgSpawn[rand][0], OM_RpgSpawn[rand][1], OM_RpgSpawn[rand][2]);
						} else if (stat[playerid][oyunmodu] == OM_Rpg)
						{
							stat[playerid][oyunmodu] = Freeroam;
							SendClientMessage(playerid, Renk_Yesil, "Olum Macindan Ciktin!");
							SetPlayerVirtualWorld(playerid, Freeroam);
							SetPlayerInterior(playerid, 0);
						} else SendClientMessage(playerid, Renk_AcikKirmizi, "Freeroamda olman gerek!");
					}
					case 7:
					{
						if(stat[playerid][oyunmodu] == Freeroam)
						{
							stat[playerid][oyunmodu] = OM_Jetpack;
							GameTextForPlayer(playerid, "Jetpack", 5000, 1);
							SetPlayerInterior(playerid, 0);
							SetPlayerVirtualWorld(playerid, OM_Jetpack);
							ResetPlayerWeapons(playerid);
							GivePlayerWeapon(playerid, 28, 999);
							new rand = random(sizeof(OM_JetpackSpawn));
							SetPlayerPos(playerid, OM_JetpackSpawn[rand][0], OM_JetpackSpawn[rand][1], OM_JetpackSpawn[rand][2]);
							SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
						} else if (stat[playerid][oyunmodu] == OM_Jetpack)
						{
							stat[playerid][oyunmodu] = Freeroam;
							SendClientMessage(playerid, Renk_Yesil, "Olum Macindan Ciktin!");
							SetPlayerVirtualWorld(playerid, Freeroam);
							SetPlayerInterior(playerid, 0);
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
						} else SendClientMessage(playerid, Renk_AcikKirmizi, "Freeroamda olman gerek!");
					}
				
				}
			}
			case Gorev_Diyalog:
			{
			    switch(listitem)
			    {
			        case 0:
			        {
			            if(stat[playerid][oyunmodu] == Freeroam)
			            {
			                stat[playerid][oyunmodu] = Gorev_Saldiri;
			            }
			            else if(stat[playerid][oyunmodu] == Gorev_Saldiri)
			            {
			            
			            }
			            else
						{
							SendClientMessage(playerid, Renk_AcikKirmizi, "Freeroamda olman gerek!");
      					}
					}
			        case 1:
					{

					}
			    }
			}
			case Derbi_Diyalog:
			{
				switch(listitem)
				{
				case 0:
				{
					if(stat[playerid][oyunmodu] == Freeroam)
					{
						SetPlayerVirtualWorld(playerid, Derbi_Hava);
						GetPlayerName(playerid, oyuncu, sizeof(oyuncu));
						GameTextForPlayer(playerid, "Hava Derbisi 1", 5000, 1);
						format(strings,sizeof(strings), "%s Hava Derbisi 1e katildi !", oyuncu);
						SendClientMessageToAll(Renk_Sari, strings);
						stat[playerid][oyunmodu] = Derbi_Hava;
						new Renk[2];
						new rand;
						new rand2;
						Renk[0] = random(255) + 1;
						Renk[1] = random(255) + 1;
						rand = random(sizeof(Derbi_Hava_Spawn));
						rand2 = random(sizeof(Derbi_HavaAraclari));
						stat[playerid][derbiarac] = CreateVehicle(Derbi_HavaAraclari[rand2][0], Derbi_Hava_Spawn[rand][0], Derbi_Hava_Spawn[rand][1], Derbi_Hava_Spawn[rand][2], Derbi_Hava_Spawn[rand][3], Renk[0], Renk[1], -1);
						SetVehicleVirtualWorld(stat[playerid][derbiarac],Derbi_Hava);
						PutPlayerInVehicle(playerid,stat[playerid][derbiarac], 0);
					}
					else if (stat[playerid][oyunmodu] == Derbi_Hava)
					{
						stat[playerid][oyunmodu] = Freeroam;
						SetPlayerVirtualWorld(playerid, 0);
						SendClientMessage(playerid, Renk_Sari, "Derbiden basariyla ciktin!");
						DestroyVehicle(stat[playerid][derbiarac]);
						if(stat[playerid][spawn] == LS)
						{
							new rand = random(sizeof(LSSpawn));
							SetPlayerPos(playerid, LSSpawn[rand][0],LSSpawn[rand][1], LSSpawn[rand][2]);
						}
						else if (stat[playerid][spawn] == SF)
						{
							new rand = random(sizeof(SFSpawn));
							SetPlayerPos(playerid, SFSpawn[rand][0], SFSpawn[rand][1], SFSpawn[rand][2]);	
						}
						else //Las Venturas 
						{
							new rand = random(sizeof(LVSpawn));
							SetPlayerPos(playerid, LVSpawn[rand][0], LVSpawn[rand][1], LVSpawn[rand][2]);		
						}
					}
					else SendClientMessage(playerid, Renk_AcikKirmizi, "Freeroamda olman gerek!");
				}
				case 1:
				{
					if(stat[playerid][oyunmodu] == Freeroam)
					{
						SetPlayerVirtualWorld(playerid, Derbi_Hava2);
						GetPlayerName(playerid, oyuncu, sizeof(oyuncu));
						GameTextForPlayer(playerid, "Hava Derbisi 2", 5000, 1);
						format(strings,sizeof(strings), "%s Hava Derbisi 2ye katildi !", oyuncu);
						SendClientMessageToAll(Renk_Sari, strings);
						stat[playerid][oyunmodu] = Derbi_Hava2;
						new Renk[2];
						new rand;
						new rand2;
						Renk[0] = random(255) + 1;
						Renk[1] = random(255) + 1;
						rand = random(sizeof(Derbi_Hava2_Spawn));
						rand2 = random(sizeof(Derbi_HavaAraclari));
						stat[playerid][derbiarac] = CreateVehicle(Derbi_HavaAraclari[rand2][0], Derbi_Hava2_Spawn[rand][0], Derbi_Hava2_Spawn[rand][1], Derbi_Hava2_Spawn[rand][2], Derbi_Hava2_Spawn[rand][3], Renk[0], Renk[1], -1);
						SetVehicleVirtualWorld(stat[playerid][derbiarac],Derbi_Hava2);
						PutPlayerInVehicle(playerid,stat[playerid][derbiarac], 0);
						
					}
					else if (stat[playerid][oyunmodu] == Derbi_Hava2)
					{
						stat[playerid][oyunmodu] = Freeroam;
						SetPlayerVirtualWorld(playerid, 0);
						SendClientMessage(playerid, Renk_Sari, "Derbiden basariyla ciktin!");
						DestroyVehicle(stat[playerid][derbiarac]);
						if(stat[playerid][spawn] == LS)
						{
							new rand = random(sizeof(LSSpawn));
							SetPlayerPos(playerid, LSSpawn[rand][0],LSSpawn[rand][1], LSSpawn[rand][2]);
						}
						else if (stat[playerid][spawn] == SF)
						{
							new rand = random(sizeof(SFSpawn));
							SetPlayerPos(playerid, SFSpawn[rand][0], SFSpawn[rand][1], SFSpawn[rand][2]);	
						}
						else //Las Venturas 
						{
							new rand = random(sizeof(LVSpawn));
							SetPlayerPos(playerid, LVSpawn[rand][0], LVSpawn[rand][1], LVSpawn[rand][2]);		
						}
					} else SendClientMessage(playerid, Renk_AcikKirmizi, "Freeroamda olman gerek!");
					
				}
				case 2:
				{
					if(stat[playerid][oyunmodu] == Freeroam)
					{
						SetPlayerVirtualWorld(playerid, Derbi_Hava3);
						GetPlayerName(playerid, oyuncu, sizeof(oyuncu));
						GameTextForPlayer(playerid, "Hava Derbisi 3", 5000, 1);
						format(strings,sizeof(strings), "%s Hava Derbisi 3e katildi !", oyuncu);
						SendClientMessageToAll(Renk_Sari, strings);
						stat[playerid][oyunmodu] = Derbi_Hava3;
						new Renk[2];
						new rand;
						new rand2;
						Renk[0] = random(255) + 1;
						Renk[1] = random(255) + 1;
						rand = random(sizeof(Derbi_Hava3_Spawn));
						rand2 = random(sizeof(Derbi_HavaAraclari));
						stat[playerid][derbiarac] = CreateVehicle(Derbi_HavaAraclari[rand2][0], Derbi_Hava3_Spawn[rand][0], Derbi_Hava3_Spawn[rand][1], Derbi_Hava3_Spawn[rand][2], Derbi_Hava3_Spawn[rand][3], Renk[0], Renk[1], -1);
						SetVehicleVirtualWorld(stat[playerid][derbiarac],Derbi_Hava3);
						PutPlayerInVehicle(playerid,stat[playerid][derbiarac], 0);
						
					}
					else if (stat[playerid][oyunmodu] == Derbi_Hava3)
					{
						stat[playerid][oyunmodu] = Freeroam;
						SetPlayerVirtualWorld(playerid, 0);
						SendClientMessage(playerid, Renk_Sari, "Derbiden basariyla ciktin!");
						DestroyVehicle(stat[playerid][derbiarac]);
						if(stat[playerid][spawn] == LS)
						{
							new rand = random(sizeof(LSSpawn));
							SetPlayerPos(playerid, LSSpawn[rand][0],LSSpawn[rand][1], LSSpawn[rand][2]);
						}
						else if (stat[playerid][spawn] == SF)
						{
							new rand = random(sizeof(SFSpawn));
							SetPlayerPos(playerid, SFSpawn[rand][0], SFSpawn[rand][1], SFSpawn[rand][2]);	
						}
						else //Las Venturas 
						{
							new rand = random(sizeof(LVSpawn));
							SetPlayerPos(playerid, LVSpawn[rand][0], LVSpawn[rand][1], LVSpawn[rand][2]);		
						}
					} else SendClientMessage(playerid, Renk_AcikKirmizi, "Freeroamda olman gerek!");
				}
				}
			}
			case Tom_Diyalog:
			{
				switch(listitem)
				{
					case 0:
					{
						if(stat[playerid][oyunmodu] == Freeroam)
						{
							if(TOM_CeteSavasi_Durum == true) SendClientMessage(playerid,Renk_AcikKirmizi, "Cetesavasi baslatilmis!");
							else{
							if(TOM_CeteSavasi_Grove_Sayi + TOM_CeteSavasi_Ballas_Sayi == 0)
							{
								SendClientMessageToAll(Renk_Mavi, "[TOM]Cetesavasi baslatildi katilmak icin 25 saniyeniz var");
								GameTextForPlayer(playerid, "Cete Savasi", 5000, 1);
								SetTimer("TOM_CeteSavasi_Baslat", 25000, false);
								stat[playerid][oyunmodu] = TOM_CeteSavasi;
								TakimBelirle(playerid,TOM_CeteSavasi);
							}
							else{
							stat[playerid][oyunmodu] = TOM_CeteSavasi;
							GameTextForPlayer(playerid, "Cete Savasi", 5000, 1);
							TakimBelirle(playerid,TOM_CeteSavasi);
							}
							}
						}
						else if (stat[playerid][oyunmodu] == TOM_CeteSavasi)
						{
							if(TOM_CeteSavasi_Durum == true)
							{
								stat[playerid][oyunmodu] = Freeroam;
								SendClientMessage(playerid, Renk_AcikKirmizi, "Cete savasindan ciktin!");
								if(GetPlayerTeam(playerid) == Takim_Grove)
								{
									TOM_CeteSavasi_Grove_Sayi--;
									if(TOM_CeteSavasi_Grove_Sayi < 1) TOM_CeteSavasi_Kapat(TOM_CeteSavasi_Cikis);
									}
								if(GetPlayerTeam(playerid) == Takim_Ballas)
								{
									TOM_CeteSavasi_Ballas_Sayi--;
									if(TOM_CeteSavasi_Ballas_Sayi < 1) TOM_CeteSavasi_Kapat(TOM_CeteSavasi_Cikis);
								}
								SetPlayerTeam(playerid, NO_TEAM);
								}
							}
							else SendClientMessage(playerid, Renk_AcikKirmizi ,"Farkli bir minigamedesin once hangisindeysen ona tekrar basarak cik");
							
						
					}
					case 1:
					{
						if(stat[playerid][oyunmodu] == Freeroam)
						{
							if(TOM_LSSavasi_Durum == true) SendClientMessage(playerid, Renk_AcikKirmizi, "LS Savasi bir baskasi tarafindan baslatilmis lutfen oyunun bitmesini bekleyin!");
							else
							{
								if(TOM_LSSavasi_Mavi_Sayi + TOM_LSSavasi_Kirmizi_Sayi == 0)
								{
									SendClientMessageToAll(Renk_Mavi, "[TOM]Los Santos Savasi baslatildi katilmak icin 25 saniyeniz var");
									SetTimer("TOM_LSSavasi_Baslat", 25000, false);
									GameTextForPlayer(playerid, "LS Savasi", 5000, 1);
									stat[playerid][oyunmodu] = TOM_LSSavasi;
									TakimBelirle(playerid,TOM_LSSavasi);
								}
								else 
								{
									stat[playerid][oyunmodu] = TOM_LSSavasi;
									TakimBelirle(playerid,TOM_LSSavasi);
									GameTextForPlayer(playerid, "LS Savasi", 5000, 1);
								}
							}
							
						}
						else if(stat[playerid][oyunmodu] == TOM_LSSavasi)
						{
							if(TOM_LSSavasi_Durum == true)
							{
								stat[playerid][oyunmodu] = Freeroam;
								SendClientMessage(playerid, Renk_AcikKirmizi, "LS Savasindan ciktin!");
								if(GetPlayerTeam(playerid) == Takim_Mavi)
								{
									TOM_LSSavasi_Mavi_Sayi--;
									if(TOM_LSSavasi_Mavi_Sayi < 1) TOM_LSSavasi_Kapat(TOM_LSSavasi_Cikis);
								}
								if(GetPlayerTeam(playerid) == Takim_Kirmizi)
								{
									TOM_LSSavasi_Kirmizi_Sayi--;
									if(TOM_LSSavasi_Kirmizi_Sayi < 1) TOM_LSSavasi_Kapat(TOM_LSSavasi_Cikis);
								}
								SetPlayerTeam(playerid, NO_TEAM);
								SetPlayerColor(playerid, Renk_Beyaz);
							}
						}
						else SendClientMessage(playerid, Renk_AcikKirmizi, "Farkli bir minigamedesin once hangisindeysen ona tekrar basarak cik");
					}
					case 2:
					{
						if(stat[playerid][oyunmodu] == Freeroam)
						{
							if(TOM_Lunapark_Durum == true) SendClientMessage(playerid, Renk_AcikKirmizi, "Lunapark Savasi bir baskasi tarafindan baslatilmis lutfen oyunun bitmesini bekleyin!");
							else
							{
								if(TOM_Lunapark_Beyaz_Sayi + TOM_Lunapark_Siyah_Sayi == 0)
								{
									SendClientMessageToAll(Renk_Mavi, "[TOM]Lunapark Savasi baslatildi katilmak icin 25 saniyeniz var");
									SetTimer("TOM_Lunapark_Baslat", 25000, false);
									GameTextForPlayer(playerid, "Lunapark", 5000, 1);
									stat[playerid][oyunmodu] = TOM_Lunapark;
									TakimBelirle(playerid,TOM_Lunapark);
								}
								else 
								{
									stat[playerid][oyunmodu] = TOM_Lunapark;
									TakimBelirle(playerid,TOM_Lunapark);
									GameTextForPlayer(playerid, "Lunapark", 5000, 1);
								}
							}
						}
						else if(stat[playerid][oyunmodu] == TOM_Lunapark)
						{
								stat[playerid][oyunmodu] = Freeroam;
								SendClientMessage(playerid, Renk_AcikKirmizi, "Lunapark Savasindan ciktin!");
								if(GetPlayerTeam(playerid) == Takim_Beyaz)
								{
									TOM_Lunapark_Beyaz_Sayi--;
									if(TOM_Lunapark_Beyaz_Sayi < 1) TOM_Lunapark_Kapat(TOM_Lunapark_Cikis);
								}
								if(GetPlayerTeam(playerid) == Takim_Siyah)
								{
									TOM_Lunapark_Siyah_Sayi--;
									if(TOM_Lunapark_Siyah_Sayi < 1) TOM_Lunapark_Kapat(TOM_Lunapark_Cikis);
								}
								SetPlayerTeam(playerid, NO_TEAM);
								SetPlayerColor(playerid, Renk_Beyaz);
						}
						else SendClientMessage(playerid, Renk_AcikKirmizi, "Freeroamda olman gerek!");
					}
					case 3:
					{
					    if(stat[playerid][oyunmodu] == Freeroam)
					    {
							if(TOM_Gemi_Durum == true) SendClientMessage(playerid, Renk_AcikKirmizi, "Gemi savasi bir baskasi tarafindan baslatilmis lutfen oyunun bitmesini bekleyin!");
							else
							{
								if(TOM_Gemi_Aztecas_Sayi + TOM_Gemi_Vagos_Sayi == 0)
								{
									SendClientMessageToAll(Renk_Mavi, "[TOM]Gemi Savasi baslatildi katilmak icin 25 saniyeniz var /tom");
									SetTimer("TOM_Gemi_Baslat", 25000, false);
									stat[playerid][oyunmodu] = TOM_Gemi;
									GameTextForPlayer(playerid, "Gemi", 5000, 1);
									TakimBelirle(playerid,TOM_Gemi);
								}
								else
								{
									stat[playerid][oyunmodu] = TOM_Gemi;
									TakimBelirle(playerid,TOM_Gemi);
									GameTextForPlayer(playerid, "Gemi", 5000, 1);
								}
							}
					    }
					    else if(stat[playerid][oyunmodu] == TOM_Gemi)
					    {
					        stat[playerid][oyunmodu] = Freeroam;
					        SendClientMessage(playerid, Renk_AcikKirmizi, "Gemi savasindan ciktin!");
					        if(GetPlayerTeam(playerid) == Takim_Aztecas)
					        {
					            TOM_Gemi_Aztecas_Sayi--;
					            if(TOM_Gemi_Aztecas_Sayi < 1) TOM_Gemi_Kapat(TOM_Gemi_Cikis);
					        }
					        if(GetPlayerTeam(playerid) == Takim_Vagos)
					        {
					            TOM_Gemi_Vagos_Sayi--;
					            if(TOM_Gemi_Vagos_Sayi < 1) TOM_Gemi_Kapat(TOM_Gemi_Cikis);
					        }
					    }
					    else SendClientMessage(playerid, Renk_AcikKirmizi, "Freeroamda olman gerek!");
					}
				}
			}
			case Spawn_Diyalog:
			{
				switch(listitem)
				{
					case 0:
					{
						stat[playerid][spawn] = LS;
						SendClientMessage(playerid, Renk_Mavi, "Sonraki olumunde Los Santosda dogucaksin");
					}
					case 1:
					{
						stat[playerid][spawn] = SF;
						SendClientMessage(playerid, Renk_Mavi, "Sonraki olumunde San Fierroda dogucaksin");	
					}
					case 2:
					{
						stat[playerid][spawn] = LV;
						SendClientMessage(playerid, Renk_Mavi, "Sonraki olumunde Las Venturasda dogucaksin");
					}
				}
			}
			case Stunt_Diyalog:
			{
				switch(listitem)
				{
					case 0:
					{
						GameTextForPlayer(playerid, "~b~Inise Isinlandin!", 3000, 6);
						if(IsPlayerInAnyVehicle(playerid))
						{
							new starac;
							starac = GetPlayerVehicleID(playerid);
							SetVehiclePos(starac, -3523.5962,328.8964,539.9399);
							PutPlayerInVehicle(playerid, starac, 0);
						} else 
						{
							SetPlayerPos(playerid, -3523.5962,328.8964,539.9399);
						}
					}
					case 1:
					{
						GameTextForPlayer(playerid, "~b~Inis 2ye Isinlandin!", 3000, 6);
						if(IsPlayerInAnyVehicle(playerid))
						{
							new starac;
							starac = GetPlayerVehicleID(playerid);
							SetVehiclePos(starac, 3282.6086,-992.4430,501.3349);
							PutPlayerInVehicle(playerid, starac, 0);
						} else
						{
							SetPlayerPos(playerid, 3282.6086,-992.4430,501.3349);
						}
					}
					case 2:
					{
					    GameTextForPlayer(playerid, "~b~Stunt adasina Isinlandin!", 3000, 6);
					    if(IsPlayerInAnyVehicle(playerid))
					    {
							new starac = GetPlayerVehicleID(playerid);
							SetVehiclePos(starac, 3026.1055,-83.7026,2.5340);
							PutPlayerInVehicle(playerid, starac, 0);
					    }
					    else
					    {
					        SetPlayerPos(playerid,3026.1055,-83.7026,2.5340);
					    }
					}
				}
			}

			
			
			case Kayit_Diyalog:
			{
				if (!(3 <= strlen(inputtext) <= 20))
				{
				    SendClientMessage(playerid, Renk_AcikKirmizi, "[Hata] Sifreniz 3 ila 20 karakter arasi olmasi gerek.");
				    ShowPlayerDialog(playerid, Kayit_Diyalog, DIALOG_STYLE_PASSWORD, "Kayit Olma", "Sunucuda kayitli degilsiniz lutfen oynamak icin kayit olun", "Kayit ol", "Cik");
					return 1;
				}
				new
				    Query[208];
				    
				WP_Hash(stat[playerid][Hesap_Sifre], 129, inputtext);
				format(Query, sizeof Query, "INSERT INTO hesaplar (hesapadi, sifre) VALUES ('%q', '%s')", stat[playerid][Hesap_Adi], stat[playerid][Hesap_Sifre]);
				db_query(Database, Query);
				SendClientMessage(playerid, Renk_AcikKirmizi, "Sunucuya basariyla kayit oldun iyi oyunlar!");
				GivePlayerMoney(playerid, 3500);
				new
				    DBResult: Result;
				Result = db_query(Database, "SELECT last_insert_rowid()");
				stat[playerid][Hesap_ID] = db_get_field_int(Result);
				db_free_result(Result);
			}
			case Giris_Diyalog:
			{
				new
				    buf[129];
				WP_Hash(buf, 129, inputtext);
				
				if(strcmp(buf, stat[playerid][Hesap_Sifre]))
				{
				    SendClientMessage(playerid, Renk_AcikKirmizi, "[Hata]Yanlis Sifre!");
				    ShowPlayerDialog(playerid, Giris_Diyalog, DIALOG_STYLE_PASSWORD, "Giris Yapma", "Sunucuda oynamak icin lutfen sifrenizi asagiya girin.", "Giris Yap", "Cik");
				    return 1;
				}
				new
				    DBResult: Result;
				    
				format(buf,sizeof buf, "SELECT * FROM hesaplar WHERE hesapadi = '%q' LIMIT 1", stat[playerid][Hesap_Adi]);
				Result = db_query(Database, buf);
				if( db_num_rows(Result))
				{
				    stat[playerid][Hesap_ID] = db_get_field_assoc_int(Result, "hesapid");
				    stat[playerid][Hesap_Admin] = db_get_field_assoc_int(Result, "admin");
					stat[playerid][Para] = db_get_field_assoc_int(Result, "para");
					stat[playerid][Oldurmeler] = db_get_field_assoc_int(Result, "oldurme");
					stat[playerid][Olumler] = db_get_field_assoc_int(Result, "olum");
					stat[playerid][Skor] = db_get_field_assoc_int(Result, "skor");
					stat[playerid][Yariskazanma] = db_get_field_assoc_int(Result, "yariskazanma");
					stat[playerid][Tomkazanma] = db_get_field_assoc_int(Result, "tomkazanma");
					GivePlayerMoney(playerid,stat[playerid][Para]);
					SetPlayerScore(playerid,stat[playerid][Skor]);
				}
				db_free_result(Result);
			}
			case Yaris_Diyalog:
			{
				switch(listitem)
				{
					case 0:
					{
						if(Yaris_SahilDurum == false)
						{
						switch(stat[playerid][oyunmodu])
						{
							case Freeroam:
							{
								stat[playerid][oyunmodu] = Yaris_Sahil;
								if (Yaris_Sahil_Sayi == 0 )
								{
								    new yarismsj[120];
								    GetPlayerName(playerid, oyuncu, sizeof oyuncu);
								    GameTextForPlayer(playerid, "Sahil", 5000, 1);
								    format(yarismsj, sizeof yarismsj,"[Yaris] Sahil yarisi %s tarafindan acildi katilmak icin /yaris",oyuncu);
									SendClientMessageToAll(Renk_Yesil, yarismsj);
									Yaris_Sahil_Sayi++;
									stat[playerid][oyunmodu] = Yaris_Sahil;
									SetPlayerVirtualWorld(playerid, Yaris_Sahil);
									SetTimer("Yaris_Sahil_Baslat", 20000, false);
									SetVehiclePos(1, 1077.0348,-1849.1119,12.9556 );
									SetVehiclePos(2, 1074.8101,-1854.7354,12.9601 );
									SetVehiclePos(3, 1090.0740,-1854.9941,12.9552 );
									SetVehiclePos(4, 1091.0313,-1850.8690,12.9506 );
									SetVehiclePos(5, 1098.9108,-1850.2220,12.9541 );
									SetVehiclePos(6, 1099.0853,-1855.3566,12.9556 );
									SetVehicleZAngle(1, 90.4027);
									SetVehicleZAngle(2, 90.4027);
									SetVehicleZAngle(3, 90.4027);
									SetVehicleZAngle(4, 90.4027);
									SetVehicleZAngle(5, 90.4027);
									SetVehicleZAngle(6, 90.4027);
									PutPlayerInVehicle(playerid, 1, 0 );
									SetPlayerInterior(playerid, 0);
									TogglePlayerControllable(playerid,0);
								}
								else if (Yaris_Sahil_Sayi < 6 )
								{
	
									Yaris_Sahil_Sayi++;
									SetPlayerVirtualWorld(playerid, Yaris_Sahil);
									PutPlayerInVehicle(playerid, Yaris_Sahil_Sayi, 0 );
									GameTextForPlayer(playerid, "Sahil", 5000, 1);
									SendClientMessage(playerid, Renk_Yesil, "[Yaris] Sahil yarisina katildin");
									stat[playerid][oyunmodu] = Yaris_Sahil;
									SetPlayerInterior(playerid, 0);
									TogglePlayerControllable(playerid,0);
								}
								else SendClientMessage(playerid, Renk_Kirmizi, "[Yaris] Yarisa maksimum 6 kisi katilabilir");
							}

						}
						} else SendClientMessage(playerid, Renk_Kirmizi, "[Yaris] Bu yaris baslatilmis");
					}
					case 1:
					{
						if(Yaris_KoyTuruDurum == false)
						{
							switch(stat[playerid][oyunmodu])
							{
							case Freeroam:
							{
								stat[playerid][oyunmodu] = Yaris_KoyTuru;
								if(Yaris_KoyTuru_Sayi == 0)
								{
									Yaris_KoyTuru_Sayi++;
									new yarismsj[120];
									GetPlayerName(playerid, oyuncu, sizeof oyuncu);
									GameTextForPlayer(playerid, "Koy Turu", 5000, 1);
									format(yarismsj, sizeof yarismsj,"[Yaris] Koyturu yarisi %s tarafindan acildi katilmak icin /yaris",oyuncu);
									SendClientMessageToAll(Renk_Yesil, yarismsj);
									stat[playerid][oyunmodu] = Yaris_KoyTuru;
									SetPlayerVirtualWorld(playerid,Yaris_KoyTuru);
									SetVehiclePos(7,644.5322,-579.5090,16.0191);
									SetVehiclePos(8,638.6627,-579.2821,16.0192);
									SetVehiclePos(9,639.3431,-566.5627,16.0191);
									SetVehiclePos(10,644.3209,-566.0817,16.0193);
									SetVehiclePos(11,644.9137,-554.7156,16.0192);
									SetVehiclePos(12,639.2882,-554.1249,16.0189);
									SetVehicleZAngle(7, 180);
									SetVehicleZAngle(8, 180);
									SetVehicleZAngle(9, 180);
									SetVehicleZAngle(10, 180);
									SetVehicleZAngle(11, 180);
									SetVehicleZAngle(12, 180);
									SetPlayerInterior(playerid, 0);
									SetTimer("Yaris_KoyTuru_Baslat", 20000, false);
									PutPlayerInVehicle(playerid, Yaris_KoyTuru_Sayi + 6, 0 );
									TogglePlayerControllable(playerid,0);
								}
								else if (Yaris_KoyTuru_Sayi < 6)
								{
									Yaris_KoyTuru_Sayi++;
									SetPlayerVirtualWorld(playerid, Yaris_KoyTuru);
									PutPlayerInVehicle(playerid, Yaris_KoyTuru_Sayi + 6, 0 );
									SendClientMessage(playerid, Renk_Yesil, "[Yaris] KoyTuru yarisina katildin");
									stat[playerid][oyunmodu] = Yaris_KoyTuru;
									GameTextForPlayer(playerid, "Koy Turu", 5000, 1);
									TogglePlayerControllable(playerid,0);
									SetPlayerInterior(playerid, 0);
									
								}
								else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Yarisa maksimum 6 kisi katilabilir");
							}
							}
						} else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Bu yaris baslatilmis");
						
					}
					case 2:
					{
						if(Yaris_VinewoodDurum == false)
						{
							switch(stat[playerid][oyunmodu])
							{
								case Freeroam:
								{
									if(Yaris_Vinewood_Sayi == 0)
									{
										stat[playerid][oyunmodu] = Yaris_Vinewood;
										SetPlayerVirtualWorld(playerid, Yaris_Vinewood);
										Yaris_Vinewood_Sayi++;
										new yarismsj[120];
										GetPlayerName(playerid, oyuncu, sizeof oyuncu);
										GameTextForPlayer(playerid, "Vinewooda Dogru", 5000, 1);
										format(yarismsj, sizeof yarismsj, "[Yaris] Vinewooda Dogru yarisi %s tarafindan acildi katilmak icin /yaris", oyuncu);
										SendClientMessageToAll(Renk_Yesil, yarismsj);
										SetPlayerInterior(playerid,0);
										TogglePlayerControllable(playerid,0);
										SetTimer("Yaris_Vinewood_Baslat", 20000, false);
										SetVehiclePos(13,2783.0913,-1876.1929,9.5204);
										SetVehiclePos(14,2781.8435,-1863.2699,9.5154);
										SetVehiclePos(15,2783.3491,-1852.5532,9.5198);
										SetVehiclePos(16,2792.5896,-1852.4843,9.5600);
										SetVehiclePos(17,2792.5676,-1863.2296,9.5546);
										SetVehiclePos(18,2793.3477,-1873.4344,9.5587);
										SetVehicleZAngle(13, 92);
										SetVehicleZAngle(14, 92);
										SetVehicleZAngle(15, 92);
										SetVehicleZAngle(16, 92);
										SetVehicleZAngle(17, 92);
										SetVehicleZAngle(18, 92);
										PutPlayerInVehicle(playerid, Yaris_Vinewood_Sayi + 12,0);
									}
									else if (Yaris_Vinewood_Sayi < 6)
									{
										Yaris_Vinewood_Sayi++;
										SetPlayerVirtualWorld(playerid, Yaris_Vinewood);
										PutPlayerInVehicle(playerid, Yaris_Vinewood_Sayi + 12, 0 );
										GameTextForPlayer(playerid, "Vinewooda Dogru", 5000, 1);
										SendClientMessage(playerid, Renk_Yesil, "[Yaris] Vinewooda dogru yarisina katildin");
										stat[playerid][oyunmodu] = Yaris_Vinewood;
										TogglePlayerControllable(playerid,0);
										SetPlayerInterior(playerid, 0);
									}
									else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Yarisa maksimum 6 kisi katilabilir");
								}
							}
						}
						else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Bu yaris baslatilmis");
					}
					case 3:
					{
						if(Yaris_LSOtoyolDurum == false)
						{
							switch(stat[playerid][oyunmodu])
							{
								case Freeroam:
								{
									if(Yaris_LSOtoyol_Sayi == 0)
									{
										stat[playerid][oyunmodu] = Yaris_LSOtoyol;
										SetPlayerVirtualWorld(playerid, Yaris_LSOtoyol);
										Yaris_LSOtoyol_Sayi++;
										new yarismsj[120];
										GetPlayerName(playerid, oyuncu, sizeof oyuncu);
										GameTextForPlayer(playerid, "LS Otoyolu", 5000, 1);
										format(yarismsj, sizeof yarismsj,"[Yaris] LS Otoyolu yarisi %s tarafindan acildi katilmak icin /yaris",oyuncu);
										SendClientMessageToAll(Renk_Yesil, yarismsj);
										SetPlayerInterior(playerid,0);
										TogglePlayerControllable(playerid,0);
										SetTimer("Yaris_LSOtoyol_Baslat", 20000, false);
										SetVehiclePos(19,1350.4674,-2344.1003,13.0820);
										SetVehiclePos(20,1344.1124,-2343.2585,13.0855);
										SetVehiclePos(21,1334.9912,-2344.9895,13.0826);
										SetVehiclePos(22,1328.7069,-2344.4338,13.0821);
										SetVehiclePos(23,1331.6019,-2337.6001,13.0891);
										SetVehiclePos(24,1347.2091,-2337.1838,13.0878);
										SetVehicleZAngle(19, 177);
										SetVehicleZAngle(20, 177);
										SetVehicleZAngle(21, 177);
										SetVehicleZAngle(22, 177);
										SetVehicleZAngle(23, 177);
										SetVehicleZAngle(24, 177);
										PutPlayerInVehicle(playerid, Yaris_LSOtoyol_Sayi + 18,0);
									}
									else if (Yaris_LSOtoyol_Sayi < 6)
									{
										Yaris_LSOtoyol_Sayi++;
										SetPlayerVirtualWorld(playerid, Yaris_LSOtoyol);
										PutPlayerInVehicle(playerid, Yaris_LSOtoyol_Sayi + 18, 0 );
 								 		GameTextForPlayer(playerid, "LS Otoyolu", 5000, 1);
										SendClientMessage(playerid, Renk_Yesil, "[Yaris] LS Otoyolu yarisina katildin");
										stat[playerid][oyunmodu] = Yaris_LSOtoyol;
										TogglePlayerControllable(playerid,0);
										SetPlayerInterior(playerid, 0);
									}
									else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Yarisa maksimum 6 kisi katilabilir");
								}
							}
							
						}
						else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Bu yaris baslatilmis");
					}
					case 4:
					{
						if(Yaris_LVYarisiDurum == false)
						{
							switch(stat[playerid][oyunmodu])
							{
								case Freeroam:
								{
									if(Yaris_LVYarisi_Sayi == 0)
									{
										stat[playerid][oyunmodu] = Yaris_LVYarisi;
										SetPlayerVirtualWorld(playerid, Yaris_LVYarisi);
										Yaris_LVYarisi_Sayi++;
										new yarismsj[120];
										GetPlayerName(playerid, oyuncu, sizeof oyuncu);
										GameTextForPlayer(playerid, "LV Yarisi", 5000, 1);
										format(yarismsj, sizeof yarismsj, "[Yaris] Las Venturas yarisi %s tarafindan baslatildi katilmak icin /yaris", oyuncu);
										SendClientMessageToAll(Renk_Yesil, yarismsj);
										SetPlayerInterior(playerid,0);
										TogglePlayerControllable(playerid,0);
										SetTimer("Yaris_LVYarisi_Baslat", 20000, false);
										SetVehiclePos(25,2045.4655,908.8571,7.9765);
										SetVehiclePos(26,2051.0674,908.1318,7.9359);
										SetVehiclePos(27,2051.5100,893.8704,7.3036);
										SetVehiclePos(28,2045.3661,894.0620,7.3106);
										SetVehiclePos(29,2045.3131,881.9445,6.8602);
										SetVehiclePos(30,2051.8640,882.5525,6.8828);
										SetVehicleZAngle(25, 1.62);
										SetVehicleZAngle(26, 1.62);
										SetVehicleZAngle(27, 1.62);
										SetVehicleZAngle(28, 1.62);
										SetVehicleZAngle(29, 1.62);
										SetVehicleZAngle(30, 1.62);
										PutPlayerInVehicle(playerid,25,0);
									}
									else if (Yaris_LVYarisi_Sayi < 6)
									{
										Yaris_LVYarisi_Sayi++;
										SetPlayerVirtualWorld(playerid, Yaris_LVYarisi);
										PutPlayerInVehicle(playerid, Yaris_LVYarisi_Sayi + 24, 0 );
										GameTextForPlayer(playerid, "LV Yarisi", 5000, 1);
										SendClientMessage(playerid, Renk_Yesil, "[Yaris] Las venturas yarisina katildin");
										stat[playerid][oyunmodu] = Yaris_LVYarisi;
										TogglePlayerControllable(playerid,0);
										SetPlayerInterior(playerid, 0);
									}
									else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Yarisa maksimum 6 kisi katilabilir");
								}
							}
						}
						else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Bu yaris baslatilmis");
						
					}
					case 5:
					{
						if(Yaris_ColDurum == false)
						{
							switch(stat[playerid][oyunmodu])
							{
								case Freeroam:
								{
									if(Yaris_Col_Sayi == 0)
									{
										stat[playerid][oyunmodu] = Yaris_Col;
										SetPlayerVirtualWorld(playerid, Yaris_Col);
										Yaris_Col_Sayi++;
										new yarismsj[120];
										GetPlayerName(playerid, oyuncu, sizeof oyuncu);
										GameTextForPlayer(playerid, "Col", 5000, 1);
										format(yarismsj, sizeof yarismsj, "[Yaris] Col yarisi %s tarafindan acildi katilmak icin /yaris",oyuncu);
										SendClientMessageToAll(Renk_Yesil, yarismsj);
										SetPlayerInterior(playerid,0);
										TogglePlayerControllable(playerid,0);
										SetTimer("Yaris_Col_Baslat", 20000, false);
										SetVehiclePos(31,641.5343,1308.0078,11.4574);
										SetVehiclePos(32,639.1046,1311.7781,11.4581);
										SetVehiclePos(33,643.9964,1314.4154,11.4506);
										SetVehiclePos(34,646.0249,1311.4917,11.4583);
										SetVehiclePos(35,651.9923,1315.0546,11.4647);
										SetVehiclePos(36,649.6691,1318.3744,11.4701);
										SetVehicleZAngle(31, 121);
										SetVehicleZAngle(32, 121);
										SetVehicleZAngle(33, 121);
										SetVehicleZAngle(34, 121);
										SetVehicleZAngle(35, 121);
										SetVehicleZAngle(36, 121);
										PutPlayerInVehicle(playerid,31,0);
									}
									else if (Yaris_Col_Sayi < 6)
									{
										Yaris_Col_Sayi++;
										SetPlayerVirtualWorld(playerid, Yaris_Col);
										PutPlayerInVehicle(playerid, Yaris_Col_Sayi + 30, 0 );
										GameTextForPlayer(playerid, "Col", 5000, 1);
										SendClientMessage(playerid, Renk_Yesil, "[Yaris] Col yarisina katildin");
										stat[playerid][oyunmodu] = Yaris_Col;
										TogglePlayerControllable(playerid,0);
										SetPlayerInterior(playerid, 0);
									}
									else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Yarisa maksimum 6 kisi katilabilir");
								}
								
							}
						}
						else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Bu yaris baslatilmis");
					}
					case 6:
					{
						if(Yaris_DenizkenariDurum == false)
						{
							if(stat[playerid][oyunmodu] == Freeroam)
							{
							if(Yaris_Denizkenari_Sayi == 0)
							{
								stat[playerid][oyunmodu] = Yaris_Denizkenari ;
								SetPlayerVirtualWorld(playerid, Yaris_Denizkenari);
								Yaris_Denizkenari_Sayi++;
								new yarismsj[120];
								GetPlayerName(playerid, oyuncu, sizeof oyuncu);
								GameTextForPlayer(playerid, "Denizkenari", 5000, 1);
								format(yarismsj, sizeof yarismsj, "[Yaris] Denizkenari yarisi %s tarafindan acildi katilmak icin /yaris", oyuncu);
								SendClientMessageToAll(Renk_Yesil, yarismsj);
								SetPlayerInterior(playerid,0);
								TogglePlayerControllable(playerid,0);
								SetTimer("Yaris_Denizkenari_Baslat", 20000, false);
								SetVehiclePos(37,-2568.7307,-2303.9648,13.0807);
								SetVehiclePos(38,-2567.3406,-2309.8667,13.1340);
								SetVehiclePos(39,-2556.4812,-2307.6462,14.1594);
								SetVehiclePos(40,-2556.9124,-2302.8989,14.0890);
								SetVehiclePos(41,-2539.1738,-2301.9270,14.8962);
								SetVehiclePos(42,-2538.3689,-2307.9836,14.9073);
								SetVehicleZAngle(37, 104);
								SetVehicleZAngle(38, 104);
								SetVehicleZAngle(39, 104);
								SetVehicleZAngle(40, 104);
								SetVehicleZAngle(41, 104);
								SetVehicleZAngle(42, 104);
								PutPlayerInVehicle(playerid,37,0);
							}
							else if(Yaris_Denizkenari_Sayi < 6)
							{
								Yaris_Denizkenari_Sayi++; 
								SetPlayerVirtualWorld(playerid, Yaris_Denizkenari);
								PutPlayerInVehicle(playerid, Yaris_Denizkenari_Sayi + 36, 0 );
								GameTextForPlayer(playerid, "Denizkenari", 5000, 1);
								SendClientMessage(playerid, Renk_Yesil, "[Yaris] Denizkenari yarisina katildin");
								stat[playerid][oyunmodu] = Yaris_Denizkenari;
								TogglePlayerControllable(playerid,0);
								SetPlayerInterior(playerid, 0);
							}
							else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Yarisa maksimum 6 kisi katilabilir");
							}
							else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Freeroamda olman gerek!");
						} else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Bu yaris baslatilmis");
					}
					case 7:
					{
						if(Yaris_SanFierroDurum == false)
						{
							if(stat[playerid][oyunmodu] == Freeroam)
							{
							if(Yaris_SanFierro_Sayi == 0)
							{
								stat[playerid][oyunmodu] = Yaris_SanFierro;
								SetPlayerVirtualWorld(playerid, Yaris_SanFierro);
								Yaris_SanFierro_Sayi++;
								new yarismsj[120];
								GetPlayerName(playerid, oyuncu, sizeof oyuncu);
								GameTextForPlayer(playerid, "San Fierro", 5000, 1);
								format(yarismsj, sizeof yarismsj, "[Yaris] San Fierro yarisi %s tarafindan baslatildi katilmak icin /yaris", oyuncu);
								SendClientMessageToAll(Renk_Yesil, yarismsj);
								SetPlayerInterior(playerid,0);
								TogglePlayerControllable(playerid,0);
								SetTimer("Yaris_SanFierro_Baslat", 20000, false);
								SetVehiclePos(43,-2686.2759,1737.5234,67.6999);
								SetVehiclePos(44,-2692.3862,1737.9049,67.6960);
								SetVehiclePos(45,-2692.8662,1747.9492,67.7622);
								SetVehiclePos(46,-2686.3184,1747.9476,67.7551);
								SetVehiclePos(47,-2686.3218,1756.6373,67.7895);
								SetVehiclePos(48,-2692.5398,1756.4888,67.7964);
								SetVehicleZAngle(43, 179);
								SetVehicleZAngle(44, 179);
								SetVehicleZAngle(45, 179);
								SetVehicleZAngle(46, 179);
								SetVehicleZAngle(47, 179);
								SetVehicleZAngle(48, 179);
								PutPlayerInVehicle(playerid,43,0);
							}
							else if(Yaris_SanFierro_Sayi < 6)
							{
								Yaris_SanFierro_Sayi++; 
								SetPlayerVirtualWorld(playerid, Yaris_SanFierro);
								PutPlayerInVehicle(playerid, Yaris_SanFierro_Sayi + 42, 0 );
								GameTextForPlayer(playerid, "San Fierro", 5000, 1);
								SendClientMessage(playerid, Renk_Yesil, "[Yaris] SanFierro yarisina katildin");
								stat[playerid][oyunmodu] = Yaris_SanFierro;
								TogglePlayerControllable(playerid,0);
								SetPlayerInterior(playerid, 0);
							}
							else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Yarisa maksimum 6 kisi katilabilir");
							}
							else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Freeroamda olman gerek!");

						} else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Bu yaris baslatilmis");
					}
					case 8:
					{
					    if(Yaris_Ucagayetis_Durum == false)
					    {
					        if(stat[playerid][oyunmodu] == Freeroam)
					        {
						        if(Yaris_Ucagayetis_Sayi == 0)
						        {
						            new yarismsj[120];
						            GetPlayerName(playerid, oyuncu, sizeof oyuncu);
						            GameTextForPlayer(playerid, "Ucaga Yetis", 5000, 1);
						            format(yarismsj, sizeof yarismsj, "[Yaris] Ucaga Yetis yarisi %s tarafindan acildi katilmak icin /yaris",oyuncu);
						            SendClientMessageToAll(Renk_Yesil, yarismsj);
						            SetTimer("Yaris_Ucagayetis_Baslat", 20000, false);
						            SetVehiclePos(49, 431.2584,-1582.9434,25.1736);
						            SetVehiclePos(50, 431.5405,-1593.6134,25.1691);
						            SetVehiclePos(51, 411.7238,-1593.2676,26.4843);
						            SetVehiclePos(52, 411.8417,-1583.5127,26.4835);
						            SetVehiclePos(53, 398.2925,-1583.8729,27.9223);
						            SetVehiclePos(54, 398.7962,-1593.0510,27.8609);
									Yaris_Ucagayetis_Sayi++;
									SetVehicleZAngle(49, 271);
									SetVehicleZAngle(50, 271);
									SetVehicleZAngle(51, 271);
									SetVehicleZAngle(52, 271);
									SetVehicleZAngle(53, 271);
									SetVehicleZAngle(54, 271);
								    SetPlayerVirtualWorld(playerid, Yaris_Ucagayetis);
									PutPlayerInVehicle(playerid, Yaris_Ucagayetis_Sayi + 48, 0);
									stat[playerid][oyunmodu] = Yaris_Ucagayetis;
									TogglePlayerControllable(playerid, 0);
									SetPlayerInterior(playerid, 0);
						        }
						        else if(Yaris_Ucagayetis_Sayi < 6)
								{
								
									Yaris_Ucagayetis_Sayi++;
								    SetPlayerVirtualWorld(playerid, Yaris_Ucagayetis);
									PutPlayerInVehicle(playerid, Yaris_Ucagayetis_Sayi + 48, 0);
									GameTextForPlayer(playerid, "Ucaga Yetis", 5000, 1);
									SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Ucaga yetis yarisina katildin!");
									stat[playerid][oyunmodu] = Yaris_Ucagayetis;
									TogglePlayerControllable(playerid, 0);
									SetPlayerInterior(playerid, 0);
								}
								else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Yarisa maksimum 6 kisi katilabilir");
							} else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Freeroamda olman gerek");
					    } else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Bu yaris baslatilmis");
					}
					case 9:
					{
					    if(Yaris_SanAndreas_Durum == false)
					    {
							if(stat[playerid][oyunmodu] == Freeroam)
							{
								if(Yaris_SanAndreas_Sayi == 0)
								{
									new yarismsj[120];
									GetPlayerName(playerid, oyuncu, sizeof oyuncu);
									GameTextForPlayer(playerid, "San Andreas", 5000, 1);
									format(yarismsj, sizeof yarismsj, "[Yaris] San Andreas yarisi %s tarafindan acildi katilmak icin /yaris", oyuncu);
									SendClientMessageToAll(Renk_Yesil, yarismsj);
									SetTimer("Yaris_SanAndreas_Baslat", 20000, false);
									SetPlayerVirtualWorld(playerid, Yaris_SanAndreas);
								    stat[playerid][oyunmodu] = Yaris_SanAndreas;
									Yaris_SanAndreas_Sayi++;
									SetPlayerInterior(playerid, 0);
									TogglePlayerControllable(playerid, 0);
									SetVehiclePos(55, 2578.0027,-1735.3180,13.2209);
									SetVehiclePos(56, 2578.2759,-1729.8538,13.2211);
									SetVehiclePos(57, 2591.5193,-1735.1755,13.2210);
									SetVehiclePos(58, 2590.9883,-1729.3478,13.2209);
                                	SetVehiclePos(59, 2603.8933,-1729.4349,12.4306);
                                	SetVehiclePos(60, 2603.7588,-1734.8939,12.4426);
                                	SetVehicleZAngle(55, 91);
                                	SetVehicleZAngle(56, 91);
                                	SetVehicleZAngle(57, 91);
                                	SetVehicleZAngle(58, 91);
                                	SetVehicleZAngle(59, 91);
                                	SetVehicleZAngle(60, 91);
									PutPlayerInVehicle(playerid, 54 + Yaris_SanAndreas_Sayi, 0);

								}
								else if(Yaris_SanAndreas_Sayi < 6)
								{
									GameTextForPlayer(playerid, "San Andreas", 5000, 1);
									SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] San Andreas yarisina katildin!");
									SetPlayerVirtualWorld(playerid, Yaris_SanAndreas);
								    stat[playerid][oyunmodu] = Yaris_SanAndreas;
									Yaris_SanAndreas_Sayi++;
									SetPlayerInterior(playerid, 0);
									TogglePlayerControllable(playerid, 0);
									PutPlayerInVehicle(playerid, 54 + Yaris_SanAndreas_Sayi, 0);
								}
								else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Yarisa maksimum 6 kisi katilabilir");
							} else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Freeroamda olman gerek!");
					    } else SendClientMessage(playerid, Renk_AcikKirmizi, "[Yaris] Bu yaris baslatilmis");
					}
				}
			}
		}
	}
	else //Diyalogda Olumsuz yanýt verirse
	{
		switch(dialogid)
		{
			case Kayit_Diyalog: return Kick(playerid);
			case Giris_Diyalog: return Kick(playerid);
			case Ban_Diyalog: return Kick(playerid);
		}
	}
	return 1;
}




public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    return 1;
} 


public Yaris_Sahil_Baslat()
{
	if (Yaris_Sahil_Sayi > 0)
	{
		SendClientMessageToAll(Renk_Yesil, "[Yaris] Sahil yarisi baslatildi");
		Yaris_SahilDurum = true;
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(stat[i][oyunmodu] == Yaris_Sahil)
			{
			TogglePlayerControllable(i,1);
			SetPlayerRaceCheckpoint(i,0,Yaris_SahilCheckpoint[0][0],Yaris_SahilCheckpoint[0][1],Yaris_SahilCheckpoint[0][2],Yaris_SahilCheckpoint[1][0],Yaris_SahilCheckpoint[1][1],Yaris_SahilCheckpoint[1][2],9.7);
			}
		}
	}
	else Yaris_Sahil_Kapat();
	return 1;
}

Yaris_Sahil_Kapat()
{
	Yaris_SahilDurum = false;
	Yaris_Sahil_Sayi = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		switch(stat[i][oyunmodu])
		{
			case Yaris_Sahil:
			{
				stat[i][oyunmodu] = Freeroam;
				stat[i][Yaris_SahilCP] = 0;
				SendClientMessage(i,Renk_Kirmizi, "[Yaris] Sahil Yarisi kapatildi");
				SetPlayerVirtualWorld(i, Freeroam);
				TogglePlayerControllable(i,1);
			}
				
		}
	}
}

public Yaris_KoyTuru_Baslat()
{
	if(Yaris_KoyTuru_Sayi > 0)
	{
		SendClientMessageToAll(Renk_Yesil, "[Yaris] Koy Turu yarisi baslatildi");
		Yaris_KoyTuruDurum = true;
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(stat[i][oyunmodu] == Yaris_KoyTuru)
			{
			TogglePlayerControllable(i,1);
			SetPlayerRaceCheckpoint(i,0,Yaris_KoyTuruCheckpoint[0][0],Yaris_KoyTuruCheckpoint[0][1],Yaris_KoyTuruCheckpoint[0][2],Yaris_KoyTuruCheckpoint[1][0],Yaris_KoyTuruCheckpoint[1][1],Yaris_KoyTuruCheckpoint[1][2],9.7);
			}
		}
	}
	else Yaris_KoyTuru_Kapat();
	return 1;
}

Yaris_KoyTuru_Kapat()
{
	Yaris_KoyTuruDurum = false;
	Yaris_KoyTuru_Sayi = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		switch(stat[i][oyunmodu])
		{
			case Yaris_KoyTuru:
			{
				stat[i][oyunmodu] = Freeroam;
				stat[i][Yaris_KoyTuruCP] = 0; 
				SendClientMessage(i,Renk_AcikKirmizi,"[Yaris] Koy Turu Yarisi kapatildi");
				SetPlayerVirtualWorld(i, Freeroam);
				TogglePlayerControllable(i,1);
			}
		}
	}
	
}


public Yaris_Vinewood_Baslat()
{
	if(Yaris_Vinewood_Sayi > 0)
	{
		SendClientMessageToAll(Renk_Yesil, "[Yaris] Vinewooda Dogru yarisi baslatildi");
		Yaris_VinewoodDurum = true;
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(stat[i][oyunmodu] == Yaris_Vinewood)
			{
			TogglePlayerControllable(i,1);
			SetPlayerRaceCheckpoint(i,0,Yaris_VinewoodCheckpoint[0][0],Yaris_VinewoodCheckpoint[0][1],Yaris_VinewoodCheckpoint[0][2],Yaris_VinewoodCheckpoint[1][0],Yaris_VinewoodCheckpoint[1][1],Yaris_VinewoodCheckpoint[1][2],9.7);
			}
		}
	}
	else Yaris_Vinewood_Kapat();
	return 1;
}



Yaris_Vinewood_Kapat()
{
	Yaris_VinewoodDurum = false;
	Yaris_Vinewood_Sayi = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		switch(stat[i][oyunmodu])
		{
			case Yaris_Vinewood:
			{
				stat[i][oyunmodu] = Freeroam;
				stat[i][Yaris_VinewoodCP] = 0;
				SendClientMessage(i,Renk_AcikKirmizi,"[Yaris] Vinewooda dogru yarisi kapatildi");
				SetPlayerVirtualWorld(i,Freeroam);
				TogglePlayerControllable(i,1);
			}
		}
	}
}

public Yaris_LSOtoyol_Baslat()
{
	if(Yaris_LSOtoyol_Sayi > 0)
	{
		SendClientMessageToAll(Renk_Yesil, "[Yaris] LS Otoyolu yarisi baslatildi");
		Yaris_LSOtoyolDurum = true;
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(stat[i][oyunmodu] == Yaris_LSOtoyol)
			{
			TogglePlayerControllable(i,1);
			SetPlayerRaceCheckpoint(i,0,Yaris_LSOtoyolCheckpoint[0][0],Yaris_LSOtoyolCheckpoint[0][1],Yaris_LSOtoyolCheckpoint[0][2],Yaris_LSOtoyolCheckpoint[1][0],Yaris_LSOtoyolCheckpoint[1][1],Yaris_LSOtoyolCheckpoint[1][2],9.7);
			}
		}
	}
	else Yaris_LSOtoyol_Kapat();
	return 1;
}


Yaris_LSOtoyol_Kapat()
{
	Yaris_LSOtoyolDurum = false;
	Yaris_LSOtoyol_Sayi = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		switch(stat[i][oyunmodu])
		{
			case Yaris_LSOtoyol:
			{
				stat[i][oyunmodu] = Freeroam;
				stat[i][Yaris_LSOtoyolCP] = 0;
				SendClientMessage(i,Renk_AcikKirmizi,"[Yaris] LS Otoyolu yarisi kapatildi");
				SetPlayerVirtualWorld(i,Freeroam);
				TogglePlayerControllable(i,1);
			}
		}
	}
}

public Yaris_LVYarisi_Baslat()
{
	if(Yaris_LVYarisi_Sayi > 0)
	{
		SendClientMessageToAll(Renk_Yesil, "[Yaris] Las Venturas yarisi baslatildi");
		Yaris_LVYarisiDurum = true;
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(stat[i][oyunmodu] == Yaris_LVYarisi)
			{
			TogglePlayerControllable(i,1);
			SetPlayerRaceCheckpoint(i,0,Yaris_LVYarisiCheckpoint[0][0],Yaris_LVYarisiCheckpoint[0][1],Yaris_LVYarisiCheckpoint[0][2],Yaris_LVYarisiCheckpoint[1][0],Yaris_LVYarisiCheckpoint[1][1],Yaris_LVYarisiCheckpoint[1][2],9.7);
			}
		}
	}
	else Yaris_LVYarisi_Kapat();
	return 1;
}


Yaris_LVYarisi_Kapat()
{
	Yaris_LVYarisiDurum = false;
	Yaris_LVYarisi_Sayi = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		switch(stat[i][oyunmodu])
		{
			case Yaris_LVYarisi:
			{
				stat[i][oyunmodu] = Freeroam;
				stat[i][Yaris_LVYarisiCP] = 0;
				SendClientMessage(i,Renk_AcikKirmizi,"[Yaris] Las venturas yarisi kapatildi");
				SetPlayerVirtualWorld(i,Freeroam);
				TogglePlayerControllable(i,1);
			}
		}
	}
}

public Yaris_Col_Baslat()
{
	if(Yaris_Col_Sayi > 0)
	{
		SendClientMessageToAll(Renk_Yesil, "[Yaris] Col yarisi baslatildi");
		Yaris_ColDurum = true;
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			switch(stat[i][oyunmodu])
			{
			case Yaris_Col:
			{
			TogglePlayerControllable(i,1);
			SetPlayerRaceCheckpoint(i,0,Yaris_ColCheckpoint[0][0],Yaris_ColCheckpoint[0][1],Yaris_ColCheckpoint[0][2],Yaris_ColCheckpoint[1][0],Yaris_ColCheckpoint[1][1],Yaris_ColCheckpoint[1][2],9.7);
			}
			}
		}
	}
	else Yaris_Col_Kapat();
	return 1;
}


Yaris_Col_Kapat()
{
	Yaris_ColDurum = false;
	Yaris_Col_Sayi = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		switch(stat[i][oyunmodu])
		{
			case Yaris_Col:
			{
				stat[i][oyunmodu] = Freeroam;
				stat[i][Yaris_ColCP] = 0;
				SendClientMessage(i,Renk_AcikKirmizi,"[Yaris] Col yarisi kapatildi");
				SetPlayerVirtualWorld(i,Freeroam);
				TogglePlayerControllable(i,1);
			}
		}
	}
}

public Yaris_Denizkenari_Baslat()
{
	if(Yaris_Denizkenari_Sayi > 0)
	{
		SendClientMessageToAll(Renk_Yesil, "[Yaris] Denizkenari yarisi baslatildi");
		Yaris_DenizkenariDurum = true;
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			switch(stat[i][oyunmodu])
			{
			case Yaris_Denizkenari:
			{
			TogglePlayerControllable(i,1);
			SetPlayerRaceCheckpoint(i,0,Yaris_DenizkenariCheckpoint[0][0],Yaris_DenizkenariCheckpoint[0][1],Yaris_DenizkenariCheckpoint[0][2],Yaris_DenizkenariCheckpoint[1][0],Yaris_DenizkenariCheckpoint[1][1],Yaris_DenizkenariCheckpoint[1][2],9.7);
			}
			}
		}
	}
	else Yaris_Denizkenari_Kapat();
	return 1;
}


Yaris_Denizkenari_Kapat()
{
	Yaris_DenizkenariDurum = false;
	Yaris_Denizkenari_Sayi = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		switch(stat[i][oyunmodu])
		{
			case Yaris_Denizkenari:
			{
				stat[i][oyunmodu] = Freeroam;
				stat[i][Yaris_DenizkenariCP] = 0;
				SendClientMessage(i,Renk_AcikKirmizi,"[Yaris] Denizkenari yarisi kapatildi");
				SetPlayerVirtualWorld(i,Freeroam);
				TogglePlayerControllable(i,1);
			}
		}
	}
}



public Yaris_SanFierro_Baslat()
{
	if(Yaris_SanFierro_Sayi > 0)
	{
		SendClientMessageToAll(Renk_Yesil, "[Yaris] SanFierro yarisi baslatildi");
		Yaris_SanFierroDurum = true;
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			switch(stat[i][oyunmodu])
			{
			case Yaris_SanFierro:
			{
			TogglePlayerControllable(i,1);
			SetPlayerRaceCheckpoint(i,0,Yaris_SanFierroCheckpoint[0][0],Yaris_SanFierroCheckpoint[0][1],Yaris_SanFierroCheckpoint[0][2],Yaris_SanFierroCheckpoint[1][0],Yaris_SanFierroCheckpoint[1][1],Yaris_SanFierroCheckpoint[1][2],9.7);
			}
			}
		}
	}
	else
	{
		Yaris_SanFierro_Kapat();
		SendClientMessageToAll(Renk_AcikKirmizi, "[Yaris] San Fierro yarisinda kimse olmadigi icin kapatildi!");
	}
	return 1;
}


Yaris_SanFierro_Kapat()
{
	Yaris_SanFierroDurum = false;
	Yaris_SanFierro_Sayi = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		switch(stat[i][oyunmodu])
		{
			case Yaris_SanFierro:
			{
				stat[i][oyunmodu] = Freeroam;
				stat[i][Yaris_SanFierroCP] = 0;
				SendClientMessage(i,Renk_AcikKirmizi,"[Yaris] SanFierro yarisi kapatildi");
				SetPlayerVirtualWorld(i,Freeroam);
				TogglePlayerControllable(i,1);
			}
		}
	}
}

public Yaris_Ucagayetis_Baslat()
{
	if(Yaris_Ucagayetis_Sayi > 0)
	{
	    SendClientMessageToAll(Renk_Yesil, "[Yaris] Ucaga yetis yarisi baslatildi.");
		Yaris_Ucagayetis_Durum = true;
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
		    if(stat[i][oyunmodu] == Yaris_Ucagayetis)
		    {
			TogglePlayerControllable(i,1);
			SetPlayerRaceCheckpoint(i,0,Yaris_UcagayetisCheckpoint[0][0],Yaris_UcagayetisCheckpoint[0][1],Yaris_UcagayetisCheckpoint[0][2],Yaris_UcagayetisCheckpoint[1][0],Yaris_UcagayetisCheckpoint[1][1],Yaris_UcagayetisCheckpoint[1][2],9.7);
		    }
		}
	}
	else
	{
	    SendClientMessageToAll(Renk_AcikKirmizi, "[Yaris] Ucaga yetis yarisinda kimse olmadigi icin kapatildi!");
	    Yaris_Ucagayetis_Kapat();
	}
}

Yaris_Ucagayetis_Kapat()
{
	Yaris_Ucagayetis_Durum = false;
	Yaris_Ucagayetis_Sayi = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(stat[i][oyunmodu] == Yaris_Ucagayetis)
	    {
			SendClientMessage(i, Renk_AcikKirmizi, "[Yaris] Ucaga yetis yarisi kapatildi");
	        stat[i][oyunmodu] = Freeroam;
	        stat[i][Yaris_UcagayetisCP] = 0;
			SetPlayerVirtualWorld(i, Freeroam);
			TogglePlayerControllable(i, 1);
			
	    }
	}
}

public Yaris_SanAndreas_Baslat()
{
	if(Yaris_SanAndreas_Sayi > 0)
	{
		SendClientMessageToAll(Renk_Yesil, "[Yaris] SanAndreas yarisi baslatildi");
		Yaris_SanAndreas_Durum = true;
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			switch(stat[i][oyunmodu])
			{
			case Yaris_SanAndreas:
			{
				TogglePlayerControllable(i,1);
				SetPlayerRaceCheckpoint(i,0,Yaris_SanAndreasCheckpoint[0][0],Yaris_SanAndreasCheckpoint[0][1],Yaris_SanAndreasCheckpoint[0][2],Yaris_SanAndreasCheckpoint[1][0],Yaris_SanAndreasCheckpoint[1][1],Yaris_SanAndreasCheckpoint[1][2],9.7);
			}
			}
		}
	}
	else
	{
		Yaris_SanAndreas_Kapat();
		SendClientMessageToAll(Renk_AcikKirmizi, "[Yaris] San Andreas yarisinda kimse olmadigi icin kapatildi!");
	}
	return 1;
}

Yaris_SanAndreas_Kapat()
{
	Yaris_SanAndreas_Durum = false;
	Yaris_SanAndreas_Sayi = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(stat[i][oyunmodu] == Yaris_SanAndreas)
		{
		    stat[i][oyunmodu] = Freeroam;
		    stat[i][Yaris_SanAndreasCP] = 0;
		    SendClientMessage(i,Renk_AcikKirmizi,"[Yaris] San Andreas yarisi kapatildi");
		    SetPlayerVirtualWorld(i,Freeroam);
   		 	TogglePlayerControllable(i,1);
		    GivePlayerWeapon(i, 46, 1);
		}
	}
}



public OnPlayerEnterRaceCheckpoint(playerid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	PlayerPlaySound(playerid, 1137, x, y, z);
	switch(stat[playerid][oyunmodu])
	{
		case Yaris_Sahil:
		{
			DisablePlayerRaceCheckpoint(playerid);
			stat[playerid][Yaris_SahilCP]++;
			if(stat[playerid][Yaris_SahilCP] < 16)
			{
			SetPlayerRaceCheckpoint(playerid,0,Yaris_SahilCheckpoint[stat[playerid][Yaris_SahilCP]][0],Yaris_SahilCheckpoint[stat[playerid][Yaris_SahilCP]][1],Yaris_SahilCheckpoint[stat[playerid][Yaris_SahilCP]][2],Yaris_SahilCheckpoint[stat[playerid][Yaris_SahilCP]+1][0],Yaris_SahilCheckpoint[stat[playerid][Yaris_SahilCP]+1][1],Yaris_SahilCheckpoint[stat[playerid][Yaris_SahilCP]+1][2],9.7);
			}
			else{
			

     		   	for(new i = 0; i < MAX_PLAYERS; i++)
       			{
       			    if(stat[i][oyunmodu] == Yaris_Sahil)
					{
					DisablePlayerRaceCheckpoint(i);
					}
  				}
       	 		GetPlayerName(playerid,Yaris_Sahil_Kazanan,sizeof(Yaris_Sahil_Kazanan));
       	 		stat[playerid][Yariskazanma]++;
  				format(strings,sizeof(strings),"[Yaris] Sahil yarisi bitti, %s kazandi !",Yaris_Sahil_Kazanan,Yaris_Parasi);
   				SendClientMessageToAll(Renk_AcikKirmizi,strings);
       		 	GivePlayerMoney(playerid,Yaris_Parasi);
    			Yaris_Sahil_Kapat();

			}
		}
		case Yaris_KoyTuru:
		{
			DisablePlayerRaceCheckpoint(playerid);
			stat[playerid][Yaris_KoyTuruCP]++;
			if(stat[playerid][Yaris_KoyTuruCP] < 25)
			{ 
				SetPlayerRaceCheckpoint(playerid,0,Yaris_KoyTuruCheckpoint[stat[playerid][Yaris_KoyTuruCP]][0],Yaris_KoyTuruCheckpoint[stat[playerid][Yaris_KoyTuruCP]][1],Yaris_KoyTuruCheckpoint[stat[playerid][Yaris_KoyTuruCP]][2],Yaris_KoyTuruCheckpoint[stat[playerid][Yaris_KoyTuruCP]+1][0],Yaris_KoyTuruCheckpoint[stat[playerid][Yaris_KoyTuruCP]+1][1],Yaris_KoyTuruCheckpoint[stat[playerid][Yaris_KoyTuruCP]+1][2],9.7);
			}
			else if (stat[playerid][Yaris_KoyTuruCP] == 26)
			{
				SetPlayerRaceCheckpoint(playerid,1,Yaris_KoyTuruCheckpoint[stat[playerid][Yaris_KoyTuruCP]][0],Yaris_KoyTuruCheckpoint[stat[playerid][Yaris_KoyTuruCP]][1],Yaris_KoyTuruCheckpoint[stat[playerid][Yaris_KoyTuruCP]][2],Yaris_KoyTuruCheckpoint[stat[playerid][Yaris_KoyTuruCP]+1][0],Yaris_KoyTuruCheckpoint[stat[playerid][Yaris_KoyTuruCP]+1][1],Yaris_KoyTuruCheckpoint[stat[playerid][Yaris_KoyTuruCP]+1][2],9.7);
			}
			else
			{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(stat[i][oyunmodu] == Yaris_KoyTuru)
					{
					DisablePlayerRaceCheckpoint(i);
					}
				}
				GetPlayerName(playerid,Yaris_KoyTuru_Kazanan,sizeof(Yaris_KoyTuru_Kazanan));
				stat[playerid][Yariskazanma]++;
 				format(strings,sizeof(strings),"[Yaris] Koy Turu yarisi bitti, %s kazandi !",Yaris_KoyTuru_Kazanan,Yaris_Parasi);
  				SendClientMessageToAll(Renk_AcikKirmizi,strings);
       		 	GivePlayerMoney(playerid,Yaris_Parasi);
   				Yaris_KoyTuru_Kapat();
			}
		}
		case Yaris_Vinewood:
		{
			DisablePlayerRaceCheckpoint(playerid);
			stat[playerid][Yaris_VinewoodCP]++;
			if(stat[playerid][Yaris_VinewoodCP] < 15)
			{ 
				SetPlayerRaceCheckpoint(playerid,0,Yaris_VinewoodCheckpoint[stat[playerid][Yaris_VinewoodCP]][0],Yaris_VinewoodCheckpoint[stat[playerid][Yaris_VinewoodCP]][1],Yaris_VinewoodCheckpoint[stat[playerid][Yaris_VinewoodCP]][2],Yaris_VinewoodCheckpoint[stat[playerid][Yaris_VinewoodCP]+1][0],Yaris_VinewoodCheckpoint[stat[playerid][Yaris_VinewoodCP]+1][1],Yaris_VinewoodCheckpoint[stat[playerid][Yaris_VinewoodCP]+1][2],9.7);
			}
			else{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(stat[i][oyunmodu] == Yaris_Vinewood)
					{
					DisablePlayerRaceCheckpoint(i);
					}
					
				}
				GetPlayerName(playerid,Yaris_Vinewood_Kazanan,sizeof(Yaris_Vinewood_Kazanan));
				stat[playerid][Yariskazanma]++;
				format(strings,sizeof(strings),"[Yaris] Vinewooda dogru yarisi bitti, %s kazandi!",Yaris_Vinewood_Kazanan,Yaris_Parasi);
				SendClientMessageToAll(Renk_AcikKirmizi,strings);
				GivePlayerMoney(playerid,Yaris_Parasi);
				Yaris_Vinewood_Kapat();
			}
		}
		case Yaris_LSOtoyol:
		{
			DisablePlayerRaceCheckpoint(playerid);
			stat[playerid][Yaris_LSOtoyolCP]++;
			if(stat[playerid][Yaris_LSOtoyolCP] < 25)
			{ 
				SetPlayerRaceCheckpoint(playerid,0,Yaris_LSOtoyolCheckpoint[stat[playerid][Yaris_LSOtoyolCP]][0],Yaris_LSOtoyolCheckpoint[stat[playerid][Yaris_LSOtoyolCP]][1],Yaris_LSOtoyolCheckpoint[stat[playerid][Yaris_LSOtoyolCP]][2],Yaris_LSOtoyolCheckpoint[stat[playerid][Yaris_LSOtoyolCP]+1][0],Yaris_LSOtoyolCheckpoint[stat[playerid][Yaris_LSOtoyolCP]+1][1],Yaris_LSOtoyolCheckpoint[stat[playerid][Yaris_LSOtoyolCP]+1][2],9.7);
			}
			else{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(stat[i][oyunmodu] == Yaris_LSOtoyol)
					{
					DisablePlayerRaceCheckpoint(i);
					}
					
				}
				GetPlayerName(playerid,Yaris_LSOtoyol_Kazanan,sizeof(Yaris_LSOtoyol_Kazanan));
				stat[playerid][Yariskazanma]++;
				format(strings,sizeof(strings),"[Yaris] LS Otoyolu yarisi bitti, %s kazandi!",Yaris_LSOtoyol_Kazanan,Yaris_Parasi);
				SendClientMessageToAll(Renk_AcikKirmizi,strings);
				GivePlayerMoney(playerid,Yaris_Parasi);
				Yaris_LSOtoyol_Kapat();
			}
		}
		case Yaris_LVYarisi:
		{
			DisablePlayerRaceCheckpoint(playerid);
			stat[playerid][Yaris_LVYarisiCP]++;
			if(stat[playerid][Yaris_LVYarisiCP] < 35)
			{ 
				SetPlayerRaceCheckpoint(playerid,0,Yaris_LVYarisiCheckpoint[stat[playerid][Yaris_LVYarisiCP]][0],Yaris_LVYarisiCheckpoint[stat[playerid][Yaris_LVYarisiCP]][1],Yaris_LVYarisiCheckpoint[stat[playerid][Yaris_LVYarisiCP]][2],Yaris_LVYarisiCheckpoint[stat[playerid][Yaris_LVYarisiCP]+1][0],Yaris_LVYarisiCheckpoint[stat[playerid][Yaris_LVYarisiCP]+1][1],Yaris_LVYarisiCheckpoint[stat[playerid][Yaris_LVYarisiCP]+1][2],9.7);
			}
			else{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(stat[i][oyunmodu] == Yaris_LVYarisi)
					{
					DisablePlayerRaceCheckpoint(i);
					}
					
				}
				GetPlayerName(playerid,Yaris_LVYarisi_Kazanan,sizeof(Yaris_LVYarisi_Kazanan));
				stat[playerid][Yariskazanma]++;
				format(strings,sizeof(strings),"[Yaris] Las venturas yarisi bitti, %s kazandi!",Yaris_LVYarisi_Kazanan,Yaris_Parasi);
				SendClientMessageToAll(Renk_AcikKirmizi,strings);
				GivePlayerMoney(playerid,Yaris_Parasi);
				Yaris_LVYarisi_Kapat();
			}
		}
		case Yaris_Col:
		{
			DisablePlayerRaceCheckpoint(playerid);
			stat[playerid][Yaris_ColCP]++;
			if(stat[playerid][Yaris_ColCP] < 25)
			{ 
				SetPlayerRaceCheckpoint(playerid,0,Yaris_ColCheckpoint[stat[playerid][Yaris_ColCP]][0],Yaris_ColCheckpoint[stat[playerid][Yaris_ColCP]][1],Yaris_ColCheckpoint[stat[playerid][Yaris_ColCP]][2],Yaris_ColCheckpoint[stat[playerid][Yaris_ColCP]+1][0],Yaris_ColCheckpoint[stat[playerid][Yaris_ColCP]+1][1],Yaris_ColCheckpoint[stat[playerid][Yaris_ColCP]+1][2],9.7);
			}
			else if (stat[playerid][Yaris_ColCP] == 25)
			{
				SetPlayerRaceCheckpoint(playerid,1,Yaris_ColCheckpoint[stat[playerid][Yaris_ColCP]][0],Yaris_ColCheckpoint[stat[playerid][Yaris_ColCP]][1],Yaris_ColCheckpoint[stat[playerid][Yaris_ColCP]][2],Yaris_ColCheckpoint[stat[playerid][Yaris_ColCP]+1][0],Yaris_ColCheckpoint[stat[playerid][Yaris_ColCP]+1][1],Yaris_ColCheckpoint[stat[playerid][Yaris_ColCP]+1][2],9.7);
			}
			else{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(stat[i][oyunmodu] == Yaris_Col)
					{
					DisablePlayerRaceCheckpoint(i);
					}
				}
				GetPlayerName(playerid,Yaris_Col_Kazanan,sizeof(Yaris_Col_Kazanan));
				stat[playerid][Yariskazanma]++;
				format(strings,sizeof(strings),"[Yaris] Col yarisi bitti, %s kazandi!",Yaris_Col_Kazanan,Yaris_Parasi);
				SendClientMessageToAll(Renk_AcikKirmizi,strings);
				GivePlayerMoney(playerid,Yaris_Parasi);
				Yaris_Col_Kapat();
			}
		}
		case Yaris_Denizkenari:
		{
			DisablePlayerRaceCheckpoint(playerid);
			stat[playerid][Yaris_DenizkenariCP]++;
			if(stat[playerid][Yaris_DenizkenariCP] < 20)
			{ 
				SetPlayerRaceCheckpoint(playerid,0,Yaris_DenizkenariCheckpoint[stat[playerid][Yaris_DenizkenariCP]][0],Yaris_DenizkenariCheckpoint[stat[playerid][Yaris_DenizkenariCP]][1],Yaris_DenizkenariCheckpoint[stat[playerid][Yaris_DenizkenariCP]][2],Yaris_DenizkenariCheckpoint[stat[playerid][Yaris_DenizkenariCP]+1][0],Yaris_DenizkenariCheckpoint[stat[playerid][Yaris_DenizkenariCP]+1][1],Yaris_DenizkenariCheckpoint[stat[playerid][Yaris_DenizkenariCP]+1][2],9.7);
			}
			else if (stat[playerid][Yaris_DenizkenariCP] == 20)
			{
				SetPlayerRaceCheckpoint(playerid,1,Yaris_DenizkenariCheckpoint[stat[playerid][Yaris_DenizkenariCP]][0],Yaris_DenizkenariCheckpoint[stat[playerid][Yaris_DenizkenariCP]][1],Yaris_DenizkenariCheckpoint[stat[playerid][Yaris_DenizkenariCP]][2],Yaris_DenizkenariCheckpoint[stat[playerid][Yaris_DenizkenariCP]+1][0],Yaris_DenizkenariCheckpoint[stat[playerid][Yaris_DenizkenariCP]+1][1],Yaris_DenizkenariCheckpoint[stat[playerid][Yaris_DenizkenariCP]+1][2],9.7);	
			}
			else{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(stat[i][oyunmodu] == Yaris_Denizkenari)
					{
					DisablePlayerRaceCheckpoint(i);
					}
				}
				GetPlayerName(playerid,Yaris_Denizkenari_Kazanan,sizeof(Yaris_Denizkenari_Kazanan));
				stat[playerid][Yariskazanma]++;
				format(strings,sizeof(strings),"[Yaris] Denizkenari yarisi bitti, %s kazandi!",Yaris_Denizkenari_Kazanan,Yaris_Parasi);
				SendClientMessageToAll(Renk_AcikKirmizi,strings);
				GivePlayerMoney(playerid,Yaris_Parasi);
				Yaris_Denizkenari_Kapat();	
			}
		}
		case Yaris_SanFierro:
		{
			DisablePlayerRaceCheckpoint(playerid);
			stat[playerid][Yaris_SanFierroCP]++;
			if(stat[playerid][Yaris_SanFierroCP] < 30)
			{ 
				SetPlayerRaceCheckpoint(playerid,0,Yaris_SanFierroCheckpoint[stat[playerid][Yaris_SanFierroCP]][0],Yaris_SanFierroCheckpoint[stat[playerid][Yaris_SanFierroCP]][1],Yaris_SanFierroCheckpoint[stat[playerid][Yaris_SanFierroCP]][2],Yaris_SanFierroCheckpoint[stat[playerid][Yaris_SanFierroCP]+1][0],Yaris_SanFierroCheckpoint[stat[playerid][Yaris_SanFierroCP]+1][1],Yaris_SanFierroCheckpoint[stat[playerid][Yaris_SanFierroCP]+1][2],9.7);
			}
			else if (stat[playerid][Yaris_SanFierroCP] == 30)
			{
				SetPlayerRaceCheckpoint(playerid,1,Yaris_SanFierroCheckpoint[stat[playerid][Yaris_SanFierroCP]][0],Yaris_SanFierroCheckpoint[stat[playerid][Yaris_SanFierroCP]][1],Yaris_SanFierroCheckpoint[stat[playerid][Yaris_SanFierroCP]][2],Yaris_SanFierroCheckpoint[stat[playerid][Yaris_SanFierroCP]+1][0],Yaris_SanFierroCheckpoint[stat[playerid][Yaris_SanFierroCP]+1][1],Yaris_SanFierroCheckpoint[stat[playerid][Yaris_SanFierroCP]+1][2],9.7);	
			}
			else{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(stat[i][oyunmodu] == Yaris_SanFierro)
					{
					DisablePlayerRaceCheckpoint(i);
					}
				}
				stat[playerid][Yariskazanma]++;
				GetPlayerName(playerid,Yaris_SanFierro_Kazanan,sizeof(Yaris_SanFierro_Kazanan));
				format(strings,sizeof(strings),"[Yaris] SanFierro yarisi bitti, %s kazandi!",Yaris_SanFierro_Kazanan,Yaris_Parasi);
				SendClientMessageToAll(Renk_AcikKirmizi,strings);
				GivePlayerMoney(playerid,Yaris_Parasi);
				Yaris_SanFierro_Kapat();	
			}
		}
		case Yaris_Ucagayetis:
		{
			DisablePlayerRaceCheckpoint(playerid);
			stat[playerid][Yaris_UcagayetisCP]++;
			if(stat[playerid][Yaris_UcagayetisCP] < 12)
			{
				SetPlayerRaceCheckpoint(playerid,0,Yaris_UcagayetisCheckpoint[stat[playerid][Yaris_UcagayetisCP]][0],Yaris_UcagayetisCheckpoint[stat[playerid][Yaris_UcagayetisCP]][1],Yaris_UcagayetisCheckpoint[stat[playerid][Yaris_UcagayetisCP]][2],Yaris_UcagayetisCheckpoint[stat[playerid][Yaris_UcagayetisCP]+1][0],Yaris_UcagayetisCheckpoint[stat[playerid][Yaris_UcagayetisCP]+1][1],Yaris_UcagayetisCheckpoint[stat[playerid][Yaris_UcagayetisCP]+1][2],9.7);
			}
			else if (stat[playerid][Yaris_UcagayetisCP] == 12)
			{
				SetPlayerRaceCheckpoint(playerid,1,Yaris_UcagayetisCheckpoint[stat[playerid][Yaris_UcagayetisCP]][0],Yaris_UcagayetisCheckpoint[stat[playerid][Yaris_UcagayetisCP]][1],Yaris_UcagayetisCheckpoint[stat[playerid][Yaris_UcagayetisCP]][2],Yaris_UcagayetisCheckpoint[stat[playerid][Yaris_UcagayetisCP]+1][0],Yaris_UcagayetisCheckpoint[stat[playerid][Yaris_UcagayetisCP]+1][1],Yaris_UcagayetisCheckpoint[stat[playerid][Yaris_UcagayetisCP]+1][2],9.7);
			}
			else{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(stat[i][oyunmodu] == Yaris_Ucagayetis)
					{
					DisablePlayerRaceCheckpoint(i);
					}
				}
				stat[playerid][Yariskazanma]++;
				GetPlayerName(playerid,Yaris_Ucagayetis_Kazanan,sizeof(Yaris_Ucagayetis_Kazanan));
				format(strings,sizeof(strings),"[Yaris] Ucagayetis yarisi bitti, %s kazandi!",Yaris_Ucagayetis_Kazanan,Yaris_Parasi);
				SendClientMessageToAll(Renk_AcikKirmizi,strings);
				GivePlayerMoney(playerid,Yaris_Parasi);
				Yaris_Ucagayetis_Kapat();
			}
		}
		case Yaris_SanAndreas:
		{
			DisablePlayerRaceCheckpoint(playerid);
			stat[playerid][Yaris_SanAndreasCP]++;
			if(stat[playerid][Yaris_SanAndreasCP] < 46)
			{
				SetPlayerRaceCheckpoint(playerid,0,Yaris_SanAndreasCheckpoint[stat[playerid][Yaris_SanAndreasCP]][0],Yaris_SanAndreasCheckpoint[stat[playerid][Yaris_SanAndreasCP]][1],Yaris_SanAndreasCheckpoint[stat[playerid][Yaris_SanAndreasCP]][2],Yaris_SanAndreasCheckpoint[stat[playerid][Yaris_SanAndreasCP]+1][0],Yaris_SanAndreasCheckpoint[stat[playerid][Yaris_SanAndreasCP]+1][1],Yaris_SanAndreasCheckpoint[stat[playerid][Yaris_SanAndreasCP]+1][2],11.7);
			}
			else if (stat[playerid][Yaris_SanAndreasCP] == 46)
			{
		 		SetPlayerRaceCheckpoint(playerid,1,Yaris_SanAndreasCheckpoint[stat[playerid][Yaris_SanAndreasCP]][0],Yaris_SanAndreasCheckpoint[stat[playerid][Yaris_SanAndreasCP]][1],Yaris_SanAndreasCheckpoint[stat[playerid][Yaris_SanAndreasCP]][2],Yaris_SanAndreasCheckpoint[stat[playerid][Yaris_SanAndreasCP]][0],Yaris_SanAndreasCheckpoint[stat[playerid][Yaris_SanAndreasCP]][1],Yaris_SanAndreasCheckpoint[stat[playerid][Yaris_SanAndreasCP]][2],11.7);
			}
			else{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(stat[i][oyunmodu] == Yaris_SanAndreas)
					{
					DisablePlayerRaceCheckpoint(i);
					}
				}
				stat[playerid][Yariskazanma]++;
				GetPlayerName(playerid,Yaris_SanAndreas_Kazanan,sizeof(Yaris_SanAndreas_Kazanan));
				format(strings,sizeof(strings),"[Yaris] SanAndreas yarisi bitti, %s kazandi!",Yaris_SanAndreas_Kazanan,Yaris_Parasi);
				SendClientMessageToAll(Renk_AcikKirmizi,strings);
				GivePlayerMoney(playerid,Yaris_Parasi);
				Yaris_SanAndreas_Kapat();
			}
		}
	}
	return 1;
}


public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{	
	switch(stat[playerid][oyunmodu])
	{
		case Yaris_Sahil:
		{
			RepairVehicle(GetPlayerVehicleID(playerid));
		}
		case Yaris_KoyTuru:
		{
			RepairVehicle(GetPlayerVehicleID(playerid));
		}
		case Yaris_Vinewood:
		{
			RepairVehicle(GetPlayerVehicleID(playerid));
		}
		case Yaris_LSOtoyol:
		{
			RepairVehicle(GetPlayerVehicleID(playerid));
		}
		case Yaris_LVYarisi:
		{
			RepairVehicle(GetPlayerVehicleID(playerid));
		}
		case Yaris_Col:
		{
			RepairVehicle(GetPlayerVehicleID(playerid));
		}
		case Yaris_Denizkenari:
		{
			RepairVehicle(GetPlayerVehicleID(playerid));
		}
		case Yaris_SanFierro:
		{
			RepairVehicle(GetPlayerVehicleID(playerid));
		}
		case Yaris_Ucagayetis:
		{
		    RepairVehicle(GetPlayerVehicleID(playerid));
		}
		case Yaris_SanAndreas:
		{
		    RepairVehicle(GetPlayerVehicleID(playerid));
		}
	}
	return 1;	
}










public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_CROUCH)
	{
		if(IsPlayerInAnyVehicle(playerid)) cmd_tamir(playerid,"");
	}
	if(newkeys & KEY_NO)
	{
		if(IsPlayerInAnyVehicle(playerid)) cmd_soncp(playerid,"");
	}
	if(newkeys & KEY_YES)
	{
		new Float:ox, Float:oy, Float:oz;
		GetPlayerPos(playerid, ox, oy, oz);
	    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && stat[playerid][oyunmodu] == Freeroam)
	    {
	        if(oz < 1000)
	        {
	        new Float:x;
	        new Float:y;
			new Float:z;
			GetVehicleVelocity(GetPlayerVehicleID(playerid), x,y,z);
			SetVehicleVelocity(GetPlayerVehicleID(playerid), x,y,z + 0.4);
			} else SendClientMessage(playerid, Renk_AcikKirmizi, "Cok yuksektesin!");
	    } 
	}


	return 1;
}


public SaatAyar() //Her 1 dakikada çalýþýr saat ayarlaama random mesaj atma gibi þeylere yarar
{
	dakika+=1;
	if(dakika == 60)
	{
	 dakika = 0;
	 Saat += 1;
	 if(saat == 24)
	 {
	    Saat = 0;
	 }
    }
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    SetPlayerTime(i, Saat, dakika);
	}
}


TakimBelirle(playerid,sebep)
{
	switch(sebep)
	{
		case TOM_CeteSavasi:
		{
			if(TOM_CeteSavasi_Ballas_Sayi < TOM_CeteSavasi_Grove_Sayi)
			{
				TOM_CeteSavasi_Ballas_Sayi++;
				SetPlayerTeam(playerid, Takim_Ballas);
				GameTextForPlayer(playerid, "~p~Ballas ~w~takimina gectin!", 3000, 5);
				
			}
			if(TOM_CeteSavasi_Ballas_Sayi > TOM_CeteSavasi_Grove_Sayi)
			{
				TOM_CeteSavasi_Grove_Sayi++;
				SetPlayerTeam(playerid, Takim_Grove);
				GameTextForPlayer(playerid, "~g~Grove ~w~takimina gectin!", 3000, 5);
			}
			else
			{
				new r = random(2) + 1;
				if (r == 1)
				{
					TOM_CeteSavasi_Ballas_Sayi++;
					SetPlayerTeam(playerid, Takim_Ballas);
					GameTextForPlayer(playerid, "~p~Ballas ~w~takimina gectin!", 3000, 5);
				}
				else
				{
					TOM_CeteSavasi_Grove_Sayi++;
					SetPlayerTeam(playerid, Takim_Grove);
					GameTextForPlayer(playerid, "~g~Grove ~w~takimina gectin!", 3000, 5);
				}
			}
		}
		case TOM_LSSavasi:
		{
			if(TOM_LSSavasi_Mavi_Sayi < TOM_LSSavasi_Kirmizi_Sayi)
			{
				TOM_LSSavasi_Mavi_Sayi++;
				SetPlayerTeam(playerid, Takim_Mavi);
				GameTextForPlayer(playerid, "~b~Mavi ~w~takima gectin!", 3000, 5);
			}
			else if(TOM_LSSavasi_Mavi_Sayi > TOM_LSSavasi_Kirmizi_Sayi)
			{
				TOM_LSSavasi_Kirmizi_Sayi++;
				SetPlayerTeam(playerid, Takim_Kirmizi);
				GameTextForPlayer(playerid, "~r~Kirmizi ~w~Takima gectin!", 3000, 5);
			}
			else
			{
				new r = random(2) + 1;
				if ( r == 1)
				{
					TOM_LSSavasi_Mavi_Sayi++;
					SetPlayerTeam(playerid, Takim_Mavi);
					GameTextForPlayer(playerid, "~b~Mavi ~w~takima gectin!", 3000, 5);
				
				}
				else
				{
					TOM_LSSavasi_Kirmizi_Sayi++;
					SetPlayerTeam(playerid, Takim_Kirmizi);
					GameTextForPlayer(playerid, "~r~Kirmizi ~w~Takima gectin!", 3000, 5);
				}
			}
		}
		case TOM_Lunapark:
		{
			if(TOM_Lunapark_Beyaz_Sayi > TOM_Lunapark_Siyah_Sayi)
			{
				TOM_Lunapark_Siyah_Sayi++;
				SetPlayerTeam(playerid, Takim_Siyah);
				GameTextForPlayer(playerid, "~l~Siyah ~w~Takima gectin!", 2000, 5);
			}
			else if(TOM_Lunapark_Beyaz_Sayi < TOM_Lunapark_Siyah_Sayi)
			{
				TOM_Lunapark_Beyaz_Sayi++;
				SetPlayerTeam(playerid, Takim_Beyaz);
				GameTextForPlayer(playerid, "Beyaz takima gectin!", 2000, 5);				
			}
			else
			{
				new r = random(2) + 1;
				if( r == 1)
				{
					TOM_Lunapark_Beyaz_Sayi++;
					SetPlayerTeam(playerid, Takim_Beyaz);
					GameTextForPlayer(playerid, "Beyaz takima gectin!", 2000, 5);
				}
				else 
				{
					TOM_Lunapark_Siyah_Sayi++;
					SetPlayerTeam(playerid, Takim_Siyah);
					GameTextForPlayer(playerid, "~l~Siyah ~w~Takima gectin!", 2000, 5);
				}
			}
		}
		case TOM_Gemi:
		{
		    if(TOM_Gemi_Aztecas_Sayi > TOM_Gemi_Vagos_Sayi)
			{
			    TOM_Gemi_Vagos_Sayi++;
			    SetPlayerTeam(playerid, Takim_Vagos);
			    GameTextForPlayer(playerid, "~y~Vagos ~w~Takimina gectin!", 2000, 5);
			}
			else if(TOM_Gemi_Aztecas_Sayi < TOM_Gemi_Vagos_Sayi)
			{
			    TOM_Gemi_Aztecas_Sayi++;
			    SetPlayerTeam(playerid, Takim_Aztecas);
			    GameTextForPlayer(playerid, "~b~Aztecas ~w~Takimina gectin!", 2000, 5);
			}
			else
			{
			    new r = random(2) + 1;
			    if( r == 1)
			    {
	   		 		TOM_Gemi_Vagos_Sayi++;
			  	  	SetPlayerTeam(playerid, Takim_Vagos);
			  	  	GameTextForPlayer(playerid, "~y~Vagos ~w~Takimina gectin!", 2000, 5);
			    }
			    else
			    {
		    		TOM_Gemi_Aztecas_Sayi++;
			   	 	SetPlayerTeam(playerid, Takim_Aztecas);
			    	GameTextForPlayer(playerid, "~b~Aztecas ~w~Takimina gectin!", 2000, 5);
			    }
			}
		}
		
	}
}




public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(stat[playerid][Hesap_Admin] == 5)
	{
	    new aracms[30];
	    format(aracms, sizeof(aracms), "%i id", vehicleid);
	    SendClientMessage(playerid, Renk_Yesil, aracms);
	}
	if(GetVehicleModel(vehicleid) == 443)
	{
		SetTimerEx("Aractanat", 3100, false, "i", playerid);
	}
}



public TOM_CeteSavasi_Baslat()
{
	if(TOM_CeteSavasi_Grove_Sayi + TOM_CeteSavasi_Ballas_Sayi > 1)
	{
		SendClientMessageToAll(Renk_Mavi,"Cete savasi baslatildi!");
		TOM_CeteSavasi_Pickupolustur();
		TOM_CeteSavasi_Durum = true;
		TOM_CeteSavasi_TIMELIMIT = SetTimer("TOM_CeteSavasi_ZamanDolumu", 300000, false);
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(stat[i][oyunmodu] == TOM_CeteSavasi)
			{
				SetPlayerVirtualWorld(i,TOM_CeteSavasi);
				SendClientMessage(i,Renk_AltinSarisi,"[TOM]5 Dakika sure dolana kadar en cok puani almaya calis");
				SetPlayerHealth(i, 100.0);
				GangZoneShowForPlayer(i, TOM_CeteSavasi_Grove_Alan, Renk_Yesil);
				GangZoneShowForPlayer(i, TOM_CeteSavasi_Ballas_Alan, Renk_Mor);
				if(GetPlayerTeam(i) == Takim_Grove) 
				{
					SetPlayerColor(i, Renk_Yesil);
					ResetPlayerWeapons(i);
					GivePlayerWeapon(i,31,1029);
					GivePlayerWeapon(i,29,999);
					GivePlayerWeapon(i,25,999);
					SetPlayerSkin(i,107);
					new rand = random(sizeof(TOM_CeteSavasi_Grove_Spawn));
					SetPlayerPos(i, TOM_CeteSavasi_Grove_Spawn[rand][0], TOM_CeteSavasi_Grove_Spawn[rand][1], TOM_CeteSavasi_Grove_Spawn[rand][2]);
					
				}
				if(GetPlayerTeam(i) == Takim_Ballas)
				{
					SetPlayerColor(i, Renk_Mor);
					ResetPlayerWeapons(i);
					GivePlayerWeapon(i,31,1029);
					GivePlayerWeapon(i,29,999);
					GivePlayerWeapon(i,26,999);
					SetPlayerSkin(i,102);
					new rand = random(sizeof(TOM_CeteSavasi_Ballas_Spawn));
					SetPlayerPos(i, TOM_CeteSavasi_Ballas_Spawn[rand][0], TOM_CeteSavasi_Ballas_Spawn[rand][1], TOM_CeteSavasi_Ballas_Spawn[rand][2]);
				}
			}
		}
	}
	else TOM_CeteSavasi_Kapat(TOM_CeteSavasi_Azkisi);
}

public TOM_CeteSavasi_ZamanDolumu()
{
	if(TOM_CeteSavasi_Grove_Skor > TOM_CeteSavasi_Ballas_Skor)
	{
		TOM_CeteSavasi_Kapat(TOM_CeteSavasi_Grove_Kazan);
	}
	else if(TOM_CeteSavasi_Ballas_Skor > TOM_CeteSavasi_Grove_Skor)
	{
		TOM_CeteSavasi_Kapat(TOM_CeteSavasi_Ballas_Kazan);
	}
	else TOM_CeteSavasi_Kapat(TOM_CeteSavasi_Berabere);
}

public TOM_LSSavasi_ZamanDolumu()
{
	if(TOM_LSSavasi_Mavi_Skor > TOM_LSSavasi_Kirmizi_Skor) TOM_LSSavasi_Kapat(TOM_LSSavasi_Mavi_Kazan);
	else if (TOM_LSSavasi_Mavi_Skor < TOM_LSSavasi_Kirmizi_Skor) TOM_LSSavasi_Kapat(TOM_LSSavasi_Kirmizi_Kazan);
	else TOM_LSSavasi_Kapat(TOM_LSSavasi_Berabere);
}

public TOM_CeteSavasi_Kapat(sebep)
{
	KillTimer(TOM_CeteSavasi_TIMELIMIT);
	Pickupyoket(TOM_CeteSavasi_Pickup);
	TOM_CeteSavasi_Durum = false;
	TOM_CeteSavasi_Grove_Sayi = 0;
	TOM_CeteSavasi_Ballas_Sayi = 0;
	TOM_CeteSavasi_Grove_Skor = 0;
	TOM_CeteSavasi_Ballas_Skor = 0;
	switch(sebep)
	{
		case TOM_CeteSavasi_Azkisi:
		{
			SendClientMessageToAll(Renk_AcikKirmizi, "Cete Savasi az kisi oldugu icin kapatildi!");
		}
		case TOM_CeteSavasi_Cikis:
		{
			SendClientMessageToAll(Renk_AcikKirmizi, "Cete Savasindan birisi cikti ve az kisi kaldigi icin kapatildi.!");
		}
		case TOM_CeteSavasi_Grove_Kazan:
		{
			SendClientMessageToAll(Renk_AcikKirmizi, "Cete savasini [Grove Takimi] kazandi");
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(GetPlayerTeam(i) == Takim_Grove)
				{
				    stat[i][Tomkazanma]++;
					GivePlayerMoney(i,Tom_Parasi);
					SendClientMessage(i,Renk_Mavi,"Cete savasini kazandigin icin odul para verildi");
				}
			}
			
		}
		case TOM_CeteSavasi_Ballas_Kazan:
		{
			SendClientMessageToAll(Renk_AcikKirmizi, "Cete savasini [Balla Takimi] kazandi");
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(GetPlayerTeam(i) == Takim_Ballas)
				{
				    stat[i][Tomkazanma]++;
					GivePlayerMoney(i,Tom_Parasi);
					SendClientMessage(i,Renk_Mavi,"Cete savasini kazandigin icin odul para verildi");
				}
			}
		}
		case TOM_CeteSavasi_Berabere:
		{
			SendClientMessageToAll(Renk_AcikKirmizi, "Cete savasi berabere bitti");
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
			    if(stat[i][oyunmodu] == TOM_CeteSavasi)
			    {
					GivePlayerMoney(i,750);
					SendClientMessage(i,Renk_Mavi,"Katildigin icin 750$");
				}
			}
			
		}
		
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	if(stat[i][oyunmodu] == TOM_CeteSavasi)
	{
		stat[i][oyunmodu] = Freeroam;
		SetPlayerVirtualWorld(i,Freeroam);
		SetPlayerTeam(i,NO_TEAM);
		GangZoneHideForPlayer(i,TOM_CeteSavasi_Grove_Alan);
		GangZoneHideForPlayer(i,TOM_CeteSavasi_Ballas_Alan);
		SetPlayerColor(i, Renk_Beyaz);
	}
	}
	
}


public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(pickupid == TOM_CeteSavasi_Pickup)
	{
	    Pickupyoket(TOM_CeteSavasi_Pickup);
	    new ran = random(4) + 1; //1 den 4e kadar sayý
		switch(ran)
		{
		    case 1:
		    {
				SetPlayerHealth(playerid, 100.0);
			}
		    case 2:
		    {
				SetPlayerArmour(playerid, 100.0);
			}
		    case 3:
		    {
				GivePlayerWeapon(playerid, 32, 999);
			}
		    case 4:
		    {
		        GivePlayerWeapon(playerid, 9, 999);
      		}
		}
		TOM_CeteSavasi_Pickupolustur();
	}
	if(pickupid == TOM_LSSavasi_Pickup)
	{
	    Pickupyoket(TOM_LSSavasi_Pickup);
	    new ran = random(4) + 1;
	    switch(ran)
	    {
	        case 1:
	        {
	            SetPlayerHealth(playerid, 100.0);
	        }
	        case 2:
	        {
	            SetPlayerArmour(playerid, 100.0);
	        }
	        case 3:
	        {
	            GivePlayerWeapon(playerid, 34, 15);
	        }
	        case 4:
	        {
	            GivePlayerWeapon(playerid, 9, 1);
	        }
	    }
	    TOM_LSSavasi_Pickupolustur();
	}
	if(pickupid == TOM_Lunapark_Pickup)
	{
	    Pickupyoket(TOM_Lunapark_Pickup);
	    new ran = random(4) + 1;
		switch(ran)
		{
		    case 1:
		    {
		        SetPlayerHealth(playerid, 100.0);
		    }
		    case 2:
		    {
		        SetPlayerArmour(playerid, 100.0);
		    }
		    case 3:
		    {
		        GivePlayerWeapon(playerid, 24, 999);
		    }
		    case 4:
		    {
		        GivePlayerWeapon(playerid, 30, 999);
		    }
		}
		TOM_Lunapark_Pickupolustur();
	}
	if(pickupid == TOM_Gemi_Pickup)
	{
	    Pickupyoket(TOM_Gemi_Pickup);
	    new ran = random(4) + 1;
	    switch(ran)
		{
		    case 1:
				{
				    SetPlayerHealth(playerid, 100.0);
				}
		    case 2:
		        {
		            SetPlayerArmour(playerid, 100.0);
		        }
		    case 3:
		        {
		            GivePlayerWeapon(playerid, 32, 999);
		        }
		    case 4:
		        {
		            GivePlayerWeapon(playerid, 31, 999);
		        }
		}
		TOM_Gemi_Pickupolustur();
	}
	if(pickupid == minigun)
	{
	    GetPlayerName(playerid, oyuncu, sizeof(oyuncu));
	    new mgmsj[100];
	    format(mgmsj, sizeof mgmsj,"[Minigun] %s adli oyuncu haritanin gizli yerindeki minigunu buldu yeni minigun olusturuluyor...", oyuncu);
	    SendClientMessageToAll(Renk_Sari, mgmsj);
	    GivePlayerWeapon(playerid, 38, 150);
		minigunolustur();
	}
}




public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == skinlistesi)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, Renk_AltinSarisi, "Skin Degistirildi");
	    	SetPlayerSkin(playerid, modelid);
	    	stat[playerid][skin] = modelid;
	    }
    	return 1;
	}
	if(listid == Ucak || listid == Motor || listid == Bot || listid == Donusturulebilir || listid == Helikopter || listid == Endustri || listid == Lowrider || listid == OffRoad || listid == Belediye || listid == RC || listid == Klasik || listid == Spor || listid == StationWagon || listid == Yuk || listid == Diger)
	{
		if(response)
		{
			DestroyVehicle(stat[playerid][arac]);
			new Float:kor[4], renk[2];
			new vw;
			vw = GetPlayerVirtualWorld(playerid);
			GetPlayerPos(playerid, kor[0], kor[1], kor[2]);
			GetPlayerFacingAngle(playerid, kor[3]);
			renk[0] = random(256);
			renk[1] = random(256);
			stat[playerid][arac] = CreateVehicle(modelid, kor[0] + 0.5, kor[1] + 2, kor[2], kor[3], renk[0], renk[1], -1);
			SetVehicleVirtualWorld(stat[playerid][arac], vw);
			PutPlayerInVehicle(playerid, stat[playerid][arac], 0);
			GameTextForPlayer(playerid, "~r~Arac ~y~Spawnlandi!", 2000, 6);
		}
	}
	return 1;
}

public TOM_LSSavasi_Baslat()
{
	if(TOM_LSSavasi_Mavi_Sayi + TOM_LSSavasi_Kirmizi_Sayi > -1)
	{
		SendClientMessageToAll(Renk_Mavi,"Los Santos Savasi baslatildi!");
		TOM_LSSavasi_Pickupolustur();
		TOM_LSSavasi_TIMELIMIT = SetTimer("TOM_LSSavasi_ZamanDolumu", 300000, false);
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(stat[i][oyunmodu] == TOM_LSSavasi)
			{
			    SetPlayerHealth(i, 100.0);
				SetPlayerVirtualWorld(i,TOM_LSSavasi);
				SendClientMessage(i,Renk_AltinSarisi,"[TOM]5 Dakika sure dolana kadar en cok puani almaya calis");
				if(GetPlayerTeam(i) == Takim_Mavi) 
				{
					SetPlayerColor(i, Renk_Mavi);
					ResetPlayerWeapons(i);
					GivePlayerWeapon(i,31,1029);
					GivePlayerWeapon(i,23,999);
					GivePlayerWeapon(i,8,999);
					SetPlayerSkin(i,173);
					new rand = random(sizeof(TOM_LSSavasi_Mavi_Spawn));
					SetPlayerPos(i, TOM_LSSavasi_Mavi_Spawn[rand][0], TOM_LSSavasi_Mavi_Spawn[rand][1], TOM_LSSavasi_Mavi_Spawn[rand][2]);
					
				}
				if(GetPlayerTeam(i) == Takim_Kirmizi)
				{
					SetPlayerColor(i, Renk_AcikKirmizi);
					ResetPlayerWeapons(i);
					GivePlayerWeapon(i,31,1029);
					GivePlayerWeapon(i,22,999);
					GivePlayerWeapon(i,4,999);
					SetPlayerSkin(i,19);
					new rand = random(sizeof(TOM_LSSavasi_Kirmizi_Spawn));
					SetPlayerPos(i, TOM_LSSavasi_Kirmizi_Spawn[rand][0], TOM_LSSavasi_Kirmizi_Spawn[rand][1], TOM_LSSavasi_Kirmizi_Spawn[rand][2]);
				}
			}
		}
		TOM_LSSavasi_Durum = true;
	}
	else TOM_LSSavasi_Kapat(TOM_LSSavasi_Azkisi);
}

public TOM_LSSavasi_Kapat(sebep)
{
	KillTimer(TOM_LSSavasi_TIMELIMIT);
	Pickupyoket(TOM_LSSavasi_Pickup);
	TOM_LSSavasi_Durum = false;
	TOM_LSSavasi_Mavi_Sayi = 0;
	TOM_LSSavasi_Kirmizi_Sayi = 0;
	TOM_LSSavasi_Mavi_Skor = 0;
	TOM_LSSavasi_Kirmizi_Skor = 0;
	switch(sebep)
	{
		case TOM_LSSavasi_Azkisi:
		{
			SendClientMessageToAll(Renk_AcikKirmizi, "Los Santos Savasi az kisi oldugu icin kapatildi!");
		}
		case TOM_LSSavasi_Cikis:
		{
			SendClientMessageToAll(Renk_AcikKirmizi, "Los Santos Savasindan birisi cikti ve az kisi kaldigi icin kapatildi.!");
		}
		case TOM_LSSavasi_Mavi_Kazan:
		{
			SendClientMessageToAll(Renk_AcikKirmizi, "Los Santos Savasini [Mavi Takim] kazandi");
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(GetPlayerTeam(i) == Takim_Mavi)
				{
					stat[i][Tomkazanma]++;
					GivePlayerMoney(i,Tom_Parasi);
					SendClientMessage(i,Renk_Mavi,"Los Santos Savasini kazandigin icin odul para verildi");
				}
			}
			
		}
		case TOM_LSSavasi_Kirmizi_Kazan:
		{
			SendClientMessageToAll(Renk_AcikKirmizi, "Los Santos Savasini [Kirmizi Takim] kazandi");
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(GetPlayerTeam(i) == Takim_Kirmizi)
				{
					stat[i][Tomkazanma]++;
					GivePlayerMoney(i,Tom_Parasi);
					SendClientMessage(i,Renk_Mavi,"Los Santos savasini kazandigin icin odul para verildi");
				}
			}
		}
		case TOM_LSSavasi_Berabere:
		{
			SendClientMessageToAll(Renk_AcikKirmizi, "Los Santos Savasi berabere bitti");
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
			    if(stat[i][oyunmodu] == TOM_LSSavasi)
				{
					GivePlayerMoney(i,750);
					SendClientMessage(i,Renk_Mavi,"Katildigin icin 750$");
				}
			}
			
		}
		
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	if(stat[i][oyunmodu] == TOM_LSSavasi)
	{
		stat[i][oyunmodu] = Freeroam;
		SetPlayerVirtualWorld(i,Freeroam);
		SetPlayerTeam(i,NO_TEAM);
		SetPlayerColor(i, Renk_Beyaz);
	}
	}
	
}



public Gokkusagi(playerid)
{
	new gkarac;
	new Renk1;
	new Renk2;
	gkarac = GetPlayerVehicleID(playerid);
	Renk1 = random(255) + 1;
	Renk2 = random(255) + 1;
	ChangeVehicleColor(gkarac, Renk1, Renk2);
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(stat[playerid][gokkusagi] != 0)
	{
		KillTimer(stat[playerid][gokkusagi]);
		stat[playerid][gokkusagi] = 0;
	}
}

stock isinlan(playerid, sebep)
{
	if(IsPlayerInAnyVehicle(playerid) == 1) {
	KillTimer(stat[playerid][gokkusagi]);
	stat[playerid][gokkusagi] = 0;
	}
	switch(sebep)
	{
		case i_grove:
		{
  			if(IsPlayerInAnyVehicle(playerid))
		    {
		        new isinlanmaarac;
		        isinlanmaarac = GetPlayerVehicleID(playerid);
		        SetVehiclePos(isinlanmaarac, 2492.1462,-1669.7593,13.3359);
		        PutPlayerInVehicle(playerid, isinlanmaarac, 0);
		    }
		    else
		    {
				SetPlayerPos(playerid, 2492.1462,-1669.7593,13.3359);
			}
			SetPlayerInterior(playerid, 0);
			GameTextForPlayer(playerid, "~g~Grove Streete~w~ Isinlandin!", 2000, 6);
		}
		case i_sfgaraj:
		{
  			if(IsPlayerInAnyVehicle(playerid))
		    {
		        new isinlanmaarac;
		        isinlanmaarac = GetPlayerVehicleID(playerid);
		        SetVehiclePos(isinlanmaarac, -2025.9207,148.0742,28.8359);
		        PutPlayerInVehicle(playerid, isinlanmaarac, 0);
		    }
		    else
		    {
				SetPlayerPos(playerid, -2025.9207,148.0742,28.8359);
			}
			SetPlayerInterior(playerid, 0);
			GameTextForPlayer(playerid, "~b~San Fierro Garajina~w~ Isinlandin!", 2000, 6);
		}
		case i_fourdragon:
		{
  			if(IsPlayerInAnyVehicle(playerid))
		    {
		        new isinlanmaarac;
		        isinlanmaarac = GetPlayerVehicleID(playerid);
		        SetVehiclePos(isinlanmaarac, 2028.5538,1008.3543,10.8203);
		        PutPlayerInVehicle(playerid, isinlanmaarac, 0);
		    }
		    else
		    {
				SetPlayerPos(playerid, 2028.5538,1008.3543,10.8203);
			}
			SetPlayerInterior(playerid, 0);
			GameTextForPlayer(playerid, "~p~Four Dragonsa~w~ Isinlandin!", 2000, 6);
			
		}
		case i_dag:
		{
  			if(IsPlayerInAnyVehicle(playerid))
		    {
		        new isinlanmaarac;
		        isinlanmaarac = GetPlayerVehicleID(playerid);
		        SetVehiclePos(isinlanmaarac, -2305.6018,-1662.4376,483.6640);
		        PutPlayerInVehicle(playerid, isinlanmaarac, 0);
		    }
		    else
		    {
				SetPlayerPos(playerid, -2305.6018,-1662.4376,483.6640);
			}
			SetPlayerInterior(playerid, 0);
			GameTextForPlayer(playerid, "Daga Isinlandin!", 2000, 6);

		}
		case i_area69:
		{
  			if(IsPlayerInAnyVehicle(playerid))
		    {
		        new isinlanmaarac;
		        isinlanmaarac = GetPlayerVehicleID(playerid);
		        SetVehiclePos(isinlanmaarac, 167.6945,1915.7870,18.3827);
		        PutPlayerInVehicle(playerid, isinlanmaarac, 0);
		    }
		    else
		    {
				SetPlayerPos(playerid, 167.6945,1915.7870,18.3827);
			}
			SetPlayerInterior(playerid, 0);
			GameTextForPlayer(playerid, "~r~Area69a ~w~Isinlandin!", 2000, 6);
		
		}
		case i_locolow:
		{
  			if(IsPlayerInAnyVehicle(playerid))
		    {
		        new isinlanmaarac;
		        isinlanmaarac = GetPlayerVehicleID(playerid);
		        SetVehiclePos(isinlanmaarac, 2644.6350,-2015.6204,13.1566);
		        PutPlayerInVehicle(playerid, isinlanmaarac, 0);
		    }
		    else
		    {
				SetPlayerPos(playerid, 2644.6350,-2015.6204,13.1566);
			}
			SetPlayerInterior(playerid, 0);
			GameTextForPlayer(playerid, "~y~Locolowcoya~w~ Isinlandin!", 2000, 6);
			
		}
		case i_transfender:
		{
  			if(IsPlayerInAnyVehicle(playerid))
		    {
		        new isinlanmaarac;
		        isinlanmaarac = GetPlayerVehicleID(playerid);
		        SetVehiclePos(isinlanmaarac, -1987.8882,228.0755,28.4588);
		        PutPlayerInVehicle(playerid, isinlanmaarac, 0);
		    }
		    else
		    {
				SetPlayerPos(playerid, -1987.8882,228.0755,28.4588);
			}
			SetPlayerInterior(playerid, 0);
			GameTextForPlayer(playerid, "~y~Transfendera~w~ Isinlandin!", 2000, 6);

		}
		case i_wheelarc:
		{
		    if(IsPlayerInAnyVehicle(playerid))
		    {
		        new isinlanmaarac;
		        isinlanmaarac = GetPlayerVehicleID(playerid);
		        SetVehiclePos(isinlanmaarac, -2703.8901,191.3344,3.8036);
		        PutPlayerInVehicle(playerid, isinlanmaarac, 0);
		    }
		    else
		    {
				SetPlayerPos(playerid, -2703.8901,191.3344,3.8036);
			}
			SetPlayerInterior(playerid, 0);
			GameTextForPlayer(playerid, "~y~Wheel Arca~w~ Isinlandin!", 2000, 6);
			
		}
		
	}
}


public OnPlayerUpdate(playerid)
{
		if(stat[playerid][oyunmodu] == TOM_CeteSavasi && TOM_CeteSavasi_Durum == true)
		{
		    if(!Bellibirbolgedemi(playerid, Tom_Cetesavasi_MaxX, Tom_Cetesavasi_MinX, Tom_Cetesavasi_MaxY, Tom_Cetesavasi_MinY))
		    {
		        GameTextForPlayer(playerid, "~r~Bolgenden cikma!", 3000, 6);
				if(GetPlayerTeam(playerid) == Takim_Grove)
				{
					new rand = random(sizeof(TOM_CeteSavasi_Grove_Spawn));
					SetPlayerPos(playerid, TOM_CeteSavasi_Grove_Spawn[rand][0], TOM_CeteSavasi_Grove_Spawn[rand][1], TOM_CeteSavasi_Grove_Spawn[rand][2]);
				}
				if(GetPlayerTeam(playerid) == Takim_Ballas)
				{
					new rand = random(sizeof(TOM_CeteSavasi_Ballas_Spawn));
					SetPlayerPos(playerid, TOM_CeteSavasi_Ballas_Spawn[rand][0], TOM_CeteSavasi_Ballas_Spawn[rand][1], TOM_CeteSavasi_Ballas_Spawn[rand][2]);
				}
			}
		}
		if(stat[playerid][oyunmodu] == TOM_LSSavasi && TOM_LSSavasi_Durum == true)
		{
		    if(!Bellibirbolgedemi(playerid, Tom_LSSavasi_MaxX, Tom_LSSavasi_MinX, Tom_LSSavasi_MaxY, Tom_LSSavasi_MinY))
		    {
		        GameTextForPlayer(playerid, "~r~Bolgenden cikma!", 3000, 6);
	     		if(GetPlayerTeam(playerid) == Takim_Mavi)
				{
					new rand = random(sizeof(TOM_LSSavasi_Mavi_Spawn));
					SetPlayerPos(playerid, TOM_LSSavasi_Mavi_Spawn[rand][0], TOM_LSSavasi_Mavi_Spawn[rand][1], TOM_LSSavasi_Mavi_Spawn[rand][2]);
				}
				if(GetPlayerTeam(playerid) == Takim_Kirmizi)
				{
					new rand = random(sizeof(TOM_LSSavasi_Kirmizi_Spawn));
					SetPlayerPos(playerid, TOM_LSSavasi_Kirmizi_Spawn[rand][0], TOM_LSSavasi_Kirmizi_Spawn[rand][1], TOM_LSSavasi_Kirmizi_Spawn[rand][2]);
				}
		    }
		}
		if(stat[playerid][oyunmodu] == TOM_Lunapark && TOM_Lunapark_Durum == true)
		{
		    if(!Bellibirbolgedemi(playerid, Tom_Lunapark_MaxX, Tom_Lunapark_MinX, Tom_Lunapark_MaxY, Tom_Lunapark_MinY))
		    {
				GameTextForPlayer(playerid, "~r~Bolgenden cikma!", 3000, 6);
				if(GetPlayerTeam(playerid) == Takim_Beyaz)
				{
					new rand = random(sizeof(TOM_Lunapark_Beyaz_Spawn));
					SetPlayerPos(playerid, TOM_Lunapark_Beyaz_Spawn[rand][0], TOM_Lunapark_Beyaz_Spawn[rand][1], TOM_Lunapark_Beyaz_Spawn[rand][2]);
				}
				if(GetPlayerTeam(playerid) == Takim_Siyah)
				{
					new rand = random(sizeof(TOM_Lunapark_Siyah_Spawn));
					SetPlayerPos(playerid, TOM_Lunapark_Siyah_Spawn[rand][0], TOM_Lunapark_Siyah_Spawn[rand][1], TOM_Lunapark_Siyah_Spawn[rand][2]);
				}
		    }

		}
		if(stat[playerid][oyunmodu] == TOM_Gemi && TOM_Gemi_Durum == true)
		{
		    if(!Bellibirbolgedemi(playerid, Tom_Gemi_MaxX, Tom_Gemi_MinX, Tom_Gemi_MaxY, Tom_Gemi_MinY))
		    {
		        GameTextForPlayer(playerid, "~r~Bolgenden cikma!", 3000, 6);
		        if(GetPlayerTeam(playerid) == Takim_Aztecas)
		        {
       		 			new rand = random(sizeof(TOM_Gemi_Aztecas_Spawn));
				    	SetPlayerPos(playerid, TOM_Gemi_Aztecas_Spawn[rand][0], TOM_Gemi_Aztecas_Spawn[rand][1], TOM_Gemi_Aztecas_Spawn[rand][2]);
			   		 	SetPlayerFacingAngle(playerid, TOM_Gemi_Aztecas_Spawn[rand][3]);
		        }
		        if(GetPlayerTeam(playerid) == Takim_Vagos)
		        {
		        	    new rand = random(sizeof(TOM_Gemi_Vagos_Spawn));
		  			  	SetPlayerPos(playerid, TOM_Gemi_Vagos_Spawn[rand][0], TOM_Gemi_Vagos_Spawn[rand][1], TOM_Gemi_Vagos_Spawn[rand][2]);
   		 				SetPlayerFacingAngle(playerid, TOM_Gemi_Vagos_Spawn[rand][3]);
		        }
		    }
		}
		if(stat[playerid][nitro] == 1 && stat[playerid][oyunmodu] == Freeroam)
		{
			new araba = GetPlayerVehicleID(playerid);
			AddVehicleComponent(araba, 1010);
		}
		if(stat[playerid][oyunmodu] == Derbi_Hava)
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			if(z < 206 || IsPlayerInAnyVehicle(playerid) == 0)
			{
				DestroyVehicle(stat[playerid][derbiarac]);
				new Renk[2];
				new rand;
				new rand2;
				Renk[0] = random(255) + 1;
				Renk[1] = random(255) + 1;
				rand = random(sizeof(Derbi_Hava_Spawn));
				rand2 = random(sizeof(Derbi_HavaAraclari));
				stat[playerid][derbiarac] = CreateVehicle(Derbi_HavaAraclari[rand2][0], Derbi_Hava_Spawn[rand][0], Derbi_Hava_Spawn[rand][1], Derbi_Hava_Spawn[rand][2], Derbi_Hava_Spawn[rand][3], Renk[0], Renk[1], -1);
				SetVehicleVirtualWorld(stat[playerid][derbiarac],Derbi_Hava);
				PutPlayerInVehicle(playerid,stat[playerid][derbiarac], 0);
			}
		}
		if(stat[playerid][oyunmodu] == Derbi_Hava2 )
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			if(z < 178 || IsPlayerInAnyVehicle(playerid) == 0)
			{
				DestroyVehicle(stat[playerid][derbiarac]);
				new Renk[2];
				new rand;
				new rand2;
				Renk[0] = random(255) + 1;
				Renk[1] = random(255) + 1;
				rand = random(sizeof(Derbi_Hava2_Spawn));
				rand2 = random(sizeof(Derbi_HavaAraclari));
				stat[playerid][derbiarac] = CreateVehicle(Derbi_HavaAraclari[rand2][0], Derbi_Hava2_Spawn[rand][0], Derbi_Hava2_Spawn[rand][1], Derbi_Hava2_Spawn[rand][2], Derbi_Hava2_Spawn[rand][3], Renk[0], Renk[1], -1);
				SetVehicleVirtualWorld(stat[playerid][derbiarac],Derbi_Hava2);
				PutPlayerInVehicle(playerid,stat[playerid][derbiarac], 0);
			}
		}
		if(stat[playerid][oyunmodu] == Derbi_Hava3)
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			if(z < 300 || IsPlayerInAnyVehicle(playerid) == 0)
			{
				DestroyVehicle(stat[playerid][derbiarac]);
				new Renk[2];
				new rand;
				new rand2;
				Renk[0] = random(255) + 1;
				Renk[1] = random(255) + 1;
				rand = random(sizeof(Derbi_Hava3_Spawn));
				rand2 = random(sizeof(Derbi_HavaAraclari));
				stat[playerid][derbiarac] = CreateVehicle(Derbi_HavaAraclari[rand2][0], Derbi_Hava3_Spawn[rand][0], Derbi_Hava3_Spawn[rand][1], Derbi_Hava3_Spawn[rand][2], Derbi_Hava3_Spawn[rand][3], Renk[0], Renk[1], -1);
				SetVehicleVirtualWorld(stat[playerid][derbiarac],Derbi_Hava3);
				PutPlayerInVehicle(playerid,stat[playerid][derbiarac], 0);
			}
		}
		return 1;
}




public TOM_Lunapark_Baslat()
{

	if(TOM_Lunapark_Beyaz_Sayi + TOM_Lunapark_Siyah_Sayi > 1)
	{
		SendClientMessageToAll(Renk_Mavi,"Lunapark Savasi baslatildi!");
		TOM_Lunapark_Pickupolustur();
		TOM_Lunapark_TIMELIMIT = SetTimer("TOM_Lunapark_ZamanDolumu", 300000, false);
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(stat[i][oyunmodu] == TOM_Lunapark)
			{
			    SetPlayerHealth(i, 100.0);
				SetPlayerVirtualWorld(i,TOM_Lunapark);
				SendClientMessage(i,Renk_AltinSarisi,"[TOM]5 Dakika sure dolana kadar en cok puani almaya calis");
				ResetPlayerWeapons(i);
				GivePlayerWeapon(i,29,1029);
				GivePlayerWeapon(i,25,999);
				GivePlayerWeapon(i,8,999);
				GivePlayerWeapon(i,34,999);
				if(GetPlayerTeam(i) == Takim_Beyaz) 
				{
					SetPlayerColor(i, Renk_Beyaz);
					SetPlayerSkin(i,83);
					new rand = random(sizeof(TOM_Lunapark_Beyaz_Spawn));
					SetPlayerPos(i, TOM_Lunapark_Beyaz_Spawn[rand][0], TOM_Lunapark_Beyaz_Spawn[rand][1], TOM_Lunapark_Beyaz_Spawn[rand][2]);
					
				}
				if(GetPlayerTeam(i) == Takim_Siyah)
				{
					SetPlayerColor(i, Renk_Siyah);
					SetPlayerSkin(i,82);
					new rand = random(sizeof(TOM_Lunapark_Siyah_Spawn));
					SetPlayerPos(i, TOM_Lunapark_Siyah_Spawn[rand][0], TOM_Lunapark_Siyah_Spawn[rand][1], TOM_Lunapark_Siyah_Spawn[rand][2]);
				}
			}
		}
		TOM_Lunapark_Durum = true;
	}
	else TOM_Lunapark_Kapat(TOM_Lunapark_Azkisi);
}




public TOM_Lunapark_Kapat(sebep)
{
	KillTimer(TOM_Lunapark_TIMELIMIT);
	Pickupyoket(TOM_Lunapark_Pickup);
	TOM_Lunapark_Durum = false;
	TOM_Lunapark_Siyah_Sayi = 0;
	TOM_Lunapark_Beyaz_Sayi = 0;
	TOM_Lunapark_Beyaz_Skor = 0;
	TOM_Lunapark_Siyah_Skor = 0;
	switch(sebep)
	{
	case TOM_Lunapark_Azkisi:
	{
		SendClientMessageToAll(Renk_AcikKirmizi, "Lunapark Savasi az kisi oldugu icin kapatildi!");
	}
	case TOM_Lunapark_Cikis:
	{
		SendClientMessageToAll(Renk_AcikKirmizi, "Lunapark Savasindan birisi cikti ve az kisi kaldigi icin kapatildi.!");
	}
	case TOM_Lunapark_Beyaz_Kazan:
	{
	SendClientMessageToAll(Renk_AcikKirmizi, "Lunapark Savasini [Beyaz Takim] kazandi");
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(GetPlayerTeam(i) == Takim_Beyaz)
		{
			GivePlayerMoney(i,Tom_Parasi);
			stat[i][Tomkazanma]++;
			SendClientMessage(i,Renk_Mavi,"Lunapark Savasini kazandigin icin odul para verildi");
		}
	}
			
	}
		case TOM_Lunapark_Siyah_Kazan:
		{
			SendClientMessageToAll(Renk_AcikKirmizi, "Lunapark Savasini [Siyah Takim] kazandi");
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(GetPlayerTeam(i) == Takim_Siyah)
				{
					GivePlayerMoney(i,Tom_Parasi);
					stat[i][Tomkazanma]++;
					SendClientMessage(i,Renk_Mavi,"Lunapark savasini kazandigin icin odul para verildi");
				}
			}
		}
		case TOM_Lunapark_Berabere:
		{
			SendClientMessageToAll(Renk_AcikKirmizi, "Lunapark Savasi berabere bitti");
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(stat[i][oyunmodu] == TOM_Lunapark)
				{
					GivePlayerMoney(i,750);
					SendClientMessage(i,Renk_Mavi,"Katildigin icin 750$");
				}
			}
			
		}
		
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	if(stat[i][oyunmodu] == TOM_Lunapark)
	{
		stat[i][oyunmodu] = Freeroam;
		SetPlayerVirtualWorld(i,Freeroam);
		SetPlayerTeam(i,NO_TEAM);
		SetPlayerColor(i, Renk_Beyaz);
	}
	}
	
}

public TOM_Lunapark_ZamanDolumu()
{
	if(TOM_Lunapark_Beyaz_Skor > TOM_Lunapark_Siyah_Skor) TOM_Lunapark_Kapat(TOM_Lunapark_Beyaz_Kazan);
	else if(TOM_Lunapark_Beyaz_Skor < TOM_Lunapark_Siyah_Skor) TOM_Lunapark_Kapat(TOM_Lunapark_Siyah_Kazan);
	else TOM_Lunapark_Kapat(TOM_Lunapark_Berabere);
}


public TOM_Gemi_Baslat()
{
	if(TOM_Gemi_Aztecas_Sayi + TOM_Gemi_Vagos_Sayi > 0)
	{
		SendClientMessageToAll(Renk_Mavi,"Gemi Savasi baslatildi!");
		TOM_Gemi_Pickupolustur();
		TOM_Gemi_TIMELIMIT = SetTimer("TOM_Gemi_ZamanDolumu", 300000, false);
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(stat[i][oyunmodu] == TOM_Gemi)
			{
			    SetPlayerHealth(i, 100.0);
				SetPlayerVirtualWorld(i,TOM_Gemi);
				SendClientMessage(i,Renk_AltinSarisi,"[TOM]5 Dakika sure dolana kadar en cok puani almaya calis");
				ResetPlayerWeapons(i);
				GivePlayerWeapon(i, 30, 1029);
				GivePlayerWeapon(i, 33, 1029);
				GivePlayerWeapon(i, 25, 999);
				GivePlayerWeapon(i, 9, 1);
				if(GetPlayerTeam(i) == Takim_Aztecas)
				{
					SetPlayerColor(i, Renk_Mavi);
					SetPlayerSkin(i,116);
	 				new rand = random(sizeof(TOM_Gemi_Aztecas_Spawn));
				    SetPlayerPos(i, TOM_Gemi_Aztecas_Spawn[rand][0], TOM_Gemi_Aztecas_Spawn[rand][1], TOM_Gemi_Aztecas_Spawn[rand][2]);
	   			 	SetPlayerFacingAngle(i, TOM_Gemi_Aztecas_Spawn[rand][3]);

				}
				if(GetPlayerTeam(i) == Takim_Vagos)
				{
					SetPlayerColor(i, Renk_Turuncu);
					SetPlayerSkin(i,110);
		    		new rand = random(sizeof(TOM_Gemi_Vagos_Spawn));
	   			 	SetPlayerPos(i, TOM_Gemi_Vagos_Spawn[rand][0], TOM_Gemi_Vagos_Spawn[rand][1], TOM_Gemi_Vagos_Spawn[rand][2]);
		    		SetPlayerFacingAngle(i, TOM_Gemi_Vagos_Spawn[rand][3]);
				}
			}
		}
		TOM_Gemi_Durum = true;
	}
	else TOM_Gemi_Kapat(TOM_Gemi_Azkisi);
}

public TOM_Gemi_Kapat(sebep)
{
	KillTimer(TOM_Gemi_TIMELIMIT);
	Pickupyoket(TOM_Gemi_Pickup);
	TOM_Gemi_Durum = false;
	TOM_Gemi_Aztecas_Sayi = 0;
	TOM_Gemi_Vagos_Sayi = 0;
	TOM_Gemi_Aztecas_Skor = 0;
	TOM_Gemi_Vagos_Skor = 0;
	switch(sebep)
	{
	case TOM_Gemi_Azkisi:
	{
		SendClientMessageToAll(Renk_AcikKirmizi, "Gemi Savasi az kisi oldugu icin kapatildi!");
	}
	case TOM_Gemi_Cikis:
	{
		SendClientMessageToAll(Renk_AcikKirmizi, "Gemi Savasindan birisi cikti ve az kisi kaldigi icin kapatildi.!");
	}
	case TOM_Gemi_Aztecas_Kazan:
	{
		SendClientMessageToAll(Renk_AcikKirmizi, "Gemi Savasini [Aztecas] kazandi");
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(GetPlayerTeam(i) == Takim_Aztecas)
			{
				GivePlayerMoney(i,Tom_Parasi);
				stat[i][Tomkazanma]++;
				SendClientMessage(i,Renk_Mavi,"Gemi Savasini kazandigin icin odul para verildi");
			}
		}
	}
		case TOM_Gemi_Vagos_Kazan:
		{
			SendClientMessageToAll(Renk_AcikKirmizi, "Gemi Savasini [Vagos] kazandi");
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(GetPlayerTeam(i) == Takim_Vagos)
				{
					GivePlayerMoney(i,Tom_Parasi);
					stat[i][Tomkazanma]++;
					SendClientMessage(i,Renk_Mavi,"Gemi savasini kazandigin icin odul para verildi");
				}
			}
		}
		case TOM_Gemi_Berabere:
		{
			SendClientMessageToAll(Renk_AcikKirmizi, "Gemi Savasi berabere bitti");
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(stat[i][oyunmodu] == TOM_Gemi)
				{
					GivePlayerMoney(i,750);
					SendClientMessage(i,Renk_Mavi,"Katildigin icin 750$");
				}
			}

		}

	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(stat[i][oyunmodu] == TOM_Gemi)
		{
			stat[i][oyunmodu] = Freeroam;
			SetPlayerVirtualWorld(i,Freeroam);
			SetPlayerTeam(i,NO_TEAM);
			SetPlayerColor(i, Renk_Beyaz);
		}
	}
}

public TOM_Gemi_ZamanDolumu()
{
	if(TOM_Gemi_Aztecas_Skor > TOM_Gemi_Vagos_Skor) TOM_Gemi_Kapat(TOM_Gemi_Aztecas_Kazan);
	else if(TOM_Gemi_Aztecas_Skor < TOM_Gemi_Vagos_Skor) TOM_Gemi_Kapat(TOM_Gemi_Vagos_Kazan);
	else TOM_Gemi_Kapat(TOM_Gemi_Berabere);
}


Derbi_Hava_MapAyarla()
{
	CreateObject(3458, 322.76801, 3016.81519, 208.57150,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 282.34760, 3016.88989, 208.65491,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 264.70291, 3039.63770, 208.65500,   0.00000, 0.00000, 270.55429);
	CreateObject(3458, 287.21719, 3057.29199, 208.82410,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 327.62241, 3057.22339, 208.82970,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 345.45389, 3034.57935, 208.80670,   0.00000, 0.00000, 270.02689);
	CreateObject(3458, 287.33011, 3044.57813, 208.82021,   0.00000, 0.00000, 0.00000);
	CreateObject(1633, 303.89114, 3044.44824, 211.77824,   0.00000, 0.00000, 274.88150);
	CreateObject(3458, 264.25500, 3079.93188, 208.62561,   0.00000, 0.00000, 270.43521);
	CreateObject(3458, 284.78778, 3097.10840, 219.22061,   0.00000, -31.00000, 360.00000);
	CreateObject(3458, 321.59494, 3097.13623, 229.45039,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 345.21017, 3077.80640, 219.46327,   0.00000, 30.00000, 270.00000);
	CreateObject(3458, 362.00079, 3097.08228, 229.43510,   0.00000, 0.00000, 359.69699);
	CreateObject(1633, 338.35260, 3045.20288, 211.36148,   0.00000, 0.00000, 88.76153);
	CreateObject(3458, 379.08804, 3077.62354, 219.46300,   0.00000, 30.00000, 270.00000);
	CreateObject(3458, 368.25168, 3057.16357, 208.79424,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 328.16821, 3074.46143, 229.45061,   0.00000, 0.00000, 89.48780);
	CreateObject(18451, 328.86618, 3056.87036, 231.70569,   0.00000, 0.00000, 179.21249);
	return 1;
}

Derbi_Hava2_MapAyarla()
{
	CreateObject(3458, 2660.45190, 3019.39844, 208.46910,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 2620.08521, 3019.27319, 208.46910,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 2602.82422, 3042.04150, 208.46910,   0.00000, 0.00000, 89.54010);
	CreateObject(3458, 2625.50586, 3054.11987, 208.46910,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 2602.98364, 3082.29150, 208.46910,   0.00000, 0.00000, 269.82230);
	CreateObject(3458, 2625.80566, 3099.70093, 208.46910,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 2639.99902, 3076.96753, 208.46910,   0.00000, 0.00000, 271.10233);
	CreateObject(3458, 2658.67017, 3053.93457, 194.48450,   0.00000, -46.00000, 179.44414);
	CreateObject(3458, 2694.02100, 3053.45728, 179.79343,   0.00000, 0.00000, 359.87827);
	CreateObject(3458, 2678.04590, 3041.50537, 204.56136,   0.00000, 11.00000, 90.20352);
	CreateObject(3458, 2677.89453, 3081.70166, 200.66737,   0.00000, 0.00000, 270.09686);
	CreateObject(3458, 2660.48438, 3099.89502, 195.84074,   0.00000, 40.00000, 0.00000);
	CreateObject(3458, 2678.66504, 3081.30615, 179.79260,   0.00000, 0.00000, 270.37900);
	CreateObject(1245, 2678.00146, 3065.93042, 182.87863,   0.00000, 0.00000, 95.60732);
	CreateObject(3458, 2677.72095, 3121.95093, 200.76863,   0.00000, 0.00000, 270.10266);
	CreateObject(3458, 2659.23120, 3134.27979, 215.10889,   0.00000, 40.00000, 0.42253);
	CreateObject(3458, 2641.98633, 3116.80884, 227.67908,   0.00000, 0.00000, 271.61612);
	CreateObject(3458, 2617.82495, 3134.36328, 219.33028,   0.00000, -31.00000, 359.57584);
	CreateObject(3458, 2598.01709, 3118.49561, 208.41850,   0.00000, 0.00000, 270.00046);
	CreateObject(1633, 2641.83008, 3097.53760, 229.75834,   0.00000, 0.00000, 175.23941);
	CreateObject(1634, 2711.73462, 3060.50806, 182.78711,   0.00000, 0.00000, 0.00000);
	CreateObject(1634, 2711.77344, 3068.54028, 186.46646,   0.00000, 0.00000, 0.00000);
	CreateObject(1634, 2711.84326, 3076.46851, 190.27800,   0.00000, 0.00000, 0.00000);
	CreateObject(1634, 2711.89600, 3084.53418, 193.97585,   0.00000, 0.00000, 0.00000);
	CreateObject(1634, 2711.79346, 3092.28516, 197.82704,   0.00000, 0.00000, 359.59393);
	CreateObject(3458, 2700.50635, 3114.07080, 200.74812,   0.00000, 0.00000, 0.00000);
	CreateObject(1245, 2635.06934, 3132.91284, 231.63544,   0.00000, 0.00000, 181.53682);
	return 1;
}

Derbi_Hava3_MapAyarla()
{
	CreateObject(3458, 2921.41772, 675.61969, 316.74530,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 2961.80981, 675.62860, 316.74530,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 3014.14575, 675.26788, 316.19910,   0.00000, 0.00000, 359.68781);
	CreateObject(5153, 2980.68457, 675.55078, 318.24146,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 3030.73975, 652.39471, 316.11554,   0.00000, 0.00000, 268.82455);
	CreateObject(3458, 3007.54199, 634.70111, 316.57999,   0.00000, 0.00000, 359.28076);
	CreateObject(3458, 2967.25562, 634.89313, 316.39127,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 2950.38818, 656.56085, 316.13428,   0.00000, 0.00000, 270.66199);
	CreateObject(3458, 2952.18701, 612.49579, 316.26904,   0.00000, 0.00000, 89.42539);
	CreateObject(3458, 2930.17627, 615.53363, 316.19275,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 2912.77783, 638.25500, 316.19894,   0.00000, 0.00000, 269.47729);
	CreateObject(18451, 2912.84473, 654.22479, 318.33267,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 3008.26025, 601.63171, 316.17230,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 3030.48999, 612.04480, 316.21558,   0.00000, 0.00000, 90.04254);
	CreateObject(1633, 2993.99976, 601.64935, 318.78557,   0.00000, 0.00000, 91.23439);
	CreateObject(3458, 3030.48682, 571.52832, 316.17041,   0.00000, 0.00000, 269.74405);
	CreateObject(3458, 3007.89722, 554.06665, 316.10648,   0.00000, 0.00000, 0.00000);
	CreateObject(3458, 2967.48535, 554.14911, 316.08624,   0.00000, 0.00000, 0.00000);
	CreateObject(12990, 2952.24951, 571.67084, 317.57242,   0.00000, 0.00000, 0.51010);
	return 1;
}


sfaracolustur()
{
	AddStaticVehicle(519,-1517.1854,-25.8945,15.0756,137.2297,1,1); //
	AddStaticVehicle(487,-1398.2983,-69.7012,14.3783,283.4538,29,42); //
	AddStaticVehicle(487,-1224.8762,-10.2000,14.3231,233.5327,29,42); //
	AddStaticVehicle(411,-1675.9413,414.5501,6.9068,314.7534,123,1); //
	AddStaticVehicle(411,-1552.2593,692.5901,6.8342,358.1152,116,1); //
	AddStaticVehicle(402,-1527.9923,855.7625,6.9183,359.9992,13,13); //
	AddStaticVehicle(415,-1610.1000,1143.6580,6.8122,0.5748,36,1); //
	AddStaticVehicle(415,-1660.2495,1214.3925,7.0199,266.8597,36,1); //
	AddStaticVehicle(429,-1655.9425,1213.7046,13.3531,275.0735,13,13); //
	AddStaticVehicle(439,-1656.6807,1209.5360,21.0524,274.7020,8,17); //
	AddStaticVehicle(445,-1901.2489,1184.1151,45.1718,90.2589,35,35); //
	AddStaticVehicle(451,-1905.2360,880.5236,34.7212,180.7453,125,125); //
	AddStaticVehicle(451,-2095.9324,643.5355,52.0745,177.4140,16,16); //
	AddStaticVehicle(479,-2123.2686,571.4257,34.8096,90.0815,59,36); //
	AddStaticVehicle(496,-2376.9783,523.2673,27.5912,6.9546,53,56); //
	AddStaticVehicle(416,-2544.2856,586.9423,14.6019,274.4558,1,3); //
	AddStaticVehicle(416,-2543.8027,592.8873,14.6015,271.4461,1,3); //
	AddStaticVehicle(420,-2541.0896,703.2614,27.6614,89.3329,6,1); //
	AddStaticVehicle(426,-2587.2483,903.0917,64.6439,269.2543,53,53); //
	AddStaticVehicle(429,-2529.9897,991.7855,77.8476,359.9778,14,14); //
	AddStaticVehicle(429,-2609.4453,1034.8445,72.6010,346.2697,14,14); //
	AddStaticVehicle(431,-2589.6799,1149.7645,55.5380,331.7274,75,59); //
	AddStaticVehicle(461,-2566.7234,1140.7465,55.3118,262.7817,37,1); //
	AddStaticVehicle(467,-2356.8547,1134.8582,55.1104,64.5373,58,8); //
	AddStaticVehicle(467,-2446.9778,1384.7452,6.8519,89.1412,58,8); //
	AddStaticVehicle(474,-2646.3057,1334.6240,6.9354,0.5729,81,1); //
	AddStaticVehicle(475,-2642.5000,1334.3666,6.9848,359.3577,9,39); //
	AddStaticVehicle(477,-2884.5542,1075.9479,30.5214,179.1447,101,1); //
	AddStaticVehicle(468,-2837.3987,894.9155,43.7148,268.4315,46,46); //
	AddStaticVehicle(468,-2836.9290,893.2179,43.7196,274.5651,46,46); //
	AddStaticVehicle(463,-2732.4526,808.7143,52.6033,268.6253,7,7); //
	AddStaticVehicle(445,-2486.5906,741.3814,34.8906,176.1747,39,39); //
	AddStaticVehicle(445,-2491.2129,741.8920,34.8905,180.6212,39,39); //
	AddStaticVehicle(438,-2286.6514,805.0091,49.2992,270.7409,6,76); //
	AddStaticVehicle(434,-2226.2258,735.1254,49.2299,271.2726,12,12); //
	AddStaticVehicle(424,-1989.6304,149.9935,27.3182,182.9173,2,2); //
}

lvaracolustur()
{
	AddStaticVehicle(415,1068.6031,1189.2205,10.4441,272.9131,1,255); // lv
	AddStaticVehicle(475,1363.6654,1191.1979,10.4748,269.3885,128,51); // lv
	AddStaticVehicle(541,1503.3497,1089.8629,10.3338,177.2869,92,150); // lv
	AddStaticVehicle(541,1506.5361,879.6404,9.7643,130.2115,87,18); // lv
	AddStaticVehicle(506,1651.4722,986.8366,10.5244,359.0739,105,234); // lv
	AddStaticVehicle(451,1661.7396,988.3078,10.5282,0.5580,14,201); // lv
	AddStaticVehicle(451,1645.4232,1066.3861,10.5264,271.2090,89,110); // lv
	AddStaticVehicle(411,2075.3623,1208.5264,10.3989,0.4019,197,184); // lv
	AddStaticVehicle(477,2040.0264,1224.9199,10.4257,179.1696,101,245); // lv
	AddStaticVehicle(438,1723.7897,1552.6823,10.6750,12.0067,192,19); // lv
	AddStaticVehicle(592,1522.2484,1657.8500,12.0201,357.7661,69,15); // lv
	AddStaticVehicle(487,1327.8218,1303.0635,11.0026,279.7000,60,186); // lv
	AddStaticVehicle(487,1326.1476,1328.7396,11.0003,286.1582,60,186); // lv
	AddStaticVehicle(522,1328.7433,1279.2474,10.3946,176.8673,43,190); // lv
	AddStaticVehicle(522,1325.4650,1279.1188,10.3822,181.9581,43,190); // lv
	AddStaticVehicle(522,1321.8907,1279.6295,10.3869,154.8863,43,190); // lv
	AddStaticVehicle(540,1856.3953,2067.0266,10.6878,88.1113,191,203); // lv
	AddStaticVehicle(540,1741.4591,2190.9294,10.6785,182.4306,191,203); // lv
	AddStaticVehicle(540,1686.1431,2201.7371,10.6824,359.9727,191,203); // lv
	AddStaticVehicle(466,1597.5563,2179.6174,10.5625,91.3954,183,173); // lv
	AddStaticVehicle(466,1541.4117,2214.7207,10.5628,177.3418,183,173); // lv
	AddStaticVehicle(400,1537.7222,2214.7107,10.9127,181.3273,250,166); // lv
	AddStaticVehicle(526,1534.3833,2214.8125,10.5870,178.7543,147,23); // lv
	AddStaticVehicle(429,1531.2537,2215.1638,10.5000,179.5278,254,97); // lv
	AddStaticVehicle(459,1397.5830,2283.4211,10.8750,268.6685,204,215); // lv
	AddStaticVehicle(415,1493.7410,2540.5327,10.5929,93.8165,158,62); // lv
	AddStaticVehicle(415,1243.1003,2609.9548,10.5207,2.1167,100,108); // lv
	AddStaticVehicle(415,1374.6527,2646.5752,10.5927,2.6847,100,108); // lv
	AddStaticVehicle(505,1369.4735,2649.4832,11.0703,359.0842,48,156); // lv
	AddStaticVehicle(603,1363.6898,2648.8916,10.6585,359.1187,209,186); // lv
	AddStaticVehicle(402,1358.1505,2648.1082,10.6516,357.8836,0,140); // lv
	AddStaticVehicle(402,1603.1167,2726.9812,10.6517,271.4614,0,140); // lv
	AddStaticVehicle(412,2142.3662,2795.5618,10.6592,90.4366,25,65); // lv
	AddStaticVehicle(480,2142.5742,2799.4507,10.5921,89.1978,205,137); // lv
	AddStaticVehicle(439,2143.3381,2806.5884,10.7157,90.0611,10,251); // lv
	AddStaticVehicle(467,2143.1182,2810.7813,10.5604,90.8678,111,135); // lv
	AddStaticVehicle(467,2143.0051,2814.1316,10.5605,90.6249,126,211); // lv
	AddStaticVehicle(420,2142.6306,2818.3674,10.6011,89.3893,3,158); // lv
	AddStaticVehicle(468,2142.5886,2836.5723,10.4890,103.5992,137,139); // lv
	AddStaticVehicle(468,2391.3560,2561.3669,10.2700,180.1068,137,139); // lv
	AddStaticVehicle(555,2339.8867,2116.1123,10.3640,180.4208,9,48); // lv
	AddStaticVehicle(555,2421.3916,2029.5565,10.3556,177.4851,9,48); // lv
	AddStaticVehicle(404,2504.0371,1919.7361,10.4053,181.3542,94,177); // lv
	AddStaticVehicle(404,2630.2651,1681.2372,10.5512,269.3296,94,177); // lv
	AddStaticVehicle(409,2492.2356,1539.2072,10.4755,51.6319,63,165); // lv
	AddStaticVehicle(463,2526.9075,1381.2229,10.3594,89.2502,134,115); // lv
	AddStaticVehicle(510,2510.8340,1262.1340,10.3530,90.6653,206,46); // lv
	AddStaticVehicle(510,2479.0376,1260.0219,10.4267,175.9569,206,46); // lv
	AddStaticVehicle(503,2424.7117,1130.0977,10.5664,182.2024,89,135); // lv
	AddStaticVehicle(503,2265.0352,975.2524,10.5668,91.7160,89,135); // lv
	AddStaticVehicle(503,2132.6851,1022.0446,10.7144,269.2664,89,135); // lv
	AddStaticVehicle(479,2132.3169,1028.8748,10.6132,270.7405,75,1); // lv
	AddStaticVehicle(479,2066.9773,759.3888,10.6120,88.7911,75,1); // lv
	AddStaticVehicle(470,2078.4041,758.3909,10.8919,273.7097,118,224); // lv
	AddStaticVehicle(470,1923.8030,671.8729,10.9660,166.9515,118,224); // lv
}




Inis_MapAyarla()
{
	CreateObject(10476, -3530.04297, 275.18231, 539.02161,   0.00000, 0.00000, 90.28376);
	CreateObject(10476, -3523.51636, 177.38914, 491.26100,   0.00000, 52.00000, 269.40207);
	CreateObject(10476, -3525.07959, 46.38808, 442.60513,   0.00000, 0.00000, 269.26556);
	CreateObject(10476, -3526.42725, -77.20602, 417.23950,   0.00000, 25.00000, 269.51254);
	CreateObject(10476, -3527.55957, -186.15657, 348.88132,   -0.06000, 40.06000, 269.18890);
	CreateObject(10476, -3527.85815, -279.72699, 260.12970,   0.00000, 47.00000, 270.44803);
	CreateObject(10476, -3527.22681, -377.48010, 176.47969,   0.00000, 33.00000, 270.25815);
	CreateObject(17582, -3538.93115, -548.51495, 137.29039,   0.00000, 0.00000, 0.00000);
	CreateObject(10472, -3532.03003, -541.69611, 104.44183,   0.00000, 0.00000, 269.72427);
	CreateObject(1632, -3527.53101, 149.28000, 459.26889,   -33.00000, 0.00000, 180.00000);
	CreateObject(10472, -3532.36548, -634.20734, 76.81567,   0.00000, 27.00000, 269.71762);
	CreateObject(10472, -3532.29761, -726.57928, 57.63660,   0.00000, 0.00000, 270.23550);
	CreateObject(1632, -3532.37476, -767.57336, 58.80877,   0.00000, 0.00000, 179.66176);
	CreateObject(8040, -3535.84253, -842.30975, 53.26710,   0.00000, 0.00000, 179.61769);

}

Inis2_MapAyarla()
{
	CreateObject(10476, 3292.07446, -976.89233, 513.98407,   87.00000, 0.00000, 271.29117);
	CreateObject(10476, 3272.23364, -977.19232, 506.89951,   -91.00000, 0.00000, 270.67068);
	CreateObject(1634, 3282.74268, -1040.30176, 501.82480,   0.00000, 0.00000, 181.23784);
	CreateObject(10476, 3286.59766, -1138.29944, 505.36002,   0.00000, -0.06000, 270.43024);
	CreateObject(1633, 3283.48755, -1204.97815, 506.63770,   0.00000, 0.00000, 180.87408);
	CreateObject(10476, 3287.89526, -1284.79321, 459.25778,   0.00000, 40.00000, 269.69049);
	CreateObject(18809, 3284.26440, -1362.53796, 419.63284,   91.00000, 0.00000, 359.81842);
	CreateObject(18809, 3284.58472, -1412.07068, 421.28214,   85.00000, 0.00000, 0.91409);
	CreateObject(10476, 3289.42407, -1489.45654, 384.42587,   0.00000, 33.00000, 271.15274);
	CreateObject(10476, 3291.48730, -1598.04102, 313.97028,   0.00000, 33.00000, 271.01837);
	CreateObject(10476, 3293.55103, -1706.61340, 243.18874,   0.00000, 33.00000, 270.99799);
	CreateObject(1632, 3290.67969, -1749.83643, 217.78566,   -18.00000, 0.00000, 179.00000);
	CreateObject(10476, 3294.54883, -1833.58325, 219.95630,   0.00000, 0.00000, 270.51822);
	CreateObject(10476, 3295.16357, -1957.75684, 194.41989,   0.00000, 25.00000, 270.00909);
	CreateObject(10476, 3294.68604, -2061.72363, 120.16135,   0.00000, 47.00000, 269.43356);
	CreateObject(8420, 3276.89600, -2152.41870, 60.69814,   0.00000, 0.00000, 0.00000);
	CreateObject(1633, 3270.71729, -2165.13867, 61.30060,   0.00000, 0.00000, 95.66650);
	CreateObject(10476, 3285.54150, -977.24432, 500.83374,   0.00000, 0.00000, 271.12546);

}

Stuntadasi_Map()
{
	CreateObject(5743, 3023.76953, -84.80440, 0.11217,   0.00000, 0.00000, 0.00000);
	CreateObject(5743, 3029.94897, -177.46082, 0.11096,   0.54000, 0.06000, 0.00000);
	CreateObject(1632, 3045.85596, -195.69019, 2.79231,   0.00000, 0.00000, 280.98428);
	CreateObject(1634, 3052.33716, -194.37218, 8.38266,   33.00000, 0.00000, 281.00000);
	CreateObject(1634, 3053.59521, -194.13881, 17.13120,   76.00000, 0.00000, 282.00000);
	CreateObject(1634, 3048.98975, -194.32176, 24.94179,   113.00000, 0.00000, 281.00000);
	CreateObject(1634, 3021.93628, -53.19367, 2.72438,   0.00000, -0.06000, 8.10635);
	CreateObject(8420, 3011.44849, 18.85627, 1.05469,   -0.48000, -0.66000, 5.93658);
	CreateObject(1859, 3035.25732, 48.59119, 1.00909,   0.00000, 0.00000, 0.00000);
	CreateObject(1859, 3007.87695, 50.33257, 0.96469,   0.00000, 0.00000, 0.00000);
	CreateObject(18801, 2989.31909, 22.85227, 23.35857,   0.00000, 0.00000, 99.00722);
	CreateObject(8420, 3003.18359, 98.18203, 1.24247,   0.06000, 0.18000, 276.01889);
	CreateObject(11423, 2978.15503, -184.61383, 4.53620,   0.00000, 0.00000, 7.42145);
	CreateObject(3364, 3039.21460, 56.15621, 1.02752,   0.00000, 0.00000, 96.77930);
	CreateObject(3664, 3037.29492, -8.26622, 7.74876,   0.00000, 0.00000, 185.71437);
	CreateObject(13647, 3012.42529, 98.81368, 0.85892,   0.00000, 0.00000, 96.37732);
	CreateObject(1634, 3028.65820, -106.33383, 2.76040,   0.00000, 0.00000, 185.69125);
	CreateObject(7073, 2971.79248, 75.04180, 19.16763,   0.00000, 0.00000, 0.00000);
	CreateObject(3363, 3041.71899, -159.53938, 1.63955,   0.00000, 0.00000, 0.00000);
	CreateObject(16317, 2979.73999, 100.70543, 1.13555,   0.00000, 0.00000, 0.00000);
	CreateObject(1634, 3028.70435, -143.08238, 2.71852,   0.00000, 0.00000, 8.16697);
	CreateObject(18809, 3064.61060, 115.71934, 9.25905,   0.06000, 84.00000, 4.88080);
	CreateObject(18826, 3102.34009, 104.89805, 11.70720,   90.00000, 0.00000, 194.39439);
	CreateObject(18822, 3078.60864, 72.18966, 8.26775,   98.06000, 0.00000, 314.90149);
	CreateObject(18809, 3062.47974, 33.53165, 5.37277,   90.94000, -0.06000, 352.28030);
	CreateObject(18809, 3058.72485, -13.66869, 7.46331,   84.00000, 0.00000, 358.64001);
	CreateObject(18809, 3058.13550, -62.14416, 12.80129,   84.00000, 0.00000, 0.00000);
	CreateObject(18809, 3057.98340, -111.41377, 14.98520,   91.00000, 0.00000, 0.00000);
	CreateObject(13593, 3037.67773, 113.69464, 1.63851,   0.00000, 0.00000, 270.86203);
	CreateObject(1634, 3058.22144, -140.01814, 7.21015,   0.00000, 0.00000, 3.28366);
	CreateObject(1634, 1993.58020, 10483.15820, 1734.12000,   0.00000, 0.00000, 0.00000);
	CreateObject(1634, 3058.58008, -148.26590, 4.02853,   0.00000, 0.00000, 3.79699);
	CreateObject(1632, 3059.13110, -156.38310, 0.83845,   0.00000, 0.00000, 4.07278);
}

public OnGameModeExit()
{
	db_close(Database);
	db_close(Banlar);
	return 1;
}

oyuncumapicon(playerid)
{
	//Los Santos Map Ýconlarý
	SetPlayerMapIcon(playerid, 0, 487.9183,-1738.7825,11.1453, 63, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 1, 812.3661,-1618.6556,13.5547, 10, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 2, 2067.2981,-1831.8708,13.5469, 63, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 3, 2102.7424,-1806.2148,13.5547, 29, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 4, 2245.4758,-1662.5996,15.4690, 45, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 5, 2029.4478,-1419.5760,16.9922, 22, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 6, 2400.3328,-1979.2914,13.5469, 6, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 7, 2398.6123,-1896.4456,13.3828, 14, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 8, 2422.3313,-1508.8656,23.9922, 14, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 9, 1364.5203,-1279.4402,13.5469, 6, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 10, 1187.4402,-1324.3937,13.5592, 22, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 11, 1200.0172,-921.1258,43.1030, 10, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 12, 1025.6165,-1026.3602,32.1016, 63, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 13, 1041.6993,-1020.2932,31.9371, 27, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 14, 2644.8169,-2043.5076,13.4820, 27, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 15, 2228.1035,-1723.7977,13.5514, 54, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 16, 2113.0950,-1215.0875,23.9682, 45, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 17, 1458.8289,-1140.0374,24.0686, 45, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 18, 1550.9606,-1675.6831,15.6390, 30, 0, MAPICON_LOCAL);
	//San Fierro Map Ýconlarý
	SetPlayerMapIcon(playerid, 19, -2671.8511,262.7358,4.6328, 14, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 20, -2626.0291,210.9343,4.6138, 6, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 21, -2722.7771,218.1241,4.1891, 27, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 22, -2335.3530,-166.8052,35.5547, 10, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 23, -1936.3435,244.8871,34.2891, 27, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 24, -1904.6279,281.6371,40.6102, 63, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 25, -1816.2312,615.8433,35.1719, 14, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 26, -1909.9227,829.1687,35.1719, 10, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 27, -1886.5820,861.8916,35.1641, 45, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 28, -1803.4011,942.8769,24.8906, 29, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 29, -1696.9421,949.3261,24.8906, 45, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 30, -1724.6033,1359.2029,7.1875, 29, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 31, -2646.6045,610.3934,14.4531, 22, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 32, -1886.5820,861.8916,35.1641, 45, 0, MAPICON_LOCAL);
	//Las Venturas Map Ýconlarý
	SetPlayerMapIcon(playerid, 33, 2755.1299,2474.6816,11.0625, 29, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 34, 2775.8452,2451.0422,10.8203, 45, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 35, 2800.1453,2428.2754,11.0625, 45, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 36, 2822.2849,2404.2793,10.8203, 45, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 37, 2840.9263,2405.1821,11.0690, 14, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 38, 1158.9968,2068.8118,10.8203, 10, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 39, 1873.6589,2068.2717,10.8203, 10, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 40, 1973.7930,2162.0662,10.7742, 63, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 41, 1966.9049,2294.4502,16.4559, 54, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 42, 2083.2002,2220.6506,10.8203, 29, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 43, 2090.2434,2221.2139,10.8203, 45, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 44, 2104.5989,2229.2244,11.0234, 14, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 45, 2105.2124,2257.5073,11.0234, 45, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 46, 2027.9208,1007.5819,10.8203, 44, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 47, 2392.5164,2044.4840,10.8203, 14, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 48, 2470.3613,2034.3145,11.0625, 10, 0, MAPICON_LOCAL);
}

minigunolustur()
{
	Pickupyoket(minigun);
	new rand = random(sizeof(minigunspawn));
	minigun = CreatePickup(362, 1, minigunspawn[rand][0], minigunspawn[rand][1], minigunspawn[rand][2], 0);
	new mgmesaj[130];
	format(mgmesaj,sizeof(mgmesaj),"[Minigun]Haritanin gizli bir yerinde minigun olusturuldu !");
	SendClientMessageToAll(Renk_Sari, mgmesaj);
}

Tom_Rutbe(playerid)
{
	new rutbe[24];
	if(stat[playerid][Tomkazanma] < 10) rutbe = "Yeni";
	else if(stat[playerid][Tomkazanma] < 25) rutbe = "Acemi";
	else if(stat[playerid][Tomkazanma] < 50) rutbe = "Gangster";
	else if(stat[playerid][Tomkazanma] < 100) rutbe = "Mafya Babasi";
	return rutbe;
}

public TOM_CeteSavasi_Pickupolustur()
{
	new r = random(sizeof(TOM_CeteSavasi_Pickup_Spawn));
	TOM_CeteSavasi_Pickup = CreatePickup(2912, 1, TOM_CeteSavasi_Pickup_Spawn[r][0], TOM_CeteSavasi_Pickup_Spawn[r][1], TOM_CeteSavasi_Pickup_Spawn[r][2], TOM_CeteSavasi);
}

public TOM_LSSavasi_Pickupolustur()
{
	new r = random(sizeof(TOM_LSSavasi_Pickup_Spawn));
	TOM_LSSavasi_Pickup = CreatePickup(2912, 1, TOM_LSSavasi_Pickup_Spawn[r][0], TOM_LSSavasi_Pickup_Spawn[r][1], TOM_LSSavasi_Pickup_Spawn[r][2], TOM_LSSavasi);
}

public TOM_Lunapark_Pickupolustur()
{
	new r = random(sizeof(TOM_Lunapark_Pickup_Spawn));
	TOM_Lunapark_Pickup = CreatePickup(2912, 1, TOM_Lunapark_Pickup_Spawn[r][0], TOM_Lunapark_Pickup_Spawn[r][1], TOM_Lunapark_Pickup_Spawn[r][2], TOM_Lunapark);
}

public TOM_Gemi_Pickupolustur()
{
	new r = random(sizeof(TOM_Gemi_Pickup_Spawn));
	TOM_Gemi_Pickup = CreatePickup(2900, 1, TOM_Gemi_Pickup_Spawn[r][0], TOM_Gemi_Pickup_Spawn[r][1], TOM_Gemi_Pickup_Spawn[r][2], TOM_Gemi);
}

public FCNPC_OnTakeDamage(npcid, issuerid, Float:amount, weaponid, bodypart)
{
	FCNPC_AimAtPlayer(npcid, issuerid, true, -1, true);
	if(bodypart == 9)
	{
		FCNPC_GiveHealth(npcid, -100.0);
	}
	else if(bodypart == 3)
	{
		FCNPC_GiveHealth(npcid, -30.0);
	}
	else
	{
		FCNPC_GiveHealth(npcid, -15.0);
	}
}

public FCNPC_OnDeath(npcid, killerid, reason)
{
	SetTimerEx("FCNPC_Respawn", 60000, false, "i", npcid);
}




denizinpartibase()
{
	CreateObject(7636, 1767.59180, -1899.42297, 12.55582,   0.00000, 0.00000, 0.00000);
	CreateObject(7636, 1769.71069, -1895.90076, 12.54316,   0.00000, 0.00000, 0.00000);
	CreateObject(1342, 1782.90674, -1891.23755, 13.39791,   0.00000, 0.00000, -20.64009);
	CreateObject(1340, 1782.75671, -1893.79236, 13.47678,   0.00000, 0.00000, 0.00000);
	CreateObject(1458, 1786.35938, -1885.90234, 12.63093,   0.00000, 0.00000, -143.64003);
	CreateObject(1281, 1808.75745, -1902.42029, 13.33128,   0.00000, 0.00000, 0.00000);
	CreateObject(1281, 1808.78137, -1907.29065, 13.33128,   0.00000, 0.00000, 0.00000);
	CreateObject(1281, 1808.88354, -1911.83618, 13.33128,   0.00000, 0.00000, 0.00000);
	CreateObject(1281, 1808.72974, -1915.99536, 13.33128,   0.00000, 0.00000, 0.00000);
	CreateObject(1281, 1808.48596, -1920.05603, 13.33128,   0.00000, 0.00000, 0.00000);
	CreateObject(2799, 1790.59705, -1883.29712, 13.06404,   0.00000, 0.00000, -60.06002);
	CreateObject(2799, 1794.16357, -1883.29016, 13.06404,   0.00000, 0.00000, -60.06002);
	CreateObject(2799, 1797.93079, -1883.21655, 13.06404,   0.00000, 0.00000, -60.06002);
	CreateObject(2799, 1801.83057, -1883.11768, 13.06404,   0.00000, 0.00000, -60.06002);
	CreateObject(1341, 1782.43066, -1895.79260, 13.35362,   0.00000, 0.00000, 4.73998);
	CreateObject(1331, 1770.93469, -1909.30920, 13.37616,   0.00000, 0.00000, 89.16001);
	CreateObject(1331, 1770.88342, -1911.44873, 13.37616,   0.00000, 0.00000, 89.16001);
	CreateObject(1331, 1770.93005, -1913.61035, 13.37616,   0.00000, 0.00000, 89.16001);
	CreateObject(2071, 1783.24707, -1887.02600, 13.79573,   0.00000, 0.00000, 0.00000);
	CreateObject(2071, 1783.24707, -1887.02600, 15.68022,   0.00000, 0.00000, 0.54000);
	CreateObject(1848, 1781.21497, -1920.20642, 12.41226,   0.00000, 0.00000, 154.19994);
	CreateObject(1848, 1777.60254, -1916.74646, 12.41226,   0.00000, 0.00000, 117.83982);
	CreateObject(1848, 1786.09290, -1920.66772, 12.41226,   0.00000, 0.00000, 194.03992);
	CreateObject(970, 1790.54175, -1920.38867, 12.90572,   0.00000, 0.00000, -4.92000);
	CreateObject(970, 1774.33142, -1927.89722, 13.02572,   0.00000, 0.00000, -90.36002);
	CreateObject(970, 1794.65137, -1920.75537, 12.90572,   0.00000, 0.00000, -4.92000);
	CreateObject(970, 1774.28174, -1932.00085, 13.02572,   0.00000, 0.00000, -90.36002);
	CreateObject(970, 1774.25684, -1933.39258, 13.02572,   0.00000, 0.00000, -90.36002);
	CreateObject(970, 1776.23401, -1935.63000, 13.02572,   0.00000, 0.00000, -1.80004);
	CreateObject(970, 1784.40430, -1935.65894, 13.02572,   0.00000, 0.00000, 0.65996);
	CreateObject(970, 1780.28540, -1935.68774, 13.02572,   0.00000, 0.00000, 0.65996);
	CreateObject(970, 1788.50940, -1935.62512, 13.02572,   0.00000, 0.00000, 0.65996);
	CreateObject(970, 1792.63074, -1935.59631, 13.02572,   0.00000, 0.00000, 0.65996);
	CreateObject(970, 1796.63831, -1935.54236, 13.02572,   0.00000, 0.00000, 0.65996);
	CreateObject(970, 1796.63831, -1935.54236, 13.02572,   0.00000, 0.00000, 0.65996);
	CreateObject(970, 1800.74023, -1935.43115, 13.02572,   0.00000, 0.00000, 0.65996);
	CreateObject(970, 1804.85962, -1935.43494, 13.02572,   0.00000, 0.00000, 0.65996);
	CreateObject(1728, 1768.62146, -1906.34131, 12.54754,   0.00000, 0.00000, 179.39952);
	CreateObject(1728, 1765.46069, -1906.33057, 12.54754,   0.00000, 0.00000, 179.39952);
	CreateObject(1728, 1762.37903, -1906.29053, 12.54754,   0.00000, 0.00000, 179.39952);
	CreateObject(1728, 1759.21863, -1906.28638, 12.54754,   0.00000, 0.00000, 179.39952);
	CreateObject(2315, 1767.25391, -1904.12280, 12.57272,   0.00000, 0.00000, 0.00000);
	CreateObject(2315, 1764.90894, -1904.12280, 12.57270,   0.01600, 0.00000, 0.00000);
	CreateObject(2315, 1762.56384, -1904.12280, 12.57270,   0.01600, 0.00000, 0.00000);
	CreateObject(2315, 1760.19873, -1904.12244, 12.57270,   0.01600, 0.00000, 0.00000);
	CreateObject(2315, 1757.87134, -1904.10791, 12.57270,   0.01600, 0.00000, 0.00000);
	CreateObject(2219, 1767.61536, -1904.33325, 13.11350,   -24.12000, 22.56001, 0.00000);
	CreateObject(2219, 1768.51257, -1904.21924, 13.11350,   -24.12000, 22.56001, -69.90002);
	CreateObject(1546, 1766.96985, -1904.01624, 13.15040,   0.00000, 0.00000, 0.00000);
	CreateObject(2214, 1765.85632, -1904.36230, 13.12047,   -24.96001, 22.25998, 0.00000);
	CreateObject(2453, 1757.92810, -1904.23010, 13.39843,   0.00000, 0.00000, 0.00000);
	CreateObject(1582, 1762.01160, -1904.18921, 13.04682,   0.00000, 0.00000, 26.82000);
	CreateObject(1582, 1761.55896, -1904.07031, 13.09116,   -1.86000, -6.48000, -38.75999);
	CreateObject(1825, 1786.19104, -1889.33643, 12.38733,   0.00000, 0.00000, -1.14000);
}

Ev_Map()
{
	CreateObject(19360, 2486.51440, -1642.63098, 13.11079,   0.00000, 91.00000, 0.28625);
	CreateObject(19453, 2485.02295, -1636.69751, 14.74707,   0.00000, 0.00000, 0.30301);
	CreateObject(19360, 2489.38159, -1642.63599, 13.11080,   0.00000, 91.00000, 0.69850);
	CreateObject(19453, 2491.08325, -1639.53430, 14.74606,   0.00000, 0.00000, 0.00000);
	CreateObject(19453, 2486.29395, -1634.98486, 14.69645,   0.00000, 0.00000, 273.14862);
	CreateObject(19360, 2486.74536, -1639.38879, 13.11080,   0.00000, 91.00000, 0.00000);
	CreateObject(19360, 2489.27954, -1639.37976, 13.11080,   0.00000, 91.00000, 0.00000);
	CreateObject(19360, 2486.81152, -1636.56372, 13.11080,   0.00000, 91.00000, 359.78619);
	CreateObject(19360, 2489.42896, -1636.39697, 13.11080,   0.00000, 91.00000, 4.40028);
	CreateObject(19356, 2489.43677, -1636.42212, 16.49520,   0.00000, 91.00000, 2.83319);
	CreateObject(19356, 2489.53564, -1639.54773, 16.57420,   0.00000, 91.00000, 1.75305);
	CreateObject(19356, 2486.61646, -1639.68311, 16.56860,   0.00000, 91.00000, 1.57126);
	CreateObject(19356, 2486.56885, -1636.47864, 16.50470,   0.00000, 91.00000, 2.47158);
	CreateObject(19356, 2486.82227, -1642.73608, 16.47080,   0.00000, 91.00000, 0.63733);
	CreateObject(19356, 2489.55322, -1642.81738, 16.55110,   0.00000, 91.00000, 359.91788);
	CreateObject(19453, 2481.48584, -1640.11902, 14.75940,   0.00000, 0.00000, 0.00000);
	CreateObject(19390, 2485.03540, -1642.90869, 14.80680,   0.00000, 0.00000, 0.00000);
	CreateObject(19360, 2483.15845, -1642.85571, 13.11080,   0.00000, 91.00000, 0.00000);
	CreateObject(19360, 2483.23486, -1639.76062, 13.11080,   0.00000, 91.00000, 0.00000);
	CreateObject(19360, 2483.28491, -1636.89807, 13.11080,   0.00000, 91.00000, 1.31975);
	CreateObject(19356, 2483.31567, -1642.86670, 16.47190,   0.00000, 91.00000, 0.00000);
	CreateObject(19356, 2483.28906, -1639.68555, 16.45330,   0.00000, 91.00000, 0.81311);
	CreateObject(19356, 2483.30688, -1636.74011, 16.43960,   0.00000, 91.00000, 2.50623);
	CreateObject(19360, 2483.34375, -1644.13977, 14.74549,   0.00000, 0.00000, 88.22052);
	CreateObject(19360, 2481.63501, -1645.57788, 14.81365,   0.00000, 0.00000, 359.82376);
	CreateObject(19356, 2489.46094, -1640.89673, 16.62117,   0.00000, 91.00000, 0.00000);
	CreateObject(2114, 2490.72241, -1635.13220, 13.28932,   0.00000, 0.00000, 0.00000);
	CreateObject(19814, 2485.13696, -1640.09351, 13.74160,   0.00000, 0.00000, 96.49113);
	CreateObject(19624, 2489.88330, -1644.48950, 13.47969,   0.00000, 0.00000, 0.00000);
	CreateObject(1809, 2490.55444, -1640.57007, 13.23310,   0.00000, 0.00000, 270.14078);
	CreateObject(2317, 2490.55884, -1640.58203, 14.02620,   0.00000, 0.00000, 273.00000);
	CreateObject(1718, 2489.89233, -1639.96667, 13.34110,   0.00000, 0.00000, 302.00000);
	CreateObject(1729, 2488.83252, -1638.85254, 13.20551,   0.00000, 0.00000, 42.68287);
	CreateObject(1729, 2488.32568, -1641.07275, 13.20550,   0.00000, 0.00000, 114.47720);
	CreateObject(2286, 2487.59619, -1635.06836, 14.90956,   0.00000, 0.00000, 2.42392);
	CreateObject(2289, 2482.68140, -1643.95129, 15.44700,   0.00000, 0.00000, 173.75020);
	CreateObject(2609, 2485.51465, -1637.30139, 14.01164,   0.00000, 0.00000, 91.00000);
	CreateObject(19930, 2489.32617, -1635.40100, 13.16346,   0.00000, 0.00000, 273.11673);
	CreateObject(2161, 2482.23120, -1635.62085, 15.02108,   0.00000, 0.00000, 0.10000);
	CreateObject(2256, 2490.70483, -1637.32593, 15.24310,   0.00000, 0.00000, -91.00000);
	CreateObject(2872, 2484.38550, -1635.70605, 13.16933,   0.00000, 0.00000, 0.00000);
	CreateObject(2768, 2490.37085, -1641.28979, 13.28874,   0.00000, 0.00000, 0.00000);
	CreateObject(19167, 2481.64478, -1641.05603, 14.97860,   -270.00000, 84.00000, 2.36825);
	CreateObject(1310, 2485.11987, -1635.36536, 13.31231,   0.00000, 0.00000, 81.19391);
	CreateObject(19563, 2488.95508, -1635.02356, 14.08564,   0.00000, 0.00000, 1.34289);
	CreateObject(19893, 2489.57935, -1635.45862, 14.08680,   0.00000, 0.00000, 0.00000);
}
