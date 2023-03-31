// AWS Tile Maker  W Stallwood - ObjectifyD

//Define variables here 

source_svg = "/Users/wstallwood/Desktop/test.svg";
text = "DynamoDB";
tile_length = 45;
tile_width = 35;
tile_height = 3;
margin = 1 ;
margin_height = 3;
rounding_factor = 2;


//Magnet options, for use on fridge or magnetic whiteboards

magnet = true;
mag_height = 1;
mag_diameter = 8.5;


$fn=50;

font = "Liberation Sans";

letter_size = 4;
letter_height = 5;


//Write the text

module letter(l) {
	// Use linear_extrude() to make the letters 3D objects as they
	// are only 2D shapes when only using text()
	linear_extrude(height = letter_height) {
		text(l, size = letter_size, font = font, halign = "center", valign = "center", $fn = 16);
	}
}


text_height = (tile_length - letter_size);
text_centre = (tile_width / 2);

translate([text_height,text_centre,0]) rotate([0,0,90]) letter(text);



// Make the Tile

margin_length_offset = (tile_length - (margin * 2));
margin_width_offset = (tile_width - (margin * 2));
margin_height_offset = (margin_height / 2);
mag_x_pos = (tile_width / 2);
mag_y_pos = (tile_length /2);
mag_radius = (mag_diameter /2);

difference () {
    minkowski() {
        cube([tile_length,tile_width,tile_height]);
        // rounded corners
        cylinder(r=rounding_factor,h=rounding_factor);
    }
    translate([mag_y_pos,mag_x_pos,0]) {
      if (magnet) cylinder(r=mag_radius,h=mag_height);
     }
    
     translate([margin,margin,margin_height]) {

        minkowski() {
            cube([margin_length_offset,margin_width_offset,margin_height_offset]);
            // rounded corners
            cylinder(r=rounding_factor,h=rounding_factor);
        }
        

    }
    
        
}



// Import the service Icon

module pyramidChildren(height){
    for ( i=[0:1:$children-1])  
      linear_extrude(height = height, scale=1)
        children(i);
 }
 
 
 icon_y_pos = ((tile_length - letter_size) /2);
 icon_x_pos = (tile_width /2);
 icon_resize = ((tile_length * 1.25)/2);
 
 difference () {
 
    translate([icon_y_pos,icon_x_pos,0]) rotate([0,0,90]) resize([icon_resize,0,    letter_height], auto=true) {
        pyramidChildren(letter_height)
        import(file = source_svg, center = true, dpi = 96);
    }
            translate([mag_y_pos,mag_x_pos,0]) {
                if (magnet) cylinder(r=mag_diameter,h=mag_height);
     }
 }