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
[120.0, 8847.0, 60.5, 68.5, 8848.0, 52.75, 9949.0, 8848.25, 9944.0, 72.75, 78.75, 60.0, 68.25, 73.25, 78.25, 175.25, 77.25, 9947.5, 71.25, 75.0, 72.0, 59.75, 72.5, 74.0, 8122.5, 69.75, 9948.0, 9068.75, 8846.75, 9528.5, 208.25, 58.5, 9025.75, 8574.25, 82.0, 69.25, 180.5, 9531.75, 8849.25, 8542.25, 8778.5, 8059.5, 9366.25, 8757.0, 9555.0, 9942.25, 8992.5, 9834.75, 96.5, 8683.5] @=> float peaks_front[];
[53.0, 52.0, 67.0, 76.0, 51.0, 59.0, 50.0, 106.0, 97.0, 55.0, 54.0, 74.0, 83.0, 56.0, 64.0, 61.0, 57.0, 58.0, 90.0, 108.0, 120.0, 89.0, 105.0, 110.0, 135.0, 80.0, 107.0, 85.0, 93.0, 91.0, 71.0, 65.0, 94.0, 136.0, 122.0, 103.0, 66.0, 119.0, 127.0, 88.0, 129.0, 63.0, 133.0, 173.0, 167.0, 140.0, 98.0, 72.0, 145.0, 115.0] @=> float peaks_contact[];
[120.0, 55.0, 80.33, 77.67, 72.67, 52.67, 74.0, 60.0, 68.67, 53.33, 78.0, 61.67, 61.33, 51.33, 77.33, 72.0, 68.33, 73.33, 86.67, 50.0, 56.0, 78.33, 106.33, 57.67, 65.67, 54.33, 65.33, 87.33, 64.33, 81.67, 86.0, 76.0, 9379.0, 63.67, 69.33, 58.67, 111.0, 50.33, 80.0, 9571.0, 65.0, 85.67, 95.0, 64.0, 59.33, 8825.67, 71.33, 57.0, 9422.0, 77.0] @=> float peaks_behind[];

[[60.0, 75.0, 78.75, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0], [60.0, 72.0, 75.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0], [60.0, 69.25, 75.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]] @=> float groups_front[][];
[[52.0, 64.0, 72.0, 88.0, 108.0, 120.0, 0.0, 0.0, 0.0], [51.0, 85.0, 119.0, 136.0, 0.0, 0.0, 0.0, 0.0, 0.0], [50.0, 90.0, 120.0, 140.0, 0.0, 0.0, 0.0, 0.0, 0.0], [55.0, 65.0, 80.0, 90.0, 105.0, 110.0, 120.0, 135.0, 140.0], [54.0, 63.0, 72.0, 108.0, 135.0, 0.0, 0.0, 0.0, 0.0], [52.0, 56.0, 64.0, 72.0, 80.0, 88.0, 108.0, 120.0, 0.0], [80.0, 90.0, 120.0, 140.0, 0.0, 0.0, 0.0, 0.0, 0.0], [66.0, 72.0, 108.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0], [55.0, 90.0, 120.0, 135.0, 0.0, 0.0, 0.0, 0.0, 0.0], [63.0, 105.0, 135.0, 140.0, 0.0, 0.0, 0.0, 0.0, 0.0], [55.0, 88.0, 110.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0], [54.0, 72.0, 90.0, 108.0, 120.0, 135.0, 0.0, 0.0, 0.0], [80.0, 88.0, 110.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0], [51.0, 85.0, 119.0, 136.0, 0.0, 0.0, 0.0, 0.0, 0.0], [65.0, 91.0, 105.0, 140.0, 0.0, 0.0, 0.0, 0.0, 0.0], [65.0, 80.0, 110.0, 135.0, 0.0, 0.0, 0.0, 0.0, 0.0], [51.0, 85.0, 119.0, 136.0, 0.0, 0.0, 0.0, 0.0, 0.0], [66.0, 72.0, 90.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0], [51.0, 85.0, 119.0, 136.0, 0.0, 0.0, 0.0, 0.0, 0.0], [64.0, 80.0, 88.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0], [63.0, 91.0, 105.0, 140.0, 0.0, 0.0, 0.0, 0.0, 0.0], [56.0, 63.0, 91.0, 98.0, 105.0, 140.0, 0.0, 0.0, 0.0]] @=> float groups_contact[][];
[[60.0, 73.33, 80.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0], [55.0, 60.0, 73.33, 80.0, 0.0, 0.0, 0.0, 0.0, 0.0], [60.0, 73.33, 80.0, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0], [56.0, 69.33, 72.0, 80.0, 0.0, 0.0, 0.0, 0.0, 0.0], [60.0, 78.0, 86.67, 120.0, 0.0, 0.0, 0.0, 0.0, 0.0], [50.0, 60.0, 65.0, 80.0, 86.67, 120.0, 0.0, 0.0, 0.0], [56.0, 60.0, 72.0, 80.0, 120.0, 0.0, 0.0, 0.0, 0.0], [53.33, 56.0, 60.0, 64.0, 72.0, 80.0, 120.0, 0.0, 0.0], [53.33, 58.67, 73.33, 77.0, 0.0, 0.0, 0.0, 0.0, 0.0]] @=> float groups_behind[][];
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