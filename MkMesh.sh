#! /bin/bash

# A simple shell script to automate mesh generation

# Check inputs - first should be the shape file name, second resolution, and third and fourth a point in the domain
if [ "$1" == "-h" -o "$1" == "--help" -o -z "$4" -o z"${1:(-4)}" != z".shp" ]
then
	echo "Usage: $0 shapefile.shp resolution lon lat"
	echo "Shape file should retain the .shp suffix. Resolution should be in km without a unit suffix (i.e. be an integer). Lon and lat are the coordinates of a point within the domain, e.g."
    echo " Arctic: lon =   0, lat = 90"
    echo " Fram:   lon = -10, lat = 75"
    echo " Kara:   lon =  75, lat = 75"
	exit 1
fi

shapefile=$1
resolution=$2
lon=$3
lat=$4
basename=$(basename $shapefile .shp)

# Make sure $resolution is a number (e.g. not 40km)
if [ "$resolution" -eq "$resolution" ] 2>/dev/null
then
	echo -n
else
	echo "Resolution must be a number (no unit suffix allowed)"
	exit 2
fi

# Check that $resolution is in kilometers
if [ $resolution -gt 1000 ]
then
	echo "Resolution must be in kilometers"
	exit 2
fi

# Create the input file for unref
tmpfile="gmsh_v3p08.msh"
cat > $basename.unr << EOF
output "$tmpfile"
shp "$shapefile"
lon $lon
lat $lat
background $(( resolution*1000 ))
boundary_name "open" 2
boundary_name "coast" 1
EOF

# Run unref on the control file
# - generates output.msh which is gmsh version 3.08
drun="docker run --rm -it -v $(pwd):/inputs -w /inputs"
$drun nersc_unref unref $basename.unr
#$drun nansencenter/nersc_unref unref $basename.unr

# Save mesh as gmsh version 2
$drun nansencenter/nextsim_base_dev gmsh \
   $tmpfile -o ${basename}_${resolution}km.msh -format msh2 -0

# Clean
rm $tmpfile
