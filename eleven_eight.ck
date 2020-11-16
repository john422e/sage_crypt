SinOsc s1 => ADSR env1 => dac;
SinOsc s2 => ADSR env2 => dac;

//0.0 => s1.gain => s2.gain;

700 => float ref;
float interval;
//3.0/2 => interval;
11.0/8 => interval;
//13.0/8 => interval;
//13.0/9 => interval;
//49.0/48 => interval;
//16.0/15 => interval;


ref => s1.freq;
ref / interval => s2.freq;

200 => float timeInterval;
70 => int timeThresh;

<<< ref*interval, s1.freq(), s2.freq() >>>;

while( true )
{
    env1.keyOn();
    timeInterval::ms => now;
    env1.keyOff();
    env2.keyOn();
    timeInterval::ms => now;
    env2.keyOff();
    env1.keyOn();
    timeInterval::ms => now;
    env1.keyOff();
    timeInterval::ms => now;
    if ( timeInterval > timeThresh ) 0.98 *=> timeInterval;
    <<< timeInterval >>>;
}
