VERSION="0.2"

getEpisodeName(){

  for dir in */; do
    if [ -d "$dir" ]; then
      echo $dir
      cd "$dir"
      if [ ! -d "./output" ]; then
        mkdir output
      fi

      for file in *; do
        if [[ "$file" == *".mkv" ]]; then
	  checkDuplicate "$file"
	fi
      done
      cd ..
    fi
  done
}

checkDuplicate(){
  found=false

  cd output
  if [ ! -d "./complete" ]; then
    mkdir complete
  fi

# cd complete

  for subfile in *; do

    if [ $1 == $subfile ]; then
#     echo "Checking $1 with $subfile"
      echo "FOUND A DUPLICATE"
      found=true
    fi
  done
# cd ..
  cd ..
  if [ $found == false ]; then
    echo "Did the found"
#   touch ../output/$1
    ffmpeg -y -i "$1" -map 0 -c:v libx264 -crf 18 -vf format=yuv420p -c:s copy "./output/$1" #\;
    touch "output/complete/$1"
#   touch $1
#   touch "./output/$file"
  else
    echo "Skipping $1"
  fi

# cd ..
}

clearOutput(){
  for dir in */; do
    if [ -d "$dir" ]; then
      echo $dir
      cd "$dir"
        if [ -d "$dir/output" ]; then
	  sudo rmdir -r $dir/output
	fi
    fi
  done
}

if [ "$1" == "clear" ]; then
  clearOutput
elif [ "$1" == "help" ]; then
  echo Season converter V$VERSION
  echo "Avaliable commands:"
  echo "  clear: clear all outputs in subfolders"
  echo ""
  echo This must be ran in the same folder as the "Season XX" folders.
else
  touch "Started conversion $(date)"
  getEpisodeName
  touch "Completed conversion $(date)"
fi
