// =============================================================================
// InkTime Smartwatch - Full Device Assembly (Exploded View)
// =============================================================================
// This file combines all components:
//   1. Enclosure / Case (approximation based on inktime_case.f3z shape)
//   2. E-Paper Display (WSH-12561)
//   3. PCB (custom board outline)
//   4. Battery (AKY0106 / LP502030)
//   5. Shaker Motor (FIT0774)
// =============================================================================
// To generate an exploded view, set explode = 1
// To generate assembled view, set explode = 0
// =============================================================================

// ===== CONFIGURATION =====
explode = 1;              // 0 = assembled, 1 = exploded view
explode_distance = 15;     // mm between layers in exploded view

// ===== IMPORTS =====
use <battery_AKY0106.scad>
use <display_WSH12561.scad>
use <shaker_FIT0774.scad>

// ===== PCB DIMENSIONS (approximate from board file) =====
// The PCB has a custom watch-shaped outline
pcb_width    = 36.0;    // approximate X dimension
pcb_height   = 40.0;    // approximate Y dimension
pcb_thick    = 1.6;     // standard FR-4 thickness

// ===== CASE DIMENSIONS (approximate from inktime_case.f3z) =====
case_width    = 38.0;
case_height   = 42.0;
case_depth    = 12.0;   // total case depth
case_wall     = 1.0;    // wall thickness
case_corner_r = 5.0;    // corner radius

// =============================================================================
// MODULE: Simplified PCB Outline
// =============================================================================
module pcb_board() {
    color("Green", 0.85)
    translate([0, 0, 0])
    linear_extrude(pcb_thick) {
        // Main body - rounded rectangle
        offset(r=3) offset(r=-3)
        union() {
            // Main rectangular area
            translate([-pcb_width/2, -pcb_height/2])
            square([pcb_width, pcb_height]);
        }
    }
    
    // USB-C connector cutout area (simplified block)
    color("Silver", 0.9)
    translate([-4.5, pcb_height/2 - 2, 0])
    cube([9, 7.5, 3.2]);
    
    // Buttons (3x side buttons on left edge) 
    for (i = [-1:1]) {
        color("DarkGray")
        translate([-pcb_width/2 - 1.5, i * 8, 0.3])
        cube([3, 3.5, 1.5]);
    }
    
    // BGA nRF52840 (center of board)
    color("DimGray")
    translate([-3.5, -3.5, pcb_thick])
    cube([7, 7, 0.85]);
    
    // Label on IC
    color("White")
    translate([0, 0, pcb_thick + 0.86])
    linear_extrude(0.05)
    text("nRF52840", size=1.5, halign="center", valign="center", font="Liberation Sans:style=Bold");
    
    // BMA423 IMU (bottom-left area)
    color("DimGray")
    translate([-14, -12, pcb_thick])
    cube([2, 2, 0.9]);
    
    // MAX17048 Fuel Gauge
    color("DimGray")
    translate([10, -8, pcb_thick])
    cube([2, 2, 0.8]);
    
    // BQ25180 Charger IC
    color("DimGray")
    translate([3, -8, pcb_thick])
    cube([1.6, 1.0, 0.5]);
    
    // RT6160A DC/DC
    color("DimGray")
    translate([-6, -7, pcb_thick])
    cube([2.3, 1.4, 0.6]);
    
    // DRV2605 Haptic Driver
    color("DimGray")
    translate([8, 5, pcb_thick])
    cube([1.44, 1.44, 0.62]);
    
    // E-Paper display connector (24-pin FPC)
    color("Tan")
    translate([6, 0, pcb_thick])
    cube([14, 3, 1.0]);
    
    // TC2030 debug header
    color("Gold")
    translate([8, 12, pcb_thick])
    for (r = [0:1]) {
        for (c = [0:2]) {
            translate([c * 1.27, r * 1.27, 0])
            cylinder(h=0.5, r=0.35, $fn=16);
        }
    }
    
    // Antenna area (chip antenna at edge)
    color("Gold")
    translate([pcb_width/2 - 5, 3, pcb_thick])
    cube([3.2, 1.6, 0.5]);
    
    // Crystals
    color("Silver")
    translate([-4, 4, pcb_thick])
    cube([2.0, 1.6, 0.6]);
    
    color("Silver")
    translate([2, 3, pcb_thick])
    cube([3.2, 1.5, 0.9]);
    
    // Various capacitors/resistors (0201 footprints scattered)
    color("Tan")
    for (i = [0:15]) {
        translate([
            -pcb_width/2 + 4 + (i % 4) * 7,
            -pcb_height/2 + 5 + floor(i / 4) * 8,
            pcb_thick
        ])
        cube([0.6, 0.3, 0.3]);
    }
    
    // Test pads (gold circles on various locations)
    color("Gold")
    for (pos = [
        [-12, 14], [12, 14], [-12, -14], [12, -14],
        [-15, 0], [15, 0], [-15, 8], [15, 8],
        [0, 16], [0, -16]
    ]) {
        translate([pos[0], pos[1], pcb_thick])
        cylinder(h=0.1, r=0.5, $fn=16);
    }
}

// =============================================================================
// MODULE: Case Bottom
// =============================================================================
module case_bottom() {
    color("DarkSlateGray", 0.8)
    difference() {
        // Outer shell
        translate([0, 0, 0])
        minkowski() {
            translate([-case_width/2 + case_corner_r, -case_height/2 + case_corner_r, 0])
            cube([
                case_width - 2*case_corner_r,
                case_height - 2*case_corner_r,
                case_depth/2 - 1
            ]);
            cylinder(r=case_corner_r, h=0.5, $fn=48);
        }
        
        // Inner cavity
        translate([0, 0, case_wall])
        minkowski() {
            translate([
                -case_width/2 + case_corner_r + case_wall,
                -case_height/2 + case_corner_r + case_wall,
                0
            ])
            cube([
                case_width - 2*(case_corner_r + case_wall),
                case_height - 2*(case_corner_r + case_wall),
                case_depth/2
            ]);
            cylinder(r=case_corner_r - case_wall/2, h=0.1, $fn=48);
        }
        
        // Button cutouts (3x on left side)
        for (i = [-1:1]) {
            translate([-case_width/2 - 1, i * 8 - 2, case_wall + 1])
            cube([case_wall + 2, 4, 2.5]);
        }
        
        // USB-C cutout
        translate([-5, case_height/2 - 1, case_wall + 1])
        cube([10, case_wall + 2, 4]);
    }
}

// =============================================================================
// MODULE: Case Top (glass/cover)
// =============================================================================
module case_top() {
    disp_window_w = 28.5;
    disp_window_h = 28.5;
    
    color("DarkSlateGray", 0.6)
    difference() {
        // Cover plate
        minkowski() {
            translate([
                -case_width/2 + case_corner_r,
                -case_height/2 + case_corner_r,
                0
            ])
            cube([
                case_width - 2*case_corner_r,
                case_height - 2*case_corner_r,
                1.5
            ]);
            cylinder(r=case_corner_r, h=0.2, $fn=48);
        }
        
        // Display window cutout
        translate([-disp_window_w/2, -disp_window_h/2 - 1, -0.5])
        cube([disp_window_w, disp_window_h, 3]);
    }
    
    // Transparent glass over display
    color("LightBlue", 0.2)
    translate([-disp_window_w/2, -disp_window_h/2 - 1, 0.2])
    cube([disp_window_w, disp_window_h, 0.8]);
}

// =============================================================================
// ASSEMBLY
// =============================================================================

// Layer offsets (from bottom)
z_case_bottom = 0;
z_battery     = case_wall + 0.5;
z_shaker      = case_wall + 0.5;
z_pcb         = z_battery + 5.5;
z_display     = z_pcb + pcb_thick + 0.5;
z_case_top    = z_display + 1.2;

// Explode multiplier
e = explode ? explode_distance : 0;

// --- Case Bottom ---
translate([0, 0, z_case_bottom - e * 2])
    case_bottom();

// --- Battery ---
translate([-15, -10, z_battery - e * 1])
    battery_AKY0106();

// --- Shaker Motor ---
translate([12, -12, z_shaker - e * 1])
    shaker_FIT0774();

// --- PCB ---
translate([0, 0, z_pcb])
    pcb_board();

// --- Display ---
translate([-31.80/2, -37.32/2 - 1, z_display + e * 1])
    display_WSH12561();

// --- Case Top ---
translate([0, 0, z_case_top + e * 2])
    case_top();

// --- Assembly labels (only in exploded view) ---
if (explode) {
    color("Black")
    translate([25, 0, z_case_top + e * 2 + 1])
    linear_extrude(0.1)
    text("Case Top", size=3, font="Liberation Sans");
    
    color("Black")
    translate([25, 0, z_display + e * 1 + 1])
    linear_extrude(0.1)
    text("E-Paper Display", size=3, font="Liberation Sans");
    
    color("Black")
    translate([25, 0, z_pcb + 1])
    linear_extrude(0.1)
    text("PCB", size=3, font="Liberation Sans");
    
    color("Black")
    translate([25, 0, z_battery - e * 1 + 1])
    linear_extrude(0.1)
    text("Battery + Shaker", size=3, font="Liberation Sans");
    
    color("Black")
    translate([25, 0, z_case_bottom - e * 2 + 1])
    linear_extrude(0.1)
    text("Case Bottom", size=3, font="Liberation Sans");
}
