# nersc_unref
This repository uses docker to provide an `unref` executable (from [here](https://git.immc.ucl.ac.be/unref/unref)) to generate meshes that can be used with the sea ice model `neXtSIM`.

## Docker image creation
```
docker build . -t nersc_unref
```

## Mesh creation
To run the executable directly, do
```
docker run --rm -it nersc_unref -v $(pwd):/inputs -w /inputs \
   unref input.unr
```
where `input.unr` has contents (for example):
```
output "gmsh_v3p08.msh"
shp "SHAPEFILE"
lon LON
lat LAT
background RESOLUTION
boundary_name "open" 2
boundary_name "coast" 1
```
The entries of this file are
- `SHAPEFILE`: a shapefile (with `.shp` extension) containing the external boundaries of the mesh.
- `RESOLUTION` should be in m without a unit suffix (i.e. be an integer).
- `LON` and `LAT` are the coordinates of a point within the domain, eg.
  - Arctic: LON=0,   LAT=90
  - Fram:   LON=-10, LAT=75
  - Kara:   LON=75,  LAT=75
This outputs a gmsh mesh with format 3.08. `neXtSIM` uses format 2.2 so we need to use `gmsh`
to convert it afterwards.


The full procedure, including with the gmsh conversion, is automated in the script `MkMesh.sh`,
which has usage:
```
./MkMesh.sh SHAPEFILE RESOLUTION_KM LON LAT
```
Here `RESOLUTION_KM` should be in km without a unit suffix (i.e. be an integer),
and the other inputs are as above.
