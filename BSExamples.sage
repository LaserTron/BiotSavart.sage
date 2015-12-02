#!/bin/python
#Line added for synthax hlighting

load("BiotSavart.sage") #delete this line if using notebook
tau=2*np.pi #tau = one turn

print "Showing a solenoid"
helix = threeDeeCurve(cos(t),sin(t),t/(10*tau))
helixGr = helix.toGraphicsObject([0,3*10*tau],samples=1000)
hFF = helix.makeFieldFunction([0,3*10*tau],samples=1000)

print "Building magnetic field"
mfGr=plotMagField(hFF,[-2,2],[-2,2],[-2,8],unit=True,drawArrows=False)

print "Tracing field lines"
L=traceFieldLine(hFF,[0.5,0.5,0],stepsize=0.01,steps=100)

print "Showing the magnetic field and a field line"
show(mfGr+helixGr+L) #Field lines to not close up due to numerical errors


print "Showing a current loop."
circle = threeDeeCurve(cos(t),sin(t),0)
circleGr = circle.toGraphicsObject([0,tau])
cFF = circle.makeFieldFunction([0,tau],samples=500)
cmfgr = plotMagField(cFF,[-3,3],[-3,3],[-3,3],unit=True)
cL = traceFieldLine(cFF,[0.5,0.5,0],stepsize=0.01,steps=1000)
show(circleGr+cmfgr+cL)

print "Showing a current loop and a solenoid."
sol = threeDeeCurve(2+t/tau,sin(t),cos(t))
solFF = sol.makeFieldFunction([0,5*tau])
solGr = sol.toGraphicsObject([0,5*tau])
totFF = superpose(solFF,cFF)#put loop and sol together
totmf = plotMagField(totFF,[-2,7],[-2,2],[-2,2],unit=True)#,drawArrows=False)
show(solGr+circleGr+totmf)
