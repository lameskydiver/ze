//              |           /                               /      /   
// ___  ___  ___| ___  _ _    ___            ___  ___  ___    ___ (___ 
//|___)|   )|   )|___)| | )| |          \  )|___ |    |   )| |   )|    
//|__  |  / |__/ |__  |  / | |__         \/  __/ |__  |    | |__/ |__  
//                                                           |         
                
/* Script for ze_endemic map: made by lameskydiver/chinny
 * First (test) version created: 10 August 2022
 * Maptest version _a12 completed: 02 October 2022
 * Maptest version _b1 completed: 08 October 2022
 * Maptest version _b2 completed: 13 October 2022
 * Maptest version _b3 completed: 13 October 2022
 * Maptest version _b4 completed: 14 October 2022
 * Release version _v1 completed: 14 October 2022
 * Releave version _v1_1 completed: 28 October 2022
 * Release version _v1_2 completed: 29 October 2022
 * Release version _v1_3 completed: 17 November 2022
 * Release version _v2 completed:
 *
 * If you spot errors / have questions contact me via:
 *  discord:    lameskydiver/chinny#5724
 *  steam:      https://steamcommunity.com/id/lameskydiver
 */

//-------------------//
//  Entity Functions //
//-------------------//

//Finds the entity given its name (this purely makes the code bit easier to read for me)
//Inputs: name - name of the entity
function entityFinder(name)
{
    local entity = Entities.FindByName(null, name);
    return entity;
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

//Creates a sparking effect for a given amount of time
//Inputs: magnitude - how big the spark is
//        trail - how long the spark trail is
//        duration - how long the sparking effect last for
function sparkingStart(duration, coordx, coordy, coordz, pitch, yaw)
{
    local spark = Entities.FindByNameNearest("map_spark", Vector(392,-360,-808), 16);
    //Give default properties for consistency
    EntFireByHandle(spark, "AddOutput", "Magnitude 1", 0.02, null, null);
    EntFireByHandle(spark, "AddOutput", "TrailLength 1", 0.02, null, null);
    //Change origin / angles
    EntFireByHandle(spark, "AddOutput", "origin "+coordx+" "+coordy+" "+coordz, 0.04, null, null);
    EntFireByHandle(spark, "AddOutput", "angles "+pitch+" "+yaw+" 0", 0.04, null, null);
    //Activate random sparking
    EntFireByHandle(self, "RunScriptCode", "sparking()", 0.1, spark, null);
    //Kill after a given duration
    EntFireByHandle(spark, "Kill", "", duration, null, null);
}

//Repeating the function after sparkingStart()
//Inputs: magnitude - how big the spark is
//        trail - how long the spark trail is
//        duration - how long the sparking effect last for
function sparking()
{
    if(activator!=null)
    {
        //Set the necessary values for the sparks
        local duration = ("0."+RandomInt(0,25)).tofloat();
        local next_spark = RandomInt(0,5);
        //On / off sparks
        EntFireByHandle(activator, "StartSpark", "", 0.0, null, null);
        EntFireByHandle(activator, "StopSpark", "", duration, null, null);
        //Fire next iteration
        EntFireByHandle(self, "RunScriptCode", "sparking()", next_spark, activator, null);
    }
}

//----------------//
//  Map Functions //
//----------------//

//------------//
//** Stages **//

//Variables
warmup_it <- 0;
debug <- false;//debug mode stops any developer console spamming
stage <- 0;//which stage the map is at currently(0: warmup, 1:pre-win, 2:post-win)

//Fires for every new round
function newRound()
{
    EntFire("map_perished_text", "SetText", perished_text, 0.0, null);
    EntFire("map_ftp_text", "SetText", zm_ftp_text, 0.0, null);
}

//Fires when the map is just loaded; i.e. warmup round
function stageIntro()
{
    stage = 0;
    EntFireByHandle(self, "RunScriptCode", "warmUpPrinter()", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "startIntro()", 40.0, null, null);
    EntFire("tp_zm*", "Kill", "", 0.0, null);
    EntFire("tp_spawn*", "AddOutput", "target dest_afk_room", 0.0, null);
    EntFire("tp_spawn*", "Enable", "", 0.0, null);
    EntFire("afk_room_hurt", "Kill", "", 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "musicPlay(9,0)", 0.0, null, null);
    EntFire("intro_dmg_multiple", "Enable", "", 0.0, null);
}

//Prints warmup in console every 5 seconds
function warmUpPrinter()
{
    if(warmup_it > 7)   return;
    ScriptPrintMessageChatAll("⠀\x02 [ CONSOLE ]\x01 WARM UP");
    EntFireByHandle(self, "RunScriptCode", "warmUpPrinter()", 5.0, null, null);
    warmup_it++;
}

//Fires for the main map, before the map is won by CT
function stagePreWin()
{
    stage = 1;
    EntFire("intro*", "Kill", "", 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "spIntro()", 10.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "detectMZ()", 10.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "checkDetectMZ()", 11.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "spInitiate()", 20.0, null, null);
    if(ScriptGetRoundsPlayed() == 1)    EntFireByHandle(self, "RunScriptCode", "musicIntro(5,6)", 11.0, null, null);//Play Plague Blossom in first round
    else    EntFireByHandle(self, "RunScriptCode", "musicChoose()", 11.0, null, null);
    if(ScriptGetRoundsPlayed() > 5)
    {//If humans lost more than 5 rounds
        finale_petty_mode = true;
        ScriptPrintMessageChatAll("⠀\x02 [ CONSOLE ]\x01 Easy mode activated in bad ending (Humans lost more than 5 rounds)");
    }
}

//Fires for the main map, after the map is won by CT
function stagePostWin()
{//Nothing much is changed, except to disable ZM glow if petty mode was activated in bad ending
    stage = 2;
    EntFire("intro*", "Kill", "", 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "spIntro()", 10.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "detectMZ()", 10.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "checkDetectMZ()", 11.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "spInitiate()", 20.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "musicChoose()", 11.0, null, null);
}

//-------------//
//**  Music  **//

//Precaches
self.PrecacheScriptSound("music/debacle/intro.mp3");
self.PrecacheScriptSound("music/debacle/plague_inc_adverse_reactions_intro.mp3");
self.PrecacheScriptSound("music/debacle/plague_inc_adverse_reactions_loop.mp3");
self.PrecacheScriptSound("music/debacle/plague_inc_z_com_falls_intro.mp3");
self.PrecacheScriptSound("music/debacle/plague_inc_z_com_falls_loop.mp3");
self.PrecacheScriptSound("music/debacle/plague_inc_plague_blossom_intro.mp3");
self.PrecacheScriptSound("music/debacle/plague_inc_plague_blossom_loop.mp3");
self.PrecacheScriptSound("music/debacle/plague_inc_nox_eternis.mp3");
self.PrecacheScriptSound("music/debacle/plague_inc_flatten_the_curve.mp3");
self.PrecacheScriptSound("music/debacle/plague_inc_evolution.mp3");

//Variables
music_pathfile <- [ "music/debacle/intro.mp3",//[0] Intro (Plague Inc OST: Flatten The Curve)
                    "music/debacle/plague_inc_adverse_reactions_intro.mp3",//[1]  Plague Inc OST: Adverse Reactions (Intro)
                    "music/debacle/plague_inc_adverse_reactions_loop.mp3",//[2] Plague Inc OST: Adverse Reactions (Loop)
                    "music/debacle/plague_inc_z_com_falls_intro.mp3",//[3] Plague Inc OST: Z Com Falls (Intro)
                    "music/debacle/plague_inc_z_com_falls_loop.mp3",//[4] Plague Inc OST: Z Com Falls (Loop)
                    "music/debacle/plague_inc_plague_blossom_intro.mp3",//[5] Plague Inc OST: Plague Blossom (Intro)
                    "music/debacle/plague_inc_plague_blossom_loop.mp3",//[6] Plague Inc OST: Plague Blossom (Loop)
                    "music/debacle/plague_inc_nox_eternis.mp3",//[7] Plague Inc OST: Nox Eternis (Bad Ending)
                    "music/debacle/plague_inc_flatten_the_curve.mp3",//[8] Plague Inc OST: Flatten The Curve (Good Ending)
                    "music/debacle/plague_inc_evolution.mp3"];//[9] Plague Inc OST: Evolution (Warm up)
music_length <- [24,21.01,153.91,22.234,198.56,168.00,188.92,126.73,125.60,30];
music_stop_loops <- false;

//Plays music with the given pathfile
//Inputs: pathfile_index - index to music pathfile
//        looped - boolean; if the music is looped or not
function musicPlay(pathfile_index, looped)
{
    local sound_emit = entityFinder("map_music");
    EntFireByHandle(sound_emit, "StopSound", "", 0.0, null, null);
    EntFireByHandle(sound_emit, "AddOutput", "message "+music_pathfile[pathfile_index], 0.0, null, null);
    EntFireByHandle(sound_emit, "PlaySound", "", 0.0, null, null);
    if(looped == 1) EntFireByHandle(self, "RunScriptCode", "musicLoop("+pathfile_index+")", music_length[pathfile_index], null, null);
}

//Plays music with looping
//Inputs: pathfile_index - index to music pathfile
function musicLoop(pathfile_index)
{
    if(music_stop_loops == false)   musicPlay(pathfile_index, 1);
}

//Stops (looping) music
function musicStop()
{
    local sound_emit = entityFinder("map_music");
    EntFireByHandle(sound_emit, "FadeOut", "5", 0.0, null, null);
    EntFireByHandle(sound_emit, "StopSound", "", 5.0, null, null);
}

//Give intro to a looping music
//Inputs: pathfile_index - index to intro music pathfile
//        pathfile_index_looped - index to looped music pathfile
function musicIntro(pathfile_index, pathfile_index_looped)
{
    musicPlay(pathfile_index, 0);
    EntFireByHandle(self, "RunScriptCode", "musicLoop("+pathfile_index_looped+")", music_length[pathfile_index], null, null);
}

//Chooses which music to play
function musicChoose()
{
    local index = RandomInt(1,6);
    if(index == 1 || index == 2)    musicIntro(1,2);
    else if(index == 3 || index == 4)    musicIntro(3,4);
    else if(index == 5 || index == 6) musicIntro(5,6);
}

//-------------//
//**  Sound  **//

//Precaches
self.PrecacheScriptSound("sfx/debacle/zombiesfx1.mp3");
self.PrecacheScriptSound("sfx/debacle/zombiesfx2.mp3");
self.PrecacheScriptSound("sfx/debacle/zombiesfx3.mp3");
self.PrecacheScriptSound("sfx/debacle/zombiesfx4.mp3");
self.PrecacheScriptSound("sfx/debacle/zombiesfx5.mp3");
self.PrecacheScriptSound("sfx/debacle/buttonsfx1.mp3");
self.PrecacheScriptSound("sfx/debacle/buttonsfx2.mp3");
self.PrecacheScriptSound("sfx/debacle/serverhack.mp3");
self.PrecacheScriptSound("sfx/debacle/newserverhack.mp3");
self.PrecacheScriptSound("sfx/debacle/subway_sfx_intro.mp3");
self.PrecacheScriptSound("sfx/debacle/subway_sfx.mp3");
self.PrecacheScriptSound("sfx/debacle/subway_approach.mp3");
self.PrecacheScriptSound("sfx/debacle/subway_depart.mp3");
//self.PrecacheScriptSound("sfx/debacle/zmalert.mp3"); Taken away after _a12 as FTP zombie alerting was replaced by visual red glow
//self.PrecacheScriptSound("sfx/debacle/subway_approach_p1.mp3"); Taken away after _b3 by completely reworking the spawn mechanism
//self.PrecacheScriptSound("sfx/debacle/subway_approach_p2.mp3"); Taken away after _b3 by completely reworking the spawn mechanism
self.PrecacheScriptSound("sfx/debacle/pickwt1.mp3");
self.PrecacheScriptSound("sfx/debacle/pickwt2.mp3");
self.PrecacheScriptSound("sfx/debacle/wtsfx.mp3");
self.PrecacheScriptSound("sfx/debacle/reportsfx.mp3");
self.PrecacheScriptSound("sfx/debacle/helicoptersfx1.mp3");
self.PrecacheScriptSound("sfx/debacle/helicoptersfx1.mp3");

//Variables
sound_pathfile <- [ "sfx/debacle/zombiesfx1.mp3",//[0]  Zombie 1
                    "sfx/debacle/zombiesfx2.mp3",//[1]  2
                    "sfx/debacle/zombiesfx3.mp3",//[2]  3
                    "sfx/debacle/zombiesfx4.mp3",//[3]  4
                    "sfx/debacle/zombiesfx5.mp3",//[4]  5
                    "sfx/debacle/buttonsfx1.mp3",//[5]  Button 1
                    "sfx/debacle/buttonsfx2.mp3",//[6]  2
                    "sfx/debacle/serverhack.mp3",//[7]  Server hacking
                    "sfx/debacle/newserverhack.mp3",//[8] New Server
                    "sfx/debacle/subway_sfx_intro.mp3",//[9] Subway sfx for intro
                    "sfx/debacle/subway_sfx.mp3",//[10] Subway sfx (loopable)
                    "sfx/debacle/subway_approach.mp3",//[11] Subway approaching
                    "sfx/debacle/subway_depart.mp3",//[12] Subway departing
                    "","","",
                    //"sfx/debacle/zmalert.mp3",//[13] Patient zero sound (zm forward spawn alert; discarded)
                    //"sfx/debacle/subway_approach_p1.mp3",//[14] Subway sfx for intro (train arrival part; discarded)
                    //"sfx/debacle/subway_approach_p2.mp3",//[15] Subway sfx for intro (doors opening part; discarded)
                    "sfx/debacle/pickwt1.mp3",//[16] Walkie-talkie transmission sfx 1
                    "sfx/debacle/pickwt2.mp3",//[17] Walkie-talkie transmission sfx 1
                    "sfx/debacle/wtsfx.mp3",//[18] Walkie-talkie button sfx
                    "sfx/debacle/reportsfx.mp3",//[19] Report trigger sfx
                    "sfx/debacle/helicoptersfx1.mp3",//[20] Helicopter passby sfx
                    "sfx/debacle/helicoptersfx2.mp3"];//[21] Helicopter landing sfx
sound_length <- [6.5,6.5,6.5,6.5,6.5,0.3,0.4,1.4,2.6,30,30,18,11,1.6,10.4,10.4,2.1,2.7,0.4,1.4,7,7];

//Plays sound at activator's location
//Inputs: pathfile_index - index to sound pathfile
//        total_duration - if looped, the total duration of sound until it is killed (negative values for infinite(until map end), 0 for non-looped)
//WARNING: If this function is called on same coordinates before previous sfx is killed, then the later ambient_generics does not get killed
function soundPlay(pathfile_index, total_duration)
{
    local maker = entityFinder("map_sfx_maker");
    maker.SpawnEntityAtLocation(activator.GetOrigin(), Vector(0,0,0));
    local sound = Entities.FindByNameNearest("map_sfx", activator.GetOrigin(), 1);
    EntFireByHandle(sound, "AddOutput", "message "+sound_pathfile[pathfile_index], 0.0, null, null);
    EntFireByHandle(sound, "PlaySound", "", 0.0, null, null);
    //Determine when to kill the sfx ambient_generic
    if(total_duration == 0) EntFireByHandle(sound, "Kill", "", sound_length[pathfile_index], null, null);
    if(total_duration > 0) EntFireByHandle(sound, "Kill", "", total_duration, null, null);
}

//Plays sound at given coordinates
//Inputs: pathfile_index - index to sound pathfile
//        total_duration - if looped, the total duration of sound until it is killed (negative values for infinite(until map end), 0 for non-looped)
//        coord(xyz)     - coordinates of desired location
function soundPlayManual(pathfile_index, total_duration, coordx, coordy, coordz)
{
    local maker = entityFinder("map_sfx_maker");
    maker.SpawnEntityAtLocation(Vector(coordx, coordy, coordz), Vector(0,0,0));
    local sound = Entities.FindByNameNearest("map_sfx", Vector(coordx, coordy, coordz), 1);
    EntFireByHandle(sound, "AddOutput", "message "+sound_pathfile[pathfile_index], 0.0, null, null);
    EntFireByHandle(sound, "PlaySound", "", 0.0, null, null);
    //Determine when to kill the sfx ambient_generic
    if(total_duration == 0) EntFireByHandle(sound, "Kill", "", sound_length[pathfile_index], null, null);
    if(total_duration > 0) EntFireByHandle(sound, "Kill", "", total_duration, null, null);
}

//-------------//
//**  Items  **//

//* General *//

//Pritns game_text to let know if a ZM interactable item is destroyed
function itemsText()
{
    EntFire("map_zm_text", "AddOutput", "holdtime 3", 0.0, null);
    EntFire("map_zm_text", "SetText", "A ZM has destroyed a map item", 0.0, null);
    EntFire("map_zm_text", "Display", "", 0.02, null);
}

//* Powerbox *//

//Variables
item_pb_health <- 91;//hp of powerbox (this value is 4 left click knife hits; if needing to change you have manually test hp at different knife hits)
item_pb_coordx <- [ 88,-368,0,      -672,-3225,-636,    896,1016,199,    -64];//coordinates to spawn in x coordinates
item_pb_coordy <- [ 2420,2000,2512, 1648,3561,1904,     832,2448,4105,  1712];
item_pb_coordz <- [ 668,748,668,    220,220,220,        -52,-68,-68,    748];
item_pb_yaw <- [    180,180,0,      180,225,0,          0,0,315,        90];//angle to rotate by around z-axis
item_pb_indices <- indexChooser(0,RandomInt(1,4),item_pb_coordx.len());//choose locations to spawn powerboxes (1 min, 4 max)

//Chooses locations to spawn powerboxes, and spawns them
function itemsPB()
{
    local indices = item_pb_indices;//Ensure global variable is not modified
    //The first spawned box is always the correct one
    EntFire("item_pb_template1", "ForceSpawn", "", 0.0, null);
    EntFire("item_pb_break_template", "ForceSpawn", "", 0.0, null);
    EntFire("item_pb_break2", "SetParent", "item_pb_box1", 0.02, null);
    EntFire("item_pb_break1", "SetParent", "item_pb_box1", 0.02, null);
    EntFire("item_pb_break1", "Sethealth", item_pb_health, 0.02, null);
    EntFire("item_pb_break2", "Sethealth", item_pb_health, 0.02, null);
    EntFireByHandle(self, "RunScriptCode", "spawnPB1("+indices[0]+")", 0.05, null, null);
    EntFire("item_pb_break2", "ClearParent", "", 0.08, null);
    //Spawn model for other (incorrect) powerboxes
    if(indices.len()>1) for(local it = 1; it < indices.len(); it++)
    {
        EntFireByHandle(self, "RunScriptCode", "spawnDelayPB1()", 0.1*it, null, null);
        EntFireByHandle(self, "RunScriptCode", "spawnPB1("+indices[it]+")", (0.1*it)+0.05, null, null);
    }
}

//Spawns powerboxes at its original state (stage 1)
//Inputs: index - index to indicate coordinates to spawn at
function spawnPB1(index)
{
    local box = Entities.FindByNameNearest("item_pb_box1", Vector(392,-232,-756),8);//Coords at item_pb_template1
    EntFireByHandle(box, "AddOutput", "origin "+item_pb_coordx[index]+" "+item_pb_coordy[index]+" "+item_pb_coordz[index], 0.0, null, null);
    EntFireByHandle(box, "AddOutput", "angles 0 "+item_pb_yaw[index]+" 0", 0.0, null, null);
}

//Templates stage 1 powerboxes with a delay
function spawnDelayPB1()
{
    EntFire("item_pb_template1", "ForceSpawn", "", 0.0, null);
}

//Spawns powerboxes at its semi-broken state (stage 2), and removes stage 1 model
function spawnPB2()
{
    local newbox = Entities.FindByNameNearest("item_pb_box2", Vector(392,-200,-756),8);//Coords at item_pb_template2
    local oldbox = Entities.FindByNameNearest("item_pb_box1",
                                                Vector(item_pb_coordx[item_pb_indices[0]],item_pb_coordy[item_pb_indices[0]],item_pb_coordz[item_pb_indices[0]]),1);
    newbox.SetOrigin(oldbox.GetOrigin());
    newbox.SetAngles(0, (oldbox.GetAngles()).y, 0);
    EntFireByHandle(oldbox, "Kill", "", 0.0, null, null);
}

//Spawns powerboxes at its destroyed state (stage 3), and removes stage 2 model
function spawnPB3()
{
    local newbox = Entities.FindByNameNearest("item_pb_box3", Vector(392,-168,-756),1);//Coords at item_pb_template3
    local oldbox = Entities.FindByNameNearest("item_pb_box2",
                                            Vector(item_pb_coordx[item_pb_indices[0]],item_pb_coordy[item_pb_indices[0]],item_pb_coordz[item_pb_indices[0]]),1);
    newbox.SetOrigin(oldbox.GetOrigin());
    newbox.SetAngles(0, (oldbox.GetAngles()).y, 0);
    EntFireByHandle(oldbox, "Kill", "", 0.0, null, null);
}

//Fires when the powerbox is broken with a black out effect
function brokePB()
{
    ScriptPrintMessageChatAll("⠀\x10 [ OPR ]\x01 I sense a\x0f sudden power surge\x01. There will be a\x02 blackout\x01 for a\x02 few seconds\x01 soon");
    //Stop the generator hints
    EntFireByHandle(self, "RunScriptCode", "stopGeneratorHints()", 5.0, null, null);
    EntFire("b_rotate*", "Stop", "", 5.0, null);
    //Prepare the blackout (fog)
    local duration = RandomInt(2,4);
    EntFire("map_fade", "AddOutput", "holdtime "+duration, 0.0, null);
    EntFire("map_fade", "AddOutput", "duration 0.05", 0.0, null);
    EntFire("map_fade", "Fade", "", 5.0, null);
    //Fire game_text so humans know of the effect
    itemsText();
    //Make path bravo minigame longer
    b_mg_wait_time <- b_mg_wait_time + 10;
    b_mg_max_time <- b_mg_max_time - 7;
}

//* Groundcables *//

//Variables
item_gc_jumps <- 0;//iterator for amount of jumps done on the cover
item_gc_max_jumps <- 3;//amount of jumps the cover can withstand
item_gc_health <- 91;//hp of cables (this value is 4 left click knife hits; if needing to change you have manually test hp at different knife hits)
item_gc_coordx <- [ -881,400,-384,   -832,-1696,-728,    144,280,856,    -750];//coordinates to spawn in x coordinates
item_gc_coordy <- [ 2118,2023,2767,  1759,3176,4065,     1344,728,896,   1168];
item_gc_coordz <- [ 688,608,608,     160,160,160,        -112,-112,-112, 688];
item_gc_yaw <- [    135,0,0,         0,0,90,             0,90,90,        90];//angle to rotate by around z-axis
item_gc_indices <- indexChooser(0,RandomInt(1,4),item_gc_coordx.len());//chooses locations to spawn ground cables (1 min, 4 max)

//Chooses locations to spawn groundcables, and spawns them
function itemsGC()
{
    local indices = item_gc_indices;//Ensure global variable is not modified
    //The first spawned box is always the correct one
    EntFire("item_gc_template1", "ForceSpawn", "", 0.0, null);
    EntFire("item_gc_break_template", "ForceSpawn", "", 0.0, null);
    EntFire("item_gc_break", "SetParent", "item_gc_prop1", 0.0, null);
    EntFire("item_gc_multiple", "SetParent", "item_gc_prop1", 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "spawnGC1("+indices[0]+")", 0.05, null, null);
    EntFire("item_gc_break", "ClearParent", "", 0.08, null);
    //Spawn other (incorrect) groundcable models
    if(indices.len()>1) for(local it = 1; it < indices.len(); it++)
    {
        EntFireByHandle(self, "RunScriptCode", "spawnDelayGC1()", 0.1*it, null, null);
        EntFireByHandle(self, "RunScriptCode", "spawnGC1("+indices[it]+")", (0.1*it)+0.05, null, null);
    }
}

//Spawns groundcable at its original state (stage 1)
//Inputs: index - index to indicate coordinates to spawn at
function spawnGC1(index)
{
    local cable = Entities.FindByNameNearest("item_gc_prop1", Vector(472,-72,-808),8);//Coords at item_gc_template1
    EntFireByHandle(cable, "AddOutput", "origin "+item_gc_coordx[index]+" "+item_gc_coordy[index]+" "+item_gc_coordz[index], 0.0, null, null);
    EntFireByHandle(cable, "AddOutput", "angles 0 "+item_gc_yaw[index]+" 0", 0.0, null, null);
}

//Templates stage 1 groundcable with a delay
function spawnDelayGC1()
{
    EntFire("item_gc_template1", "ForceSpawn", "", 0.0, null);
}

//Detects if a player jumps onto the covers
function gcJump()
{
    if((activator.GetVelocity()).z < -200)    item_gc_jumps++;
    if(item_gc_jumps == item_gc_max_jumps)
    {//break the cover
        EntFire("item_gc_template2", "ForceSpawn", "", 0.0, null);
        EntFireByHandle(self, "RunScriptCode", "spawnGC2()", 0.02, null, null);
        activator.SetVelocity(Vector((activator.GetVelocity()).x,(activator.GetVelocity()).y,0));//prevent player potentially getting stuck
    }
}

//Spawns groundcable at its semi-broken state (stage 2), removes stage 1 model
function spawnGC2()
{
    local newcable = Entities.FindByNameNearest("item_gc_prop2", Vector(472,-40,-808),8);//Coords at item_gc_template2
    local oldcable = Entities.FindByNameNearest("item_gc_prop1",
                                                Vector(item_gc_coordx[item_gc_indices[0]],item_gc_coordy[item_gc_indices[0]],item_gc_coordz[item_gc_indices[0]]),1);
    newcable.SetOrigin(oldcable.GetOrigin());
    newcable.SetAngles(0, (oldcable.GetAngles()).y, 0);
    EntFireByHandle(oldcable, "Kill", "", 0.0, null, null);
    EntFire("item_gc_break", "SetHealth", item_gc_health, 0.0, null);//change hp of the breakable
}

//Spawns groundcable at its destroyed state (stage 3), removes stage 2 model
function spawnGC3()
{
    local newcable = Entities.FindByNameNearest("item_gc_prop3", Vector(472,-8,-808),8);//Coords at item_gc_template3
    local oldcable = Entities.FindByNameNearest("item_gc_prop2",
                                            Vector(item_gc_coordx[item_gc_indices[0]],item_gc_coordy[item_gc_indices[0]],item_gc_coordz[item_gc_indices[0]]),1);
    newcable.SetOrigin(oldcable.GetOrigin());
    newcable.SetAngles(0, (oldcable.GetAngles()).y, 0);
    EntFireByHandle(oldcable, "Kill", "", 0.0, null, null);
}

//Fires if the groundcable is broken, and disables radar
function brokeGC()
{
    ScriptPrintMessageChatAll("⠀\x10 [ OPR ]\x01 I just lost all my\x02 camera feeds\x01... I\x0f can't relay zombies' positions\x01 until it is fixed");
    //Disable radar for about 20 seconds
    local duration = RandomInt(18,22);
    EntFire("map_servercommand", "Command", "sv_disable_radar 1", 0.0, null);
    EntFire("map_servercommand", "Command", "sv_disable_radar 0", duration, null);
    itemsText();//let humans know the item is broken
    //Make path charlie minigame harder
    c_mg_max_options = c_mg_rgb.len();
    c_mg_wait = c_mg_wait + 3;
    c_mg_max_time <- c_mg_max_time - 15;
}

//* Transmitter *//

//Variables
item_tm_health <- 166;//hp of transmitter cover (this value is 7 left click knife hits; if needing to change you have manually test hp at different knife hits)
item_tm_coordx <- [ -1280,-448,320, -768,-720,-3209,    960,216,1192,   -152];//coordinates to spawn in x coordinates
item_tm_coordy <- [ 1136,2136,2500, 1784,1328,3577,     1592,816,3432,  1352];
item_tm_coordz <- [ 786,786,706,    258,786,258,        -14,-14,-30,    786];
item_tm_yaw <- [    0,270,270,      90,270,225,          90,180,225,     45];//angle to rotate by around z-axis
item_tm_indices <- indexChooser(0,RandomInt(1,4),item_tm_coordx.len());//chooses locations for transmitter spawn

//Chooses locations to spawn transmitters, and spawns them
function itemsTM()
{
    local indices = item_tm_indices;
    //The first spawned box is always the correct one
    EntFire("item_tm_template1", "ForceSpawn", "", 0.0, null);
    EntFire("item_tm_break_template", "ForceSpawn", "", 0.0, null);
    EntFire("item_tm_break", "SetParent", "item_tm_prop1", 0.0, null);
    EntFire("item_tm_button", "SetParent", "item_tm_prop1", 0.0, null);
    EntFire("item_tm_break", "Sethealth", item_tm_health, 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "spawnTM1("+indices[0]+")", 0.05, null, null);
    EntFire("item_tm_button", "ClearParent", "", 0.08, null);
    //Spawn other (incorrect) transmitter models
    if(indices.len()>1) for(local it = 1; it < indices.len(); it++)
    {
        EntFireByHandle(self, "RunScriptCode", "spawnDelayTM1()", 0.1*it, null, null);
        EntFireByHandle(self, "RunScriptCode", "spawnTM1("+indices[it]+")", (0.1*it)+0.05, null, null);
    }
}

//Spawns transmitter at its original state (stage 1)
//Inputs: index - index to indicate coordinates to spawn at
function spawnTM1(index)
{
    local box = Entities.FindByNameNearest("item_tm_prop1", Vector(392,-136,-718),8);//Coords at item_tm_template1
    EntFireByHandle(box, "AddOutput", "origin "+item_tm_coordx[index]+" "+item_tm_coordy[index]+" "+item_tm_coordz[index], 0.0, null, null);
    EntFireByHandle(box, "AddOutput", "angles 0 "+item_tm_yaw[index]+" 0", 0.0, null, null);
}

//Templates stage 1 transmitter with a delay
function spawnDelayTM1()
{
    EntFire("item_tm_template1", "ForceSpawn", "", 0.0, null);
}

//Spawns transmitter at its destroyed state (stage 2), removes stage 1 model
function spawnTM2()
{
    local newbox = Entities.FindByNameNearest("item_tm_prop2", Vector(392,-104,-718),8);//Coords at item_tm_template2
    local oldbox = Entities.FindByNameNearest("item_tm_prop1",
                                            Vector(item_tm_coordx[item_tm_indices[0]],item_tm_coordy[item_tm_indices[0]],item_tm_coordz[item_tm_indices[0]]),1);
    newbox.SetOrigin(oldbox.GetOrigin());
    newbox.SetAngles(0, (oldbox.GetAngles()).y, 0);
    EntFireByHandle(oldbox, "Kill", "", 0.0, null, null);
}

//Fires if the transmitter is disrupted
function brokeTM()
{
    ScriptPrintMessageChatAll("⠀\x10 [ OPR ]\x01 I am sensing\x0f higher latency\x01... I'm afraid all the\x02 triggers will take longer\x01 to open");
    //Make all (non specified) triggers longer
    trig_add_delay = trig_add_delay + RandomInt(1,3);
    itemsText();//let humans know item is broken
    //Make path alpha minigame harder
    a_mg_hackduration = a_mg_hackduration - 0.15;
    a_mg_totduration = a_mg_totduration - 8;
}

//* Reports *//

//References
//0 - helps with path alpha
//1 - helps with path bravo
//2 - helps with path charlie
//from here everything is artificial
//3 - greenland closes ports
//4 - collective
//5 - increased subway peak time usage
//6 - increasing subway fares
//7 - cannibalism incident in the station
//8 - complaints about bright lights (zombies are photophobic)
//9 - replacing with faster trains
//10 - increasing capacity due to higher traffic to hospitals
//11 - government banning public transport due to health concerns
//12 - increasing security in station
//13 - responding to airport quarantine (prey_annex reference)

//Variables
item_rp_coordx <- [ -1440,-1400,-1584,-944,-788,-1072,144,228,248,98,-508,-560,-304,-46,//[0-13] path alpha
                    -608,-920,-1696,-1888,-2584,-3080,-2688,-1696,-1296,-720,//[14-23] path bravo
                    932,787,608,758,920,832,832,1552,1264,412];//[24-33] path charlie
item_rp_coordy <- [ 1216,1464,1648,1488,1692,2376,2362,2140,2568,3248,2880,2984,3056,3000,
                    2576,1920,2592,1920,2592,2096,3160,3856,3200,3856,
                    1656,1484,1408,1324,1168,764,688,864,1784,3868];
item_rp_coord_pm <- [   28,8,3,40,14,5,8,8,12,10,5,5,5,4,
                        16,8,8,8,8,12,8,8,24,8,
                        12,4,24,10,10,5,5,8,8,8];//allowed maximum additional +- value to item_rp_coordx and item_rp_coordy
item_rp_coordz <- [ 727,721,725,718,730,708,661,682,670,557,666,640,666,649,
                    160,160,160,160,160,160,160,160,160,160,
                    -57,-56,-8,-21,-25,-54,-106,-128,-128,-128];
item_rp_yaw <- [    90,90, 90,270,270,0,285,225,165,0,180,90,180,255,
                    330,180,15,195,30,135,240,0,225,330,
                    315,90,90,270,270,270,240,240,75,330];//angle to rotate by around z-axis
item_rp_yaw_pm <- 30;//allowed maximum additional value to item_rp_yaw
item_rp_amount <- RandomInt(3,10);//amount of reports to spawn
item_rp_indices <- indexChooser(3,item_rp_amount-3,14);//which (superficial) report type to spawn
item_rp_coords_indices <- indexChooser(0,item_rp_amount,item_rp_coordx.len());//locations of spawn
item_rp_chat <- [   "⠀\x09 [ REPORT ]\x10 'Global emergency frequencies list'\x01. This will help us at the\x02 control room\x01 later",
                    "⠀\x09 [ REPORT ]\x10 'Power generators maintenance logs'\x01. This will help us with the\x02 generators\x01 later",
                    "⠀\x09 [ REPORT ]\x10 'Accessing the server files remotely'\x01. This will help us at the\x02 server room\x01 later",
                    "⠀\x09 [ REPORT ]\x10 'Greenland closes all ports due to global health concerns'\x01. Now that is frustrating",
                    "⠀\x09 [ REPORT ]\x10 'i pledge to do my part for the collective'\x01. Sounds like a cult of some sorts",
                    "⠀\x09 [ REPORT ]\x10 'Increased subway traffic in peak-time hours'\x01. Useless for us now",
                    "⠀\x09 [ REPORT ]\x10 'Increasing subway fares for higher revenues'\x01. Absolutely useless for us",
                    "⠀\x09 [ REPORT ]\x10 'Cannibalism incident at the station'\x01. It's more than an incident now, isn't it",
                    "⠀\x09 [ REPORT ]\x10 'Increased complaint on bright lightning'\x01. I'll make sure to use advantage of this later",
                    "⠀\x09 [ REPORT ]\x10 'Replacing trains with faster variant'\x01. Probably hinting at something...",
                    "⠀\x09 [ REPORT ]\x10 'Experiencing increased traffic to hospitals'\x01. Can't imagine what would be happening at a hospital right now",
                    "⠀\x09 [ REPORT ]\x10 'Government banning public transports and legalising personal armaments'\x01. I guess that is why you all have guns right now",
                    "⠀\x09 [ REPORT ]\x10 'Increased security and CCTV's in the station'\x01. Thanks to that I can relay zombie's positions accurately to you now",
                    "⠀\x09 [ REPORT ]\x10 'Airport under lockdown due to extraterristrial invasion'\x01. What's next, 'People carry around crates with tazers?'"];
item_rp_it <- 0;
item_rp_explain <- ["⠀\x10 [ OPR ]\x01 Heads up, if you see\x02 black clipboards\x01 as you move around, pick them up",
                    "⠀\x10 [ OPR ]\x01 They have\x09 reports\x01 about the station, which may help us later in the\x02 minigames"];
item_rp_introducing <- false;//bool; checks if introduceRP() is already fired

//Chooses locations to spawn reports, and spawns them
function itemsRP()
{
    for(local it = 0; it<item_rp_coords_indices.len(); it++)
    {
        EntFireByHandle(self, "RunScriptCode", "itemsRPSpawn()", 0.1*it, null, null);
        //Always spawn reports for all three paths first
        if(it == 0) EntFireByHandle(self, "RunScriptCode", "allocateReport(0,"+item_rp_coords_indices[it]+")", (0.1*it)+0.05, null, null);
        else if(it == 1)    EntFireByHandle(self, "RunScriptCode", "allocateReport(1,"+item_rp_coords_indices[it]+")", (0.1*it)+0.05, null, null);
        else if(it == 2)    EntFireByHandle(self, "RunScriptCode", "allocateReport(2,"+item_rp_coords_indices[it]+")", (0.1*it)+0.05, null, null);
        //Afterwards spawn whatever is needed
        else    EntFireByHandle(self, "RunScriptCode", "allocateReport("+item_rp_indices[it-3]+","+item_rp_coords_indices[it]+")", (0.1*it)+0.05, null, null);
    }
}

//Separate function to spawn in reports with delays
function itemsRPSpawn()
{
    EntFire("item_rp_template", "ForceSpawn", "", 0.0, null);
}

//Allocates different I/O depending on what report it is
//Inputs: index_report - index to indicate which report it is
//        index_coords - index to indicate which coordinates to spawn at
function allocateReport(index_report, index_coords)
{
    local report = Entities.FindByNameNearest("item_rp_prop",Vector(392,-296,-816),8);//coordinates at item_report_template
    local button = Entities.FindByNameNearest("item_rp_button",Vector(392,-296,-816),8);
    //Add report type number at the end for the model and button
    EntFireByHandle(report, "AddOutput", "targetname item_rp_prop"+index_report, 0.02, null, null);
    EntFireByHandle(button, "AddOutput", "targetname item_rp_button"+index_report, 0.02, null, null);
    EntFireByHandle(report, "Skin", index_report.tostring(), 0.02, null, null);//apply appropriate report texture
    EntFireByHandle(button, "SetParent", "item_rp_prop"+index_report, 0.04, null, null);
    //Apply appropriate origin / rotations
    EntFireByHandle(report, "AddOutput",
                    "origin "+(item_rp_coordx[index_coords]+RandomInt(-item_rp_coord_pm[index_coords],item_rp_coord_pm[index_coords]))+" "
                            +(item_rp_coordy[index_coords]+RandomInt(-item_rp_coord_pm[index_coords],item_rp_coord_pm[index_coords]))+" "+item_rp_coordz[index_coords], 0.04, null, null);
    EntFireByHandle(report, "AddOutput", "angles 0 "+(item_rp_yaw[index_coords]+RandomInt(-item_rp_yaw_pm,item_rp_yaw_pm))+" 0", 0.04, null, null);
}

//When the report has been triggered, fire the corresponding output
function triggerReport()
{
    local index = (caller.GetName()).slice(14);//get the index of the triggered report type
    (caller.GetMoveParent()).Destroy();
    EntFireByHandle(self, "RunScriptCode", "triggerReportChat("+index+")", 4.0, null, null);//fire the relative effect
}

//Displays which report was picked up
//Inputs: index - index to the triggered report
function triggerReportChat(index)
{
    ScriptPrintMessageChatAll(item_rp_chat[index]);
    switch(index)
    {
        case 0:
        {//Make path alpha minigame easier
            a_mg_hackduration = a_mg_hackduration + 0.3;
            return;
        }
        case 1:
        {//Make path beta minigame shorter
            b_mg_wait_time = floor(b_mg_wait_time * 0.6);
            return;
        }
        case 2:
        {//Make path charlie minigame easier
            c_mg_max_options = floor(c_mg_max_options * 0.5);
            c_mg_wait = floor(c_mg_wait * 0.8);
            return;
        }
    }
}

//Introduce to players the reports in the map
function introduceRP()
{
    if(!item_rp_introducing)
    {//Fire the text message if introduceRP() is not already activated
        item_rp_introducing == true;//Prevent multiple introduceRP() running at the same time
        ScriptPrintMessageChatAll(item_rp_explain[item_rp_it]);
        if(item_rp_it == 0)//spawn the next trigger
            EntFireByHandle(self, "RunScriptCode", "addTrigToQueue(-2,1328,736,15,2)", 0, null, null);
        if(item_rp_it == 1)
            return;
        item_rp_it++;
        EntFireByHandle(self, "RunScriptCode", "introduceRP()", 4, null, null);
        EntFireByHandle(self, "RunScriptCode", "item_rp_introducing <- false;", 3.98, null, null);//Allow to fire the next iteration in item_rp_explain
        EntFireByHandle(self, "RunScriptCode", "item_rp_introducing <- true;", 4, null, null);//Prevent multiple introduceRP() running at the same time
    }
}

//* Walkie Talkie *//

//Variables
item_wt_max <- 1;//max number of walkie talkies to spawn; note: more than 1 needs reworking in the code
item_wt_coordx <- [-920,-920,-320,-320,-96,24,-96,24,320,320,928,928];//potential x coords to spawn
item_wt_coordy <- [-96,128,24,8,56,56,-24,-24,24,8,128,-96];//y coords
item_wt_x_pm <- 56;//allowed variation in x coords
item_wt_y_pm <- 2;//allowed variation in y coords
item_wt_height <-216;//z coords to spawn walkie talkies
item_wt_enabled <- false;//if the walkie talkie is picked up and in effect
item_wt_was_first <- false;//if the walkie talkie was picked up before the (no trigger) console print

//Spawns walkie talkies in the platform
function itemsWT()
{
    for(local it = 0; it<item_wt_max; it++)
    {
        EntFireByHandle(self, "RunScriptCode", "itemsWTSpawn()", 0.1*it, null, null);
        EntFireByHandle(self, "RunScriptCode", "itemsWTMove()", (0.1*it)+0.05, null, null);
    }
}

//Fires walkie talkie template with delay
function itemsWTSpawn()
{
    EntFire("item_wt_template", "ForceSpawn", "", 0.0, null);
}

//Moves walkie talkie to defined coordinates
function itemsWTMove()
{
    local wt = Entities.FindByNameNearest("item_wt", Vector(392,-392,-808), 8);
    local index = RandomInt(0, item_wt_coordx.len()-1);
    EntFire("item_wt_button", "SetParent", "item_wt", 0.0, null);
    EntFireByHandle(wt, "AddOutput",
            "origin "+(item_wt_coordx[index]+RandomInt(-item_wt_x_pm,item_wt_x_pm))+
            " "+(item_wt_coordy[index]+RandomInt(-item_wt_y_pm,item_wt_y_pm))+" "+item_wt_height, 0.1, null, null);
    EntFireByHandle(wt, "AddOutput", "angles -90 "+RandomInt(0,359)+" 0", 0.2, null, null);
    EntFireByHandle(self, "RunScriptCode", "itemsWTBuzz()", 2.0, wt, null);//start the audible clue of walkie talkie position
}

//Give audible clue to the location of walkie talkie
function itemsWTBuzz()
{
    if(!item_wt_enabled)
    {
        local wt = entityFinder("item_wt");
        EntFireByHandle(self, "RunScriptCode", "soundPlay("+RandomInt(16,17)+",0)", 0.0, wt, null);
        EntFireByHandle(self, "RunScriptCode", "itemsWTBuzz()", RandomInt(13,17), wt, null);//Repeat again after some time
    }
}

//When the walkie talkie is picked up
function itemsWTPicked()
{
    EntFire("map_servercommand", "Command", "sv_disable_radar 0", 2.0, null);
    item_wt_enabled = true;
    if(!sp_end_area)    item_wt_was_first = true;//if walkie talkie is picked up before all trains arrive
    EntFireByHandle(self, "RunScriptCode", "itemsWTPickedChat()", 2.0, null, null);
    spIntroEnd();//fires in case walkie talkie is picked up after all trains arrive
    local wt = entityFinder("item_wt");
    //Kill any sound that is currently playing from the walkie talkie (prevents potential edict count inflate)
    local sound = Entities.FindByNameNearest("map_sfx", wt.GetOrigin(),1);
    if(sound!=null) EntFireByHandle(sound, "Kill", "", 0.5, null, null);
    EntFireByHandle(self, "RunScriptCode", "soundPlay(18,0)", 0.0, wt, null);
}

item_wt_chat_it <- 0;
item_wt_chat <- ["⠀\x08 [ ???? ]\x01 Good, I see you have survived the initial\x02 zombie outbreak",
                "⠀\x10 [ OPR ]\x01 I am the\x10 operator\x01 of the station, I control everything in my room here",
                "⠀\x10 [ OPR ]\x01 Anyhow, I am sure you are eager to get out of here. Let's do that by breaking the\x02 barriers\x01 for you",
                "⠀\x10 [ OPR ]\x01 I'd imagine you want to escape, but unfortunately I have to let\x02 all the trains arrive first",
                "⠀\x10 [ OPR ]\x01 Once they arrive, I will break the\x02 barriers\x01 for you"];
//Corresponding chatting function to itemsWTPicked()
function itemsWTPickedChat()
{
    if(item_wt_chat_it == item_wt_chat.len()) return;
    if(item_wt_chat_it == 2)
    {//different text depending on when walkie talkie is picked up
        if(item_wt_chat_it == 2 && sp_end_area == true)
        {//if walkie talkie is picked after all trains arrive
            ScriptPrintMessageChatAll(item_wt_chat[item_wt_chat_it]);
            return;
        }
        else    item_wt_chat_it = 3;//if walkie talkie is picked before all trains arrive
    }
    ScriptPrintMessageChatAll(item_wt_chat[item_wt_chat_it]);
    item_wt_chat_it++;
    EntFireByHandle(self, "RunScriptCode", "itemsWTPickedChat()", 4.0, null, null);
}

//-----------------------//
//**  Zombie Spawning  **//

//References
//[0] - subway platform area
//[1] - path alpha
//[2] - path bravo
//[3] - path charlie
//[4] - near finale area

//* Spawn Room *//

//* Mother Zombie *//

//Variables
zm_mz_hp <- 2500;//the limit to check the health of terrorist for mz; this can be configured by servers
zm_mz_found <- false;//bool; if a mz is found
zm_mz_checking <- false;//bool; checks if detectMZ() is being ran

//Detects if there are MZ in the map
function detectMZ()
{
    zm_mz_checking = true;
    local plyer = null;
    if(!zm_mz_found)
    {
        while((plyer = Entities.FindByClassname(plyer, "player"))!=null)
        {
            if(plyer.GetTeam()==2)
            {
                if(plyer.GetHealth()<zm_mz_hp)
                {//if a terrorist has non zombie-like hp (i.e. mz has not fired yet) then repeat the code again
                    EntFireByHandle(self, "RunScriptCode", "detectMZ()", 0.5, null, null);
                    return;
                }
                else
                {//Detect terrorist team with zombie-like hp
                    EntFireByHandle(self, "RunScriptCode", "spInitiate()", 1.0, null, null);
                    EntFire("debug", "Command", "echo Debug (MZ): MZ has been detected", 0.0, null);
                    //TP zombies away in case they spawn in with the humans
                    EntFire("tp_spawn_t", "AddOutput", "target dest_spwait", 0.0, null);
                    EntFire("tp_sp_zm_failsafe", "Enable", "", 0.1, null);
                    EntFire("tp_sp_zm_failsafe", "Kill", "", 2.0, null);
                    EntFire("spawn_premz_multiple", "Kill", "", 6.0, null);//Disable context removal trigger in spawn
                    EntFire("spawn_postmz_multiple", "Enable", "", 6.0, null);//Enable 'zombified' context trigger in spawn
                    EntFire("tp_spawn_failsafe", "Enable", "", 12.0, null);//Enable failsafe teleport in spawn
                    EntFire("spawn_failsafe_sprite", "ShowSprite", "", 12.0, null);//Enable failsafe sprite in spawn
                    EntFire("map_perished_timer", "Enable", "", 7.0, null);//Enable delayed infections for later zombies
                    EntFire("map_spawn_timer", "Enable", "", 6.0, null);
                    zm_mz_checking = false;
                    zm_mz_found = true;
                    return;
                }
            }
        }
        if(!zm_mz_found)
        {//if no mz was detected (i.e. all were CT) then repeat the code again
            EntFireByHandle(self, "RunScriptCode", "detectMZ()", 0.5, null, null);
        }
    }
}

//Checks if detectMZ() is running; this is a fail-safe function in case detectMZ() fails to detect a valid MZ and quits prematurely
function checkDetectMZ()
{
    if(zm_mz_found)
    {
        EntFire("debug", "Command", "echo Debug (MZ): MZ was found successfully. Ending MZ failsafe", 0.0, null);
        return;//The map found MZ already and has stopped the MZ check (normal operation)
    }
    if(zm_mz_checking && !zm_mz_found)
    {//Map is still looking for a MZ; do another check after 1 seconds (normal operation)
        EntFire("debug", "Command", "echo Debug (MZ): Map is still searching for MZ", 0.0, null);
        EntFireByHandle(self, "RunScriptCode", "checkDetectMZ()", 1.0, null, null);
        return;
    }
    //From here this should not be happening in normal circumstances; in case a MZ was not found and the check function somehow ends, re fire the check function
    EntFire("debug", "Command", "echo Debug (MZ): MZ search has failed. Enabling failsafe mechanism", 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "detectMZ()", 0.0, null, null);//Rerun the MZ check
    EntFireByHandle(self, "RunScriptCode", "checkDetectMZ()", 1.0, null, null);//Continue with the failsafe
}

//* Infected *//

//Variables
perished_tp <- Vector(0,-304,-1032);//coords to spawn freshly infected zombies
perished_hp <- 1250;//HP of zombies when infected
perished_text <- "You have perished...\nYou will spawn with less HP and with no HP regen";

//As a player gets infected, put a timeout before they can infect others
function perished()
{
    if(activator == null)   return;
    //Choose sfx to play
    local index = RandomInt(0,4);
    EntFireByHandle(self, "RunScriptCode", "soundPlay("+index+",0)", 0.0, activator, null);
    local origin = activator.GetOrigin();
    //Tp player away, and back at their position 5s later
    EntFireByHandle(activator, "AddOutput", "Origin "+perished_tp.x+" "+perished_tp.y+" "+perished_tp.z, 0.02, null, null);
    EntFireByHandle(activator, "AddOutput", "Origin "+origin.x+" "+origin.y+" "+origin.z, 5.0, null, null);
    //Give player infected context filter
    EntFireByHandle(activator, "AddContext", "zombified:1", 0.0, null, null);
    //Disable HP regen + set HP to perished_hp
    activator.SetHealth(perished_hp);
    EntFireByHandle(self, "RunScriptCode", "noZmHpRegen(0.5)", 0.05, activator, null);
    //Spawn particle on infected player's location
    local particle_maker = entityFinder("zm_perished_maker");
    particle_maker.SpawnEntityAtLocation(origin, Vector(0,0,0));
    local particle = Entities.FindByClassnameNearest("info_particle_system", origin, 1);
    EntFireByHandle(particle, "Kill", "", 10.0, null, null);
}

//Pritns game_text to let know first infection / perished mechanism
function perishedText()
{
    EntFire("map_zm_text", "SetText", "A human has been infected\nThey will respawn as ZM at their last position", 0.0, null);
    EntFire("map_zm_text", "Display", "", 0.02, null);
}

//* AFK TP *//

//Variables
zm_spawn_sp1 <- false;
zm_spawn_sp2 <- false;
zm_spawn_sp3 <- false;
zm_spawn_a1 <- false;
zm_spawn_a2 <- false;
zm_spawn_a_tw1 <- false;
zm_spawn_a_tw2 <- false;
zm_spawn_b1 <- false;
zm_spawn_b_gr1 <- false;
zm_spawn_b_gr2 <- false;
zm_spawn_c1 <- false;
zm_spawn_c_sv1 <- false;
zm_spawn_c_sv2 <- false;
zm_spawn_c_sv3 <- false;

//Moves zombie AFK TP to desired postition
//Inputs: area - in which area the spawn is
function  enableAFKTP(area)
{
    switch(area)
    {
    case 0:
    {
        //Activate teleport to subway platform area
        EntFire("tp_zm_spawn_sp", "Enable", "", 1.0, null);
        EntFire("zm_spawn_sp_sprite", "ShowSprite", "", 0.0, null);
        if(zm_spawn_sp1)
        {//stair approach from east
            openZMDoors("zm_sp_spawn1");
            openZMDoors("zm_sp_spawn2");
            EntFire("tp_zm_spawn_sp", "AddOutput", "target dest_zm_sp1", 1.0, null);
        }
        if(zm_spawn_sp2)
        {//stair approach from west
            openZMDoors("zm_sp_spawn3");
            openZMDoors("zm_sp_spawn4");
            EntFire("tp_zm_spawn_sp", "AddOutput", "target dest_zm_sp2", 1.0, null);
        }
        if(zm_spawn_sp1 && zm_spawn_sp2)  EntFire("tp_zm_spawn_sp", "AddOutput", "target dest_zm_sp*", 1.0, null);//stair approach from both directions
        if(zm_spawn_sp3)
        {//split area before 3 paths
            openZMDoors("zm_sp_spawn5");
            openZMDoors("zm_sp_spawn6");
            EntFire("tp_zm_spawn_sp", "AddOutput", "target dest_zm_up_sp", 1.0, null);
        }
        return;
    }
    //Activated teleport to 3 paths; remove tp to subway platform area
    EntFire("tp_zm_spawn_sp", "Kill", "", 0.0, null);
    EntFire("zm_spawn_sp_sprite", "Kill", "", 0.0, null);
    case 1:
    {//path alpha
        //Activate teleport in path alpha
        EntFire("tp_zm_spawn_a", "Enable", "", 1.0, null);
        EntFire("zm_spawn_a_sprite", "ShowSprite", "", 0.0, null);
        if(zm_spawn_a1)
        {//office corridors
            openZMDoors("zm_a_spawn1");
            openZMDoors("zm_a_spawn2");
            EntFire("tp_zm_spawn_a", "AddOutput", "target dest_zm_a1", 1.0, null);
        }
        if(zm_spawn_a2)
        {//2 way split hallway
            openZMDoors("zm_a_spawn3");
            openZMDoors("zm_a_spawn4");
            EntFire("tp_zm_spawn_a", "AddOutput", "target dest_zm_a2", 1.0, null);
        }
        if(zm_spawn_a_tw1)
        {//top floor before mg
            openZMDoors("zm_a_spawn5");
            openZMDoors("zm_a_spawn6");
            EntFire("tp_zm_spawn_a", "AddOutput", "target dest_zm_a_tw1", 1.0, null);
        }
        if(zm_spawn_a_tw2)
        {//bottom floor before mg
            openZMDoors("zm_a_spawn7");
            openZMDoors("zm_a_spawn8");
            EntFire("tp_zm_spawn_a", "AddOutput", "target dest_zm_a_tw2", 1.0, null);
        }
        if(zm_spawn_a_tw1 && zm_spawn_a_tw2)
            EntFire("tp_zm_spawn_a", "AddOutput", "target dest_zm_a_tw*", 1.0, null);
        return;
    }
    case 2:
    {//path bravo
        //Activate teleport to path bravo
        EntFire("tp_zm_spawn_b", "Enable", "", 1.0, null);
        EntFire("zm_spawn_b_sprite", "ShowSprite", "", 0.0, null);
        if(zm_spawn_b1)
        {//corridor before sewer tunnel
            openZMDoors("zm_b_spawn1");
            openZMDoors("zm_b_spawn2");
            EntFire("tp_zm_spawn_b", "AddOutput", "target dest_zm_b1", 1.0, null);
        }
        if(zm_spawn_b_gr1)
        {//wide hallway after tunnel
            openZMDoors("zm_b_spawn3");
            EntFire("tp_zm_spawn_b", "AddOutput", "target dest_zm_b_gr1", 1.0, null);
        }
        if(zm_spawn_b_gr2)
        {//near minigame room
            openZMDoors("zm_b_spawn4");
            openZMDoors("zm_b_spawn5");
            EntFire("tp_zm_spawn_b", "AddOutput", "target dest_zm_b_gr2", 1.0, null);
        }
        if(zm_spawn_b_gr1 && zm_spawn_b_gr2)
            EntFire("tp_zm_spawn_b", "AddOutput", "target dest_zm_b_gr*", 1.0, null);//both tp after tunnel
        return;
    }
    case 3:
    {//path charlie
        //Activate teleport to path charlie
        EntFire("tp_zm_spawn_c", "Enable", "", 1.0, null);
        EntFire("zm_spawn_c_sprite", "ShowSprite", "", 0.0, null);
        if(zm_spawn_c1)
        {//door before subway tunnel
            openZMDoors("zm_c_spawn1");
            openZMDoors("zm_c_spawn2");
            EntFire("tp_zm_spawn_c", "AddOutput", "target dest_zm_c1", 1.0, null);
        }
        if(zm_spawn_c_sv1)
        {//in subway tunnel
            openZMDoors("zm_c_spawn3");
            openZMDoors("zm_c_spawn4");
            EntFire("tp_zm_spawn_c", "AddOutput", "target dest_zm_c_sv1", 1.0, null);
        }
        if(zm_spawn_c_sv2)
        {//small corridor near minigame room
            openZMDoors("zm_c_spawn5");
            EntFire("tp_zm_spawn_c", "AddOutput", "target dest_zm_c_sv2", 1.0, null);
        }
        if(zm_spawn_c_sv1 && zm_spawn_c_sv2)
            EntFire("tp_zm_spawn_c", "AddOutput", "target dest_zm_c_sv*", 1.0, null);//both in/after subway tunnel
        if(zm_spawn_c_sv3)
        {//large corridor near the server room-lift exit
            openZMDoors("zm_c_spawn6");
            openZMDoors("zm_c_spawn7");
            EntFire("tp_zm_spawn_c", "AddOutput", "target dest_zm_c_sv3", 1.0, null);
        }
        return;
    }
    default:
    {//after triggering final gate; remove all teleport to 3 paths
    EntFire("tp_zm_spawn_a", "Kill", "", 0.0, null);
    EntFire("zm_spawn_a_sprite", "Kill", "", 0.0, null);
    EntFire("tp_zm_spawn_b", "Kill", "", 0.0, null);
    EntFire("zm_spawn_b_sprite", "Kill", "", 0.0, null);
    EntFire("tp_zm_spawn_c", "Kill", "", 0.0, null);
    EntFire("zm_spawn_c_sprite", "Kill", "", 0.0, null);
    //Enable teleport to near finale area
    EntFire("tp_zm_spawn_nf", "Enable", "", 0.0, null);
    EntFire("zm_spawn_nf_sprite", "ShowSprite", "", 0.0, null);
    EntFire("tp_zm_spawn_nf", "AddOutput", "target dest_zm_nf*", 0.0, null);
    }
    }
}

//Opens the door for ZM spawning room
//Inputs: name - name of the door in string
function openZMDoors(name)
{
    local rotate = entityFinder(name);
    if(rotate == null)  return;
    EntFire(name, "Open", "", 0.0, null);
    //Clear the parent on doors and kill the func_rotating
    local door = Entities.FindByClassnameNearest("prop_dynamic", rotate.GetOrigin(), 140);
    EntFireByHandle(door, "ClearParent", "", 2.0, null, null);
    EntFire(name, "Kill", "", 2.5, null);
}

//* Forward Spawns *//

//REWORKED IN V2
//* More flexibility by adding separate addition and removal function for valid forward spawn coordinates
//* Likely to be more resource demanding

//Variables
zm_fsp_coords <- ["-128 160 520", "-224 648 624", "624 736 704", "-112 1712 704"];//coordinates for f(orward) zombie spawns in subway platform area
zm_fa_coords <- [   "-1336 1504 704","-1160 1832 704","-816 1616 704","-1080 2296 704","-648 2272 704",
                    "-16 2264 624","424 2272 624","-224 2536 624","64 3456 432"];//coordinates for f(orward) zombie spawns in path alpha area
zm_fb_coords <- [   "-1312 2536 176","-2024 2520 168","-2768 2016 168","-2656 3240 168"];//coordinates for f(orward) zombie spawns in path bravo area
zm_fc_coords <- [   "848 1520 -104","760 896 -104","1312 896 -120","1312 1872 -120","544 3688 -120",
                    "-224 4456 -120"];//coordinates for f(orward) zombie spawns in path charlie area
zm_fnf_coords <- ["-560 6408 712","-864 6600 712","-1072 6608 1096"];//coordinates for f(orward) zombie spawns in near finale area
zm_ftp_ply_list <- [];//stores handles to players who have forward spawned
zm_ftp_tp_list <- [];//stores valid forward spawn coordinates
zm_ftp_text <- "You have been forward spawned\nSpawn with less HP + no HP regen + humans can see your presence";
zm_ftp_hp <- 750;//health of zombies who teleport forward

//Teleports a zombie at designated forward spawn coords
function forwardTP()
{
    if(activator==null)
        return;
    //Creates an array to choose which area to spawn
    if(zm_ftp_tp_list.len()==0)
    {//back-up exit in case the function is called when it shouldn't be
        checkFTP();
        return;
    }
    local coords = zm_ftp_tp_list[RandomInt(0,zm_ftp_tp_list.len()-1)];
    removeFTP(coords);
    EntFireByHandle(activator, "AddOutput", "origin "+coords, 0, null, null);
    if(detectFTP(activator))
    {
        //Enable ZM disadvantages
        activator.SetHealth(zm_ftp_hp);
        EntFireByHandle(self, "RunScriptCode", "noZmHpRegen(0.5)", 0, activator, null);
        //Display disadvantage to the player
        EntFire("map_ftp_text", "Display", "", 0, null);
        //Create glow around zombie every 5s
        EntFire("zm_ftp_template", "ForceSpawn", "", 0, null);
        EntFireByHandle(self, "RunScriptCode", "alertFTP()", 0.02, activator, null);
        //Save the player handle to the list
        zm_ftp_ply_list.append(activator);
    }
    else
        printl("Debug (FTP): player already has forward spawned")
}

//Checks if foward TP should be enabled; i.e. if there are valid coords to tp to
function checkFTP()
{
    if(zm_ftp_tp_list.len()!=0)
    {//Enable TP if there are valid coords
        EntFire("tp_zm_spawn_ft", "Enable", "", 0.0, null);
        EntFire("zm_spawn_ft_sprite", "ShowSprite", "", 0.0, null);
        foreach(i in zm_ftp_tp_list)
            printl(i);
    }
    else
    {//Don't if there aren't
        EntFire("tp_zm_spawn_ft", "Disable", "", 0.0, null);
        EntFire("zm_spawn_ft_sprite", "HideSprite", "", 0.0, null);
    }
}

//Adds valid forward TP points to zm_ftp_tp_list
//Inputs: start_index - initial index to add tp in zm_<area>_coords
//        end_index - final index to add tp in zm_<area>_coords
//        area - designates which area to apply to
function addFTP(start_index, end_index, area)
{
    for(local i=start_index;i<end_index;i++)
    {
        switch(area)
        {
            case 0: if(doesFTPExist(zm_fsp_coords[i])==-1)
            {//subway platform
                zm_ftp_tp_list.append(zm_fsp_coords[i]);
                break;
            }
            case 1: if(doesFTPExist(zm_fa_coords[i])==-1)
            {//path alpha
                zm_ftp_tp_list.append(zm_fa_coords[i]);
                break;
            }
            case 2: if(doesFTPExist(zm_fb_coords[i])==-1)
            {//path beta
                zm_ftp_tp_list.append(zm_fb_coords[i]);
                break;
            }
            case 3: if(doesFTPExist(zm_fc_coords[i])==-1)
            {//path charlie
                zm_ftp_tp_list.append(zm_fc_coords[i]);
                break;
            }
            case 4: if(doesFTPExist(zm_fnf_coords[i])==-1)
            {//near finale
                zm_ftp_tp_list.append(zm_fnf_coords[i]);
                break;
            }
        }
    }
    EntFireByHandle(self, "RunScriptCode", "checkFTP()", 0.02, null, null);//Updates the FTP list and removes the coords
}

//Removes forward TP points from zm_ftp_tp_list by tp and area indices
//Inputs: start_index - initial index to remove tp from zm_<area>_coords
//        end_index - final index to remove tp from zm_<area>_coords
//        area - designates which area to apply to
function removeFTPIndex(start_index, end_index, area)
{
    for(local index=start_index;index<end_index;index++)
    {
        local coord = null;
        switch(area)
        {
            case 0:
            {//subway platform
                coord = zm_fsp_coords[index];
                break;
            }
            case 1:
            {//path alpha
                coord = zm_fa_coords[index];
                break;
            }
            case 2:
            {//path beta
                coord = zm_fb_coords[index];
                break;
            }
            case 3:
            {//path charlie
                coord = zm_fc_coords[index];
                break;
            }
            case 4:
            {//near finale
                coord = zm_fnf_coords[index];
                break;
            }
        }
    removeFTP(coord);
    }
}

//Removes forward TP points from zm_ftp_tp_list
//Inputs: coord - the coordinates of forward tp point
function removeFTP(coord)
{
    if(coord == null)
        return;
    local index = doesFTPExist(coord);
    if(index!=-1)
    {
        zm_ftp_tp_list.remove(index);
        EntFireByHandle(self, "RunScriptCode", "checkFTP()", 0.02, null, null);//Updates the FTP list and removes the coords
        return;
    }
}

//Checks if coord is already added to zm_ftp_tp_list, and returns its index (-1 if it does not exist)
function doesFTPExist(coord)
{
    for(local it=0;it<zm_ftp_tp_list.len();it++) if(zm_ftp_tp_list[it]==coord)
        return  it;
    return -1;
}


//Separate addFTP() function for near-finale area; Prevents FTP at the elevators if the gate is triggered by humans
function addFTPNF()
{
    if(!trig_humans_at_finale)
        addFTP(0,2,4);
}

//Creates glow around zombie every 5s
function alertFTP()
{
    local prop = Entities.FindByNameNearest("zm_ftp_glow", Vector(426,80,-822),16);
    if(detectFTP(activator))//zombie should stop having glow (when recurssive func. missed their death)
        return;
    if(activator==null || activator.GetHealth() < 1)
    {//Sstop if the zombie is dead
        EntFireByHandle(self, "RunScriptCode", "removeFTPGlow()", 0.0, activator, null);
        EntFireByHandle(prop, "Kill", "", 0.0, null, null);
        return;
    }
    if(RandomInt(0,1))//Toggle between crouch and standing animations
        EntFireByHandle(prop, "SetAnimation", "Idle_lower", 0.0, null, null);
    //Set position + angle relative to zombie
    prop.SetOrigin(activator.GetOrigin());
    local angles = activator.GetAngles();
    prop.SetAngles(angles.x, angles.y, angles.z);
    //Activates glow, updates their position after 5s
    EntFireByHandle(prop, "SetGlowEnabled", "", 0.1, null, null);
    EntFireByHandle(prop, "Kill", "", 5.1, null, null);
    EntFire("zm_ftp_template", "ForceSpawn", "", 4.98, null);
    EntFireByHandle(self, "RunScriptCode", "alertFTP()", 5.0, activator, null);
}

//Checks if the zombie is still valid for FTP glow, and returns bool to quit the function
function detectFTP(handle)
{
    local quit = true;
    //Detect if the zombie should no longer be having the glow
    foreach(it in zm_ftp_ply_list)  if(it == handle)
    {//zombie should still have glow
        quit = false;
        return quit;
    }
    return quit;
}

//Failsafe; Removes glow around forward spawned zombies when they spawn after they die
function removeFTPGlow()
{
    if(!activator)
        return;
    for(local it = 0; it < zm_ftp_ply_list.len(); it++)    if(zm_ftp_ply_list[it] == activator)
    {//remove the zombie from zm_ftp_ply_list
        zm_ftp_ply_list.remove(it);
        return;
    }
}

//Pritns game_text to let know forward spawn mechanism
function textFTP()
{
    EntFire("map_zm_text", "SetText", "ZM forward spawn is now activated\nDetect their presence with red glow", 0.0, null);
    EntFire("map_zm_text", "Display", "", 0.02, null);
}

//* HP Regen *//

//Variables
zm_hp_regen_tick <- 1.5;//time in seconds to check for HP regen

//Disables HP Regen by comparing the HP in the previous tick; does not actual restricts regen, but ensures HP is always decreasing
//Inputs: prev_hp - previous hp that a player had in the previous tick
function noZmHpRegen(prev_hp)
{
    if(activator == null)   return;
    local current_hp = activator.GetHealth();
    if(current_hp < 1 || activator.GetTeam() != 2)  return;//quit if the player is dead or not a terrorist anymore
    if(prev_hp==0.5)    prev_hp = current_hp;//change prev_hp to current health when function has just been initiated
    if(prev_hp < current_hp)    current_hp = prev_hp;//prevent hp regeneration
    activator.SetHealth(current_hp);
    EntFireByHandle(self, "RunScriptCode", "noZmHpRegen("+current_hp+")", zm_hp_regen_tick, activator, null);//repeat again after zm_hp_regen_tick seconds
}

//------------------//
//**  Triggering  **//

//REWORKED IN V2
//* Allows dynamic spawning of walkie talkie triggers
//* Allows modification of trigger I/O via vscript with trigger_funcs.nut
//* More clarity for players by making the walkie talkie stay on a bit longer after the door has opened (killed 5 s after door opens)

//Note; unless pre-defined, the triggers for door and etc. will be done by relaying via walkie talkie to the operator

//Variables
trig_chat <- ["⠀\x10 [ OPR ]\x01 I will get that for you. Just a second...",
            "⠀\x10 [ OPR ]\x01 I got you. Give me a moment...",
            "⠀\x10 [ OPR ]\x01 No problem. It will open up soon...",
            "⠀\x10 [ OPR ]\x01 Got it. I am working on it...",
            "⠀\x10 [ OPR ]\x01 This? I got it...",
            "⠀\x10 [ OPR ]\x01 I see you. Let me get that for you..."];
trig_chat_long <- ["⠀\x10 [ OPR ]\x01 This will take a while, just hold on tight...",
                    "⠀\x10 [ OPR ]\x01 That is going to be hard, but I think I got it...",
                    "⠀\x10 [ OPR ]\x01 One second... actually give me more time...",
                    "⠀\x10 [ OPR ]\x01 This is going to be hard to operate, just defend for now...",
                    "⠀\x10 [ OPR ]\x01 That... will take some time. Let me work on it...",
                    "⠀\x10 [ OPR ]\x01 This is a bit complex to get it open. I need some time..."];
trig_vary <- 0.1;//% of how much the input time should be varied by
trig_add_delay <- 0;//additional delay if zombies break the transmitter
trig_humans_at_finale <- false;
trig_wt_template <- Vector(424,-392,-808);
trig_queue <- [];//queue of triggers to be spawned
trig_spawning <- false;//if spawnTrigger() is already in process
trig_radius <- 128;//radius in units to find the nearby door/movelinear
trig_default_duration <- 10;//default value in seconds for trigger durations
trig_functions <- [ "trigSPBigGateWest" ,"trigSPBigGateEast"    ,"trigSPPreSplit"   ,"trigSPA"      ,"trigSPB"          ,//array of functions to connect via ConnectOutput
                    "trigSPC"           ,"trigAOffice1"         ,"trigAOffice2"     ,"trigAOffice3" ,"trigASp"          ,
                    "trigBSewer1"       ,"trigBSewer2" 	        ,"trigBSewer3"      ,"trigBSewer4"  ,"trigCSubway1"     ,
                    "trigCSubwayMid"    ,"trigCSubwayEnd"       ,"trigCServerLift"];

//Separate function to spawn in walkie talkie trigger with delay
function spawnTriggerTemplate()
{
    EntFire("trig_template", "ForceSpawn", "", 0.0, null);
}

//Adds a trigger spawn to the queue
function addTrigToQueue(coordx,coordy,coordz,duration,func_index)
{
    local temp = [coordx,coordy,coordz,duration,func_index];
    trig_queue.append(temp);
    EntFireByHandle(self, "RunScriptCode", "spawnTrigger(1)", 0.1, null, null);
}

//Function to spawn in triggers in trig_queue
//Inputs: mode - 0; maintain (recursive func), 1; new (called by addTrigToQueue())
function spawnTrigger(mode)
{
    if(trig_queue.len()==0)
    {
        printl("Debug (Trigger): Queue ended");
        trig_spawning <- false;
        return;
    }
    if(mode)
    {
        if(trig_spawning)
        {
            printl("Debug (Trigger): spawning already in process");
            return;
        }
        else
            printl("Debug (Trigger): Queue detected; started trigger spawning");
    }
    trig_spawning <- true;
    EntFireByHandle(self, "RunScriptCode", "spawnTriggerTemplate()", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "assignTrigger("+trig_queue[0][0]+","+trig_queue[0][1]+","+trig_queue[0][2]+","+trig_queue[0][3]+","+trig_queue[0][4]+")", 0.1, null, null);
    trig_queue = trig_queue.slice(1);
    EntFireByHandle(self, "RunScriptCode", "spawnTrigger(0)", 0.5, null, null);
}

//Spawns a walkie talkie at a given coordinates with a given trigger duration
//Inputs: coord - coordinates to spawn the trigger at
//        duration - how long the trigger should take to open a door
//        func_index - if present, the button will link to a function via ConnectOutput
function assignTrigger(coordx,coordy,coordz,duration,func_index)
{
    local button = Entities.FindByNameNearest("trig_button", trig_wt_template, 16);
    //If the button has a function to connect to
    local sprite = Entities.FindByNameNearest("trig_sprite", trig_wt_template, 16);
    //Add the duration information to the button
    button.ValidateScriptScope();
    button.GetScriptScope().time <- duration;
    if(func_index!=-1)
        button.GetScriptScope().func <- func_index;
    //Move the button to the specified location
    EntFireByHandle(button, "AddOutput", "origin "+coordx+" "+coordy+" "+coordz, 0.1, null, null);
    EntFireByHandle(sprite, "AddOutput", "origin "+coordx+" "+coordy+" "+coordz, 0.1, null, null);
}

//Opens nearby func_movelinear's or prop_door_rotating's, with a random variability to the given time (10% of time input)
//Note, the time is given by the caller (most likely a func_button) itself
//Note, there really isn't any rigorous checking if it is a valid trigger to open so it needs manual testing (by tweaking trig_radius)
function openTrigger()
{
    local triggers = [];
    local trigger = null;
    while(null!=(trigger=(Entities.FindByClassnameWithin(trigger, "func_movelinear", caller.GetOrigin(), trig_radius))))
        triggers.append(trigger)
    while(null!=(trigger=(Entities.FindByClassnameWithin(trigger, "prop_door_rotating", caller.GetOrigin(), trig_radius))))
        triggers.append(trigger)
    if(triggers.len()==0)
    {//if the function still cannot find the door, return the function
        printl("Debug (Trigger): Function could not find a valid trigger");
        EntFire("debug", "Command", "echo Debug (Trigger): Function could not find a valid trigger to open", 0.0, null);
        return
    }
    EntFireByHandle(self, "RunScriptCode", "soundPlay(18, 0)", 0.0, caller, null);
    local sprite = Entities.FindByClassnameNearest("env_sprite", caller.GetOrigin(), trig_radius);
    local delay = 0
    if(("time" in caller.GetScriptScope()))
        delay = ((caller.GetScriptScope().time).tointeger() + RandomFloat(-(caller.GetScriptScope().time).tointeger()*trig_vary,(caller.GetScriptScope().time).tointeger()*trig_vary)).tointeger() + trig_add_delay;
    else
    {//if caller has no time information, set the default value of 10
        EntFire("debug", "Command", "echo Debug (Trigger): caller has no valid time; setting to "+trig_default_duration+" seconds", 0.0, null);
        delay = trig_default_duration;
    }
    //if the button has a function to call
    if(("func" in caller.GetScriptScope()))
        EntFire("map_func_script", "RunScriptCode", trig_functions[caller.GetScriptScope().func]+"()", 0.0, null);
    //Kill the button
    EntFireByHandle(caller, "Kill", "", 0.0, null, null);
    //Reduce the opacity of sprite, kill it 5 sec after door(s) opens
    EntFireByHandle(sprite, "Alpha", "100", 0.0, null, null);
    EntFireByHandle(sprite, "Kill", "", delay+5, null, null);
    //Display random chat message
    if(delay>10)
    {//if delay is longer than 10s, also print 5s remaining text
        ScriptPrintMessageChatAll(trig_chat_long[RandomInt(0,trig_chat_long.len()-1)]);
        EntFireByHandle(self, "RunScriptCode", "triggerFiveSeconds()", delay-5, null, null);
    }
    else    ScriptPrintMessageChatAll(trig_chat[RandomInt(0,trig_chat.len()-1)]);
    //Open triggers listed in 'triggers' array
    foreach(trigger in triggers)
        EntFireByHandle(trigger, "Open", "", delay, null, null);
    printl("Debug (Trigger): Triggering in "+delay+" seconds");
    //shoddy way of removing entity_blocker generated by prop_door_rotating; i *think* they are created if the prop clips into the world during opening animation
    EntFire("entity_blocker*", "Kill", "", delay+5, null);
}

//Warn the players if a door/linear that took more than 10 seconds is about to trigger in 5 seconds
function triggerFiveSeconds()
{
    ScriptPrintMessageChatAll("⠀\x10 [ OPR ]\x01 About\x02 5 seconds\x01 more...");
}

//Detects if a zombie is interacting with the walkie-talkie, and prevent them from doing so
function detectZMTrigger()
{
    if(!activator || activator.GetTeam() == 2)
    {//If zombie is triggering, ignore their commands
        local coords = caller.GetOrigin();
        local button = Entities.FindByNameNearest("trig_button", coords, 16);
        local sprite = Entities.FindByNameNearest("trig_sprite", coords, 16);
        EntFireByHandle(button, "Kill", "", 0.0, null, null);
        EntFireByHandle(sprite, "Kill", "", 0.0, null, null);
        spawnTrigger(buttonOrigin(coords.x),buttonOrigin(coords.y),buttonOrigin(coords.z),caller.GetScriptScope().time,caller.GetScriptScope().func);//yes, this is making an identical button. why? because source fucking breaks with the more sensible method
        printl("Debug (Trigger): ZM detected on the trigger, creating a new one...");
    }
    else
        EntFireByHandle(self, "RunScriptCode", "openTrigger()", 0.0, null, caller);
}

//Detects if a zombie is interacting various interactables, and prevent them from doing so
function detectZMInteract()
{
    if(activator && activator.GetTeam() == 3)
        EntFireByHandle(caller, "FireUser1", "", 0.0, null, null);
}

//Gives int value for a given value
//Note, this is specific to detectZMTrigger()
function buttonOrigin(val)
{
    if(val>0)
        val = ceil(val);
    else
        val = floor(val);
    return val;
}

//Detects if a zombie reached the finale area before the humans, and closes off the gates so the humans have time to catch up
//Note, this only works if zombies are the first to reach; if humans reach first from other paths, then this function will not fire
function detectZMatFinale()
{
    if(trig_humans_at_finale || activator == null)   return;
    if(activator.GetTeam() == 2)    EntFireByHandle(caller, "FireUser1", "", 0.0, null, null);
}

//------------------//
//**  Cinematics  **//

//*  Intro *//

//Variables
intro_speed <- 320;//speed of movelinear
intro_sequences <- 25;//amount of sequences needed
intro_sequence_time <- 1;//duration (sec) of each movelinear sequence
intro_sequence_it <- 0;//iterator for intro sequences
intro_rail_coords <- -704;//position of intro rail tracks
intro_rail_height <- 164;//height of intro rail tracks
intro_train_spawn_coords <- [592,1104,1616];//coordinates to spawn

//Starts the intro sequence
function startIntro()
{
    //Start intro fog
    EntFire("map_fade", "Fade", "", 0.0, null);
    //Enable camera for players
    EntFire("intro_camera", "Enable", "", 1.0, null);
    EntFireByHandle(self, "RunScriptCode", "introSequence()", 2.0, null, null);
    //Play sounds
    EntFireByHandle(self, "RunScriptCode", "musicPlay(0,0)", 3.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "soundPlay(9,0)", 1.0, entityFinder("intro_camera"), null);
    //Disable radar for  i m m e r s i o n
    EntFire("map_servercommand", "Command", "sv_disable_radar 1", 1.0, null);
}

//Moves the func_movelinear; also sets fade between each sequence due to visual glitching
function moveMovelinear()
{
    //In case the movelinear somehow resets its properties
    EntFire("intro_cinematics", "AddOutput", "speed 320", 0.0, null);
    EntFire("intro_cinematics", "AddOutput", "origin 0 -864 288", 0.0, null);
    EntFire("intro_cinematics", "Open", "", 0.0, null);
    //Fade between each sequence
    EntFire("map_intro_midfade", "Fade", "", 0.85, null);
    EntFire("map_intro_midfade", "FadeReverse", "", 1.0, null);
    //Toggle black texture to fix flickering issue
    EntFire("intro_texture_black", "Toggle", "", 0.9, null);
    EntFire("intro_texture_black", "Toggle", "", 1.0, null);
    EntFireByHandle(self, "RunScriptCode", "introSequence()", 0.0, null, null);
}

//Commands for each sequence
function introSequence()
{
    if(intro_sequence_it==intro_sequences)
    {//quit intro
        EntFire("map_servercommand", "Command", "sv_disable_radar 0", 0.0, null);
        EntFire("intro_camera", "Disable", "", 0.0, null);
        //Hold fog until round over
        EntFire("map_fade", "AddOutput", "duration 0", 0.0, null);
        EntFire("map_fade", "AddOutput", "holdtime 60", 0.0, null);
        EntFire("map_fade", "FadeReverse", "", 0.0, null);
        //Set next stage (main map)
        EntFire("map_level_counter", "SetValueNoFire", "2", 0.0, null);
        EntFire("map_round", "EndRound_Draw", "5", 2.0, null);
        return;
    }
    //Starts the intro sequences on screen
    if(intro_sequence_it==5)
    {//lameskydiver/chinny presents
        EntFire("intro_texture1", "Toggle", "", 0.0, null);
        EntFire("intro_texture1", "Toggle", "", 3.0, null);
    }
    if(intro_sequence_it==10)
    {//mapea 2022 context
        EntFire("intro_texture2", "Toggle", "", 0.0, null);
        EntFire("intro_texture2", "Toggle", "", 4.0, null);
    }
    if(intro_sequence_it==14)
    {//train passing by
        EntFireByHandle(self, "RunScriptCode",
                        "spawnCheapTrain("+intro_train_spawn_coords[0]+","+intro_rail_coords+","+intro_rail_height+",0)", 0.0, null, null);//function from platform section
        EntFireByHandle(self, "RunScriptCode",
                        "spawnCheapTrain("+intro_train_spawn_coords[1]+","+intro_rail_coords+","+intro_rail_height+",0)", 0.0, null, null);
        EntFireByHandle(self, "RunScriptCode",
                        "spawnCheapTrain("+intro_train_spawn_coords[2]+","+intro_rail_coords+","+intro_rail_height+",0)", 0.0, null, null);
        EntFire("train_prop_cheap", "SetParent", "intro_linear", 0.02, null);
        EntFire("intro_linear", "AddOutput", "speed 1200", 0.02, null);
        EntFire("intro_linear", "Open", "", 0.04, null);
    }
    if(intro_sequence_it==16)
    {// E N D E M I C
        EntFire("intro_texture3", "Toggle", "", 0.0, null);
        EntFire("intro_texture3", "Toggle", "", 5.0, null);
    }
    EntFireByHandle(self, "RunScriptCode", "moveMovelinear()", intro_sequence_time, null, null);
    intro_sequence_it++;
}

//-----------------------//
//**  Subway Platform  **//

//References
//[0] - spawn a train at south platform
//[1] - spawn a train at north platform
//[2/3] - spawn two trains at both platforms
//[4] - spawn train after the intro sequence

//Variables
sp_rail_east_coords <- -288//coordinates of rail tracks
sp_rail_west_coords <- 320//coordinates of rail tracks
sp_rail_height <- 172;//height of rail tracks
sp_coords <- [-1760, -2272, -2784, -3296, 1760, 2272, 2784, 3296];//initial coordinates to spawn trains on the rails; first 4 is for eastbound, latter 4 westbound
sp_parked_coords <- [-768, -256, 256, 768];//coordinates to spawn trains on parked platform
sp_positions <- ["bottom", "top", "bottom_simult", "top_simult"];//which side of platform to interact with; latter two spawn trains at same time
sp_ambience_coords <- [-768,-256,256,768];//coordinates to spawn ambient_generics
sp_ambience_top_bottom_coords <- [-112, 144];
sp_ambience_height <- 320;//height to spawn ambient_generics
sp_door_index <- [];

//Starts sequence of train approaching the platform
//Inputs: index - index describing which platform
function platformApproach(index)
{
    local rail_coords = sp_rail_east_coords;
    local coord_index = 0;
    if(index==1 || index==3)
    {//If the train spawns at northern platform instead
        rail_coords = sp_rail_west_coords;
        coord_index = 4
    }
    //Spawn in the train models
    EntFireByHandle(self, "RunScriptCode",
                        "spawnCheapTrain("+sp_coords[coord_index]+","+rail_coords+","+sp_rail_height+","+index+")", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode",
                        "spawnCheapTrain("+sp_coords[coord_index+1]+","+rail_coords+","+sp_rail_height+","+index+")", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode",
                        "spawnCheapTrain("+sp_coords[coord_index+2]+","+rail_coords+","+sp_rail_height+","+index+")", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode",
                        "spawnCheapTrain("+sp_coords[coord_index+3]+","+rail_coords+","+sp_rail_height+","+index+")", 0.0, null, null);
    //Attach to the existing movelinear
    EntFireByHandle(self, "RunScriptCode", "attachTrainStart(0,"+index+")", 0.02, null, null);
    EntFireByHandle(self, "RunScriptCode", "attachTrainStart(1,"+index+")", 0.02, null, null);
    EntFireByHandle(self, "RunScriptCode", "attachTrainStart(2,"+index+")", 0.02, null, null);
    EntFireByHandle(self, "RunScriptCode", "attachTrainStart(3,"+index+")", 0.02, null, null);
    //Simulate train slowing down
    EntFire("sp_linear_"+sp_positions[index], "AddOutput", "speed 600", 0.0, null);
    EntFire("sp_linear_"+sp_positions[index], "SetSpeed", "500", 1, null);
    EntFire("sp_linear_"+sp_positions[index], "SetSpeed", "300", 3, null);
    EntFire("sp_linear_"+sp_positions[index], "SetSpeed", "150", 4.75, null);
    EntFire("sp_linear_"+sp_positions[index], "SetSpeed", "100", 6.5, null);
    EntFire("sp_linear_"+sp_positions[index], "SetSpeed", "50", 8, null);
    EntFire("sp_linear_"+sp_positions[index], "SetPosition", "0.823", 0.04, null);
    //Open platform doors when it arrives
    EntFireByHandle(self, "RunScriptCode", "platformDoorsOpen("+index+")", 9, null, null);
    if(index == 3)  return;//Prevent ambient_generic being unkilled and causing edict count inflate
    else
    {//Play sounds
        EntFireByHandle(self, "RunScriptCode", "soundPlayManual(11,0,"+
                        sp_ambience_coords[0]+","+sp_ambience_top_bottom_coords[0]+","+sp_ambience_height+")", 0.0, null, null);
        EntFireByHandle(self, "RunScriptCode", "soundPlayManual(11,0,"+
                        sp_ambience_coords[1]+","+sp_ambience_top_bottom_coords[0]+","+sp_ambience_height+")", 0.0, null, null);
        EntFireByHandle(self, "RunScriptCode", "soundPlayManual(11,0,"+
                        sp_ambience_coords[2]+","+sp_ambience_top_bottom_coords[0]+","+sp_ambience_height+")", 0.0, null, null);
        EntFireByHandle(self, "RunScriptCode", "soundPlayManual(11,0,"+
                        sp_ambience_coords[3]+","+sp_ambience_top_bottom_coords[0]+","+sp_ambience_height+")", 0.0, null, null);
        EntFireByHandle(self, "RunScriptCode", "soundPlayManual(11,0,"+
                        sp_ambience_coords[0]+","+sp_ambience_top_bottom_coords[1]+","+sp_ambience_height+")", 0.0, null, null);
        EntFireByHandle(self, "RunScriptCode", "soundPlayManual(11,0,"+
                        sp_ambience_coords[1]+","+sp_ambience_top_bottom_coords[1]+","+sp_ambience_height+")", 0.0, null, null);
        EntFireByHandle(self, "RunScriptCode", "soundPlayManual(11,0,"+
                        sp_ambience_coords[2]+","+sp_ambience_top_bottom_coords[1]+","+sp_ambience_height+")", 0.0, null, null);
        EntFireByHandle(self, "RunScriptCode", "soundPlayManual(11,0,"+
                        sp_ambience_coords[3]+","+sp_ambience_top_bottom_coords[1]+","+sp_ambience_height+")", 0.0, null, null);
    }
}

//Starts sequence of opening doors of the platform; also replaces to more detailed train props
//Inputs: index - index describing which platform
function platformDoorsOpen(index)
{
    //Kill all cheap model trains at the platform
    EntFire("train_prop_cheap", "KillHierarchy", "", 0.0, null);
    //Replace with better versioned trains
    local rail_coords = sp_rail_east_coords;
    if(index==1 || index ==3)    rail_coords = sp_rail_west_coords;//If the train spawns at northern platform instead
    EntFireByHandle(self, "RunScriptCode",
                        "spawnTrain("+sp_parked_coords[0]+","+rail_coords+","+sp_rail_height+","+index+")", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode",
                        "spawnTrain("+sp_parked_coords[1]+","+rail_coords+","+sp_rail_height+","+index+")", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode",
                        "spawnTrain("+sp_parked_coords[2]+","+rail_coords+","+sp_rail_height+","+index+")", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode",
                        "spawnTrain("+sp_parked_coords[3]+","+rail_coords+","+sp_rail_height+","+index+")", 0.0, null, null);
    //Choose the doors to open
    local sp_door_index = indexChooser(1,4,5);
    if(index>1)
    {//If the sequence is on both platforms, kill doors on train and open all doors
        EntFire("train_prop_door_moveleft", "Kill", "", 0.0, null);
        EntFire("train_prop_door_moveright", "Kill", "", 0.0, null);
        EntFire("sp_doors_bottom_left*", "Open", "", 1.0, null);
        EntFire("sp_doors_bottom_right*", "Open", "", 1.0, null);
        EntFire("sp_doors_top_left*", "Open", "", 1.0, null);
        EntFire("sp_doors_top_right*", "Open", "", 1.0, null);
        //Enable teleports
        EntFire("tp_spawn_postmz", "AddOutput", "target dest_sp_*", 0.0, null);
        EntFire("tp_sp_bottom", "Disable", "", 0.0, null);
        EntFire("tp_sp_top", "Disable", "", 0.0, null);
        EntFire("tp_sp_wait", "AddOutput", "target dest_sp_*", 0.0, null);
        EntFire("tp_sp_wait", "Enable", "", 0.02, null);
        sp_end_area = true;
        if(index == 3)  spIntroEnd();//check in case humans triggered walkie talkie before all trains arrive
    }
    else
    {//If not, simulate trains leaving the platform
        //Disable teleport at the trains
        EntFire("tp_spawn_postmz", "AddOutput", "target dest_sp_"+sp_positions[index], 0.0, null);
        EntFire("tp_sp_"+sp_positions[index], "Disable", "", 0.0, null);
        //Enable teleport at waiting room
        EntFire("tp_sp_wait", "AddOutput", "target dest_sp_"+sp_positions[index], 0.0, null);
        EntFire("tp_sp_wait", "Enable", "", 0.02, null);
        EntFire("train_prop_door_moveleft", "SetParent", "sp_doors_"+sp_positions[index]+"_left"+sp_door_index[0], 0.0, null);
        EntFire("train_prop_door_moveright", "SetParent", "sp_doors_"+sp_positions[index]+"_right"+sp_door_index[2], 0.0, null);
        EntFire("sp_doors_"+sp_positions[index]+"_left"+sp_door_index[0], "Open", "", 0.02, null);
        EntFire("sp_doors_"+sp_positions[index]+"_left"+sp_door_index[1], "Open", "", 0.02, null);
        EntFire("sp_doors_"+sp_positions[index]+"_right"+sp_door_index[2], "Open", "", 0.02, null);
        EntFire("sp_doors_"+sp_positions[index]+"_right"+sp_door_index[3], "Open", "", 0.02, null);
        EntFireByHandle(self, "RunScriptCode", "platformDoorsClose("+index+")", 9, null, null);
        //Move movelinear to desired position
        EntFire("sp_linear_"+sp_positions[index], "AddOutput", "speed 6000", 0.0, null);
        EntFire("sp_linear_"+sp_positions[index], "SetPosition", "0.177", 0.04, null);
    }
}

//Starts sequence of closing doors of the platform; also replaces trains back to cheap version
//Inputs: index - index describing which platform
function platformDoorsClose(index)
{
    //Play sounds
    EntFireByHandle(self, "RunScriptCode", "soundPlayManual(12,0,"+
                    sp_ambience_coords[0]+","+sp_ambience_top_bottom_coords[0]+","+sp_ambience_height+")", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "soundPlayManual(12,0,"+
                    sp_ambience_coords[1]+","+sp_ambience_top_bottom_coords[0]+","+sp_ambience_height+")", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "soundPlayManual(12,0,"+
                    sp_ambience_coords[2]+","+sp_ambience_top_bottom_coords[0]+","+sp_ambience_height+")", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "soundPlayManual(12,0,"+
                    sp_ambience_coords[3]+","+sp_ambience_top_bottom_coords[0]+","+sp_ambience_height+")", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "soundPlayManual(12,0,"+
                    sp_ambience_coords[0]+","+sp_ambience_top_bottom_coords[1]+","+sp_ambience_height+")", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "soundPlayManual(12,0,"+
                    sp_ambience_coords[1]+","+sp_ambience_top_bottom_coords[1]+","+sp_ambience_height+")", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "soundPlayManual(12,0,"+
                    sp_ambience_coords[2]+","+sp_ambience_top_bottom_coords[1]+","+sp_ambience_height+")", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "soundPlayManual(12,0,"+
                    sp_ambience_coords[3]+","+sp_ambience_top_bottom_coords[1]+","+sp_ambience_height+")", 0.0, null, null);
    EntFire("sp_doors_"+sp_positions[index]+"_left*", "Close", "", 0.0, null);
    EntFire("sp_doors_"+sp_positions[index]+"_right*", "Close", "", 0.0, null);
    //Teleport people inside the train to waiting room
    EntFire("tp_sp_"+sp_positions[index], "Enable", "", 3.0, null);
    EntFire("tp_spawn_postmz", "AddOutput", "target dest_spwait", 3.0, null);
    EntFire("tp_sp_wait", "Disable", "", 3.0, null);
    //Kill all detailed model trains at the platform
    EntFire("train_prop_detailed", "KillHierarchy", "", 3.0, null);
    EntFire("train_prop_door_moveleft", "Kill", "", 3.0, null);
    EntFire("train_prop_door_moveright", "Kill", "", 3.0, null);
    //Replace with cheaper trains
    local rail_coords = sp_rail_east_coords;
    if(index==1||index==3)    rail_coords = sp_rail_west_coords;//If the train spawns at northern platform instead
    EntFireByHandle(self, "RunScriptCode",
                        "spawnCheapTrain("+sp_parked_coords[0]+","+rail_coords+","+sp_rail_height+","+index+")", 3.0, null, null);
    EntFireByHandle(self, "RunScriptCode",
                        "spawnCheapTrain("+sp_parked_coords[1]+","+rail_coords+","+sp_rail_height+","+index+")", 3.0, null, null);
    EntFireByHandle(self, "RunScriptCode",
                        "spawnCheapTrain("+sp_parked_coords[2]+","+rail_coords+","+sp_rail_height+","+index+")", 3.0, null, null);
    EntFireByHandle(self, "RunScriptCode",
                        "spawnCheapTrain("+sp_parked_coords[3]+","+rail_coords+","+sp_rail_height+","+index+")", 3.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "attachTrainMid(0,"+index+")", 3.02, null, null);
    EntFireByHandle(self, "RunScriptCode", "attachTrainMid(1,"+index+")", 3.02, null, null);
    EntFireByHandle(self, "RunScriptCode", "attachTrainMid(2,"+index+")", 3.02, null, null);
    EntFireByHandle(self, "RunScriptCode", "attachTrainMid(3,"+index+")", 3.02, null, null);
    //Simulate train acceleration
    EntFire("sp_linear_"+sp_positions[index], "AddOutput", "speed 50", 3.04, null);
    EntFire("sp_linear_"+sp_positions[index], "SetSpeed", "100", 4, null);
    EntFire("sp_linear_"+sp_positions[index], "SetSpeed", "150", 5, null);
    EntFire("sp_linear_"+sp_positions[index], "SetSpeed", "225", 6, null);
    EntFire("sp_linear_"+sp_positions[index], "SetSpeed", "350", 7.5, null);
    EntFire("sp_linear_"+sp_positions[index], "SetSpeed", "500", 9, null);
    EntFire("sp_linear_"+sp_positions[index], "SetSpeed", "600", 10, null);
    EntFire("sp_linear_"+sp_positions[index], "Open", "", 3.04, null);
    if(index==0)    EntFireByHandle(self, "RunScriptCode", "platformApproach(1)", 12, null, null);//Starts next sequence in opposite platform
    if(index==1)
    {//starts next sequence of spawning trains at both platforms
        EntFireByHandle(self, "RunScriptCode", "platformApproach(2)", 12, null, null);
        EntFireByHandle(self, "RunScriptCode", "platformApproach(3)", 12, null, null);
    }
}

//Attach train to movelinear at the start of sequence
//Inputs: index - index of coords
//        index_movelienar - index of movelinear
function attachTrainStart(index, index_movelinear)
{
    local rail_coords = sp_rail_east_coords;
    local coord_index = 0;
    if(index_movelinear==1 || index_movelinear==3)
    {//If the train spawns at northern platform instead
        rail_coords = sp_rail_west_coords;
        coord_index = 4
    }
    local train = Entities.FindByNameNearest("train_prop_cheap", Vector(sp_coords[coord_index+index], rail_coords, sp_rail_height), 200);
    EntFireByHandle(train, "SetParent", "sp_linear_"+sp_positions[index_movelinear], 0.0, null, null);
}

//Attach train to movelinear at the platform
//Inputs: index - index of coords
//        index_movelienar - index of movelinear
function attachTrainMid(index, index_movelinear)
{
    local rail_coords = sp_rail_east_coords;
    if(index_movelinear==1) rail_coords = sp_rail_west_coords;
    local train = Entities.FindByNameNearest("train_prop_cheap", Vector(sp_parked_coords[index], rail_coords, sp_rail_height), 200);
    EntFireByHandle(train, "SetParent", "sp_linear_"+sp_positions[index_movelinear], 0.0, null, null);
}

//Spawns trains on desired locations
//Inputs: originx - x coordinates of spawn position
//        originy - y coordinates
//        originz - z coordinates
//        index - which platform it spawns at; the orientation is important for doors
function spawnTrain(originx, originy, originz, index)
{
    local maker = entityFinder("train_maker_detailed");
    local angle = 0;
    if(index == 1 || index == 3)  angle = 180;
    maker.SpawnEntityAtLocation(Vector(originx,originy,originz), Vector(0,angle,0));
}

//Spawns cheap versioned trains on desired locations
//Inputs: originx - x coordinates of spawn position
//        originy - y coordinates
//        originz - z coordinates
//        index - which platform it spawns at; the orientation is important for doors
function spawnCheapTrain(originx, originy, originz, index)
{
    local maker = entityFinder("train_maker_cheap");
    local angle = 0;
    if(index == 1 || index == 3)  angle = 180;
    maker.SpawnEntityAtLocation(Vector(originx,originy,originz), Vector(0,angle,0));
}

//If a human does not get off the train after door closes
function missedDisembark()
{
    if(activator.GetTeam()==3)  EntFireByHandle(activator, "SetHealth", "0", 0.0, null, null);
}


//* Subway Platform Intro *//

//Variables
sp_intro_wait <- 3;//how long players are stuck in train until the door opens
sp_end_area <- false;//to determine if the train sequence is completey finished
sp_seconds <- 12;//time-second iteration for the center chat message
sp_intro_started <- false;

//Starts train arrival to station sequence
function spIntro()
{  
    if(!debug)
    {
        //Enable/disable fog
        EntFire("map_fade", "Fade", "", 0.0, null);
        EntFire("map_fade", "Addoutput", "holdtime 0", 0.0, null);
        EntFire("map_fade", "FadeReverse", "", 1.0, null);
        //Disable radar
        EntFire("map_servercommand", "Command", "sv_disable_radar 1", 1.5, null);
        //Start train arriving sequence
        EntFireByHandle(self, "RunScriptCode", "platformApproach(0)", 1.0, null, null);
        //Teleport from spawn room
        EntFire("tp_spawn_ct", "Enable", "", 1.0, null);
        EntFire("tp_spawn_t", "Enable", "", 3.0, null);
        EntFireByHandle(self, "RunScriptCode", "spIntroChat()", 1.0, null, null);
        EntFire("sp_mz_trigger", "Enable", "", 6.0, null);//add infected context filter to mz
        EntFire("sprite_sp_template", "ForceSpawn", "", 1.0, null);//spawn lighting sprites
    }
}

//Prints out chat message (time + location) as the train arrives
function spIntroChat()
{
    if(sp_seconds == 19) return;
    local text = "City Underground Subway\n⠀⠀⠀⠀⠀14:27:"+sp_seconds;
    ScriptPrintMessageCenterAll(text);
    sp_seconds++
    EntFireByHandle(self, "RunScriptCode", "spIntroChat()", 1.0, null, null);
}

//Initiates the map features as the players are teleported into the map
function spInitiate()
{//This is the point where some players are converted to mother zombies
    if(!sp_intro_started)
    {//Start the map
        EntFire("debug", "Command", "echo Debug (start): starting the map initiating commands", 0.0, null);
        if(!zm_mz_found)
        {//This really should not happen!
            EntFire("debug", "Command", "echo Debug (start): WARNING! Map did not detect any MZ", 0.0, null);
            EntFire("spawn_premz_multiple", "Kill", "", 0.0, null);//Disable context removal trigger in spawn
            EntFire("spawn_postmz_multiple", "Enable", "", 0.0, null);//Enable 'zombified' context trigger in spawn
            EntFire("map_perished_timer", "Enable", "", 1.0, null);//Enable delayed infections for later zombies
            EntFire("map_spawn_timer", "Enable", "", 0.0, null);
            EntFire("tp_spawn_failsafe", "Enable", "", 10.0, null);//Enable failsafe teleport in spawn
            EntFire("spawn_failsafe_sprite", "ShowSprite", "", 10.0, null);//Enable failsafe sprite in spawn
        }
        EntFireByHandle(self, "RunScriptCode", "itemsWT()", 0.0, null, null);
        EntFire("tp_spawn_ct", "Kill", "", 5.5, null);
        EntFire("tp_spawn_t", "Kill", "", 5.5, null);
        EntFire("tp_spawn_postmz", "Enable", "", 5.5, null);
        //Change the spawn trigger_teleport with the spawn context filter applied
        sp_intro_started <- true;
        return;
    }
    EntFire("debug", "Command", "echo Debug (start): map has already started, so skipping the failsafe map start", 0.0, null);//If map already started
}

//Ends the subway platform section and move to next area
function spIntroEnd()
{
    if(!sp_end_area||!item_wt_enabled)
    {//humans did not find the walkie talkie before all trains arrive
        if(!item_wt_enabled)    ScriptPrintMessageChatAll("⠀\x02 [ CONSOLE ]\x01 To escape we need some sort of help. Try to find a\x0d walkie talkie\x01!");
        return;//If the sequence has not finished OR the walkie talkie is not picked up yet
    }
    if(item_wt_was_first)   EntFire("sp_break*", "Break", "", 2.0, null);//humans found the walkie talkie in time
    else    EntFire("sp_break*", "Break", "", 14.0, null);//humans did not find the walkie talkie in time
    //Change the spawn tp to the afk/teleport room
    EntFire("tp_spawn_postmz", "AddOutput", "target dest_afk_room", 0.0, null);
    EntFire("afk_room_hurt", "Enable", "", 0.0, null);
}

//* Maintenance Hall *//

//Sets up the three paths
function preSplit()
{
    EntFireByHandle(self, "RunScriptCode", "preSplitChat()", 0.0, null, null);
    //Spawn map items
    EntFireByHandle(self, "RunScriptCode", "itemsPB()", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "itemsGC()", 1.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "itemsTM()", 2.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "itemsRP()", 3.0, null, null);
    //Enable triggers to each path
    local coords =  [Vector(-1008,1170,736),Vector(-640,1256,736),Vector(400,1568,752)];
    for(local i=0;i<3;i++)
    {
        local button = Entities.FindByNameNearest("trig_button", coords[i], 16);
        EntFireByHandle(button, "Unlock", "", 14, null, null);
        local sprite = Entities.FindByNameNearest("trig_sprite", coords[i], 16);
        EntFireByHandle(sprite, "ShowSprite", "", 14, null, null);
    }
    //Kill the trains in the platform + close platform doors
    EntFire("train_prop_detailed", "KillHierarchy", "", 0.0, null);
    EntFire("sp_doors_top_left", "Close", "", 0.0, null);
    EntFire("sp_doors_top_right", "Close", "", 0.0, null);
    EntFire("sp_doors_bottom_left", "Close", "", 0.0, null);
    EntFire("sp_doors_bottom_right", "Close", "", 0.0, null);
    //Enable ZM tp forward + move people AFK in trains to the AFK room
    zm_spawn_sp3 <- true;
    EntFire("tp_sp_top", "AddOutput", "target dest_afk_room", 0.0, null);
    EntFire("tp_sp_bottom", "AddOutput", "target dest_afk_room", 0.0, null);
    EntFire("tp_sp_top", "Enable", "", 0.0, null);
    EntFire("tp_sp_bottom", "Enable", "", 0.0, null);
    //Enable AFK teleport to the split area
    EntFireByHandle(self, "RunScriptCode", "enableAFKTP(0)", 16.0, null, null);
}

presplit_chat <- ["⠀\x10 [ OPR ]\x01 Okay... now I need you to\x0f split\x01 into\x02 three groups",
                "⠀\x10 [ OPR ]\x01 Basically, there are things I'd like you to complete at the end of each path...",
                "⠀\x10 [ OPR ]\x01 which can\x0f aid\x01 you when you need to\x0f escape\x01 through a\x02 zombie infested area\x01 at the end",
                "⠀\x10 [ OPR ]\x01 Of course, you don't have to. But I reckon it will be harder if you don't. Now, gather your team, and decide what you will do"];
presplit_chat_it <- 0;

//Prints out chat for preSplit()
function preSplitChat()
{
    if(presplit_chat_it == presplit_chat.len())   return;
    ScriptPrintMessageChatAll(presplit_chat[presplit_chat_it]);
    EntFireByHandle(self, "RunScriptCode", "preSplitChat()", 4, null, null);
    presplit_chat_it++
}

//---------------------------//
//**  Path Alpha (Office)  **//

//* Two Way Split *//

//Variables
a_attempted <- false;//If players have attempted path alpha (trigger for this is by the door after the big blue room)
a_completed <- false;//If players have completed the path, regardless of the minigame
a_explain <- ["⠀\x02 [ A ]\x01 If you are exiting some\x0f corridor\x01 right now, you are going to the\x02 control room",
            "⠀\x02 [ A ]\x01 We need to let the outside know there are survivors here, and there are transmissions equipments there",
            "⠀\x02 [ A ]\x01 But I will explain more when you are closer to the control room"];
a_bottom_triggered <- false;
a_top_triggered<- false;
a_doors_wait_time <- 20;//how long should players wait if only one door is triggered
a_chat_it <- 0;

//Displays in chat the purpose of path alpha
function alphaExplain()
{
    if(a_chat_it == a_explain.len())   return;
    ScriptPrintMessageChatAll(a_explain[a_chat_it]);
    EntFireByHandle(self, "RunScriptCode", "alphaExplain()", 4.0, null, null);
    a_chat_it++
}

//Checks if both doors are triggerd
//Inputs: index - indicating if it is top(0) or bottom(1) door
function controlDoorsTriggerd(index)
{
    if(!activator || activator.GetTeam()==2)
        return;
    else
    {
        if(index)//Bottom is triggered
            a_bottom_triggered<-true;
        else//Top is triggered
            a_top_triggered<-true;
        EntFireByHandle(self, "RunScriptCode", "soundPlay(18,0);", 0, caller, null);
        a_mg_terminals<-a_mg_terminals+4;
        EntFireByHandle(caller, "KillHierarchy", "", 0.5, null, null);
    }
    if(a_bottom_triggered && a_top_triggered)
    {//Both are triggered
        ScriptPrintMessageChatAll("⠀\x02 [ A ]\x01 Nice! I will open\x02 both gates\x01 soon");
        EntFireByHandle(self, "RunScriptCode", "introduceAdminHack()", 4, null, null);
        EntFire("a_tw_linear_top", "Open", "", 5, null);
        EntFire("a_tw_linear_bottom", "Open", "", 5, null);
        EntFire("sprite_a_mg_template", "ForceSpawn", "", 5, null);
        EntFire("a_sprite1", "Kill", "", 5, null);
        EntFire("sp_up_sprite", "Kill", "", 5, null);
    }
    else if(a_bottom_triggered)//Bottom is triggered
        ScriptPrintMessageChatAll("⠀\x02 [ A ]\x01 The gate will open quicker if you trigger the\x02 top gate\x01 as well");
    else if(a_top_triggered)//Top is triggered
        ScriptPrintMessageChatAll("⠀\x02 [ A ]\x01 The gate will open quicker if you trigger the\x02 bottom gate\x01 as well");
    EntFireByHandle(self, "RunScriptCode", "controlDoorWait("+index+")", a_doors_wait_time, null, null);
}

//If only one is triggered, then ONLY open that one after a long time
//Inputs: index - indicating if it is top(0) or bottom(1) door
function controlDoorWait(index)
{
    if(a_bottom_triggered && a_top_triggered) return;//function has no usage if both are triggered
    ScriptPrintMessageChatAll("⠀\x02 [ A ]\x01 No response from the other floor... I'll open the gate");
    if(!index)
    {//open top gate only
        EntFire("a_tw_linear_top", "Open", "", 2.0, null);
        EntFire("a_tw_linear_bottom", "Open", "", 22.0, null);
        EntFire("a_tw_button_bottom", "KillHierarchy", "", 0.0, null);
    }
    else
    {//open bottom gate only
        EntFire("a_tw_linear_bottom", "Open", "", 2.0, null);
        EntFire("a_tw_linear_top", "Open", "", 22.0, null);
        EntFire("a_tw_button_top", "KillHierarchy", "", 0.0, null);
    }
    //Start minigame
    EntFireByHandle(self, "RunScriptCode", "introduceAdminHack()", 2.0, null, null);
    EntFire("sprite_a_mg_template", "ForceSpawn", "", 2.0, null);
    //Kill lightning sprites in previous areas
    EntFire("a_sprite1", "Kill", "", 2.0, null);
    EntFire("sp_up_sprite", "Kill", "", 2.0, null);
}

//* Minigame *//

//Variables
a_mg_terminals <- 0;//number of terminals to be hacked (variable as map progresses)
a_mg_1_hacked <- false;//If terminal 1 is hacked
a_mg_2_hacked <- false;//etc.
a_mg_3_hacked <- false;
a_mg_4_hacked <- false;
a_mg_5_hacked <- false;
a_mg_6_hacked <- false;
a_mg_7_hacked <- false;
a_mg_8_hacked <- false;
a_mg_terminals_hacked <- 0;//counts how many terminals are hacked so far
a_mg_hackduration <- 0.35;//duration where hacking is enabled
a_mg_totduration <- 20;//total duration of the minigame
a_mg_finish <- false;//bool to end minigame
a_mg_success <- false;
a_mg_intro_chat <- ["⠀\x02 [ A ]\x01 You have to be\x02 very precise\x01 on the terminals when it shows a\x0f white light\x01..."
                    "",
                    "⠀\x02 [ A ]\x01 Let me know when you are ready"];
a_mg_chat <- ["⠀\x02 [ A ]\x01 Ok I am firing up the terminals...",
            "⠀\x02 [ A ]\x01 Now!"];
a_mg_chat_it <- 0;
a_mg_warned <- false;//if the player has been warned about early exit from minigame
a_mg_warned_chat <- ["⠀\x02 [ A ]\x01 Wait! You did not trasmit your survival to the outside yet",
                    "⠀\x02 [ A ]\x01 Do you really want to leave now?"];
a_mg_complete_chat <- [ "⠀\x02 [ A ]\x01 You got it! And the transmission has been sent",
                        "⠀\x02 [ A ]\x01 Hopefully, there are still people alive receiving it though",
                        "⠀\x02 [ A ]\x01 Let me open the doors now",
                        "⠀\x02 [ CONSOLE ] Alpha\x01 minigame:\x04 SUCCESS"];
a_mg_semi_complete_chat <- ["⠀\x02 [ A ]\x01 You got it... but I can't seem to find a signal on this frequency",
                            "⠀\x02 [ A ]\x01 I think the terminals on\x02 both floors\x01 were needed to be hacked... too late to dwell on that though",
                            "⠀\x02 [ A ]\x01 Let me open the doors now",
                            "⠀\x02 [ CONSOLE ] Alpha\x01 minigame:\x02 FAILED"];
a_mg_failed_chat <- [       "⠀\x02 [ A ]\x01 Aah... I think we just missed our window by a second",
                            "⠀\x02 [ A ]\x01 You should get moving, I see a horde of zombies headed your way",
                            "⠀\x02 [ A ]\x01 Let me open the doors now",
                            "⠀\x02 [ CONSOLE ] Alpha\x01 minigame:\x02 FAILED"];
a_mg_inprogress <- false;

//Introduces and let players know the minigame they are facing
function introduceAdminHack()
{
    local text = a_mg_intro_chat[a_mg_chat_it];
    //Separate to update a_mg_totduration and a_mg_terminals correctly
    if(a_mg_chat_it == 1)
    {
        if(!(a_top_triggered && a_bottom_triggered))
        {
            a_mg_totduration = a_mg_totduration/2;
            EntFire("debug", "Command", "echo Debug (a MG): adjustment for only 1 floor trigger", 0.0, null);
        }
        text = "⠀\x02 [ A ]\x01 and you have limited time... about\x02 "+a_mg_totduration+" seconds\x01 to tune all\x02 "+a_mg_terminals+" terminals";
    }
    ScriptPrintMessageChatAll(text);
    if(a_mg_chat_it == 2)
    {
        a_mg_chat_it = 0;
        EntFire("a_mg_wt", "Unlock", "", 1.0, null);
        EntFire("a_mg_quit_wt", "Unlock", "", 3.0, null);
        EntFire("a_mg_wt_sprite", "ShowSprite", "", 1.0, null);
        EntFire("a_mg_quit_wt_sprite", "ShowSprite", "", 3.0, null);
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "introduceAdminHack()", 4.0, null, null);
    a_mg_chat_it++;
}

//Skip the minigame and move on to next area
function exitAlpha()
{
    EntFire("a_mg_wt", "Lock", "", 0.0, null);
    EntFire("a_mg_quit_wt", "Lock", "", 0.0, null);
    EntFire("a_mg_wt_sprite", "HideSprite", "", 0.0, null);
    EntFire("a_mg_quit_wt_sprite", "HideSprite", "", 0.0, null);
    if(a_mg_warned)
    {//If players want to exit even after the warning
        ScriptPrintMessageChatAll("⠀\x02 [ A ]\x01 Well... let me get the doors for you then");
        EntFire("a_mg*", "Kill", "", 0.0, null);
        EntFireByHandle(self, "RunScriptCode", "alphaOpenDoors()", 2.0, null, null);
        return;
    }
    ScriptPrintMessageChatAll(a_mg_warned_chat[a_mg_chat_it]);
    if(a_mg_chat_it==1)
    {
        a_mg_chat_it  = 0;
        a_mg_warned = true;
        EntFire("a_mg_wt", "Unlock", "", 1.0, null);
        EntFire("a_mg_quit_wt", "Unlock", "", 3.0, null);//Prevent potential trolling
        EntFire("a_mg_wt_sprite", "ShowSprite", "", 1.0, null);
        EntFire("a_mg_quit_wt_sprite", "ShowSprite", "", 3.0, null);
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "exitAlpha()", 4.0, null, null);
    a_mg_chat_it++;
}

//Starts the minigame sequence
function startAdminHack()
{
    ScriptPrintMessageChatAll(a_mg_chat[a_mg_chat_it]);
    if(a_mg_chat_it == 0)
    {
        EntFire("a_mg_quit_wt", "Kill", "", 0.0, null);//Prevent the early quit option
        EntFire("a_mg_condition_text", "AddOutput", "message LAUNCHING", 0.0, null);
        local time = RandomInt(3,5);
        EntFireByHandle(self, "RunScriptCode", "startAdminHack()", time, null, null);
        EntFireByHandle(self, "RunScriptCode", "initiateHackMinigame()", time, null, null);//Start the minigame
        a_mg_chat_it++;
        a_mg_inprogress = true;
    }
}

//Initiates the hacking minigame
function initiateHackMinigame()
{
    if(a_bottom_triggered && !a_top_triggered)  for(local it = 1 ; it < a_mg_terminals+1 ; it++)
        EntFireByHandle(self, "RunScriptCode", "checkHack("+it+")", 0.0, null, null);
    else if(a_top_triggered && !a_bottom_triggered) for(local it = 5 ; it < a_mg_terminals+5 ; it++)
        EntFireByHandle(self, "RunScriptCode", "checkHack("+it+")", 0.0, null, null);
    else    for(local it = 1 ; it < a_mg_terminals+1 ; it++)
        EntFireByHandle(self, "RunScriptCode", "checkHack("+it+")", 0.0, null, null);
    for(local it = 1 ; it < 9 ; it++)    EntFire("a_mg_text"+it, "AddOutput", "message "+RandomInt(0,9), 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "a_mg_finish <- true;", a_mg_totduration, null, null);//Bool to stop the minigame
    EntFireByHandle(self, "RunScriptCode", "hackFailed()", a_mg_totduration, null, null);//Checks if minigames is won
    EntFire("a_mg_dot_text", "AddOutput", "message .", 0.0, null);
    EntFire("a_mg_mhz_text", "AddOutput", "message MHz", 0.0, null);
    EntFire("a_mg_condition_text", "AddOutput", "message TUNING", 0.0, null);
}

//Fire a specific terminal to be hackable for the duration stated with a_mg_hackduration
//Inputs: number - number corresponding the terminal to be hacked
function repeatHack(number)
{
    //Activates visual indications
    EntFire("a_mg_sprite"+number, "ShowSprite", "", 0.0, null);
    EntFire("a_mg_button"+number, "Unlock", "", 0.0, null); //Unlocks corresponding button
    EntFire("a_mg_button"+number, "Lock", "", a_mg_hackduration, null);    //Prevents same tick hack / button lock
    EntFireByHandle(self, "RunScriptCode", "checkHack("+number+")", a_mg_hackduration+0.05, null, null); //Checks if hack was successful
}

//Checks if the hack on specific termianl was succesful; recurssive between repeatHack() function
//Inputs: number - number corresponding the terminal to be hacked
function checkHack(number)
{
    if(a_mg_finish)    return;//Quit function if the timelimit of minigame has reached
    EntFireByHandle(self, "RunScriptCode", "isHackComplete()", 0.02, null, null);//Checks if all hack is complete
    local sprite = entityFinder("a_mg_sprite"+number);
    local next_timing = RandomInt(3,5);
    //Cosmetic frequency display
    EntFire("a_mg_text"+number, "AddOutput", "message "+RandomInt(0,9), 0.0, null);
    switch(number)
    {
        case 1:
        {
            if(a_mg_1_hacked)
            {//The hack was successful
                sprite.__KeyValueFromString("rendercolor", "0 255 0");
                a_mg_terminals_hacked++;
                return;
            }
            break;
        }
        case 2:
        {
            if(a_mg_2_hacked)
            {//The hack was successful
                sprite.__KeyValueFromString("rendercolor", "0 255 0");
                a_mg_terminals_hacked++;
                return;
            }
            break;
        }
        case 3:
        {
            if(a_mg_3_hacked)
            {//The hack was successful
                sprite.__KeyValueFromString("rendercolor", "0 255 0");
                a_mg_terminals_hacked++;
                return;
            }
            break;
        }
        case 4:
        {
            if(a_mg_4_hacked)
            {//The hack was successful
                sprite.__KeyValueFromString("rendercolor", "0 255 0");
                a_mg_terminals_hacked++;
                return;
            }
            break;
        }
        case 5:
        {
            if(a_mg_5_hacked)
            {//The hack was successful
                sprite.__KeyValueFromString("rendercolor", "0 255 0");
                a_mg_terminals_hacked++;
                return;
            }
            break;
        }
        case 6:
        {
            if(a_mg_6_hacked)
            {//The hack was successful
                sprite.__KeyValueFromString("rendercolor", "0 255 0");
                a_mg_terminals_hacked++;
                return;
            }
            break;
        }
        case 7:
        {
            if(a_mg_7_hacked)
            {//The hack was successful
                sprite.__KeyValueFromString("rendercolor", "0 255 0");
                a_mg_terminals_hacked++;
                return;
            }
            break;
        }
        case 8:
        {
            if(a_mg_8_hacked)
            {//The hack was successful
                sprite.__KeyValueFromString("rendercolor", "0 255 0");
                a_mg_terminals_hacked++;
                return;
            }
            break;
        }
    }
    //Otherwise try again for next time
    EntFireByHandle(sprite, "HideSprite", "", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "repeatHack("+number+")", next_timing, null, null);//Repeats 3-5 secs later
}

//If a player mis-times the terminal
function missedHack()
{
    if(a_mg_inprogress)
    {//only fire if the mg is happening
        EntFireByHandle(activator, "AddContext", "a_mg_failed:1", 0.0, null, null);
        EntFireByHandle(activator, "RemoveContext", "a_mg_failed", 0.1, null, null);
    }
}

//Checks if all terminals has been hacked
function isHackComplete()
{
    if(a_mg_terminals_hacked == a_mg_terminals)
    {//Quit function if all terminals are hacked
        if(a_mg_terminals_hacked == 8)
        {
            a_mg_success <- true;//Good ending progress only if both floors are triggered
            hackSuccess();
        }
        else    hackSuccessOneFloor();
        a_mg_inprogress = false;
        finalGateUnlock();
    }
}

//Fires when all terminals have been hacked
function hackSuccess()
{
    a_mg_chat_it = 0;
    EntFire("a_mg_condition_text", "AddOutput", "message SUCCESS", 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "hackSuccessChat()", 0.0, null, null);
}

//Fires when all terminals have been hacked
function hackSuccessChat()
{
    ScriptPrintMessageChatAll(a_mg_complete_chat[a_mg_chat_it]);
    if(a_mg_chat_it == 2)   alphaOpenDoors();
    if(a_mg_chat_it == a_mg_complete_chat.len()-1)  return;
    EntFireByHandle(self, "RunScriptCode", "hackSuccessChat()", 4.0, null, null);
    a_mg_chat_it++;
}

//Fires when all terminals have been hacked
function hackSuccessOneFloor()
{
    a_mg_chat_it = 0;
    EntFire("a_mg_condition_text", "AddOutput", "message SUCCESS", 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "hackSuccessOneFloorChat()", 0.0, null, null);
}

//Chat for hackSuccessOneFloor()
function hackSuccessOneFloorChat()
{
    ScriptPrintMessageChatAll(a_mg_semi_complete_chat[a_mg_chat_it]);
    if(a_mg_chat_it == 2)   alphaOpenDoors();
    if(a_mg_chat_it == a_mg_semi_complete_chat.len()-1)  return;
    EntFireByHandle(self, "RunScriptCode", "hackSuccessOneFloorChat()", 4.0, null, null);
    a_mg_chat_it++;
}

//Fires when terminal hacking has failed
function hackFailed()
{
    if(!a_mg_success && a_mg_inprogress)
    {
        a_mg_chat_it = 0;
        EntFire("a_mg_button*", "Kill", "", 0.0, null);
        EntFire("a_mg_sprite*", "ShowSprite", "", 0.0, null);
        EntFire("a_mg_sprite*", "AddOutput", "rendercolor 255 0 0", 0.5, null);
        EntFire("a_mg_failhurt", "Kill", "", 0.0, null);
        EntFire("a_mg_condition_text", "AddOutput", "message FAILED", 0.0, null);
        EntFire("a_mg_text*", "Kill", "", 0.0, null);
        EntFire("a_mg_dot_text", "Kill", "", 0.0, null);
        EntFire("a_mg_mhz_text", "Kill", "", 0.0, null);
        EntFireByHandle(self, "RunScriptCode", "hackFailedChat()", 0.0, null, null);
        a_mg_inprogress = false;
        finalGateUnlock();
    }
}

//Fires when all terminals have been hacked
function hackFailedChat()
{
    ScriptPrintMessageChatAll(a_mg_failed_chat[a_mg_chat_it]);
    if(a_mg_chat_it == 2)   alphaOpenDoors();
    if(a_mg_chat_it == a_mg_failed_chat.len()-1)    return;
    EntFireByHandle(self, "RunScriptCode", "hackFailedChat()", 4.0, null, null);
    a_mg_chat_it++;
}

//Opens the doors to the next area, whether or not the hack was completed
function alphaOpenDoors()
{
    if(a_bottom_triggered && !a_top_triggered)
    {//only open bottom path
        EntFire("a_nf_door1", "Open", "", 0.0, null);
        EntFire("a_nf_door2", "Open", "", 0.0, null);
        EntFire("a_nf_door3", "Open", "", 8.0, null);
        EntFire("a_nf_door4", "Open", "", 8.0, null);
    }
    else if(a_top_triggered && !a_bottom_triggered)
    {//only open top path
        EntFire("a_nf_door1", "Open", "", 5.0, null);
        EntFire("a_nf_door2", "Open", "", 5.0, null);
        EntFire("a_nf_door3", "Open", "", 0.0, null);
        EntFire("a_nf_door4", "Open", "", 0.0, null);
    }
    else
    {//open both path
        EntFire("a_nf_door1", "Open", "", 0.0, null);
        EntFire("a_nf_door2", "Open", "", 0.0, null);
        EntFire("a_nf_door3", "Open", "", 0.0, null);
        EntFire("a_nf_door4", "Open", "", 0.0, null);
    }
    EntFire("a_mg*", "Kill", "", 10.0, null);
    EntFireByHandle(self, "RunScriptCode", "addTrigToQueue(-784,4008,656,3,-1)", 0, null, null);
    EntFireByHandle(self, "RunScriptCode", "addTrigToQueue(-664,5026,656,5,-1)", 0, null, null);
    EntFireByHandle(self, "RunScriptCode", "addTrigToQueue(-542,5104,656,10,-1)", 0, null, null);
}

//--------------------------//
//**  Path Bravo (Sewer)  **//

//* Sewers *//

//Variables
b_attempted <- false;//If players have attempted path bravo (trigger for this is as you come out of the sewers)
b_completed <- false;//If players have completed the path, regardless of the minigame
b_explain <- ["⠀\x0b [ B ]\x01 If you are in the\x0f tunnels\x01, you are going to the\x02 station's generator rooms",
            "⠀\x0b [ B ]\x01 I need you to\x02 activate a backup generator\x01 in there, but last I heard they were a bit\x0f 'unstable'",
            "⠀\x0b [ B ]\x01 I will let you know more later, but for now try to look for\x02 clues\x01 about which generator you\x0f should activate"];
b_chat_it <- 0;

//Provides visible hint to which generator is the valid one, and sets up buttons
function setUpGenerator()
{
    print(b_mg_valid+", "+b_mg_invalid);
    EntFireByHandle(entityFinder("b_rotate"+b_mg_invalid), "Start", "", 0.0, null, null);//Rotate the INcorrect fan (changed in v2)
    EntFireByHandle(entityFinder("b_rotate"+(b_mg_invalid+2)), "Start", "", 0.0, null, null);
    //Give visual indication to the third (broken) fan
    for(local it=0; it<2; it++)
    {
        EntFire("map_spark_template", "ForceSpawn", "", (0.1*it), null);
        if(it == 0) EntFireByHandle(self, "RunScriptCode", "sparkingStart(90,-2112,2256,392,90,0)", (0.1*it)+0.05, null, null);
        if(it == 1) EntFireByHandle(self, "RunScriptCode", "sparkingStart(90,-2112,3520,392,90,0)", (0.1*it)+0.05, null, null);
    }  
}

//Function correspondent to brokePB(), stop the hint for the generator (stop fans from rotating forever)
function stopGeneratorHints()
{
    for(local it=1; it<5; it++)
    {
        local fan = entityFinder("b_rotate"+it).FirstMoveChild();
        EntFireByHandle(fan, "ClearParent", "", it*0.1, null, null);
    }
    EntFire("b_rotate*", "Kill", "", 1.0, null);
}

//Displays in chat the purpose of path bravo
function bravoExplain()
{
    if(b_chat_it == b_explain.len())   return;
    ScriptPrintMessageChatAll(b_explain[b_chat_it]);
    EntFireByHandle(self, "RunScriptCode", "bravoExplain()", 4.0, null, null);
    b_chat_it++
}

//* Minigame *//

//Note: essentially, the player must choose only between two generators instead out of all three; the last one is always broken which is visible by its broken state.

//Variables
b_mg_valid <- RandomInt(1,2);//which generator is valid for the round
b_mg_invalid <- (b_mg_valid%2)+1;
b_mg_wait_time <- 30;//Waiting time to fully initiate a generator
b_mg_chat_intro <- ["⠀\x0b [ B ]\x01 The\x02 generators\x01 are\x0f due for maintenance\x01... which definitely won't happen now",
                    "⠀\x0b [ B ]\x01 Basically, you shouldn't be pressing random buttons unless you are\x02 absolutely certain",
                    "⠀\x0b [ B ]\x01 Okay... now give me some time to set them up for you...",
                    "",//artificial waiting time (4 sec per line)
                    "",
                    "",
                    "⠀\x0b [ B ]\x01 There! Pick your poison..."];
b_mg_chat <- ["⠀\x0b [ B ]\x01 I can see an influx of additional power, nicely done!",
            "⠀\x0b [ B ]\x01 Obviously that was not the right one",
            "⠀\x0b [ B ]\x01 ...Nope, that doesn't look right. Try a different one",
            "⠀\x0b [ B ]\x01 Uhh... nothing has changed. I think it's a different generator",
            "⠀\x0b [ B ]\x01 I can see an influx of- wait no. False alarm, try again",
            "⠀\x0b [ B ]\x01 Nothing. It's one of the others"];
b_mg_chat_it <- 0;
b_mg_warned <- false;
b_mg_warned_chat <- ["⠀\x0b [ B ]\x01 I could really use some extra power right now",
                    "⠀\x0b [ B ]\x01 Do you really want to leave?"];
b_mg_success <- false;
b_mg_success_chat <- [  "⠀\x0b [ B ]\x01 Let's get you moving now",
                        "⠀\x0b [ B ]\x01 Don't worry, I've already checked that there are no zombies in front of you",
                        "⠀\x02 [ CONSOLE ]\x0b Bravo\x01 minigame:\x04 SUCCESS"];
b_mg_timeover_chat <- [ "⠀\x0b [ B ]\x01 You are taking too long to choose a generator... and you really don't have time",
                        "⠀\x0b [ B ]\x01 ...Forget about it, you need to get moving now",
                        "⠀\x02 [ CONSOLE ]\x0b Bravo\x01 minigame:\x02 FAILED"];
b_mg_counter <- 0;//how many generators humans have tried so far
b_mg_max_time <- 15;//max time until the minigame is failed
b_mg_inprogress <- false;

//Prints chat as players enter the generator room
function generatorChat()
{
    ScriptPrintMessageChatAll(b_mg_chat_intro[b_mg_chat_it]);
    if(b_mg_chat_it == 0)   b_mg_inprogress = true;
    if(b_mg_chat_it == b_mg_chat_intro.len()-1)
    {
        //Activate buttons for generator triggers
        EntFire("b_mg_button*", "Unlock", "", 0.0, null);
        EntFire("b_mg_sprite*", "ShowSprite", "", 0.0, null);
        EntFireByHandle(self, "RunScriptCode", "generatorCheckTime("+b_mg_counter+")", b_mg_max_time, null, null);//give max round time stated by b_mg_max_time
        //Fire sparks on third generator
        for(local it=0; it<3; it++)
        {
            EntFire("map_spark_template", "ForceSpawn", "", (0.1*it), null);
            if(it == 0) EntFireByHandle(self, "RunScriptCode", "sparkingStart(30,-980,4710,224,0,90)", (0.1*it)+0.05, null, null);
            if(it == 1) EntFireByHandle(self, "RunScriptCode", "sparkingStart(30,-1056,4710,204,0,90)", (0.1*it)+0.05, null, null);
            if(it == 2) EntFireByHandle(self, "RunScriptCode", "sparkingStart(30,-1124,4710,218,0,90)", (0.1*it)+0.05, null, null);
        }
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "generatorChat()", 4.0, null, null);
    b_mg_chat_it++;
}

//Skip the generator room and move on to next area
function exitBravo()
{
    EntFire("b_mg_wt", "Lock", "", 0.0, null);
    EntFire("b_mg_quit_wt", "Lock", "", 0.0, null);
    EntFire("b_mg_wt_sprite", "HideSprite", "", 0.0, null);
    EntFire("b_mg_quit_wt_sprite", "HideSprite", "", 0.0, null);
    if(b_mg_warned)
    {//If players want to exit even after the warning
        ScriptPrintMessageChatAll("⠀\x0b [ B ]\x01 Okay... but this is your loss as well");
        EntFire("b_mg*", "Kill", "", 0.0, null);
        EntFire("b_gr_linear2", "Open", "", 2.0, null);
        EntFire("b_gr_linear3", "Open", "", 5.0, null);
        EntFireByHandle(self, "RunScriptCode", "addTrigToQueue(-832,5168,216,15,-1)", 0, null, null);
        return;
    }
    ScriptPrintMessageChatAll(b_mg_warned_chat[b_mg_chat_it]);
    if(b_mg_chat_it==1)
    {
        b_mg_chat_it  = 0;
        b_mg_warned = true;
        EntFire("b_mg_wt", "Unlock", "", 1.0, null);
        EntFire("b_mg_quit_wt", "Unlock", "", 3.0, null);//Prevent potential trolling
        EntFire("b_mg_wt_sprite", "ShowSprite", "", 1.0, null);
        EntFire("b_mg_quit_wt_sprite", "ShowSprite", "", 3.0, null);
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "exitBravo()", 4.0, null, null);
    b_mg_chat_it++;
}

//Checks whether power is delivered (i.e. if minigame is completed)
//Inputs: number - number corresponding the generator to be initiated
function checkPower(number)
{
    if(b_mg_success == true)    generatorSuccess();
    else
    {//minigame is not completed
        EntFire("b_mg_button*", "Unlock", "", b_mg_wait_time-5, null);
        EntFire("b_mg_sprite*", "ShowSprite", "", b_mg_wait_time-5, null);
        EntFireByHandle(self, "RunScriptCode", "generatorCheckTime("+b_mg_counter+")", b_mg_wait_time+b_mg_max_time-5, null, null);//give max round time stated by b_mg_max_time
        EntFireByHandle(self, "RunScriptCode", "soundPlayManual(8,0,-1056,4888,216)", b_mg_wait_time-5, null, null);
        EntFireByHandle(self, "RunScriptCode", "soundPlayManual(8,0,-1056,4744,216)", b_mg_wait_time-5, null, null);
        EntFireByHandle(self, "RunScriptCode", "checkPowerChat(4)", 4.0, null, null);
    }
    checkPowerChat(number);
}

//Prints out on chat for checkPower()
//Inputs: number - number corresponding the generator to be initiated
function checkPowerChat(number)
{
    if(number == 4)
    {//Just to let players know they have to wait a bit
        ScriptPrintMessageChatAll("⠀\x0b [ B ]\x01 The power grid needs to\x0f stabilise\x01. I imagine about\x02 "+(b_mg_wait_time-9)+" seconds\x01 more");
        return;
    }
    if(number == b_mg_valid) ScriptPrintMessageChatAll(b_mg_chat[0]);//player chose correct generator
    else if(number == 3)
    {//If the player chose the obvious broken generator
        ScriptPrintMessageChatAll(b_mg_chat[1]);
        return;
    }
    else    ScriptPrintMessageChatAll(b_mg_chat[RandomInt(2,5)]);//player chose incorrect generator
}

//Checks after b_mg_max_time if a generator has not been selected by humans
//Inputs: input - number of generators that have been selected
function generatorCheckTime(input)
{
    if(input == b_mg_counter && b_mg_inprogress)   generatorTimeOver();//humans took too long to press a generator
}

//End the minigame if humans have not selected any generator after b_mg_max_time
function generatorTimeOver()
{
    generatorEnd(); 
    EntFireByHandle(self, "RunScriptCode", "generatorTimeOverChat()", 0.0, null, null);
}

//Chat for generatorTimeOver()
function generatorTimeOverChat()
{
    ScriptPrintMessageChatAll(b_mg_timeover_chat[b_mg_chat_it]);
    if(b_mg_chat_it == b_mg_timeover_chat.len()-1)
    {
        b_mg_inprogress = false;
        finalGateUnlock();
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "generatorTimeOverChat()", 4.0, null, null);
    b_mg_chat_it++;
}

//Fires after the correct generator is activated
function generatorSuccess()
{
    generatorEnd();
    EntFireByHandle(self, "RunScriptCode", "generatorSuccessChat()", 4.0, null, null);
}

//Fires to open gates etc. after the minigame is finished by any means
function generatorEnd()
{
    b_mg_chat_it = 0;
    EntFire("b_mg*", "Kill", "", 0.0, null);
    EntFire("tp_b_mr", "Enable", "", 0.0, null);
    EntFire("tp_b_mr", "Disable", "", 8.0, null);
    EntFire("b_gr_linear2", "Close", "", 0.0, null);
    EntFire("b_gr_linear2", "Open", "", 10.0, null);
    EntFire("b_gr_linear3", "Open", "", 4.0, null);
}

//Fires chat in correspondence to generatorSuccess()
function generatorSuccessChat()
{
    ScriptPrintMessageChatAll(b_mg_success_chat[b_mg_chat_it]);
    if(b_mg_chat_it == b_mg_success_chat.len()-1)
    {
        b_mg_inprogress = false;
        finalGateUnlock();
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "generatorSuccessChat()", 4.0, null, null);
    b_mg_chat_it++;
}

//Checks whether a generator is in process of being initiated   (does not affect the condition of success of said initialisation)
//Inputs: number - number corresponding the generator to be initiated
function initiateGenerator(number)
{
    if(activator.GetTeam()==3)
    {//Only allow CT trigger
        EntFireByHandle(caller, "FireUser1", "", 0.0, null, null);
        EntFireByHandle(self, "RunScriptCode", "soundPlay(5,0)", 0.0, caller, null);
        if(b_mg_valid == number)
        {//enable finish condition
            b_mg_success <- true;
            EntFire("b_gr_linear2", "Close", "", 0.0, null);
        }
        else
        {//give indication that wrong generator was chosen
            local coords = caller.GetOrigin();
            EntFire("map_spark_template", "ForceSpawn", "", 0.0, null);
            EntFireByHandle(self, "RunScriptCode", "sparkingStart(10,"+coords.x+","+coords.y+","+(coords.z+RandomInt(20,50))+",0,0)", 0.05, null, null);
            EntFireByHandle(activator, "SetHealth", "0", 0.0, null, null);//punish(electrocute) the player for choosing the wrong generator
        }
        //Lock buttons for next round
        EntFire("b_mg_button*", "Lock", "", 0.0, null);
        EntFire("b_mg_sprite*", "HideSprite", "", 0.0, null);
        EntFireByHandle(self, "RunScriptCode", "checkPower("+number+")", 5.0, null, null);
        b_mg_counter++;
    }
}

//-----------------------------//
//**  Path Charlie (Subway)  **//

//* Subway Trains *//

//Variables
c_attempted <- false;//If players have attempted path charlie (the trigger is as you exit the subway tunnels)
c_completed <- false;//If players have completed the path, regardless of the minigame
c_explain <- [  "⠀\x04 [ C ]\x01 If you are in the\x0f elevator\x01 right now, you will be headed to the\x02 station's server room",
                "⠀\x04 [ C ]\x01 I need you to\x02 gather some data\x01 on the\x0f server racks\x01",
                "⠀\x04 [ C ]\x01 I will explain more once you are nearby"];
c_trains_chat <- [  "⠀\x04 [ C ]\x01 Oh almost forgot to say... there are still\x02 trains\x0f in the tunnels",
                    "⠀\x04 [ C ]\x01 The\x0f trains\x01 are\x02 automated by the city\x01, I cannot do anything about them from here",
                    "⠀\x04 [ C ]\x01 Safe to say, you should\x02 get out of its way\x01 when one comes"];
c_trigger_chat <- [ "⠀\x04 [ C ]\x01 Heads up, you need to flip a switch in a hallway to your right after the door opens",
                    "⠀\x04 [ C ]\x01 It's the manual override of the servers, allowing me to access them remotely"];
c_chat_it <- 0;

//Display to players the purpose of path charlie
function charlieExplain()
{
    ScriptPrintMessageChatAll(c_explain[c_chat_it]);
    if(c_chat_it == c_explain.len()-1)
    {
        c_chat_it = 0;
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "charlieExplain()", 4.0, null, null);
    c_chat_it++;
}

//Spawns trains in the subway tunnel
function spawnHurtTrain()
{
    EntFire("train_template_hurt", "ForceSpawn", "", 0.0, null);
}

//Let players know of deadly trains
function spawnTrainChat()
{
    ScriptPrintMessageChatAll(c_trains_chat[c_chat_it]);
    if(c_chat_it == c_trains_chat.len()-1)
    {
        c_chat_it = 0;
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "spawnTrainChat()", 4.0, null, null);
    c_chat_it++;
}

//Spawns all trains in the subway tunnel
function startHurtTrainSequence()
{
    EntFireByHandle(self, "RunScriptCode", "spawnTrainChat()", 9, null, null);
    EntFireByHandle(self, "RunScriptCode", "spawnHurtTrain()", 0, null, null);
    EntFireByHandle(self, "RunScriptCode", "spawnHurtTrain()", 1, null, null);
    EntFireByHandle(self, "RunScriptCode", "spawnHurtTrain()", 2, null, null);
    EntFireByHandle(self, "RunScriptCode", "spawnHurtTrain()", 8, null, null);
    EntFireByHandle(self, "RunScriptCode", "spawnHurtTrain()", 9, null, null);
    EntFireByHandle(self, "RunScriptCode", "spawnHurtTrain()", 10, null, null);
    EntFireByHandle(self, "RunScriptCode", "spawnHurtTrain()", 16, null, null);
    EntFireByHandle(self, "RunScriptCode", "spawnHurtTrain()", 17, null, null);
    EntFireByHandle(self, "RunScriptCode", "spawnHurtTrain()", 18, null, null);
}

//Let players know to trigger the server room minigame
function serverTriggerChat()
{
    ScriptPrintMessageChatAll(c_trigger_chat[c_chat_it]);
    if(c_chat_it == c_trigger_chat.len()-1)
    {
        c_chat_it = 0;
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "serverTriggerChat()", 4.0, null, null);
    c_chat_it++;
}

//* Minigame *//

/* Note: the minigame was heavily revamped in v2.
 * One of reoccuring problem was that people were triggering incorrectly (either intentionally or by mistake) a lot more than anticipated
 * which led to long time spent on the minigame.
 * The hurting mechanism was made for this, but it obviously did not do enough as a deterrent.
 * With v2, the map now restricts players who have made 2 mistakes from participating in the future rounds.
 * Additionally, if a player has made an error in the previous round, they cannot participate in the next consecutive round.
 */

//Variables
c_mg_monitor_it <- 0;//iterates through all monitors
c_mg_monitor_prev <- 0;//Compare with previous round
c_mg_rounds <- 6;//total amount of rounds
c_mg_max_servers <- 26;//amount of server racks present
c_mg_wait <- 5;//time to wait until next round of minigame
c_mg_rgb <- [   "255 0 0", "0 255 0", "0 0 255", "255 255 0", "0 255 255",
                "255 0 255","255 255 255", "255 125 0", "125 255 0", "0 255 125",
                "0 125 255", "125 0 255", "125 255 255", "255 125 255"];//List of possible rgb values
c_mg_max_options <- 8;//amount of sprite/button to spawn for each round
c_mg_min_x <- [479,577,639,750,918,         750,918,750,918,934,        934,462,462,479,479,        577,577,622,745,807,        698,698,929,929,1057,1057];//minimum x position for template spawner
c_mg_max_x <- [479,577,639,890,1058,        890,1058,890,1058,1074,     1074,602,602,479,479,       577,577,762,745,807,        838,838,929,929,1057,1057];//maximum x
c_mg_min_y <- [5590,5590,5590,5745,5745,    5615,5615,5553,5553,5455,   5393,5391,5329,4910,5078,   4910,5078,5201,5246,5246,   5009,5071,4910,5078,4910,5078];//minimum y
c_mg_max_y <- [5730,5730,5730,5745,5745,    5615,5615,5553,5553,5455,   5393,5391,5329,5050,5218,   5050,5218,5201,5386,5386,   5009,5071,5050,5218,5050,5218];//maximum y
c_mg_min_z <- -42;//minimum z
c_mg_max_z <- 34;//maximum z
c_mg_chat_intro <- ["⠀\x04 [ C ]\x01 I need some data from the servers... it's been a while since I had to do everything manually",
                    "⠀\x04 [ C ]\x01 I will let you know which one I need by\x0f colors on displays\x01, and you have to\x02 find the correct server rack",
                    "⠀\x04 [ C ]\x01 Let me know when you are ready"];
c_mg_chat <- [  "⠀\x04 [ C ]\x01 Yes, that is what I wanted. Sending a new request now",
                "⠀\x04 [ C ]\x01 Looks correct, requesting a new one",
                "⠀\x04 [ C ]\x01 This is correct, yeah. Relaying a new one",
                "⠀\x04 [ C ]\x01 Perfect. Keep it up",
                "⠀\x04 [ C ]\x01 Uhh nope. Try this one instead",
                "⠀\x04 [ C ]\x01 Sorry, but you sent the wrong one. Try again",
                "⠀\x04 [ C ]\x01 Nah. Let's try a different one",
                "⠀\x04 [ C ]\x01 Huh? No, this ain't right. Let's try this then"];
c_mg_warned_chat <- ["⠀\x04 [ C ]\x01 I need those info and I can't do it without you",
                    "⠀\x04 [ C ]\x01 Do you really want to leave now?"];
c_mg_success_chat <- [  "⠀\x04 [ C ]\x01 I think I got everything I wanted!",
                        "⠀\x04 [ C ]\x01 Okay, let's get going then",
                        "⠀\x02 [ CONSOLE ]\x04 Charlie\x01 minigame:\x04 SUCCESS"];
c_mg_timeover_chat <- [  "⠀\x04 [ C ]\x01 What? Oh, I think the manual override got reverted",
                        "⠀\x04 [ C ]\x01 It will be a headache to set that up again... let's just get going",
                        "⠀\x02 [ CONSOLE ]\x04 Charlie\x01 minigame:\x02 FAILED"];
c_mg_chat_it <- 0;
c_mg_warned <- false;
c_mg_success <- false;
c_mg_inprogress <- false;//if the mg is in progress or not
c_mg_max_time <- 30;//max time to wait for each server hack round
c_mg_counter <- 0;//counts the amount of attempts
c_mg_pre_ban <- [];//list of players who made one mistake (another mistake bans them from mg)
c_mg_ban <- [];//list of players who made two mistakes, and banned from mg
c_mg_mistaker <- null;//holds handle of player who made incorrect choice in previous round

//Introduce the server minigame to players
function serverChatIntro()
{
    ScriptPrintMessageChatAll(c_mg_chat_intro[c_mg_chat_it]);
    if(c_mg_chat_it == 2)
    {
        EntFire("c_mg_wt", "Unlock", "", 2.0, null);
        EntFire("c_mg_quit_wt", "Unlock", "", 4.0, null);
        EntFire("c_mg_wt_sprite", "ShowSprite", "", 2.0, null);
        EntFire("c_mg_quit_wt_sprite", "ShowSprite", "", 4.0, null);
        c_mg_chat_it = 0;
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "serverChatIntro()", 4.0, null, null);
    c_mg_chat_it++;
}

//Skip the server room and move on to next area
function exitCharlie()
{
    EntFire("c_mg_wt", "Lock", "", 0.0, null);
    EntFire("c_mg_quit_wt", "Lock", "", 0.0, null);
    EntFire("c_mg_wt_sprite", "HideSprite", "", 0.0, null);
    EntFire("c_mg_quit_wt_sprite", "HideSprite", "", 0.0, null);
    if(c_mg_warned)
    {//If players want to exit even after the warning
        ScriptPrintMessageChatAll("⠀\x04 [ C ]\x01 This is not great but alright");
        EntFire("c_mg*", "Kill", "", 0.0, null);
        EntFire("c_sv_door1", "Open", "", 2.0, null);
        EntFire("c_sv_door2", "Open", "", 2.0, null);
        EntFire("c_sv_button1", "KillHierarchy", "", 0, null);
        return;
    }
    ScriptPrintMessageChatAll(c_mg_warned_chat[c_mg_chat_it]);
    if(c_mg_chat_it==c_mg_warned_chat.len()-1)
    {
        c_mg_chat_it  = 0;
        c_mg_warned = true;
        EntFire("c_mg_wt", "Unlock", "", 1.0, null);
        EntFire("c_mg_quit_wt", "Unlock", "", 3.0, null);//Prevent potential trolling
        EntFire("c_mg_wt_sprite", "ShowSprite", "", 1.0, null);
        EntFire("c_mg_quit_wt_sprite", "ShowSprite", "", 3.0, null);
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "exitCharlie()", 4.0, null, null);
    c_mg_chat_it++;
}

//Starts the server minigame
function startServerMG()
{
    ScriptPrintMessageChatAll("⠀\x04 [ C ]\x01 Okay, I have relayed the request. Best of luck!");
    EntFireByHandle(self, "RunScriptCode", "serverHackRound()", 2.0, null, null);
    c_mg_inprogress = true;
}

//Chooses locations for the sprite and button
//Inputs: index - index of the server
function locationChooser(index)
{
    local coordinates = [0,0,0];
    coordinates[0] = RandomInt(c_mg_min_x[index],c_mg_max_x[index]);
    coordinates[1] = RandomInt(c_mg_min_y[index],c_mg_max_y[index]);
    coordinates[2] = RandomInt(c_mg_min_z,c_mg_max_z);
    return coordinates
}

//Initiates a round of server hacking minigame
function serverHackRound()
{
    //Choose location / sprite colour
    local colour_indices = indexChooser(0,c_mg_max_options,c_mg_rgb.len());
    local rack_indices = indexChooser(0,c_mg_max_options,c_mg_max_servers);
    local sprite = entityFinder("c_mg_sprite"+(c_mg_monitor_it+1));
    sprite.__KeyValueFromString("rendercolor", c_mg_rgb[colour_indices[0]]);
    EntFireByHandle(sprite, "ShowSprite", "", 0.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "soundPlayManual(8,0,1230,5312,0)", 0.0, null, null);//sound to indicate new round
    //Spawn and set sprites
    for(local it=0; it<c_mg_max_options; it++)
    {
        local coordinates = locationChooser(rack_indices[it]);
        coordinates = Vector(coordinates[0],coordinates[1],coordinates[2]);
        if(it==0)
        {//first iteration is always correct
            local entity = entityFinder("c_mg_correct_maker");
            entity.SpawnEntityAtLocation(coordinates, Vector(0,0,0));
            local correct_sprite = Entities.FindByNameNearest("c_mg_correct_sprite", coordinates, 1)
            correct_sprite.__KeyValueFromString("rendercolor", c_mg_rgb[colour_indices[it]]);
        }
        else
        {//the latter are wrong
            local entity = entityFinder("c_mg_false_maker");
            entity.SpawnEntityAtLocation(coordinates, Vector(0,0,0));
            local false_sprite = Entities.FindByNameNearest("c_mg_false_sprite", coordinates, 1)
            false_sprite.__KeyValueFromString("rendercolor", c_mg_rgb[colour_indices[it]]);
        }
    }
    EntFireByHandle(self, "RunScriptCode", "serverHackCheckTime("+c_mg_counter+")", c_mg_max_time, null, null);//start the time limit check
}

//Prints to players if they chose the correct server
//Inputs: index - if the player chose the correct one or not (0: incorrect, 1: correct, 2: all completed)
function serverHackChat(index)
{
    if(index == 1)  ScriptPrintMessageChatAll(c_mg_chat[RandomInt(0,3)]);
    else    ScriptPrintMessageChatAll(c_mg_chat[RandomInt(4,7)]);
}

//Initiates server hacking minigame (function essentially adds delay defined by c_mg_wait)
//Inputs: index - required orientation of particle
function startHackRound()
{
    if(activator.GetTeam()!=3)  return;//Only CT can trigger
    else if(activator == c_mg_mistaker)
    {//this player made incorrect choice in previous round
        if(c_mg_ban.len()>0) if(activator == c_mg_ban[c_mg_ban.len()-1])
        {//if they are banned in previous round, state they have been banned forever
            EntFire("map_c_mg_text", "SetText", "MG: You are banned from the minigame (2 mistakes made)", 0.0, null);
            EntFire("map_c_mg_text", "Display", "", 0.02, activator);
        }
        else
        {//if not, state it is only for this round
            EntFire("map_c_mg_text", "SetText", "MG: You are banned in this round (1 mistake made)", 0.0, null);
            EntFire("map_c_mg_text", "Display", "", 0.02, activator);
        }
        return;
    }
    else if(!serverCheckBan(activator))
    {//Only allow CT who are not banned from mg
        EntFireByHandle(self, "RunScriptCode", "soundPlay(7,0)", 0.0, caller, null);
        if(caller.GetName() == "c_mg_correct_button")   c_mg_monitor_it++;//If correct server is chosen, progress forward
        else
        {
            serverCheckPreBan(activator);//otherwise add player to pre-ban / ban list
            c_mg_mistaker = activator;//and not let them participate in the next round (if not banned)
        }
        //Kill all mg buttons and sprites
        EntFire("c_mg_correct_button", "Kill", "", 0.0, null);
        EntFire("c_mg_correct_sprite", "Kill", "", 0.0, null);
        EntFire("c_mg_false_button", "Kill", "", 0.0, null);
        EntFire("c_mg_false_sprite", "Kill", "", 0.0, null);
        //Create an indicative particle at the sprite location
        local origin = caller.GetOrigin();
        local particle_maker = entityFinder("c_mg_particle_maker");
        particle_maker.SpawnEntityAtLocation(origin, Vector(0,0,0));
        //Print to chat if end of mg is reached
        if(c_mg_monitor_it == c_mg_rounds)
        {
            serverHackSuccess();
            return;
        }
        else if(c_mg_monitor_prev != c_mg_monitor_it)    EntFireByHandle(self, "RunScriptCode", "serverHackChat(1)", c_mg_wait-2, null, null);//Chose correct server
        else    EntFireByHandle(self, "RunScriptCode", "serverHackChat(0)", c_mg_wait-2, null, null);//Chose wrong server
        EntFireByHandle(self, "RunScriptCode", "serverHackRound()", c_mg_wait, null, null);//Start next round
        EntFire("c_mg_particle", "Kill", "", c_mg_wait, null);
        c_mg_monitor_prev = c_mg_monitor_it;//Set for next round
        c_mg_counter++;//increase the rounds
    }
    else
    {
        EntFire("map_c_mg_text", "SetText", "MG: You are banned from the minigame (2 mistakes made)", 0.0, null);
        EntFire("map_c_mg_text", "Display", "", 0.02, activator);
    }
}

//Fires when player makes incorrect choice; iterates over c_mg_ban and see if the player is banned from mg already
//Inputs: handle - handle to the player who triggered
function serverCheckBan(handle)
{
    local banned = false;
    foreach(i in c_mg_ban)  if(i == handle)
    {//player is banned
        banned = true;
        break;
    }
    return banned;
}

//Fires when player makes incorrect choice; iterates over c_mg_pre_ban and see if the player is banned from mg already
//If player handle is found, then remove them from c_mg_pre_ban and add them to c_mg_ban
//Inputs: handle - handle to the player who triggered
function serverCheckPreBan(handle)
{
    for(local it = 0; it < c_mg_pre_ban.len(); it++)  if(c_mg_pre_ban[it] == handle)
    {//player already made an error before, ban them from joining future rounds
        c_mg_pre_ban.remove(it);
        c_mg_ban.append(handle);
        EntFire("map_c_mg_text", "SetText", "MG: You are banned in future rounds (chose 2 incorrect colours)", 0.0, null);
        EntFire("map_c_mg_text", "Display", "", 0.02, activator);
        return;
    }
    c_mg_pre_ban.append(handle);
    EntFire("map_c_mg_text", "SetText", "MG: You are banned in next round (chose incorrect colour)", 0.0, null);
    EntFire("map_c_mg_text", "Display", "", 0.02, activator);
}

//Check after c_mg_max_time if the minigame round was attempted
//Inputs: input - number of rounds completed so far
function serverHackCheckTime(input)
{
    if(input == c_mg_counter && c_mg_inprogress)    serverHackTimeOver();
}

//Fires when the minigame was not completed after c_mg_max_time
function serverHackTimeOver()
{
    EntFire("c_mg*", "Kill", "", 0.0, null);
    serverHackEnd();
    EntFireByHandle(self, "RunScriptCode", "serverHackTimeOverChat()", 0.0, null, null);
}

//Chat for serverHackTimeOver()
function serverHackTimeOverChat()
{
    ScriptPrintMessageChatAll(c_mg_timeover_chat[c_mg_chat_it]);
    if(c_mg_chat_it == c_mg_timeover_chat.len()-1)
    {
        c_mg_inprogress = false;
        finalGateUnlock();
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "serverHackTimeOverChat()", 4.0, null, null);
    c_mg_chat_it++;
}

//Fires to end the minigame regardless of the minigame completion
function serverHackEnd()
{
    EntFire("c_sv_door1", "Open", "", 9.0, null);
    EntFire("c_sv_door2", "Open", "", 9.0, null);
}

//Fires when server minigame is completed
function serverHackSuccess()
{
    c_mg_success <- true;
    c_mg_inprogress <- false;
    c_mg_chat_it = 0;
    EntFireByHandle(self, "RunScriptCode", "serverHackSuccessChat()", 3.0, null, null);
    EntFire("c_mg*", "Kill", "", 15.0, null);
    serverHackEnd();
    finalGateUnlock();
    //EntFire("debug", "Command", "echo Debug (c MG): c_mg_success = "+c_mg_success, 0.0, null);
}

function serverHackSuccessChat()
{
    ScriptPrintMessageChatAll(c_mg_success_chat[c_mg_chat_it]);
    if(c_mg_chat_it == c_mg_success_chat.len()-1)
    {
        finalGateUnlock();
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "serverHackSuccessChat()", 4.0, null, null);
    c_mg_chat_it++;
}

//-------------------//
//**  Near Finale  **//

//Variables
nf_wait_chat <- [   "⠀\x10 [ OPR ]\x01 I don't think everybody is here yet",
                    "⠀\x10 [ OPR ]\x01 I'm going to open it about\x02 20 seconds later\x01, and let everyone catch up"];
nf_elevator_chat <- [   "⠀\x10 [ OPR ]\x01 Once the gate\x0f fully opens\x01, the first elevator will leave after\x02 20 seconds",
                        "⠀\x10 [ OPR ]\x01 The second one will leave\x02 20 seconds\x0f after the first",
                        "⠀\x10 [ OPR ]\x01 Once you're at the top, just\x0f get in the room\x01 and I will prepare you for your\x02 final escape"];
nf_warn_chat <-    [    "⠀\x02 [ CONSOLE ]\x0f First elevator\x01 will leave in\x02 5 seconds",
                        "⠀\x02 [ CONSOLE ]\x0f Second elevator\x01 will leave in\x02 5 seconds",
                        "⠀\x02 [ CONSOLE ]\x0f Final gate\x01 will close in\x02 5 seconds"];
nf_explain_finale_chat <- [ "⠀\x10 [ OPR ]\x01 This is what happens next",
                            "⠀\x10 [ OPR ]\x01 The path that leads you to the surface is\x02 overwhelmed by zombies\x01. There are\x02 no ways around it",
                            "⠀\x10 [ OPR ]\x01 You have to\x02 run straight\x01 to the exit on the opposite end...",
                            "⠀\x10 [ OPR ]\x01 I will try my best to tip the favours on your side using\x0f resources you have given me\x01...",
                            "⠀\x10 [ OPR ]\x01 ...which is not a lot admittedely",
                            "⠀\x02 [ CONSOLE ]\x01 Zombies have\x02 limited vision\x01 and\x0f radar\x01 is\x02 disabled",
                            "⠀\x10 [ OPR ]\x01 But in the end, it will be just a matter of luck to escape",
                            "⠀\x10 [ OPR ]\x01 Godspeed"];
nf_chat_it <- 0;

//Determines if the gate can be opened; checks if the trigger is CT, and if none of the minigames are in progress
function finalGateTrigger()
{
    if(activator && activator.GetTeam()==3)
    {//Only allow CT trigger
        EntFireByHandle(self, "RunScriptCode", "soundPlay(18,0)", 0.0, caller, null);
        if(a_mg_inprogress)
        {//Alpha minigame is still in progress
            ScriptPrintMessageChatAll("⠀\x10 [ OPR ]\x01 I see people are still at the\x02 control room\x01... I will let you know when they are finished");
            finalGateLock();
            return;
        }
        if(b_mg_inprogress)
        {//Beta minigame is still in progress
            ScriptPrintMessageChatAll("⠀\x10 [ OPR ]\x01 I see people are still at the\x02 generator room\x01... I will let you know when they are finished");
            finalGateLock();
            return;
        }
        if(c_mg_inprogress)
        {//Charlie minigame is still in progress
            ScriptPrintMessageChatAll("⠀\x10 [ OPR ]\x01 I see people are still at the\x02 server room\x01... I will let you know when they are finished");
            finalGateLock();
            return;
        }
        //None are in progress
        EntFire("nf_wt", "FireUser1", "", 0.0, null);
    }
}

//Locks the gate + hides walkie talkie sprite at the finale gate
function finalGateLock()
{
    EntFire("nf_wt", "Lock", "", 0.0, null);
    EntFire("nf_wt_sprite", "HideSprite", "", 0.0, null);
}

//Unlocks the gate + shows walkie talkie sprite at the finale gate
function finalGateUnlock()
{
    EntFire("nf_wt", "Unlock", "", 0.0, null);
    EntFire("nf_wt_sprite", "ShowSprite", "", 0.0, null);
}

//Checks if good ending objectives are fulfilled
function determineEnding()
{
    if(a_mg_success && b_mg_success && c_mg_success) finale_good_ending = true;
}

//Starts the ending sequence
function initiateEndingSequence()
{
    if(finale_good_ending)  endingInstant();//If all players are present
    else if(a_attempted && a_completed) endingWait();//If some are still in path alpha
    else if(b_attempted && b_completed) endingWait();//If some are still in path beta
    else if(c_attempted && c_completed) endingWait();//If some are still in path charlie
    else    endingInstant();//If team did not attempt the other paths
}

//If everybody is at the final door when the button is triggered
function endingInstant()
{
    EntFireByHandle(self, "RunScriptCode", "music_stop_loops <- true;", 3.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "musicStop()", 4.0, null, null);
    ScriptPrintMessageChatAll("⠀\x10 [ OPR ]\x01 I think everybody is here? Okay, let me get the gate opening...");
    EntFire("nf_linear_north", "Open", "", 4.0, null);
    EntFireByHandle(self, "RunScriptCode", "displayEnding()", 4.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "elevatorChat()", 8.0, null, null);
}

//If part of the team is still in one of the paths
function endingWait()
{
    EntFireByHandle(self, "RunScriptCode", "endingWaitChat()", 4.0, null, null);
    EntFire("nf_linear_north", "Open", "", 28.0, null);
    EntFireByHandle(self, "RunScriptCode", "displayEnding()", 28.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "music_stop_loops <- true;", 31.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "musicStop()", 32.0, null, null);
    EntFireByHandle(self, "RunScriptCode", "elevatorChat()", 32.0, null, null);
}

//Chat for endingWait()
function endingWaitChat()
{
    ScriptPrintMessageChatAll(nf_wait_chat[nf_chat_it]);
    if(nf_chat_it == nf_wait_chat.len()-1)
    {
        nf_chat_it = 0;
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "endingWaitChat()", 4.0, null, null);
    nf_chat_it++;
}

//Display which ending is triggered
function displayEnding()
{
    if(finale_good_ending)    ScriptPrintMessageChatAll("⠀\x02 [ CONSOLE ]\x01 Triggering\x04 GOOD ENDING");
    else    ScriptPrintMessageChatAll("⠀\x02 [ CONSOLE ]\x01 Triggering\x02 BAD ENDING");
}

//Function for near ending area triggers
function nfEndingSequences()
{
    if(finale_good_ending)  EntFireByHandle(self, "RunScriptCode", "musicPlay(8,0)", 0.0, null, null);//good ending song
    else    EntFireByHandle(self, "RunScriptCode", "musicPlay(7,0)", 0.0, null, null);//bad ending song
    //Remove FTP at top
    EntFireByHandle(self, "RunScriptCode", "removeFTPIndex(2,3,4)", 20, null, null);
    //First elevator
    EntFireByHandle(self, "RunScriptCode", "elevatorWarnChat(0)", 15.0, null, null);
    EntFire("nf_lift1", "Open", "", 20.0, null);
    //Second elevator
    EntFireByHandle(self, "RunScriptCode", "elevatorWarnChat(1)", 30.0, null, null);
    EntFire("nf_lift2", "Open", "", 40.0, null);
    //Gate
    EntFire("nf_linear_top", "Open", "", 35.0, null);
    EntFireByHandle(self, "RunScriptCode", "elevatorWarnChat(2)", 50.0, null, null);
    //Prepare for finale run
    EntFireByHandle(self, "RunScriptCode", "endingChat()", 43.0, null, null);
    EntFire("nf_linear_top", "Close", "", 55.0, null);
    EntFireByHandle(self, "RunScriptCode", "chooseEnding()", 60.0 null, null);
}

//Print on chat about what to do next as the gate opens
function elevatorChat()
{
    ScriptPrintMessageChatAll(nf_elevator_chat[nf_chat_it]);
    if(nf_chat_it == nf_elevator_chat.len()-1)
    {
        nf_chat_it = 0;
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "elevatorChat()", 4.0, null, null);
    nf_chat_it++;
}

//Print on chat about what to do next as the gate opens
//Inputs: index - the index of nf_warn_chat
function elevatorWarnChat(index)
{
    ScriptPrintMessageChatAll(nf_warn_chat[index]);
}

//Explain what to do in the ending
function endingChat()
{
    ScriptPrintMessageChatAll(nf_explain_finale_chat[nf_chat_it]);
    if(nf_chat_it == nf_explain_finale_chat.len()-1)    return;
    if(nf_chat_it == 3 && finale_good_ending)   nf_chat_it++;//good ending
    if(nf_chat_it == 4 && !finale_good_ending)    nf_chat_it++;//bad ending
    EntFireByHandle(self, "RunScriptCode", "endingChat()", 4.0, null, null);
    nf_chat_it++;
}

//----------------//
//**  "Finale"  **//
//yes there are 2 "finales" now in v2; the finale at the latter half of map will be called 'The End'

//Variables
finale_zm_count <- 0;//amount of zombies at the finale
finale_human_count <- 0;//amount of humans at the finale
finale_end_zm_count <- 0;//amount of zombies present in the very final area
finale_it <- 0;
finale_good_ending <- false;
finale_zm_hp <- 450;//This is base HP if there are 1:1 human to zombie ratio
finale_in_progress <- false;//If the finale is in progress (duh)
finale_petty_mode <- false;//If humans loses 5 rounds, enable ZM glow in the bad ending as well; this is removed when they eventually win a round
finale_zm_tick <- 0.02;//time in second to iterate though each zombie
finale_door_closing <- false;//If the final door is set to close

//Determine which ending to play
function chooseEnding()
{
    //Reset FTP points
    zm_ftp_tp_list <- [];
    checkFTP();
    EntFire("finale_end_linear", "Open", "", 0.0, null);//open final finale gate
    if(finale_good_ending)    EntFireByHandle(self, "RunScriptCode", "endingGood()", 5.0, null, null);
    else
    {
        EntFireByHandle(self, "RunScriptCode", "endingBad()", 5.0, null, null);
        EntFire("map_ending_fade", "Kill", "", 5.0, null);//disable ZM disadvantage
    }
    EntFire("sprite_end_template", "ForceSpawn", "", 5.0, null);
    EntFire("nf_sprite", "Kill", "", 5.5, null);
    EntFire("finale_tp", "Enable", "", 5.5, null);
    EntFireByHandle(self, "RunScriptCode", "endingZMHPRatio()", 6.0, null, null);//calculate ZM HP in finale
    EntFire("finale_start_linear", "Open", "", 7.0, null);
    EntFireByHandle(self, "RunScriptCode", "finale_in_progress<-true;", 7.0, null, null);
}

//Links related triggers to good ending area
function endingGood()
{
    EntFire("finale_human_good_tp", "Enable", "", 0.0, null);
    EntFire("finale_tp", "AddOutput", "target dest_f_good", 0.0, null);
    EntFire("tp_spawn_postmz", "AddOutput", "target dest_f_good", 0.0, null);
    EntFire("finale_end_tp", "AddOutput", "target dest_f_good", 0.0, null);
    EntFire("map_servercommand", "Command", "sv_disable_radar 1", 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "endingZMSetGlow()", 3.0, null, null);
}

//Teleport players in the safe zone to good ending area
function endingGoodTP()
{
    local current = activator.GetOrigin();
    activator.SetOrigin(Vector((current.x-960),current.y,current.z));
}

//Teleport players to bad ending area
function endingBad()
{
    EntFire("finale_human_bad_tp", "Enable", "", 0.0, null);
    EntFire("finale_tp", "AddOutput", "target dest_f_bad", 0.0, null);
    EntFire("finale_end_tp", "AddOutput", "target dest_f_good", 0.0, null);
    EntFire("tp_spawn_postmz", "AddOutput", "target dest_f_bad", 0.0, null);
    if(finale_petty_mode)   EntFireByHandle(self, "RunScriptCode", "endingZMSetGlow()", 3.0, null, null);
}

//Teleport players in the safe zone to good ending area
function endingBadTP()
{
    local current = activator.GetOrigin();
    activator.SetOrigin(Vector((current.x-960),current.y,(current.z-480)));
}

//Calculates the HP of zombies according to the humans alive and zombies present
function endingZMHPRatio()
{
    if(finale_zm_count < 1 || finale_human_count)    return;//If for whatever reason no ZM are detected, use the base HP value
    local ratio = finale_human_count.tofloat()/finale_zm_count.tofloat();
    if(ratio<0.5)   finale_zm_hp = finale_zm_hp * pow(ratio,0.75);//ratio^0.75 if there are more zm (nerfed adjustment)
    else if(ratio>2)    finale_zm_hp = finale_zm_hp * pow(ratio,1.25);//ratio^1.25 if there are more humans (buffed adjustment)
    else    finale_zm_hp = finale_zm_hp * ratio;//equal ratio
    finale_zm_hp = finale_zm_hp.tointeger();
}

//Limits zombie health in finale and activate no HP regen
function endingZMLimitHP()
{
    if(!finale_in_progress)
    {
        EntFireByHandle(self, "RunScriptCode", "removeFTPGlow()", 0.0, activator, null);
        //Quick method; zombies less than 2500 HP likely already have no HP regen
        if(activator.GetHealth()>perished_hp)   EntFireByHandle(self, "RunScriptCode", "noZmHpRegen(0.5)", 0.5, activator, null);
    }
    else    EntFireByHandle(self, "RunScriptCode", "noZmHpRegen(0.5)", 0.0, activator, null);
    activator.SetHealth(finale_zm_hp);
}

//Creates a glow around ALL zombies in good ending; goes through each ZM with 0.05 sec interval
function endingZMSetGlow()
{
    local it = 0;
    local plyer = null;
    while((plyer = Entities.FindByClassname(plyer, "player"))!=null)
    {
        if(plyer.GetTeam()==2)
        {//Apply glow to all zombies
            EntFire("zm_ftp_template", "ForceSpawn", "", finale_zm_tick*it, null);
            EntFireByHandle(self, "RunScriptCode", "endingZMGlow()", (finale_zm_tick*it)+0.05, plyer, null);
            it++;
        }
    }
}

//Creates a glow around the specified player
function endingZMGlow()
{
    if(finale_in_progress)
    {
        local prop = Entities.FindByNameNearest("zm_ftp_glow", Vector(426,80,-822),16);
        //Stop if the zombie is dead
        if(activator == null || activator.GetHealth() < 1)
        {
            EntFireByHandle(prop, "Kill", "", 0.0, null, null);
            return;
        }
        if(RandomInt(0,1) == 1) EntFireByHandle(prop, "SetAnimation", "Idle_lower", 0.0, null, null);//Toggle between crouch and standing animations
        prop.SetOrigin(activator.GetOrigin());
        local angles = activator.GetAngles();
        prop.SetAngles(angles.x, angles.y, angles.z);
        EntFireByHandle(prop, "SetGlowEnabled", "", finale_zm_tick, null, null);
        EntFireByHandle(prop, "Kill", "", finale_zm_count*finale_zm_tick+0.1, null, null);
        EntFire("zm_ftp_template", "ForceSpawn", "", finale_zm_count*finale_zm_tick-0.05, null);
        EntFireByHandle(self, "RunScriptCode", "endingZMGlow()", finale_zm_count*finale_zm_tick, activator, null);
    }
}

//Prints in chat about anti camping
function endingAntiCamp()
{
    if(!finale_door_closing)
    {//If final door trigger has not been triggered
        EntFire("finale_anticamp", "Enable", "", 0.0, null);
        ScriptPrintMessageChatAll("⠀\x02 [ CONSOLE ]\x01 Humans are taking too long to reach the end! Enabling anti-camp measures...");
    }
}

//Detect if there are any zombies in the very end area
function zmDetect()
{
    //EntFire("debug", "Command", "echo Debug (Finale): "+finale_end_zm_count+" ZM detected", 0.0, null);
    if(finale_end_zm_count > 0)
    {//Repeat until all zombies has died
        EntFireByHandle(self, "RunScriptCode", "zmDetect()", 1.0, null, null);
        return;
    }
    if(finale_good_ending)  EntFireByHandle(self, "RunScriptCode", "endingApproach()", 0.0, null, null);//CT's won good ending!
    else
    {
        if(admin_abuse)
        {//naughty naughty
            ScriptPrintMessageChatAll("⠀\x02 [ CONSOLE ]\x01 Admin room was triggered for the win");
            ScriptPrintMessageChatAll("⠀\x02 [ CONSOLE ]\x01 Admin room was triggered for the win");
            ScriptPrintMessageChatAll("⠀\x02 [ CONSOLE ]\x01 Admin room was triggered for the win");
            ScriptPrintMessageChatAll("⠀\x02 [ CONSOLE ]\x01 Admin room was triggered for the win");
            ScriptPrintMessageChatAll("⠀\x02 [ CONSOLE ]\x01 Admin room was triggered for the win");
        }
        ScriptPrintMessageChatAll("⠀\x02 [ CONSOLE ]\x01 You have won\x02 BAD ENDING\x01!");
        ScriptPrintMessageChatAll("⠀\x02 [ CONSOLE ]\x01 Thanks for playing!");
        EntFire("map_round", "EndRound_CounterTerroristsWin", "5", 3.0, null);//CT's won!
        EntFire("map_level_counter", "SetValueNoFire", "3", 3.0, null);
    }
}

//Print in chat to kill all zombies in the very final area
function zmDetectChat()
{
    if(finale_end_zm_count>0)   ScriptPrintMessageChatAll("⠀\x02 [ CONSOLE ]\x01 Kill all zombies in the room!");
}

//  =============== ---------------- ===============   //
//                                                     //
//  =============== NEW V2 ADDITIONS ===============   //
//                                                     //
//  =============== ---------------- ===============   //

//--------------------------//
//**  Connecting Hallway  **//

//Minigame (fixing powerbox)

//Variables
item_pb_fix_coords <- [Vector(-256,-1792,60),Vector(-192,-1920,60)];//valid coordinates for powerbox fix item to spawn at
item_pb_fix_angles <- [270,0];//angles around z axis for the powerbox fix item spawns
item_pb_fix_template <- Vector(-160,-1856,60);//coordinates of powerbox fix item env_entity_maker
item_pb_fix_valid <- indexChooser(0,1,2);//chooses which powerbox item is fixable/interactable
item_pb_fix_max_time <- 10;//how long should player(s) hold on the button to fix the item
item_pb_fix_progress <- array(item_pb_fix_valid.len(),0);//dynamic list of progress on fixing powerbox; same index order as item_pb_fix_valid
item_pb_fix_pressed <- array(item_pb_fix_valid.len(),false);//dynamic list whether powerbox being fixed (i.e. button has been pressed); same index order as item_pb_fix_valid
item_pb_fix_search_radius <- 256;//radius around button to search for players to display progress information
item_pb_fix_buffer_time <- 0.1;//buffer time between calling the button back at its position until calling the progress decay function

//Creates an interactable button for the powerbox fix minigame
function itemsPBFSpawn()
{
    foreach(index in item_pb_fix_valid)
    {
        //Spawn interactable buttons for valid indices
        local maker = entityFinder("item_pb_fix_maker");
        maker.SpawnEntityAtLocation(item_pb_fix_coords[index], Vector(0,item_pb_fix_angles[index],0));
        //Enable glow on the corresponding powerbox model
        EntFire("pb"+index, "SetGlowEnabled", "", 0, null);
        //Change targetname of the button corresponding to the referred index
        local button = Entities.FindByNameNearest("pb_rot", item_pb_fix_coords[index], 16);
        EntFireByHandle(button, "AddOutput", "targetname pb_rot"+index, 0, null, null);
    }
}

//Returns whether the given index exists in item_pb_fix_valid
//Inputs: index - index to be searched
function itemsPBFIndexExists(index)
{
    foreach(i,value in item_pb_fix_valid)
    {
        if(value==index)
            return i;
    }
    return -1;
}

//Stores info about which powerboxes are being fixed
function itemsPBFActivate()
{
    local index = (caller.GetName()).slice(6).tointeger();
    local array_index = itemsPBFIndexExists(index);
    if(array_index==-1)
    {//if the given index is not listed in item_pb_fix_valid, quit function; this should not occur!
        EntFire("debug", "Command", "echo Debug (items): invalid powerbox fix index given!", 0.0, null);
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "itemsPBFProgress("+array_index+",1)", 0, null, caller);
}

//Gives progress update on given powerbox; activated only once per powerbox when activated at its 'reset' state
//Inputs: index - index item_pb_fix_activated; NOT THE INDEX OF POWERBOX
//        operation - whether to add or deduct progress
function itemsPBFProgress(index, operation)
{
    //Skip the function if the button is actively pressed
    if(item_pb_fix_pressed[index])
        return;
    local progress = item_pb_fix_progress[index];
    //Set the text for players
    if(caller)
        EntFireByHandle(self, "RunScriptCode", "itemsPBFText("+item_pb_fix_progress[index]+")", 0, null, caller);
    if(!operation && !item_pb_fix_progress[index])//if the powerbox is let to be reset
        return;
    if(item_pb_fix_progress[index]==item_pb_fix_max_time)
    {//if the powerbox is fully repaired
        if(entityFinder("pb_rot"+item_pb_fix_valid[index]))
        {
            EntFireByHandle(self, "RunScriptCode", "soundPlay(8,0)", 0, caller, null);
            EntFire("pb_rot"+item_pb_fix_valid[index], "Kill", "", 0.02, null);
        }
        return;
    }
    //Move the button away from the powerbox to simulate "holding" the button to get fixed
    local coords = item_pb_fix_coords[item_pb_fix_valid[index]];
    EntFire("pb_rot"+item_pb_fix_valid[index], "AddOutput", "origin 0 0 0", 0, null);
    if(operation)
    {//Add progress as button is held
        item_pb_fix_progress[index] = item_pb_fix_progress[index] + 1;
        EntFireByHandle(self, "RunScriptCode", "itemsPBFProgress("+index+",0)", 1+item_pb_fix_buffer_time, null, caller);
        EntFire("pb_rot"+item_pb_fix_valid[index], "AddOutput", "origin "+coords.x+" "+coords.y+" "+coords.z, 1, null);
        item_pb_fix_pressed[index] = true;
        EntFireByHandle(self, "RunScriptCode", "item_pb_fix_pressed["+index+"] = false;", 1, null, caller);
    }
    else if(!operation)
    {//Decay progress as button is not held
        item_pb_fix_progress[index] = item_pb_fix_progress[index] - 1;
        EntFireByHandle(self, "RunScriptCode", "itemsPBFProgress("+index+",0)", 0.5+item_pb_fix_buffer_time, null, caller);
        EntFire("pb_rot"+item_pb_fix_valid[index], "AddOutput", "origin "+coords.x+" "+coords.y+" "+coords.z, 0.5, null);
    }
}

//Creates corresponding text indicating the progress of the powerbox fix
//Inputs: fill - how many empty boxes should be filled
function itemsPBFText(fill)
{
    local text = "";
    if(fill==item_pb_fix_max_time)
        text = "Complete\n[ ";
    else
        text = "Progress\n[ ";
    //Progress bar depends on item_pb_fix_max_time; each bar is one second
    for(local i=0;i<item_pb_fix_max_time;i++)
        if(i<fill)
            text = text + "■ ";
        else
            text = text + "□ ";
    text = text + "]";
    EntFire("pb_text", "SetText", text, 0, null);
    if(fill==item_pb_fix_max_time)
        EntFire("pb_text", "AddOutput", "color 0 255 0", 0, null);
    else
        EntFire("pb_text", "AddOutput", "color 255 255 255", 0, null);
    local ply = null;
    while(null != (ply = Entities.FindByClassnameWithin(ply, "player", caller.GetOrigin(), 128)))   if(ply.GetTeam() == 3)
    {
        EntFire("pb_text", "Display", "", 0, ply);
    }
}

//-------------//
//  Admin Room //
//-------------//

//Position: 0 -16 -1016

//Variables
admin_abuse <- false;//If the admin room has been accessed
admin_a_chat <- [   "⠀\x03 [ ADMIN ]\x01 Setting up the office minigame...",
                    "⠀\x03 [ ADMIN ]\x01 You have infinite time (999 seconds) for practice",
                    "⠀\x03 [ ADMIN ]\x01 Remember, you have to trigger on both floors (use noclip in console)",
                    "⠀\x03 [ ADMIN ]\x01 Good luck!"];
admin_b_chat <- [   "⠀\x03 [ ADMIN ]\x01 Setting up the generator minigame...",
                    "⠀\x03 [ ADMIN ]\x01 Look at the fans above for the correct generator (the correct one is\x02 number "+b_mg_valid+"\x01)",
                    "⠀\x03 [ ADMIN ]\x01 Remember, choosing the wrong one kills you (use god in console)",
                    "⠀\x03 [ ADMIN ]\x01 Good luck!"];
admin_c_chat <- [   "⠀\x03 [ ADMIN ]\x01 Setting up the server minigame...",
                    "⠀\x03 [ ADMIN ]\x01 Setting infinite time (999 seconds) per round, but with maximum colour options for practice",
                    "⠀\x03 [ ADMIN ]\x01 Remember, you need to choose the correct colour on the displays",
                    "⠀\x03 [ ADMIN ]\x01 Good luck!"];
admin_ftp_chat <- [ "⠀\x03 [ ADMIN ]\x01 Spawning glowing zombie models at all possible forward spawn coordinates",
                    "⠀\x03 [ ADMIN ]\x01 "+zm_fsp_coords.len()+" in subway platform, "+zm_fa_coords.len()+" in alpha, "+zm_fb_coords.len()+" in bravo, "+
                    zm_fc_coords.len()+" in charlie, "+zm_fnf_coords.len()+" in near finale area",
                    "⠀\x03 [ ADMIN ]\x01 Good hunting!"];
admin_tm_chat <- [  "⠀\x03 [ ADMIN ]\x01 Spawning glowing transmitters at all possible coordinates",
                    "⠀\x03 [ ADMIN ]\x01 There are "+item_tm_coordx.len()+" possible coordinates in total, only 1 is breakable",
                    "⠀\x03 [ ADMIN ]\x01 They are broken by knifing the cover, and pressing the button inside",
                    "⠀\x03 [ ADMIN ]\x01 Remember only zombies (terrorists) can trigger",
                    "⠀\x03 [ ADMIN ]\x01 Good hunting!"];
admin_gc_chat <- [  "⠀\x03 [ ADMIN ]\x01 Spawning glowing ground cables at all possible coordinates",
                    "⠀\x03 [ ADMIN ]\x01 There are "+item_gc_coordx.len()+" possible coordinates in total, only 1 is breakable",
                    "⠀\x03 [ ADMIN ]\x01 They are broken by jumping on the cover 3 times, and knifing the cables inside",
                    "⠀\x03 [ ADMIN ]\x01 Remember only zombies (terrorists) can trigger",
                    "⠀\x03 [ ADMIN ]\x01 Good hunting!"];
admin_pb_chat <- [  "⠀\x03 [ ADMIN ]\x01 Spawning glowing power boxes at all possible coordinates",
                    "⠀\x03 [ ADMIN ]\x01 There are "+item_pb_coordx.len()+" possible coordinates in total, only 1 is breakable",
                    "⠀\x03 [ ADMIN ]\x01 They are broken by knifing the cover, and knifing the cables inside",
                    "⠀\x03 [ ADMIN ]\x01 Remember only zombies (terrorists) can trigger",
                    "⠀\x03 [ ADMIN ]\x01 Good hunting!"];
admin_rp_chat <- [  "⠀\x03 [ ADMIN ]\x01 Spawning glowing report (black clipboard models) at all possible coordinates",
                    "⠀\x03 [ ADMIN ]\x01 There are "+item_rp_coordx.len()+" possible coordinates in total",
                    "⠀\x03 [ ADMIN ]\x01 Pay close attention to their textures",
                    "⠀\x03 [ ADMIN ]\x01 Good hunting!"];
admin_chat_it <- 0;

//If the admin room has been accessed
function adminAccess()
{
    ScriptPrintMessageChatAll("⠀\x03 [ ADMIN ]\x01 Admin room has been accessed");
    ScriptPrintMessageChatAll("⠀\x03 [ ADMIN ]\x01 Admin room has been accessed");
    ScriptPrintMessageChatAll("⠀\x03 [ ADMIN ]\x01 Admin room has been accessed");
    EntFire("item_pb_template1", "ForceSpawn", "", 0.0, null);
    EntFire("item_gc_template1", "ForceSpawn", "", 0.0, null);
    EntFire("item_tm_template1", "ForceSpawn", "", 0.0, null);
    EntFire("item_rp_template", "ForceSpawn", "", 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "adminSpawnItems()", 0.5, null, null);
}

//Spawns items on walls for display
function adminSpawnItems()
{
    for(local i = 0; i < 4; i++)
    {
        switch(i)
        {
        case 0:
        {
            local box = Entities.FindByNameNearest("item_pb_box1", Vector(392,-232,-756),8);//Coords at item_pb_template1
            box.SetOrigin(Vector(-40,128,-960)) ;
            box.SetAngles(0,180,0);
            break;
        }
        case 1:
        {
            local cable = Entities.FindByNameNearest("item_gc_prop1", Vector(472,-72,-808),8);//Coords at item_gc_template1
            cable.SetOrigin(Vector(40,96,-1040));
            cable.SetAngles(0,0,0);
            break;
        }
        case 2:
        {
            local box = Entities.FindByNameNearest("item_tm_prop1", Vector(392,-136,-718),8);//Coords at item_tm_template1
            box.SetOrigin(Vector(120,128,-960));
            box.SetAngles(0,180,0);
            break;
        }
        case 3:
        {
            local report = Entities.FindByNameNearest("item_rp_prop",Vector(392,-296,-816),8);//coordinates at item_report_template
            report.SetOrigin(Vector(-120,128,-960));
            report.SetAngles(0,0,90);
            break;
        }
        }
    }
}

//Sets up alpha minigame for practice
function adminA()
{
    EntFire("sprite_a_mg_template", "ForceSpawn", "", 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "adminAChat()", 0.0, null, null);
    a_bottom_triggered <- 1;
    a_top_triggered <- 1;
    a_mg_totduration <- 999;
    a_mg_terminals <- 8;
    EntFire("a_mg_wt_sprite", "ShowSprite", "", 3.0, null);
    EntFire("a_mg_wt", "Unlock", "", 3.0, null);
}

//Chat for adminA()
function adminAChat()
{
    ScriptPrintMessageChatAll(admin_a_chat[admin_chat_it]);
    if(admin_chat_it == admin_a_chat.len()-1)
    {
        admin_chat_it = 0;
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "adminAChat()", 1.0, null, null);
    admin_chat_it++;
}

//Sets up bravo minigame for practice
function adminB()
{
    EntFire("sprite_b2_template", "ForceSpawn", "", 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "adminBChat()", 0.0, null, null);
    b_mg_max_time <- 999;
    setUpGenerator();
    EntFire("b_sw_linear4", "SetSpeed", "176", 0.0, null);
    EntFire("b_sw_linear4", "Open", "", 0.0, null);
    EntFire("a_mg_wt_sprite", "Kill", "", 0.0, null);
    EntFire("b_mg_wt", "Kill", "", 0.0, null);
    EntFire("a_mg_quit_wt_sprite", "Kill", "", 0.0, null);
    EntFire("b_mg_quit_wt", "Kill", "", 0.0, null);
    EntFire("b_gr_door1", "Open", "", 0.0, null);
    EntFire("b_gr_door2", "Open", "", 0.0, null);
    EntFire("b_mg_button*", "Unlock", "", 0.0, null);
    EntFire("b_mg_sprite*", "ShowSprite", "", 0.0, null);
}

//Chat for adminB()
function adminBChat()
{
    ScriptPrintMessageChatAll(admin_b_chat[admin_chat_it]);
    if(admin_chat_it == admin_b_chat.len()-1)
    {
        admin_chat_it = 0;
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "adminBChat()", 1.0, null, null);
    admin_chat_it++;
}

//Sets up charlie minigame for practice
function adminC()
{
    EntFire("sprite_c_mg_template", "ForceSpawn", "", 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "adminCChat()", 0.0, null, null);
    c_mg_max_options <- c_mg_rgb.len();
    c_mg_max_time <- 999;
    EntFire("c_sv_linear4", "Open", "", 0.0, null);
    EntFire("c_mg_wt_sprite", "HideSprite", "", 0.0, null);
    EntFire("c_mg_wt", "Lock", "", 0.0, null);
    EntFire("c_mg_wt_sprite", "ShowSprite", "", 3.0, null);
    EntFire("c_mg_wt", "Unlock", "", 3.0, null);
}

//Chat for adminC()
function adminCChat()
{
    ScriptPrintMessageChatAll(admin_c_chat[admin_chat_it]);
    if(admin_chat_it == admin_c_chat.len()-1)
    {
        admin_chat_it = 0;
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "adminCChat()", 1.0, null, null);
    admin_chat_it++;
}

//Chat to let know good ending is triggered
function adminFinaleGoodEndingChat()
{
    ScriptPrintMessageChatAll("⠀\x03 [ ADMIN ]\x01 Good ending has been triggered");
}

//Spawns glowing model at all possible forward spawn locations
function adminFTP()
{
    EntFireByHandle(self, "RunScriptCode", "adminFTPChat()", 0.0, null, null);
    local it = 0;
    local model = null;
    for(local i = 0; i < zm_fsp_coords.len(); i++)
    {
        EntFire("zm_ftp_template", "ForceSpawn", "", it, null);
        EntFireByHandle(self, "RunScriptCode", "adminFTPLoop(0,"+i+")", it+0.05, null, null);
        it = it + 0.1;
    }
    for(local i = 0; i < zm_fa_coords.len(); i++)
    {
        EntFire("zm_ftp_template", "ForceSpawn", "", it, null);
        EntFireByHandle(self, "RunScriptCode", "adminFTPLoop(1,"+i+")", it+0.05, null, null);
        it = it + 0.1;
    }
    for(local i = 0; i < zm_fb_coords.len(); i++)
    {
        EntFire("zm_ftp_template", "ForceSpawn", "", it, null);
        EntFireByHandle(self, "RunScriptCode", "adminFTPLoop(2,"+i+")", it+0.05, null, null);
        it = it + 0.1;
    }
    for(local i = 0; i < zm_fc_coords.len(); i++)
    {
        EntFire("zm_ftp_template", "ForceSpawn", "", it, null);
        EntFireByHandle(self, "RunScriptCode", "adminFTPLoop(3,"+i+")", it+0.05, null, null);
        it = it + 0.1;
    }
    for(local i = 0; i < zm_fnf_coords.len(); i++)
    {
        EntFire("zm_ftp_template", "ForceSpawn", "", it, null);
        EntFireByHandle(self, "RunScriptCode", "adminFTPLoop(4,"+i+")", it+0.05, null, null);
        it = it + 0.1;
    }
}

//Loop function to iterate through each zm_ftp coord arrays
//Inputs: index - index to reference each zm_ftp coord array
//        array_index - index in the said array above
function adminFTPLoop(index, array_index)
{
    switch(index)
    {
    case 0:
    {
        local model = Entities.FindByNameNearest("zm_ftp_glow", Vector(426,80,-822),16);
        EntFireByHandle(model, "AddOutput", "origin "+zm_fsp_coords[array_index], 0.0, null, null);
        EntFireByHandle(model, "SetGlowEnabled", "", 0.0, null, null);
        break;
    }
    case 1:
    {
        local model = Entities.FindByNameNearest("zm_ftp_glow", Vector(426,80,-822),16);
        EntFireByHandle(model, "AddOutput", "origin "+zm_fa_coords[array_index], 0.0, null, null);
        EntFireByHandle(model, "SetGlowEnabled", "", 0.0, null, null);
        break;
    }
    case 2:
    {
        local model = Entities.FindByNameNearest("zm_ftp_glow", Vector(426,80,-822),16);
        EntFireByHandle(model, "AddOutput", "origin "+zm_fb_coords[array_index], 0.0, null, null);
        EntFireByHandle(model, "SetGlowEnabled", "", 0.0, null, null);
        break;
    }
    case 3:
    {
        local model = Entities.FindByNameNearest("zm_ftp_glow", Vector(426,80,-822),16);
        EntFireByHandle(model, "AddOutput", "origin "+zm_fc_coords[array_index], 0.0, null, null);
        EntFireByHandle(model, "SetGlowEnabled", "", 0.0, null, null);
        break;
    }
    case 4:
    {
        local model = Entities.FindByNameNearest("zm_ftp_glow", Vector(426,80,-822),16);
        EntFireByHandle(model, "AddOutput", "origin "+zm_fnf_coords[array_index], 0.0, null, null);
        EntFireByHandle(model, "SetGlowEnabled", "", 0.0, null, null);
        break;
    }
    }
}

//Chat for adminFTP()
function adminFTPChat()
{
    ScriptPrintMessageChatAll(admin_ftp_chat[admin_chat_it]);
    if(admin_chat_it == admin_ftp_chat.len()-1)
    {
        admin_chat_it = 0;
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "adminFTPChat()", 1.0, null, null);
    admin_chat_it++;
}

//Spawns glowing transmitter model at all possible forward spawn locations
function adminTM()
{
    EntFire("item_tm_prop1", "Kill", "", 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "adminTMChat()", 0.0, null, null);
    item_tm_indices = indexChooser(0,item_tm_coordx.len(),item_tm_coordx.len());
    itemsTM();
    EntFire("item_tm_prop1", "SetGlowEnabled", "", (item_tm_coordx.len()*0.1)+0.5, null);
}

//Chat for adminTM()
function adminTMChat()
{
    ScriptPrintMessageChatAll(admin_tm_chat[admin_chat_it]);
    if(admin_chat_it == admin_tm_chat.len()-1)
    {
        admin_chat_it = 0;
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "adminTMChat()", 1.0, null, null);
    admin_chat_it++;
}

//Spawns glowing ground cable model at all possible forward spawn locations
function adminGC()
{
    EntFire("item_gc_prop1", "Kill", "", 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "adminGCChat()", 0.0, null, null);
    item_gc_indices = indexChooser(0,item_gc_coordx.len(),item_gc_coordx.len());
    itemsGC();
    EntFire("zm_b_spawn3", "Open", "", 0.0, null);//open the gate for one of the ground cable spawn
    EntFire("item_gc_prop1", "SetGlowEnabled", "", (item_gc_coordx.len()*0.1)+0.5, null);
}

//Chat for adminGC()
function adminGCChat()
{
    ScriptPrintMessageChatAll(admin_gc_chat[admin_chat_it]);
    if(admin_chat_it == admin_gc_chat.len()-1)
    {
        admin_chat_it = 0;
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "adminGCChat()", 1.0, null, null);
    admin_chat_it++;
}

//Spawns glowing ground cable model at all possible forward spawn locations
function adminPB()
{
    EntFire("item_pb_box1", "Kill", "", 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "adminPBChat()", 0.0, null, null);
    item_pb_indices = indexChooser(0,item_pb_coordx.len(),item_pb_coordx.len());
    itemsPB();
    EntFire("item_pb_box1", "SetGlowEnabled", "", (item_pb_coordx.len()*0.1)+0.5, null);
}

//Chat for adminPB()
function adminPBChat()
{
    ScriptPrintMessageChatAll(admin_pb_chat[admin_chat_it]);
    if(admin_chat_it == admin_pb_chat.len()-1)
    {
        admin_chat_it = 0;
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "adminPBChat()", 1.0, null, null);
    admin_chat_it++;
}

//Spawns glowing ground cable model at all possible forward spawn locations
function adminRP()
{
    EntFire("item_rp_prop*", "Kill", "", 0.0, null);
    EntFire("item_rp_button*", "Kill", "", 0.0, null);
    EntFireByHandle(self, "RunScriptCode", "adminRPChat()", 0.0, null, null);
    local it = 0;
    for(local i = 0; i < item_rp_coordx.len(); i++)
    {
        EntFire("item_rp_template", "ForceSpawn", "", it, null);
        EntFireByHandle(self, "RunScriptCode", "allocateReport("+RandomInt(0,13)+","+i+")", it+0.05, null, null);
        it = it + 0.1;
    }
    EntFire("item_rp_button*", "Kill", "", it+0.5, null);
    EntFire("item_rp_prop*", "SetGlowEnabled", "", it+0.5, null);
}

//Chat for adminRP()
function adminRPChat()
{
    ScriptPrintMessageChatAll(admin_rp_chat[admin_chat_it]);
    if(admin_chat_it == admin_rp_chat.len()-1)
    {
        admin_chat_it = 0;
        return;
    }
    EntFireByHandle(self, "RunScriptCode", "adminRPChat()", 1.0, null, null);
    admin_chat_it++;
}

//Fires in chat for spawning players back to spawn from admin room
function adminSpawnTP()
{
    ScriptPrintMessageChatAll("⠀\x03 [ ADMIN ]\x01 Spawning back at spawn room...");
}

//Fires in chat that the intro cinematics has been skipped, or if it has already been skipped / completed
function adminIntroSkip()
{
    if(stage == 0)  ScriptPrintMessageChatAll("⠀\x03 [ ADMIN ]\x01 Skipping intro cinematics...");
    else    ScriptPrintMessageChatAll("⠀\x03 [ ADMIN ]\x01 Intro cinematics has already been skipped / finished!");
}

//Fires in chat that debug mode is activated
function adminDebug()
{
    ScriptPrintMessageChatAll("⠀\x03 [ ADMIN ]\x01 Debug mode activated. All map related functions / outputs have been stopped");
}