#!/bin/python
#Line added for syntha

"""This sage module computes the magnetic field produced from a
current going through a wire described by a parametrized curve in
3-space.

"""

import numpy as np
var("t")

def magFieldBundle(initial,deltax,deltay,deltaz,delta,TB):
    """Computes the magnetic field from a wire tangent bundle TB, in a
    parallepiped whith one corner initial, and width, depth, height
    given by deltax, deltay, deltaz. delta gives the sudivision
    size.

    """
    
    pts = cubePoints(initial,deltax,deltay,deltaz,delta)
    print "Number of points to compute: "+str(len(pts))
    output = []
    c = 0
    for p in pts:
        output.append(magAtPoint(TB,p))
        c = c+1
        if c%50 == 0:
            print c        
    return [pts,output]

def unitFieldBundle(initial,deltax,deltay,deltaz,delta,TB):
    """Same as magFieldBundle, but every vector is a unit vector.

    """

    pts = cubePoints(initial,deltax,deltay,deltaz,delta)
    print "Number of points to compute: "+str(len(pts))
    output = []
    c = 0
    for p in pts:
        vect = magAtPoint(TB,p)
        mag = np.linalg.norm(vect)
        if mag ==0:
            output.append(np.array([0,0,0]))#zero vector normalizes to 0
        else:
            vect = 0.5*(1/mag)*vect
            output.append(vect)
        c = c+1
        if c%50 == 0:
            print c        
    return [pts,output]

def cubePoints(initial,deltax,deltay,deltaz,delta):
    """Lists the points in a parallpiped with a corner initial and width
    depth height given by deltax deltay deltaz at even x,y,z intervals
    = delta

    """
    initial = vector(RR,initial)
    output=[]
    xpos = initial[0]
    ypos = initial[1]
    zpos = initial[2]
    while xpos <= initial[0]+deltax:
        while ypos <= initial[1]+deltay:
            while zpos <= initial[2]+deltaz:
                output.append(vector([xpos,ypos,zpos]))
                zpos = zpos+delta
            zpos = initial[2]
            ypos = ypos+delta
        ypos = initial[1]
        xpos = xpos+delta
    return output

def quickFill(l,x):
    """Creates a numpy array with length l filled with x.

    """
    emp = np.zeros(l)
    emp.fill(x)
    return emp

def speedify(f):
    """This function is to turn real numbers into a vectorized constant
    function, and to make other sage functions vectorized and fast_callable.

    """
    if f in RR:
        return lambda t : quickFill(len(t),f)
            #SOLUTION: return constant numpy array
            #http://stackoverflow.com/questions/5891410/numpy-array-initialization-fill-with-identical-values
            
    else:
        return fast_callable(f,vars=[t])
            #the option domain=RDR seemed interesting, but it
            #un-vectorized the functions and then re-vectorizing
            #looses speed.

class threeDeeCurve:
    """This object is equipped with methods do work with curves in
    3-space, defined by 3 coordinate functions in the variable t. The
    variable t is the independent variable, and things are set up so
    that numpy can be used. """
    
    def __init__(self,f_x,f_y,f_z):
        """Records the coordinate functions and makes 
        fast implementations of them"""
        var("t")
        self.coord_x=f_x
        self.coord_y=f_y
        self.coord_z=f_z
        self.ffx = speedify(self.coord_x)
        self.ffy = speedify(self.coord_y)
        self.ffz = speedify(self.coord_z)

    def toTriple(self):
        """Returns coordinate functions as a triple"""
        return([self.coord_x,self.coord_y,self.coord_z])

    def toFtriple(self):
        """Returns triple of fast_callable coordinate functions"""
        return([self.ffx,self.ffy,self.ffz])
               
    def derivative(self):
        """Outpts the 3dCurve object corresponding the the 
        derivative"""

        dx = derivative(self.coord_x)
        dy = derivative(self.coord_y)
        dz = derivative(self.coord_z)

        return threeDeeCurve(dx,dy,dz)

    def toFunction(self):
        """Returns a python/numpy function that takes numbers as 
        inputs and returns triples representing points in 3-space."""
        return lambda t : np.array([self.ffx(t),self.ffy(t),self.ffz(t)]).transpose()

    def toGraphicsObject(self,tdomain,linecolor='red',samples=100):
        """Returns a sage parametric plot of the curve, the 
        domain is a lst with two entries (which looks like a 
        closed interval)."""
        return parametric_plot3d(self.toTriple(),(tdomain[0],tdomain[1]),color=linecolor,plot_points=samples)

    def tangentBundle(self,interval,samples=100):
        """Creates the tangent bundle for the curve over the interval interval
        (2 element list), with the specified number of evenly spaces
        sample points. The result is a 2 element list of numpy arrays
        of three vectors the 0-entry is a numpy array of points on the
        curve, the 1-entry is the numpy array of tangent vectors at
        the corresponding points.

        The tangent bundle is the main computational object used to
        compute the magnetic field. It encodes the interval for the
        parametrized curve you want to compute with, and the more
        samples used, the better the Riemann sum approximations of the
        magnetic field.

        """
        dc = self.derivative()
        sf = self.toFunction()
        df = dc.toFunction()
        L=np.linspace(interval[0],interval[1],samples)
        return [sf(L),df(L)]
        

def magAtPoint(bundle,point,factor=0.1):
    """Given the tangent bundle of a curve, this function computes the
     magnetic field at the point, or more specifically, does a Riemann
     sum approximation if the vector. The number of summands depends
     on the number of samples in the tangent bundle.

    dB is the same as give here:
     https://en.wikibooks.org/wiki/Electrodynamics/Biot-Savart_Law up
     to IK_m.
    
    So far the computation is dimensionless. The factor argument, can
    be used to to specify constants. It should also incorporate the Delta
    t factor in a Riemann sum with equal subdivisions.

    """
    
    point = np.array(point,dtype='float64')
    cp = point-bundle[0] #vectors from curve to point
    rs = np.linalg.norm(cp,axis=1)
    if rs.min() == 0:
        return np.array([0,0,0])
    #http://stackoverflow.com/questions/5795700/multiply-numpy-array-of-scalars-by-array-of-vectors
    rcubinv = rs**(-3)
    urr=cp*rcubinv[:,np.newaxis]
    dBs = factor*np.cross(bundle[1],urr)
    return dBs.sum(axis=0)


def drawBundle(bun,drawArrows=True):
    """Draws a tangent bundle"""
    base=bun[0]
    tans=bun[1]
    lh = len(base)
    bun = np.hstack([base,tans]).reshape(lh,2,3)
    output = []
    for i in bun:
        if drawArrows==True:
            output.append(arrow(i[0],i[0]+i[1]))
        else:
            output.append(line([i[0],i[0]+i[1]]))
    G=0
    for i in output:
        G=G+i
    return G

def plotMagField(tanbundle,xint,yint,zint,stepsize=1,unit=False,drawArrows=True):
    """Returns a Sage 3D graphics object representing the magnetic field
    made by the wire with the specified tangent bundle.

    """
    cubeinput = {
        'initial' : [xint[0],yint[0],zint[0]],
        'deltax': xint[1]-xint[0],
        'deltay': yint[1]-yint[0],
        'deltaz': zint[1]-zint[0],
        'delta' : stepsize,
    }
    pts = cubePoints(**cubeinput)
    cubeinput['TB']=tanbundle
    if unit:
        mfb = unitFieldBundle(**cubeinput)
    else:
        mfb = magFieldBundle(**cubeinput)
    return drawBundle(mfb,drawArrows=drawArrows)

def normalize(v):
    "Returns a unit length numpy vector"
    mag = np.linalg.norm(v)
    if mag == 0:
        return np.array([0,0,0])
    else:
        return (1/mag)*v

def traceFieldLine(tanbundle,initial,stepsize=0.1,steps=100,lcolor='green'):
    """Given a tangent bundle, traces a portion of a field line starting
    at the initial point. """
    
    initial = np.array(initial)
    path = [initial]
    cur = initial
    for i in range(steps):
        vect = magAtPoint(tanbundle,cur)
        vect = stepsize*normalize(vect)
        cur = cur+vect
        path.append(cur)
    return line3d(path,color=lcolor)
