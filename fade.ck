// GLOBALS

3 => int sectionLength; // seconds
sectionLength::second => dur sectionTime;
sectionLength/3.0 => float rampTime;


5 => int groupMax;
50 => int totalPeaks;

1.0/groupMax => float groupGain;
1.0/totalPeaks => float peakGain;

// SOUNDCHAINS

dac.gain(0.6);

// set up peak soundchains

SinOsc peaks1[50];
SinOsc peaks2[50];


for( 0 => int i; i < 50; i++ ) {
    // sinosc to env to dac
    peaks1[i] => dac;
    peaks2[i] => dac;
    // set gain to 1/50
    0.00 => peaks1[i].gain => peaks2[i].gain;
}

// set up group soundchains

SinOsc groups1[groupMax];
SinOsc groups2[groupMax];

for( 0 => int i; i < groupMax; i++ ) {
    // sinosc to env to dac
    groups1[i] => dac;
    groups2[i] => dac;
    // set gain to 1/groupMax
    0.0 => groups1[i].gain => groups2[i].gain;
}  


// FUNCTIONS
fun void setPeaks( float peaksList[], SinOsc peaks[] ) {
    for( 0 => int i; i < 50; i++ ) {
        if( peaksList[i] < 70.0 ) 2 *=> peaksList[i];
        else peaksList[i] => peaks[i].freq;
    }
}

fun void fadeIn( SinOsc s, float g )
{
    // gain variables
    g => float targetGain;
    0.0 => float gainPosition;
    0.00001 => float gainInc;
    while( gainPosition <= targetGain )
    {
        gainPosition + gainInc => gainPosition;
        gainPosition => s.gain;
        10::ms => now;
    }
}

fun void fadeOut( SinOsc s )
{
    // gain variables
    0.0 => float targetGain;
    0.0 => float gainPosition;
    0.0001 => float gainInc;
    while( gainPosition > 0.0 )
    {
        gainPosition - gainInc => gainPosition;
        gainPosition => s.gain;
        10::ms => now;
    }
}

fun void bankOn( SinOsc sins[], float g ) {
    for( 0 => int i; i < sins.cap(); i++ ) {
        spork ~ fadeIn( sins[i], g );
    }
}

fun void bankOff( SinOsc sins[] ) {
    for( 0 => int i; i < sins.cap(); i++ ) {
        spork ~ fadeOut( sins[i] );
    }
}


fun void setGroups( float groupsList[], SinOsc groups[] ) {
    // groupsList length must be equal to groups length (manually add zeros for shorter lists)
    for( 0 => int i; i < groupMax; i++ ) {
        if( groupsList[i] < 70.0 ) 2 *=> groupsList[i];
        else groupsList[i] => groups[i].freq;
    }
}



// DATA

// order? front -> contact -> behind? or front -> behind -> contact?
[120.0, 60.0, 59.75, 60.5, 9542.25, 9543.25, 56.5, 9543.0, 205.5, 80.25, 59.25, 56.25, 8204.5, 8544.25, 9187.5, 9014.25, 8203.0, 9553.5, 8378.25, 9589.25, 9970.5, 60.25, 79.75, 9600.5, 9216.75, 8228.75, 80.5, 9205.5, 8443.0, 9553.0, 8377.5, 9617.5, 76.75, 53.25, 81.25, 7933.5, 50.5, 9220.5, 9997.25, 9618.75, 9738.5, 9619.5, 9737.0, 9626.75, 9534.25, 8475.25, 54.0, 9044.0, 9737.25, 9555.75] @=> float peaks_front[];
[50.0, 80.0, 62.0, 82.0, 69.0, 72.0, 56.0, 3311.0, 3354.0, 68.0, 55.0, 51.0, 65.0, 3360.0, 107.0, 63.0, 3330.0, 85.0, 103.0, 3440.0, 113.0, 101.0, 3273.0, 130.0, 3380.0, 3300.0, 3262.0, 3341.0, 3275.0, 3394.0, 3337.0, 3399.0, 3404.0, 3431.0, 186.0, 164.0, 3400.0, 53.0, 3408.0, 78.0, 61.0, 66.0, 3363.0, 3392.0, 3331.0, 111.0, 3383.0, 3550.0, 3329.0, 88.0] @=> float peaks_contact[];
[60.0, 60.67, 58.33, 54.33, 52.33, 55.0, 52.0, 56.0, 56.67, 53.33, 54.0, 59.67, 63.33, 50.33, 62.0, 72.0, 67.0, 70.33, 50.0, 73.67, 71.67, 61.67, 54.67, 120.0, 64.67, 55.33, 51.33, 50.67, 60.33, 56.33, 66.0, 9982.67, 9981.0, 52.67, 64.0, 65.67, 57.33, 53.0, 69.67, 57.0, 59.33, 63.67, 58.67, 68.0, 61.33, 9987.33, 66.33, 80.67, 70.0, 118.0] @=> float peaks_behind[];

[[54.0, 56.25, 60.0, 120.0, 0.0], [56.25, 60.0, 120.0, 0.0, 0.0], [8228.75, 9216.75, 9600.5, 0.0, 0.0], [54.0, 56.25, 60.0, 120.0, 0.0]] @=> float groups_front[][];
[[55.0, 65.0, 80.0, 130.0, 0.0], [63.0, 66.0, 72.0, 78.0, 0.0], [56.0, 72.0, 80.0, 88.0, 0.0]] @=> float groups_contact[][];
[[54.0, 60.0, 66.0, 72.0, 120.0], [51.33, 56.0, 58.33, 60.67, 70.0], [55.0, 60.0, 70.0, 120.0, 0.0], [53.33, 56.0, 60.0, 64.0, 120.0], [53.33, 56.0, 60.0, 70.0, 120.0], [54.0, 60.0, 66.0, 72.0, 120.0], [56.0, 60.0, 72.0, 120.0, 0.0], [54.0, 60.0, 66.0, 72.0, 120.0], [51.33, 58.67, 66.0, 80.67, 0.0], [50.67, 57.0, 63.33, 69.67, 0.0], [55.0, 58.67, 66.0, 80.67, 0.0], [51.33, 55.0, 58.67, 66.0, 80.67], [51.33, 58.33, 60.67, 70.0, 0.0]] @=> float groups_behind[][];
0 => int front_i => int contact_i => int behind_i;

// make ramp time random?
// make sustain time random?

// 6 sections (1-8) 3 peaks sections, 1 silence, 3 groups sections, 1 silence
1 => int section;




// SCORE
while( true ) {
    <<< "SECTION:", section >>>;
    if( section == 1) {
        <<< "PEAKS FRONT" >>>;
        // set freqs and start ramp
        setPeaks( peaks_front, peaks1 );
        bankOn( peaks1, peakGain );
        // advance time
        sectionTime => now;
    }
    if( section == 2) {
        <<< "PEAKS CONTACT" >>>;
        // set freqs and start crossfade
        setPeaks( peaks_contact, peaks2 );
        bankOn( peaks2, peakGain );
        bankOff( peaks1 );
        // advance time
        sectionTime => now;
    }
    if( section == 3) {
        <<< "PEAKS BEHIND" >>>;
        // set freqs and start crossfade
        setPeaks( peaks_behind, peaks1 );
        bankOn( peaks1, peakGain );
        bankOff( peaks2 );
        // advance time
        sectionTime => now;
    }
    if( section == 4) {
        <<< "SILENCE" >>>;
        // fade out peaks
        bankOff( peaks1 );
        // advance time
        sectionTime => now;
    }
    if( section == 5) 
    {
        <<< "GROUPS FRONT" >>>;
        // get random index
        math.random2(0, groups_front.cap()-1) => front_i;
        // set freqs and start ramp
        setGroups( groups_front[front_i], groups1 );
        bankOn( groups1, groupGain );
        // advance time
        sectionTime => now;
    }
    if( section == 6) {
        <<< "GROUPS CONTACT" >>>;
        // get random index
        math.random2(0, groups_contact.cap()-1) => contact_i;
        // set freqs and start crossfade
        setGroups( groups_contact[contact_i], groups2 );
        bankOn( groups2, groupGain );
        bankOff( groups1 );
        // advance time
        sectionTime => now;
    }
    if( section == 7) {
        <<< "GROUPS BEHIND" >>>;
        // get random index
        math.random2(0, groups_behind.cap()-1) => behind_i;
        // set freqs and start crossfade
        setGroups( groups_behind[behind_i], groups1 );
        bankOn( groups1, groupGain );
        bankOff( groups2 );
        // advance time
        sectionTime => now;
    }
    if( section == 8) {
        <<< "SILENCE" >>>;
        // fade out groups
        bankOff( groups1 );
        // advance time
        sectionTime => now;
    }
    
    // advance section
    1 +=> section;
    if( section > 8 ) 1 => section;
   
}