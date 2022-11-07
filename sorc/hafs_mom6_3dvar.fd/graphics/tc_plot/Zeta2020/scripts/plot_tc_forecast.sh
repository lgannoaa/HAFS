#!/bin/bash

module load ncl

yyyymmddhh=2020101712
tcname=Epislon

cp ../scripts/Hurricane_track.ncl.tmp Hurricane_track.ncl
cp ../scripts/Hurricane_Vmax_time.py.tmp Hurricane_Vmax_time.py
cp ../scripts/Hurricane_Pmin_time.py.tmp Hurricane_Pmin_time.py

sed -i "s;YYYYMMDDHH;${yyyymmddhh};g" Hurricane_track.ncl
sed -i "s;TCNAME;${tcname};g" Hurricane_track.ncl

sed -i "s;YYYYMMDDHH;${yyyymmddhh};g" Hurricane_Vmax_time.py
sed -i "s;TCNAME;${tcname};g" Hurricane_Vmax_time.py

sed -i "s;YYYYMMDDHH;${yyyymmddhh};g" Hurricane_Pmin_time.py
sed -i "s;TCNAME;${tcname};g" Hurricane_Pmin_time.py

ncl Hurricane_track.ncl
python3 Hurricane_Vmax_time.py
python3 Hurricane_Pmin_time.py

