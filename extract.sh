#!/bin/bash

if [ ! -f "0/0/0.jpg" ]; then
  for ((zoom = 0; zoom < 6; zoom++)); do
    for ((i = 0; i < $((2**zoom)); i++)); do
      mkdir -p "$zoom/$i"
      mkdir -p "512/$zoom/$i"
    done
  done
fi
# zoom level 5 doesn't exist after tile concatenation
rm -rf 512/5

sqlite3 satellite-lowres-2018-03-01-planet.mbtiles <<< "SELECT writefile(tile_id || '.jpg', tile_data) FROM images"

# concat to 512x512 tiles (original levels = 0-5, discard 0 and build 0-4 from 1-5)
for ((zoom = 0; zoom < 5; zoom++)); do
  # based on https://vcs.rowanthorpe.com/rowan/jpegconcat
  for ((x = 0; x < $((2**zoom)); x++)); do
    for ((y = 0; y < $((2**zoom)); y++)); do
      OUT="512/$zoom/$x/$y.jpg"
      TL=$((zoom+1))/$((2*$x))/$((2*y)).jpg
      TR=$((zoom+1))/$((2*$x))/$((2*y+1)).jpg
      BL=$((zoom+1))/$((2*$x+1))/$((2*y)).jpg
      BR=$((zoom+1))/$((2*$x+1))/$((2*y+1)).jpg
      jpegtran -perfect -copy none -crop 512x512 -outfile $OUT $TL
      jpegtran -perfect -copy none -drop +0+256 $TR -outfile $OUT $OUT
      jpegtran -perfect -copy none -drop +256+0 $BL -outfile $OUT $OUT
      jpegtran -optimize -perfect -copy none -drop +256+256 $BR -outfile $OUT $OUT
      # could also run jpegoptim over the file: https://github.com/tjko/jpegoptim
    done
  done
done

# alternative approach (didn't manage to get it working)
#gdal_retile.py -ps 512 512 -levels 5 -useDirForEachRow -of Jpeg -targetDir retiled satellite-lowres-2018-03-01-planet.mbtiles

zip -r openmaptiles512.zip 512/*
