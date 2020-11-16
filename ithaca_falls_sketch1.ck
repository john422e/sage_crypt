SndBuf shotgun => Pan2 panTape => dac;

0.5 => panTape.pan;

SinOsc one => Pan2 panOne => dac;
SinOsc two => Pan2 panTwo => dac;
SinOsc three => Pan2 panThree => dac;
SinOsc four => Pan2 panFour => dac;
SinOsc five => Pan2 panFive => dac;
SinOsc six => Pan2 panSix => dac;
SinOsc seven => Pan2 panSeven => dac;
SinOsc eight => Pan2 panEight => dac;

0.0 => one.gain;
0.0 => two.gain;
0.0 => three.gain;
0.0 => four.gain;
0.0 => five.gain;
0.0 => six.gain;
0.0 => seven.gain;
0.0 => eight.gain;

-1 => panOne.pan;
-1 => panTwo.pan;
1 => panThree.pan;
1 => panFour.pan;
-1 => panFive.pan;
-1 => panSix.pan;
1 => panSeven.pan;
1 => panEight.pan;

// gain variables
0.25 => float targetGain;
0.0001 => float gainInc;
10 => int noteDuration;

// functions
fun void fadeIn( SinOsc s )
{
    while( s.gain() < targetGain )
    {
        s.gain() + gainInc => s.gain;
        //<<< gainPosition >>>;
        1::ms => now;
    }
    noteDuration::second => now;
    fadeOut( s );
    //<<< "end" >>>;
}

fun void fadeOut( SinOsc s )
{
    while( s.gain() > 0.0 )
    {
        s.gain() - (gainInc*0.5) => s.gain;
        //<<< gainPosition >>>;
        1::ms => now;
    }
}

// this directory
me.dir() => string path;
// filename
"audio/trimmed/ithaca_falls_shotgun.wav" => string shotgun_filename;
path + shotgun_filename => shotgun_filename;
<<< shotgun_filename >>>;
// open soundfile
shotgun_filename => shotgun.read;

0.6 => shotgun.gain;
0 => shotgun.pos;

1.0 => float playbackRate;
1.0 => float speed;

//playbackRate => shotgun.rate; // set rate
//speed::second => now;






//fifths
[465.75, 155.25, 408.0, 68.0, 403.5, 269.0, 403.5, 67.25, 288.0, 96.0, 225.75, 150.5, 216.0, 72.0, 108.0, 72.0, 99.0, 66.0] @=> float fifths[];

//major thirds
[343.0, 137.25, 301.25, 60.25, 288.0, 115.25, 250.0, 200.0, 247.5, 99.0, 228.75, 183.0, 219.0, 175.25, 214.0, 171.25, 200.0, 160.0, 180.0, 72.0, 163.75, 131.0, 123.75, 99.0, 99.0, 79.25, 85.0, 68.0] @=> float thirds[];

//sevenths
[344.75, 197.0, 292.25, 83.5, 238.0, 68.0, 227.5, 65.0, 225.75, 64.5] @=> float sevenths[];

//elevenths
[264.0, 96.0, 247.5, 180.0, 99.0, 72.0] @=> float elevenths[];

//thirteenths
[217.75, 134.0, 201.5, 62.0] @=> float thirteenths[];

//<<< fifths.cap(), thirds.cap(), elevenths.cap(), thirteenths.cap() >>>; // 18, 28, 6, 4 = 56 freqs = 28 dyads


// form starts here

240 => int pieceLength;
10 => int leadTime; // make this longer
leadTime => int tick;

leadTime::second => now;

-1 => int play_selection;
while( tick < (pieceLength - leadTime*2) )
{
    
    if( tick % 20 == 0 ) // every twenty seconds
    {
        Math.random2(0,1) => int panPlay;
        if( (panPlay==0 && panTape.pan() > -1.0) || panTape.pan()==1.0) {
            panTape.pan() - .5 => panTape.pan;
        }
        if( (panPlay==1 && panTape.pan() < 1.0) || panTape.pan()==-1.0) {
            panTape.pan() + .5 => panTape.pan;
        }
    }
    
    if( tick % 4 == 0 ) // every four seconds
    {
        Math.random2(0, 9) => play_selection; // 0-4 = play dyad, 5-19 = nothing
        if( play_selection==0 && one.gain()<=0.0 ) {
            <<< "fifths" >>>;
            Math.random2(0, (fifths.cap()-1)/2)*2 => int i;
            fifths[i] => one.freq;
            fifths[i+1] => two.freq;
            <<< one.freq(), two.freq() >>>;
            spork ~ fadeIn( one );
            spork ~ fadeIn( two );
        }
        if( play_selection==1 && three.gain()<=0.0) {
            <<< "thirds" >>>;
            Math.random2(0, (thirds.cap()-1)/2)*2 => int i;
            thirds[i] => three.freq;
            thirds[i+1] => four.freq;
            spork ~ fadeIn( three );
            spork ~ fadeIn( four );
        }
        if( play_selection==2 && five.gain()<=0.0) {
            <<< "sevenths" >>>;
            Math.random2(0, (sevenths.cap()-1)/2)*2 => int i;
            sevenths[i] => five.freq;
            thirds[i+1] => six.freq;
            spork ~ fadeIn( five );
            spork ~ fadeOut( six );
        }
        if( play_selection==3 && seven.gain()<=0.0) {
            <<< "elevenths" >>>;
            Math.random2(0, (elevenths.cap()-1)/2)*2 => int i;
            elevenths[i] => seven.freq;
            elevenths[i+1] => eight.freq;
            spork ~ fadeIn( seven );
            spork ~ fadeIn( eight );
        }
        if( play_selection==4 && seven.gain()<=0.0) { // elevenths and thirteenths share channels
            <<< "thirteenths" >>>;
            Math.random2(0, (thirteenths.cap()-1)/2)*2 => int i;
            thirteenths[i] => seven.freq;
            thirteenths[i+1] => eight.freq;
            spork ~ fadeIn( seven );
            spork ~ fadeIn( eight );
        }
    }
    else {
        -1 => play_selection;
    }
    <<< tick, play_selection, panTape.pan() >>>;
    1::second => now;
    tick++;
}


leadTime*2::second => now;

