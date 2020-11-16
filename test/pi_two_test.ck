// GLOBALS

10 => int sectionLength; // seconds
sectionLength::second => dur sectionTime;
sectionLength/4.0 => float rampTime;

2 => int groupMax;
10 => int total_peaks;

// SOUNDCHAINS

dac.gain(0.4);

// set up peak soundchains

SinOsc peaks1[total_peaks];
Envelope peak_envs1[total_peaks];
SinOsc peaks2[total_peaks];
Envelope peak_envs2[total_peaks];

for( 0 => int i; i < total_peaks; i++ ) {
    // sinosc to env to dac
    peaks1[i] => peak_envs1[i] => dac;
    peaks2[i] => peak_envs2[i] => dac;
    // set gain to 1/total_peaks
    0.01 => peaks1[i].gain => peaks2[i].gain;
    // set ramp time
    rampTime => peak_envs1[i].time;
    rampTime => peak_envs2[i].time;
}

// set up group soundchains

SinOsc groups1[groupMax];
Envelope group_envs1[groupMax];
SinOsc groups2[groupMax];
Envelope group_envs2[groupMax];

for( 0 => int i; i < groupMax; i++ ) {
    // sinosc to env to dac
    groups1[i] => group_envs1[i] => dac;
    groups2[i] => group_envs2[i] => dac;
    // set gain to 1/groupMax
    1.0/(groupMax*4) => groups1[i].gain => groups2[i].gain;
    // set ramp time
    rampTime => group_envs1[i].time;
    rampTime => group_envs2[i].time;
}  


// FUNCTIONS
fun void setPeaks( float peaksList[], SinOsc peaks[] ) {
    for( 0 => int i; i < total_peaks; i++ ) {
        if( peaksList[i] < 70.0 ) peaksList[i]*2 => peaks[i].freq;
        else peaksList[i] => peaks[i].freq;
    }
}

fun void peaksOn( Envelope envs[] ) {
    for( 0 => int i; i < total_peaks; i++ ) {
        envs[i].keyOn();
    }
}

fun void peaksOff( Envelope envs[] ) {
    for( 0 => int i; i < total_peaks; i++ ) {
        envs[i].keyOff();
    }  
}

fun void setGroups( float groupsList[], SinOsc groups[] ) {
    // groupsList length must be equal to groups length (manually add zeros for shorter lists)
    for( 0 => int i; i < groupMax; i++ ) {
        if( groupsList[i] < 70.0 ) groupsList[i]*2 => groups[i].freq;
        else groupsList[i] => groups[i].freq;
    }
}

fun void groupsOn( Envelope envs[] ) {
    for( 0 => int i; i < groupMax; i++ ) {
        envs[i].keyOn();
    }
}

fun void groupsOff( Envelope envs[] ) {
    for( 0 => int i; i < groupMax; i++ ) {
        envs[i].keyOff();
    }  
}


// DATA

// order? front -> contact -> behind? or front -> behind -> contact?
[52.27, 119.87, 89.46, 9438.02, 78.91, 68.85, 120.12, 9478.73, 50.01, 80.41, 56.04, 50.76, 9479.48, 8892.46, 75.14, 79.91, 74.63, 9478.98, 118.36, 92.73, 110.32, 66.34, 9403.59, 50.51, 81.67, 9960.2, 9996.39, 8280.32, 8279.06, 66.84, 59.81, 75.64, 9128.93, 91.97, 205.56, 9872.5, 9954.42, 60.81, 8890.7, 8864.32, 64.08, 91.72, 9963.22, 51.77, 9440.03, 9832.55, 9028.66, 102.02, 97.25, 9130.18] @=> float peaks_front[];
[55.0, 77.0, 51.0, 104.0, 109.0, 54.0, 63.0, 82.0, 72.0, 53.0, 78.0, 94.0, 57.0, 70.0, 71.0, 96.0, 73.0, 117.0, 65.0, 58.0, 3354.0, 3456.0, 105.0, 85.0, 116.0, 50.0, 98.0, 59.0, 61.0, 3292.0, 80.0, 110.0, 171.0, 122.0, 86.0, 87.0, 64.0, 3240.0, 113.0, 3448.0, 123.0, 189.0, 3307.0, 3366.0, 141.0, 3702.0, 91.0, 90.0, 3319.0, 83.0] @=> float peaks_contact[];
[50.33, 50.67, 52.0, 51.0, 56.33, 56.67, 51.33, 56.0, 51.67, 120.0, 63.33, 52.67, 54.33, 63.67, 60.67, 63.0, 66.0, 68.0, 117.33, 59.33, 55.67, 71.0, 62.67, 52.33, 70.67, 62.33, 64.0, 54.0, 60.33, 53.0, 50.0, 75.67, 61.33, 65.67, 80.0, 59.67, 53.33, 65.33, 86.0, 83.67, 69.67, 79.33, 69.33, 66.67, 61.0, 55.33, 79.0, 205.67, 66.33, 67.33] @=> float peaks_behind[];

[[79.91, 119.87, 205.56, 0.0, 0.0, 0.0, 0.0, 0.0], [56.04, 64.08, 120.12, 0.0, 0.0, 0.0, 0.0, 0.0]] @=> float groups_front[][];
[[55.0, 65.0, 70.0, 80.0, 90.0, 105.0, 110.0, 0.0], [63.0, 70.0, 77.0, 98.0, 105.0, 189.0, 0.0, 0.0], [65.0, 78.0, 91.0, 104.0, 117.0, 0.0, 0.0, 0.0], [54.0, 63.0, 72.0, 90.0, 117.0, 189.0, 0.0, 0.0], [72.0, 78.0, 104.0, 117.0, 0.0, 0.0, 0.0, 0.0], [72.0, 78.0, 104.0, 117.0, 0.0, 0.0, 0.0, 0.0], [65.0, 70.0, 91.0, 105.0, 0.0, 0.0, 0.0, 0.0], [72.0, 80.0, 96.0, 104.0, 0.0, 0.0, 0.0, 0.0], [50.0, 55.0, 65.0, 70.0, 80.0, 90.0, 105.0, 110.0], [63.0, 70.0, 77.0, 91.0, 98.0, 105.0, 189.0, 0.0], [54.0, 64.0, 72.0, 96.0, 0.0, 0.0, 0.0, 0.0], [63.0, 90.0, 117.0, 189.0, 0.0, 0.0, 0.0, 0.0], [77.0, 91.0, 98.0, 105.0, 189.0, 0.0, 0.0, 0.0]] @=> float groups_contact[][];
[[51.0, 56.67, 62.33, 68.0, 79.33, 0.0, 0.0, 0.0], [51.0, 56.67, 62.33, 68.0, 79.33, 0.0, 0.0, 0.0], [53.33, 56.0, 64.0, 66.67, 80.0, 0.0, 0.0, 0.0], [56.33, 64.0, 69.33, 117.33, 0.0, 0.0, 0.0, 0.0], [51.0, 56.67, 62.33, 68.0, 79.33, 0.0, 0.0, 0.0], [50.0, 53.33, 56.0, 64.0, 66.67, 80.0, 120.0, 0.0], [53.33, 56.0, 66.67, 80.0, 120.0, 0.0, 0.0, 0.0], [56.67, 62.33, 68.0, 79.33, 0.0, 0.0, 0.0, 0.0], [53.33, 56.0, 64.0, 66.67, 80.0, 120.0, 0.0, 0.0]] @=> float groups_behind[][];
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
        peaksOn( peak_envs1 );
        // advance time
        sectionTime => now;
    }
    if( section == 2) {
        <<< "PEAKS CONTACT" >>>;
        // set freqs and start crossfade
        setPeaks( peaks_contact, peaks2 );
        peaksOn( peak_envs2 );
        peaksOff( peak_envs1 );
        // advance time
        sectionTime => now;
    }
    if( section == 3) {
        <<< "PEAKS BEHIND" >>>;
        // set freqs and start crossfade
        setPeaks( peaks_behind, peaks1 );
        peaksOn( peak_envs1 );
        peaksOff( peak_envs2 );
        // advance time
        sectionTime => now;
    }
    if( section == 4) {
        <<< "SILENCE" >>>;
        // fade out peaks
        peaksOff( peak_envs1 );
        // advance time
        sectionTime => now;
    }
    if( section == 5) 
    {
        <<< "GROUPS FRONT" >>>;
        // get random index
        Math.random2(0, groups_front.cap()-1) => front_i;
        // set freqs and start ramp
        setGroups( groups_front[front_i], groups1 );
        groupsOn( group_envs1 );
        // advance time
        sectionTime => now;
    }
    if( section == 6) {
        <<< "GROUPS CONTACT" >>>;
        // get random index
        Math.random2(0, groups_contact.cap()-1) => contact_i;
        // set freqs and start crossfade
        setGroups( groups_contact[contact_i], groups2 );
        groupsOn( group_envs2 );
        groupsOff( group_envs1 );
        // advance time
        sectionTime => now;
    }
    if( section == 7) {
        <<< "GROUPS BEHIND" >>>;
        // get random index
        Math.random2(0, groups_behind.cap()-1) => behind_i;
        // set freqs and start crossfade
        setGroups( groups_behind[behind_i], groups1 );
        groupsOn( group_envs1 );
        groupsOff( group_envs2 );
        // advance time
        sectionTime => now;
    }
    if( section == 8) {
        <<< "SILENCE" >>>;
        // fade out groups
        groupsOff( group_envs1 );
        // advance time
        sectionTime => now;
    }
    
    // advance section
    1 +=> section;
    if( section > 8 ) 1 => section;
   
}