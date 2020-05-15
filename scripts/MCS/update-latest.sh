#! /bin/bash

aws s3 ls potatoebot/minecraft/backups/ > /tmp/backup_list

cat /tmp/backup_list | grep 'latest.zip'
if [ $? -ne 0 ]
then
  tag=$(date +%s)
  zip -r $tag /home/ec2-user/minecraft
  aws s3 cp $tag.zip s3://potatoebot/minecraft/backups/
  rm $tag.zip
  rm /tmp/backup_list
  exit 0
fi

cat /tmp/backup_list | grep 'latest_1.zip'
if [ $? -ne 0 ]
then
  tag=$(date +%s)
  zip -r $tag /home/ec2-user/minecraft
  aws s3 cp $tag.zip s3://potatoebot/minecraft/backups/
  rm $tag.zip
  rm /tmp/backup_list
  exit 0
fi

cat /tmp/backup_list | grep 'latest_2.zip'
if [ $? -ne 0 ]
then
  tag=$(date +%s)
  zip -r $tag /home/ec2-user/minecraft
  aws s3 cp $tag.zip s3://potatoebot/minecraft/backups/
  rm $tag.zip
  rm /tmp/backup_list
  exit 0
fi

zip -r latest /home/ec2-user/minecraft
aws s3 mv s3://potatoebot/minecraft/backups/latest_2.zip s3://potatoebot/minecraft/backups/latest_3.zip
aws s3 mv s3://potatoebot/minecraft/backups/latest_1.zip s3://potatoebot/minecraft/backups/latest_2.zip
aws s3 mv s3://potatoebot/minecraft/backups/latest.zip s3://potatoebot/minecraft/backups/latest_1.zip
aws s3 cp latest.zip s3://potatoebot/minecraft/backups/latest.zip
rm latest.zip
rm /tmp/backup_list