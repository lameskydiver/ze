::g_warmup_it <- 0;
g_warmup_origin <- Vector(0,3072,512)
g_warmup_end <- false;
g_warmup_chat <- [  " \x02 oh no!!!!! the map is broken!!",
                    " \x02 it's funny since the mapper called it final version but it's broken!!!",
                    " \x02 stupid admins adding in broken maps LOL",
                    " \x02 i haven't even played a single minute of this map but it must be shit map!!!",
                    " \x02 shit map rtv!!! TYPE RTV IN CHAT PLS!!",
                    " \x04[NU]\x05 THE BEST ZE PLAYER ghostfap.com\x01 has nominated\x04 ",
                    " \x02 PLS VOTE FOR MY NOM IN MAP VOTE IT'S BEST MAP",
                    " \x02 rtv rtv rtv rtv rtv rtv rtv rtv rtv rtv rtv rtv"  ];
g_warmup_maps <- [  "ze_ATIX_panic_b3t_p3",
                    "ze_best_korea_v1",
                    "ze_collective_v1_9",
                    "ze_endemic_v1_3",
                    "ze_mist_q3",
                    "ze_Outlast_v2_cm1_fix1",
                    "ze_rush_B_v2_2",
                    "ze_red_planet_escape_v2_c34_final_fix_csgo_e_fyh",
                    "ze_solgryn_v2",
                    "ze_squid_game_v1"  ];

//intro / warm-up
function warmUp()
{
    self.PrecacheScriptSound("music/chinny/sans.mp3");
    EntFire("chinny_intro_clip","Kill","",0,null);
    EntFireByHandle(self, "RunScriptCode", "warmUpEnd()", 25, null, null);
    fuckItUp();
}

function warmUpChat(it)
{
    if(!g_warmup_end)
    {
        if(it==g_warmup_chat.len()-3)
            ScriptPrintMessageChatAll(g_warmup_chat[it]+g_warmup_maps[RandomInt(0,g_warmup_maps.len()-1)]+"\x01 [1 vote]");
        else
            ScriptPrintMessageChatAll(g_warmup_chat[it]);
        if(it<g_warmup_chat.len()-1)
            EntFireByHandle(self, "RunScriptCode", "warmUpChat("+(it+1)+")", 2, null, null);
        else
            EntFireByHandle(self, "RunScriptCode", "warmUpChat("+it+")", 2, null, null);
    }
}

function fuckItUp()
{
    if(!g_warmup_end)
    {
        if(g_warmup_it == 0)
            soundPlay(g_warmup_origin,100000,"music/chinny/sans.mp3",10,100,60,0);
        else
            soundPlay(g_warmup_origin,100000,"music/chinny/sans.mp3",10,RandomInt(80,120),60,0);
        EntFireByHandle(self, "RunScriptCode", "warmUpChat(0)", 0, null, null);
        g_warmup_it++;
        EntFireByHandle(self, "RunScriptCode", "fuckItUp()", RandomInt(4,8), null, null);
    }
}

function warmUpEnd()
{
    g_warmup_end = true;
    perm.ValidateScriptScope();
    perm.GetScriptScope().level <- 1;
    ScriptPrintMessageChatAll(" \x02 okay fine i'll start up the map now");
    EntFire("chinny_intro*","Kill","",0.5,null);
    EntFire("chinny_intro_mortal","Disable","",0,null);
    EntFire("chinny_sfx*","Volume","0",0,null);
    EntFire("nuke","Enable","",3,null);
}