#!/bin/sh

#This script try to download all youtube videos from any channel
#Recommend: put this script in empty folder before run!!!!
#Requirements: yt-dlp;jq;ffmpeg;tr
#Usage: yt-cdown.sh YOUTUBE_CHANNEL_URL
#Tested on ubuntulinux based systems

####VARIABLES####

#OUTPUT_FOLDER
FOLDER=output
mkdir ${FOLDER}
cd ${FOLDER}

#CHANNEL_URL
URL_CHANNEL="$1"

#TEMPORARY FILE
VIDEO_LIST_CSV=list.csv

#OUTPUT FORMAT like mp3,mp4,aac etc. See yt-dlp docummentation for details
OUTPUT_FORMAT=mp4

#Set your navigator for cookies. Useful for download restricted/member videos. EG:firefox,chrome etc
NAVIGATOR=firefox

#Generating video CSV URL
yt-dlp -j --flat-playlist ${URL_CHANNEL} | jq -r '[.url] | @csv' > ${VIDEO_LIST_CSV}

#Removing all quotes from CSV file
tr -d \" < ${VIDEO_LIST_CSV} > ${VIDEO_LIST_CSV}_tmp
rm ${VIDEO_LIST_CSV}
mv ${VIDEO_LIST_CSV}_tmp ${VIDEO_LIST_CSV}

#Downloading videos
yt-dlp --cookies-from-browser ${NAVIGATOR} -a ${VIDEO_LIST_CSV} -t ${OUTPUT_FORMAT} -o "%(upload_date>%Y-%m-%d)s_%(epoch-3600>%H-%M-%S)s_%(title)s"

#Removing temporary file list
rm ${VIDEO_LIST_CSV}


