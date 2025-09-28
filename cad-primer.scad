// cube(10);

difference(){
    translate([10,20,30]){
        linear_extrude(10){
            circle(10);
            translate([5,5,0]){
                square([12,14]);
            }
        }
    }

    translate([15,15,30]){
        sphere(7);
    }
}

rotate_extrude(angle=90){
    text("Turn");
}