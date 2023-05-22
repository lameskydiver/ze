/*  script for ze_aaa_ohio, made by lameskydiver/chinny
 *  written for cincinnati (aka mist) stage
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
g_cn_normal_chat <- [   "\x01You find yourself in some ancient ruins...",//[0]
                        "\x01You feel as if you are about to dodge some schwing schwing's soon...",
                        "\x02STAGE RULE:\x02 HUMANS\x01 and\x04 ZOMBIES\x01 will compete with each other trying to dodge more laser than the other team",
                        "\x02STAGE RULE:\x01 Both teams are\x02 INVINCIBLE\x01 (i.e. cannot die due) to lasers \x02 and to each other, and set to 100 HP",
                        "\x02STAGE RULE:\x01 Higher dodge performance as\x02 HUMANS\x01 will\x04 add humans's health",
                        "\x02STAGE RULE:\x01 Higher dodge performance as\x04 ZOMBIES\x01 will\x02 subtract humans's health",//[5]
                        "\x02STAGE RULE:\x01 HP increase (or decrease) for\x02 HUMANS\x01 is calculated at the end",
                        "\x0bLASERFRIEND RULE:\x02 HUMANS\x01 can declare themself as a\x0b LASERFAG\x01 by shooting up",
                        "\x0bLASERFRIEND RULE:\x01 More\x0b LASERFAGS\x01 give additional HP",
                        "\x0bLASERFRIEND RULE:\x01 You WILL die if you let your HP drain to 0 by the end",
                        "\x0bLASERFRIEND RULE:\x01 Every\x0b LASERFAG's\x01 death will bring\x02 negative HP",//[10]
                        "\x0bLASERFRIEND RULE:\x01 Watch out! Your death has\x02 serious consequences!"
                        "\x01Only the chosen may survive..."];//[12]
g_cn_extreme_chat <- [  "\x01You find yourself in the same ancient ruins as before...",//[0]
                        "\x02STAGE RULE:\x01 Same rules apply! But now there are\x02 2 attacks\x01 per sequence...",
                        "\x02STAGE RULE:\x01 ...and\x02 reverse attacks\x01 are possible at any point",
                        "\x02STAGE RULE:\x01 Unlike in normal mode,\x02 upcoming attacks\x01 will be shown",
                        "\x02STAGE RULE:\x01 And everybody is given\x02 150 HP",
                        "\x02STAGE RULE: The dragon\x01 will be trying to\x02 reclaim its throne",//[5]
                        "\x02STAGE RULE:\x01 Shoot the dragon to stagger it,\x02 or you will face total annihilation",
                        "\x02STAGE RULE:\x01 The dragon will not hesitate to kill you this time, stay away from it!",
                        "\x0bLASERFRIEND RULE:\x02 HUMANS\x01 can still declare themself as a\x0b LASERFAG\x01 by shooting up",
                        "\x0bLASERFRIEND RULE:\x01 The additional modifiers for the HP calculation will be the same...",
                        "\x0bLASERFRIEND RULE:\x01 But can you face the challenge?",//[10]
                        "\x01Only the chosen may survive..."];//[11]

//print on chat set messages
function printCNChat(it)
{
    if(!::g_extreme)
    {
        ScriptPrintMessageChatAll(" \x10<< "+g_cn_normal_chat[it]+" \x10>>");
        if(it<g_cn_normal_chat.len()-1)
            EntFireByHandle(self, "RunScriptCode", "printCNChat("+(it+1)+")", 2, null, null);
    }
    else
    {
        ScriptPrintMessageChatAll(" \x10<< "+g_cn_extreme_chat[it]+" \x10>>");
        if(it<g_cn_extreme_chat.len()-1)
            EntFireByHandle(self, "RunScriptCode", "printCNChat("+(it+1)+")", 2, null, null);
    }
}

// ----------------------------- //
// +   Cincinnati Mist Stage   + //
// ----------------------------- //

g_cn_origin <- Vector(0,-7168,-6144);
g_cn_interval <- 0.811;//based on 74 BPM of music

// +   General   + //

function precacheCincinnati()
{
    // +   Music   + //
    self.PrecacheScriptSound("music/chinny/masked_ball.mp3");
    self.PrecacheScriptSound("music/chinny/grandma_(destruction)_biggest_bird.mp3");
    // +   Sound   + //
    self.PrecacheScriptSound("sfx/chinny/ohyeah1.mp3");
    self.PrecacheScriptSound("sfx/chinny/ohyeah2.mp3");
    self.PrecacheScriptSound("sfx/chinny/ohyeah3.mp3");
    self.PrecacheScriptSound("sfx/chinny/baller_announce.mp3");
    self.PrecacheScriptSound("sfx/chinny/boom.mp3");
    self.PrecacheScriptSound("sfx/chinny/blade_out.mp3");
    self.PrecacheScriptSound("sfx/chinny/square_appear.mp3");
    self.PrecacheScriptSound("sfx/chinny/square_fire.mp3");
    self.PrecacheScriptSound("sfx/chinny/fire_alert.mp3");
    self.PrecacheScriptSound("sfx/chinny/fire_fire.mp3");
    self.PrecacheScriptSound("sfx/chinny/laser_charge.mp3");
    self.PrecacheScriptSound("sfx/chinny/laser_fire.mp3");
    self.PrecacheScriptSound("sfx/chinny/ball_charge.mp3");
    self.PrecacheScriptSound("sfx/chinny/ball_fire.mp3");
    self.PrecacheScriptSound("sfx/chinny/calculating.mp3");
    self.PrecacheScriptSound("sfx/chinny/hp.mp3");
}

//teleport out and clean up all entities
function cincinnatiEnd()
{
    endStage();
    cincinnatiReset();
    EntFire("chinny_cn_end_ct_tp","Enable","",0.5,null);
    EntFire("chinny_cn_end_all_tp","Enable","",5,null);
    EntFireByHandle(self, "RunScriptCode", "cleanUp()", 6, null, null);
}

//variables
g_mist_dragon_spawn <- Vector(g_cn_origin.x,g_cn_origin.y,g_cn_origin.z+640);
g_mist_dragon_dest <- Vector(g_cn_origin.x-8192,g_cn_origin.y,g_cn_origin.z+640);
g_mist_afk_loc <- Vector(g_cn_origin.x-8192,g_cn_origin.y,0);
g_mist_humans <- [];
g_mist_zms <- [];
g_mist_human_hits <- 0.0;
g_mist_tot_human_hits <- 0.0;
g_mist_human_dodge_perc <- 0.0;
g_mist_zm_hits <- 0.0;
g_mist_tot_zm_hits <- 0.0;
g_mist_zm_dodge_perc <- 0.0;
g_mist_laserfriends <- [];
g_mist_laserfriends_kill <- [];//apparantely you can't SetHealth(0) with damage filters!
g_mist_hit_hp <- -10;
g_mist_restart_regen <- false;
g_mist_active <- false;
g_mist_attacks_tot <- 7;
/* 0: sweeping eagle
 * 1: baller balls
 * 2: classic lasers
 * 3: squares
 * 4: side attacks
 * 5: celeste laser
 * 6: celeste balls
 */
g_mist_attack_it <- 0;
g_mist_second_attack_it <- 0;
g_mist_attacks_pending <- [];
g_mist_attacks_completed <- [];
g_mist_attacks_upcoming <- [];
g_mist_attacks_upcoming_reverse <- [];
g_mist_attack_sequence_it <- 0;
g_mist_attack_sequence_tot <- 9;
g_mist_attack_paused <- false;
g_mist_attack_dist <- 10192;
g_mist_staggered <- false;
g_mist_hits <- 25;
g_mist_laserfriends_alive <- 0;
g_mist_hp_start <- 100;
g_mist_hp_gain <- 0;
g_mist_max_speed <- 400;
g_mist_dead_humans <- [];
g_mist_dead_zombies <- [];
g_mist_alive_laserfriend_hp_modifier <- 5;
g_mist_dead_laserfriend_hp_modifier <- 7;
g_mist_base_hp_gain <- 5;

function cincinnatiReset()
{
    g_mist_dragon_spawn = Vector(g_cn_origin.x,g_cn_origin.y,g_cn_origin.z+640);
    g_mist_dragon_dest = Vector(g_cn_origin.x-8192,g_cn_origin.y,g_cn_origin.z+640);
    g_mist_afk_loc = Vector(g_cn_origin.x-8192,g_cn_origin.y,0);
    g_mist_humans = [];
    g_mist_zms = [];
    g_mist_human_hits = 0.0;
    g_mist_tot_human_hits = 0.0;
    g_mist_human_dodge_perc = 0.0;
    g_mist_zm_hits = 0.0;
    g_mist_tot_zm_hits = 0.0;
    g_mist_zm_dodge_perc = 0.0;
    g_mist_laserfriends = [];
    g_mist_laserfriends_kill = [];
    g_mist_restart_regen = false;
    g_mist_active = false;
    g_mist_attack_it = 0;
    g_mist_second_attack_it = 0;
    g_mist_attacks_pending = [];
    g_mist_attacks_completed = [];
    g_mist_attacks_upcoming = [];
    g_mist_attacks_upcoming_reverse = [];
    g_mist_attack_sequence_it = 0;
    g_mist_attack_paused = false;
    g_mist_staggered = false;
    g_mist_laserfriends_alive = 0;
    g_mist_hp_start = 100;
    g_mist_hp_gain = 0;
    g_mist_dead_humans = [];
    g_mist_dead_zombies = [];
}

//fires for normal mode of cincinnati mist stage
function cincinnatiNormal()
{
    precacheCincinnati();
    EntFireByHandle(self, "RunScriptCode", "musicPlay(\"music/chinny/masked_ball\",::g_music_on)", 2, null, null);
    EntFireByHandle(self, "RunScriptCode", "printCNChat(0)", 3, null, null);
    EntFireByHandle(self, "RunScriptCode", "musicStop()", 29.9, null, null);
    EntFireByHandle(self, "RunScriptCode", "startLasers()", 30, null, null);
}

//fires for extreme mode of cincinnati mist stage
function cincinnatiExtreme()
{
    precacheCincinnati();
    g_mist_dragon_spawn.x -= 8192;
    g_mist_dragon_dest.x += 8192;
    g_mist_hp_start = 150;
    EntFireByHandle(self, "RunScriptCode", "musicPlay(\"music/chinny/masked_ball\",::g_music_on)", 2, null, null);
    local tp = Entities.FindByName(null,"chinny_cn_entry_tp");
    tp.__KeyValueFromString("target","chiny_dest_cn_extreme");
    tp = Entities.FindByName(null, "chinny_cn_entry_all_tp");
    tp.__KeyValueFromString("target","chiny_dest_cn_extreme");
    EntFireByHandle(self, "RunScriptCode", "printCNChat(0)", 3, null, null);
    EntFireByHandle(self, "RunScriptCode", "musicStop()", 26.9, null, null);
    EntFireByHandle(self, "RunScriptCode", "startLasers()", 27, null, null);
}

//IM THE BIGGEST BIRD
function biggestBird()
{
    musicPlay("music/chinny/grandma_(destruction)_biggest_bird",::g_music_on);
    EntFireByHandle(self, "RunScriptCode", "lyricsDisplay()", 1.6, null, null);
}

//spawn in the dragon and change its related settings
function spawnDragon()
{
    local orient = Vector(0,0,0)
    if(::g_extreme)
        orient = Vector(0,180,0);
    local maker = Entities.FindByName(null,"chinny_maker_cn_dragon");
    maker.SpawnEntityAtLocation(g_mist_dragon_spawn, orient);
    EntFire("chinny_cn_dragon_baller","SetParentAttachment","baller",0,null);
}

//forces players to jump in arena
function booster()
{
    local vel = activator.GetVelocity();
    if((pow(vel.x,2)+pow(vel.y,2))>pow(g_mist_max_speed,2))
    {
        local modifier = pow(g_mist_max_speed,2)/(pow(vel.x,2)+pow(vel.y,2));
        vel.x = vel.x * modifier;
        vel.y = vel.y * modifier;
    }
    activator.SetVelocity(Vector(vel.x,vel.y,RandomInt(300,400)));
}

// +   L A S E R S   + //

//starts the overall laser sequences
function startLasers()
{
    EntFire("chinny_cn_fade3","FadeReverse","",0,null);
    EntFire("chinny_cn_entry_break","Break","",1,null);
    EntFire("chinny_cn_entry_all_tp","Enable","",10,null);
    biggestBird();
    spawnDragon();
    attackArrayRefill();
    EntFire("chinny_cn_timer","Enable","",0,null);
    EntFire("chinny_cn_particle_side","Start","",0,null);
    EntFireByHandle(self, "RunScriptCode", "dragonSpeaks()", 9.75, null, null);
    EntFireByHandle(self, "RunScriptCode", "enactFairness()", 10, null, null);
    EntFireByHandle(self, "RunScriptCode", "attackSequences()", 13.75, null, null);
    EntFire("chinny_cn_fade","AddOutput","rendercolor 255 0 0",0,null);
    EntFire("chinny_cn_fade","AddOutput","renderamt 75",0,null);
    g_mist_active = true;
    if(::g_extreme)
    {
        g_mist_attacks_upcoming.append(attackChoose());
        g_mist_attacks_upcoming.append(attackChoose());
        g_mist_attacks_upcoming_reverse = [RandomInt(0,1),RandomInt(0,1)];
        maintainHitStats();
    }
}

//flavour text before laser spawn
function dragonSpeaks()
{
    if(!::g_extreme)
        ScriptPrintMessageChatAll(" \x02<< so smug... but for how long? >>");
    else
        ScriptPrintMessageChatAll(" \x02<< do not try to stop me... you are only delaying the inevitable >>");
}

//count number of humans and zm's in the schwing area
function counter()
{
    if(activator.GetTeam()==3)
        g_mist_humans.append(activator);
    else if(activator.GetTeam()==2)
        g_mist_zms.append(activator);
}

function clearCounter()
{
    g_mist_humans.clear();
    g_mist_zms.clear();
}

//back-up counter function to fire independently of player OnStartTouch
//DEBUG NOTE: this causes offset between human versus (bot) zombies hit performances - not a concern for live server
function counterSecondary()
{
    g_mist_humans.clear();
    g_mist_zms.clear();
    local ply = null;
    while((ply=Entities.FindByClassname(ply, "player"))!=null)
    {
        if(ply && ply.IsValid() &&  ply.GetOrigin().z<g_cn_origin.z+1600)
        {
            if(ply.GetTeam()==3)
                g_mist_humans.append(ply);
            else if(ply.GetTeam()==2)
                g_mist_zms.append(ply);
        }
    }
}

//set everyone to 100HP before lasers
//finalx3: rewritten so that everybody is set to 100 HP
function enactFairness()
{
    local ply = null;
    while((ply=Entities.FindByClassname(ply, "player"))!=null)  if(ply && ply.IsValid())
    {
        ply.ValidateScriptScope();
        ply.GetScriptScope().oldhp <- ply.GetHealth();
        ply.GetScriptScope().prevhp <- g_mist_hp_start;
        ply.SetHealth(g_mist_hp_start);
        EntFireByHandle(self, "RunScriptCode", "restrictRegen()", randVal(g_cn_interval,g_cn_interval*3,2), ply, null);
    }
}

//restric HP regeneration
//finalx3: rewritten so that everybody has HP restricted
function restrictRegen()
{
    if(g_mist_restart_regen || !activator || activator.GetHealth()<=0 || !(activator.IsValid()))
        return;
    if(!("prevhp" in activator.GetScriptScope()))
    {
        activator.SetHealth(g_mist_hp_start);
        activator.ValidateScriptScope();
        activator.GetScriptScope().prevhp <- g_mist_hp_start;
    }
    else
    {
        local prev_hp = activator.GetScriptScope().prevhp;
        local current_hp = activator.GetHealth();
        if(prev_hp<current_hp)
            activator.SetHealth(prev_hp);
        else
            activator.GetScriptScope().prevhp <- current_hp;
    }
    EntFireByHandle(self, "RunScriptCode", "restrictRegen()", g_cn_interval, activator, null);
}

//reset original HP onto player + kill laserfriends who fucked up
//finalx3: rewritten so that everybody has gets their original HP back
function setOriginalHP()
{
    g_mist_restart_regen = true;
    local ply = null;
    while((ply=Entities.FindByClassname(ply, "player"))!=null)  if(ply && ply.IsValid())
    {
        ply.ValidateScriptScope();
        if("oldhp" in ply.GetScriptScope())
        {
            ply.SetHealth(ply.GetScriptScope().oldhp);
            continue;
        }
        else if(ply.GetTeam()==2)
        {
            ply.SetHealth(5000);
            continue;
        }
        else if(ply.GetTeam()==3)
            ply.SetHealth(100);
    }
    foreach(ply in g_mist_laserfriends_kill) if(ply && ply.IsValid())
    {
        EntFireByHandle(ply, "SetHealth", "0", 0, null, null);
        ScriptPrintMessageChatAll(" \x10<<\x01 lmao should have offlined more loser\x10 >>");
    }
}

//finalx3: when player touches the boss (extreme mode)
function touchedBoss()
{
    if(!activator || !(activator.IsValid()))
        return;
    if(activator.GetTeam()==2)
    {
        local vel = activator.GetVelocity();
        vel.x = -vel.x * 2;
        if(abs(vel.x)<250)
            vel.x = 500;
        if(abs(vel.x)>1000)
            vel.x = 1000;
        activator.SetVelocity(vel);
    }
    else if(activator.GetTeam()==3)
    {
        EntFireByHandle(activator, "SetDamageFilter", "mortal", 0, null, null);
        EntFireByHandle(activator, "SetDamageFilter", "immortal", 0.98, null, null);
        changeHealth(-20,3);
        EntFireByHandle(activator, "ignitelifetime", "1", 0.02, null, null);
    }
}

//manages the attack sequences
function attackSequences()
{
    local reverse = [];
    if(g_mist_attack_sequence_it>=g_mist_attack_sequence_tot)
    {
        endBoss();
        return;
    }
    if(g_mist_attack_sequence_it==5 && !g_mist_attack_paused)
    {
        EntFireByHandle(self, "RunScriptCode", "attackSequences()", 1.55, null, null);
        if(!::g_extreme)
        {
            ScriptPrintMessageChatAll(" \x10<<\x01 REVERSE ATTACKS INBOUND!\x10 >>");
            ScriptPrintMessageChatAll(" \x10<<\x01 REVERSE ATTACKS INBOUND!\x10 >>");
            ScriptPrintMessageChatAll(" \x10<<\x01 REVERSE ATTACKS INBOUND!\x10 >>");
            ScriptPrintMessageChatAll(" \x10<<\x01 REVERSE ATTACKS INBOUND!\x10 >>");
        }
        g_mist_attack_paused = true;
        return;
    }
    if(!g_mist_attack_sequence_it)
    {
        EntFire("chinny_cn_gravity","Enable","",0,null);
        EntFire("chinny_cn_booster","Enable","",0,null);
        EntFire("chinny_cn_afk","Toggle","",0,null);
        if(::g_extreme)
        {
            EntFire("chinny_cn_dragon_hitbox","SetDamageFilter","",0,null);
            //EntFire("chinny_cn_push","Disable","",0,null);
            EntFire("chinny_cn_dragon_move","Open","",0,null);
            EntFire("chinny_cn_dragon_kill","Enable","",0,null);
            EntFire("chinny_cn_dragon_kill","FireUser1","",0,null);
        }
        EntFire("chinny_cn_afk_tp","Enable","",0,null);
        EntFire("chinny_cn_afk_tp","Disable","",0.5,null);
        maintainHitStats();
    }
    local attack = [];
    if(!::g_extreme)
    {
        if((g_mist_attack_sequence_it==5||g_mist_attack_sequence_it==6) && g_mist_attack_paused)
        {
            reverse.append(1);
            if(g_mist_attack_sequence_it == 5)
                attack.append(g_mist_attacks_completed[RandomInt(0,1)]);
            if(g_mist_attack_sequence_it == 6)
                attack.append(g_mist_attacks_completed[RandomInt(2,4)]);
        }
        else
        {
            reverse.append(0);
            attack.append(attackChoose());
        }
    }
    else
    {
        foreach(a in g_mist_attacks_upcoming)
            attack.append(a);
        g_mist_attacks_upcoming.clear();
        foreach(r in g_mist_attacks_upcoming_reverse)
            reverse.append(r);
        g_mist_attacks_upcoming_reverse.clear();
        if(g_mist_attack_sequence_it<g_mist_attack_sequence_tot-1)
        {
            g_mist_attacks_upcoming.append(attackChoose());
            g_mist_attacks_upcoming.append(attackChoose());
            g_mist_attacks_upcoming_reverse = [RandomInt(0,1),RandomInt(0,1)];
        }
    }
    counterSecondary();
    foreach(i,a in attack)
    {
        switch(a)
        {
            case 0:
            {
                ScriptPrintMessageChatAll(" \x10<<\x02 MIGHTY EAGLE ATTACK\x10 >>");
                attackMightyEagle(reverse[i],i);
                break;
            }
            case 1:
            {
                ScriptPrintMessageChatAll(" \x10<<\x02 BALLER ATTACK\x10 >>");
                attackBallerBalls(reverse[i],i);
                break;
            }
            case 2:
            {
                ScriptPrintMessageChatAll(" \x10<<\x02 CLASSIC LASERS ATTACK\x10 >>");
                attackClassicLasers(reverse[i],i);
                break;
            }
            case 3:
            {
                ScriptPrintMessageChatAll(" \x10<<\x02 SQUARE ATTACK\x10 >>");
                attackSquares(reverse[i],i);
                break;
            }
            case 4:
            {
                ScriptPrintMessageChatAll(" \x10<<\x02 SIDE ATTACK\x10 >>");
                attackSides(reverse[i],i);
                break;
            }
            case 5:
            {
                ScriptPrintMessageChatAll(" \x10<<\x02 LASER BEAM ATTACK\x10 >>");
                attackCeleLaser(reverse[i],i);
                break;
            }
            case 6:
            {
                ScriptPrintMessageChatAll(" \x10<<\x02 FIRE BALL ATTACK\x10 >>");
                attackCeleBall(reverse[i],i);
            }
        }
    }
    g_mist_attack_sequence_it++;
    EntFireByHandle(self, "RunScriptCode", "attackSequences()", g_cn_interval*16, null, null);
}

//choose a pending attack and remove from pending attacks array, and add to completed attacks array
function attackChoose()
{
    local it=RandomInt(0,g_mist_attacks_pending.len()-1);
    local attack_it = g_mist_attacks_pending[it];
    g_mist_attacks_pending.remove(it);
    if(g_mist_attacks_completed.len()<g_mist_attacks_tot)
        g_mist_attacks_completed.append(attack_it);
    if(g_mist_attacks_pending.len()==0)
        attackArrayRefill();
    return attack_it;
}

//refills g_mist_attacks_pending
function attackArrayRefill()
{
    if(g_mist_attacks_pending.len()>0)
        return;
    for(local i=0;i<g_mist_attacks_tot;i++)
        g_mist_attacks_pending.append(i)
}

//play related attack sfx
function attackSFX(filepath,pitch,vol,channel)
{
    local sfx1 = null;
    local sfx2 = null;
    if(!channel)
    {
        sfx1 = Entities.FindByName(null,"chinny_cn_sfx1");
        sfx2 = Entities.FindByName(null,"chinny_cn_sfx2");
    }
    else
    {
        sfx1 = Entities.FindByName(null,"chinny_cn_sfx3");
        sfx2 = Entities.FindByName(null,"chinny_cn_sfx4");
    }
    sfx1.__KeyValueFromString("message",filepath);
    sfx1.__KeyValueFromInt("pitch",RandomInt(pitch[0],pitch[1]));
    sfx1.__KeyValueFromInt("health",vol);
    sfx2.__KeyValueFromString("message",filepath);
    sfx2.__KeyValueFromInt("pitch",RandomInt(pitch[0],pitch[1]));
    sfx2.__KeyValueFromInt("health",vol);
    EntFireByHandle(sfx1,"PlaySound","",0,null,null);
    EntFireByHandle(sfx2,"PlaySound","",0,null,null);
}

//choose random player to target
function attackTarget(amount)
{
    local targets = [];
    local tgt = null;
    foreach(_ in array(amount))
    {
        if(targets.len()==0)
        {
            if(g_mist_humans.len()!=0)
            {
                while(!tgt|| !tgt.IsValid())
                    tgt = g_mist_humans[RandomInt(0,g_mist_humans.len()-1)];
                targets.append(tgt);
            }
            else if(g_mist_zms.len()!=0)
            {
                while(!tgt|| !tgt.IsValid())
                    tgt = g_mist_zms[RandomInt(0,g_mist_humans.len()-1)];
                targets.append(tgt);
            }
            else
            {
                foreach(_ in array(amount))
                    targets.append(null);
                return targets;
            }
            continue;
        }
        if(RandomInt(0,1) && g_mist_humans.len()!=0)
        {
            while(!tgt|| !tgt.IsValid())
                tgt = g_mist_humans[RandomInt(0,g_mist_humans.len()-1)];
            if(detectElement(tgt,targets))
                tgt = null;
            targets.append(tgt);
        }
        else if (g_mist_zms.len()!=0)
        {
            while(!tgt|| !tgt.IsValid())
                tgt = g_mist_zms[RandomInt(0,g_mist_zms.len()-1)];
            if(detectElement(tgt,targets))
                tgt = null;
            targets.append(tgt);
        }
        else
        {
            foreach(_ in array(amount-targets.len()))
                targets.append(null);
            return targets;
        }
    }
    return targets;
}

//attack 0: sweeping eagle
function attackMightyEagle(reverse,channel)
{
    local sound = "";
    if(!RandomInt(0,2))
        sound = "sfx/chinny/ohyeah1";
    else if(!RandomInt(0,1))
        sound = "sfx/chinny/ohyeah2";
    else
        sound = "sfx/chinny/ohyeah3";
    attackSFX(sound+".mp3",[80,110],10,channel);
    updateTotHitCounter();
    attackMightyEagleSpawn(reverse);
    if(!channel)
    {
        g_mist_attack_it++;
        if(g_mist_attack_it<4)
            EntFireByHandle(self, "RunScriptCode", "attackMightyEagle("+reverse+","+channel+")", g_cn_interval*4, null, null);
        else
            g_mist_attack_it = 0;
    }
    else
    {
        g_mist_second_attack_it++;
        if(g_mist_second_attack_it<4)
            EntFireByHandle(self, "RunScriptCode", "attackMightyEagle("+reverse+","+channel+")", g_cn_interval*4, null, null);
        else
            g_mist_second_attack_it = 0;
    }
    calculateDodgePercentage();
    updateHitStats();
}

function attackMightyEagleSpawn(reverse)
{
    local org = Entities.FindByName(null,"chinny_cn_dragon_move").GetOrigin();
    local dist = g_mist_attack_dist;
    local movedir = Vector(0,180,0);
    local orient = Vector(0,0,0);
    if(::g_extreme)
    {
        dist = abs(org.x-g_cn_origin.x)+2000;
        movedir = Vector(0,0,0);
        orient = Vector(0,180,0);
    }
    if(reverse)
    {
        if(!::g_extreme)
        {
            org.x -= dist;
            movedir = Vector(0,0,0);
            orient = Vector(0,180,0);
        }
        else
        {
            org.x += dist;
            movedir = Vector(0,180,0);
            orient = Vector(0,180,0);
        }
    }
    org.z = g_cn_origin.z;
    local parent_name = "chinny_move"+::g_lin_idx;
    moveSpawn(org,movedir,dist,2000,0,0,"","",8,0);
    local maker = Entities.FindByName(null,"chinny_maker_cn_attack1");
    local template = Entities.FindByName(null,"chinny_template_cn_attack1");
    template.ValidateScriptScope();
    template.GetScriptScope().keyvalues <- {parentname = parent_name};
    template.GetScriptScope().PreSpawnInstance <- function(entityClass,entityName)
        return keyvalues;
    maker.SpawnEntityAtLocation(org,orient);
}

//attack 1: baller balls
function attackBallerBalls(reverse,channel)
{
    local sound = ""
    if((!channel && !g_mist_attack_it)||(channel && !g_mist_second_attack_it))
    {
        sound = "sfx/chinny/baller_announce";
        EntFireByHandle(self, "RunScriptCode", "attackSFX(\""+sound+".mp3\",[100,100],10,0)", 1, null, null);
    }
    else
    {
        sound = "sfx/chinny/boom";
        attackSFX(sound+".mp3",[80,110],6,channel);
        local targets = attackTarget(4);
        local dragon_org = Entities.FindByName(null,"chinny_cn_dragon_move").GetOrigin();
        local org = dragon_org;
        foreach(tgt in targets)
        {
            local org = g_mist_dragon_spawn;
            if(tgt)
            {
                org = tgt.GetOrigin();
                org.x = dragon_org.x;
            }
            else
                org = Vector(dragon_org.x,g_cn_origin.y+RandomInt(-900,900),g_cn_origin.z+RandomInt(256,800));
            updateTotHitCounter();
            attackBallerBallsSpawn(org,reverse);
        }
    }
    if(!channel)
    {
        g_mist_attack_it++;
        if(g_mist_attack_it<8)
            EntFireByHandle(self, "RunScriptCode", "attackBallerBalls("+reverse+","+channel+")", g_cn_interval*2, null, null);
        else
            g_mist_attack_it = 0;
    }
    else
    {
        g_mist_second_attack_it++;
        if(g_mist_second_attack_it<8)
            EntFireByHandle(self, "RunScriptCode", "attackBallerBalls("+reverse+","+channel+")", g_cn_interval*2, null, null);
        else
            g_mist_second_attack_it = 0;
    }
    calculateDodgePercentage();
    updateHitStats();
}

function attackBallerBallsSpawn(org,reverse)
{
    local dist = g_mist_attack_dist;
    local movedir = Vector(0,180,0);
    if(::g_extreme)
    {
        dist = abs(org.x-g_cn_origin.x)+2000;
        movedir = Vector(0,0,0);
    }
    if(reverse)
    {
        if(!::g_extreme)
        {
            org.x -= dist;
            movedir = Vector(0,0,0);
        }
        else
        {
            org.x += dist;
            movedir = Vector(0,180,0);
        }
    }
    local parent_name = "chinny_move"+::g_lin_idx;
    moveSpawn(org,movedir,dist,2500,0,0,"","",8,0);
    local maker = Entities.FindByName(null,"chinny_maker_cn_attack2");
    local template = Entities.FindByName(null,"chinny_template_cn_attack2");
    template.ValidateScriptScope();
    template.GetScriptScope().keyvalues <- {parentname = parent_name};
    template.GetScriptScope().PreSpawnInstance <- function(entityClass,entityName)
        return keyvalues;
    maker.SpawnEntityAtLocation(org,Vector(0,0,RandomInt(0,360)));
}

//attack 2: classic lasers (varying speed)
function attackClassicLasers(reverse,channel)
{
    local sound = "sfx/chinny/blade_out";
    attackSFX(sound+".mp3",[100,100],6,channel);
    updateTotHitCounter();
    attackClassicLasersSpawn(reverse);
    if(!channel)
    {
        g_mist_attack_it++;
        if(g_mist_attack_it<8)
            EntFireByHandle(self, "RunScriptCode", "attackClassicLasers("+reverse+","+channel+")", g_cn_interval*2, null, null);
        else
            g_mist_attack_it = 0;
    }
    else
    {
        g_mist_second_attack_it++;
        if(g_mist_second_attack_it<8)
            EntFireByHandle(self, "RunScriptCode", "attackClassicLasers("+reverse+","+channel+")", g_cn_interval*2, null, null);
        else
            g_mist_second_attack_it = 0;
    }
    calculateDodgePercentage();
    updateHitStats();
}

function attackClassicLasersSpawn(reverse)
{
    local org = Entities.FindByName(null,"chinny_cn_dragon_move").GetOrigin();
    local dist = g_mist_attack_dist;
    local movedir = Vector(0,180,0);
    local orient = Vector(0,0,0);
    if(::g_extreme)
    {
        dist = abs(org.x-g_cn_origin.x)+1000;
        movedir = Vector(0,0,0);
        orient = Vector(0,180,0);
    }
    if(reverse)
    {
        if(!::g_extreme)
        {
            org.x -= (dist-1000);
            movedir = Vector(0,0,0);
            orient = Vector(0,180,0);
        }
        else
        {
            org.x += dist;
            movedir = Vector(0,180,0);
            orient = Vector(0,0,0);
        }
    }
    org.y += RandomInt(-50,50);
    org.z += RandomInt(-150,150);
    local parent_name = "chinny_move"+::g_lin_idx;
    moveSpawn(org,movedir,dist,RandomInt(500,5000),0,0,"","",8,0);
    local maker = Entities.FindByName(null,"chinny_maker_cn_attack3");
    local template = Entities.FindByName(null,"chinny_template_cn_attack3");
    template.ValidateScriptScope();
    template.GetScriptScope().keyvalues <- {parentname = parent_name};
    template.GetScriptScope().PreSpawnInstance <- function(entityClass,entityName)
        return keyvalues;
    maker.SpawnEntityAtLocation(org,Vector(0,orient.y,RandomInt(0,360)));
}

//attack 3: squares
function attackSquares(reverse,channel)
{
    for(local i=0;i<4;i++)
    {
        if(i==3)
            EntFireByHandle(self, "RunScriptCode", "attackSquaresSound("+channel+")", (i+1)*0.5, null, null);
        else
            EntFireByHandle(self, "RunScriptCode", "attackSquaresSpawn("+i+","+reverse+","+channel+")", i*0.5, null, null);
    }
    if(!channel)
    {
        g_mist_attack_it++;
        if(g_mist_attack_it<4)
            EntFireByHandle(self, "RunScriptCode", "attackSquares("+reverse+","+channel+")", g_cn_interval*4, null, null);
        else
            g_mist_attack_it = 0;
    }
    else
    {
        g_mist_second_attack_it++;
        if(g_mist_second_attack_it<4)
            EntFireByHandle(self, "RunScriptCode", "attackSquares("+reverse+","+channel+")", g_cn_interval*4, null, null);
        else
            g_mist_second_attack_it = 0;
    }
}

function attackSquaresSpawn(i,reverse,channel)
{
    updateTotHitCounter();
    local sound = "sfx/chinny/square_appear";
    attackSFX(sound+".mp3",[95+(i*10),95+(i*10)],7,channel);
    local dist = g_mist_attack_dist;
    local movedir = Vector(0,180,0);
    local org = Entities.FindByName(null,"chinny_cn_dragon_move").GetOrigin();
    if(::g_extreme)
    {
        dist = abs(org.x-g_cn_origin.x)+1000;
        movedir = Vector(0,0,0);
    }
    if(reverse)
    {
        if(!::g_extreme)
        {
            org.x -= (dist-1000);
            movedir = Vector(0,0,0);
        }
        else
        {
            org.x += dist;
            movedir = Vector(0,180,0);
        }
    }
    org.y += RandomInt(-750,750);
    org.z += RandomInt(-450,450);
    local parent_name = "chinny_move"+::g_lin_idx;
    moveSpawn(org,movedir,dist,4000,0,0,"","",8,(2-i*0.5));
    local maker = Entities.FindByName(null,"chinny_maker_cn_attack4");
    local template = Entities.FindByName(null,"chinny_template_cn_attack4");
    template.ValidateScriptScope();
    template.GetScriptScope().keyvalues <- {parentname = parent_name};
    template.GetScriptScope().PreSpawnInstance <- function(entityClass,entityName)
        return keyvalues;
    maker.SpawnEntityAtLocation(org,Vector(0,0,RandomInt(0,360)));
    calculateDodgePercentage();
    updateHitStats();
}

function attackSquaresSound(channel)
{
    local sound = "sfx/chinny/square_fire";
    attackSFX(sound+".mp3",[100,100],8,channel);
}

//attack 4: left/right attacks
function attackSides(reverse,channel)
{
    local sound = "sfx/chinny/fire_alert";
    for(local i=0;i<2;i++)
        EntFireByHandle(self, "RunScriptCode", "attackSFX(\""+sound+".mp3\",[100,100],4,"+channel+")", i*1, null, null);
    sound = "sfx/chinny/fire_fire";
    EntFireByHandle(self, "RunScriptCode", "attackSFX(\""+sound+".mp3\",[100,100],7,"+channel+")", 2, null, null);
    updateTotHitCounter();
    attackSidesSpawn(reverse);
    if(!channel)
    {
        g_mist_attack_it++;
        if(g_mist_attack_it<4)
            EntFireByHandle(self, "RunScriptCode", "attackSides("+reverse+","+channel+")", g_cn_interval*4, null, null);
        else
            g_mist_attack_it = 0;
    }
    else
    {
        g_mist_second_attack_it++;
        if(g_mist_second_attack_it<4)
            EntFireByHandle(self, "RunScriptCode", "attackSides("+reverse+","+channel+")", g_cn_interval*4, null, null);
        else
            g_mist_second_attack_it = 0;
    }
    calculateDodgePercentage();
    updateHitStats();
}

function attackSidesSpawn(reverse)
{
    local dist = g_mist_attack_dist;
    local movedir = Vector(0,180,0);
    local org = Entities.FindByName(null,"chinny_cn_dragon_move").GetOrigin();
    local orient = Vector(0,0,0);
    if(::g_extreme)
    {
        dist = abs(org.x-g_cn_origin.x)+500;
        movedir = Vector(0,0,0);
        orient = Vector(0,180,0);
    }
    if(reverse)
    {
        if(!::g_extreme)
        {
            org.x -= (dist-1500);
            movedir = Vector(0,0,0);
            orient = Vector(0,180,0);
        }
        else
        {
            org.x += dist;
            movedir = Vector(0,180,0);
            orient = Vector(0,0,0);
        }
    }
    if(RandomInt(0,1))
        org.y = g_cn_origin.y+512;
    else
        org.y = g_cn_origin.y-512;
    org.z = g_cn_origin.z+512;
    local parent_name = "chinny_move"+::g_lin_idx;
    moveSpawn(org,movedir,dist,5000,0,0,"","",8,2);
    local maker = Entities.FindByName(null,"chinny_maker_cn_attack5");
    local template = Entities.FindByName(null,"chinny_template_cn_attack5");
    template.ValidateScriptScope();
    template.GetScriptScope().keyvalues <- {parentname = parent_name};
    template.GetScriptScope().PreSpawnInstance <- function(entityClass,entityName)
        return keyvalues;
    maker.SpawnEntityAtLocation(org,orient);
    EntFire("chinny_cn_attack5_particle","Start","",0,null);
}

//attack 5: celeste laser
function attackCeleLaser(reverse,channel)
{
    for(local i=0;i<6;i++)
    {
        if(i==5)
            EntFireByHandle(self, "RunScriptCode", "attackCeleLaserFire("+reverse+","+channel+")", 3, null, null);
        else
        {
            updateTotHitCounter();
            attackCeleLaserSpawn(reverse);
        }
    }
    local sound = "sfx/chinny/laser_charge";
    attackSFX(sound+".mp3",[100,100],5,channel);
    EntFire("chinny_cn_cele_laser_particle","Start","",0,null);
    EntFire("chinny_cn_cele_laser_particle","Kill","",3,null);
    if(!channel)
    {
        g_mist_attack_it++;
        if(g_mist_attack_it<4)
            EntFireByHandle(self, "RunScriptCode", "attackCeleLaser("+reverse+","+channel+")", g_cn_interval*4, null, null);
        else
            g_mist_attack_it = 0;
    }
    else
    {
        g_mist_second_attack_it++;
        if(g_mist_second_attack_it<4)
            EntFireByHandle(self, "RunScriptCode", "attackCeleLaser("+reverse+","+channel+")", g_cn_interval*4, null, null);
        else
            g_mist_second_attack_it = 0;
    }
}

function attackCeleLaserSpawn(reverse)
{
    local org = Entities.FindByName(null,"chinny_cn_dragon_move").GetOrigin();
    local dist = g_mist_attack_dist;
    local orient = Vector(0,0,0);
    if(::g_extreme)
    {
        dist = abs(org.x-g_cn_origin.x)+500;
        orient = Vector(0,180,0);
    }
    if(reverse)
    {
        if(!::g_extreme)
        {
            org.x -= (dist-1500);
            orient = Vector(0,180,0);
        }
        else
        {
            org.x += dist;
            orient = Vector(0,0,0);
        }
    }
    org.y += RandomInt(-750,750);
    org.z += RandomInt(-350,350);
    local maker = Entities.FindByName(null,"chinny_maker_cn_cele_laser");
    maker.SpawnEntityAtLocation(org,orient);
}

function attackCeleLaserFire(reverse,channel)
{
    local sound = "sfx/chinny/laser_fire";
    attackSFX(sound+".mp3",[100,100],6,channel);
    local tgt = null;
    EntFire("chinny_cn_cele_laser","Enable","",0,null);
    local orient = Vector(0,180,0);
    if(::g_extreme)
        orient = Vector(0,0,0);
    if(reverse)
    {
        if(!::g_extreme)
            orient = Vector(0,0,0);
        else
            orient = Vector(0,180,0);
    }
    while((tgt=Entities.FindByName(tgt,"chinny_cn_cele_laser"))!=null)
        particleSpawn(tgt.GetOrigin(),orient,"custom_particle_002",2,"");
    EntFire("chinny_cn_cele_laser","Kill","",0.1,null);
    calculateDodgePercentage();
    updateHitStats();
}

//attack 6: celeste ball
function attackCeleBall(reverse,channel)
{
    local sound = "sfx/chinny/ball_charge";
    attackSFX(sound+".mp3",[100,100],3,channel);
    foreach(_ in array(2))
    {
        updateTotHitCounter();
        attackCeleBallSpawn(reverse,channel);
    }
    EntFire("chinny_cn_cele_ball_particle","Start","",0.5,null);
    if(!channel)
    {
        g_mist_attack_it++;
        if(g_mist_attack_it<16)
            EntFireByHandle(self, "RunScriptCode", "attackCeleBall("+reverse+","+channel+")", g_cn_interval, null, null);
        else
            g_mist_attack_it = 0;
    }
    else
    {
        g_mist_second_attack_it++;
        if(g_mist_second_attack_it<16)
            EntFireByHandle(self, "RunScriptCode", "attackCeleBall("+reverse+","+channel+")", g_cn_interval, null, null);
        else
            g_mist_second_attack_it = 0;
    }
    calculateDodgePercentage();
    updateHitStats();
}

function attackCeleBallSpawn(reverse,channel)
{
    local sound = "sfx/chinny/ball_fire";
    EntFireByHandle(self, "RunScriptCode", "attackSFX(\""+sound+".mp3\",[100,100],3,"+channel+")",0.5,null,null);
    local dist = g_mist_attack_dist;
    local movedir = Vector(0,180,0);
    local org = Entities.FindByName(null,"chinny_cn_dragon_move").GetOrigin();
    if(::g_extreme)
    {
        dist = abs(org.x-g_cn_origin.x)+2000;
        movedir = Vector(0,0,0);
    }
    if(reverse)
    {
        if(!::g_extreme)
        {
            org.x -= (dist-500);
            movedir = Vector(0,0,0);
        }
        else
        {
            org.x += (dist-1500);
            movedir = Vector(0,180,0);
        }
    }
    org.y += RandomInt(-850,850);
    org.z += RandomInt(-450,450);
    local parent_name = "chinny_move"+::g_lin_idx;
    moveSpawn(org,movedir,dist,3000,0,0,"","",8,0.5);
    local maker = Entities.FindByName(null,"chinny_maker_cn_cele_ball");
    local template = Entities.FindByName(null,"chinny_template_cn_cele_ball");
    template.ValidateScriptScope();
    template.GetScriptScope().keyvalues <- {parentname = parent_name};
    template.GetScriptScope().PreSpawnInstance <- function(entityClass,entityName)
        return keyvalues;
    maker.SpawnEntityAtLocation(org,Vector(0,0,0));
}

//record laser/attack hits on players
function hitCounter()
{
    if(!activator || !(activator.IsValid()))
        return;
    if(!multipleHits(activator,caller))
    {
        if((activator.GetHealth()+g_mist_hit_hp)<1)
        {
            if(activator.GetTeam()==3 && !detectElement(activator,g_mist_dead_humans))
            {
                g_mist_dead_humans.append(activator);
                if(detectElement(activator,g_mist_laserfriends) && !detectElement(activator,g_mist_laserfriends_kill))
                {
                    g_mist_laserfriends_kill.append(activator);
                    ScriptPrintMessageChatAll(" \x02<< another challenger bows to me... >>");
                }
            }
            else if(activator.GetTeam()==2 && !detectElement(activator,g_mist_dead_zombies))
                g_mist_dead_zombies.append(activator);
        }
        else
            EntFireByHandle(self, "RunScriptCode", "changeHealth("+g_mist_hit_hp+",0)", 0, activator, null);
        if(activator.GetTeam()==3)
            g_mist_human_hits++;
        else if(activator.GetTeam()==2)
            g_mist_zm_hits++;
        EntFire("chinny_cn_fade","FadeReverse","",0,activator);
    }
}

//detect if a player triggers an attack multiple times
function multipleHits(ply,object)
{
    local hit = [];
    object.ValidateScriptScope()
    if("hits" in object.GetScriptScope())
    {
        hit = object.GetScriptScope().hits;
        foreach(p in hit)   if(ply == p)
            return true;
    }
    hit.append(ply);
    object.GetScriptScope().hits <- hit;
    return false;
}

//update total potential hits for humans and zm (for dodge percentages)
function updateTotHitCounter()
{
    g_mist_tot_human_hits += g_mist_humans.len();
    g_mist_tot_zm_hits += g_mist_zms.len();
}

function calculateDodgePercentage()
{
    if(g_mist_tot_human_hits)
        g_mist_human_dodge_perc = g_mist_human_hits/g_mist_tot_human_hits*100;
    else
        g_mist_human_dodge_perc = 100.0;
    if(g_mist_tot_zm_hits)
        g_mist_zm_dodge_perc = g_mist_zm_hits/g_mist_tot_zm_hits*100;
    else
        g_mist_zm_dodge_perc = 100.0;
}

//maintain hit status hud
function maintainHitStats()
{
    if(g_mist_active)
    {
        if(::g_extreme)
            EntFire("chinny_cn_hit_count","SetHitMax",(g_mist_humans.len()*g_mist_hits).tostring(),0,null);
        updateHitStats();
        EntFireByHandle(self, "RunScriptCode", "maintainHitStats()", g_cn_interval, null, null);
    }
}

//update human and zm hit status
function updateHitStats()
{
    if(!::g_extreme)
        ScriptPrintMessageCenterAll("Hits / Total Potential Hits (Hit Percentage)\n--------------------\n"
            +"Humans : <font color='#ff0000'>"+g_mist_human_hits+"</font>/"+g_mist_tot_human_hits+" ("+roundFloat(g_mist_human_dodge_perc,0)+"%)\n"
            +"Zombies: <font color='#00ff00'>"+g_mist_zm_hits+"</font>/"+g_mist_tot_zm_hits+" ("+roundFloat(g_mist_zm_dodge_perc,0)+"%)\n");
    else
        upcomingAttackHUD();
}

//set up text to display next attacks
function upcomingAttackHUD()
{
    local text = "Upcoming Attacks\n--------------------\n";
    if(g_mist_attacks_upcoming.len()>0)
    {
        foreach(i,attack in g_mist_attacks_upcoming)
        {
            if(!g_mist_attacks_upcoming_reverse[i])
                text += "<font color='#00ff00'>"+attackNameByIndex(attack)+"</font>\n";
            else
                text += "<font color='#ff0000'>REVERSE "+attackNameByIndex(attack)+"</font>\n";
        }
    }
    else
        text += "NONE\n";
    ScriptPrintMessageCenterAll(text);
}

//return attack names by index
function attackNameByIndex(index)
{
    switch(index)
    {
        case 0:
            return "MIGHTY EAGLE";
        case 1:
            return "BALLER";
        case 2:
            return "CLASSIC LASERS";
        case 3:
            return "SQUARE";
        case 4:
            return "SIDE";
        case 5:
            return "LASER BEAM";
        case 6:
            return "FIRE BALL";
    }
}

//calculate hp gain
//finalx3: rewritten many of the hp calculation
function calculateHPGain()
{
    local hp = g_mist_base_hp_gain;
    local modifier = roundFloat(g_mist_zm_dodge_perc,0)-roundFloat(g_mist_human_dodge_perc,0);
    if(g_mist_humans.len()<=0)
        hp -= 9999;
    else
    {
        foreach(i,p in g_mist_laserfriends)
        {
            if(p && p.IsValid() && !detectElement(p,g_mist_laserfriends_kill))
                g_mist_laserfriends_alive++;
        }
        //printl(hp+", "+modifier);
        hp += (g_mist_dead_zombies.len()-g_mist_dead_humans.len()+
                ((g_mist_laserfriends_alive*g_mist_alive_laserfriend_hp_modifier)
                -(g_mist_laserfriends_kill.len()*g_mist_dead_laserfriend_hp_modifier)));
        //printl(hp+", "+modifier);
    }
    if(modifier==0)
    {
        hp += g_mist_dead_zombies.len()-g_mist_dead_humans.len();
        modifier = 1;
    }
    //printl(hp+", "+modifier);
    g_mist_hp_gain = hp*modifier;
    if(g_mist_hp_gain > 200)
        g_mist_hp_gain=200;
    else if(g_mist_hp_gain < -200)
        g_mist_hp_gain=-200;
}

//display hp calculation to players via hud
//finalx3: rewritten many of the hp calculation
function displayHPGainCalc()
{
    local text = "Calculating HP gain...\n--------------------\n";
    local sound = "sfx/chinny/calculating";
    switch(g_mist_attack_it)
    {
        case 0:
        {
            text += "'Dead' Humans: <font color='#ff0000'>"+g_mist_dead_humans.len()+"</font>\n"
                        +"'Dead' Zombies: <font color='#00ff00'>"+g_mist_dead_zombies.len()+"</font>\n----------\n"
                        +"Diff: <font color='#00ff00'>"+g_mist_dead_zombies.len()+"</font> - "
                        +"<font color='#ff0000'>"+g_mist_dead_humans.len()+"</font> = "
                        +(g_mist_dead_zombies.len()-g_mist_dead_humans.len());
            break;
        }
        case 1:
        {
            text += "Humans Hit Ratio: <font color='#ff0000'>"+g_mist_human_hits+"</font>/"+g_mist_tot_human_hits+" ("
                        +roundFloat(g_mist_human_dodge_perc,0)+"%)\nZombies H R: <font color='#00ff00'>"+g_mist_zm_hits+"</font>/"
                        +g_mist_tot_zm_hits+" ("+roundFloat(g_mist_zm_dodge_perc,0)+"%)\n----------\n"
                        +"Diff: <font color='#ff0000'>"+roundFloat(g_mist_zm_dodge_perc,0)+"</font> - "
                        +"<font color='#00ff00'>"+roundFloat(g_mist_human_dodge_perc,0)+"</font> = "+(roundFloat(g_mist_zm_dodge_perc,0)-roundFloat(g_mist_human_dodge_perc,0));
            break;
        }
        case 2:
        {
            text += "Alive laserfriends: <font color='#00ff00'>"+g_mist_laserfriends_alive+"</font> (Multiplier *+"
                        +g_mist_alive_laserfriend_hp_modifier+")\nDead Laserfriends: <font color='#ff0000'>"
                        +g_mist_laserfriends_kill.len()+"</font> (Multiplier *-"+g_mist_dead_laserfriend_hp_modifier+")";
            break;
        }
        case 3:
        {
            text += "Laserfriends Performance: (<font color='#00ff00'>"+g_mist_laserfriends_alive+" * "+g_mist_alive_laserfriend_hp_modifier
                        +"</font>) - (<font color='#ff0000'>"+g_mist_laserfriends_kill.len()+" * "+g_mist_dead_laserfriend_hp_modifier
                        +"</font>) = "+((g_mist_laserfriends_alive*g_mist_alive_laserfriend_hp_modifier)
                        -(g_mist_laserfriends_kill.len()*g_mist_dead_laserfriend_hp_modifier));
            break;
        }
        case 4:
        {
            
            if(g_mist_humans.len()<=0)
            {
                text += " - 9999 (no humans alive penalty!)";
                g_mist_hp_gain = -9999;
            }
            else if((roundFloat(g_mist_zm_dodge_perc,0)-roundFloat(g_mist_human_dodge_perc,0))==0)
                text += "["+g_mist_base_hp_gain+" + "+g_mist_dead_zombies.len()+" - "+g_mist_dead_humans.len()
                            +" + "+g_mist_laserfriends_alive*g_mist_alive_laserfriend_hp_modifier+" - "
                            +g_mist_laserfriends_kill.len()*g_mist_dead_laserfriend_hp_modifier+"]";
            else
                text += "["+g_mist_base_hp_gain+" + "+g_mist_dead_zombies.len()+" - "+g_mist_dead_humans.len()
                            +" + "+g_mist_laserfriends_alive*g_mist_alive_laserfriend_hp_modifier+" - "
                            +g_mist_laserfriends_kill.len()*g_mist_dead_laserfriend_hp_modifier+"] * "
                            +(roundFloat(g_mist_zm_dodge_perc,0)-roundFloat(g_mist_human_dodge_perc,0));
            text += "\n----------\nTotal HP gain: ";
            if(g_mist_hp_gain > 0)
                text += "<font color='#00ff00'>+"+g_mist_hp_gain+"</font>";
            else if(g_mist_hp_gain < 0)
                text += "<font color='#ff0000'>"+g_mist_hp_gain+"</font>";
            else if(g_mist_hp_gain == 0)
                text += g_mist_hp_gain;
            if(g_mist_hp_gain == 200 || g_mist_hp_gain == -200)
                text += " (Max HP)";
            sound = "sfx/chinny/hp";
            break;
        }
    }
    ScriptPrintMessageCenterAll(text);
    if(!g_mist_second_attack_it && g_mist_attack_it)
        attackSFX(sound+".mp3",[100,100],10,0);
    g_mist_second_attack_it++;
    if(g_mist_attack_it<4 && g_mist_second_attack_it>4)
    {
        if(g_mist_attack_it == 0)
            setOriginalHP();
        if(g_mist_attack_it==1)
            calculateHPGain();
        g_mist_attack_it++;
        g_mist_second_attack_it = 0;
    }
    else if(g_mist_attack_it==4)
    {
        if(g_mist_second_attack_it==4)
            mistGiveHP();
        else if(g_mist_second_attack_it>8)
            return;
    }
    EntFireByHandle(self, "RunScriptCode", "displayHPGainCalc()", g_cn_interval, null, null);
}

//give hp
function mistGiveHP()
{
    local ply = null;
    while((ply=Entities.FindByClassname(ply,"player"))!=null)    if(ply && ply.IsValid() && ply.GetTeam()==3)
        EntFireByHandle(self, "RunScriptCode", "changeHealth("+g_mist_hp_gain+",0)", 0, ply, null);
}

//stagger the boss
function staggerBoss()
{
    EntFire("chinny_cn_dragon_move","Close","",0,null);
    EntFire("chinny_cn_dragon_model","SetAnimation","hit_front",0,null);
    g_mist_staggered <- true;
}

//resume the default flying anim
function resetFlyingAnim()
{
    if(g_mist_staggered)
    {
        EntFire("chinny_cn_dragon_move","Open","",0,null);
        g_mist_staggered = false;
    }
}

//end the boss sequences
function endBoss()
{
    EntFire("spawn_tp_ct","AddOutput","target chiny_dest_cn_end",0,null);
    EntFire("spawn_tp_t","AddOutput","target chiny_dest_cn_end",0,null);
    EntFire("chinny_cn_t_tp","Enable","",0,null);
    EntFire("chinny_cn_t_tp","Kill","",0.1,null);
    EntFire("chinny_cn_gravity","Kill","",0,null);
    EntFire("chinny_cn_afk","Kill","",0,null);
    EntFire("chinny_cn_laser_clip","Kill","",0,null);
    EntFire("chinny_cn_immortal","Kill","",3,null);
    EntFire("chinny_cn_mortal","Enable","",3,null);
    EntFire("chinny_cn_dragon_model","ClearParent","",0,null);
    EntFire("chinny_cn_dragon_move","KillHierarchy","",0.1,null);
    EntFire("chinny_cn_timer","Kill","",0,null);
    EntFire("chinny_cn_push","Kill","",0,null);
    EntFire("chinny_cn_booster","Kill","",0,null);
    EntFire("chinny_cn_particle_side","Kill","",0,null);
    EntFire("chinny_cn_particle_throne","Start","",0,null);
    if(!::g_extreme)
    {
        ScriptPrintMessageChatAll(" \x10<<\x01 The dragon stands down from the throne!\x10 >>");
        ScriptPrintMessageChatAll(" \x10<<\x01 The dragon stands down from the throne!\x10 >>");
    }
    else
    {
        ScriptPrintMessageChatAll(" \x10<<\x01 The dragon embraces you as the new owner of the throne!\x10 >>");
        ScriptPrintMessageChatAll(" \x10<<\x01 The dragon embraces you as the new owner of the throne!\x10 >>");
    }
    EntFireByHandle(self, "RunScriptCode", "cincinnatiEnd()", g_cn_interval*32, null, null);
    g_mist_active = false;
    displayHPGainCalc();
}

// +   L A S E R S F A G S   + //

//make player into a laserf-riend
function laserFaggify()
{
    if(!g_mist_active && !detectElement(activator,g_mist_laserfriends))
    {
        g_mist_laserfriends.append(activator);
        EntFire("chinny_cn_fade","AddOutput","rendercolor 0 255 255",0,null);
        EntFire("chinny_cn_fade","AddOutput","renderamt 50",0,null);
        EntFire("chinny_cn_fade","FadeReverse","",0,activator);
        EntFire("chinny_cn_text","Display","",0,activator);
    }
}