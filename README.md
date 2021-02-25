# nersc_unref
This repository uses docker to provide an `unref` executable (from [here](https://git.immc.ucl.ac.be/unref/unref)) to generate meshes that can be used with the sea ice model `neXtSIM`.

## Docker image creation
```
docker build . -t nersc_unref
```

## Mesh creation
```
./MkMesh.sh SHAPEFILE RESOLUTION LON LAT
```
Here the inputs are
- `SHAPEFILE` should retain the .shp suffix.
- `RESOLUTION` should be in km without a unit suffix (i.e. be an integer).
- `LON` and `LAT` are the coordinates of a point within the domain,
  - Arctic: LON=0,   LAT=90
  - Fram:   LON=-10, LAT=75
  - Kara:   LON=75,  LAT=75
