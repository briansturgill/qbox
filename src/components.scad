tiny = 0.01; // Value to add hole depths to fully clear OpenSCAD preview.

module doppler_motion_sensor() {
    translate([0, 0, 0]) tap_post(6, 1.4);
    translate([15, 0, 0]) tap_post(6, 1.4);
    translate([0, 15, 0]) tap_post(6, 1.4);
    translate([15, 15, 0]) tap_post(6, 1.4);
}

module round_buzzer(buzzer_d, hole_d) {
    difference() {
        linear_extrude(2) circle((buzzer_d+2)/2.0);
        translate([0,0,-tiny]) linear_extrude(2+2*tiny) circle(buzzer_d/2.0);
    }
}

module round_buzzer_hole(hole_d) {
    hole(hole_d/2.0);
}

// Works best if r is evenly divisible by hole_w
module circular_speaker_grid_holes(r, h=wall, hole_w=2) {
    tiny = 0.01;
    translate([0, 0, -(h/2)-tiny]) intersection() {
        union() {
            for (y = [-(r-hole_w):2*hole_w:r-hole_w]) {
                translate([0, y, 0]) cube([r*2, hole_w, h+2*tiny], center=true);
            }
        }
        cylinder(r=r, h=h+2*tiny, center=true);
    }
}

module bme280() {
    translate([0, 0, 3/2]) difference() {
        cube([12+4, 16+4, 3], center=true);
        cube([12, 16, 3+2*tiny], center=true);
    }
    translate([3.5, -8-2, 1]) rotate([0, 0, 90]) wire_tie_loop();
    translate([3.5, 8, 1]) rotate([0, 0, 90]) wire_tie_loop();
}

module bme280_marker() {
    small = 0.2;
    translate([0, -(((16+4)/2)+small), 0])
        cube([12+4+2*small, small*3, small*2], center=true);
}

module bme280_hole() {
    translate([(11.5/2)-3.5, 0, -tiny]) hole(3/2);
}

module max9814_mic(rot=0) {
    rotate([0, 0, rot])
        union() {
            difference() {
                translate([-7.5-2, -7.5-2, 0]) cube([15.5+4, 26.5+4, 6]);
                translate([-7.5, -7.5, -tiny]) cube([15.5, 26.5, 6+2*tiny]);
            }
            translate([-7.5-2, -7.5-2, 0]) cube([15.5+4, 26.5, 3]);
            translate([8, 5, 4]) rotate([0, 0, 0]) wire_tie_loop();
            translate([-9.5, 5, 4]) rotate([0, 0, 0]) wire_tie_loop();
        }
}

module max9814_mic_hole() {
    translate([0, 0, 6-tiny]) hole(5, wall+6);
}

module wire_tie_loop() {
    translate([1,3.5,3]) difference() {
        cube([2, 7, 6], center=true);
        cube([2+2*tiny, 3, 2], center=true);
    }
}
