#! /usr/bin/env python

# screen issue
import matplotlib
matplotlib.use('Agg')

from scipy.ndimage import gaussian_filter1d
from netCDF4 import MFDataset, Dataset, num2date, date2num
import numpy as np
import matplotlib.pyplot as plt
#import matplotlib.tri as tri
#from mpl_toolkits.basemap import Basemap
import matplotlib.cm as cm
import glob
import matplotlib
import numpy.ma as ma
import datetime
from dateutil.relativedelta import relativedelta
import sys
import os
from os.path import join
###############################################################

pbest=np.ndarray(shape=(22), dtype=np.float32, order='F')
wbest=np.ndarray(shape=(22), dtype=np.float32, order='F')
lonbest=np.ndarray(shape=(22), dtype=np.float32, order='F')
latbest=np.ndarray(shape=(22), dtype=np.float32, order='F')

phycom=np.ndarray(shape=(22), dtype=np.float32, order='F')
whycom=np.ndarray(shape=(22), dtype=np.float32, order='F')
lonhycom=np.ndarray(shape=(22), dtype=np.float32, order='F')
lathycom=np.ndarray(shape=(22), dtype=np.float32, order='F')

perrhycomall=np.ndarray(shape=(22), dtype=np.float32, order='F')
werrhycomall=np.ndarray(shape=(22), dtype=np.float32, order='F')
derrhycomall=np.ndarray(shape=(22), dtype=np.float32, order='F')

perrhycomall=0
werrhycomall=0
derrhycomall=0

pmom6=np.ndarray(shape=(22), dtype=np.float32, order='F')
wmom6=np.ndarray(shape=(22), dtype=np.float32, order='F')
lonmom6=np.ndarray(shape=(22), dtype=np.float32, order='F')
latmom6=np.ndarray(shape=(22), dtype=np.float32, order='F')

perrmom6all=np.ndarray(shape=(22), dtype=np.float32, order='F')
werrmom6all=np.ndarray(shape=(22), dtype=np.float32, order='F')
derrmom6all=np.ndarray(shape=(22), dtype=np.float32, order='F')

perrmom6all=0
werrmom6all=0
derrmom6all=0

x=[4,9]
y=np.sqrt(x)
print(y)

mainpath='/work/noaa/ng-godas/yli/plot112/tc_ncl/Zeta/'

start_date = datetime.datetime(2020, 10, 24, hour=12)
end_date   = datetime.datetime(2020, 10, 24, hour=18)
delta=datetime.timedelta(hours=6)

m=0
loop_date=start_date
while loop_date <= end_date:

 # BEST
 best_date=loop_date
 besttrack=glob.glob(mainpath+'statistics/bal282020.dat')
 lines = open(besttrack[0], "r")
 print(loop_date)

 n=0
 hr=0
 while hr <= 126:
   ymdh=datetime.datetime.strptime(str(best_date),"%Y-%m-%d %H:%M:%S").strftime("%Y%m%d%H")
   for line in lines:
      newline = line.split(",")
      ss = str(np.squeeze(newline[2])).strip()
      if ( ss == ymdh ):
         
         pbest[n]=float(line.split(",")[9])
         wbest[n]=float(line.split(",")[8])
         lonbest[n]=-0.1*float(line.split(",")[7][0:-1])
         latbest[n]=0.1*float(line.split(",")[6][0:-1])
         break
   n=n+1
   hr +=6
   best_date += delta

 print(pbest)
 print(wbest)
 print(lonbest)
 print(latbest)

 # MOM6
 init=datetime.datetime.strptime(str(loop_date),"%Y-%m-%d %H:%M:%S").strftime("%Y%m%d%H")
 mom6track=glob.glob(mainpath+init+'/mom6.track')
 lines = open(mom6track[0], "r")
 print(mom6track)

 n=0
 hr=0
 while hr <= 126:
   hhh = str(hr).zfill(3)
   for line in lines:
      newline = line.split(",")
      ss = str(np.squeeze(newline[5])).strip()
      if ( ss == hhh ):
         
         pmom6[n]=float(line.split(",")[9])
         wmom6[n]=float(line.split(",")[8])
         lonmom6[n]=-0.1*float(line.split(",")[7][0:-1])
         latmom6[n]=0.1*float(line.split(",")[6][0:-1])
         break
   n=n+1
   hr +=6

 print(pmom6)
 print(wmom6)
 print(lonmom6)
 print(latmom6)

 # HYCOM
 hycomtrack=glob.glob(mainpath+init+'/hycom.track')
 lines = open(hycomtrack[0], "r")
 print(hycomtrack)

 n=0
 hr=0
 while hr <= 126:
   hhh = str(hr).zfill(3)
   for line in lines:
      newline = line.split(",")
      ss = str(np.squeeze(newline[5])).strip()
      if ( ss == hhh ):
         
         phycom[n]=float(line.split(",")[9])
         whycom[n]=float(line.split(",")[8])
         lonhycom[n]=-0.1*float(line.split(",")[7][0:-1])
         lathycom[n]=0.1*float(line.split(",")[6][0:-1])
         break
   n=n+1
   hr +=6

 print(phycom)
 print(whycom)
 print(lonhycom)
 print(lathycom)

 print('MOM6 SQUARE ERR')
 perrmom6=np.square(pmom6-pbest)
 werrmom6=np.square(wmom6-wbest)
 derrmom6=np.square(lonmom6-lonbest)+np.square(latmom6-latbest)

 perrmom6all=perrmom6all+perrmom6
 werrmom6all=werrmom6all+werrmom6
 derrmom6all=derrmom6all+derrmom6

 print('HYCOM SQUARE ERR')
 perrhycom=np.square(phycom-pbest)
 werrhycom=np.square(whycom-wbest)
 derrhycom=np.square(lonhycom-lonbest)+np.square(lathycom-latbest)

 perrhycomall=perrhycomall+perrhycom
 werrhycomall=werrhycomall+werrhycom
 derrhycomall=derrhycomall+derrhycom

 m=m+1
 loop_date += delta

print('MOM6 Final')
perrmom6all=np.sqrt(perrmom6all/m)
derrmom6all=np.sqrt(derrmom6all/m)
werrmom6all=np.sqrt(werrmom6all/m)

print(perrmom6all)
print(werrmom6all)
print(derrmom6all)

print('HYCOM Final')
perrhycomall=np.sqrt(perrhycomall/m)
derrhycomall=np.sqrt(derrhycomall/m)
werrhycomall=np.sqrt(werrhycomall/m)

print(perrhycomall)
print(werrhycomall)
print(derrhycomall)

hr=range(0,132,6)

fig, (ax1) = plt.subplots(1)
fig.suptitle("Hurricane Zeta (2020) Forecast Pmin Error")
ax1.plot(hr,perrmom6all,color='red',linestyle='solid',label='MOM6 SST')
ax1.plot(hr,perrhycomall,color='green',linestyle='solid',label='HYCOM SST')
ax1.legend(loc='best')
ax1.set(xlabel='Forecast hours')
ax1.set(Ylabel='Pmin Error(hPa)')
fig.savefig('Zeta_Pmin_Error.png', dpi = 300)
plt.close()

fig, (ax1) = plt.subplots(1)
fig.suptitle("Hurricane Zeta (2020) Forecast Max 10m Wind Error")
ax1.plot(hr,werrmom6all,color='red',linestyle='solid',label='MOM6 SST')
ax1.plot(hr,werrhycomall,color='green',linestyle='solid',label='HYCOM SST')
ax1.legend(loc='best')
ax1.set(xlabel='Forecast hours')
ax1.set(Ylabel='Max 10m Wind Error(kt)')
fig.savefig('Zeta_Vmax_Error.png', dpi = 300)
plt.close()

fig, (ax1) = plt.subplots(1)
fig.suptitle("Hurricane Zeta (2020) Forecast Track Error")
ax1.plot(hr,derrmom6all,color='red',linestyle='solid',label='MOM6 SST')
ax1.plot(hr,derrhycomall,color='green',linestyle='solid',label='HYCOM SST')
ax1.legend(loc='best')
ax1.set(xlabel='Forecast hours')
ax1.set(Ylabel='Track Error(degree)')
fig.savefig('Zeta_Track_Error.png', dpi = 300)
plt.close()

sys.exit()

