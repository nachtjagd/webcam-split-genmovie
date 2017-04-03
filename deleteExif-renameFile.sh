PREFIX=/home/USERNAME/public_html/ImageDirwORIG
OUTPUTDIR=/home/USERNAME/public_html/ImageDirw/1024
ALBUMDIR=/home/USERNAME/public_html/ImageDirw/photo-album
JHEAD=/usr/bin/jhead
CONVERT=/usr/bin/convert
PHOTON=/home/USERNAME/public_html/Photon-0.4.6/photon

mkdir -p ${OUTPUTDIR}
mkdir -p ${ALBUMDIR}


Count=1000


echo "Converting file Resize 20%"
echo "Inputdir = ${PREFIX}
echo "Outputdir = ${OUTPUTDIR}
echo "Delete Exif"
echo "10 Second a go Starting"

for C in `seq 1 10`
do
	echo $C
	usleep 1000000
done


for i in `ls -1 ${PREFIX} |  egrep ".jpg|.JPG"`
do
	#echo "${JHEAD} ${PREFIX}/${i} | grep Date/Time | cut -d':' -f 2-| column -t"
	DATETIME=`${JHEAD} ${PREFIX}/${i} | grep Date/Time | cut -d':' -f 2-| column -t`
	xYear=`echo $DATETIME|cut -d':' -f 1|sed -e s/'"'//g`
	xMonth=`echo $DATETIME|cut -d':' -f 2|sed -e s/'"'//g`
	xDate=`echo $DATETIME|cut -d':' -f 3|sed -e s/'"'//g|awk '{print $1}'`
	xHour=`echo $DATETIME|cut -d':' -f 3|sed -e s/'"'//g|awk '{print $2}'`
	xMinits=`echo $DATETIME|cut -d':' -f 4`
	xSeconds=`echo $DATETIME|cut -d':' -f 5|sed -e s/'"'//g`
	#echo ${xYear}-${xMonth}-${xDate}_${xHour}-${xMinits}-${xSeconds}-${Count}
	NEWFILENAME=${xYear}-${xMonth}-${xDate}_${xHour}-${xMinits}-${xSeconds}-${Count}
	${CONVERT} -resize 20% ${PREFIX}/${i} ${OUTPUTDIR}/${NEWFILENAME}.jpg
	${JHEAD} -purejpg ${OUTPUTDIR}/${NEWFILENAME}.jpg

          PICSTATUS=`jhead ${OUTPUTDIR}/${NEWFILENAME}.jpg|grep :`
          FN=`echo "$PICSTATUS" |grep "File name"`
          FS=`echo "$PICSTATUS" |grep "File size"`
          FD=`echo "$PICSTATUS" |grep "File date"`
          RS=`echo "$PICSTATUS" |grep "Resolution"`
          echo $FN, $FS, $FD, $RS

	Count=`echo ${Count} + 1|bc`
done

${PHOTON} -s 0  -l 300 -o ${ALBUMDIR}  ${OUTPUTDIR}/

