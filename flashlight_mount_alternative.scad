include <vendor/roundedcube.scad>;

// rendering
$fn       = 64; // increasing this value increases quality
explosion = 0;  // mm ; explode parts by this distance

// measured values
gasketThickness    =   4; // mm
handlebarDiameter  =  32; // mm
flashlightDiameter =  25; // mm // 24.1 ?
flashlightLength   = 123; // mm

// desired properties
flashlightPosition         =  41; // mm ; the distance between the mount and the flashlight
wallThickness              =   5; // mm ; very low value may cause bug of rounded cube
interconnectMountThickness =   6; // mm
handlebarsMountLength      =  20; // mm
screwHoleDiameter          = 5.4; // mm
screwMountLength           =  14; // mm ; very low  value may cause bug of rounded cube
screwMountRadius           =   3; // mm ; very high value may cause bug of rounded cube
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
_flashlightPosition    = flashlightPosition + explosion;
_handlebar_binding_tape_diameter  = _handlebarDiameter  + wallThickness*2;
_flashlight_binding_tape_diameter = _flashlightDiameter + wallThickness;
_handlebar_binding_tape_offset   = 5; // TODO
_flashlight_binding_tape_offset   = 19; // TODO

// rotate([0,90,0])
render();

module render(){
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

    // do not print this
    # handlebar();
    # translate([0,0,_flashlightPosition]) flashlight(_flashlightDiameter);
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
    middlePartBase   = interconnectMountThickness - interconnectMountThickness + explosion/2 + 5; // TODO
    middlePartTop    = _flashlightPosition - _flashlightDiameter/2 - interconnectMountThickness;
    middlePartHeight = middlePartTop - middlePartBase - explosion/2 + interconnectMountThickness + _flashlightDiameter/2;
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
