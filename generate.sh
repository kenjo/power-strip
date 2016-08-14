#! /bin/bash

echo "Generate STL files"
echo "This takes a long time time, On my computer about 3 minutes"
echo ""

mkdir -p stl
openscad  -D rows=1  --render -o stl/holder_2.stl  holder.scad
openscad  -D rows=2  --render -o stl/holder_4.stl  holder.scad
openscad  -D rows=3  --render -o stl/holder_6.stl  holder.scad
openscad  -D rows=4  --render -o stl/holder_8.stl  holder.scad
openscad  -D rows=5  --render -o stl/holder_10.stl holder.scad
openscad  -D rows=6  --render -o stl/holder_12.stl holder.scad

openscad  -D render_bottom=true   --render -o stl/bottom.stl pw_strip.scad
openscad  -D render_bottom=false  --render -o stl/lid.stl    pw_strip.scad

echo ""
echo "Done!"
echo "you can now slice all the stl files in the stl subrirectory"
echo ""
