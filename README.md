# BiotSavart.sage
A [SageMath](http://www.sagemath.org/) module that uses the Biot-Savard law to numerically computes magnetic fields generated from a current passing through a wire given as a parametrized curve. The numerical calculations are done with [numpy](http://www.numpy.org/) for low overhead high speed computation.

# Contributing:
Please give me a hand if you want to. This is a great opportunity to learn some Python. Also if you have some interesting curves please share them with me!

# Usage
It's pretty straightforward, the code should be self-expanatory. A complete newbie could:
 1. Sign up for sage. 
 2. Create a new worksheet. 
 3. Copy the code of `BiotSavart.sage` into Sage notebook cell and evaluate.
 4. Copy the code of `BSExamples.sage` into another cell, evaluate, and experiment.
Personally though, I prefer using the command line interpreter.

# Projected features:
* The ability to support piecewise-defined curves.
* Computation of coupling constants.
* Better unit support.
* Error estimation.
* Improvements to visualisation.
* Methods to create interesting families of curves, e.g. a wire wrapped arount a torus.
