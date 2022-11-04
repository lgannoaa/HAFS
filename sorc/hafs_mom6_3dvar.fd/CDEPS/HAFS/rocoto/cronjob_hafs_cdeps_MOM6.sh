#!/bin/sh
set -x
date

# NOAA WCOSS Dell Phase3
#HOMEhafs=/gpfs/dell2/emc/modeling/noscrub/${USER}/save/HAFS
#dev="-s sites/wcoss_dell_p3.ent -f"
#PYTHON3=/usrx/local/prod/packages/python/3.6.3/bin/python3

# NOAA WCOSS Cray
#HOMEhafs=/gpfs/hps3/emc/hwrf/noscrub/${USER}/save/HAFS
#dev="-s sites/wcoss_cray.ent -f"
#PYTHON3=/opt/intel/intelpython3/bin/python3

# NOAA RDHPCS Jet
#HOMEhafs=/mnt/lfs4/HFIP/hwrfv3/${USER}/HAFS
#dev="-s sites/xjet.ent -f"
#PYTHON3=/apps/intel/intelpython3/bin/python3

# MSU Orion
 HOMEhafs=/work/noaa/hwrf/save/yongzuo/HAFS
 dev="-s sites/orion.ent -f"
 PYTHON3=/apps/intel-2020/intel-2020/intelpython3/bin/python3

#NOAA RDHPCS Hera
#HOMEhafs=/scratch1/NCEPDEV/hwrf/save/${USER}/HAFS
#dev="-s sites/hera.ent -f"
#PYTHON3=/apps/intel/intelpython3/bin/python3

cd ${HOMEhafs}/rocoto

EXPT=$(basename ${HOMEhafs})

#===============================================================================
# Here are some simple examples, more examples can be seen in cronjob_hafs_rt.sh

# Run data atmosphere with ERA5
#${PYTHON3} ./run_hafs.py -t ${dev} 2019082900 00L HISTORY config.EXPT=${EXPT} \
#    config.SUBEXPT=${EXPT}_era5 \
#    forecast.output_history=.true. \
#    ../parm/hafs_regional_static.conf ../parm/hafs_hycom.conf \
#    ../parm/hafs_datm.conf ../parm/hafs_datm_era5.conf

#    ../parm/hafsv0p3_regional_storm.conf \
#    ../parm/hafs_regional_static.conf \
#    dir.DOCNdir=/work/noaa/hwrf/noscrub/yongzuo/DOCN \

# Run data ocean with OISST
${PYTHON3} ./run_hafs.py -t ${dev} 2022092412 00L HISTORY config.EXPT=${EXPT} \
       config.SUBEXPT=${EXPT}_mom6_2022092412 \
    forecast.output_history=.true. \
    config.run_emcgraphics=yes \
    config.scrub_work=no \
    config.scrub_com=no \
    ../parm/hafs_regional_static.conf \
    ../parm/hafs_docn.conf ../parm/hafs_docn_oisst.conf \
    dir.DOCNdir=/work/noaa/hwrf/save/yongzuo/prep/2022092412 \
    forecast.mesh_ocn_in=/work/noaa/hwrf/noscrub/yongzuo/DOCN/hat10_210129_ESMFmesh_py.nc

# Run data ocean with GHRSST
#${PYTHON3} ./run_hafs.py -t ${dev} 2019082900 00L HISTORY config.EXPT=${EXPT} \
#    config.SUBEXPT=${EXPT}_ghrsst \
#    forecast.output_history=.true. \
#    ../parm/hafs_regional_static.conf \
#    ../parm/hafs_docn.conf ../parm/hafs_docn_ghrsst.conf

#===============================================================================

date

echo 'cronjob done'
