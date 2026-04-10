// =============================================================================
// InkTime Smartwatch - E-Paper Display 3D Model
// Component: Waveshare WSH-12561 (1.54" E-Paper Display)
// External Dimensions: 31.80 x 37.32 x 1.05 mm
// Display Active Area: 27.60 x 27.60 mm (200x200 pixels)
// Connector: 24-pin 0.5mm pitch FPC (rear-flip, 2.0H)
// =============================================================================

module display_WSH12561() {
    // External dimensions (mm)
    ext_width  = 31.80;
    ext_height = 37.32;
    ext_depth  = 1.05;
    
    // Active display area (mm)
    disp_width  = 27.60;
    disp_height = 27.60;
    
    // Display offset from edges (centered horizontally, offset vertically)
    disp_x_offset = (ext_width - disp_width) / 2;
    disp_y_offset = 5.0;  // offset from bottom edge
    
    // FPC cable dimensions
    fpc_width  = 13.0;   // 24 pins at 0.5mm pitch + margins
    fpc_length = 15.0;   // cable length extending from panel
    fpc_thick  = 0.3;    // FPC cable thickness
    
    // --- Main panel body ---
    color("DimGray", 0.9)
    cube([ext_width, ext_height, ext_depth]);
    
    // --- Active display area (white e-paper surface) ---
    color("White", 0.95)
    translate([disp_x_offset, disp_y_offset, ext_depth - 0.01])
    cube([disp_width, disp_height, 0.15]);
    
    // --- Thin bezel frame around active area ---
    color("Black", 0.8)
    translate([disp_x_offset - 0.3, disp_y_offset - 0.3, ext_depth + 0.13])
    difference() {
        cube([disp_width + 0.6, disp_height + 0.6, 0.05]);
        translate([0.3, 0.3, -0.1])
        cube([disp_width, disp_height, 0.3]);
    }
    
    // --- FPC cable ---
    color("Orange", 0.7)
    translate([(ext_width - fpc_width) / 2, ext_height, 0])
    cube([fpc_width, fpc_length, fpc_thick]);
    
    // --- FPC connector pads (gold-colored contact strips) ---
    color("Gold")
    translate([(ext_width - fpc_width) / 2 + 0.5, ext_height - 0.5, ext_depth - 0.3])
    for (i = [0:23]) {
        translate([i * 0.5, 0, 0])
        cube([0.3, 0.5, 0.3]);
    }
}

// Render the display
display_WSH12561();
