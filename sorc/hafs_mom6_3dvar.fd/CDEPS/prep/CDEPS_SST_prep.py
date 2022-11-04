import netCDF4
from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter
from netCDF4 import Dataset    # Note: python is case-sensitive!
import numpy as np
from datetime import date
import datetime
import glob
import sys
from netCDF4 import date2num,num2date

from warnings import filterwarnings
filterwarnings(action='ignore', category=DeprecationWarning, message='`np.bool` is a deprecated alias')

description = "replace time & SST in hycom_201908_surf_nolev.nc"
parser = ArgumentParser(
   description=description,
   formatter_class=ArgumentDefaultsHelpFormatter)
parser.add_argument(
   '-t',
   '--ymdh',
   help="time string YYYYMMDDHH",
   type=str, required=True)

args = parser.parse_args()

# HYCOM time is days from 12/31/1900. Here SST is 6 hourly, 0.25 days.
# HAFS forecast is 126 hrs, 5.25 days. One extra time is required by HAFS,
# 132 hrs, 5.5 days. Time dimension is 23.
 
#init='2020050406'
init=args.ymdh
yyyy=int(init[0:4])
mm=int(init[4:6])
dd=int(init[6:8])
hh=int(init[8:10])

day0=datetime.datetime(1900,12,31,hour=0)
day1=datetime.datetime(yyyy,mm,dd,hour=hh)
daydelta=day1-day0
daystart=daydelta.days+daydelta.seconds/86400
day575=daystart+5.75  # 0.25*23 above comments
day5p5=np.arange(daystart,day575,0.25)

daydate=np.arange(0.0,23.0,1.0) # form array
loop_date=day1
delta=datetime.timedelta(hours=6)
hr=0
while hr <= 132:
   ymdh=datetime.datetime.strptime(str(loop_date),"%Y-%m-%d %H:%M:%S").strftime("%Y%m%d%H")
   daydate[int(hr/6)]=float(ymdh[0:8])+float(ymdh[8:10])/24.
   hr +=6
   loop_date += delta

# input HYCOM, replace time
hycomdset = netCDF4.Dataset('./hycom_201908_surf_nolev.nc','r+')
hycomdset.variables['time'][:] = day5p5[:]
hycomdset.variables['Date'][:] = daydate[:]
ssthyc = hycomdset.variables['temp']
print('hycom sst',np.shape(ssthyc))

# input MOM6 analysis (use 1st of 50 Layers)
mom6dset = Dataset('ocn_3d.nc')
sst3d = np.squeeze(mom6dset.variables['Temp'][:,:,:,:])
print('MOM6 ana Temp',np.shape(sst3d))
print('MOM6 ana Layer',mom6dset.variables['Layer'][:][0:1])

# input MOM6 132 hrs 2D SST (6-h interval, 22 times)
mom6sst2d = Dataset('ocn_2d.nc')
sst2d = np.squeeze(mom6sst2d.variables['sst'][:,:,:])
print('MOM6 2d sst',np.shape(sst2d))

hy2d=np.squeeze(ssthyc[0:1,:,:])
ta2d=np.squeeze(sst3d[0:1,:,:])
tf2d=np.squeeze(sst2d[0:1,:,:])
print('hy2d ',np.shape(hy2d))
print('ta2d ',np.shape(ta2d))
print('tf2d ',np.shape(tf2d))

for i in range(633):
   for j in range(1135):
      if ta2d[i,j]>5.0 and ta2d[i,j]<40.0 and hy2d[i,j]>5.0 and hy2d[i,j]<40.0 :
         hycomdset.variables['temp'][0:1,i,j] = sst3d[0:1,i,j]

      if tf2d[i,j]>5.0 and tf2d[i,j]<40.0 and hy2d[i,j]>5.0 and hy2d[i,j]<40.0 :
         hycomdset.variables['temp'][1:22,i,j] = sst2d[0:21,i,j]

#hycomdset.variables['temp'][0:1,:,:] = sst3d[0:1,:,:]
mom6dset.close()
#hycomdset.variables['temp'][1:23,:,:] = sst2d[0:22,:,:]
mom6sst2d.close()
hycomdset.close()
sys.exit()

