// number of fragments used for circular offsets
$fn = 256;
cutout_over_extension = 1;

// square socket dimensions
skip_bottom = 0; //21.7;
socket_inner_size = 13.9;
socket_inner_depth = 22.7 - skip_bottom;
socket_inner_corner_curve_radius = 1.0;
// original part had heavily rounded outer corners
// but they cracked, so we'll keep this square
socket_outer_size = 21.6;
socket_outer_height = 27.0 - skip_bottom;

//O-ring holder outer dimensions
o_ring_holder_outer_diameter = 14.3;
o_ring_holder_height = 5.9;

//square handle seating dimensions
//actual part has a solid square 9.8 mm
//plus ribs that extend out to 10.5 mm
handle_seating_outer_size = 10.3;
handle_seating_height = 6.2;

screw_hole_diameter = 4.0;
screw_head_diameter = 7.1; // measured 6.6
screw_head_height = 3.1; // measured 2.1
screw_total_height = 20.9;

// threaded handle trim that we must fit into
containing_handle_trim_diameter = 29.6;

// the top of the part must fit in a narrower
// section of the threaded handle trim
narrower_circular_handle_trim_diameter = 21.8;
// this is the depth of that narrower section
// from the top of the o-ring holder downwards
narrower_circular_handle_trim_depth = 67.6 - 53.0;

module shell() {
    // outside of the socket
    linear_extrude(socket_outer_height) {
        square(socket_outer_size, center=true);
    }

    // outside of the O-ring holder
    translate([0, 0, socket_outer_height]) {
        linear_extrude(o_ring_holder_height) {
            circle(o_ring_holder_outer_diameter / 2);
        }
    }

    // outside of the handle seating
    translate([0, 0, socket_outer_height + o_ring_holder_height]) {
        linear_extrude(handle_seating_height) {
            square(handle_seating_outer_size, center=true);
        }
    }
}

module cutout () {
    // inside of the socket
    translate([0, 0, -1 * cutout_over_extension]) {
        linear_extrude(socket_inner_depth + cutout_over_extension) {
            offset(r=socket_inner_corner_curve_radius) {
                square(socket_inner_size
                          - 2 * socket_inner_corner_curve_radius,
                       center=true);
            }
        }
    }

    // screw hole
    translate([0, 0, -500]) {
        linear_extrude(1000) {
            circle(screw_hole_diameter / 2);
        }
    }

    // screw head inset
    translate([0, 0, socket_inner_depth-0.1]) {
        linear_extrude(screw_head_height+0.1, scale = screw_head_diameter / socket_inner_size * 1.5) {
            circle(socket_inner_size / 2);
        }
    }
    
    // narrower section of threaded trim piece
    translate([0, 0, socket_outer_height + o_ring_holder_height - narrower_circular_handle_trim_depth]) {
        linear_extrude(narrower_circular_handle_trim_depth, convexity=10) {
            difference() {
                circle(narrower_circular_handle_trim_diameter);
                circle(narrower_circular_handle_trim_diameter / 2);
            }
        }
    }
}

// debugging for the cutout
color("lightblue") {
    translate([30,30,0]) {
        // cutout();
    }
}

module boundary () {
    translate([0, 0, -500]) {
        linear_extrude(1000) {
            circle(containing_handle_trim_diameter / 2);
        }
    }
}

difference() {
    intersection() {
        shell();
        boundary();
    }
    cutout();
}