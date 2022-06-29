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
flashlightPosition         =  41; // mm ; the distance between the mount and the flashlight
wallThickness              =   5; // mm ; very low value may cause bug of rounded cube
handlebarsMountLength      =  20; // mm
binding_tape_width         =   5; // mm
binding_tape_thickness     =   3;
flashlight_rotation        =   0; // degrees. values [ 0 - 15 ] should be sane enough

//////////////////////////////////////////////////////////
// there is no need to touch any of the following lines //
//////////////////////////////////////////////////////////

_handlebarLength       = 800;
_handlebarDiameter     = handlebarDiameter  + gasketThickness;
_flashlightDiameter    = flashlightDiameter + gasketThickness;
_renderingFix          = 1;
flashlightMountLength  = _handlebarDiameter  + wallThickness*2 + 12; // TODO
_flashlightPosition    = flashlightPosition;
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

    translate([0,0,_flashlightPosition])
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
        translate([0,0,_flashlightPosition]) flashlight(_flashlightDiameter);

        rotate([0,0,flashlight_rotation])
        union(){
            translate([0,_flashlight_binding_tape_offset,_flashlightPosition])
            rotate([0,0,90])
            binding_tape(_flashlight_binding_tape_diameter);

            translate([0,-_flashlight_binding_tape_offset,_flashlightPosition])
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
    rotate([90,0,flashlight_rotation])
    cylinder(h=flashlightLength, r1=innerDiameter/2, r2=innerDiameter/2, center=true);
}

module interconnect(){
    // middle part
    middlePartBase   = + 5; // TODO
    middlePartTop    = _flashlightPosition - _flashlightDiameter/2 ;
    middlePartHeight = middlePartTop - middlePartBase + _flashlightDiameter/2;
    translate([
        -handlebarsMountLength/2,
        -flashlightMountLength/2,
        middlePartBase
    ])
    cube([
        handlebarsMountLength,
        flashlightMountLength,
        middlePartHeight
    ]);
}
