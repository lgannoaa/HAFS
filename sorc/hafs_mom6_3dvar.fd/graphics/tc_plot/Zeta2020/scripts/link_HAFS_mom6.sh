#!/bin/bash

YMDH=2020082200

mkdir ${YMDH}
cd ${YMDH}
ln -s ../h3bs/13l.${YMDH}.hafs.grid01.trak.atcfunix hycom.track
cp ../bal132020.dat best.track

mkdir tmp
cd tmp
ln -s /work/noaa/hwrf/scrub/yongzuo/HAFS_mom6_${YMDH}/${YMDH}/00L/emc_graphics/laura13l.${YMDH}.trak.hafs.atcfunix .
cp laura13l.${YMDH}.trak.hafs.atcfunix laura13l.${YMDH}.trak.hafs.atcfunix-ok

cd ..
ln -s tmp/laura13l.${YMDH}.trak.hafs.atcfunix-ok mom6.track

