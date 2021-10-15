$fn=16;



color("blue")
difference() {
import("Adapter.stl");

color("green")
translate([21.65,0,10])
rotate([90,0,0])
cylinder(r=2.65, h=20, center=true);
}

