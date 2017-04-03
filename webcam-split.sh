#!/bin/sh

#PREFIXDIR=/home/USERNAME/public_html/webcam
PREFIXDIR=/home/USERNAME/public_html/ipcamera


for YYYYMMDD in `ls -1 ${PREFIXDIR} |sed -e s/.......\.jpg//g|sort|uniq|sort|egrep '[0-9]{8}'`
 do 
    YYYY=`echo ${YYYYMMDD}|cut -c 1-4`
    MM=`echo ${YYYYMMDD}|cut -c 5-6`
    DD=`echo ${YYYYMMDD}|cut -c 7-8`

    mkdir -p ${PREFIXDIR}/${YYYY}/${MM}/${DD}
    mv  ${PREFIXDIR}/${YYYYMMDD}*.jpg ${PREFIXDIR}/${YYYY}/${MM}/${DD}
done


