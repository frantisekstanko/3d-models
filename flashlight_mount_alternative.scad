include <vendor/roundedcube.scad>;

// rendering
$fn       = 256; // increasing this value increases quality
show      = "print"; // [ "preview" | "print" ]

// measured values
gasketThickness    =   4; // mm
flashlightLength   = 125; // mm

// desired properties

// front light
flashlight_rotation           =  0;
X_mountLength                 = 20;
flashlightMountPadding        =  0;
topOffsetFromFlashlightCenter = 12;
mountDiameter                 = 35; // some real life values: 32, 35
flashlightDiameter            = 26; // some real life values: 26 (convoy S21A)
Z_flashlightPosition          = 42; // 41 if mountDiameter==32, 42 if 35

// rear light
// flashlight_rotation           = 14;
// X_mountLength                 = 32;
// flashlightMountPadding        = 10;
// topOffsetFromFlashlightCenter =  8;
// mountDiameter                 = 32;
// flashlightDiameter            = 25;
// Z_flashlightPosition          = 42;

horizontalWallThickness           =  3; // mm ;
verticalWallThickness             =  1; // mm ;
binding_tape_width                =  5; // mm
binding_tape_thickness            =  2;
binding_tape_rotation_corr        =  flashlight_rotation/4;
bottomOffsetFromHandlerbarsCenter =  7;

//////////////////////////////////////////////////////////
// there is no need to touch any of the following lines //
//////////////////////////////////////////////////////////

_handlebarLength       = 800;
_mountDiameter     = mountDiameter  + gasketThickness;
_flashlightDiameter    = flashlightDiameter + gasketThickness;
_renderingFix          = 1;
flashlightMountLength  = _mountDiameter + flashlightMountPadding;
_Z_flashlightPosition    = Z_flashlightPosition;
_handlebar_binding_tape_diameter  = _mountDiameter  + horizontalWallThickness*2;
_flashlight_binding_tape_diameter = _flashlightDiameter + horizontalWallThickness*2;
_handlebar_binding_tape_offset    = X_mountLength/2 - binding_tape_width/2 - verticalWallThickness*2; // TO CHECK
_flashlight_binding_tape_offset   = flashlightMountLength/2 - binding_tape_width/2 - verticalWallThickness*2 - binding_tape_rotation_corr; // TO CHECK

if (show=="preview"){
    render();
}
else if (show=="print"){
    rotate([0,90,0])
    printable();
}

module render(){
    printable();

    color("#444")
    handlebar();

    color("#888888")
    flashlight(_flashlightDiameter);
}

module printable(){
    difference(){
        interconnect();
        handlebar();

        translate([_handlebar_binding_tape_offset,0,0]) // TODO
        binding_tape(_handlebar_binding_tape_diameter);

        translate([-_handlebar_binding_tape_offset,0,0]) // TODO
        binding_tape(_handlebar_binding_tape_diameter);

        flashlight(_flashlightDiameter);

        rotate([0,0,flashlight_rotation])
        union(){
            translate([0,_flashlight_binding_tape_offset,_Z_flashlightPosition])
            rotate([0,0,90])
            binding_tape(_flashlight_binding_tape_diameter);

            translate([0,-_flashlight_binding_tape_offset,_Z_flashlightPosition])
            rotate([0,0,90])
            binding_tape(_flashlight_binding_tape_diameter);
        }
    }
}

module binding_tape(diameter){
    rotate([0,90,0])
    intersection(){
        difference(){
            cylinder(
                h=binding_tape_width,
                r1=diameter/2+binding_tape_thickness,
                r2=diameter/2+binding_tape_thickness,
                center=true);
            cylinder(
                h=binding_tape_width+_renderingFix,
                r1=(diameter/2),
                r2=(diameter/2),
                center=true);
        }
    }
}

module handlebar(){
    translate([-_handlebarLength/2,0,0])
    rotate([0,90,0])
    cylinder(h=_handlebarLength, r1=_mountDiameter/2, r2=_mountDiameter/2);
}

module flashlight(innerDiameter){
    translate([0,0,_Z_flashlightPosition])
    rotate([90,0,flashlight_rotation])
    cylinder(h=flashlightLength, r1=innerDiameter/2, r2=innerDiameter/2, center=true);
}

module interconnect(){
    middlePartTop    = _Z_flashlightPosition - _flashlightDiameter/2 - topOffsetFromFlashlightCenter;
    middlePartHeight = middlePartTop - bottomOffsetFromHandlerbarsCenter + _flashlightDiameter/2;
    translate([
        -X_mountLength/2,
        -flashlightMountLength/2,
        bottomOffsetFromHandlerbarsCenter
    ])
    cube([
        X_mountLength,
        flashlightMountLength,
        middlePartHeight
    ]);
}
