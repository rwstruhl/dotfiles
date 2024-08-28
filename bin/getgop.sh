#!/bin/sh

startswith() { case $1 in $2*) true;; *) false;; esac; }

tmpfile=$(mktemp)
ffprobe -show_frames "$1" 2> /dev/null > "$tmpfile"

GOP=1
maxGOP=1
Bframes=0
M=0
maxM=0
is_video=false
is_started=false
struct=""

while read p; do
  if startswith "$p" "media_type="; then
    if startswith "$p" "media_type=video"; then
      is_video=true
    else
      is_video=false
    fi
  fi
  if $is_video; then
    if startswith "$p" "key_frame=0"; then
      GOP=$(( GOP + 1 ))
    elif startswith "$p" "key_frame=1"; then
      is_max_thus_far=
      if [ $GOP -gt $maxGOP ]; then
        maxGOP=$GOP
        is_max_thus_far="*"
      fi
      if $is_started; then
        printf "GOP: M=$maxM, N=$GOP $is_max_thus_far\n"
        printf "  $struct\n"
      else
        is_started=true
      fi
      GOP=1
      Bframes=0
      maxM=0
      struct=""
    elif startswith "$p" "pict_type=I"; then
      struct="${struct}I"
    elif startswith "$p" "pict_type=P"; then
      if [ $Bframes -gt $maxM ]; then
        maxM=$(( Bframes + 1 ))
      fi
      Bframes=0
      struct="${struct}P"
    elif startswith "$p" "pict_type=B"; then
      Bframes=$(( Bframes + 1 ))
      struct="${struct}B"
    fi
  fi
done < "$tmpfile"
rm "$tmpfile"
echo Max. GOP = $maxGOP

