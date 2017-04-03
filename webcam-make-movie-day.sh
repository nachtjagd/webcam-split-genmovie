#!/bin/sh


###################################################################################################################################
# 下記のような YYYY/MM/DD というディレクトリの中に YYYYmmdd-HHMMSS.jpg というパターンのファイルが格納される構造のとき
# /var/tmp/${WORKDIR}/ に  image0nnnn.jpgという連番のsymlinkを作成し ffmpegの -iオプションでファイルを渡して動画(mp4)を作成する
# 
#  $ pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'
#  /home/USERNAME/public_html/webcam
#  |--2014
#  |  |--12
#  |  |  |--17
#  |  |  |  |--20141217-003751.jpg
#  |  |  |  |--20141217-013001.jpg
#  |  |  |  |--20141217-023001.jpg
#  |  |  |  |--20141217-033001.jpg
#  |  |  |  |--20141217-043001.jpg
#  |  |  |  |--20141217-060001.jpg
#  |  |  |  |--20141217-070001.jpg
#  |  |  |  |--20141217-080002.jpg
#  |  |  |  |--20141217-090001.jpg
#  |  |  |  |--20141217-100001.jpg
#  |  |  |  |--20141217-110001.jpg
#  |  |  |  |--20141217-120753.jpg
#  |  |  |  |--20141217-123001.jpg
#  |  |  |  |--20141217-130001.jpg
#  |  |  |  |--20141217-133001.jpg
#  |  |  |  |--20141217-140001.jpg
#  |  |  |  |--20141217-143001.jpg
#  |  |  |  |--20141217-150001.jpg
#  |  |  |  |--20141217-153001.jpg
#  |  |  |  |--20141217-160001.jpg
#  |  |  |  |--20141217-163001.jpg
#  |  |  |  |--20141217-170001.jpg
#  |  |  |  |--20141217-173001.jpg
#  |  |  |  |--20141217-180001.jpg
#  |  |  |  |--20141217-183001.jpg
#  |  |  |  |--20141217-190001.jpg
#  |  |  |  |--20141217-193001.jpg
#  |  |  |  |--20141217-200001.jpg
#  |  |  |  |--20141217-203001.jpg
#  |  |  |  |--20141217-210001.jpg
#  |  |  |  |--20141217-213001.jpg
#  |  |  |  |--20141217-220001.jpg
#  |  |  |  |--20141217-223001.jpg
#  |  |  |  |--20141217-230002.jpg
#  |  |  |  |--20141217-233002.jpg
#  |  |  |--18
#  |  |  |  |--20141218-000001.jpg
#  |  |  |  |--20141218-003002.jpg
# (以下省略)
###################################################################################################################################






TARGET=$1
if [ -z "$1" ];then
  echo "Usage: $0 (YYYYMMDD) "
  exit 1
fi

# 引数を分割
TARGET_YEAR=`echo ${TARGET}|cut -c 1-4`
TARGET_MONTH=`echo ${TARGET}|cut -c 5-6`
TARGET_DAY=`echo ${TARGET}|cut -c 7-8`


#WORKING DIR SET
WORKDIR=`date +%Y%m%d`
mkdir -p /var/tmp/${WORKDIR}


# 連結するファイル数を取得して FILESに代入
FILES=`find /home/USERNAME/public_html/webcam/${TARGET_YEAR}/${TARGET_MONTH} -type f |grep ${TARGET}|sort|wc -l`
echo FILES=$FILES

#ファイル数が何桁か取得して FILEKETAに代入
FILEKETA=${#FILES}
echo FILEKETA=${FILEKETA}


# 変換するファイル名で連番のsymlinkを作成
z=1
for i in `find /home/USERNAME/public_html/webcam/${TARGET_YEAR}/${TARGET_MONTH} -type f |grep ${TARGET}|sort`
do
    printf "ln -s $i /var/tmp/${WORKDIR}/image0%0${FILEKETA}d\n" ${z} >> /var/tmp/${WORKDIR}/batch.txt
    z=`echo $z+1|bc`
done


#バッチファイルの加工
sed -i -e  s/$/.jpg/g /var/tmp/${WORKDIR}/batch.txt
sh /var/tmp/${WORKDIR}/batch.txt


# FFMPEGオプション設定
export LD_LIBRARY_PATH=/usr/local/lib/

FFMPEG=/usr/local/bin/ffmpeg
FFMPEGOPT01="-f image2 -r 4"
FFMPEGOPT02="-i /var/tmp/${WORKDIR}/image0%0${FILEKETA}d.jpg" 
FFMPEGOPT03="-r 4 -an -vcodec libx264"
FFMPEGOPT04="-pix_fmt yuv420p -g 150 -qcomp 0.7 -qmin 10 -qmax 51 -qdiff 4 -subq 6 -me_range 16 -i_qfactor 0.714286"
FFMPEGOUTFILE="/home/USERNAME/public_html/webcam/video_${TARGET}.mp4"

#エンコードする
echo "time ${FFMPEG}  ${FFMPEGOPT01} ${FFMPEGOPT02} ${FFMPEGOPT03} ${FFMPEGOPT04} ${FFMPEGOUTFILE}"
time ${FFMPEG}  ${FFMPEGOPT01} ${FFMPEGOPT02} ${FFMPEGOPT03} ${FFMPEGOPT04} ${FFMPEGOUTFILE}


#バッチファイル削除
rm -rf /var/tmp/${WORKDIR}/batch.txt

#symlink削除
rm -rf /var/tmp/${WORKDIR}/image*.jpg

#WORKING DIR削除
rm -rf /var/tmp/${WORKDIR}/


