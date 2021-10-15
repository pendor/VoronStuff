difference(){
union() {
color("red")
translate([-126,-82,13])
rotate([180,0,90])
import("spool_holder.stl");

color("yellow")
  translate([5,0,1])
cube([10,10,10]);
  
  color("yellow")
  translate([25,0,1])
cube([10,10,10]);
}

color("green")
translate([0,10,0])
cube([42,90,13.1]);

color("pink")
translate([-1,0,0])
cube([48,12,7]);

}

