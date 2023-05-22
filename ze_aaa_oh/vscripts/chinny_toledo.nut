/*  script for ze_aaa_ohio, made by lameskydiver/chinny
 *  Mostly written by me, but yoinked shit from luff's ze_collective manager.nut as well for toledo stage
 *  First test version created: March 2023
 *
 *  If you spot errors / have questions contact me via:
 *  discord:    lameskydiver/chinny#5724
 *  steam:      https://steamcommunity.com/id/lameskydiver
 */

// ---------------- //
// +   Entities   + //
// ---------------- //

// +   Chat   + //
g_fell_from_bridge_chat <-  [   "hey man, people worked hard to close that gap...",
                                "according to the local traffic law article 16.420.69,\n"
                                    +"you have committed a serious crime\n(i.e. falling off a bridge without permission)\n"
                                    +"you are hereby expected to be present at your local court\n"
                                    +"to hear for your case\n"
                                    +"sincerely, the city with a bridge that has gaps",
                                "man only if there was a traffic sign\n"
                                    +"indicating a gap in the bridge, huh?",
                                "you got got, i think?",
                                "what? massive gaps on a bridge is not normal? get out of here",
                                "hey look! it says 'gullible' at the bottom of the bridge!",
                                "offline to dodge lasers but you can't even dodge a massive gap...",
                                "oh! oh! oh! oh! oh! oh! oh! oh! oh! \n"
                                    +"oh! oh! oh! oh! oh! oh! oh! oh! oh!",
                                "how to cross a road:\n"
                                    +"step 1: look both ways before crossing the road\n"
                                    +"step 2: raise your hand high\n"
                                    +"step 3: see all vehicles have stopped\n"
                                    +"step 4: cross the road safely",
                                "so uh, you come here often?",
                                "jumping off from a bridge is illegal by law",
                                "hey! it's okay! we all make mistakes sometime!",
                                "this is the moment where you spam rtv in chat!",
                                "i'm the biggest bird i'm the biggest bird\n"
                                    +"i'm the biggest bird i'm the biggest bird\n"
                                    +"i'm the biggest bird i'm the biggest bird\n"
                                    +"i'm the biggest bird i'm the biggest bird",
                                "be my mommy",
                                "if you read this you're uh... happy",
                                "i pledge to do my part for the pledge to do my part\n"
                                    +"for the pledge to do my part for the pledge\n"
                                    +"to do my part for the pledge to do my part\n"
                                    +"for the pledge to do my part for the pledge",
                                "this is a crucial part of the map lore that will never be explained",
                                "cool! you died!",
                                "ok don't tell the admins but i added a vscript backdoor to this map...",
                                "turns out jumping off from a bridge is lethal!"
                                "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not.\n"
                                    +"It's not a story the Jedi would tell you. It's a Sith legend.\n"
                                    +"Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise\n"
                                    +"he could use the Force to influence the midichlorians to create life…\n"
                                    +"He had such a knowledge of the dark side that\n"
                                    +"he could even keep the ones he cared about from dying.\n"
                                    +"The dark side of the Force is a pathway\n"
                                    +"to many abilities some consider to be unnatural.\n"
                                    +"He became so powerful…\nthe only thing he was",
                                "I have a dream about a ze map with a boss\nin a form of anime girl with big ass\n"
                                    +"And she will use attack similar to\nball-santa attacks on santassination,\n"
                                    +"so basically she will be jumping\nand crushing humans with her ass\n"
                                    +"I want it because I can die every boss fight without regret\n"
                                    +"and feeling like worthless noob",
                                "THANK YOU VALVE FOR MAKING CSGO FREE\n"
                                    +"AND THEREBY FUCKING BREAKING THE PIECE OF SHIT\n"
                                    +"GIVE ME BACK THE MONEY I PAID\n"
                                    +"FOR THIS CONSISTENTLY CRASHING,\n"
                                    +"BROKEN FUCKING NETWORK PILE OF GARBAGE\n"
                                    +"THAT'S SLOGGING UP HALF MY FUCKING DRIVE\n"
                                    +"ATLEAST GIVE ME A FUCKING ERROR CODE\n"
                                    +"OR SOMETHING OF FUCKING USE AS TO WHY YOU CRASH\n"
                                    +"YOU INCOMPETENTLY DEVELOPED ANCIENT PILE OF FUCKING SHIT.",
                                "So we use all torches -> boss door opens and boss appears ~15 sec\n"
                                    +"after torches are used -> we use push to push them back\n"
                                    +"around where the pillar is -> we use big dick\n"
                                    +"to slow the zombies where they got pushed to ->\n"
                                    +"use the first wall after the pillar where the ladder is\n"
                                    +"(to get to the top) -> rest of the walls walk back progressively\n"
                                    +"-> ~3rd or 4th wall is used at the boss gate,\n"
                                    +"rest stack right behind them -> while walls are being placed\n"
                                    +"the rest of the team goes in and shoots the boss",
                                "hello!\n"
                                    +"please play my map\n"
                                    +"why you should play my map:\n"
                                    +"- it is made in hammer editor\n"
                                    +"- it is playable\n"
                                    +"- it is on the server\n"
                                    +"- it can be nominated\n"
                                    +"thank you for playing my map!",
                                "Can people please stop trolling at part 1 in ze_best_korea\n"
                                    +"it's not even that hard\n"
                                    +"oh eh oh ah ah ting tang walla walla bing bang",
                                "a affirmative alert alien aliens all am\nan anything are area ass at away\n"
                                    +"backup bag bastard bastards blow blows bogie\nbogies bravo call casualty casualties\n"
                                    +"charlie check checking clear command\ncontinue control cover creep creeps\n"
                                    +"dam damn dat dis delta down east echo eliminate\neverything fall fight fire five force\n"
                                    +"formation four foxtrot freeman get go god\ngoing got grenade guard have he heavy hell\n"
                                    +"here hold hole hostiles hot i in is ja\nkick lay left lets let's level lookout\n"
                                    +"maintain mission mister mom mother",
                                "thats what happens when you play overplays maps at this time\n"
                                    +"all the fucking time same fucking maps\n"
                                    +"same dumbfucks nominating the same dumbfuck maps",
                                    ];
g_toledo_normal_chat <- [   " \x0e welcome to\x10 the bridge\x0e!!!!",//[0]
                            " \x0e unfortunately your\x10 illegal smuggling van\x0e has just broken down, so looks like you will have to\x10 walk!!",
                            " \x0e that's ok, you can walk your way across this\x10 perfectly normal and safe\x10 bridge!!",
                            "",
                            " \x0e good on you for spotting\x10 an average pothole!!\x0e wait until i close the gap for you!!",
                            " \x0e oops!! you have went over\x10 an average pothole!!\x0e wait until i close the gap for you!!",//[5]
                            " \x10 ok you can cross now!!",
                            " \x0e that's strange! the bridge closed on itself!!",
                            " \x0e the music is getting intense too, surely nothing bad will happen on this\x10 perfectly normal bridge!!",
                            " \x0e oh no!! looks like something has fractured the fragement of spacetime reality and turned off the gravity (for cars)!!",
                            " \x0e that's okay, at least the the trains are running fine!!",//[10]
                            " \x0e just make sure to give them\x10 right of way!!\x0e ask the trains\x10 politely\x0e if you want to cross!!",
                            "",
                            " \x10 the trains are granting you passage!!",
                            " \x0e how weird! the bridge has closed again!!",
                            " \x0e is it me or am i hearing even more epic music?!?!",//[15]
                            " \x0e surely the bridge is not closing on itself behind you?!?!",
                            " \x0e oh no!! quick!!\x10 run towards the tunnels at the end and get inside!!",
                            " \x0e phew!! the bridge almost consumed us!!",
                            " \x0e but you're safe now!! i think!!",
                            " \x0e *you ask the trains nicely to slow itself down*"    ];//[20]
g_toledo_extreme_chat <- [  " \x0e i am sad you are wanting to leave, but i understand!! ",//[0]
                            " \x0e let's walk you back across the\x10 perfectly normal bridge!!",
                            " \x0e don't worry about\x06 that thing\x0e in front of you!!",
                            " \x0e surely it won't start moving like in ze_collective!!",
                            " \x10 oh shit oh fuck",
                            " \x0e haha maybe it is just showing off its moves",//[5]
                            " \x0e surely it will not begin attacking or anything haha!!",
                            " \x10 oh shit oh fuck run, across the bridge!!!!",
                            "",
                            " \x06 THE COLLECTIVE\x0e is preparing for its\x10 ultimate-final-dooming attack!!",
                            " \x0e quick!! get in this\x10 totally inconspicuous trap-free van!!",//[10]
                            " \x10 and stay away from that glitching wall!!\x0e just do!!",
                            " \x02 T H E R E  I S  N O  E S C A P I N G",
                            " \x02 T H E R E  I S  N O  E S C A P I N G",
                            " \x02 T H E R E  I S  N O  E S C A P I N G",
                            " \x0e oops!! it was a trap after all!!",//[15]
                            " \x0e surely nobody fell for it though!!",
                            " \x0e anyways let's cross the\x10 perfectly normal bridge\x0e back!!",
                            " \x0e looks like\x06 THE COLLECTIVE\x0e is still angry though!!",
                            " \x0e oh no!!\x06 THE COLLECTIVE\x0e went absolutely fuming and it\x10 phased into the depths below!!",
                            " \x0e i think you owe it an apology after this!!",//[20]
                            " \x0e but for now let's get\x10 back into the tunnel!!",
                            "",
                            "",
                            " \x10 afk tp has been activated!!",
                            " \x0e oh no!! the stage went borked and the map is now broken!!",//[25]
                            " \x0e wait no, then how is this chat working",
                            " \x0e whatever it is, just go back to the tunnel you teleported in from and defend for about 30 secs!!",
                            " \x10 hmm... something is fishy or something?"  ];
g_chat_delays <- null;

//print on chat set messages
function printTLChat(index,amount,it)
{
    if(!::g_extreme)
        ScriptPrintMessageChatAll(g_toledo_normal_chat[index]);
    else
        ScriptPrintMessageChatAll(g_toledo_extreme_chat[index]);
    index++;
    amount--;
    if(amount>0)
        EntFireByHandle(self, "RunScriptCode", "printTLChat("+index+","+amount+","+(it+1)+")", g_chat_delays[it], null, null);
}

// +   Clean-up   + //

function cleanUpToledo()
{
    cleanUp();
    EntFire("fog","TurnOff","",0,null);
    toledoReset();
}

// --------------------------- //
// +   Toledo Bridge Stage   + //
// --------------------------- //

g_toledo_origin <- Vector(3072,0,0);//this is the centre of toledo stage at the height of the road

// +   Normal   + //

//variables
g_break_0 <- false;
g_break_1 <- false;
g_trn_dist <- 2688;
g_trn_length <- 600;
g_trn_coords <- [Vector(g_toledo_origin.x-1280,g_toledo_origin.y+1344,g_toledo_origin.z),Vector(g_toledo_origin.x,g_toledo_origin.y-1344,g_toledo_origin.z),Vector(g_toledo_origin.x+1792,g_toledo_origin.y+1344,g_toledo_origin.z)];
g_trn_stop_spawn <- [false, false, false];
g_trn_max_speed <- 600;
g_trn_speed <- [600,600,600];
g_trn_slow <- [false,false,false];
g_trn_speed_interval <- 50;
g_music_transit <- false;
g_music_transit_to <- "";
g_music_transit_time <- 0;
g_music_transit_progress <- 1.0;
g_music_sequence <- 1;
g_music_seq_part <- 1;
g_music_func_queue <- [];
//g_vehicles <- [];
//g_vehicles_bobbing_offset <- [];
//g_vehicle_bobbing_disable <- false;//changeable by server
//g_vehicle_bobbing <- false;
//g_vehicle_bobbing_start <- false;
g_bridge_spawn_num <- 38;
g_bridge_interval <- 320;
g_skybridge_dist <- 2304;
g_bridge_coords <- Vector((g_toledo_origin.x+6080)-(g_bridge_spawn_num*g_bridge_interval),g_toledo_origin.y,g_toledo_origin.z+g_skybridge_dist);
g_skybridge_speed <- g_skybridge_dist.tofloat()/2;
g_bridge_stop_spawn <- false;
g_sin <- 0.00;

function precacheToledo()
{
    // +   Sound   + //
    self.PrecacheScriptSound("sfx/chinny/intro_vignette.mp3");
    self.PrecacheScriptSound("sfx/chinny/metal_pipe_sfx.mp3");
    self.PrecacheScriptSound("luffaren/eye_terror.mp3");
    self.PrecacheScriptSound("luffaren/eye_terror3.mp3");
    self.PrecacheScriptSound("sfx/chinny/laser_charge.mp3");
    self.PrecacheScriptSound("sfx/chinny/laser_fire.mp3");
    self.PrecacheScriptSound("sfx/chinny/ball_charge.mp3");
    self.PrecacheScriptSound("sfx/chinny/ball_fire.mp3");

    // +   Music   + //
    self.PrecacheScriptSound("music/chinny/celeste_confronting_myself_intro.mp3");
    self.PrecacheScriptSound("music/chinny/celeste_confronting_myself_loop.mp3");
    self.PrecacheScriptSound("music/chinny/celeste_starjump_11.mp3");
    self.PrecacheScriptSound("music/chinny/celeste_starjump_12.mp3"); 
    self.PrecacheScriptSound("music/chinny/celeste_starjump_13.mp3"); 
    self.PrecacheScriptSound("music/chinny/celeste_starjump_14.mp3");
    self.PrecacheScriptSound("music/chinny/celeste_starjump_21.mp3"); 
    self.PrecacheScriptSound("music/chinny/celeste_starjump_22.mp3"); 
    self.PrecacheScriptSound("music/chinny/celeste_starjump_23.mp3"); 
    self.PrecacheScriptSound("music/chinny/celeste_starjump_24.mp3"); 
    self.PrecacheScriptSound("music/chinny/celeste_starjump_3.mp3"); 
}

//reset the stage to its initial conditions; just a back-up in case things fail loading the stage multiple times in the same round
function toledoReset()
{
    g_break_0 = false;
    g_break_1 = false;
    g_trn_stop_spawn = [false, false, false];
    g_trn_slow = [false,false,false];
    //g_vehicles = [];
    //g_vehicle_bobbing_disable = false;
    //g_vehicles_bobbing_offset = [];
    //g_vehicle_bobbing = false;
    //g_vehicle_bobbing_start = false;
    g_bridge_coords = Vector((g_toledo_origin.x+6080)-(g_bridge_spawn_num*g_bridge_interval),g_toledo_origin.y,g_toledo_origin.z+g_skybridge_dist);
    g_bridge_stop_spawn = false;
    g_sin = 0.00;
    g_eye_kill = false;
    g_eye_dying = false;
    g_eye_deadvel = Vector(randVal(-10,10,2),randVal(-10,10,2),randVal(50,60,2));
    g_eye_deadrot = Vector(randVal(-5,5,2),randVal(-5,5,2),randVal(-5,5,2));
    g_can_eye_roam = false;
    g_eye_platforms = [];
    g_is_eye_open = true;
    g_eyelid_forced = false;
    g_eye_start = false;
    g_eye_platform_spawning = false;
    g_eye_focus_prev_ply = null;
    g_eye_focus_ply = null;
    g_eye_prev_movept = null;
    g_eye_movept = null;
    g_eye_movespeed = 50.0;//note; not actual speed - lower is faster
    g_eye_warmup_counter = 0;
    g_eye_find_new_target = true;
    g_eye_allow_attack = false;
    g_eye_attacking = false;
    g_eye_laser_attacking = false;
    g_attack_rest_time = 1.0;
    g_attack_laser_it = 0;
    g_attack_ball_it = 0;
    g_eye_trap_attack = false;
    g_eye_reverse = false;
    g_eye_afk_active = false;
    g_eye_afk_tp = Vector(g_toledo_origin.x+6144,g_toledo_origin.y,g_toledo_origin.z+800);
}

//related function for Toledo normal mode
function toledoNormal()
{
    precacheToledo();
    g_trn_max_speed = 600;
    g_trn_speed = [600,600,600];
    foreach(i in array(2))
        soundPlay(Vector(g_toledo_origin.x-6016,g_toledo_origin.y,g_toledo_origin.z+96),20000,"sfx/chinny/intro_vignette.mp3",10,100,7,0);
    g_chat_delays = [3,4];
    EntFireByHandle(self, "RunScriptCode", "printTLChat(0,3,0)", 1, null, null);
}

//if player falls off bridge
//finalx3: added some funny messages to CT who fall in normal mode
function fellOffBridge()
{
    if(!activator || !(activator.IsValid()))
        return;
    if(activator.GetTeam()==3)
    {
        if(!::g_extreme)
        {
            local text = Entities.FindByName(null, "chinny_tl_text");
            text.__KeyValueFromString("message", g_fell_from_bridge_chat[RandomInt(0,g_fell_from_bridge_chat.len()-1)]);//g_fell_from_bridge_chat.len()-1
            EntFire("chinny_tl_text","Display","",0,activator);
        }
        EntFireByHandle(activator,"SetHealth","0",0,null,null);
    }
    if(activator.GetTeam()==2)
    {
        if(!::g_extreme)
        {
            local coords = activator.GetOrigin();
            coords.z += 384;
            if(coords.y-g_toledo_origin.y>0)
                coords.y = g_toledo_origin.y+352;
            else
                coords.y = g_toledo_origin.y-352;
            coords.x -= 512;
            activator.SetOrigin(coords);
        }
        else
            EntFireByHandle(self, "RunScriptCode", "teleportAFKExtreme()", 0, activator, null);
    }
}

//if player is suspected to be boosted
function possibleBoost()
{
    if((activator.GetVelocity()).LengthSqr()>(600*600)||activator.GetVelocity().z>300)
    {
        local vel = activator.GetVelocity()*-1;
        activator.SetVelocity(vel);
        ScriptPrintMessageChatAll("it is forbidden\x02 BY\x01 law to be boosted");
    }
}

//transit music between two songs
function musicTransit()
{
    local music_from = Entities.FindByName(null, "music_looper"+::g_music_on);
    local music_to = Entities.FindByName(null, "music_looper"+::g_music_off);
    if(!music_from || !music_to)
        return;
    EntFireByHandle(music_from, "Volume", (10.0-g_music_transit_progress).tostring(), 0, null, null);
    EntFireByHandle(music_to, "Volume", g_music_transit_progress.tostring(), 0, null, null);
    if(g_music_transit_progress==1.0)
    {
        music_to.__KeyValueFromString("message", g_music_transit_to+".mp3");
        music_to.__KeyValueFromInt("health", g_music_transit_progress);
        EntFireByHandle(music_to, "PlaySound", "", 0, null, null);
    }
    g_music_transit_progress+=0.5;
    if(g_music_transit_progress<=10.0)
    {
        EntFireByHandle(self, "RunScriptCode", "musicTransit()", roundFloat(g_music_transit_time.tofloat()/20,2), null, null);
    }
    else
    {
        switchChannel();
        g_music_transit_time = 0
        g_music_transit_to = "";
        g_music_transit_progress = 1.0;
        g_music_transit = false;
        g_music_sequence++;
        if(g_music_sequence==3)
            g_music_sequence = 0;
    }
}

//manage the music sequences in normal mode
function musicSequenceManager()
{
    if(!g_music_sequence)
        return;
    if(g_music_transit)
    {
        if(g_music_sequence==1)
        {
            startCrossing();
            g_chat_delays = [8.5,3,2];
            printTLChat(8,4,0);
        }
        if(g_music_sequence==2)
        {
            if(g_music_seq_part==4)
            {
                g_music_transit_to = "music/chinny/celeste_starjump_3";
                bridgeCollapse();
                musicTransit();
                g_chat_delays = [12,4];
                printTLChat(15,3,0);
                EntFire("chinny_tl_bridgemove2","SetSpeed","6",8,null);
                EntFire("chinny_tl_bridgemove2","Close","",8,null);
                EntFire("chinny_tl_bridge_clip2","Kill","",8,null);
                EntFire("chinny_tl_bridge_clip2","Kill","",8,null);
                EntFireByHandle(self, "RunScriptCode", "toledoEnd()", 46, null, null);
            }
        }
        else
        {
            g_music_transit_to = "music/chinny/celeste_starjump_"+(g_music_sequence+1)+""+g_music_seq_part;
            musicTransit();
        }
    }
    musicPlay("music/chinny/celeste_starjump_"+g_music_sequence+""+g_music_seq_part,::g_music_on);
    EntFireByHandle(self, "RunScriptCode", "musicSequenceManager()", 8, null, null);
    g_music_seq_part++;
    if(g_music_seq_part>4)
        g_music_seq_part = 1;
}

//starts transition betweeen music sequences
function musicStartTransit()
{
    if(!g_music_transit)
    {
        g_music_transit = true;
        g_music_transit_time = 8;
    }
    else
        EntFireByHandle(self, "RunScriptCode", "musicStartTransit()", 8, null, null);
}

//if a player breaks bridge prematurely
//note; triggerer=0 - break by time limit, triggerer=1 - break by player
function breakBridgeDetect(loc,triggerer)
{
    if(!loc)
    {
        if(g_break_0)
            return;
        g_break_0 = true;
    }
    else
    {
        if(g_break_1)
            return;
        g_break_1 = true;
    }
    EntFireByHandle(self, "RunScriptCode", "bridgeBreak("+loc+")", 10+randVal(-5,5,2), null, null);
    if(!triggerer)
        printTLChat(4,1,0);
    else
        EntFireByHandle(self, "RunScriptCode", "printTLChat(5,1,0)", 1, null, null);
}

//deals with bridge breaking + moving crossable platform
function bridgeBreak(loc)
{
    if(!::g_extreme)
        printTLChat(6,1,0);
    if(!loc)
    {
        EntFire("chinny_tl_bridge_break1","Break","",0,null);
        local trailer1 = Entities.FindByName(null, "chinny_tl_connector1");
        local trailer2 = Entities.FindByName(null, "chinny_tl_connector2");
        trailer1.SetOrigin(Vector(g_toledo_origin.x-4352,g_toledo_origin.y-352,g_toledo_origin.z-160));
        trailer2.SetOrigin(Vector(g_toledo_origin.x-4352,g_toledo_origin.y+352,g_toledo_origin.z-160));
        if(!::g_extreme)
        {
            trailer1.SetAngles(0,0,0);
            trailer2.SetAngles(0,180,0);
        }
        else
        {
            trailer1.SetAngles(0,90,0);
            trailer2.SetAngles(0,90,0);
        }
    }
    else
    {
        EntFire("chinny_tl_bridge_break2","Break","",0,null);
        local car1 = Entities.FindByName(null, "chinny_tl_connector3");
        local car2 = Entities.FindByName(null, "chinny_tl_connector4");
        car1.SetOrigin(Vector(g_toledo_origin.x-3408,g_toledo_origin.y-352,g_toledo_origin.z));
        car1.SetAngles(180,0,0);
        car2.SetOrigin(Vector(g_toledo_origin.x-3408,g_toledo_origin.y+352,g_toledo_origin.z));
        car2.SetAngles(180,0,0);
    }
}

//start the weird sequence
function startCrossing()
{
    local move = Entities.FindByName(null,"chinny_tl_bridgemove1");
    move.__KeyValueFromInt("speed",120);
    EntFireByHandle(move,"Close","",7,null,null);
    doCrossing(0);
    EntFireByHandle(self, "RunScriptCode", "doCrossing(1)", 0.3, null, null);
    EntFireByHandle(self, "RunScriptCode", "doCrossing(2)", 0.6, null, null);
    randomizeVehicles();
    EntFire("chinny_tl_bridge_clip1","Kill","",0,null);
    EntFire("chinny_tl_invis*","Toggle","",0,null);
}

//spawn train model
function spawnTrain(pos,track,parent_name)
{
    local template = Entities.FindByName(null, "chinny_template_tl_train");
    local maker = Entities.FindByName(null, "chinny_maker_tl_train");
    template.ValidateScriptScope();
    template.GetScriptScope().keyvalues <- {
        targetname = "chinny_tl_train"+track,
        parentname = parent_name
        };
    template.GetScriptScope().PreSpawnInstance <- function(entityClass,entityName)    return keyvalues;
    maker.SpawnEntityAtLocation(pos, Vector(0,90,0));
}

//move train at specified track
function moveTrain(track)
{
    local pos = g_trn_coords[track];
    local dir = Vector();
    if(track==1)
        dir = Vector(0,90,0);
    else
        dir = Vector(0,270,0);
    moveSpawn(pos,dir,g_trn_dist,g_trn_speed[track],0,999999,"","",0,0);
    local move = null;
    if(::g_lin_idx==0)
        move = Entities.FindByName(null, "chinny_move"+g_lin_idx_max);
    else
        move = Entities.FindByName(null, "chinny_move"+(::g_lin_idx-1));
    spawnTrain(pos,track,move.GetName());
}

//start the crossing of trains across track
function doCrossing(track)
{
    if(g_trn_stop_spawn[track])
        return;
    if(g_trn_speed[track]>0)
    {
        moveTrain(track);
        EntFireByHandle(self, "RunScriptCode", "doCrossing("+track+")", roundFloat(g_trn_length.tofloat()/g_trn_speed[track].tofloat(),2), null, null);
        if(g_trn_speed[track]!=g_trn_max_speed)
            adjustTrainSpeed(track);
        if(g_trn_slow[track])
        {
            if(g_trn_speed[track]==(g_trn_max_speed-g_trn_speed_interval))
            {
                printTLChat(13,1,0);
                EntFire("chinny_tl_train_clip"+track,"Kill","",0,null);
            }
            g_trn_speed[track] -= g_trn_speed_interval;
        }
    }
    else
        adjustTrainSpeed(track);
}

//slow the trains on track
function adjustTrainSpeed(track)
{
    local tgt = null;
    while((tgt=Entities.FindByName(tgt, "chinny_tl_train"+track))!=null)
    {
        EntFireByHandle(tgt.GetMoveParent(), "SetSpeed", g_trn_speed[track].tostring(), 0, null, null);
    }
}

//stops crossing of trains across specified track
function stopCrossing(track)
{
    printTLChat(20,1,0);
    EntFireByHandle(self, "RunScriptCode", "stopCrossingDelayed("+track+")", 15+randVal(-5,5,2), null, null);
}

//delayed func of stopCrossing() (after random time)
function stopCrossingDelayed(track)
{
    g_trn_slow[track] = true;
}

//choose random pos, rot, colour of vehicles in the middle part of bridge
function randomizeVehicles()
{
    g_sin = PI/4;
    local vehicle = null;
    while((vehicle=Entities.FindByName(vehicle,"chinny_tl_car*"))!=null) if(vehicle.GetClassname()=="prop_dynamic")
    {
        local coords = vehicle.GetOrigin();
        local angle = vehicle.GetAngles();
        vehicle.__KeyValueFromVector("rendercolor", Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)));
        coords = Vector(coords.x,coords.y+RandomInt(-96,96),coords.z+RandomInt(32,96));
        if(RandomInt(0,1))
        {
            angle = Vector(RandomInt(150,210),RandomInt(0,360),angle.z+RandomInt(-70,70));
            coords.z += 64;
        }
        else
            angle = Vector(RandomInt(-30,30),RandomInt(0,360),angle.z+RandomInt(-70,70));
        vehicle.SetOrigin(coords);
        vehicle.SetAngles(angle.x,angle.y,angle.z);
        //g_vehicles.append(vehicle);
    }
    EntFire("chinny_tl_car_clip*","ClearParent","",0,null);
    while((vehicle=Entities.FindByName(vehicle,"chinny_tl_truck*"))!=null) if(vehicle.GetClassname()=="prop_dynamic")
    {
        local coords = vehicle.GetOrigin();
        local angle = vehicle.GetAngles();
        vehicle.__KeyValueFromVector("rendercolor", Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)));
        coords.z += RandomInt(32,64);
        if(angle.y>180)
            angle = Vector(RandomInt(-40,40),RandomInt(240,270),RandomInt(-5,5));
        else
            angle = Vector(RandomInt(-40,40),RandomInt(60,90),RandomInt(-5,5));
        vehicle.SetAngles(angle.x,angle.y,angle.z);
        local trailer = Entities.FindByName(null, "chinny_tl_trailer"+vehicle.GetName().slice(15));
        trailer.__KeyValueFromVector("rendercolor", Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)));
        trailer.SetAngles(angle.x+RandomInt(-5,5),angle.y+RandomInt(-5,5),angle.z+RandomInt(-3,3));
        vehicle.SetOrigin(coords);
        trailer.SetOrigin(coords+(vehicle.GetLeftVector()*320));
        //g_vehicles.append(vehicle);
    }
    EntFire("chinny_tl_truck_clip*","ClearParent","",0,null);
    EntFire("chinny_tl_trailer_clip*","ClearParent","",0,null);
    /*if(!g_vehicle_bobbing_disable)
    {
        g_vehicle_bobbing_start = true;
        tickMoveVehicle();
    }*/
}
/* Deleted in favour of smoother music transitions on live servers
//move cars as if they are floating
//note; this can be disabled via g_vehicle_bobbing_disable
function tickMoveVehicle()
{
    if(g_vehicle_bobbing_disable)
        return;
    local coords = Vector();
    foreach(i,vehicle in g_vehicles)
    {
        coords = vehicle.GetOrigin();
        if(g_vehicle_bobbing_start)
            g_vehicles_bobbing_offset.append(randVal(0,PI,2));
        coords.z += sin(g_sin+g_vehicles_bobbing_offset[i])*0.25;
        vehicle.SetOrigin(coords);
        if(vehicle.GetName().find("chinny_tl_truck")!=null)
        {
            local trailer = Entities.FindByName(null, "chinny_tl_trailer"+vehicle.GetName().slice(15));
            coords = trailer.GetOrigin();
            coords.z += sin(g_sin+g_vehicles_bobbing_offset[i])*0.25;
            trailer.SetOrigin(coords);
        }
    }
    if(g_vehicle_bobbing_start)
    {
        g_vehicle_bobbing_start = false;
        g_vehicle_bobbing = true;
    }
    if(!g_vehicle_bobbing)
        return;
    g_sin -= 0.1;
    EntFireByHandle(self, "RunScriptCode", "tickMoveVehicle()", 0.2, null, null);
}*/

//spawn bridge in the skybox
function spawnSkyBridge(pos,parent_name)
{
    local template = Entities.FindByName(null, "chinny_template_tl_skybridge");
    local maker = Entities.FindByName(null, "chinny_maker_tl_skybridge");
    template.ValidateScriptScope();
    template.GetScriptScope().keyvalues <- {
        targetname = "chinny_tl_skybridge",
        parentname = parent_name
        };
    template.GetScriptScope().PreSpawnInstance <- function(entityClass,entityName)    return keyvalues;
    maker.SpawnEntityAtLocation(pos,Vector(0,0,0));
}

//do the bridge collapse sequence
function bridgeCollapse()
{
    if(g_bridge_coords.x<(g_toledo_origin.x+6144))
    {
        moveSpawn(g_bridge_coords,Vector(90,0,0),g_skybridge_dist,g_skybridge_speed,0,0,"","",8,0);
        if(::g_lin_idx==0)
        {
            spawnSkyBridge(g_bridge_coords,"chinny_move"+g_lin_idx_max);
            EntFire("chinny_move"+g_lin_idx_max,"SetSpeed","0",roundFloat((g_skybridge_dist.tofloat()/g_skybridge_speed.tofloat()),2)-0.04,null);
        }
        else
        {
            spawnSkyBridge(g_bridge_coords, "chinny_move"+(::g_lin_idx-1));
            EntFire("chinny_move"+(::g_lin_idx-1),"SetSpeed","0",roundFloat((g_skybridge_dist.tofloat()/g_skybridge_speed.tofloat()),2)-0.04,null);
        }
        EntFireByHandle(self, "RunScriptCode", "bridgeCollapseMultiple("+g_bridge_coords.x+")", roundFloat(((g_skybridge_dist-72).tofloat()/g_skybridge_speed.tofloat()),2)-0.1, null, null);
        g_bridge_coords.x += g_bridge_interval;
        EntFireByHandle(self, "RunScriptCode", "bridgeCollapse()", 1, null, null);
    }
    else
    {
        g_chat_delays = [3];
        EntFireByHandle(self, "RunScriptCode", "printTLChat(18,2,0)", 2, null, null);
    }
}

//move the trigger_multiple of falling skybridge
function bridgeCollapseMultiple(coordx)
{
    local tp = Entities.FindByName(null, "chinny_tl_skybridge_tp");
    local coords = tp.GetOrigin();
    tp.SetOrigin(Vector(coordx,coords.y,coords.z));
    EntFireByHandle(tp, "Enable", "", 0.1, null, null);
}

//if player is 'crushed' by falling sky-bridge
function bridgeCrushed()
{
    if(activator.GetTeam()==3)
        EntFireByHandle(activator,"SetHealth","0",0,null,null);
    if(activator.GetTeam()==2)
    {
        local coords = activator.GetOrigin();
        coords.z += 1344;
        activator.SetOrigin(coords);
    }
}

//teleport out and clean up all entities
function toledoEnd()
{
    endStage();
    musicStopLoopQueue();
    //g_vehicle_bobbing = false;
    g_trn_stop_spawn = [true, true, true];
    g_eye_kill = true;
    g_can_eye_roam = false;
    EntFire("chinny_tl_exit_ct","Enable","",0.5,null);
    EntFire("chinny_tl_exit_all","Enable","",1,null);
    EntFireByHandle(self, "RunScriptCode", "cleanUpToledo()", 5, null, null);
}

// +   Extreme   + //
// Some parts of this vscript has been referenced from ze_collective manager.nut vscript by luffaren (amen)

//variables
g_eye_kill <- false;
g_eye_dying <- false;
g_eye_deadvel <- Vector(randVal(-5,5,2),randVal(-10,10,2),randVal(40,50,2));
g_eye_deadrot <- Vector(randVal(-10,10,2),randVal(-10,10,2),randVal(-10,10,2));
g_can_eye_roam <- false;
g_eye_max_platforms <- 10;
g_eye_platforms <- [];
g_eye_first_platform_dist <- 120;
g_eye_platform_dist <- 90;
g_tickrate <- 0.02;
g_eye_height <- g_toledo_origin.z+750;
g_eye_height_var <- 400;
g_eye_axis <- g_toledo_origin.y;
g_eye_axis_var <- 500;
g_eye_allowed_dist_var <- 50;
g_platform_spawn_axis <- g_toledo_origin.x-6144;
g_is_eye_open <- true;
g_eyelid_forced <- false;
g_eye_start <- false;
g_eye_platform_spawning <- false;
g_eye_focus_prev_ply <- null;
g_eye_focus_ply <- null;
g_eye_prev_movept <- null;
g_eye_movept <- null;
g_eye_keep_dist <- 1600;
g_eye_movespeed <- 50.0;//note; not actual speed - lower is faster
g_eye_rotspeed <- 0.2;
g_eye_warmup_counter <- 0;
g_eye_find_new_target <- true;
g_eye_time_per_target <- 8;
g_eye_allow_attack <- false;
g_eye_attacking <- false;
g_eye_laser_attacking <- false;
g_eye_notified_quickness <- false;
g_attack_rest_time <- 1.0;
g_attack_laser_gb_i <- [0,100];
g_attack_laser_gb_f <- [0,0];
g_attack_laser_it <- 0;
g_attack_laser_max_it <- 20;
g_attack_laser_gb_it <- [floor((255-g_attack_laser_gb_i[0])/g_attack_laser_max_it),floor((255-g_attack_laser_gb_i[1])/g_attack_laser_max_it)];
g_attack_ball_max <- 4;
g_attack_ball_it <- 0;
g_attack_notified <- false;
g_eye_trap_attack <- false;
g_eye_reverse <- false;
g_eye_afk_active <- false;
g_eye_afk_changed <- false;
g_eye_afk_tp <- Vector(g_toledo_origin.x+6144,g_toledo_origin.y,g_toledo_origin.z+800);
g_eye_crash_pos <- Vector();

//start the extreme level sequence
function toledoExtreme()
{
    precacheToledo();
    g_trn_speed = [100, 100, 100];
    g_trn_max_speed = 100;
    g_chat_delays = [2,2,2,3.5,10,5];
    EntFireByHandle(self, "RunScriptCode", "printTLChat(0,7,0)", 1, null, null);
}

//start the boss sequence
function startEye()
{
    g_sin = 0.0;
    g_eye_start = true;
    g_can_eye_roam = true;
    checkEyeBork();
    foreach(i in array(2))
        soundPlay(Entities.FindByName(null, "chinny_tl_eye").GetOrigin(),100000,"luffaren/eye_terror.mp3",10,RandomInt(65,75),10,0);
    musicLoop("music/chinny/celeste_confronting_myself_intro","music/chinny/celeste_confronting_myself_loop",29.15,116.325,0,::g_music_on,-1);
    EntFireByHandle(self, "RunScriptCode", "tickMove()", 1, null, null);
    EntFireByHandle(self, "RunScriptCode", "tickBlink()", 5, null, null);
    EntFire("chinny_tl_eye","SetAnimation","open",2,null);
	EntFire("chinny_tl_eye","SetDefaultAnimation","idle_open",2.02,null);
    local slow = Entities.FindByName(null, "chinny_tl_eye_slow");
    EntFireByHandle(slow, "Enable", "", 0, null,null);
    EntFireByHandle(slow, "SetPushDirection", "0 0 0", 0, null,null);
}

function tickMove(){newthread(___tickMove.bindenv(this)).call();}//prevents SQQuerySuspend - amen
//set boss position every tick
function ___tickMove()
{
    local eye = Entities.FindByName(null, "chinny_tl_eye");
    if(!eye)
        return;
    local next_fvec = null;
    local eye_org = eye.GetOrigin();
    g_sin -= 0.05;
    if(g_eye_dying)
    {
        if(g_eye_deadvel.z > -50)
            g_eye_deadvel.z -= 1.5;
		eye.SetOrigin(eye_org+g_eye_deadvel);
        if(eye_org.z<(g_toledo_origin.z-2500))
        {
            EntFire("chinny_tl_eye*", "Kill", "",0,null);
            g_eye_kill = true;
            return;
        }
		local ang = eye.GetAngles();
		ang += g_eye_deadrot;
		eye.SetAngles(ang.x,ang.y,ang.z);
    }
    else
    {
        //work on movement part
        if(g_can_eye_roam)
        {
            if(eye_org.x>(g_toledo_origin.x+5632) && g_eye_reverse)
            {
                EntFireByHandle(eye,"SetAnimation","idle_open_frenzy",0.04,null,null);
                EntFireByHandle(eye,"SetDefaultAnimation","idle_open_frenzy",0.05,null,null);
                soundPlay(eye_org,100000,"luffaren/eye_terror.mp3",10,RandomInt(220,255),10,0);
                soundPlay(eye_org,100000,"luffaren/eye_terror.mp3",10,RandomInt(130,150),10,0);
                EntFire("chinny_tl_eye_slow", "Kill", "", 0, null);
                g_chat_delays = [3,3];
                printTLChat(19,3,0);
                EntFire("chinny_tl_end_east*", "Close", "", 20, null);
                EntFire("music_looper"+::g_music_on, "FadeOut", "5", 23, null);
                EntFireByHandle(self, "RunScriptCode", "toledoEnd()", 28, null, null);
                EntFire("chinny_tl_extreme_afk_particle","StopPlayEndCap","",28,null);
                g_eye_dying = true;
            }
            local next_pos = Vector();
            if(g_eye_start)
                next_pos = Vector(eye_org.x,eye_org.y,g_eye_height);
            else
            {
                if(!g_eye_movept)
                {
                    g_eye_movept = Vector();
                    g_eye_movept.y = g_eye_axis+RandomInt(-g_eye_axis_var,g_eye_axis_var);
                    g_eye_movept.z = g_eye_height+RandomInt(-g_eye_height_var,g_eye_height_var);
                    local target = chooseMoveTarget();
                    if(target)
                    {
                        if(!g_eye_reverse)
                            g_eye_movept.x = target.x-g_eye_keep_dist;
                        else
                            g_eye_movept.x = target.x+g_eye_keep_dist;
                    }
                    else
                    {
                        if(g_eye_prev_movept)
                        {
                            if(!g_eye_reverse)
                                g_eye_movept.x = g_eye_prev_movept.x-g_eye_keep_dist;
                            else
                                g_eye_movept.x = g_eye_prev_movept.x+g_eye_keep_dist;
                        }
                        else
                        {
                            EntFire("chinny_tl_eye*", "Kill", "",0,null);
                            g_eye_kill = true;
                            return;
                        }
                    }
                    if(g_eye_afk_changed)
                        g_eye_afk_changed = !g_eye_afk_changed;
                }
                if(g_eye_movept.x<(g_toledo_origin.x-5568) && !g_eye_reverse)
                {
                    g_eye_movept = Vector(g_toledo_origin.x-4268,g_toledo_origin.y,g_eye_height+256);
                    g_eye_focus_ply = Entities.FindByName(null, "chinny_tl_eye_laser_target");
                    g_eye_focus_ply.SetOrigin(Vector(g_toledo_origin.x-5568,g_toledo_origin.y,g_toledo_origin.z));
                    g_eye_trap_attack = true;
                    g_eyelid_forced = true;
                    if(!g_is_eye_open)
                        EntFire("chinny_tl_eye","SetAnimation","open",0,null);
                    EntFire("chinny_tl_eye","SetDefaultAnimation","idle_open",0.01,null);
                    EntFire("chinny_tl_eye_slow", "Disable", "", 0, null);
                    EntFire("chinny_tl_extreme_afk","Enable","",0,null);
                    local wall = Entities.FindByName(null, "chinny_tl_extreme_afk_wall");
                    wall.SetOrigin(Vector(g_toledo_origin.x-4576,wall.GetOrigin().y,wall.GetOrigin().z));
                    g_eye_afk_active = false;
                }
                next_pos = g_eye_movept;
            }
            local dir = next_pos-eye_org;
            local dist = dir.Length();
            dir.Norm();
            if(dist>g_eye_allowed_dist_var)
            {
                eye.SetOrigin(eye_org+(dir * (dist/g_eye_movespeed)));
                local slow = Entities.FindByName(null, "chinny_tl_eye_slow");
                slow.SetOrigin(Vector(eye_org.x,slow.GetOrigin().y,slow.GetOrigin().z));
            }
            else
            {
                g_eye_prev_movept = g_eye_movept;
                g_eye_movept = null;
                if(g_eye_start)
                {
                    g_eye_start = false;
                    g_can_eye_roam = false;
                    EntFireByHandle(self, "RunScriptCode", "collectPieces()", 2, null, null);
                }
                else if(g_eye_trap_attack)
                {
                    g_can_eye_roam = false;
                    local laser = Entities.FindByName(null, "chinny_tl_eye_laser");
                    laser.SetOrigin(eye_org);
                    local target = Entities.FindByName(null, "chinny_tl_eye_laser_target");
                    local dir = g_eye_focus_ply.GetOrigin()-eye_org;
                    dir.Norm();
                    local coords = g_eye_focus_ply.GetOrigin();
                    target.SetOrigin(coords);
                    laser.__KeyValueFromFloat("width", 20.0);
                    laser.__KeyValueFromString("LaserTarget", target.GetName());
                    laser.__KeyValueFromString("rendercolor", "255 "+g_attack_laser_gb_i[0]+" "+g_attack_laser_gb_i[1]);
                    laser.__KeyValueFromInt("TextureScroll",0);
                    EntFire("chinny_tl_eye_laser", "TurnOn", "", 0, null);
                    foreach(i in g_attack_laser_gb_f)
                        g_attack_laser_gb_f[i] = g_attack_laser_gb_it[i];
                    EntFireByHandle(self, "RunScriptCode", "eyeFakeAttack()", 5, null, null);
                    g_chat_delays = [3,3];
                    EntFireByHandle(self, "RunScriptCode", "printTLChat(9,3,0)", 1, null, null);
                }
                else
                {
                    if(g_eye_warmup_counter>=9)
                    {
                        if(!g_attack_notified)
                        {
                            EntFireByHandle(self, "RunScriptCode", "printTLChat(7,1,0)", 0.5, null, null);
                            g_attack_notified = true;
                        }
                        if(RandomInt(1,100)>5)
                        {
                            g_can_eye_roam = false;
                            g_eye_allow_attack = true;
                        }
                        if(!g_eye_afk_changed)
                        {
                            if(!g_eye_reverse)
                            {
                                g_eye_afk_tp.x = eye_org.x+(g_eye_keep_dist*3)+512;
                                if(g_eye_afk_tp.x<(g_toledo_origin.x+6144) && !g_eye_afk_active)
                                {
                                    EntFireByHandle(self, "RunScriptCode", "printTLChat(24,1,0)", 0, null, null);
                                    g_eye_afk_active = true;
                                }
                            }
                            else if(g_eye_reverse)
                            {
                                g_eye_afk_tp.x = eye_org.x-(g_eye_keep_dist*3)-512;
                                if(g_eye_afk_tp.x>(g_toledo_origin.x-6144) && !g_eye_afk_active)
                                {
                                    local tp = Entities.FindByName(null,"chinny_tl_extreme_afk");
                                    local wall = Entities.FindByName(null, "chinny_tl_extreme_afk_wall");
                                    tp.SetAngles(0,180,0);
                                    wall.SetAngles(0,180,0);
                                    EntFireByHandle(self, "RunScriptCode", "printTLChat(24,1,0)", 0, null, null);
                                    g_eye_afk_active = true;
                                }
                            }
                            if(g_eye_afk_active)
                            {
                                local tp = Entities.FindByName(null,"chinny_tl_extreme_afk");
                                local wall = Entities.FindByName(null, "chinny_tl_extreme_afk_wall");
                                local particle = Entities.FindByName(null, "chinny_tl_extreme_afk_particle");
                                local coords = tp.GetOrigin();
                                if(!g_eye_reverse)
                                {
                                    tp.SetOrigin(Vector(g_eye_afk_tp.x+128,coords.y,coords.z));
                                    particle.SetOrigin(Vector(g_eye_afk_tp.x+128,coords.y,coords.z));
                                    coords = wall.GetOrigin();
                                    wall.SetOrigin(Vector(g_eye_afk_tp.x+128,coords.y,coords.z));
                                }
                                else
                                {
                                    tp.SetOrigin(Vector(g_eye_afk_tp.x-128,coords.y,coords.z));
                                    particle.SetOrigin(Vector(g_eye_afk_tp.x-128,coords.y,coords.z));
                                    coords = wall.GetOrigin();
                                    wall.SetOrigin(Vector(g_eye_afk_tp.x-128,coords.y,coords.z));
                                }
                                EntFireByHandle(tp,"Enable","",0,null,null);
                                EntFireByHandle(particle,"StopPlayEndCap","",0,null,null);
                                EntFireByHandle(particle,"Start","",1,null,null);
                                g_eye_afk_changed = true;
                            }
                        }
                    }
                    else
                        g_eye_warmup_counter++;
                }
            }
            //random chance of boss noise
            if(RandomInt(0,1000)<5 && !g_eye_start) foreach(i in array(2))
                soundPlay(Entities.FindByName(null, "chinny_tl_eye").GetOrigin(),100000,"luffaren/eye_terror3.mp3",10,RandomInt(55,85),4,0);
        }
        //work on rotation part
        if(!g_eye_start && !g_eye_laser_attacking)
        {
            if(g_eye_find_new_target && !g_eye_trap_attack)
            {
                g_eye_focus_prev_ply = g_eye_focus_ply;
                g_eye_focus_ply = chooseBeamTarget();
                if(g_eye_focus_ply)
                {
                    g_eye_find_new_target = false;
                    EntFireByHandle(self, "RunScriptCode", "g_eye_find_new_target <- true", g_eye_time_per_target, null, null);
                }
                else
                {
                    if(g_eye_focus_prev_ply)
                    {
                        g_eye_focus_ply = g_eye_focus_prev_ply;
                        g_eye_find_new_target = false;
                        EntFireByHandle(self, "RunScriptCode", "g_eye_find_new_target <- true", g_eye_time_per_target, null, null);
                    }
                    else
                    {
                        EntFire("chinny_tl_eye*", "Kill", "", 0, null);
                        g_eye_kill = true;
                        return;
                    }
                }
            }
            local current_fvec = eye.GetForwardVector();
            next_fvec = (g_eye_focus_ply.GetOrigin()-eye_org);
            next_fvec.Norm();
            eye.SetForwardVector(current_fvec+(next_fvec*g_eye_rotspeed));
        }
        else if(g_eye_trap_attack)
            next_fvec = (Vector(g_toledo_origin.x-5568,0,0)-eye_org);
        //start attack sequence
        if(g_eye_allow_attack && !g_eye_attacking)
            eyeAttack(eye);
    }
    //do platform movements
    if(g_eye_platforms.len()>0)
    {
        foreach(i, platform in g_eye_platforms)
        {
            if(!i)
            {
                if(!g_eye_dying)
                {
                    if(g_eye_platforms.len()>=g_eye_max_platforms && !g_eye_attacking)
                    {
                        platform.SetOrigin(eye_org-(next_fvec*g_eye_first_platform_dist));
                        platform.SetForwardVector(next_fvec);
                    }
                    else
                    {
                        local dir = (eye_org-platform.GetOrigin());
                        local dist = dir.Length();
                        dir.Norm();
                        if(dist*2 > g_eye_first_platform_dist)
                            platform.SetOrigin(platform.GetOrigin() + (dir * (dist*5/g_eye_platform_dist)));
                        else
                            platform.SetOrigin(eye_org-(dir*25));
                    }
                }
                else
                {
                    platform.SetOrigin(eye_org);
                    platform.SetForwardVector(eye.GetForwardVector());
                }
                continue;
            }
            local next_pos = platform.GetOrigin();
            next_pos.z += (sin(g_sin+(i.tofloat()/2))*4);
            next_pos -= (eye.GetForwardVector()*8);
            next_pos -= eye.GetUpVector();
            platform.SetOrigin(next_pos);
            local dir = (platform.GetOrigin()-g_eye_platforms[i-1].GetOrigin());
            local dist = dir.Length();
            dir.Norm();
            if(g_eye_platforms.len()>=g_eye_max_platforms)
            {
                if(dist > g_eye_platform_dist)
                    platform.SetOrigin(g_eye_platforms[i-1].GetOrigin() + (dir * g_eye_platform_dist));
            }
            else
            {
                if(dist > g_eye_platform_dist*1.2)
                    platform.SetOrigin(platform.GetOrigin() - (dir * (dist*20/g_eye_platform_dist)));
                else
                    platform.SetOrigin(g_eye_platforms[i-1].GetOrigin() + (dir * g_eye_platform_dist));
            }
            platform.SetForwardVector(dir);
        }
    }
    EntFireByHandle(self, "RunScriptCode", "tickMove()", g_tickrate, null, null);
}

//animate eye blinking
function tickBlink()
{
    if(g_eye_kill || g_eye_dying)
        return;
    if(!g_eyelid_forced)
    {
        if(g_is_eye_open)
        {
            EntFire("chinny_tl_eye","SetAnimation","close",0,null);
            EntFire("chinny_tl_eye","SetDefaultAnimation","idle_closed",0.01,null);
            EntFireByHandle(self, "RunScriptCode", "tickBlink()", 0.4, null, null);
        }
        else
        {
            EntFire("chinny_tl_eye","SetAnimation","open",0,null);
            EntFire("chinny_tl_eye","SetDefaultAnimation","idle_open",0.01,null);
            EntFireByHandle(self, "RunScriptCode", "tickBlink()", randVal(2,6,1), null, null);
        }
        local eye = Entities.FindByName(null, "chinny_tl_eye");
        EntFire("chinny_tl_eye","SetPlaybackRate","5",0,null);
        g_is_eye_open = !g_is_eye_open;
    }
    else
        EntFireByHandle(self, "RunScriptCode", "tickBlink()", randVal(2,6,1), null, null);
}

//collect pieces for boss' tail
function collectPieces()
{
    g_eye_movespeed = 25.0;
    spawnPieces();
}

//start collecting platforms as boss' tail
function spawnPieces()
{
    if(g_eye_kill || g_eye_dying)
        return;
    local template = Entities.FindByName(null, "chinny_template_tl_platform");
    local maker = Entities.FindByName(null, "chinny_maker_tl_platform");
    template.ValidateScriptScope();
    template.GetScriptScope().keyvalues <- {targetname = "chinny_tl_platform"+g_eye_platforms.len()};
    template.GetScriptScope().PreSpawnInstance <- function(entityClass,entityName)
    {
        return keyvalues;
    }
    maker.SpawnEntityAtLocation(Vector(g_platform_spawn_axis,g_eye_axis+RandomInt(-g_eye_axis_var,g_eye_axis_var),g_eye_height+RandomInt(-g_eye_height_var,g_eye_height_var)), Vector(0,0,0));
    g_eye_platforms.append(Entities.FindByName(null, "chinny_tl_platform"+g_eye_platforms.len()));
    if(g_eye_platforms.len()<g_eye_max_platforms)
        EntFireByHandle(self, "RunScriptCode", "spawnPieces()", 0.5, null, null);
    else
        g_can_eye_roam = true;
}

//attack function of eye boss
function eyeAttack(handle)
{
    g_eye_attacking = true;
    g_eyelid_forced = true;
    if(!g_is_eye_open)
        EntFire("chinny_tl_eye","SetAnimation","open",0,null);
    EntFire("chinny_tl_eye","SetDefaultAnimation","idle_open",0.01,null);
    if(RandomInt(0,1))
    {//laser attack
        g_eye_laser_attacking = true;
        local laser = Entities.FindByName(null, "chinny_tl_eye_laser");
        laser.SetOrigin(handle.GetOrigin());
        local target = Entities.FindByName(null, "chinny_tl_eye_laser_target");
        local dir = g_eye_focus_ply.GetOrigin()-handle.GetOrigin();
        dir.Norm();
        local coords = g_eye_focus_ply.GetOrigin();
        coords.z += 32;
        coords += (dir*200);
        target.SetOrigin(coords);
        laser.__KeyValueFromFloat("width", 20.0);
        laser.__KeyValueFromString("LaserTarget", target.GetName());
        laser.__KeyValueFromString("rendercolor", "255 "+g_attack_laser_gb_i[0]+" "+g_attack_laser_gb_i[1]);
        laser.__KeyValueFromInt("TextureScroll",0);
        EntFire("chinny_tl_eye_laser", "TurnOn", "", 0, null);
        foreach(i in g_attack_laser_gb_f)
            g_attack_laser_gb_f[i] = g_attack_laser_gb_it[i];
        laserCharge();
        foreach(i in array(2))
            soundPlay(handle.GetOrigin(),100000,"sfx/chinny/laser_charge.mp3",10,100,3,0);
        particleSpawn(handle.GetOrigin(),handle.GetAngles(),"custom_particle_001",3,"");
    }
    else
    {//ball attack
        ballAttack();
    }
}

//charge up laser
function laserCharge()
{
    local laser = Entities.FindByName(null, "chinny_tl_eye_laser");
    local eye = Entities.FindByName(null, "chinny_tl_eye");
    if(g_attack_laser_it==g_attack_laser_max_it)
    {
        EntFireByHandle(laser, "TurnOff", "", 0, null, null);
        laser.__KeyValueFromFloat("width", 150.0);
        EntFireByHandle(self, "RunScriptCode", "laserAttack()", g_attack_rest_time, laser, eye);
        EntFireByHandle(laser, "TurnOn", "", g_attack_rest_time, null, null);
        return;
    }
    //originally iterated through (floor((1*g_attack_laser_max_it/7))-1), but hardcoding it in hopes to reduce stress
    //the texturescroll was also calculated by floor(1*100/7) and etc.; 7 is the number of skins present on collective eye model
    if(g_attack_laser_it==1)
    {
        eye.__KeyValueFromInt("skin",1);
        laser.__KeyValueFromInt("TextureScroll",14);
    }
    if(g_attack_laser_it==4)
    {
        eye.__KeyValueFromInt("skin",2);
        laser.__KeyValueFromInt("TextureScroll",28);
    }
    if(g_attack_laser_it==7)
    {
        eye.__KeyValueFromInt("skin",3);
        laser.__KeyValueFromInt("TextureScroll",42);
    }
    if(g_attack_laser_it==10)
    {
        eye.__KeyValueFromInt("skin",4);
        laser.__KeyValueFromInt("TextureScroll",57);
    }
    if(g_attack_laser_it==13)
    {
        eye.__KeyValueFromInt("skin",5);
        laser.__KeyValueFromInt("TextureScroll",71);
    }
    if(g_attack_laser_it==16)
    {
        eye.__KeyValueFromInt("skin",6);
        laser.__KeyValueFromInt("TextureScroll",86);
    }
    if(g_attack_laser_it==9)
    {
        EntFire("chinny_tl_eye","SetAnimation","idle_open_frenzy",0,null);
        EntFire("chinny_tl_eye","SetPlaybackRate","5",0,null);
    }
    laser.__KeyValueFromString("rendercolor", "255 "+g_attack_laser_gb_f[0]+" "+g_attack_laser_gb_f[1]);
    foreach(i, dummy in g_attack_laser_gb_f)
        g_attack_laser_gb_f[i] += g_attack_laser_gb_it[i];
    g_attack_laser_it++;
    EntFireByHandle(self, "RunScriptCode", "laserCharge()", g_attack_rest_time*0.1, null, null);
}

//charge up laser
function laserAttack()
{
    local laser = Entities.FindByName(null, "chinny_tl_eye_laser");
    laserHurt(caller);
    EntFireByHandle(activator, "TurnOff", "", 0.05, null, null);
    caller.__KeyValueFromInt("skin",0);
    EntFire("chinny_tl_eye","SetAnimation","idle_open",0,null);
    laser.__KeyValueFromString("rendercolor", "255 0 0");
    foreach(i in array(2))
            soundPlay(caller.GetOrigin(),100000,"sfx/chinny/laser_fire.mp3",10,100,2,0);
    particleSpawn(caller.GetOrigin(),Entities.FindByName(null, "chinny_tl_eye").GetAngles(),"custom_particle_002",2,"");
    EntFire("chinny_tl_laser_hurt","Kill","",0.05,null);
    g_attack_laser_it = 0;
    g_attack_laser_gb_f = [0,0];
    g_eye_attacking = false;
    g_eye_find_new_target = true;
    g_eye_laser_attacking = false;
    g_eye_allow_attack = false;
    g_eyelid_forced = false;
    EntFireByHandle(self, "RunScriptCode", "g_can_eye_roam <- true", 1, null, null);
}

//spawn trigger_hurt
function laserHurt(eye)
{
    local template = Entities.FindByName(null, "chinny_template_tl_laser_hurt");
    local maker = Entities.FindByName(null, "chinny_maker_tl_laser_hurt");
    template.ValidateScriptScope();
    template.GetScriptScope().keyvalues <- {
        targetname = "chinny_tl_laser_hurt",
        };
    template.GetScriptScope().PreSpawnInstance <- function(entityClass,entityName)    return keyvalues;
    maker.SpawnEntityAtLocation(eye.GetOrigin(), eye.GetAngles());
}

//do ball attack
function ballAttack()
{
    g_eye_focus_ply = chooseBeamTarget();
    local eye = Entities.FindByName(null, "chinny_tl_eye");
    local eye_org = eye.GetOrigin();
    moveSpawn(eye_org,eye.GetAngles(),6000,750,0,0,"","",8,0.5);
    if(::g_lin_idx==0)
    {
        ballHurt(eye, "chinny_move"+g_lin_idx_max);
        particleSpawn(eye_org,eye.GetAngles(),"custom_particle_004",10,"chinny_move"+g_lin_idx_max);
    }
    else
    {
        ballHurt(eye, "chinny_move"+(::g_lin_idx-1));
        particleSpawn(eye_org,eye.GetAngles(),"custom_particle_004",10,"chinny_move"+(::g_lin_idx-1));
    }
    if(!g_attack_ball_it)
    {
        EntFire("chinny_tl_eye","SetAnimation","idle_open_frenzy",0,null);
        EntFire("chinny_tl_eye","SetPlaybackRate","5",0,null);
    }
    soundPlay(eye_org,100000,"sfx/chinny/ball_charge.mp3",10,100,2,0);
    soundPlay(eye_org,100000,"sfx/chinny/ball_fire.mp3",10,100,2,0.5);
    g_attack_ball_it++;
    if(g_attack_ball_it<g_attack_ball_max)
        EntFireByHandle(self, "RunScriptCode", "ballAttack()", g_attack_rest_time, null, null);
    else
    {
        g_attack_ball_it = 0;
        g_eye_attacking = false;
        g_eye_allow_attack = false;
        g_eyelid_forced = false;
        EntFireByHandle(self, "RunScriptCode", "g_can_eye_roam <- true", 1.5, null, null);
        EntFire("chinny_tl_eye","SetAnimation","idle_open",1,null);
    }
}

//spawn trigger_hurt for ball
function ballHurt(eye,parent_name)
{
    local template = Entities.FindByName(null, "chinny_template_tl_ball_hurt");
    local maker = Entities.FindByName(null, "chinny_maker_tl_ball_hurt");
    template.ValidateScriptScope();
    template.GetScriptScope().keyvalues <- {
        targetname = "chinny_tl_ball_hurt",
        parentname = parent_name
        };
    template.GetScriptScope().PreSpawnInstance <- function(entityClass,entityName)    return keyvalues;
    maker.SpawnEntityAtLocation(eye.GetOrigin(), eye.GetAngles());
}

//do the fake attack
function eyeFakeAttack()
{
    local laser = Entities.FindByName(null, "chinny_tl_eye_laser");
    local eye = Entities.FindByName(null, "chinny_tl_eye");
    if(g_attack_laser_it<(floor(g_attack_laser_max_it*0.9)))
        soundPlay(eye.GetOrigin(),100000,"sfx/chinny/laser_charge.mp3",10,30+(g_attack_laser_it*2)+RandomInt(-15,15),0.75,0);
    if(g_attack_laser_it==g_attack_laser_max_it)
    {
        eye.__KeyValueFromInt("skin",0);
        EntFireByHandle(laser, "TurnOff", "", 0, null, null);
        EntFire("chinny_tl_eye","SetAnimation","idle_open",0,null);
        EntFire("chinny_tl_eye_slow", "Enable", "", 0, null);
        EntFire("chinny_tl_eye_slow", "SetPushDirection", "0 180 0", 0, null);
        EntFire("chinny_tl_trap", "Open", "", 0, null);
        soundPlay(Vector(g_toledo_origin.x-5852,g_toledo_origin.y,g_toledo_origin.z+96),50000,"sfx/chinny/metal_pipe_sfx.mp3",10,100,2,0);
        g_chat_delays = [0.1,0.1,4,4,4,4];
        printTLChat(12,7,0);
        EntFire("chinny_tl_extreme_afk_particle","StopPlayEndCap","",0,null);
        EntFire("spawn_tp_ct", "AddOutput", "target chiny_dest_west_t", 0, null);
        EntFire("spawn_tp_t", "AddOutput", "target chiny_dest_west_t", 0, null);
        local tp = Entities.FindByName(null,"chinny_tl_extreme_afk");
        tp.SetOrigin(Vector(g_toledo_origin.x-4576,tp.GetOrigin().y,tp.GetOrigin().z));
        EntFireByHandle(tp, "Enable", "", 0, null, null);
        EntFireByHandle(tp, "Disable", "", 0.5, null, null);
        local wall = Entities.FindByName(null, "chinny_tl_extreme_afk_wall");
        wall.SetOrigin(Vector(g_toledo_origin.x-7000,wall.GetOrigin().y,wall.GetOrigin().z));
        g_attack_laser_it = 0;
        g_attack_laser_gb_f = [0,0];
        g_eye_trap_attack = false;
        g_eye_find_new_target = true;
        g_eyelid_forced = false;
        g_eye_reverse = true;
        g_eye_movept = null;
        EntFireByHandle(self, "RunScriptCode", "g_can_eye_roam <- true", 2, null, null);
        EntFire("chinny_tl_end_west", "Open", "", 10, null);
        return;
    }
    //originally iterated through (floor((1*g_attack_laser_max_it/7))-1), but hardcoding it in hopes to reduce stress
    //the texturescroll was also calculated by floor(1*100/7) and etc.; 7 is the number of skins present on collective eye model
    if(g_attack_laser_it==1)
    {
        eye.__KeyValueFromInt("skin",1);
        laser.__KeyValueFromInt("TextureScroll",14);
    }
    if(g_attack_laser_it==4)
    {
        eye.__KeyValueFromInt("skin",2);
        laser.__KeyValueFromInt("TextureScroll",28);
    }
    if(g_attack_laser_it==7)
    {
        eye.__KeyValueFromInt("skin",3);
        laser.__KeyValueFromInt("TextureScroll",42);
    }
    if(g_attack_laser_it==10)
    {
        eye.__KeyValueFromInt("skin",4);
        laser.__KeyValueFromInt("TextureScroll",57);
    }
    if(g_attack_laser_it==13)
    {
        eye.__KeyValueFromInt("skin",5);
        laser.__KeyValueFromInt("TextureScroll",71);
    }
    if(g_attack_laser_it==16)
    {
        eye.__KeyValueFromInt("skin",6);
        laser.__KeyValueFromInt("TextureScroll",86);
    }
    if(g_attack_laser_it==9)
    {
        EntFire("chinny_tl_eye","SetAnimation","idle_open_frenzy",0,null);
        EntFire("chinny_tl_eye","SetPlaybackRate","5",0,null);
    }
    laser.__KeyValueFromString("rendercolor", "255 "+g_attack_laser_gb_f[0]+" "+g_attack_laser_gb_f[1]);
    foreach(i, dummy in g_attack_laser_gb_f)
        g_attack_laser_gb_f[i] += g_attack_laser_gb_it[i];
    g_attack_laser_it++;
    EntFireByHandle(self, "RunScriptCode", "eyeFakeAttack()", 0.75, null, null);
}

//choose human to target for boss movement
//finalx3 update: added a failsafe distance calculation based on the average position of the CT team
function chooseMoveTarget()
{
    local coords = Vector();
    local cum_x = 0;
    local tot = 0;
    local ply = null;
    if(!g_eye_reverse)
    {
        coords = Vector(99999,99999,99999);
        while(null!=(ply=Entities.FindByClassname(ply, "player")))  if(ply && ply.IsValid() && ply.GetTeam()==3)
        {
            local ply_coord = ply.GetOrigin();
            cum_x += ply_coord.x;
            tot += 1;
            if(ply_coord.x<coords.x)
                coords = ply_coord;
        }
        if(coords==Vector(99999,99999,99999))
            return null;
        //prevent eye from wandering off too far from the average CT location
        local avg_x_coord = (cum_x/tot) - (g_eye_keep_dist*3);
        //ScriptPrintMessageCenterAll("Target ent loc: "+coords.x+"\nCT average loc: "+avg_x_coord+"\nDistance: "+(coords.x-avg_x_coord)+"\nTotal CT number: "+tot);
        //avg_x_coord -= (g_eye_keep_dist*3);
        if(coords.x < avg_x_coord)
        {
            printTLChat(28,1,0);
            EntFire("debug", "Command", "echo ----------(DEBUG WARNING)----------", 0.0, null);
            EntFire("debug", "Command", "echo The eye has targetted someone/something very far from CT team! Failsafe mechanism has been enabled!", 0.0, null);
            EntFire("debug", "Command", "echo ----------", 0.0, null);
            EntFire("debug", "Command", "echo Targeted entity coordinate: "+coords.x, 0.0, null);
            EntFire("debug", "Command", "echo Average coordinate of CT team: "+avg_x_coord, 0.0, null);
            EntFire("debug", "Command", "echo -----------------------------------", 0.0, null);
            coords.x = avg_x_coord
        }
    }
    else
    {
        coords = Vector(-99999,-99999,-99999);
        while(null!=(ply=Entities.FindByClassname(ply, "player")))  if(ply && ply.IsValid() && ply.GetTeam()==3)
        {
            local ply_coord = ply.GetOrigin();
            cum_x += ply_coord.x;
            tot += 1;
            if(ply_coord.x>coords.x)
                coords = ply_coord;
        }
        if(coords==Vector(-99999,-99999,-99999))
            return null;
        //prevent eye from wandering off too far from the average CT location
        local avg_x_coord = (cum_x/tot) + (g_eye_keep_dist*3);
        //ScriptPrintMessageCenterAll("Target ent loc: "+coords.x+"\nCT average loc: "+avg_x_coord+"\nDistance: "+(coords.x-avg_x_coord)+"\nTotal CT number: "+tot);
        //avg_x_coord += (g_eye_keep_dist*3);
        if(coords.x > avg_x_coord)
        {
            printTLChat(28,1,0);
            EntFire("debug", "Command", "echo ----------(DEBUG WARNING)----------", 0.0, null);
            EntFire("debug", "Command", "echo The eye has targetted someone/something very far from CT team! Failsafe mechanism has been enabled!", 0.0, null);
            EntFire("debug", "Command", "echo ----------", 0.0, null);
            EntFire("debug", "Command", "echo Targeted entity coordinate: "+coords.x, 0.0, null);
            EntFire("debug", "Command", "echo Average coordinate of CT team: "+avg_x_coord, 0.0, null);
            EntFire("debug", "Command", "echo -----------------------------------", 0.0, null);
            coords.x = avg_x_coord
        }
    }
    return coords;
}

//choose human to target for boss attack
function chooseBeamTarget()
{
    local coords = [];
    local ply = null;
    while((ply=Entities.FindByClassname(ply, "player"))!=null)  if(ply && ply.IsValid() && ply.GetTeam()==3)
        coords.append(ply);
    if(coords.len()==0)
        return null;
    return coords[RandomInt(0,coords.len()-1)];
}

//afk tp people far behind in extreme
function teleportAFKExtreme()
{
    activator.SetVelocity(Vector(0,0,0));
    if(g_eye_afk_active)
        activator.SetOrigin(g_eye_afk_tp);
    else
    {
        if(g_eye_reverse || g_eye_trap_attack)
        {
            if(RandomInt(0,1))
                activator.SetOrigin(Vector(g_toledo_origin.x-6592,g_toledo_origin.y+272,g_toledo_origin.z+8));
            else
                activator.SetOrigin(Vector(g_toledo_origin.x-6592,g_toledo_origin.y-272,g_toledo_origin.z+8));
        }
        else
        {
            if(RandomInt(0,1))
                activator.SetOrigin(Vector(g_toledo_origin.x+6592,g_toledo_origin.y+272,g_toledo_origin.z+8));
            else
                activator.SetOrigin(Vector(g_toledo_origin.x+6592,g_toledo_origin.y-272,g_toledo_origin.z+8));
        }
    }
}

//emergency fail-safe to end the stage early
function checkEyeBork()
{
    //ScriptPrintMessageCenterAll("test!");
    if(!g_eye_kill)
    {
        local pos = Entities.FindByName(null, "chinny_tl_eye").GetOrigin();
        if(!((pos-g_eye_crash_pos).LengthSqr()))
            toledoEndEarly();
        else
        {
            g_eye_crash_pos = pos;
            if(g_eye_start || g_eye_trap_attack)
                EntFireByHandle(self, "RunScriptCode", "checkEyeBork()", 30, null, null);
            else
                EntFireByHandle(self, "RunScriptCode", "checkEyeBork()", 15, null, null);
        }
    }
}

//quit stage early
function toledoEndEarly()
{
    g_eye_kill = true;
    EntFire("chinny_tl_eye*", "Kill", "", 0, null);
    EntFire("chinny_tl_platform*", "Kill", "", 0, null);
    EntFire("chinny_tl_extreme_afk*","Kill","",0,null);
    g_chat_delays = [3,3];
    printTLChat(25,3,0);
    EntFire("chinny_tl_end_east*", "Close", "", 35, null);
    EntFire("music_looper"+::g_music_on, "FadeOut", "5", 38, null);
    EntFireByHandle(self, "RunScriptCode", "toledoEnd()", 41, null, null);
}