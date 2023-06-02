# ComputingWithPhotonicPhaseChangeMemory
Set of programs used to verify the model of the PCM and to generate the graphs used in the paper Computing With Photonic Phase Change Memory

Verification of Model:
The First piece of Software to consider is the Verification of Model. This piece of software
contains all of the equations and basic equations and variables to create and test the Phase
Changing Material model to see if it is representative of models found in papers.

In the Software there are many comments for the understanding of the software but the basic
construction of the software is it starts out with declaration of variables and the Power in is
5 spikes of optical power that program the PCM. The next step is to calculate the resulting
temperature of the PCM which can be calculated only at the position Z=0 as the heat spreads
through the PCM is a predictable way allowing us to calculate the heat everywhere on the PCM 
based on the temp at Z=0.

The next step of the software is that from the temperature of the PCM to calculate the Zint: or
where the PCM switches from crystalline stage and amorphous stage. Once the Zint is found this
is what we need to read the PCM state which allows us to read the value programmed into the PCM.
Now that the PCM is programmed we read the PCM over the entire timespan.

The output of the Verification Of Model Software is a 3 graphed output screen where the top graph
is the Temperature of the PCM, the second graph is the Zint in the PCM, and the third graph is the
Delta Transmission or the change of optical transmittance measured at the read port which shown 
that proportionally as the Zint changes the optical transmission also changes. These graphs also
back up and show the same information as previous models and implementation of PCMs.


L Shaped Pulse:
This follows the same structure and equations from the Verification of Model however the inputs
are no longer spikes but a 2 pieced L shaped pulse with a optically intense starting pulse of
short length followed immediately by a second much less optically intense but much longer than
the length of the initial pulse. This allows precise controlling of the state of the PCM. The
software of "LShapedPulse.m" also uses the output of the piece of software 
"LShappedPulseFindingLengthOfTail.m" which outputs the length of each secondary pulse so that it
can program the PCM to the correct value. These 2 pieces of software allow us to find and implement
the use of L shaped pulses which are important as L shaped pulse can program a PCM value into the 
PCM without needing to know the PCM current state.


PCM 4 Bit:
This piece of software uses the same equations and structure from the Verification of Model
however, this software’s output is that the first graph shows the temperature reaction of the PCM
for each L shaped pulse the PCM can support. There are 16 different pulses with 16 different
times representing a 4-bit number that the PCM can store. The second graph shows the 16 different
Zints of the PCM from the sixteen different L shaped programming pulses. The Final bottom graph is the
Read out or the output of the PCM when read by a reading pulse.


Multiplication Table Generator:
This piece of software uses the same equations and structure from the Verification of Model
however, this software's output is a variable which is a matrix of size 16x16. The x-axis is the
input value and the y-axis is the weight value. The input power is represented on the length of time.
the read signal is on the PCM, and the weight value is from the PCM. These values are gotten when the
value read from the PCM is then integrates over the length of time the read signal exists. These
integration numbers are simulating when the light resulting signal is then passed to the optical detector
which then creates a current proportional to the power of the signal for the same length. From these
numbers we can then calculate the product of the input value and the weight value. The variable that 
holds this multiplication table of sorts is in the variable "Matrix". When opened we can see the 16x16
matrix of numbers.


