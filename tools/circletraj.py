import math
dist =24
nbsteps = 64
tabval = []
for ii in range (0, nbsteps):
    angle=ii * (2*math.pi/nbsteps)
    [px, py] = [round(dist*math.cos(angle)), round(dist*math.sin(angle))]
    angleZ = round((math.atan2(-py, -px)*(256/(2*math.pi))) )
    tabval.append(px)
    tabval.append(py)
    tabval.append(angleZ)
print (tabval)


    