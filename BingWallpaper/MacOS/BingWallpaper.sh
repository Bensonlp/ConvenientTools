#!/bin/sh
localDir="/Users/$USER/Pictures/BingWallpaper"
filenameRegex=".*"$(date "+%Y-%m-%d")".*jpg"
log="$localDir/bin/log.log"

findResult=$(find $localDir -regex $filenameRegex)
if [ ! -n "$findResult" ]; then
    baseUrl="cn.bing.com"
    imgurl=$(expr "$(curl -L $baseUrl | grep hprichbg)" : '.*hprichbg\(.*\)",id.*')
    filename=$(expr "$imgurl" : '.*/\(.*\)')
    localpath="$localDir/$(date "+%Y-%m-%d")-$filename"
    curl -o $localpath $baseUrl/az/hprichbg/$imgurl
#    curl -o $localpath $baseUrl/az/hprichbg/rb/MineralCliffs_ZH-CN11986913181_1920x1080.jpg
    echo "$imgurl"
    osascript -e "                              \
        tell application \"System Events\" to   \
            tell every desktop to               \
                set picture to \"$localpath\""
    osascript -e "display notification \"$filename Downloaded\" with title \"BingWallpaper\""
    echo "$(date +"%Y-%m-%d %H:%M:%S") Downloaded $filename"
    #echo "$(date +"%Y-%m-%d %H:%M:%S") Downloaded $filename" >> $log
else
    #echo "$(date +"%Y-%m-%d %H:%M:%S") Exist" >> $log
    echo "$(date +"%Y-%m-%d %H:%M:%S") Exist"
    exit 0
fi
