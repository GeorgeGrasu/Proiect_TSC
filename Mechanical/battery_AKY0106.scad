// =============================================================================
// InkTime Smartwatch - Battery 3D Model
// Component: Akyga AKY0106 (LP502030) LiPo Battery
// Dimensions from datasheet: 30 x 20 x 5 mm (L x W x H)
// Capacity: 250 mAh, Voltage: 3.7V
// =============================================================================
// Note: Battery will be soldered directly to test pads on the PCB
// (no JST connector used, to save space)
// =============================================================================

module battery_AKY0106() {
    // Main battery body dimensions (mm)
    battery_length = 30;
    battery_width  = 20;
    battery_height = 5;
    
    // Corner radius for the pouch cell
    corner_r = 1.5;
    
    color("Silver", 0.85)
    translate([0, 0, battery_height/2])
    minkowski() {
        cube([
            battery_length - 2*corner_r,
            battery_width - 2*corner_r,
            battery_height - 1
        ], center=true);
        cylinder(r=corner_r, h=0.5, $fn=32);
    }
    
    // Solder tab / wire leads (simplified - 2 pads)
    // Positive tab
    color("Red")
    translate([battery_length/2, battery_width/4, battery_height/2])
    cube([3, 2, 0.2], center=true);
    
    // Negative tab
    color("Black")
    translate([battery_length/2, -battery_width/4, battery_height/2])
    cube([3, 2, 0.2], center=true);
    
    // Label on battery
    color("DimGray")
    translate([0, 0, battery_height + 0.01])
    linear_extrude(0.1)
    text("LP502030", size=3, halign="center", valign="center", font="Liberation Sans:style=Bold");
}

// Render the battery
battery_AKY0106();
