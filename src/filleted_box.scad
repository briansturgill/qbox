/* You must define these in your project file.
$fn = 50;
w = 100; // Inner box width (X)
d = 70; // Inner box depth (Y)
h = 40; // Inner box height (Z)
lid_h = 15; // For filleted_shell_lid
lid_hole_z_offset = lid_h/2; // Z distance down from top of box.
lid_inset = 0.3; // So lid is not such a tight fit.
// Wall should be at least 2 or it may not print well.
lid_hole_size = 3; // M3 bolt.
lid_bolts_tapered = true;
wall = 2; // Box/lid wall thickness
// Fillet must be greater than or equal to 2*wall.
fillet = 5; // Fillet radius of xy plane fillet
*/

//filleted_facade_lid(); // For debugging

module filleted_box() {
    difference() {
        union() {
            _make_filleted_box(w, d, h, wall, fillet);
        }
        _make_filleted_box_holes();
    }
}

module _make_filleted_box_holes() {
    left(d*0.25, h-lid_hole_z_offset)
        rotate([180, 0, 0]) translate([0, 0, wall])
            tapered_bolt_hole((lid_hole_size/2.0), 8);
    left(d*0.75, h-lid_hole_z_offset)
        rotate([180, 0, 0]) translate([0, 0, wall])
            tapered_bolt_hole((lid_hole_size/2.0), 8); 
    right(d*0.25, h-lid_hole_z_offset)
        rotate([180, 0, 0]) translate([0, 0, wall])
            tapered_bolt_hole((lid_hole_size/2.0), 8);
    right(d*0.75, h-lid_hole_z_offset)
        rotate([180, 0, 0]) translate([0, 0, wall])
            tapered_bolt_hole((lid_hole_size/2.0), 8);

}
    
module _make_filleted_box(w, d, h, wall, fillet) {
    difference() {
        translate([-wall, -wall, 0])
            linear_extrude(h)
                round_rect([w+2*wall,d+2*wall], fillet);
        translate([0, 0, -1])
            linear_extrude(h+2)
                round_rect([w,d], fillet-wall);
    }
    let(tiny = 0.1) {
        for (iota = [tiny: tiny : 2.0+tiny ]) {
            translate([-wall+iota, -wall+iota,-iota])
                linear_extrude(tiny)
                    round_rect([w+2*(wall-iota), d+2*(wall-iota)], fillet-tiny);
        }
    }
}

module _make_filleted_lid_insert(lid_h, insert_h) {
    difference() {
        translate([0, 0, 0])
            linear_extrude(lid_h+insert_h)
                round_rect([w, d], fillet-wall);
        translate([wall+lid_inset, wall+lid_inset, -1])
            linear_extrude(lid_h+insert_h+2)
                round_rect([w-2*wall-lid_inset, d-2*wall-lid_inset], fillet-2*wall);
        difference() {
            translate([0, 0, lid_h])
                linear_extrude(insert_h)
                    round_rect([w, d], fillet-wall);
             translate([lid_inset, lid_inset, lid_h])
                linear_extrude(insert_h+2)
                    round_rect([w-2*lid_inset, d-2*lid_inset], fillet-wall-lid_inset);
       }
    }
    left(d*0.25, lid_h+insert_h-lid_hole_z_offset) translate([0,0,wall])tap_post(8, lid_hole_size); 
    left(d*0.75, lid_h+insert_h-lid_hole_z_offset) translate([0,0,wall])tap_post(8, lid_hole_size); 
    right(d*0.25, lid_h+insert_h-lid_hole_z_offset) translate([0,0,wall])tap_post(8, lid_hole_size); 
    right(d*0.75, lid_h+insert_h-lid_hole_z_offset) translate([0,0,wall])tap_post(8, lid_hole_size); 
}

module filleted_shell_lid() {
    difference() {
        union() {
            _make_filleted_box(w, d, lid_h, wall, fillet);
            _make_filleted_lid_insert(lid_h, lid_h);
        }
        _make_filleted_lid_holes(lid_h, lid_h);
    }
}

module filleted_facade_lid(oversize=2, lid_thickness=wall) {
    difference() {
        union() {
            translate([-wall-oversize, -wall-oversize, -lid_thickness]) {
                linear_extrude(lid_thickness)
                    round_rect([w+2*wall+2*oversize,d+2*wall+2*oversize], fillet+oversize);
             }
            _make_filleted_lid_insert(0, lid_h);
         }
        _make_filleted_lid_holes(0, lid_h);
     }
}

module _make_filleted_lid_holes(lid_h, insert_h) {
    left(d*0.25, lid_h+insert_h-lid_hole_z_offset) translate([0,0,wall])hole(lid_hole_size/2.0, 8); 
    left(d*0.75, lid_h+insert_h-lid_hole_z_offset) translate([0,0,wall])hole(lid_hole_size/2.0, 8); 
    right(d*0.25, lid_h+insert_h-lid_hole_z_offset) translate([0,0,wall])hole(lid_hole_size/2.0, 8); 
    right(d*0.75, lid_h+insert_h-lid_hole_z_offset) translate([0,0,wall])hole(lid_hole_size/2.0, 8); 
}
