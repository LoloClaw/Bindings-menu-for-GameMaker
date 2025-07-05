///@desc Draws and operates the bindings menu. Put in the draw GUI event
///@param {Asset.GMFont}  font  The font to use in the menu. Please use a font with size 20-30
///@param {real}  y  The top position of the menu, not considering the table descriptions
///@param {real}  x  The middle x position of the menu
///@param {Asset.GMFont} small_font The smaller font for the menu. Suggested size 12-15 fonts
///@param {real}  rows  The max amount of rows in the menu, defaults to 8
///@param {real}  size  The scale of the menu, defaults to 1
function draw_bindings_menu(_font, _ystart, _x, _small_font, _rows = 8, _size = 1)
{
	//variables and text alignemnt setup
	var _max_y = 0; //the maximum y value at the end of the foe loop
	var _width = 400 * _size; //the amount of pixels to the left and right of the table
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(_font); //setting the main font
	var bindings_array = array_filter(global.bindings, bindings_filter); //creates the bindings array filtering out hidden bindings
	
	//drawing the fixed table descriptions
	draw_text_transformed(_x - _width + 10, _ystart - 60 * _size, "Input", _size, _size, 0);
	draw_text_transformed(_x - 5 * _size, _ystart - 60 * _size, "Keyboard", _size, _size, 0);
	draw_text_transformed(_x + _width / 3 + 15, _ystart - 60 * _size, "Mouse", _size, _size, 0);
	draw_text_transformed(_x + _width / 3 * 2 + 10, _ystart - 60 * _size, "Gamepad", _size, _size, 0);
	//sets mode to keyboard, mouse or gamepad depending on wich one is being used
	if (hascontrol) and (binding_iframes < 0) 
	{
		if (keyboard_check_pressed(vk_anykey)) 
		{
			if (mode != "keyboard") binding_iframes = 10;
			mode = "keyboard";
		}
		if (mouse_check_button_pressed(mb_any)) 
		{
			if (mode != "mouse") binding_iframes = 10;
			mode = "mouse";
		}
		if (gamepad_button_check_pressed(global.slot, gp_face1)) 
		{
			if (mode != "gamepad") binding_iframes = 10;
			mode = "gamepad";
		}
	}
	//slot selection
	if (column != -1) and (row != -1) 
	{
		draw_set_color(c_red);
		draw_rectangle(_x + column * _width / 3 + 1, _ystart + row * 60 * _size + 1, _x + (column + 1) * _width / 3, _ystart + (row + 1) * 60 * _size, false); //drawing the selected slot backround
		if (key_check_pressed("Menu_unbind")) and (binding_iframes < 0) and (!choosing) //code to unbind the current binding when the unbinding key is pressed
		{
			binding_iframes = 10;
			global.bindings[page * _rows + row][1][column] = "noone";
		}
		if (key_check_pressed("Menu_select")) and (binding_iframes < 0) and (!choosing) //code to enter key binding mode
		{
			type = column;
			index = page * _rows + row; //setting the index to the one in the controls array
			hascontrol = false;
			choosing = true;
			binding_iframes = 10;
		}
	}
	draw_set_color(c_white);
	
	//main for loop
	for (var i = page * _rows; i < (page + 1) * _rows; i++)
	{
		if (i > array_length(bindings_array) - 1) break; //safety exit
		var item = variable_clone(bindings_array[i]); //variable containing the current binding info like this [name, [keyboard, mouse, gamepad]]
		var _y = _ystart + (i - page * _rows) * 60 * _size; //y position of the rows
		draw_line(_x - _width, _y, _x + _width, _y); //drawing the rows
		
		draw_text_transformed(_x - _width + 15 * _size, _y + 10 * _size, item[0], _size, _size, 0); //drawing the name
		//drawing the sprites in order: keyboard, mouse, gamepad
		if (item[1][0] != "noone") draw_sprite_ext(spr_keyboard, binding_get_image(0, item[1][0]), _x + 40 * _size, _y + 5 * _size, _size, _size, 0, c_white, 1);
		if (item[1][1] != "noone") draw_sprite_ext(spr_mouse, binding_get_image(1, item[1][1]), _x + 40 * _size + _width / 3, _y + 5 * _size, _size, _size, 0, c_white, 1);
		if (item[1][2] != "noone") draw_sprite_ext(spr_playstation, binding_get_image(2, item[1][2]), _x + 40 * _size + _width / 3 * 2, _y + 5 * _size, _size, _size, 0, c_white, 1);
		
		_max_y = _y + 60 * _size; //setting the last row y
	}
	
	if (choosing) //code for setting the new key
	{
		draw_set_color(c_dkgray);
		draw_rectangle(_x + column * _width / 3 + 1, _ystart + row * 60 * _size + 1, _x + (column + 1) * _width / 3, _ystart + (row + 1) * 60 * _size, false); //drawing the background
		draw_set_color(c_white);
		draw_set_font(_small_font);
		draw_text_transformed(_x + column * _width / 3 + 20 * _size, _ystart + row * 60 * _size + 20 * _size, "[Choose key]", _size, _size, 0); //drawing the "choose key" text
		if (binding_iframes < 0)
		{
			if (column == 0) and (keyboard_check_pressed(vk_anykey)) //code for rebinding the keyboard key
			{
				choosing = false;
				hascontrol = true;
				binding_iframes = 10;
				global.bindings[index][1][column] = keyboard_lastkey; //setting the binding
			}
			if (column == 1) and ((mouse_check_button_pressed(mb_any)) or (mouse_wheel_up()) or (mouse_wheel_down())) //code for rebinding the mouse key
			{
				choosing = false;
				hascontrol = true;
				binding_iframes = 10;
				global.bindings[index][1][column] = mouse_lastbutton; //setting the binding if it's a normal button
				if (mouse_wheel_down()) global.bindings[index][1][column] = "down"; //setting the binding for scroll wheel up
				if (mouse_wheel_up()) global.bindings[index][1][column] = "up"; //setting the binding for scroll wheel down
			}
			if (column == 2) //code for rebinding the gamepad key
			{
				//variables setup
				var go_on = false;
				var key = "noone";
				if (global.controller) //checking if a controller is connected
				{
					//this for loop checks which gamepad key is being pressed
					for (var i = 0; i < array_length(global.binding_list[2]); i++)
					{
						//checks for every key if one is being pressed except for stick movement
						if (!is_string(global.binding_list[2][i])) if (gamepad_button_check_pressed(global.slot, global.binding_list[2][i]))
						{
							go_on = true;
							key = global.binding_list[2][i];
							break;
						}
					}
					//checks for stick movement
					if (gamepad_axis_value(global.slot, gp_axislh) > 0.5) 
					{
						go_on = true;
						key = "Lright";
					}
					if (gamepad_axis_value(global.slot, gp_axislh) < -0.5) 
					{
						go_on = true;
						key = "Lleft";
					}
					if (gamepad_axis_value(global.slot, gp_axislv) > 0.5) 
					{
						go_on = true;
						key = "Ldown";
					}
					if (gamepad_axis_value(global.slot, gp_axislv) < -0.5) 
					{
						go_on = true;
						key = "Lup";
					}
					if (gamepad_axis_value(global.slot, gp_axisrh) > 0.5) 
					{
						go_on = true;
						key = "Rright";
					}
					if (gamepad_axis_value(global.slot, gp_axisrh) < -0.5) 
					{
						go_on = true;
						key = "Rleft";
					}
					if (gamepad_axis_value(global.slot, gp_axisrv) > 0.5) 
					{
						go_on = true;
						key = "Rdown";
					}
					if (gamepad_axis_value(global.slot, gp_axisrv) < -0.5) 
					{
						go_on = true;
						key = "Rup";
					}
				}
				if (keyboard_check_pressed(vk_escape)) and (binding_iframes < 0) go_on = true; //safety exit if a player tries to set a gamepad key with no gamepad connected
				if (go_on)
				{
					choosing = false;
					hascontrol = true;
					binding_iframes = 10;
					global.bindings[index][1][column] = key; //sets the new key based on the variables acquired before
				}
			}
		}
		draw_set_font(_font);
	}
	
	draw_line(_x - _width, _max_y, _x + _width, _max_y); //drawing the last row
	//drawing the columns
	draw_line(_x - _width, _ystart, _x - _width, _max_y);
	draw_line(_x, _ystart, _x, _max_y);
	draw_line(_x + _width / 3, _ystart, _x + _width / 3, _max_y);
	draw_line(_x + _width / 3 * 2, _ystart, _x + _width / 3 * 2, _max_y);
	draw_line(_x + _width, _ystart, _x + _width, _max_y);
	
	//active player stuff
	if (hascontrol)
	{
		draw_set_font(_small_font); //sets the font
		draw_binding(_x - _width / 2, _max_y + 10, "change binding:", "Menu_select", "", _size); //draws the binding for selecting
		draw_binding(_x + _width / 2, _max_y + 10, "remove binding:", "Menu_unbind", "", _size); //draws the binding for unbinding
		draw_set_font(_font); //sets the main font again
		if (mode != "mouse") and (binding_iframes <= 0) //moves the selection based on gamepad or keyboard input
		{
			if (key_check("Menu_left")) //moves column left
			{
				column = max(0, column - 1); 
				binding_iframes = 10;
			}
			if (key_check("Menu_right")) //moves column right
			{
				column = min(2, column + 1); 
				binding_iframes = 10;
			}
			if (key_check("Menu_up")) //moves row up
			{
				row = max(0, row - 1); 
				binding_iframes = 10;
			}
			if (key_check("Menu_down")) //moves row down
			{
				row = min(min(_rows - 1, array_length(bindings_array) - page * _rows - 1), row + 1); 
				binding_iframes = 10;
			}
		}
		if (mode == "mouse") //moves the selection based on mouse position
		{
			var _x_mouse = device_mouse_x_to_gui(0); //gets mouse x for the gui
			var _y_mouse = device_mouse_y_to_gui(0); //gets mouse y for the gui
			column = floor((_x_mouse - _x) / (_width / 3)); //sets column
			if (column > 2) or (column < 0) column = -1; //adjusts column
			row = floor((_y_mouse - _ystart) / (60 * _size)); //sets row
			if (row >= _rows) or (row >= array_length(bindings_array) - page * _rows) or (row < 0) row = -1; //adjusts row
		}
		
		//page stuff
		if (mode == "mouse")
		{
			if (page > 0) draw_menu(_x - _width / 2, _max_y + 80 * _size, [["<", variable_instance_set, [id, "page", page - 1]]], _size); //page forward
			if ((page + 1) * _rows < array_length(bindings_array)) draw_menu(_x + _width / 2, _max_y + 80 * _size, [[">", variable_instance_set, [id, "page", page + 1]]], _size); //page back
			draw_menu(_x, _max_y + 40, [["Reset default", set_default_bindings, []], ["Back", exit_menu, [0]]], _size); //menu with 2 options: reset default and back
		}
		else if (!choosing) //checks if it isn't in mouse mode and the player isn't choosing a new binding
		{
			draw_binding(_x, _max_y + 40, "Press", "Menu_reset", "to reset bindings", _size); //draws reset bindings prompt
			if (key_check_pressed("Menu_reset")) and (binding_iframes < 0) set_default_bindings(); //resets bindings
			draw_binding(_x, _max_y + 100, "Press", "Menu_quit", "To go back", _size); //draws the exit menu prompt
			if (key_check_pressed("Menu_quit")) and (binding_iframes < 0) exit_menu() //exits menu
			
			if (page > 0) //goes to the previous page
			{
				draw_binding(_x - _width / 2 - 70 * _size, _max_y + 40, "", "Page_left", "", _size);
				if (key_check_pressed("Page_left")) and (binding_iframes < 0)
				{
					page--;
					row = 0;
					column = 0;
				}
			}
			if ((page + 1) * _rows < array_length(bindings_array)) //goes to the next page
			{
				draw_binding(_x + _width / 2 + 70 * _size, _max_y + 40, "", "Page_right", "", _size);
				if (key_check_pressed("Page_right")) and (binding_iframes < 0) 
				{
					page++;
					row = 0;
					column = 0;
				}
			}
		}
	}
	
	binding_iframes --; //reducing iframes to prevent input overflow
}

///@desc Exits the bindings menu. Change this to go with your game
function exit_menu()
{
	//change this unless using my menu system
	menu_swicth(0);
}

///@desc Set up the menu for bindings, put in the create event
function setup_binding_menu()
{
	hascontrol = true;
	page = 0; //the current page of the menu
	binding_iframes = 0; //iframes for input overflow
	row = 0; //the current selected row
	column = 0; //the current selected column
	
	mode = "mouse"; //the mode, can be "mouse", "keyboard" or "gamepad"
	if (global.controller) mode = "gamepad"; //sets the mode as gamepad if one is connected
	choosing = false; //when this variable is true, the player is choosing a new binding
	index = 0; //the current index in the bindings array
	type = 0; //the binding type
	
	setup_menu() //sets up the regular menu for some stuff in the binding menu
}

///@desc Filtering function for the bindings, hides all the hidden bindings
function bindings_filter(element, index)
{
	if (element[2]) return false
	else return true;
}