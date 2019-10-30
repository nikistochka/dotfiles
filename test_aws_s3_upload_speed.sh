#! /bin/bash
#
# Script for testing upload speed to AWS s3

set -e

AWS_PROFILE=my_profile
BUCKETNAME=test-bucket
REGION=eu-west-1
PREFIX=folder/folder
FILENAME=temp_speed_file

truncate -s 500M $FILENAME

i=1
while [ $i -gt 0 ]
do
    FILESIZE="$(wc -c <"$FILENAME")"
    STARTTIME=$(date +"%s.%N")
    STARTTIME_us=$(expr $STARTTIME*$((1000000)) | bc -l)
    # Copy file to s3
    aws s3 cp $FILENAME s3://$BUCKETNAME/$PREFIX/$FILENAME --region $REGION --profile $AWS_PROFILE
    ENDTIME=$(date +"%s.%N")
    ENDTIME_us=$(expr $ENDTIME*$((1000000)) | bc -l)
    Time_elapsed=$(expr $ENDTIME_us-$STARTTIME_us | bc -l)
    Throughput=$(expr $(($FILESIZE*8))/$Time_elapsed | bc -l)
    Throughput_in_Mbps=$(expr $Throughput/$((1024*1024)) | bc -l)
    echo "File uploaded at $(expr $Throughput_in_Mbps*$((1000000)) | bc -l) Mbps speed."
    # Delete file from s3
    aws s3 rm s3://$BUCKETNAME/$PREFIX/$FILENAME --region $REGION --profile $AWS_PROFILE
done

rm $FILENAME
