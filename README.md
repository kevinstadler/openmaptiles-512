## Generating 512 pixel tilesize raster tiles from OpenMapTiles downloads

MapTiler's [OpenMapTiles initiative](https://openmaptiles.com) offers some older vector and raster tilesets for free download, such as [a 2018 snapshot of the low (0-5) zoom levels](https://openmaptiles.com/downloads/tileset/satellite-lowres/) of their commercial [Satellite raster tiles](https://openmaptiles.com/downloads/dataset/satellite/) (up to zoom level 20).

Even though most tile services (including [MapTiler](https://www.maptiler.com/news/2019/04/maptiler-cloud-infrastructure-upgrade/)) are now using 512x512 pixel tiles, the jpeg tiles contained in the OpenMapTiles downloads are still at the old default tilesize of 256 pixels.

The bash script in this repository can be used to generate 512x512 pixel tiles (for zoom levels 0-4) from the `satellite-lowres-2018-03-01-planet.mbtiles` OpenMapTiles download. The script should work just as well for other jpeg raster tile sets (such as the hillshading tiles), and also non-OpenMapTiles tile sets.

*Even if you are self-hosting these tiles, they still require a [© MapTiler](https://www.maptiler.com/copyright/) attribution wherever you use them.*

The script depends on `sqlite3` (for tile extraction) and `jpegtran` (for lossless concatenation and optimization of the jpeg files).
