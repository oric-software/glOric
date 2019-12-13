import math
N=7

with open('output.txt', 'w') as file:  # Use file to refer to the file object


    for X in range (-N,N+1):
        for Y in range (-N,N+1):
            exp = round(math.atan2(Y,X)*(128.0/math.pi))
            if (exp == 128):  exp = -128
            file.write("""\ttx = %d; ty = %d; res = 0; atan2_8 (); if (res!=%d) printf("ERR atan2 (%%d, %%d) = %%d exp=%d\\n", tx, ty, res);
            \n"""%(X, Y
            , exp
            , exp
            ))
            #print (tmplt)

