#!/bin/bash

socapath=/work/noaa/marine/yli/HAFS/sorc/hafs_mom6_3dvar.fd/soca-science/
dapath=/work/noaa/stmp/yli/Zeta2020_3dvar/2020102412
fcstroot=/work/noaa/stmp/yli/Zeta2020_fcst
gfsatm=/work/noaa/marine/yli/GFSatm_FORC/2020

    YMDH=2020102500
END_YMDH=2020102500
DH=6

tmp_YMDH=${YMDH:0:8}Z${YMDH:8:2}
date_YMDH=$(date -ud "$tmp_YMDH")
ymdh=$(date -ud "$date_YMDH + 66 hours" +%Y%m%d%H )

while [[ "${YMDH}" -le "${END_YMDH}" ]]; do

echo ${YMDH} ${ymdh}

cp exp.config.tmp exp.config.${YMDH}

sed -i "s;YYYY;${YMDH:0:4};g" exp.config.${YMDH}
sed -i "s;MM;${YMDH:4:2};g" exp.config.${YMDH}
sed -i "s;DD;${YMDH:6:2};g" exp.config.${YMDH}
sed -i "s;HH;${YMDH:8:2};g" exp.config.${YMDH}

sed -i "s;yyyy;${ymdh:0:4};g" exp.config.${YMDH}
sed -i "s;mm;${ymdh:4:2};g" exp.config.${YMDH}
sed -i "s;dd;${ymdh:6:2};g" exp.config.${YMDH}
sed -i "s;hh;${ymdh:8:2};g" exp.config.${YMDH}

fcstpath=${fcstroot}/${YMDH}

mkdir ${fcstpath}

ln -sf ${socapath}/scripts/workflow/cycle.sh ${fcstpath}/.
ln -sf ${dapath}/static ${fcstpath}/.
cp ${fcstroot}/exp.config.${YMDH} ${fcstpath}/exp.config

mkdir -p ${fcstpath}/rst/${YMDH}/ctrl
ln -sf ${dapath}/SCRATCH/${YMDH}/ana_rst/ctrl/* ${fcstpath}/rst/${YMDH}/ctrl/.

mkdir -p ${fcstpath}/FORC
ln -sf ${gfsatm}/${YMDH:0:8}/atm_${YMDH}.nc ${fcstpath}/FORC/atm.nc 

cd ${fcstpath}
####${fcstpath}/cycle.sh
cd -

YMDH=$(date -ud "$date_YMDH + $DH hours" +%Y%m%d%H )
DH66=$(($DH+66))
ymdh=$(date -ud "$date_YMDH + ${DH66} hours" +%Y%m%d%H )

DH=$(($DH+6))

done  # day loop

