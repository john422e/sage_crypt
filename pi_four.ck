// GLOBALS

3 => int sectionLength; // seconds
sectionLength::second => dur sectionTime;
sectionLength/3.0 => float rampTime;

4 => int groupMax;

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
        if( groupsList[i] < 70.0 ) 2 *= > groupsList[i];
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
[205.5, 60.25, 60.0, 8644.0, 61.0, 59.25, 9226.25, 8645.25, 60.5, 50.0, 51.25, 8646.0, 8641.5, 79.25, 52.5, 61.25, 8642.5, 9729.0, 59.75, 9283.0, 8646.25, 9732.75, 9564.25, 8644.25, 8641.75, 53.75, 8137.25, 9062.75, 89.0, 9419.75, 9563.75, 9422.75, 8847.75, 70.25, 53.5, 8420.75, 8523.75, 8637.5, 9338.25, 70.0, 72.0, 9730.0, 8944.25, 9634.25, 9797.25, 9223.75, 55.0, 89.75, 9080.0, 8983.0] @=> float peaks_front[];
[55.0, 88.0, 75.0, 66.0, 58.0, 59.0, 67.0, 3401.0, 92.0, 52.0, 63.0, 3404.0, 68.0, 3120.0, 3194.0, 3397.0, 113.0, 3361.0, 3163.0, 79.0, 57.0, 3095.0, 3180.0, 3421.0, 3116.0, 94.0, 3394.0, 3396.0, 3318.0, 106.0, 76.0, 3106.0, 3079.0, 2932.0, 109.0, 93.0, 3472.0, 3086.0, 3146.0, 70.0, 3181.0, 3093.0, 3119.0, 2863.0, 3068.0, 86.0, 2834.0, 99.0, 3205.0, 3435.0] @=> float peaks_contact[];
[119.97, 205.61, 117.93, 60.15, 50.98, 78.85, 56.42, 61.85, 119.63, 59.47, 80.55, 136.96, 73.41, 59.14, 55.06, 51.32, 75.11, 79.19, 68.31, 73.75, 59.81, 7857.83, 9476.22, 9350.82, 8894.05, 79.53, 9474.52, 9259.06, 9481.66, 82.25, 88.02, 9482.68, 9377.67, 74.43, 63.55, 9990.09, 9260.08, 9349.46, 61.17, 9465.01, 9483.02, 65.25, 121.33, 60.49, 8815.2, 137.98, 8814.86, 9516.67, 68.99, 9491.86] @=> float peaks_behind[];

[[52.5, 60.0, 70.0, 0.0], [50.0, 55.0, 60.0, 70.0], [52.5, 61.25, 70.0, 0.0], [52.5, 61.25, 70.0, 0.0], [8646.0, 9080.0, 9729.0, 0.0], [8646.25, 9080.0, 9730.0, 0.0]] @=> float groups_front[][];
[[55.0, 66.0, 88.0, 99.0]] @=> float groups_contact[][];
[[50.98, 55.06, 61.17, 65.25], [55.06, 61.17, 73.41, 79.53], [59.14, 68.99, 78.85, 137.98], [59.14, 68.99, 78.85, 137.98]] @=> float groups_behind[][];
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