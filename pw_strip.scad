// Copyright (c) 2016 Kenneth Johansson <ken@kenjo.org>
// License: BSD

use <fillet.scad>
use <wago_222.scad>

// the diamater of the cable,
cable=8;

// set to false to render lid
render_bottom = true;

// set fast to ture to have quicker rendering time.
// this removes holes, fillets and so on that is timeconsuming to render.
//fast=true;
fast=false;


///////////////////////////////////////////////////////////////////////////////

slack=2;
wall=3;
$fn=40;

b_dia=cable*2;
s_dia=3;
sep=20;
 
height= 4 + (cable + 2 * 1.5)*6 ;

w=(cable*2 + slack*2 + s_dia + b_dia + cable +wall )*2 ;
lid_guide=5;
length=200;


if (render_bottom) {
    bottom();
}else{
    lid();
}


module bottom() {

    difference() {
	union() {
	    cable_base();
	    translate([-45, 70, wall])	wago(1);
	    translate([-10, 70, wall])	wago(1);
	    translate([ 25, 70, wall])	wago(1);
	    translate([ -42, length - (wall-3), 35])	rotate([00, 0, -90]) wago(2);
	}

	/* scrape a 0.3 mm from the top to make sure lid will fit.
	   lid has fillet so use the lid itself, but only the top part of the lid
	   otherwise the hooks at the bottom of lid will carv out extra space
	   and that is bad.
	*/
	 union() {
	     translate([0, 0, -0.3])
	     difference(){
		 lid();
		 translate([-w/2 -wall - lid_guide,-10,0])
		 cube([w + 2*wall + 2*lid_guide, length+ 20, 60]);
	     }
	 }
    }
}


//scale([1 ,1 ,0.99])
module lid(){
    difference(){
	union(){
	    /* top */
	    translate([-w/2 - lid_guide, 0, height + wall ])
	    cube([w + 2*lid_guide , length ,wall]);

	    /* left */
	    translate([-w/2 - lid_guide - wall , 0, wall/2 ])
	    cube([wall, length , height + wall + wall/2]);
	    /* left bottom */
	    translate([-w/2 - lid_guide - wall/2 , 0, wall/2 ])
	    rotate([-90, 0, 0])
	    cylinder(d=wall, length );

	    /* right */
	    translate([+w/2 + lid_guide  , 0, wall/2 ])
	    cube([wall, length , height + wall + wall/2]);
	    /* right bottom */
	    translate([+w/2 + lid_guide + wall/2 , 0, wall/2 ])
	    rotate([-90, 0, 0])
	    cylinder(d=wall, length );
	}

	if (! fast) {
	    /* rounding/filler on outer wall edge */
	    translate([-w/2 - lid_guide - wall, -1 , height + wall*2])
	    rotate([-90, 0, 0])
	    difference() {
		cube([3, 3, length + 2]);
		translate([3, 3, 0])
		cylinder(r=3, length + 2 );
	    }

	    /* rounding/filler on outer wall edge */
	    translate([w/2 + lid_guide , -1 , height + wall*2])
	    rotate([-90, 0, 0])
	    difference() {
		cube([3, 3, length + 2]);
		translate([0, 3, 0])
		cylinder(r=3, length + 2 );
	    }
	}
    }

    if (! fast) {
	translate([-w/2 - lid_guide , 0 , height + wall])
	rotate([-90, 0, 0])
	difference() {
	    cube([3, 3, length ]);
	    translate([3, 3, 0])
	    cylinder(r=3, length  );
	}

	translate([w/2 + lid_guide - wall , 0 , height + wall])
	rotate([-90, 0, 0])
	difference() {
	    cube([3, 3, length ]);
	    translate([0, 3, 0])
	    cylinder(r=3, length  );
	}
    }
    mirror() hook_side();
    hook_side();
}

module hook_side(scale=1){

    translate([w/2 + lid_guide, length/2 , wall + wall ])
    for (idx=[0:1:2]) {
	translate([0, 11*idx, 0])
	rotate([0,180,90])
	hook(scale=scale);
    }
}

module hook(scale=1){
    scale(scale)
    linear_extrude(height= 2, scale=[2,0])
    copy_mirror()
    square([5/2 , 2]);
}

/* wago 222 holders */
module wago(fillet=0) {
    holder_rail(3, fillet=fillet, skip=fast);
}

/* cable holes */
module cable_base()
{
    difference () {
	walls();

	/* apparently openscad gets slow when you have lots of holes, */
	if (! fast) {
	    /* cable holes */
	    for (idx=[0:1:5]) {
		translate([cable/2+1.5, -1 ,wall + 4 + cable/2 + (cable + 3)*idx])
		rotate([0,90,90])
		cylinder(d=cable*1.02,h=wall + 2);

		translate([- (cable/2 +1.5), -1 ,wall + 4 + cable/2 + (cable + 3)*idx])
		rotate([0,90,90])
		cylinder(d=cable*1.02,h=wall + 2);
	    }
	    /* cable holes farside */

	    translate([0 , length -wall , wall + 4 + cable/2 + (cable + 3)*0])
	    rotate([0,90,90])
	    cylinder(d=cable*1.02, h=wall + 2);
	    
	    /* cable tie holes */
	    for (idx=[0:1:6]) {
		translate([-w/2 - wall -1 , 43, wall + 2 + (cable + 3)*idx ])
		cube([w+2*wall+2, 3.5, 3]);
	    }
	    /* cable tie holes , farside */
	    for (idx=[0:1:1]) {
    		translate([-w/2 - wall -1 , length -33, wall + 2 + (cable + 3)*idx ])
		cube([w+2*wall+2, 3.5, 3]);
	    }
	}

	mirror()
	hook_side(scale=1.05);
	hook_side(scale=1.05);

    }
    
    translate([0 ,wall,0])
    ancor_4();

    ancor_farside_fillet(fast=fast);
}

module walls(){
    h=50;
    far_h=37;

    difference() {
	union() {
	    fillet(r=3, steps=10, include=true, skip=fast) {
		/* base plate */
		translate([-w/2 - lid_guide, 0, 0])
		cube([w + 2*lid_guide, length, wall]);

		/* end wall */
		translate([-w/2 -lid_guide, 0, 0])
		cube([w +2*lid_guide, wall ,height + wall]);

		/* end farside */
		translate([-w/2 - lid_guide , length - wall , 0])
		cube([w + 2*lid_guide  , wall ,height + wall ]);

		/* left wall */
		translate([-w/2-wall, 0, 0])
		cube([wall, h, height + wall]);

		/* left wall middle, for lid hooks */
		translate([-w/2 - lid_guide, length/2 - 8, 0])
		cube([wall, 12.5*3, wall + wall + wall]);

		/* right wall middle, for lid hooks */
		mirror()
		translate([-w/2 - lid_guide, length/2 - 8, 0])
		cube([wall, 12.5*3, wall + wall + wall]);

		/* left wall farside */
		translate([-w/2 - wall, length - far_h - wall/2, 0])
		cube([wall, far_h, cable*3]);

		/* right wall */
		translate([w/2, 0, 0])
		cube([wall, h, height + wall]);

		/* right wall farside */
		translate([w/2, length - far_h - wall/2, 0])
		cube([wall, far_h, cable*3 ]);

		/* far side end rounding */
		translate([w/2 + lid_guide -wall , length - wall , 0])
		cylinder(r=3, height + wall);

		translate([-w/2 -lid_guide + wall, length - wall, 0])
		cylinder(r=3, height + wall);
	    }
	}

        if (! fast) {
	    /* rounding/filler on end outer wall edge */
	    translate([-w/2 -lid_guide, 0 , 0])
	    difference(){
		cube([3, 3, height + wall]);
		translate([3, 3, 0])
		cylinder(r=3, height + wall);
	    }
	    translate([w/2 + lid_guide -wall , 0 , 0])
	    difference(){
		cube([3, 3, height + wall]);
		translate([0, 3, 0])
		cylinder(r=3, height + wall);
	    }

	    /* rounding/filler on end outer wall edge */
	    translate([-w/2 -lid_guide, length - wall, 0])
	    difference(){
		cube([3, 3, height + wall]);
		translate([3, 0, 0])
		cylinder(r=3, height + wall);
	    }
	    translate([w/2 + lid_guide -wall , length - wall , 0])
	    difference(){
		cube([3, 3, height + wall]);
		translate([0, 0, 0])
		cylinder(r=3, height + wall);
	    }
	}
    }

    if (! fast) {
	/* rounding on wall ending */
	translate([w/2 + wall/2, h, 0])
	cylinder(d=wall, height + wall);

	translate([-w/2 - wall/2, h, 0])
	cylinder(d=wall, height + wall);

	/* rounding on farside wall ending */
	translate([w/2 + wall/2, length - far_h - wall/2, 0])
	cylinder(d=wall, cable*3 );

	translate([-w/2 - wall/2, length - far_h - wall/2, 0])
	cylinder(d=wall, cable*3);
    }
}

/* takes less space and we only have one cable on farside */
module ancor_farside_fillet(fast = false){

    x_split=w/2 - b_dia/2 - cable - slack;

    if ( ! fast ) {
	difference() {
	    fillet(r=3, steps=10, include=true) {

		translate ([x_split,  length - b_dia/2 - cable  - slack - wall, 0])
		cylinder(d=b_dia, h=30);
		translate ([-x_split, length - cable*2 - slack - wall, 0])
		cylinder(d=b_dia, h=30);

		/* a base to create the fillet to */
		translate([-w/2-lid_guide ,0,0])
		cube([w+2*lid_guide, length, wall]);
	    }
	    /* when done remove the base */
	    translate([-w/2-lid_guide ,0,0])
	    cube([w+2*lid_guide, length, wall]);
	}
    } else {
	/* no fillet,for speed during develop */
	translate ([x_split,  length - b_dia/2 - cable  - slack - wall, 0])
	cylinder(d=b_dia, h=30);
	translate ([-x_split, length - cable*2 - slack - wall, 0])
	cylinder(d=b_dia, h=30);
    }
}

/* all four strain relief bars */
module ancor_4(){
    mirror()
    translate([0,0,wall])
    ancors(height, fast);

    translate([0,0,wall])
    ancors(height, fast);
}

module ancors(height, fast=true){

    // the y position should be calculated so that the cable will fit.
    // it's possible to do this exactly but you need to do a lot of trig.
    // instead we approx it. works ok for cable size 10 or smaller
    translate([cable + slack, (cable + slack*2) * 2 , 0])
    ancor_fillet(height, fast, inv=false);


    translate([cable*2 + slack*2 + s_dia , cable + slack, 0])
    ancor_fillet(height, fast, inv=true);
}

module ancor_fillet(height, fast = false, inv=false) {
    fill = 10;

    if ( ! fast ) {
	difference() {
	    fillet(r=3, steps=10, include=true) {
		ancor(height,inv);
		/* a base to create the fillet to */
 		translate([- fill/2, - fill/2, 0])
		cube([b_dia + fill, s_dia/2 + b_dia/2 + sep + fill ,0.001]);
	    }
	    /* when done remove the base */
 	    translate([- fill/2, - fill/2, 0])
	    cube([b_dia + fill, s_dia/2 + b_dia/2 + sep + fill ,0.001]);
	}
    } else {
	/* no fillet,for speed during develop */
	ancor(height, inv);
    }
}

module ancor(height, inv=false) {

    linear_extrude(height=height)
    hull() {
	if (inv) {
	    translate([b_dia/2,  b_dia/2])
	    circle(d=b_dia);

	    translate([b_dia/2 +(b_dia/2 -s_dia/2),  sep + b_dia/2])
	    circle(d=s_dia);

	} else{
	    translate([b_dia/2, sep + s_dia/2])
	    circle(d=b_dia);

	    translate([s_dia/2,  s_dia/2])
	    circle(d=s_dia);
	}
    }
}



