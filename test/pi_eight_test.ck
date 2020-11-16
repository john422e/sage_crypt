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
[9816.0, 9259.75, 9261.25, 8892.5, 7751.75, 50.25, 9261.5, 60.75, 9427.75, 9264.25, 8739.5, 8555.25, 9257.75, 8673.75, 8891.75, 9281.0, 9448.5, 9099.25, 9257.5, 9486.25, 9111.5, 9258.25, 9441.75, 9357.5, 9340.5, 9672.5, 9484.5, 54.75, 8896.5, 9260.25, 8999.0, 9676.5, 8628.5, 9065.5, 9181.0, 9460.75, 9677.5, 8522.25, 9630.0, 7753.25, 9566.25, 8457.75, 9258.5, 6574.75, 8771.25, 9254.5, 7917.75, 56.5, 8737.5, 9271.25] @=> float peaks_front[];
[71.0, 67.0, 54.0, 66.0, 80.0, 84.0, 130.0, 69.0, 68.0, 65.0, 74.0, 104.0, 105.0, 114.0, 56.0, 3528.0, 87.0, 95.0, 88.0, 75.0, 119.0, 52.0, 93.0, 61.0, 137.0, 72.0, 111.0, 133.0, 51.0, 108.0, 152.0, 70.0, 94.0, 64.0, 82.0, 129.0, 139.0, 176.0, 98.0, 128.0, 134.0, 121.0, 3499.0, 79.0, 157.0, 3469.0, 158.0, 116.0, 156.0, 3452.0] @=> float peaks_contact[];
[120.0, 118.0, 50.0, 56.0, 54.0, 138.0, 78.0, 74.0, 60.0, 122.0, 9592.0, 9594.0, 58.0, 9842.0, 116.0, 62.0, 154.0, 9754.0, 9522.0, 66.0, 104.0, 7860.0, 88.0, 8398.0, 76.0, 9532.0, 8638.0, 112.0, 8508.0, 8388.0, 128.0, 68.0, 9598.0, 86.0, 8394.0, 8602.0, 8728.0, 8582.0, 9304.0, 7804.0, 9194.0, 7460.0, 8604.0, 8198.0, 9410.0, 124.0, 114.0, 8786.0, 8834.0, 8448.0] @=> float peaks_behind[];

[[8891.75, 9261.25, 9630.0, 0.0, 0.0, 0.0, 0.0]] @=> float groups_front[][];
[[54.0, 66.0, 72.0, 84.0, 108.0, 0.0, 0.0], [66.0, 72.0, 84.0, 108.0, 156.0, 0.0, 0.0], [65.0, 104.0, 130.0, 156.0, 0.0, 0.0, 0.0], [65.0, 70.0, 80.0, 105.0, 130.0, 0.0, 0.0], [95.0, 114.0, 133.0, 152.0, 0.0, 0.0, 0.0], [56.0, 80.0, 104.0, 176.0, 0.0, 0.0, 0.0], [95.0, 114.0, 133.0, 152.0, 0.0, 0.0, 0.0], [65.0, 70.0, 75.0, 80.0, 105.0, 130.0, 0.0], [64.0, 72.0, 84.0, 104.0, 128.0, 0.0, 0.0], [95.0, 114.0, 133.0, 152.0, 0.0, 0.0, 0.0], [56.0, 64.0, 72.0, 84.0, 104.0, 128.0, 0.0], [56.0, 70.0, 84.0, 98.0, 105.0, 0.0, 0.0], [66.0, 88.0, 121.0, 176.0, 0.0, 0.0, 0.0], [54.0, 66.0, 84.0, 108.0, 156.0, 0.0, 0.0]] @=> float groups_contact[][];
[[60.0, 104.0, 120.0, 128.0, 0.0, 0.0, 0.0], [50.0, 54.0, 56.0, 60.0, 120.0, 0.0, 0.0], [56.0, 88.0, 112.0, 128.0, 0.0, 0.0, 0.0], [54.0, 60.0, 78.0, 120.0, 0.0, 0.0, 0.0], [60.0, 78.0, 104.0, 120.0, 0.0, 0.0, 0.0], [60.0, 66.0, 88.0, 120.0, 0.0, 0.0, 0.0], [60.0, 88.0, 104.0, 112.0, 120.0, 128.0, 0.0], [60.0, 88.0, 104.0, 112.0, 128.0, 0.0, 0.0], [56.0, 88.0, 112.0, 154.0, 0.0, 0.0, 0.0], [56.0, 60.0, 88.0, 104.0, 112.0, 120.0, 128.0]] @=> float groups_behind[][];
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