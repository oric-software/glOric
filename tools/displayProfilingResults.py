#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      tbpk7658
#
# Created:     09/03/2020
# Copyright:   (c) tbpk7658 2020
# Licence:     <your licence>
#-------------------------------------------------------------------------------


PATH_TO_PRINTER_OUT = 'C:\\Users\\tbpk7658\\Applis\\osdk_1_15\\Oricutron\\printer_out.txt'
#PATH_TO_PRINTER_OUT = 'C:\\Users\\tbpk7658\\Documents\\Projets\\glOric\\tests\\benchmark_results.txt'

def main():
    ficin = open (PATH_TO_PRINTER_OUT, 'r')
    lines = ficin.readlines()
    ficin.close()

    dictNumCycle = {}
    for li in lines:
        #print (li)
        try:
            [fild1, fild2, fild3] = li.replace("\r","").replace("\n","").split(" ")
            #print (fild3, int(fild2,16), fild1)
            if fild3 in dictNumCycle.keys():
                dictNumCycle[fild3] += int(fild2,16)
            else :
                dictNumCycle[fild3] = int(fild2,16)
            #print ("%s is now : %d"%(fild3, dictNumCycle[fild3]))
        except :
            pass

    for ke in dictNumCycle.keys():
        print ("%20s => \t\t%8d cycles"%(ke, dictNumCycle[ke]))
if __name__ == '__main__':
    main()
