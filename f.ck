SinOsc s => dac;

fun void fadeIn( SinOsc s, float g )
{
    // gain variables
    g => float targetGain;
    0.0 => float gainPosition;
    0.0001 => float gainInc;
    while( gainPosition <= targetGain )
    {
        gainPosition + gainInc => gainPosition;
        gainPosition => s.gain;
        10::ms => now;
        <<< s.gain() >>>;
    }
}


spork ~ fadeIn(s, 0.5);

10::second => now;