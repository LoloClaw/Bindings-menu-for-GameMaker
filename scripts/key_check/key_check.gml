///@desc Finds the index of the key in the global.bindings array
///@arg {string} name The display name for the binding
function key_get_index(_name)
{
	for (var i = 0; i < array_length(global.bindings); i++)
	{
		if (global.bindings[i][0] == _name) return i; //checks if the binding is present in the array and returns the index
	}
	return -1;
}

///@desc Sets the global.controller to true if a gamepad is connected and global.slot to the slot in wich the gamepad is connected
function gamepad_set_target()
{
	//setup variables
	global.controller = false;
	global.slot = -1;
	for (var i = 0; i < 12; i++)
	{
		if (gamepad_is_connected(i)) //get if the slot is connected
		{
			//sets the slot as connected
			global.controller = true;
			global.slot = i;
			break;
		}
	}
}

///@desc Returns if the binding is being held. It's true if any type (keyboard, mouse or gamepad) is held
///@arg {string} name The display name for the binding
function key_check(_name)
{
	gamepad_set_target(); //resets the target if for some reason something changed
	var index = key_get_index(_name); //get index for the binding in global.bindings
	if (index == -1) return false; //end function if binding is not found
	var item = global.bindings[index]; //get the array for the binding, it looks like this [name, [keyboard, mouse, gamepad]]
	var keyboard = false 
	if (item[1][0] != "noone") keyboard = keyboard_check(item[1][0]); //checks if key is being held for the keyboard
	
	var mouse = false;
	if (is_string(item[1][1])) //checks if the binding is a string
	{
		if (item[1][1] == "up") and (mouse_wheel_up()) mouse = true; //checks if mouse wheel is going up
		if (item[1][1] == "down") and (mouse_wheel_down()) mouse = true; //checks if mouse wheel is going down
	}
	else if (mouse_check_button(item[1][1])) mouse = true; //checks if key is being held for the mouse
	
	var gamepad = false;
	if (is_string(item[1][2])) //checks if the binding is a string
	{
		if (global.controller) //checks if the gamepad is actually connected
		{
			//checks if the binding is the gamepad sticks and if they are being held
			if (item[1][2] == "Lright") and (gamepad_axis_value(global.slot, gp_axislh) > 0.5) gamepad = true;
			if (item[1][2] == "Lleft") and (gamepad_axis_value(global.slot, gp_axislh) < -0.5) gamepad = true;
			if (item[1][2] == "Ldown") and (gamepad_axis_value(global.slot, gp_axislv) > 0.5) gamepad = true;
			if (item[1][2] == "Lup") and (gamepad_axis_value(global.slot, gp_axislv) < -0.5) gamepad = true;
			
			if (item[1][2] == "Rright") and (gamepad_axis_value(global.slot, gp_axisrh) > 0.5) gamepad = true;
			if (item[1][2] == "Rleft") and (gamepad_axis_value(global.slot, gp_axisrh) < -0.5) gamepad = true;
			if (item[1][2] == "Rdown") and (gamepad_axis_value(global.slot, gp_axisrv) > 0.5) gamepad = true;
			if (item[1][2] == "Rup") and (gamepad_axis_value(global.slot, gp_axisrv) < -0.5) gamepad = true;
		}
	}
	else if (gamepad_button_check(global.slot, item[1][2])) gamepad = true; //checks if the key is being held for the gamepad
	
	if (keyboard) or (mouse) or (gamepad) return true; //returns true if either the keyboard keys, mouse keys or gamepad keys are being held
	return false; //if nothing returned true before returns false
}

//these other 2 functions are the same as the above one only that they work with key pressed or released instead of held
//NOTE: Keys like mouse_wheel_up and gamepad stick movement have no difference in the 3 functions

///@desc Returns if the binding is being pressed. It's true if any type (keyboard, mouse or gamepad) is pressed
///@arg {string} name The display name for the binding
function key_check_pressed(_name)
{
	gamepad_set_target();
	var index = key_get_index(_name);
	if (index == -1) return false;
	var item = global.bindings[index];
	var keyboard = false 
	if (item[1][0] != "noone") keyboard = keyboard_check_pressed(item[1][0]);
	
	var mouse = false;
	if (is_string(item[1][1]))
	{
		if (item[1][1] == "up") and (mouse_wheel_up()) mouse = true;
		if (item[1][1] == "down") and (mouse_wheel_down()) mouse = true;
	}
	else if (mouse_check_button_pressed(item[1][1])) mouse = true;
	
	var gamepad = false;
	if (is_string(item[1][2]))
	{
		if (global.controller) //checks if the gamepad is actually connected
		{
			//checks if the binding is the gamepad sticks and if they are being held
			if (item[1][2] == "Lright") and (gamepad_axis_value(global.slot, gp_axislh) > 0.5) gamepad = true;
			if (item[1][2] == "Lleft") and (gamepad_axis_value(global.slot, gp_axislh) < -0.5) gamepad = true;
			if (item[1][2] == "Ldown") and (gamepad_axis_value(global.slot, gp_axislv) > 0.5) gamepad = true;
			if (item[1][2] == "Lup") and (gamepad_axis_value(global.slot, gp_axislv) < -0.5) gamepad = true;
			
			if (item[1][2] == "Rright") and (gamepad_axis_value(global.slot, gp_axisrh) > 0.5) gamepad = true;
			if (item[1][2] == "Rleft") and (gamepad_axis_value(global.slot, gp_axisrh) < -0.5) gamepad = true;
			if (item[1][2] == "Rdown") and (gamepad_axis_value(global.slot, gp_axisrv) > 0.5) gamepad = true;
			if (item[1][2] == "Rup") and (gamepad_axis_value(global.slot, gp_axisrv) < -0.5) gamepad = true;
		}
	}
	else if (gamepad_button_check_pressed(global.slot, item[1][2])) gamepad = true;
	
	if (keyboard) or (mouse) or (gamepad) return true;
	return false;
}

///@desc Returns if the binding is being released. It's true if any type (keyboard, mouse or gamepad) is released
///@arg {string} name The display name for the binding
function key_check_released(_name)
{
	gamepad_set_target();
	var index = key_get_index(_name);
	if (index == -1) return false;
	var item = global.bindings[index];
	var keyboard = false 
	if (item[1][0] != "noone") keyboard = keyboard_check_released(item[1][0]);
	
	var mouse = false;
	if (is_string(item[1][1]))
	{
		if (item[1][1] == "up") and (mouse_wheel_up()) mouse = true;
		if (item[1][1] == "down") and (mouse_wheel_down()) mouse = true;
	}
	else if (mouse_check_button_released(item[1][1])) mouse = true;
	
	var gamepad = false;
	if (is_string(item[1][2]))
	{
		if (global.controller) //checks if the gamepad is actually connected
		{
			//checks if the binding is the gamepad sticks and if they are being held
			if (item[1][2] == "Lright") and (gamepad_axis_value(global.slot, gp_axislh) > 0.5) gamepad = true;
			if (item[1][2] == "Lleft") and (gamepad_axis_value(global.slot, gp_axislh) < -0.5) gamepad = true;
			if (item[1][2] == "Ldown") and (gamepad_axis_value(global.slot, gp_axislv) > 0.5) gamepad = true;
			if (item[1][2] == "Lup") and (gamepad_axis_value(global.slot, gp_axislv) < -0.5) gamepad = true;
			
			if (item[1][2] == "Rright") and (gamepad_axis_value(global.slot, gp_axisrh) > 0.5) gamepad = true;
			if (item[1][2] == "Rleft") and (gamepad_axis_value(global.slot, gp_axisrh) < -0.5) gamepad = true;
			if (item[1][2] == "Rdown") and (gamepad_axis_value(global.slot, gp_axisrv) > 0.5) gamepad = true;
			if (item[1][2] == "Rup") and (gamepad_axis_value(global.slot, gp_axisrv) < -0.5) gamepad = true;
		}
	}
	else if (gamepad_button_check_released(global.slot, item[1][2])) gamepad = true;
	
	if (keyboard) or (mouse) or (gamepad) return true;
	return false;
}

///@returns {bool}
///@desc Returns if any gamepad button is being pressed. Doesn't check for stick movement
function gamepad_check_any()
{
	//checks every gamepad key to see if it's being pressed
	for (var i = 0; i < array_length(global.binding_list[2]); i++)
	{
		if (!is_string(global.binding_list[2][i])) if (gamepad_button_check_pressed(global.slot, global.binding_list[2][i]))
		{
			return true; //returns true if a key is being pressed
		}
	}
	return false; //returns false if no key is being pressed
}