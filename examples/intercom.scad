$fn = 50;
w = 120; // Inner box width (X)
d = w/1.618; // Inner box depth (Y)
h = 65; // Inner box height (Z)

// Wall should be at least 2 or it may not print well.
wall = 2; // Box/lid wall thickness
// Fillet must be greater than or equal to 2*wall.
fillet = 7; // Fillet radius of xy plane fillet

lid_inset = 0.3; // So lid is not such a tight fit.
lid_hole_size = 3; // M3 bolt.

include <../src/simple_box.scad>;
include <../src/utils.scad>;
include <../src/components.scad>;

spk_hole_spacing = 41;
module speaker() {
    translate([0, 0, 0]) tap_post(6, 3);
    translate([spk_hole_spacing, 0, 0]) tap_post(6, 3);
    translate([0, spk_hole_spacing, 0]) tap_post(6, 3);
    translate([spk_hole_spacing, spk_hole_spacing, 0]) tap_post(6, 3);
}
module speaker_holes() {
    ctr = spk_hole_spacing/2;
    translate([ctr, ctr, 0.01])
        circular_speaker_grid_holes(20, 3);
}

module make_body() {
    difference() {
        union() {
            simple_box_body(add_posts=true);
            left(d/2, 2*(h/3)) bme280();
        }
        right(d/2, h-15) horizontal_slot_hole(12, 7); // Slot for micro-usb
        left(d/2, 2*(h/3)) bme280_hole();
        //left(d/2, 2*(h/3)) bme280_marker();
    }
}


module make_bottom() {
        spk_off = (d-spk_hole_spacing)/2;
    difference() {
        union() {
            simple_box_bottom();
            bottom(spk_off+8, spk_off) speaker();
            bottom(w-28, d/3) max9814_mic(rot=90);
        }
        bottom(spk_off+8, spk_off) speaker_holes();
        bottom(w-28, 2*(d/3)) hole(6); // 12mm d pushbutton
        bottom(w-28, d/3) max9814_mic_hole();
    }
}

module make_lid() {
    difference() {
        union() {
            simple_box_lid();
        }
    }
}

MODEL="all";
if (MODEL == "body") {
    make_body();
} else if (MODEL == "lid") {
    make_lid();
} else if (MODEL == "bottom") {
    make_bottom();
} else if (MODEL == "glue") {
    simple_box_posts();
    translate([10, -20, 0]) bme280();
} else {
    make_body();
    translate([-10, d, 0]) rotate ([0, 0, 90])
        make_lid();
    translate([-d-10, 0, 0]) rotate ([0, 0, -90])
        make_bottom();
}
