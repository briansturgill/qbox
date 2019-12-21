# qbox
Quickly create boxes in OpenSCAD.

The whole project is geared toward the 3D printing of boxes, though it could be used elsewhere.

Not quite ready for prime time yet -- documentation being the major missing piece.

If you want to get started anyway, I suggest starting with examples/intercom.scad
This is a real world example of a box that holds an ESP8266-based intercom.
The CPU itself is on a solderless breadboard, with its USB port lining up with the USB slot in the model.

## A quick guide to qbox

Choose one of simple_box or filleted_box.

At the top of the source code of your chosen box, there is a comment containing lines of OpenSCAD code. Use this as your template. You can also start with one of the files in `examples`.

In the examples for these boxes you will see functions that create the box, the lid, etc.

Each of these functions (called modules by OpenSCAD), has code of this form:
```OpenSCAD
    difference() {
        union() {
            box(); // Create the box or lid or body...
            left(d/2, 2*(h/3)) component(); // Create a component on the left workplane.
						// Other components THAT ARE NOT HOLES OR MARKERS GO here.
        }
				// Holes and Markers go here.
        right(d/2, h-15) horizontal_slot_hole(12, 7); // Slot for micro-usb
        left(d/2, 2*(h/3)) bme280_hole();
        left(d/2, 2*(h/3)) bme280_marker();
    }
```

Functions ending with _hole() or _holes() or _marker() must appear in the difference section as they are removed.
All other components are drawn (rather than subtracted) and appear in the union.


## Workplanes
Workplanes are a concept from most cad systems and represent the 2D drawings you'll make when you
design your box.

Look at your box from its width (called 'w' in the code), with its depth (called 'd') extending away from you.
The OpenSCAD  x, y, and z origin is the left, front, bottom corner *inside* the box.

Workplanes left, right, front, back and bottom for boxes are the corresponding planes *inside* the box.

It works the same way for lids, but as the lids are shown as if they are boxes (i.e. the lid's "top" is downward when you view the model in OpenSCAD) the "bottom" plane refers to the underside of the lids top.

For bodies, they are the same as boxes but have a separate bottom (to allow printing in a different color).

# Components

Draw all components at the origin.
Round (and a few exceptions) are centered over the origin.
All others are drawn with origin at its bottom left corner.

Components that need to make a hole, are drawn inverse.
In other words, you draw a solid that will used as the shape of what is to be removed.

Markers are for components that are on the side, but are too complex to be 3d printed there without supports. Essentially a marker is a tiny hole used to mark the position where the separately printed component will be glued (use super glue with PLA).


## utility.scad vs components.scad

Both of these files contain components (utility has a few additional functions). The components in utility.scad are intended for use in boxes (like filleted_box.scad) and projects (such as found in examples). The ones in components.scad are intended for projects only.
