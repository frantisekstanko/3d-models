include <vendor/roundedcube.scad>;

// rendering
$fn       = 128; // increasing this value increases quality
show      = "preview"; // [ "preview" | "print" ]

// measured values
gasketThickness    =   4; // mm
handlebarDiameter  =  32; // mm
flashlightDiameter =  25; // mm
flashlightLength   = 125; // mm

// desired properties
wallThickness              =   5; // mm ; very low value may cause bug of rounded cube
X_handlebarsMountLength    =  20; // mm
Z_flashlightPosition       =  41; // mm ; the distance between the mount and the flashlight
binding_tape_width         =   5; // mm
binding_tape_thickness     =   3;
flashlight_rotation        =   0; // degrees. values [ 0 - 15 ] should be sane enough
bottomOffsetFromHandlerbarsCenter = 5;

//////////////////////////////////////////////////////////
// there is no need to touch any of the following lines //
//////////////////////////////////////////////////////////

_handlebarLength       = 800;
_handlebarDiameter     = handlebarDiameter  + gasketThickness;
_flashlightDiameter    = flashlightDiameter + gasketThickness;
_renderingFix          = 1;
flashlightMountLength  = _handlebarDiameter  + wallThickness*2 + 12; // TODO
_Z_flashlightPosition    = Z_flashlightPosition;
_handlebar_binding_tape_diameter  = _handlebarDiameter  + wallThickness*2;
_flashlight_binding_tape_diameter = _flashlightDiameter + wallThickness;
_handlebar_binding_tape_offset   = 5; // TODO
_flashlight_binding_tape_offset   = 19; // TODO

if (show=="preview"){
    render();
}
else if (show=="print"){
    rotate([0,90,0])
    printable();
}

module render(){
    printable();

    color("#222222")
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

        translate([0,0,_Z_flashlightPosition]) flashlight(_flashlightDiameter);

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
    cylinder(h=_handlebarLength, r1=_handlebarDiameter/2, r2=_handlebarDiameter/2);
}

module flashlight(innerDiameter){
    translate([0,0,_Z_flashlightPosition])
    rotate([90,0,flashlight_rotation])
    cylinder(h=flashlightLength, r1=innerDiameter/2, r2=innerDiameter/2, center=true);
}

module interconnect(){
    middlePartTop    = _Z_flashlightPosition - _flashlightDiameter/2;
    middlePartHeight = middlePartTop - bottomOffsetFromHandlerbarsCenter + _flashlightDiameter/2;
    translate([
        -X_handlebarsMountLength/2,
        -flashlightMountLength/2,
        bottomOffsetFromHandlerbarsCenter
    ])
    cube([
        X_handlebarsMountLength,
        flashlightMountLength,
        middlePartHeight
    ]);
}
