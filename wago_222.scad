// Copyright (c) 2016 Kenneth Johansson <ken@kenjo.org>
// License: BSD
use <morphology.scad>
use <fillet.scad>

$fn=20;

// dimentions from https://eshop.wago.com/JPBC/0_5StartPage.jsp;jsessionid=6317F88AB0BF164868AAF81BEEFE2993?zone=6
// https://eshop.wago.com/JPBC/image/WAGO01/pictures/detail/00078929_0.jpg

// here we model it so that
// x = height
// y = length
// z = widht
length = 20.5;
height = 14.5;
width  = 26.6;

//module guide(offset, len, plate_len)
//translate([0, 0, 24.9])
//mirror([1,0,0])
//rotate([0, -90, 0])


holder_single(fillet=2,skip=false);

module holder_rail(num=1, fillet=0, skip=false) {
    ddepth = width*num + (num-1)*2;

    difference(){
	if (fillet) {
	    if (fillet == 1){
		difference(){
		    fillet(r=3, steps=10, include=true, skip=skip) {
			/* bottom */
			translate([-3,-3,0])
			cube([19 + 6 ,ddepth + 6 , 0.1]);

			cube([19, ddepth, 25]);

		    }
		    /* bottom */
		    translate([-3, -3, 0])
		    cube([19 + 6 , ddepth + 6 , 0.1]);
		}
	    }else {
		/* really complicated way of doing a triangle */
		fillet(r=35, steps=2, include=true, skip=skip) {
		    /* back */
		    translate([0, 0, -15])
		    cube([2 ,ddepth , 15]);

		    cube([19,ddepth,25]);
		}
	    }
	}else {
	    cube([19,ddepth ,25]);
	}


	translate([9.1, -1, 7])
	cube([10, ddepth + 2, 17]);

	/* remove top */
	translate([4.2, -1, 22])
	cube([20, ddepth+2, 20]);

	/* remove wago base unit*/
	factor=1.02;
	translate([3,-0.02,2])
	scale([ factor, factor, factor])
	scale([1,ddepth,1])
	3d_base_unit();

    }

    /* add in negative wago base unit, that is with pegs to it snap inplace */
    for(idx=[0 : 1 :num-1  ]) {
	translate([0, width*idx + idx*2, 0])
	holder_single(fillet=0, skip=true);
    }

}

module holder_single(fillet=0, skip=false){

    difference() {

	if (fillet) {
	    if (fillet == 1){
		difference(){
		    fillet(r=3, steps=10, include=true, skip=skip) {
			/* bottom */
			translate([-3,-3,0])
			cube([19 + 6 ,width + 6 , 0.1]);

			cube([19, width, 25]);
		    }
		    /* bottom */
		    translate([-3, -3, 0])
		    cube([19 + 6 , width + 6 , 0.1]);
		}
	    }else {
		    /* really complicated way of doing a triangle */
		    fillet(r=35, steps=2, include=true, skip=skip) {
			/* back */
			translate([0, 0, -15])
			cube([2 ,width , 15]);

			cube([19,width,25]);
		    }
	    }
	}else {
	    cube([19,width ,25]);
	}

	/* remove right side */
	translate([9.1, -1, 7])
	cube([10, width+2, 17]);

	/* remove top */
	translate([4.2, -1, 22])
	cube([20, width+2, 20]);

	factor=1.02;
	translate([3,-0.02,2])
	scale([ factor, factor, factor])
	3d_full();
    }
}

module 3d_full()
{
    difference()
    {
	3d_base();

	w    = 18;
	h    =  9.3;
	thik =  1.2;

	// the cutout needs to be smaller than the real thing as we are going to remove this model
	// from another solid and the result needs to fit in the real thing.
	translate([0, (width - w)/2, length - h])
	cube([thik, w, h]);

	// test hole, again a bit smaller than real hole.
	translate([13.3, width/2, 2.3])
	rotate([90,0,270])
	test_hole();
    }
}

module test_hole(){
    copy_mirror()
    linear_extrude(height=2,scale=[0.5,1])
    square([1.9, 1.6]);
}

module 3d_base(){
    scale([1,width,1])
    3d_base_unit();
}

/*depth of 1 so it scales in y */
module 3d_base_unit(){
    translate([0,1,0])
    rotate([90,0])
    linear_extrude(height=1)
    2d_base();
}


module 2d_base(){
    rounding(r=1)
    2d_base_raw();
}

module 2d_base_offset(){
    $fn=30;
    offset(r=-29.8)
    offset(r=30)
    2d_base_raw();
}

module 2d_base_raw(){

    difference(){
	square([height,length]);

	// bottom left
	polygon(points=[[0,0],[3,0],[0,8]]);

	// bottom right
	polygon(points=[[height-3.5, 0],[height, 0],[height, 6]]);

	// top left
	polygon(points=[[0, 8],[0, length],[1.2, length]]);

	// top right
	polygon(points=[[height, length-7],[height-4, length],[height, length]]);
    }
}


/******************************************************************************/
/* generic helpers */

module copy_mirror(vec=[1,0,0])
{
    children();
    mirror(vec) children();
}
