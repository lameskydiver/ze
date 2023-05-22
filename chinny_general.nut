/*  script for ze_aaa_ohio, made by lameskydiver/chinny
 *  for general use on all my stages
 *  First test version created: March 2023
 *
 *  If you spot errors / have questions contact me via:
 *  discord:    lameskydiver/chinny#5724
 *  steam:      https://steamcommunity.com/id/lameskydiver
 */

// --------------- //
// +   General   + //
// --------------- //

//returns a number truncated to specified decimal places
//note; order of 0 returns an integer, negative order defaults to 0!
function sigFig(val, order)
{
    if(order<0) order = 0;
    return ((val*pow(10,order)).tointeger()).tofloat()/pow(10,order);
}

//returns a random number from given min max values and decimal places
//note; order of 0 returns an integer, negative order defaults to 0!
function randVal(min, max, order)
{
    if(order<0) order = 0;
    return sigFig(RandomFloat(min,max),order);
}

//returns float value rounded up to designated decimal places
//note; order of 0 returns an integer, negative order defaults to 0!
function roundFloat(val, order)
{
    if(order<0) order = 0;
    val = val*pow(10,order);
    if(val == 0){}
    else if(val>0)
    {
        if(ceil(val)-val<=0.5 && ceil(val)-val>0)
            val += 1;
    }
    else if(val < 0)
    {
        if(val-floor(val)<=0.5 && val-floor(val)>0)
            val -= 1;
    }
    val = val/pow(10,order);
    val = sigFig(val,order);
    return val;
}

//returns bool whether an input element already exists in a given list
function detectElement(ele, list)
{
    foreach(e in list)
    {
        if(e==ele)
            return true;
    }
    return false;
}

//Chooses non-repeating indices for a round of minigame; used for spawning server rack and colours
//Inputs: minimum_index - minimum index to start from
//        maximum_indices - maximum amount of indices needed
//        maximum_options - maximum amount of options available
function indexChooser(minimum_index,maximum_indices,maximum_options)
{
    local indices = [];
    while(indices.len()<maximum_indices)
    {//only chooses the max stated by maximum_indices
        local current_index = RandomInt(minimum_index,maximum_options-1);
        if(indices.len() == 0)  indices.append(current_index);//add the first iteration
        else
        {
            local duplicates = false;
            foreach(i in indices)
            {//iterate through the index array
                if(i==current_index)
                {//detect if there are duplicates
                    duplicates = true;
                    break;
                }
            }
            //add if no duplication was detected
            if(duplicates == true) continue;
            else    indices.append(current_index);
        }
    }
    return indices;
}

// ------------- //
// +   Stage   + //
// ------------- //

::g_extreme <- false;
::g_level <- 0;
perm <- Entities.FindByName(null, "perm");
::g_stages <- [0,1];
g_end_origin <- Vector(0,-0,4096);
g_start_chat <- [   " \x02 ur playing ze_aaa_ohio_final_FINAL_FiNaL made by me (lameskydiver/chinny)",
                    " \x02 thanks to luff and soft serve for feeding my mapping autism",    ];
g_normal_end_chat <- [  " \x02 map's over, guess you win",
                        " \x02 or is it?"   ];
g_extreme_end_chat <- [ " \x02 ok yeah that's the map",
                        " \x02 hope you enjoyed",
                        " \x02 ...?",
                        " \x02 OH NO INVISIBLE LASERS",
                        " \x02 GOOD FUCKING LUCK!!!!!!!"   ];
//0 - toledo bridge
//1 - cincinnati mist

//check current stage
function checkStage()
{
    perm.ValidateScriptScope();
    if(!("level" in perm.GetScriptScope())||perm.GetScriptScope().level==0)
    {
        perm.GetScriptScope().level <- ::g_level;
        EntFireByHandle(self, "RunScriptCode", "warmUp()", 5, null, null);
    }
    else
    {
        introChat(0);
        ::g_level = perm.GetScriptScope().level;
        if(::g_level == 2)
            ::g_extreme = true;
        EntFireByHandle(self, "RunScriptCode", "chooseStage()", 10, null, null);
    }
}

function chooseStage()
{
    if(::g_stages.len()>0)
    {
        ScriptPrintMessageChatAll(" \x02 choosing next stage...");
        local next_stage = 0;
        if("forcedstage" in perm.GetScriptScope())
        {
            if(perm.GetScriptScope().forcedstage!=-1)
            {
                next_stage = perm.GetScriptScope().forcedstage;
                perm.GetScriptScope().forcedstage <- -1;
                foreach(it,stage in ::g_stages) if(stage==next_stage)
                {
                    ::g_stages.remove(it);
                    break;
                }
            }
            else
            {
                local it = RandomInt(0,::g_stages.len()-1);
                next_stage = ::g_stages[it];
                ::g_stages.remove(it);
            }
        }
        else
        {
            local it = RandomInt(0,::g_stages.len()-1);
            next_stage = ::g_stages[it];
            ::g_stages.remove(it);
        }
        switch(next_stage)
        {
            case 0:
            {
                EntFire("fog","TurnOn","",0,null);
                if(!::g_extreme)
                {
                    EntFire("chinny_relay_tl_normal","Trigger","",2,null);
                    EntFire("spawn_tp_ct","AddOutput","target chiny_dest_west_ct",0,null);
                    EntFire("spawn_tp_t","AddOutput","target chiny_dest_west_t",0,null);
                }
                else
                {
                    EntFire("chinny_relay_tl_extreme","Trigger","",2,null);
                    EntFire("spawn_tp_ct","AddOutput","target chiny_dest_east_ct",0,null);
                    EntFire("spawn_tp_t","AddOutput","target chiny_dest_east_t",0,null);
                }
                break;
            }
            case 1:
            {
                EntFire("fog","TurnOff","",0,null);
                if(!::g_extreme)
                    EntFire("chinny_relay_cn_normal","Trigger","",2,null);
                else
                    EntFire("chinny_relay_cn_extreme","Trigger","",2,null);
                EntFire("spawn_tp_ct","AddOutput","target chiny_dest_cn_entry",0,null);
                EntFire("spawn_tp_t","AddOutput","target chiny_dest_cn_entry",0,null);
                break;
            }
        }
    }
}

function introChat(it)
{
    ScriptPrintMessageChatAll(g_start_chat[it]);
    if(!it)
        EntFireByHandle(self, "RunScriptCode", "introChat("+(it+1)+")", 4, null, null);
}

function endStage()
{
    EntFire("spawn_tp_t","Disable","",0,null);
    EntFire("spawn_tp_ct","Disable","",0,null);
    if(::g_stages.len()>0)
        EntFireByHandle(self, "RunScriptCode", "chooseStage()", 10, null, null);
    else
        endMap();
}

function endMap()
{
    if(!g_extreme)
    {
        local tp = Entities.FindByName(null,"spawn_tp_ct");
        tp.__KeyValueFromString("target","dest_end_ct");
        EntFireByHandle(tp, "Enable", "", 0, null, null);
        endMapNormalChat(0);
        EntFire("nuke","Enable","",5,null);
        perm.GetScriptScope().level <- 2;
    }
    else
    {
        self.PrecacheScriptSound("music/chinny/pendulum_distress_signal.mp3");
        EntFire("spawn_tp_ct","AddOutput","target dest_end_ct",0,null);
        EntFire("spawn_tp_t","AddOutput","target dest_end_t",0,null);
        EntFire("spawn_tp_ct","Enable","",0,null);
        EntFire("spawn_tp_t","Enable","",0,null);
        endMapExtremeChat(0);
        EntFireByHandle(self, "RunScriptCode", "endMapExtreme()", 3, null, null);
    }
}

function endMapExtreme()
{
    musicPlay("music/chinny/pendulum_distress_signal",::g_music_on);
    EntFire("map_end_timer","Enable","",7,null);
}

function endMapNormalChat(it)
{
    ScriptPrintMessageChatAll(g_normal_end_chat[it]);
    if(!it)
        EntFireByHandle(self, "RunScriptCode", "endMapNormalChat("+(it+1)+")", 4, null, null);
}

function endMapExtremeChat(it)
{
    ScriptPrintMessageChatAll(g_extreme_end_chat[it]);
    if(it<2)
        EntFireByHandle(self, "RunScriptCode", "endMapExtremeChat("+(it+1)+")", 3, null, null);
    else if(it==2)
        EntFireByHandle(self, "RunScriptCode", "endMapExtremeChat("+(it+1)+")", 2, null, null);
    else if(it<4)
    {
        EntFireByHandle(self, "RunScriptCode", "endMapExtremeChat("+(it+1)+")", 1, null, null);
        EntFireByHandle(self, "RunScriptCode", "endLasers(0)", 3, null, null);
    }
}

function endDetectCrouchOrJump()
{
    local pos = activator.EyePosition();
    if((pos.z<g_end_origin.z+60) || (pos.z>g_end_origin.z+70))
        EntFireByHandle(activator, "SetHealth", "0", 0, null, null);
    //added in finalx3 to prevent going afk cheese
    activator.ValidateScriptScope();
    if("prevpos" in activator.GetScriptScope()){
        local prev_pos = activator.GetScriptScope().prevpos;
        if(prev_pos.x==pos.x && prev_pos.y==pos.y)
            EntFireByHandle(activator, "SetHealth", "0", 0, null, null);
    }
    activator.GetScriptScope().prevpos <- pos;
}

function endLasers(it)
{
    if(it<5)
    {
        foreach(_ in array(3))
            soundPlay(Vector(g_end_origin.x,g_end_origin.y,g_end_origin.z+64),100000,"sfx/chinny/blade_out.mp3",10,100,3,0);
        EntFireByHandle(self, "RunScriptCode", "endLasers("+(it+1)+")", randVal(1,2,2), null, null);
    }
    else if(it>4 && it<8)
    {
        if(it==5)
        {
            ScriptPrintMessageChatAll(" \x02 wow!!! you are truly skilled!!!!!");
            EntFire("map_end_timer","Kill","",0,null);
            EntFire("map_end_multiple","Kill","",0,null);
        }
        if(it==6)
            ScriptPrintMessageChatAll(" \x02 or you offlined the map you disgusting fuck");
        if(it==7)
        {
            ScriptPrintMessageChatAll(" \x02 whatever humans win yay");
            EntFire("nuke","Enable","",2,null);
            EntFire("map_end_nuke","Enable","",2,null);
        }
        else
            EntFireByHandle(self, "RunScriptCode", "endLasers("+(it+1)+")", 2, null, null);
    }
}

// ---------------- //
// +   Entities   + //
// ---------------- //

// +   Sound   + //

//variables
::g_snd_idx <- 0;
g_snd_idx_max <- 999;
g_snd_template <- Entities.FindByName(null, "chinny_template_sfx");
g_snd_maker <- Entities.FindByName(null, "chinny_maker_sfx");
g_snd_list <- [ "sfx/chinny/pendulum_the_tempest.mp3",//[0]
                "sfx/chinny/mako1.mp3",
                "sfx/chinny/mako2.mp3",
                "sfx/chinny/mako3.mp3",
                "sfx/chinny/mako4.mp3",
                "sfx/chinny/intro_vignette.mp3",//[5]
                "sfx/chinny/metal_pipe_sfx.mp3"];//for calling the function via hammer (cannot have ")

//play sound with given kv
function soundPlay(pos,radius,filepath,vol,pitch,duration,delay)
{
    g_snd_template.ValidateScriptScope();
    g_snd_template.GetScriptScope().duration <- duration;
    g_snd_template.GetScriptScope().delay <- delay;
    if(useList(filepath))
        filepath = g_snd_list[filepath];//note; the input filepath should be an integer, working as an index to g_snd_list!
    g_snd_template.GetScriptScope().keyvalues <- {
        targetname = "chinny_sfx"+::g_snd_idx,
        radius = radius,
        message = filepath,
        health = vol,
        pitch = pitch
        };
    g_snd_template.GetScriptScope().PreSpawnInstance <- function(entityClass,entityName)    return keyvalues;
    g_snd_template.GetScriptScope().PostSpawn <- function(entities)
    {
        foreach(e in entities)
        {
            EntFireByHandle(e,"PlaySound","",delay,null,null);
            EntFireByHandle(e,"Kill","",duration+delay,null,null);
        }
    }
    g_snd_maker.SpawnEntityAtLocation(pos, Vector(0,0,0));
    ::g_snd_idx++;
    if(::g_snd_idx>g_snd_idx_max)
        ::g_snd_idx = 0;
}

//determine if soundPlay should refer from g_snd_list instead
//note; this means any string starting with a number will be indexed to the list
function useList(input)
{
    input = input.tostring().slice(0,1);
    for(local num=0;num<10;num++)
    {
        if(input==num.tostring())
            return true;
    }
    return false;
}

// +   Particles   + //

//variables
::g_ptc_idx <- 0;
g_ptc_idx_max <- 999;
g_ptc_template <- Entities.FindByName(null, "chinny_template_particle");
g_ptc_maker <- Entities.FindByName(null, "chinny_maker_particle");

//spawn particle
function particleSpawn(pos,rot,particle_name,duration,parent_name)
{
    g_ptc_template.ValidateScriptScope();
    g_ptc_template.GetScriptScope().duration <- duration;
    g_ptc_template.GetScriptScope().keyvalues <- {
        targetname = "chinny_particle"+::g_ptc_idx,
        effect_name = particle_name,
        parentname = parent_name
        };
    g_ptc_template.GetScriptScope().PreSpawnInstance <- function(entityClass,entityName)    return keyvalues;
    g_ptc_template.GetScriptScope().PostSpawn <- function(entities)
    {
        foreach(e in entities)
        {
            EntFireByHandle(e,"Start","",0,null,null);
            if(e.GetMoveParent()==null)
                EntFireByHandle(e,"Kill","",duration,null,null);
        }
    }
    g_ptc_maker.SpawnEntityAtLocation(pos, rot);
    ::g_ptc_idx++;
    if(::g_ptc_idx>g_ptc_idx_max)
        ::g_ptc_idx = 0;
}

// +   Movelinear   + //

//variables
::g_lin_idx <- 0;
g_lin_idx_max <- 999;
g_lin_template <- Entities.FindByName(null, "chinny_template_move");
g_lin_maker <- Entities.FindByName(null, "chinny_maker_move");

//spawn func_movelinear
function moveSpawn(pos,dir,dist,speed,start_pos,dmg,start_sound,end_sound,spawnflag,wait)
{
    g_lin_template.ValidateScriptScope();
    g_lin_template.GetScriptScope().delay <- wait;
    g_lin_template.GetScriptScope().keyvalues <- {
        targetname = "chinny_move"+::g_lin_idx,
        movedir = dir,
        movedistance = dist,
        speed = speed,
        startposition = start_pos,
        blockdamage = dmg,
        startsound = start_sound,
        end_sound = end_sound,
        spawnflags = spawnflag
        };
    g_lin_template.GetScriptScope().PreSpawnInstance <- function(entityClass,entityName)    return keyvalues;
    g_lin_template.GetScriptScope().PostSpawn <- function(entities)
    {
        foreach(e in entities)
            EntFireByHandle(e,"Open","",delay,null,null);
    }
    g_lin_maker.SpawnEntityAtLocation(pos, Vector(0,0,0));
    ::g_lin_idx++;
    if(::g_lin_idx>g_lin_idx_max)
        ::g_lin_idx = 0;
}

// +   Players   + //

g_max_hp <- 200;

//enact hurt to players
function changeHealth(amount, filter)
{
    if((filter && activator.GetTeam()!=filter) || !activator || !activator.IsValid())
        return;
    if((activator.GetHealth()+amount)>0)
    {
        if((activator.GetHealth()+amount)>g_max_hp)
            activator.SetHealth(g_max_hp);
        else
            activator.SetHealth(activator.GetHealth()+amount);
    }
    else
        EntFireByHandle(activator, "SetHealth", "0", 0, null, null);
}

// +   Clean-up   + //

function cleanUp()
{
    EntFire("chinny_move*","Kill","",0,null);
    EntFire("chinny_particle*","Kill","",0,null);
    EntFire("chinny_sfx*","Kill","",0,null);
    EntFire("chinny_tl*","Kill","",0,null);
    EntFire("chinny_cn*","Kill","",0,null);
}

// ------------------ //
// +   Admin Room   + //
// ------------------ //

function adminSkipIntro()
{
    if(perm.GetScriptScope().level==0)
    {
        ScriptPrintMessageChatAll(" \x02 fun at parties aren't you");
        warmUpEnd();
    }
}

function adminSetNormal()
{
    if(g_extreme)
    {
        ScriptPrintMessageChatAll(" \x02 normal mode set");
        perm.ValidateScriptScope();
        perm.GetScriptScope().level <- 1;
    }
    else
        ScriptPrintMessageChatAll(" \x02 normal mode is already set dumbass");
}

function adminSetExtreme()
{
    if(!g_extreme)
    {
        ScriptPrintMessageChatAll(" \x02 extreme mode set");
        perm.ValidateScriptScope();
        perm.GetScriptScope().level <- 2;
    }
    else
        ScriptPrintMessageChatAll(" \x02 extreme mode is already set dumbass");
}

function adminSetToledo()
{
    ScriptPrintMessageChatAll(" \x02 bridge stage set");
    perm.ValidateScriptScope();
    //perm.GetScriptScope().level <- 1;
    perm.GetScriptScope().forcedstage <- 0;
}

function adminSetCincinnati()
{
    ScriptPrintMessageChatAll(" \x02 mist stage set");
    perm.ValidateScriptScope();
    //perm.GetScriptScope().level <- 1;
    perm.GetScriptScope().forcedstage <- 1;
}

g_slay_chat <- [    " \x02 why am i doing your work for you? just type !slay @all maybe",
                    "!slay @all",
                    " \x02 like that, you're welcome"    ];

function adminSlay()
{
    adminSlayChat(0);
    EntFire("nuke","Enable","",1,null);
}

function adminSlayChat(it)
{
    ScriptPrintMessageChatAll(g_slay_chat[it]);
    if(it+1<g_slay_chat.len())
        EntFireByHandle(self, "RunScriptCode", "adminSlayChat("+(it+1)+")", 1, null, null);
}