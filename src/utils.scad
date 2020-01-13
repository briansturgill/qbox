module tap_post(h, size, post_wall=2, add_taper=false, z_rot=0) {
    inner_d = size*0.8; //Possibly snug, but with PLA I prefer that
    outer_d = post_wall*2+size;
    difference() {
        linear_extrude(h) circle(outer_d/2.0);
        translate([0, 0, -1]) linear_extrude(h+2) circle(inner_d/2.0); 
    }
    if (add_taper) {
        translate([0, 0, -h*2]) difference() {
            linear_extrude(h*2) circle(outer_d/2.0);
            translate([0, 0, -1]) linear_extrude(h*2+2) circle(inner_d/2.0);
            rotate([45, 0, z_rot]) translate([0,0,h])
                cube([outer_d, outer_d, h*3+2], center=true);
        }
    }
}

module heat_insert_post(h, size, post_wall=2) {
    inner_d = size;
    outer_d = post_wall*2+size;
    inset_r = (size+2+0.15)/2.0;
    chamfer_h = sin(8)*inset_r;
    difference() {
        linear_extrude(h) circle(outer_d/2.0);
        translate([0, 0, -1]) linear_extrude(h+2) circle(inner_d/2.0);
        translate([0, 0, -1]) cylinder(h=h+2, r1=inset_r, r2=inset_r-cos(8)*inset_r); 
    }
}

module horizontal_slot_hole(sw, sh) {
    translate([-(sw-sh)/2.0, 0, 0]) hole(sh/2.0, wall);
    centered_rect_hole(sw-sh, sh, wall);
    translate([(sw-sh)/2.0, 0, 0]) hole(sh/2.0, wall);
}

module tapered_bolt_hole(r, h) {
    rotate([180, 0, 0]) translate([0, 0, -1]) union() {
        bolt_top_r = r*2;
        chamfer_h = sin(45)*bolt_top_r;
        h_chamfered = chamfer_h>h?h:chamfer_h;
        h_remaining = chamfer_h>h?0:h-chamfer_h;
        cylinder(h=1, r=bolt_top_r);
        translate([0, 0, 1])
            cylinder(h=h_chamfered, r1=bolt_top_r, r2=r);
        translate([0, 0, h_chamfered])
            cylinder(h=h_remaining+2, r=r*0.80);
    }
}

module hole(r, h=wall) {
        rotate([180, 0, 0]) translate([0, 0, -1]) linear_extrude(h+2) circle(r);
}

module centered_rect_hole(w, d, h) {
    rotate([180, 0, 0]) translate([0, 0, -1]) linear_extrude(h+2) square([w,d], center=true);
}

module round_rect(dim, radius) {
    hull() {
        translate([radius, radius, 0]) circle(radius);
        translate([dim.x-radius, radius, 0]) circle(radius);
        translate([radius, dim.y-radius, 0]) circle(radius);
        translate([dim.x-radius, dim.y-radius, 0]) circle(radius);
    }
}

module left(x, y) {
    translate([0, x, y]) rotate([-90, 180, -90]) children();
}

module right(x, y) {
    translate([w, d-x, y]) rotate([-90, 180, 90]) children();
}

module front(x, y) {
    translate([w-x, 0, y]) rotate([90, 0, 180]) children();
}

module back(x, y) {
    translate([x, d, y]) rotate([90, 0, 0]) children();
}

module bottom(x, y) {
    translate([x, y, 0]) children();
}
