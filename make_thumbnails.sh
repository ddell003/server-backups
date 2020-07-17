#!/bin/bash

# must be run in the directory with all of the images

sudo mogrify -verbose -path thumb256 -resize 256x256 -quality 60 -format jpg '*.jpg' '*.JPG' '*.jpeg' '*.JPEG' '*.png' '*.PNG' '*.gif' '*.GIF'
&& mogrify -verbose -resize 1500x1500 -quality 60 -format jpg '*.jpg' '*.JPG' '*.jpeg' '*.JPEG' '*.png' '*.PNG' '*.gif' '*.GIF'

