//variables
::g_music_on <- 1;
::g_music_off <- 2;
::g_music_idx <- 0;

MusicArray <- [
                //Intro Path || Loop Music Path || Intro Length || Loop Length\\
                ["music/demon/lil b - swag like ohio (loop)", "music/demon/lil b - swag like ohio (loop)", 156.7, 156.7] /* 0 */,
              ];

// music functions
function PlayDownInOhio()
{
    musicLoop(MusicArray[0][0], MusicArray[0][1], MusicArray[0][2], MusicArray[0][3], 0, ::g_music_on, -1);
}

//play music WITHOUT looping
function musicPlay(filepath,channel)
{
    local music = Entities.FindByName(null, "music_looper"+::g_music_on);
    if(!music || channel != ::g_music_on)
        return;
    music.__KeyValueFromString("message",filepath+".mp3");
    music.__KeyValueFromInt("health", 10);
    EntFireByHandle(music, "PlaySound", "", 0, null, null);
}

//play looping music
//index = -1 will declare a new looping music to be played
function musicLoop(filepath_intro,filepath_loop,length,loop_length,looping,channel,index)
{
    if(index!=::g_music_idx)
    {
        if(index==-1)
        {
            musicStopLoopQueue();
            index = ::g_music_idx;
        }
        else
            return;
    }
    local music = Entities.FindByName(null, "music_looper"+::g_music_on);
    if(!music)
        return;
    music.__KeyValueFromInt("health", 10);
    if(looping)
    {
        if(channel != ::g_music_on)
            return;
        music.__KeyValueFromString("message",filepath_loop+".mp3");
        EntFireByHandle(self, "RunScriptCode", "musicLoop(\""+filepath_intro+"\",\""+filepath_loop+"\","+length+","+loop_length+",1,"+channel+","+index+")", loop_length, music, null);
    }
    else
    {
        music.__KeyValueFromString("message",filepath_intro+".mp3");
        EntFireByHandle(self, "RunScriptCode", "musicLoop(\""+filepath_intro+"\",\""+filepath_loop+"\","+length+","+loop_length+",1,"+channel+","+index+")", length, music, null);
    }
    EntFireByHandle(music, "PlaySound", "", 0, null, null);
}

//change the master ambient_generic
function switchChannel()
{
    ::g_music_on = (::g_music_on%2)+1;
    ::g_music_off = (::g_music_off%2)+1;
}

//stop the looping
function musicStopLoopQueue()
{
    ::g_music_idx++;
}

//stop the current playing song
function musicStop()
{
    EntFire("music_looper"+::g_music_on, "Volume", "0", 0, null);
}