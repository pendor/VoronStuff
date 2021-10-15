$fn=16;





import("2020StockMount/files/Spool_Holder.STL");

color("red")
translate([43,0,20.5])
rotate([0,180,0])
union() {
translate([1,-2.9,.5])
cube([41,3.5,12]);

translate([0,-2.9,0])
import("MountPlateVoron.stl");
}