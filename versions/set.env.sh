#! /bin/sh

set -x
name=`basename $ECF_NAME`
EMCCANNED=/lfs/h2/emc/noscrub/CANNED_input_for_HAFS
#if [ $envir != "test" ]; then
#  echo "It is not test enviroment, $envir, skipping set env...."
#  exit 0
#fi
#if [[ $name = "jhafs_launch" && ${storm_num} = "1" ]]; then
#  echo "name=$name and torm_num={storm_num}, check and link the com data..."

#  if [[ $PDY != '' && $cyc != '' ]] ; then
#    ver=${gfs_ver}
#    for NET in gfs gdas enkfgdas; do 
#      ls -ltrd /lfs/h1/ops/test/com/gfs/${ver}/${NET}.$PDY
#    done
  
#    ver=${rtofs_ver}
#    NET=rtofs
#    ls -ltrd /lfs/h1/ops/test/com/${NET}/${ver}/${NET}.$PDY

#    NET=obsproc
#    ver=${obsproc_ver}
#    ls -ltrd /lfs/h1/ops/test/com/obsproc/${obsproc_ver}/gfs.$PDY
#    ls -ltrd /lfs/h1/ops/test/dcom/$PDY
#  else
#    echo "PDY=$PDY and cyc=$cyc is empty ..., skipping set env"
#  fi
#else
#  echo "name=$name and ${storm_num} != 1, skipping link the com data..."
#  sleep 10
#fi

COMIN_BASE=$(compath.py hafs/v2.0.0)
if [ $name = "jhafs_launch" ]; then
  if [ -s ${EMCCANNED}/com/hafs/v1.0/inp${RUN}/message${storm_num}_$PDY$cyc ] ;then
    rm -rf ${COMIN_BASE}/inp${RUN}/message${storm_num}
    ln -sf ${EMCCANNED}/com/hafs/v1.0/inp${RUN}/message${storm_num}_$PDY$cyc ${COMIN_BASE}/inp${RUN}/message${storm_num}
  else
    echo "${EMCCANNED}/com/hafs/v1.0/inp${RUN}/message${storm_num}_$PDY$cyc not existed, no link to ${COMIN_BASE}/inp${RUN}/message${storm_num}"
   if [[ ${storm_num} = "1" && `ls ${EMCCANNED}/com/hafs/v1.0/inp${RUN}/message*$PDY$cyc*|wc -l` = "1" ]]; then
     echo " found ${EMCCANNED}/com/hafs/v1.0/inp${RUN}/message*$PDY$cyc, linking to ${COMIN_BASE}/inp${RUN}/message${storm_num} .."
     rm -rf ${COMIN_BASE}/inp${RUN}/message${storm_num}
     ln -sf ${EMCCANNED}/com/hafs/v1.0/inp${RUN}/message*$PDY$cyc* ${COMIN_BASE}/inp${RUN}/message${storm_num}
   else
     echo " ${storm_num} != 1 or ${EMCCANNED}/com/hafs/v1.0/inp${RUN}/message*$PDY$cyc is more than 1, skipped "
   fi
  fi
fi

if [[ $PDY != '' && $cyc != '' && -s ${COMIN_BASE}/inp${RUN}/message${storm_num} ]] ; then
  STORM_NAME_ID=`cat ${COMIN_BASE}/inp${RUN}/message${storm_num} |awk '{print $3"_"$2}'`
  echo "STORM_NAME_ID=${STORM_NAME_ID}"
  export WORKhafs=${WORKhafs:-${DATAROOT:?}/${RUN:?}${storm_num:?}_${cyc:?}_${envir:?}_${hafs_ver:?}_${STORM_NAME_ID}_$PDY$cyc}
  echo "WORKhafs=$WORKhafs"
else
  echo "Not set WORKhafs since PDY=$PDY or cyc=$cyc or ${COMIN_BASE}/inp${RUN}/message${storm_num} ??"
fi
