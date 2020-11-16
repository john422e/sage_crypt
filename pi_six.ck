// GLOBALS

3 => int sectionLength; // seconds
sectionLength::second => dur sectionTime;
sectionLength/3.0 => float rampTime;

6 => int groupMax;

// SOUNDCHAINS

dac.gain(0.9);

// set up peak soundchains

SinOsc peaks1[50];
Envelope peak_envs1[50];
SinOsc peaks2[50];
Envelope peak_envs2[50];

for( 0 => int i; i < 50; i++ ) {
    // sinosc to env to dac
    peaks1[i] => peak_envs1[i] => dac;
    peaks2[i] => peak_envs2[i] => dac;
    // set gain to 1/50
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
    1.0/groupMax => groups1[i].gain => groups2[i].gain;
    // set ramp time
    rampTime => group_envs1[i].time;
    rampTime => group_envs2[i].time;
}  


// FUNCTIONS
fun void setPeaks( float peaksList[], SinOsc peaks[] ) {
    for( 0 => int i; i < 50; i++ ) {
        if( peaksList[i] < 70.0 ) 2 *=> peaksList[i];
        else peaksList[i] => peaks[i].freq;
    }
}

fun void peaksOn( Envelope envs[] ) {
    for( 0 => int i; i < 50; i++ ) {
        envs[i].keyOn();
    }
}

fun void peaksOff( Envelope envs[] ) {
    for( 0 => int i; i < 50; i++ ) {
        envs[i].keyOff();
    }  
}

fun void setGroups( float groupsList[], SinOsc groups[] ) {
    // groupsList length must be equal to groups length (manually add zeros for shorter lists)
    for( 0 => int i; i < groupMax; i++ ) {
        if( groupsList[i] < 70.0 ) 2 *=> groupsList[i];
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
[60.0, 68.5, 9497.0, 9490.25, 9708.25, 9490.75, 9856.0, 9488.75, 9367.75, 9502.5, 9547.0, 9503.75, 9500.75, 9595.5, 9529.75, 9574.5, 61.0, 9543.75, 9521.5, 9901.25, 9837.5, 58.25, 9875.25, 87.25, 9760.5, 9429.25, 9544.25, 9496.0, 9490.0, 9833.75, 9099.5, 9836.75, 55.0, 60.75, 56.75, 8708.25, 53.5, 9670.25, 9550.25, 9853.75, 9533.0, 9498.5, 51.25, 9530.75, 9477.5, 9528.75, 9486.0, 9492.5, 9672.25, 9521.75] @=> float peaks_front[];
[66.44, 76.66, 58.26, 50.08, 84.83, 60.3, 62.35, 108.34, 97.1, 53.15, 68.48, 123.67, 3711.26, 128.78, 77.68, 89.95, 109.37, 67.46, 64.39, 55.19, 182.96, 61.33, 107.32, 3904.43, 101.19, 3499.68, 79.72, 3547.72, 141.05, 139.01, 72.57, 3727.61, 3542.61, 3455.73, 112.43, 52.13, 3444.49, 54.17, 83.81, 3522.17, 111.41, 56.22, 59.28, 3874.79, 3932.03, 3554.87, 94.03, 131.85, 3679.57, 3665.26] @=> float peaks_contact[];
[50.33, 51.33, 50.67, 53.67, 51.67, 54.33, 57.67, 57.33, 52.67, 56.67, 169.0, 54.67, 58.33, 53.0, 55.0, 56.0, 52.0, 50.0, 74.0, 66.0, 53.33, 55.67, 75.0, 55.33, 77.67, 90.67, 66.33, 91.33, 58.0, 120.0, 88.67, 73.67, 61.67, 121.0, 60.67, 88.0, 76.0, 67.67, 62.0, 63.67, 74.33, 120.33, 57.0, 61.0, 60.0, 93.67, 81.0, 56.33, 68.33, 96.67] @=> float peaks_behind[];

[[9099.5, 9477.5, 9856.0, 0.0, 0.0, 0.0]] @=> float groups_front[][];
[[56.22, 61.33, 66.44, 76.66, 107.32, 112.43], [61.33, 66.44, 76.66, 112.43, 0.0, 0.0], [50.08, 64.39, 107.32, 128.78, 0.0, 0.0], [56.22, 67.46, 89.95, 101.19, 112.43, 123.67], [55.19, 61.33, 64.39, 67.46, 79.72, 128.78], [61.33, 64.39, 79.72, 128.78, 0.0, 0.0], [61.33, 66.44, 76.66, 79.72, 0.0, 0.0]] @=> float groups_contact[][];
[[55.0, 66.0, 88.0, 121.0, 0.0, 0.0], [52.0, 56.0, 60.0, 88.0, 120.0, 0.0], [50.0, 53.33, 56.0, 60.0, 120.0, 0.0], [55.0, 66.0, 88.0, 121.0, 0.0, 0.0], [50.0, 53.33, 56.0, 60.0, 120.0, 0.0], [55.0, 60.0, 75.0, 120.0, 0.0, 0.0], [50.67, 57.0, 76.0, 88.67, 0.0, 0.0], [55.0, 66.0, 88.0, 120.0, 0.0, 0.0], [50.67, 57.0, 76.0, 88.67, 0.0, 0.0], [50.67, 57.0, 76.0, 88.67, 0.0, 0.0], [55.0, 60.0, 66.0, 120.0, 0.0, 0.0]] @=> float groups_behind[][];
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
        math.random2(0, groups_front.cap()-1) => front_i;
        // set freqs and start ramp
        setGroups( groups_front[front_i], groups1 );
        groupsOn( group_envs1 );
        // advance time
        sectionTime => now;
    }
    if( section == 6) {
        <<< "GROUPS CONTACT" >>>;
        // get random index
        math.random2(0, groups_contact.cap()-1) => contact_i;
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
        math.random2(0, groups_behind.cap()-1) => behind_i;
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