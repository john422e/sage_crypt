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
[120.0, 51.0, 60.0, 60.25, 52.25, 61.5, 205.5, 56.5, 50.75, 68.5, 68.75, 9223.75, 57.0, 58.25, 63.0, 74.5, 58.5, 55.75, 60.75, 53.75, 54.0, 6715.0, 9224.25, 90.5, 51.25, 8997.75, 9157.0, 70.0, 9275.25, 9218.5, 72.5, 97.25, 7686.25, 9581.75, 8645.25, 7404.75, 8863.75, 72.25, 206.25, 9236.0, 9257.5, 9236.5, 71.0, 9398.75, 9234.75, 73.5, 7406.0, 55.5, 9238.25, 9218.25] @=> float peaks_front[];
[52.0, 51.0, 60.0, 55.0, 75.0, 62.0, 90.0, 109.0, 93.0, 64.0, 76.0, 59.0, 112.0, 107.0, 77.0, 61.0, 95.0, 74.0, 56.0, 96.0, 86.0, 57.0, 182.0, 70.0, 125.0, 71.0, 120.0, 105.0, 110.0, 131.0, 80.0, 100.0, 81.0, 116.0, 50.0, 82.0, 79.0, 54.0, 103.0, 102.0, 108.0, 73.0, 84.0, 119.0, 67.0, 128.0, 132.0, 58.0, 2151.0, 66.0] @=> float peaks_contact[];
[60.17, 50.76, 72.27, 120.01, 68.58, 61.18, 62.53, 68.91, 74.29, 59.84, 63.2, 51.77, 58.83, 67.57, 90.43, 9230.63, 52.78, 89.42, 69.59, 89.08, 9258.53, 113.62, 9392.66, 73.62, 9902.61, 64.54, 55.8, 8664.87, 60.51, 9114.99, 96.14, 205.73, 52.44, 56.14, 8706.22, 7749.84, 57.48, 66.9, 61.52, 9903.62, 74.63, 8491.07, 73.96, 7509.82, 9318.03, 8789.25, 71.6, 173.46, 9782.27, 9782.6] @=> float peaks_behind[];

[[60.0, 70.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [60.0, 63.0, 70.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [7686.25, 8645.25, 9223.75, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [54.0, 58.5, 60.75, 63.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [54.0, 60.75, 63.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [54.0, 60.75, 97.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [7686.25, 8645.25, 9223.75, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [63.0, 70.0, 73.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]] @=> float groups_front[][];
[[52.0, 56.0, 64.0, 84.0, 100.0, 112.0, 128.0, 0.0, 0.0, 0.0, 0.0, 0.0], [60.0, 70.0, 80.0, 110.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [55.0, 70.0, 90.0, 105.0, 110.0, 125.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [60.0, 75.0, 90.0, 110.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [60.0, 80.0, 84.0, 90.0, 108.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [52.0, 56.0, 60.0, 64.0, 80.0, 84.0, 96.0, 100.0, 108.0, 112.0, 120.0, 128.0], [56.0, 84.0, 108.0, 112.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [56.0, 70.0, 77.0, 105.0, 112.0, 182.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [56.0, 60.0, 80.0, 84.0, 100.0, 108.0, 112.0, 128.0, 0.0, 0.0, 0.0, 0.0], [60.0, 80.0, 84.0, 96.0, 108.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [56.0, 70.0, 77.0, 84.0, 105.0, 112.0, 182.0, 0.0, 0.0, 0.0, 0.0, 0.0], [60.0, 70.0, 100.0, 105.0, 125.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [50.0, 55.0, 60.0, 70.0, 75.0, 80.0, 90.0, 100.0, 105.0, 110.0, 120.0, 125.0], [60.0, 96.0, 120.0, 132.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [60.0, 70.0, 100.0, 105.0, 125.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [55.0, 75.0, 90.0, 110.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [56.0, 60.0, 80.0, 100.0, 105.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [54.0, 60.0, 66.0, 81.0, 84.0, 90.0, 96.0, 108.0, 0.0, 0.0, 0.0, 0.0], [50.0, 56.0, 60.0, 70.0, 80.0, 100.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0], [54.0, 60.0, 66.0, 84.0, 96.0, 108.0, 132.0, 0.0, 0.0, 0.0, 0.0, 0.0], [60.0, 90.0, 108.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [60.0, 84.0, 90.0, 108.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [52.0, 56.0, 60.0, 64.0, 80.0, 84.0, 96.0, 100.0, 108.0, 112.0, 120.0, 128.0], [66.0, 84.0, 90.0, 108.0, 120.0, 132.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [66.0, 75.0, 90.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]] @=> float groups_contact[][];
[[52.44, 61.18, 96.14, 113.62, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [52.44, 61.18, 96.14, 113.62, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]] @=> float groups_behind[][];
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