///@desc Draws some text, the binding and some other text in order.
///@arg {real} x The x posistion for the text, in the middle
///@arg {real} y The y position for the text
///@arg {string} pre_text The text before the binding
///@arg {string} binding The display name for the binding
///@arg {string} post_text The text after the binding
///@arg {real} size The size of the bindings, defaults to 1
function draw_binding(_x, _y, _pre_text, _binding, _post_text, _size = 1)
{
	//set alignment and variables
	var font_size = font_get_size(draw_get_font()); //gets font size
	var _size_img = (font_size / 50) * _size; //sets image size to fit with the font size
	draw_set_valign(fa_top);
	if (key_get_index(_binding) == -1) return -1; //stops everything if the binding doesn't exist
	var item = global.bindings[key_get_index(_binding)]; //gets the binding
	var image_width = 10 * _size;
	var pre_width = string_width(_pre_text); //first string width
	var post_width = string_width(_post_text); //last string width
	var total_width  = variable_clone(pre_width + post_width + 50 * _size_img); //calculate the total width of the text
	if (global.controller) //checks if controller is connected
	{
		//draws the binding and sets the size
		image_width = 50 * _size_img;
		draw_sprite_ext(spr_playstation, binding_get_image(2, item[1][2]), _x + total_width / 2 - post_width - 55 * _size_img, _y, _size_img, _size_img, 0, c_white, draw_get_alpha());
		image_width += 10 * _size_img;
	}
	else
	{
		if (item[1][0] == "noone") and (item[1][1] != "noone") //checks if only the mouse is bound
		{
			image_width = 50 * _size_img;
			draw_sprite_ext(spr_mouse, binding_get_image(1, item[1][1]), _x + total_width / 2 - post_width - 55 * _size_img, _y, _size_img, _size_img, 0, c_white, draw_get_alpha());
		}
		if (item[1][1] == "noone") and (item[1][0] != "noone") //checks if only the keyboard is bound
		{
			image_width = 50 * _size_img;
			draw_sprite_ext(spr_keyboard, binding_get_image(0, item[1][0]) ,_x + total_width / 2 - post_width - 55 * _size_img, _y, _size_img, _size_img, 0, c_white, draw_get_alpha());
		}
		if (item[1][1] != "noone") and (item[1][0] != "noone") //checks if both the keyboard and mouse are bound
		{
			image_width = 110 * _size_img;
			total_width  = pre_width + post_width + 110 * _size_img;
			draw_sprite_ext(spr_mouse, binding_get_image(1, item[1][1]), _x + total_width / 2 - post_width - 55 * _size_img, _y, _size_img, _size_img, 0, c_white, draw_get_alpha());
			draw_sprite_ext(spr_keyboard, binding_get_image(0, item[1][0]), _x + total_width / 2 - post_width - 110 * _size_img, _y, _size_img, _size_img, 0, c_white, draw_get_alpha());
		}
		image_width += 10 * _size_img;
	}

	draw_set_halign(fa_right)
	draw_text_transformed(_x + total_width / 2 - post_width - image_width, _y - font_size / 2 + 5, _pre_text, _size, _size, 0); //draws pre-text
	draw_set_halign(fa_left);
	draw_text_transformed(_x + total_width / 2 - post_width, _y - font_size / 2 + 5, _post_text, _size, _size, 0); //draws post-text
}