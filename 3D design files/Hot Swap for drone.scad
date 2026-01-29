/////////////////////////////////////////////////////////////
// Fully 3D-Printable Drone Quick-Release Mount
// Version: Compact 3x4in
// Author: GPT-5 for Advaith Menon John
// Units: millimeters
/////////////////////////////////////////////////////////////

// ---------- USER SETTINGS ----------
part = "both";        // "rail", "adapter", or "both"
tolerance = 0.25;     // clearance for fit (mm)
rail_len = 80;        // overall length (≤100 mm)
rail_w   = 28;        // width (≤76 mm)
rail_h   = 8;         // total height
plate_t  = 2.5;       // base thickness
latch_th = 2.2;       // flex latch thickness
zip_slot_w = 5;       // slot width for zip ties
zip_slot_h = 2.5;     // slot height

$fn = 64;

// ---------- UTILS ----------
module rcube(x,y,z,r=1){hull(){for(dx=[-1,1])for(dy=[-1,1])
  translate([dx*(x/2-r),dy*(y/2-r),0])cylinder(r=r,h=z);}}

// ---------- MALE RAIL (Drone Side) ----------
module rail(){
  // base plate
  rcube(rail_len,rail_w,plate_t,1);
  
  // dovetail ridge
  translate([0,(rail_w-14)/2,plate_t])
    linear_extrude(height=rail_h-plate_t)
      polygon([[0,0],
               [rail_len,0],
               [rail_len-2,4],
               [2,4]]);
  
  // front stop lip
  translate([rail_len-3,(rail_w-16)/2,plate_t])
    cube([3,16,rail_h-plate_t],center=false);
  
  // latch catch window (for snap)
  translate([rail_len/2-4,rail_w/2-2,rail_h-2])
    cube([8,4,2.1],center=false);
  
  // zip-tie slots
  for(y=[-rail_w/2+6,rail_w/2-6])
    translate([rail_len/4,y,plate_t/2])
      rotate([0,90,0])
        cube([rail_len/3,zip_slot_w,zip_slot_h],center=true);
}

// ---------- FEMALE ADAPTER (Tool Side) ----------
module adapter(){
  adapter_len = rail_len-4;
  
  // outer body
  rcube(adapter_len,rail_w+2*tolerance,rail_h+4,1);
  
  // carve dovetail slot
  difference(){
    translate([0,-tolerance,2])
      linear_extrude(height=rail_h)
        offset(r=-tolerance)
          polygon([[0,0],
                   [adapter_len,0],
                   [adapter_len-2,4],
                   [2,4]]);
  }

  // flex latch tongue (springy tab)
  translate([adapter_len/2-6,rail_w/2-2,rail_h+1])
    cube([12,4,latch_th],center=false);
  
  // relief cut under latch to make it flexible
  translate([adapter_len/2-6,rail_w/2-2,rail_h-2])
    cube([12,4,2],center=false);

  // small thumb pad
  translate([adapter_len/2-4,rail_w/2-3,rail_h+latch_th])
    rcube(8,6,1.5,0.6);

  // zip-tie slots
  for(y=[-rail_w/2+6,rail_w/2-6])
    translate([adapter_len/4,y,plate_t/2])
      rotate([0,90,0])
        cube([adapter_len/3,zip_slot_w,zip_slot_h],center=true);
}

// ---------- RENDER ----------
if (part=="rail" || part=="both")
  color("silver") rail();

if (part=="adapter" || part=="both")
  translate([0,rail_w+15,0]) color("orange") adapter();
