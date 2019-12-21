$fn=50;
include <../src/utils.scad>;
lid_hole_size=3;
fillet=8;

module posts(h=8, sz=lid_hole_size, heat_insert=false) {
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

posts(heat_insert=true);