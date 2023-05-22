//This script lists all the functions used for triggering

function trigSPBigGateWest()
{
    EntFire("map_script", "RunScriptCode", "zm_spawn_sp1 <- true;", 3, null);
    EntFire("map_script", "RunScriptCode", "enableAFKTP(0)", 4, null);
    EntFire("map_script", "RunScriptCode", "removeFTPIndex(0,3,0)", 5, null);
}

function trigSPBigGateEast()
{
    EntFire("map_script", "RunScriptCode", "zm_spawn_sp2 <- true;", 3, null);
    EntFire("map_script", "RunScriptCode", "enableAFKTP(0)", 4, null);
    EntFire("map_script", "RunScriptCode", "removeFTPIndex(0,3,0)", 5, null);
}

function trigSPPreSplit()
{
    EntFire("sprite_a1_template", "ForceSpawn", "", 0, null);
    EntFire("map_script", "RunScriptCode", "addFTP(3,4,0)", 0.0, null);
    EntFire("map_script", "RunScriptCode", "removeFTPIndex(3,4,0)", 12, null);
    EntFire("map_script", "RunScriptCode", "addFTP(0,3,1)", 13, null);
    EntFire("map_script", "RunScriptCode", "preSplit()", 15, null);
    //spawn next triggers
    EntFire("map_script", "RunScriptCode", "addTrigToQueue(-1008,1170,736,5,3)", 0, null);
    EntFire("map_script", "RunScriptCode", "addTrigToQueue(-640,1256,736,5,4)", 0, null);
    EntFire("map_script", "RunScriptCode", "addTrigToQueue(400,1568,752,8,5)", 0, null);
    //and lock them
    EntFireByHandle(self, "RunScriptCode", "trigSPPreSplitDelay()", 2, null, null);
}

//Delayed function for trigSPPreSplit to lock buttons and hide sprites
function trigSPPreSplitDelay()
{
    local coords =  [Vector(-1008,1170,736),Vector(-640,1256,736),Vector(400,1568,752)];
    for(local i=0;i<3;i++)
    {
        local button = Entities.FindByNameNearest("trig_button", coords[i], 16);
        EntFireByHandle(button, "Lock", "", 0, null, null);
        local sprite = Entities.FindByNameNearest("trig_sprite", coords[i], 16);
        EntFireByHandle(sprite, "HideSprite", "", 0, null, null);
    }
}

function trigSPA()
{
    EntFire("map_script", "RunScriptCode", "removeFTPIndex(0,3,1)", 0, null);
    EntFire("map_script", "RunScriptCode", "addFTP(3,5,1)", 0, null);
    EntFire("map_script", "RunScriptCode", "addTrigToQueue(-1014,1982,752,15,6)", 0, null);
}

function trigSPB()
{
    EntFire("map_script", "RunScriptCode", "addFTP(0,1,2)", 0, null);
    EntFire("sprite_b1_template", "ForceSpawn", "", 0, null);
    EntFire("map_script", "RunScriptCode", "addTrigToQueue(-832,1872,216,8,10)", 0, null);
}

function trigSPC()
{
    EntFire("map_script", "RunScriptCode", "addFTP(0,2,3)", 0, null);
    EntFire("map_script", "RunScriptCode", "removeFTPIndex(0,1,3)", 8, null);
    EntFire("sprite_c1_template", "ForceSpawn", "", 0, null);
    EntFire("map_script", "RunScriptCode", "charlieExplain()", 2, null);
    EntFire("sp_up_linear_lift", "Close", "", 6, null);
    EntFire("map_script", "RunScriptCode", "addTrigToQueue(760,1080,-56,8,14)", 0, null);
}

function trigAOffice1()
{
    EntFire("map_script", "RunScriptCode", "addTrigToQueue(-472,2272,752,10,7)", 0, null);
    EntFire("a_mr_vent", "Break", "", 0, null);
    EntFire("map_script", "RunScriptCode", "zm_spawn_a1 <- true;", 9, null);
    EntFire("map_script", "RunScriptCode", "enableAFKTP(1)", 10, null);
    EntFire("map_script", "RunScriptCode", "removeFTPIndex(3,5,1)", 12, null);
    EntFire("map_script", "RunScriptCode", "addFTP(5,7,1)", 12, null);
}

function trigAOffice2()
{
    EntFire("map_script", "RunScriptCode", "addTrigToQueue(398,2448,664,15,8)", 0, null);
    EntFire("map_script", "RunScriptCode", "removeFTPIndex(5,7,1)", 5, null);
    EntFire("sp_up_break", "Break", "", 7, null);
}

function trigAOffice3()
{
    EntFire("map_script", "RunScriptCode", "addTrigToQueue(128,2688,672,7,-1)", 0, null);
    EntFire("map_script", "RunScriptCode", "addTrigToQueue(-384,2656,672,10,-1)", 0, null);
    EntFire("map_script", "RunScriptCode", "addFTP(7,8,1)", 0, null);
    EntFire("map_script", "RunScriptCode", "removeFTPIndex(7,8,1)", 12, null);
    EntFire("sprite_a2_template", "ForceSpawn", "", 0, null);
    EntFire("sp_sprite", "Kill", "", 0, null);
    EntFire("a_tw_door3", "Open", "", 18, null);
    EntFire("a_tw_door4", "Open", "", 18, null);
}

function trigASp()
{
    EntFire("map_script", "RunScriptCode", "removeFTPIndex(8,9,1)", 0, null);
}

trig_a_final <- false;
trig_a_final2 <- false;

function trigAFinal()
{
    if(!trig_a_final2)
    {
        EntFire("a_nf_door7", "Close", "", 0.02, null);
        EntFire("a_nf_door8", "Close", "", 0.02, null);
    }
    trig_a_final <- true;
}

function trigAFinal2()
{
    if(!trig_a_final)
    {
        EntFire("a_nf_door5", "Close", "", 0.02, null);
        EntFire("a_nf_door6", "Close", "", 0.02, null);
    }
    EntFire("sprite_nf_template", "ForceSpawn", "", 0, null);
    EntFire("a_sprite2", "Kill", "", 0, null);
    EntFire("a_nf_door5", "Open", "", 10, null);
    EntFire("a_nf_door6", "Open", "", 10, null);
    EntFire("a_nf_door10", "Open", "", 10, null);
    EntFire("a_nf_door11", "Open", "", 10, null);
    trig_a_final2 <- true;
}

function trigBSewer1()
{
    EntFire("map_script", "RunScriptCode", "removeFTPIndex(0,1,2)", 0, null);
    EntFire("map_script", "RunScriptCode", "addFTP(1,3,2)", 0, null);
    EntFire("map_script", "RunScriptCode", "setUpGenerator()", 0, null);
    EntFire("map_script", "RunScriptCode", "addTrigToQueue(-1712,1980,216,10,11)", 0, null);
    EntFire("map_script", "RunScriptCode", "addTrigToQueue(-1712,2532,216,10,11)", 0, null);
}

function trigBSewer2()
{
    EntFire("map_script", "RunScriptCode", "removeFTPIndex(1,3,2)", 5, null);
    EntFire("map_script", "RunScriptCode", "addFTP(3,4,2)", 5, null);
    local coords = [Vector(-1712,1980,216),Vector(-1712,2532,216)];
    foreach(coord in coords)
    {
        local button = Entities.FindByNameNearest("trig_button", coord, 16);
        EntFireByHandle(button, "Kill", "", 0, null, null);
        local sprite = Entities.FindByNameNearest("trig_sprite", coord, 16);
        EntFireByHandle(sprite, "Alpha", "100", 0, null, null);
        EntFireByHandle(sprite, "Kill", "", 15, null, null);
    }
    EntFire("map_script", "RunScriptCode", "addTrigToQueue(-3460,2808,216,10,12)", 0, null);
    EntFire("map_script", "RunScriptCode", "addTrigToQueue(-2908,2808,216,10,12)", 0, null);
}

function trigBSewer3()
{
    EntFire("map_script", "RunScriptCode", "removeFTPIndex(3,4,2)", 5, null);
    local coords = [Vector(-3460,2808,216),Vector(-2908,2804,216)];
    foreach(coord in coords)
    {
        local button = Entities.FindByNameNearest("trig_button", coord, 16);
        EntFireByHandle(button, "Kill", "", 0, null, null);
        local sprite = Entities.FindByNameNearest("trig_sprite", coord, 16);
        EntFireByHandle(sprite, "Alpha", "100", 0, null, null);
        EntFireByHandle(sprite, "Kill", "", 15, null, null);
    }
    EntFire("map_script", "RunScriptCode", "addTrigToQueue(-1872,3796,216,10,13)", 0, null);
    EntFire("map_script", "RunScriptCode", "addTrigToQueue(-1872,3244,216,10,13)", 0, null);
}

function trigBSewer4()
{
    local coords = [Vector(-1872,3796,216),Vector(-1872,3244,216)];
    foreach(coord in coords)
    {
        local button = Entities.FindByNameNearest("trig_button", coord, 16);
        EntFireByHandle(button, "Kill", "", 0, null, null);
        local sprite = Entities.FindByNameNearest("trig_sprite", coord, 16);
        EntFireByHandle(sprite, "Alpha", "100", 0, null, null);
        EntFireByHandle(sprite, "Kill", "", 15, null, null);
    }
}

function trigCSubway1()
{
    EntFire("map_script", "RunScriptCode", "removeFTPIndex(1,2,3)", 0, null);
    EntFire("map_script", "RunScriptCode", "addFTP(2,4,3)", 0, null);
}

trig_c_subway_trig <- false;

function trigCSubwayMid()
{
    EntFire("map_script", "RunScriptCode", "removeFTPIndex(4,6,3)", 0, null);
    if(!trig_c_subway_trig)
    {
        EntFire("map_script", "RunScriptCode", "addTrigToQueue(-32,4576,-44,10,16)", 0, null);
        trig_c_subway_trig <- true;
    }
}

function trigCSubwayEnd()
{
    EntFire("sprite_c2_template", "ForceSpawn", "", 0, null);
    EntFire("map_script", "RunScriptCode", "serverTriggerChat()", 2, null);
}

//not part of trig_functions
function trigCServerDelete()
{
    local button = Entities.FindByNameNearest("trig_button", Vector(232,5006,-40), 16);
    if(!button)
        return;
    local sprite = Entities.FindByNameNearest("trig_sprite", Vector(232,5006,-40), 16);
    EntFireByHandle(button, "Kill", "", 0, null, null);
    EntFireByHandle(sprite, "Kill", "", 0, null, null);
}

function trigCServerLift()
{
    EntFire("map_script", "RunScriptCode", "addFTPNF()", 0, null);
}