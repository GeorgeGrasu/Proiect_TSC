// =============================================================================
// InkTime Smartwatch - Shaker/Vibration Motor 3D Model
// Component: DFRobot FIT0774 Coin Vibration Motor
// Dimensions: Diameter 10 mm, Thickness 2.7 mm
// Specifications: DC 1.5-4.2V, Rated 3V/50mA, 11000±2500 RPM
// =============================================================================

module shaker_FIT0774() {
    // Motor dimensions (mm)
    diameter  = 10.0;
    radius    = diameter / 2;
    thickness = 2.7;
    
    // Wire dimensions
    wire_length  = 12.0;
    wire_radius  = 0.25;
    wire_spacing = 2.0;
    
    // --- Main motor body (cylindrical coin motor) ---
    color("Silver", 0.9)
    cylinder(h=thickness, r=radius, $fn=64);
    
    // --- Top label/marking circle ---
    color("DimGray", 0.6)
    translate([0, 0, thickness - 0.01])
    cylinder(h=0.05, r=radius * 0.7, $fn=64);
    
    // --- Eccentric weight (visible as a bump on top) ---
    color("Copper")
    translate([radius * 0.3, 0, thickness])
    scale([1, 0.6, 1])
    cylinder(h=0.3, r=radius * 0.35, $fn=32);
    
    // --- Thin adhesive backing ---
    color("White", 0.5)
    translate([0, 0, -0.1])
    cylinder(h=0.1, r=radius, $fn=64);
    
    // --- Wire leads ---
    // Positive (red)
    color("Red")
    translate([wire_spacing/2, -radius + 1, thickness/2])
    rotate([-90, 0, 0])
    cylinder(h=wire_length, r=wire_radius, $fn=16);
    
    // Negative (blue/black)
    color("Blue")
    translate([-wire_spacing/2, -radius + 1, thickness/2])
    rotate([-90, 0, 0])
    cylinder(h=wire_length, r=wire_radius, $fn=16);
}

// Render the shaker motor
shaker_FIT0774();
