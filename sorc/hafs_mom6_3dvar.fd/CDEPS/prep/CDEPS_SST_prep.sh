#!/bin/bash

# https://www.ncei.noaa.gov/erddap/convert/time.html?n=43830.5&units=days+since+1900-12-31

work=/work/noaa/hwrf/save/yongzuo/prep

    YMDH=2020102506
END_YMDH=2020102506

FCST_LEN=66 # MOM6 forecast 66 hrs 
CYCLE_DH=6

START_YMDH=${YMDH:0:8}Z${YMDH:8:2}
date_YMDH=$(date -ud "$START_YMDH")

while [[ "${YMDH}" -le "${END_YMDH}" ]]; do

if [[ ! -d ${main}/${YMDH} ]]; then
mkdir -p ${work}/${YMDH}
fi

cd ${work}/${YMDH}
rm *.nc

#mom6da=/work/noaa/stmp/yli/Laura_3dvar              # SST at 0h
#ln -sf ${mom6da}/ana/${YMDH:0:4}/${YMDH}/ctrl/ocn.ana.${YMDH}.nc ocn_3d.nc

#mom6fcst=/work/noaa/stmp/yli/Laura_fcst/${YMDH}     # SST 0-66 h
#mom6fcst=/work/noaa/stmp/yli/Ian2022_fcst/${YMDH}     # SST 0-66 h
mom6fcst=/work/noaa/stmp/yli/Zeta2020_fcst/${YMDH}     # SST 0-66 h

# (1) MOM6 T 3d 
ln -sf ${mom6fcst}/bkg/${YMDH:0:4}/${YMDH}/ctrl/ocn.bkg.${YMDH}.nc ocn_3d.nc

# (2) MOM6 T 2d part 1
ln -sf ${mom6fcst}/SCRATCH/${YMDH}/run.fcst/${YMDH:0:8}.ocean_hourly_2d.nc sst1.nc

# (3) MOM6 T 2d part 2
ymdh=$(date -ud "$date_YMDH + ${FCST_LEN} hours" +%Y%m%d%H ) # SST 72-132 h
ln -sf ${mom6fcst}/SCRATCH/${ymdh}/run.fcst/${ymdh:0:8}.ocean_hourly_2d.nc sst2.nc

ncrcat sst1.nc sst2.nc ocn_2d.nc

cp ../hycom_201908_surf_nolev.nc .
cp ../CDEPS_SST_prep.py .
python3 CDEPS_SST_prep.py -t ${YMDH}

exit

YMDH=$(date -ud "$date_YMDH + $CYCLE_DH hours" +%Y%m%d%H )

FCST_LEN=$(($FCST_LEN+6))
CYCLE_DH=$(($CYCLE_DH+6))

done

