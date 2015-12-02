# BiotSavart.sage
A [SageMath](http://www.sagemath.org/) module that uses the Biot-Savard law to numerically computes magnetic fields created from a current passing through a wire given as an arbitrary parametrized curve in 3-space. The curves are specified in SageMath and the numerical calculations are done with [numpy](http://www.numpy.org/) for low overhead high speed computation. All software is free open source.

![ScreenShot](Solenoid.png?raw=true "The curve doesn't have to be a solenoid :-)")
 
# Contributing:
Please give me a hand if you want to. This is a great opportunity to learn some Python. Also if you have some interesting curves please share them with me l453r7r0n@gmail.com.

# Usage
It's pretty straightforward, the code should be self-expanatory. A complete newbie could:
 1. [Sign up for sage](http://www.sagemath.org/). 
 2. Create a new worksheet. 
 3. Copy the code of `BiotSavart.sage` into Sage notebook cell and evaluate.
 4. Copy the code of `BSExamples.sage` into another cell, evaluate, and experiment.
Personally though, I prefer using the command line interpreter.

#Features:
* Input wires as triples of functions describing parametrized curves, Sage does the calculus. Try any shape you can think of.
* Plot magnetic fields and field lines.
* You can superpose magnetic fields created from multiple components.
* As precise as you want it to be.

# Projected features:
* Computation of coupling constants.
* Better unit support.
* Error estimation.
* Improvements to visualisation, e.g. projections of the field onto planes.
* Methods to create interesting families of curves, e.g. a wire wrapped arount a torus.
* Better physics (I'm not a physicist)
