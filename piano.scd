s.boot;

//Sends MIDI to Grand Piano instrument in Ableton Live 9

MIDIClient.init;

~mOut = MIDIOut.new(3);

//Set the scale to be Cmajor
~scale=[0,2,4,5,7,9,11];

//Define pattern proxies which will be modified by the task t below

a=PatternProxy(Pxrand([3,3,3,1,3,3],inf));
b=PatternProxy(Pseq([1/2],inf));
r=PatternProxy(Pseq([12],inf));
n=Prand([4,8,16],inf).asStream;

t=Task({
Pdef(\x,Pbind(\type,\midi,\chan,0,
          \midiout,~mOut,
          \scale,~scale,
          \root,-12,
          \degree,Pxrand([[0,3,5],[3,5,7],[4,6,8],[5,7,11]],inf),
          \legato,1,
          \amp,[{rrand(0.6,0.8)},{rrand(0.5,0.6)},{rrand(0.5,0.6)}]*0.7,    \dur,Prand([Pseq([1,1,1,1],1),Pseq([1,1,2],1),Pseq([1,2,1],1)],inf))).play(quant:1);

Pdef(\y,Pbind(\type,\midi,\chan,0,
          \midiout,~mOut,
          \scale,~scale,
          \root,r,
          \degree,a,
          \legato,1,
          \amp,{rrand(0.5,0.6)},
\dur,b)).play(quant:1);

10.wait;

t=Task({
    inf.do({
        if (0.7.coin,{ 
         c=[[3,0,7,1,9,11,0,4],[[3,7],0,7,Rest,9,[0,11],0,4]].choose.scramble;
             r.source=Pseq([[12,24].wchoose([0.7,0.3])],inf);
         d=n.next;
             a.source=Pseq([Pxrand(c,d),Pxrand([3,3,3,1,3,3],inf)]);
             b.source=Pseq([Pseq([1/8],d),Pseq([1/2],inf)]);
           });
       rrand(3,4).wait;})}).play(quant:1);
    };
).play(quant:1);
