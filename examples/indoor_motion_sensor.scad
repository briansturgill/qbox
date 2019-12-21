$fn = 50;
w = 90; // Inner box width (X)
d = w/1.618; // Inner box depth (Y)
h = 35; // Inner box height (Z)
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


module make_box() {
    difference() {
        union() {
            filleted_box();
            left(d/2.0, (h-lid_h)/2.0) round_buzzer(13);
        }
        right(d/2, 15) horizontal_slot_hole(12, 7); // Slot for micro-usb
        left(d/2.0, (h-lid_h)/2.0) round_buzzer_hole(4);
    }
}

module make_shell_lid() {
    difference() {
        union() {
            filleted_shell_lid();
            bottom((w-36)/2.0, d-24) doppler_motion_sensor();
        }
    }
}
MODEL="both";
if (MODEL == "box") {
    make_box();
} else if (MODEL == "slid") {
    make_shell_lid();
} else {
    make_box();
        translate([-10, d, 0]) rotate ([0, 0, 90])
    make_shell_lid();
}
