#!/bin/python
#Line added for synthax hlighting

load("BiotSavart.sage")
tau=2*np.pi #tau = one turn

helix = threeDeeCurve(cos(t),sin(t),t/(4*tau))
helixGr = helix.toGraphicsObject([0,6*4*tau],samples=200)
#print "Showing helix"
#show(helixGr)

hvb = helix.tangentBundle([0,6*4*tau],samples=200)
hvbGr = drawBundle(hvb)
print "Showing a tangent bundle"
show(hvbGr)

print "Building magnetic field"
mfGr=plotMagField(hvb,[-3,3],[-3,3],[-2,8],unit=True,drawArrows=False)

L=traceFieldLine(hvb,([0.5,0.5,0]))
L2=traceFieldLine(hvb,([1.5,0,3]))

print "Showing a magnetic field and some field lines"
show(mfGr+helixGr+L+L2)


circle = threeDeeCurve(cos(t),sin(t),0)
circleGr = circle.toGraphicsObject([0,tau])
ctb = circle.tangentBundle([0,tau],samples=500)
cmfgr = plotMagField(ctb,[-3,3],[-3,3],[-3,3])
cL = traceFieldLine(ctb,([0.5,0.5,0]))
show(circleGr+cmfgr+cL)
