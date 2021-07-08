# cshapes-genalg
Matlab files to generate Comsol simulation with genetic algorith optimization for a bidimensional optomechanical cavity

These files are not well organized, but they can be the starting point for a genetic algorithm optimization. It is composed of four files:

- defect_generate.m : This one is used to construct the shape of the defect. It can be used for any of the different parameters. I was using a gaussian defect. You can adapt to a parabolic defect (which is more usual in photonic crystals). 

- callcomsol.m : creates the basic geometry and physics of the problem on comsol

- myfitness.m : This is the most important function of the loop. It computes a fitness function that will be optimized. Probably here you will have to play a lot. In the one I used, I was just optimizing the optical quality factor, as you can see in the end of this script (minimizing y=1e7-Qopt). So at every step, the script was defining new parameters (in the input vector x) and using it to generate the new geometry and compute y. I think you should include g0 coputation also here, but this I have not done.

- run_ga.m :  This is the script you are gonna run. It runs the genetic algorithm based on some parameters (boundaries, number of steps etc). You should check on matlab help (https://www.mathworks.com/help/gads/ga.html) to find more information about this functions and all their options. After some runs, it should start plotting the results. 

Important: this script takes a lot of time to run, depending on the options you choose. Usually a good round would run overnight or more. So, try many small tests to check if everything is working. Moreover, it is possible that you have some issues with comsol version compatibility. I used version 3.3 to create this script, but the ones I made for my thesis that are on Zenodo were made on comsol 5.5. So it is possible that you will have to adapt the callcomsol script. The basic script can be generated automatically by comsol (in COMSOL, File > Save as Model M-file, don’t forget to simplify your comsol file before).  
