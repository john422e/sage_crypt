SinOsc s1 => dac;
SinOsc s2 => dac;
SinOsc s3 => dac;
SinOsc s4 => dac;
SinOsc s5 => dac;
SinOsc s6 => dac;
SinOsc s7 => dac;
SinOsc s8 => dac;

0.1 => s1.gain => s2.gain => s3.gain => s4.gain => s5.gain => s6.gain => s7.gain => s8.gain;


50 => s1.freq;
100 => s2.freq;
200 => s3.freq;
400 => s4.freq;
800 => s5.freq;
1600 => s6.freq;
3200 => s7.freq;
6400 => s8.freq;


5::second => now;