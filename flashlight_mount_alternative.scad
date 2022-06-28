include <vendor/roundedcube.scad>;

// rendering
$fn       = 32; // increasing this value increases quality
explosion = 5;  // mm ; explode parts by this distance

// measured values
gasketThickness    =   3.95; // mm
handlebarDiameter  =  32.00; // mm
flashlightDiameter =  26.45; // mm // 24.1 ?
flashlightLength   = 123.00; // mm

// desired properties
flashlightPosition         =  45; // mm ; the distance between the mount and the flashlight
wallThickness              =   5; // mm ; very low value may cause bug of rounded cube
interconnectMountThickness =   6; // mm
handlebarsMountLength      =  25; // mm
screwHoleDiameter          = 5.4; // mm
screwMountLength           =  14; // mm ; very low  value may cause bug of rounded cube
screwMountRadius           =   3; // mm ; very high value may cause bug of rounded cube
binding_tape_width         =   5; // mm
binding_tape_thickness     =   4;

//////////////////////////////////////////////////////////
// there is no need to touch any of the following lines //
//////////////////////////////////////////////////////////

_handlebarLength       = 800;
_handlebarDiameter     = handlebarDiameter  + gasketThickness;
_flashlightDiameter    = flashlightDiameter + gasketThickness;
_renderingFix          = 1;
_screwMountLength      = screwMountLength + wallThickness;
screwCircleDiameter    = _flashlightDiameter + _screwMountLength + screwHoleDiameter + wallThickness;
flashlightMountLength  = _handlebarDiameter  + wallThickness*2;
_flashlightPosition    = flashlightPosition + explosion;
_binding_tape_diameter = handlebarDiameter + binding_tape_thickness + wallThickness * 3; // TO CHECK
_binding_tape_offset   = 6; // TODO

render();

module render(){
    // top/flashlight mount
    // rotate([90,0,0])
    translate([0,0,_flashlightPosition])
    mount(_flashlightDiameter, wallThickness, flashlightMountLength, _screwMountLength, screwHoleDiameter);
    
    // middle part
    // rotate([0,180,0])
    difference(){
        interconnect();
        handlebar();
        translate([_binding_tape_offset,0,0]) // TODO
        zdrhavacka();
        translate([-_binding_tape_offset,0,0]) // TODO
        zdrhavacka();
    }

    // do not print this
    # handlebar();
    # translate([0,0,_flashlightPosition]) flashlight(_flashlightDiameter);
}

module zdrhavacka(){
    rotate([0,90,0])
    intersection(){
        difference(){
            cylinder(
                h=binding_tape_width,
                r1=_binding_tape_diameter/2+binding_tape_thickness,
                r2=_binding_tape_diameter/2+binding_tape_thickness,
                center=true);
            cylinder(
                h=binding_tape_width+_renderingFix,
                r1=(_binding_tape_diameter/2),
                r2=(_binding_tape_diameter/2),
                center=true);
        }
    }
}

module mount(innerDiameter, wallThickness, mountLength, mountSize, screwHoleSize){
    outerDiameter = innerDiameter+wallThickness*2;
    difference(){
        rotate([90,0,0])
        cylinder(
            h=mountLength,
            r1=outerDiameter/2,
            r2=outerDiameter/2,
            center=true
        );
        translate([0,0,-outerDiameter/2])
        cube([
            outerDiameter+_renderingFix,
            mountLength+_renderingFix,
            outerDiameter
        ], center=true);
        flashlight(innerDiameter);
    }

    // >>>
    union(){
        translate([
            -outerDiameter/2 - mountSize/2 + wallThickness,
            0,
            -innerDiameter/2 + wallThickness/2
        ])
        submount(mountSize, mountLength, wallThickness, screwHoleSize);
    }
    // <<<

    // >>>
    translate([
        -outerDiameter/2,
        -mountLength/2,
        -innerDiameter/2
    ])
    cube([wallThickness,mountLength,innerDiameter/2]);

    translate([
        outerDiameter/2 - wallThickness,
        -mountLength/2,
        -innerDiameter/2
    ])
    cube([wallThickness,mountLength,innerDiameter/2]);
    // <<<
}

module handlebar(){
    translate([-_handlebarLength/2,0,0])
    rotate([0,90,0])
    cylinder(h=_handlebarLength, r1=_handlebarDiameter/2, r2=_handlebarDiameter/2);
}

module flashlight(innerDiameter){
    rotate([90,0,0])
    cylinder(h=flashlightLength, r1=innerDiameter/2, r2=innerDiameter/2, center=true);
}

module submount(mountSize, length, wallThickness, screwHoleSize){
    difference(){
        union(){
            customRoundedCubeZ(mountSize, length, wallThickness, screwMountRadius);
            translate([0,-length/2,-wallThickness/2])
            cube([mountSize/2,length,wallThickness]);
        }
        translate([-wallThickness/2,0,-wallThickness])
        cylinder(r1=screwHoleSize/2,r2=screwHoleSize/2,h=wallThickness*2);
    }
}

module interconnect(){
    toffset = 20; // TODO
    bw = screwMountLength + wallThickness + toffset;
    outerDiameter = _flashlightDiameter+wallThickness*2;
    // top part
    translate([
        0,
        0,
        _flashlightPosition - _flashlightDiameter/2 - interconnectMountThickness/2 - explosion/2
    ])
    difference(){
        color("red")
        translate([
            -outerDiameter/2 - _screwMountLength/2 + wallThickness + toffset/2,
            0,
            0,
        ])
        union(){
            customRoundedCubeZ(
                bw,
                flashlightMountLength,
                interconnectMountThickness,
                screwMountRadius
            );
        }
        intersection(){
            difference(){
                cylinder(h=100,r1=screwCircleDiameter/2,r2=screwCircleDiameter/2, center=true);
                cylinder(h=100+_renderingFix,r1=(screwCircleDiameter)/2-screwHoleDiameter,r2=(screwCircleDiameter)/2-screwHoleDiameter, center=true);
            }
            translate([-20,0,0]) // TODO FIX
            cube([
                40, // TODO FIX
                flashlightMountLength-interconnectMountThickness*2,
                interconnectMountThickness*2
            ], center=true);
        }
    }

    // middle part
    middlePartBase   = interconnectMountThickness - interconnectMountThickness + explosion/2;
    middlePartTop    = _flashlightPosition - _flashlightDiameter/2 - interconnectMountThickness;
    middlePartHeight = middlePartTop - middlePartBase - explosion/2 + interconnectMountThickness;
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

module customRoundedCubeZ(x, y, z, radius){
    intersection(){
        roundedcube([x,y,z*2], true, radius, apply_to = "z");
        cube([x*2,y*2,z], true);
    }
}
