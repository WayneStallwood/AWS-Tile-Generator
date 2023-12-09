// AWS Tile Maker  W Stallwood - ObjectifyD.xyz

//Define variables here 

source_svg = "/path/to/icons/Glue_64.svg";
text = "Glue";
tile_length = 50;
tile_width = 40;
tile_height = 3;
margin = 1 ;
margin_height = tile_height;
rounding_factor = 2;


//Magnet options, for use on fridge or magnetic whiteboards

magnet = true;
mag_height = 1.2;
mag_diameter = 8.5;


$fn=50;

font = "Liberation Sans";

letter_size = 4;
letter_height = 1;

// Round corners alter dimensions
final_width  = (tile_width - (rounding_factor * 2));
final_length = (tile_length - (rounding_factor * 2));

//Write the text

module letter(l) {
	// Use linear_extrude() to make the letters 3D objects as they
	// are only 2D shapes when only using text()
	linear_extrude(height = letter_height) {
		text(l, size = letter_size, font = font, halign = "center", valign = "center", $fn = 16);
	}
}


text_height = (final_length - letter_size);
text_centre = (final_width / 2);

translate([text_height,text_centre,tile_height]) rotate([0,0,90]) letter(text);



// Make the Tile

margin_length_offset = (final_length - (margin * 2));
margin_width_offset = (final_width - (margin * 2));
margin_height_offset = (margin_height / 2);
mag_x_pos = (final_width / 2);
mag_y_pos = (final_length /2);
mag_radius = (mag_diameter /2);

difference () {
    minkowski() {
        cube([final_length,final_width,tile_height]);
        // rounded corners
        cylinder(r=rounding_factor,h=letter_height);
    }
    translate([mag_y_pos,mag_x_pos,0]) {
      if (magnet) cylinder(r=mag_radius,h=mag_height);
     }
    
     translate([margin,margin,margin_height]) {

        minkowski() {
            cube([margin_length_offset,margin_width_offset,margin_height_offset]);
            // rounded corners
            cylinder(r=rounding_factor,h=letter_height);
        }
        

    }
    
        
}



// Import the service Icon

module pyramidChildren(height){
    for ( i=[0:1:$children-1])  
      linear_extrude(height = height, scale=1)
        children(i);
 }
 
 
 icon_y_pos = ((final_length - letter_size) /2);
 icon_x_pos = (final_width /2);
 icon_resize = ((final_length * 1.25)/2);

 difference () {
 
    translate([icon_y_pos,icon_x_pos,tile_height]) rotate([0,0,90]) resize([icon_resize,0,    letter_height], auto=true) {
        pyramidChildren(letter_height)
        import(file = source_svg, center = true, dpi = 96);
    }
            translate([mag_y_pos,mag_x_pos,0]) {
                if (magnet) cylinder(r=mag_diameter,h=mag_height);
     }
 }
