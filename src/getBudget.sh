#!/bin/bash
# basepath="s3://budget-planner-files-prod/"

if [ -z "$1" ];
then
  echo "Please enter a valid environment"
  exit 1
fi
if [ -z "$2" ]
then
  echo "Please enter a valid file type"
  exit 1
fi
if [ -z "$3" ]
then
  echo "Please enter a client name"
  exit 1
fi

base_path=""
if [[ $1 == *"dev"* ]];
then
  base_path="s3://budget-planner-files-dev/"
fi
if [[ $1 == *"test"* ]]
then
  base_path="s3://budget-planner-files-test/"
fi
if [[ $1 == *"prod"* ]]
then
  base_path="s3://budget-planner-files-prod/"
fi

echo "here is your basepath 1" $base_path

if [[ $2 == *"arch"* ]]; then
  base_path2=$base_path"archive-file/"
fi
if [[ $2 == *"temp"* ]]; then
  base_path2=$base_path"temp-file/"
fi
if [[ $2 == *"client"* ]]; then
  base_path2=$base_path"clients-file/"
fi



echo "here is your base_path2" $base_path2

if [[ $4 == *"open"* ]]; then
  echo "Opening latest budget plan"
  folder_path=$base_path2$3"/"
  echo "searching files in "$folder_path
  file=$(aws s3 ls $folder_path --recursive | sort | tail -n 1 | awk '{printf "%s\\ %s",$4,$5}')
  file_path=$base_path$file
  echo "latest file path in the folder "$file_path
  echo "syncing whole folder to bo/pd"
  mkdir -p ~/Documents/BO_PD/$3/
  aws s3 sync $folder_path ~/Documents/BO_PD/$3/
fi
