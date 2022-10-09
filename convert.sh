getEpisodeName(){
  for dir in */; do
    if [ -d "$dir" ]; then
      echo $dir
      cd "$dir"
      mkdir output

      for file in *; do
        if [[ "$file" == *".mkv" ]]; then
	  checkDuplicate $file
	fi
      done
      cd ..
    fi
  done
#	echo $1
}

checkDuplicate(){
  found=false

  cd output
  mkdir complete
  cd complete
  for subfile in *; do

    if [ $1 == $subfile ]; then
#     echo "Checking $1 with $subfile"
      echo "FOUND A DUPLICATE"
      found=true
    fi
  done
  cd ..
  if [ $found == false ]; then
    echo "Did the found"
#   touch ../output/$1
    ffmpeg -y -i "../$1" -map 0 -c:v libx264 -crf 18 -vf format=yuv420p -c:s copy ./$1 #\;
    touch complete/$1
#   touch $1
#   touch "./output/$file"
  else
    echo "Skipping $1"
  fi

  cd ..
}

clearOutput(){
	rm -r 'Futurama Season 1 S01 DVDRip x264'/output
	rm -r 'Futurama Season 2 S02 DVDRip x264'/output
	rm -r 'Futurama Season 3 S03 DVDRip x264'/output
	rm -r 'Futurama Season 4 S04 DVDRip x264'/output
	rm -r 'Futurama Season 5 S05 DVDRip x264'/output
	rm -r 'Futurama Season 5 S05 Part 2 Movies WEB-DL-BluRay x264-MIXED'/output
	rm -r 'Futurama Season 6 S06 1080p BluRay x264-CtrlHD'/output
	rm -r 'Futurama Season 7 S07 1080p BluRay x264-CtrlHD'/output

}

if [ $1 == "clear" ]; then
  clearOutput
else
  getEpisodeName
  touch "Completed conversion $(date)"
fi


