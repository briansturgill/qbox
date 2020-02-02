$fn = 50;
w = 100; // Inner box width (X)
d = w/1.618; // Inner box depth (Y)
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

include <../src/filleted_box.scad>;
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

module make_box() {
    difference() {
        union() {
            filleted_box();
            right(d/2, 0) usb_breakout();
        }
        right(d/2, 0) usb_breakout_hole();
    }
}

module make_shell_lid() {
        spk_off = (d-spk_hole_spacing)/2;
    difference() {
        union() {
            filleted_shell_lid();
            bottom(spk_off+8, spk_off) speaker();
        }
        bottom(spk_off+8, spk_off) speaker_holes();
        bottom(w-22, d/2) hole(6.3); // 12.6mm d pushbutton
    }
}

module make_facade_lid() {
        spk_off = (d-spk_hole_spacing)/2;
    difference() {
        union() {
            filleted_facade_lid();
            bottom(spk_off+8, spk_off) speaker();
        }
        bottom(spk_off+8, spk_off) speaker_holes();
        bottom(w-22, d/2) hole(6); // 12mm d pushbutton
    }
}

MODEL="all";
if (MODEL == "box") {
    make_box();
} else if (MODEL == "slid") {
    make_shell_lid();
} else if (MODEL == "flid") {
    make_facade_lid();
} else {
    make_box();
        translate([-10, d, 0]) rotate ([0, 0, 90])
    make_shell_lid();
        translate([-d-10, 0, 0]) rotate ([0, 0, -90])
    make_facade_lid();
}
