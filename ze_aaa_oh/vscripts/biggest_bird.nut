/*  script for ze_aaa_ohio, made by lameskydiver/chinny
 *  IM THE BIGGEST BIRD
 *  First test version created: March 2023
 *
 *  If you spot errors / have questions contact me via:
 *  discord:    lameskydiver/chinny#5724
 *  steam:      https://steamcommunity.com/id/lameskydiver
 */

lyrics <- [ "Don't know what you've heard",
            "Don't know what you've heard\n(Don't know what you heard)",
            "Don't know what you've heard",
            "Don't know what you've heard\n(I don't know what you heard)",
            "I don't know what you heard",
            "I don't know what you heard\n(Don't know what you heard)",
            "Oh no, oh no",
            "But I'm the biggest bird\n(I'm the biggest bird)",
            "I'm the biggest bird\n(I'm the biggest bird)",
            "I'm the biggest bird\n(I'm the biggest bird)",
            "I'm the biggest bird\n(I'm the biggest bird, I'm the biggest bird)",
            "I'm the biggest bird\n(I'm the biggest bird, I'm the biggest bird)",
            "Bigger than a cassowary or an ostrich",
            "Bigger than a cassowary or an ostrich\n(Me)",
            "They wanna be like me but they can't be like this",
            "They wanna be like me but they can't be like this\n(You can't compare)",
            "I'm the biggest bird",
            "I'm the biggest bird\n(I'm the biggest bird)",
            "I'm the biggest bird\n(I'm the biggest bird)",
            "Walked in they scared of me",
            "Walked in they scared of me\n(I got 'em scared)",
            "They wanna be like Moa, it's no comparison",
            "They wanna be like Moa, it's no comparison\n(Can't compare)",
            "They wanna be like Chickadee singin' in the wind",
            "They wanna be like Chickadee singin' in the wind\n(Tweet, tweet, tweet, tweet)",
            "(Tweet, tweet, tweet, tweet)\nPulled up with Aepyornis, yeah, I'm not him",
            "Bigger than a Moa",
            "They scared when I show up\n(Bigger than 'em, bigger than 'em)",
            "They scared of the claws that tip my legs",
            "They said, 'Oh my, look at the size of his egg'\n(Oh my gosh, oh my gosh)",
            "I'm the biggest bird, it's so absurd",
            "(It's crazy)",
            "I'm the biggest bird, how have you not heard",
            "(How ain't you heard? How ain't you heard?)",
            "Don't know what you heard\n(Don't know what you heard)",
            "Don't know what you heard",
            "Don't know what you heard\n(Don't know what you heard)",
            "But, I'm the biggest bird",
            "(I'm the biggest bird)",
            "I'm the biggest bird\n(I'm the biggest bird)",
            "I'm the biggest bird\n(I'm the biggest bird)",
            "I'm the biggest bird\n(I'm the biggest bird)",
            "I'm the biggest bird\n(I'm the biggest bird)",
            "I'm the biggest bird\n(I'm the biggest bird)",
            "I'm the biggest bird\n(I'm the biggest bird)",
            "Aepyornis (Aepyornis), Mercator when I walk in",
            "(Who I is? Who I is?)",
            "Doves fly above me, don't wanna give me no company",
            "It's okay with me",
            "You can't be on my perch",
            "(You cannot, you cannot)",
            "You can't rest in my roost",
            "(No you can't, no you can't)",
            "I already know how you do",
            "(I already know how you do)\nBiggest bird, that's me, Mr. 2002",
            "(That's me, that's me)"
            ];
duration <- [   1.32,   1.90,   1.02,   3.07,   1.53,//[4]
                1.58,   1.90,   1.39,   2.06,   3.22,//[9]
                3.26,   3.21,   2.42,   0.84,   2.33,//[14]
                0.89,   1.30,   1.95,   3.26,   2.32,//[19]
                0.93,   2.52,   0.74,   2.46,   0.75,//[24]
                4.83,   1.58,   3.24,   3.34,   4.47,//[29]
                3.06,   1.81,   3.17,   3.68,   2.09,//[34]
                1.16,   1.60,   1.21,   1.67,   1.63,//[39]
                3.20,   3.26,   3.26,   3.16,   4.89,//[44]
                3.22,   1.62,   3.63,   2.00,   2.06,//[49]
                1.15,   2.02,   1.33,   2.21,   2.97,//[54]
                3.50 ];//[55] 
pause <- [  0.00,   0.50,   0.00,   0.00,   0.00,//[4]
            0.00,   0.00,   0.00,   0.40,   0.40,//[9]
            0.30,   0.30,   0.00,   0.00,   0.00,//[14]
            0.00,   0.00,   0.30,   0.30,   0.00,//[19]
            0.00,   0.00,   0.00,   0.00,   0.00,//[24]
            1.30,   0.00,   0.40,   0.00,   1.00,//[29]
            0.00,   0.00,   0.00,   1.50,   0.50,//[34]
            0.00,   0.00,   0.00,   0.00,   0.30,//[39]
            0.70,   0.30,   0.30,   0.30,   1.80,//[44]
            0.00,   0.00,   0.00,   0.00,   0.00,//[49]
            0.00,   0.00,   0.00,   0.00,   0.00,//[54]
            0.00 ];//[55] 
::g_mist_lyrics_it <- 0;

function lyricsDisplay()
{
    if(::g_mist_lyrics_it<lyrics.len())
    {
        local displayer = Entities.FindByName(null, "chinny_cn_lyrics");
        displayer.__KeyValueFromString("message", lyrics[::g_mist_lyrics_it]);
        if(pause[::g_mist_lyrics_it]!=0.0)
            EntFireByHandle(self, "RunScriptCode", "blankLyrics()", (duration[::g_mist_lyrics_it]-pause[::g_mist_lyrics_it]), null, null);
        EntFireByHandle(self, "RunScriptCode", "lyricsDisplay()", duration[::g_mist_lyrics_it], null, null);
        ::g_mist_lyrics_it++;
        EntFireByHandle(displayer, "Display", "", 0, null, null);
    }
    else
        blankLyrics();
}

function blankLyrics()
{
    local displayer = Entities.FindByName(null, "chinny_cn_lyrics");
    displayer.__KeyValueFromString("message", "");
    EntFireByHandle(displayer, "Display", "", 0, null, null);
}

/*  IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD
 *  IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD
 *  IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD
 *  IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD
 *  IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD
 *  IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD
 *  IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD
 *  IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD
 *  IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD
 *  IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD IM THE BIGGEST BIRD
 */