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
[60.0, 205.5, 64.25, 169.0, 120.0, 51.75, 55.75, 74.25, 51.25, 53.0, 63.75, 60.75, 59.0, 50.0, 52.0, 50.5, 50.25, 56.25, 73.75, 55.0, 73.25, 79.75, 89.0, 57.5, 54.0, 53.75, 52.25, 88.5, 80.75, 54.75, 118.25, 8367.5, 9415.75, 57.75, 61.75, 67.25, 8545.0, 66.5, 57.25, 51.0, 70.75, 6962.0, 58.5, 9690.0, 64.5, 68.5, 8392.75, 68.25, 9598.75, 56.0] @=> float peaks_front[];
[64.0, 55.0, 56.0, 69.0, 70.0, 71.0, 83.0, 95.0, 146.0, 52.0, 102.0, 105.0, 3499.0, 104.0, 139.0, 106.0, 85.0, 145.0, 57.0, 99.0, 62.0, 76.0, 126.0, 3598.0, 143.0, 3575.0, 3475.0, 178.0, 3563.0, 66.0, 58.0, 60.0, 50.0, 61.0, 3305.0, 3610.0, 3480.0, 3513.0, 3584.0, 67.0, 100.0, 127.0, 3646.0, 63.0, 3544.0, 3543.0, 3504.0, 3380.0, 3620.0, 3618.0] @=> float peaks_contact[];
[120.0, 50.33, 60.0, 53.0, 205.33, 96.67, 65.33, 59.67, 58.67, 68.67, 50.0, 56.33, 54.33, 58.33, 60.33, 130.33, 129.33, 156.33, 51.0, 71.33, 51.67, 82.0, 50.67, 130.67, 56.67, 63.0, 84.0, 97.33, 90.0, 123.33, 94.33, 58.0, 118.33, 89.67, 52.33, 51.33, 69.0, 155.67, 87.0, 85.67, 57.67, 52.0, 73.67, 162.67, 134.0, 55.33, 70.0, 65.0, 57.33, 103.0] @=> float peaks_behind[];

[[50.0, 54.0, 56.0, 60.0, 120.0, 0.0], [55.0, 57.75, 74.25, 0.0, 0.0, 0.0], [58.5, 60.75, 79.75, 0.0, 0.0, 0.0], [50.5, 67.25, 80.75, 0.0, 0.0, 0.0], [56.25, 60.0, 120.0, 0.0, 0.0, 0.0], [52.25, 61.75, 66.5, 0.0, 0.0, 0.0], [54.75, 68.5, 205.5, 0.0, 0.0, 0.0], [52.25, 61.75, 66.5, 0.0, 0.0, 0.0], [58.5, 60.75, 79.75, 0.0, 0.0, 0.0], [54.75, 68.5, 205.5, 0.0, 0.0, 0.0], [52.0, 58.5, 68.25, 0.0, 0.0, 0.0], [52.0, 56.0, 60.0, 120.0, 0.0, 0.0]] @=> float groups_front[][];
[[52.0, 56.0, 60.0, 64.0, 100.0, 104.0], [56.0, 60.0, 100.0, 105.0, 0.0, 0.0], [55.0, 60.0, 70.0, 100.0, 105.0, 0.0], [52.0, 56.0, 64.0, 104.0, 0.0, 0.0], [60.0, 70.0, 105.0, 126.0, 0.0, 0.0], [52.0, 60.0, 100.0, 104.0, 0.0, 0.0], [56.0, 60.0, 70.0, 126.0, 0.0, 0.0], [50.0, 55.0, 60.0, 70.0, 100.0, 105.0], [56.0, 60.0, 70.0, 100.0, 105.0, 0.0], [60.0, 63.0, 70.0, 105.0, 126.0, 0.0]] @=> float groups_contact[][];
[[60.0, 65.0, 90.0, 120.0, 0.0, 0.0], [65.33, 84.0, 130.67, 205.33, 0.0, 0.0], [60.0, 65.0, 70.0, 90.0, 120.0, 0.0], [51.33, 65.33, 84.0, 130.67, 205.33, 0.0], [50.0, 60.0, 85.67, 120.0, 0.0, 0.0], [60.0, 70.0, 84.0, 120.0, 0.0, 0.0]] @=> float groups_behind[][];
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