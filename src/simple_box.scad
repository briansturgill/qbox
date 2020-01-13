/* You must define these in your project file.
$fn = 50;
w = 100; // Inner box width (X)
d = 70; // Inner box depth (Y)
h = 40; // Inner box height (Z)

// Wall should be at least 2 or it may not print well.
wall = 2; // Box/lid wall thickness
// Fillet must be greater than or equal to 2*wall.
fillet = 7; // Fillet radius of xy plane fillet

lid_inset = 0.5; // So lid is not such a tight fit.
lid_hole_size = 3; // M3 bolt.
 */
 
//include <../src/utils.scad>; // For debugging
//simple_box_lid(); // For debugging

module simple_box() {
    _make_simple_box_bottom();
    translate([0, 0, wall]) simple_box_body();
}

module _make_simple_box_bottom() {
	translate([-wall, -wall, -wall]) 
        linear_extrude(wall)
			round_rect([w+2*wall,d+2*wall], fillet);
}

module simple_box_bottom() {
    _make_simple_box_bottom();
    difference() {
        translate([lid_inset, lid_inset, 0])
            linear_extrude(2*wall+2)
                round_rect([w-2*lid_inset,d-2*lid_inset], fillet-wall-lid_inset);
        translate([wall+lid_inset, wall+lid_inset, -1])
            linear_extrude(2*wall+4)
                round_rect([w-2*wall-2*lid_inset,d-2*wall-2*lid_inset], fillet-2*wall-lid_inset);
    }
}

module simple_box_body(add_posts=true) {
    difference() {
        translate([-wall, -wall, 0])
            linear_extrude(h)
                round_rect([w+2*wall,d+2*wall], fillet);
        translate([0, 0, -1])
            linear_extrude(h+2)
                round_rect([w,d], fillet-wall);
    }
    if (add_posts) {
        post_ctr = fillet-2;
        // 2 is default post wall size, but we use 4 below to anchor solidly
        translate([post_ctr, post_ctr, h-8])
            tap_post(8, lid_hole_size, 4, add_taper=true, z_rot=180-45);
        translate([post_ctr, d-post_ctr, h-8])
            tap_post(8, lid_hole_size, 4, add_taper=true, z_rot=45);
        translate([w-post_ctr, post_ctr, h-8])
            tap_post(8, lid_hole_size, 4, add_taper=true, z_rot=180+45);
        translate([w-post_ctr, d-post_ctr, h-8])
            tap_post(8, lid_hole_size, 4, add_taper=true, z_rot=-45);
    }
}

module simple_box_posts(h=8, sz=lid_hole_size, heat_insert=false) {
    p_wall = fillet-2-(sz/2);
    p_r = fillet-2;
    p_d = p_r*2;
    sep_thickness = 0.5;
    sep_len = p_d;
    for (x= [0, p_d+sep_len]) {
        for(y= [0, p_d+sep_len]) {
            if (!heat_insert) {
                translate([x,y,0]) tap_post(h, sz, p_wall);
            } else {
                translate([x,y,0]) heat_insert_post(h, sz, p_wall);
            }
            translate([x+p_r-2,y-1,0]) cube([sep_len+4, 2, 0.5]);
            translate([x-1,y+p_r-2,0]) cube([2, sep_len+4, 0.5]);
        }
    }
}

module simple_box_lid() {
    post_ctr = fillet-2;
    difference() {
        translate([0, 0, wall]) _make_simple_box_bottom();
        translate([post_ctr, post_ctr, 0])
            rotate([180, 0, 0]) 
                tapered_bolt_hole((lid_hole_size/2.0), 8);
        translate([post_ctr, d-post_ctr, 0])
            rotate([180, 0, 0]) 
                tapered_bolt_hole((lid_hole_size/2.0), 8);
        translate([w-post_ctr, post_ctr, 0])
            rotate([180, 0, 0]) 
                tapered_bolt_hole((lid_hole_size/2.0), 8);
        translate([w-post_ctr, d-post_ctr, 0])
            rotate([180, 0, 0]) 
                tapered_bolt_hole((lid_hole_size/2.0), 8);
    }
}
