#!/usr/bin/env bash

BASE_DIR=/home/igbt6/Desktop/Blog
BLOG_SOURCE_DIR=$(pwd)
OUTPUT_DIR=$BLOG_SOURCE_DIR/output
WEBSITE_DIR=$BASE_DIR/igbt6.github.io
CONFFILE=$BLOG_SOURCE_DIR/pelicanconf.py

echo $WEBSITE_DIR 

function usage(){
  echo "usage: $0 (start)/(git) $1 (commit msg) " 
  echo "starts/stops embedded in Pelican server"
  echo "sends all the changes to github repo"
}

function generate(){
  
  cd $BLOG_SOURCE_DIR
  rm -rf $OUTPUT_DIR
  echo $(pwd)
  source $BLOG_SOURCE_DIR/env/bin/activate
  pelican content
  echo "--------generated---------"
}

function remove_and_copy(){
  rm -rf $WEBSITE_DIR/*
  cp -r $OUTPUT_DIR/* $WEBSITE_DIR
  echo "$OUTPUT_DIR copied into $WEBSITE_DIR"
}

function fire_up_pelican_server(){
  cd $OUTPUT_DIR
  python -m pelican.server
  echo "--------pelican.server enabled---------" 
}


function commit_changes(){
  echo "--------$BLOG_SOURCE_DIR source update---------" 
  cd $BLOG_SOURCE_DIR
  git add --all
  if [$# -eq 1] 
  then
     git commit -m $1
  else
     git commit -m "blog source updated" 
  fi
  git push

  echo "--------$WEBSITE_DIR source update---------" 
  cd $WEBSITE_DIR
  git add --all
  if [$# -eq 1] 
  then
     git commit -m $1
  else
     git commit -m "blog content updated" 
  fi
  git push  
  echo "--------changes commited---------" 
}


###
#  MAIN
###
echo "--------start--------"
generate
remove_and_copy
if [[ $1 == "start" ]] 
then
  fire_up_pelican_server
elif [[ $1 -eq "git" ]] 
then
  (commit_changes $2)
fi 
echo "--------done---------"
