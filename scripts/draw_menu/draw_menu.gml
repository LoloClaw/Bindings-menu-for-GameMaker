///@function Draws a menu vertically with the current font and color, put in the draw GUI event
///@param {real} x The x position for the middle of the menu
///@param {real} y The y position for the top of the menu
///@param {array} options The options for the menu as an array, write like this: [[name1, function1, arguments1], [name2, function2, arguments2], ...]. For switch and list see function page
//switch and list options
//Set function to "switch" and arguments to [global variable (as a string), inverted (boolean)] to make that entry boolean. 
//Set function to "options" and arguments to [global_variable (string), option1 (str), option2 (str), ...] to make it a list
///@param {real} size The size for the menu. Defaults to 1.
function draw_menu(_x, _y, _arguments, _size = 1)
{
	//sorry the code is kinda bad in this, hope you won't have too much trouble :)
	//Sets up variables
	var _mouse_x = device_mouse_x_to_gui(0); //gets mouse x
	var _mouse_y = device_mouse_y_to_gui(0); //gets mouse y
	var height = (string_height("H") + 10) * _size; //sets height
	
	if (mouse_check_button(mb_left)) //checks if to activate mouse mode
	{
		if (!mouse)
		{	
			mouse = true;
			if (selected != round((_mouse_y - _y) / height)) menu_iframes = 10;
		}
	}
	if ((keyboard_check_pressed(vk_anykey)) or (global.controller)) and (menu_iframes < 0) mouse = false; //checks to deactivate mouse mode
	
	if (mouse) selected = round((_mouse_y - _y) / height); //gets the selected entry for the mouse
	else if (menu_iframes < 0) 
	{
		if (key_check("Menu_up")) or (key_check("Menu_down")) menu_iframes = 10;
		selected = clamp(selected + key_check("Menu_down") - key_check("Menu_up"), 0, array_length(_arguments) - 1) //siwtches selections for the keyboard and gamepads
	}
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);
	var width = 0;
	menu_iframes --; //reduces iframes
	
	for (var i = 0; i < array_length(_arguments); i++) //main for loop
	{
		var ypos = _y + i * height; //y position of the entry
		if (_arguments[i][1] == "switch") //checks if in switch mode
		{
			var _text = "[  ]";
			if (variable_global_get(_arguments[i][2][0])) and (!variable_global_get(_arguments[i][2][1])) _text = "[X]";
			if (!variable_global_get(_arguments[i][2][0])) and (variable_global_get(_arguments[i][2][1])) _text = "[X]";
			_arguments[i][0] += "  " + _text;
		}
		if (_arguments[i][1] == "options") //checks if in options mode
		{
			var _options = variable_clone(_arguments[i][2]);
			array_delete(_options, 0, 1);
			_arguments[i][0] += "  " + _options[variable_global_get(_arguments[i][2][0])];
		}
		width = (string_width(_arguments[i][0]) + 10) * _size; //sets the width of the entry
		draw_text_transformed(_x, ypos, _arguments[i][0], _size, _size, 0); //draws the entry
		if ((_mouse_x > _x - width / 2) and (_mouse_x < _x + width / 2)) or (!mouse) //checks if the mouse is on the menu or the keyboard/gamepad are being used
		{
			if (selected == i) draw_rectangle(_x - width / 2, ypos + height / 2, _x + width / 2, ypos - height / 2, true); //draws the outline
			if (key_check_pressed("Menu_select")) and (i == selected) and ((menu_iframes < 0)) //checks if the function can be called
			{
				if (!is_string(_arguments[i][1])) script_execute_ext(_arguments[i][1], _arguments[i][2]); //executes the function
				else //execute the switch or options functions
				{
					if (_arguments[i][1] == "switch") variable_global_set(_arguments[i][2][0], !variable_global_get(_arguments[i][2][0]));
					if (_arguments[i][1] == "options")
					{
						variable_global_set(_arguments[i][2][0], variable_global_get(_arguments[i][2][0]) + 1);
						if (variable_global_get(_arguments[i][2][0]) >= array_length(_arguments[i][2]) - 1) variable_global_set(_arguments[i][2][0], 0);
					}
				}
			}
		}
	}
}

///@desc Switches menu page
///@param {real} menu The page to switch to
///@param {real} iframes The iframes to give the menu
function menu_swicth(_menu, _iframes = 10)
{
	menu = _menu;
	menu_iframes = _iframes;
	selected = 0;
}

///@desc Sets up the menu, call in the create event when using a menu
function setup_menu()
{
	mouse = true;
	menu_iframes = 10;
	menu = 0;
	selected = 0;
}

enum ARGUMENTS
{
	NAME = 0,
	FUNCTION = 1,
	ARGUMENTS = 2
}