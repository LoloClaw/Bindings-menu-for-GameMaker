#macro BINDINGFILE game_save_id + "bindings.sav" //setting up the savefile for the bindings in a MACRO, change to change save location

///@desc Sets up the bindings, call at the beginning of the game
function bindings_setup()
{
	gamepad_set_target(); //gets if the gamepad is connected and in which slot it's connected
	set_default_bindings(); //loads default bindings
	load_bindings(); //loads saved bindings (if they exist)
	binding_setup_list(); //loads the image_index list for the bindings
}

///@desc Resets all bindings to default ones
function set_default_bindings()
{
	global.bindings = []; //Empties the bindings array
	//Fill the default binding array using the new_binding() function. NOTHING WORKS IF YOU DON'T FILL THIS UP
	//here is an example binding, delete it and add your own :)
	//do NOT put hidden bindings here, if you do bindings will be messed up
	new_binding("Example", vk_space, mb_left, gp_face1);
	new_binding("Example 2", ord("D"), "noone", "Rright");
	new_binding("Example 3", ord(1), "down", gp_start);
	//Hidden bindings!!!! (set as hidden in the function)
	//These are the menu hidden bindings, you may change the controls but don't change the names or delete the bindings otherwise menus will stop working
	new_binding("Menu_quit", vk_escape, "noone", gp_face2, true);
	new_binding("Menu_up", vk_up, "noone", "Lup", true);
	new_binding("Menu_down", vk_down, "noone", "Ldown", true);
	new_binding("Menu_left", vk_left, "noone", "Lleft", true);
	new_binding("Menu_right", vk_right, "noone", "Lright", true);
	new_binding("Menu_reset", ord("H"), "noone", gp_face4, true);
	new_binding("Menu_select", vk_enter, mb_left, gp_face1, true);
	new_binding("Menu_unbind", vk_backspace, mb_right, gp_face3, true);
	new_binding("Page_right", ord("D"), "noone", gp_shoulderr, true);
	new_binding("Page_left", ord("A"), "noone", gp_shoulderl, true);
	clipboard_set_text(json_stringify(global.bindings))
	//Insert here your own hidden bindings!!
	//ONLY put hidden bindings here
}

///@desc Create a new binding and set the default bindings. USE ONLY IN THE set_default_bindings() FUNCTION UNLESS YOU KNOW WHAT YOU ARE DOING. Write "noone" in inputs to set no default option
///@param {string}  display  The display name for the binding, also used for calling the key
///@param {real}  keyboard_input The default input for keyboards
///@param {real}  mouse_input The default input for the mouse
///@param {real}  gamepad_input The default input for gamepads
///@param {bool} hidden Set to true if you want to hide this binding and prevent it from being changed. Defaults to false
function new_binding(_display, _keyboard_input, _mouse_input, _gamepad_input, _hidden = false)
{
	global.bindings[array_length(global.bindings)] = [_display, [_keyboard_input, _mouse_input, _gamepad_input], _hidden];
}

///@desc Sets up the list for the image_indexes of the sprites for the bindings. Once called once it's useless. It's already called with the bindings_setup() function, so DON'T CALL UNLESS YOU KNOW WHAT YOU ARE DOING
function binding_setup_list()
{
	global.binding_list = [[0]]; //Create the array
	
	var _normal_keys = "QWERTYUIOPASDFGHJKLZXCVBNM0123456789-+\\.,>"; //list of normal keyboard keys
	var _normal_bindings = []; //Create the normal keyboard bindings array
	for (var i = 1; i <= string_length(_normal_keys); i++) _normal_bindings[i] = ord(string_char_at(_normal_keys, i)); //transforms the keys in the list into bindings in the array
	array_delete(_normal_bindings, 0, 1); //format the array
	var _other_keys = [vk_end, vk_enter, vk_backspace, vk_lcontrol, vk_lalt, vk_shift, vk_space, vk_escape, vk_tab, vk_f1, vk_f2, vk_f3, vk_f4, vk_f5, vk_f6, vk_f7, vk_f8, vk_f9, vk_f10, vk_f11, vk_f12, vk_down, vk_up, vk_left, vk_right]; //list of the other keyboard keys
	global.binding_list[0] = array_concat(_normal_bindings, _other_keys); //merge the normal bindings and the other bindings
	
	global.binding_list[1] = [mb_left, mb_right, mb_middle, "up", "down", mb_side1, mb_side2]; //array for the mouse inputs
	
	global.binding_list[2] = [gp_padu, gp_padd, gp_padr, gp_padl, gp_shoulderl, gp_shoulderlb, gp_shoulderr, gp_shoulderrb, "Lup", "Ldown", "Lright", "Lleft", "Rup", "Rdown", "Rright", "Rleft", gp_face1, gp_face2, gp_face3, gp_face4, gp_stickl, gp_stickr, gp_select, gp_start]; //array for the gamepad inputs
}

///@desc Get the image_index for the given binding. The sprites are: spr_keyboard, spr_mouse and spr_playstation 
///@param {real} type Can be: 0 for keyboard, 1 for mouses and 2 for gamepads
///@param {real} binding The binding to search for
///@returns {real} Returns the index
function binding_get_image(_type, _item)
{
	var value = 0; //sets up the variables
	var array = variable_clone(global.binding_list[_type]); //get the right array to search the binding in
	for (var i = 0; i < array_length(array); i++;) //main for loop
	{
		if (_item == array[i]) 
		{
			value = i;
			return value + 1; //returns the right image_index
		}
	}
	return 0; //returns the "?" image_index
}

///@desc Save the bindings in a file, call at the end of binding setup or game
function save_bindings()
{
	var file = file_text_open_write(BINDINGFILE); //opens file
	file_text_write_string(file, json_stringify(global.bindings)); //writes in the file as json
	file_text_close(file); //closes file
}

///@desc Loads the bindings, it's automatically called with bindings_setup so you shouldn't need to call this
function load_bindings()
{
	if (file_exists(BINDINGFILE)) //checks if the file exists
	{
		var file = file_text_open_read(BINDINGFILE); //opens file
		global.bindings = json_parse(file_text_read_string(file)); //reads file and translates it into an array
		file_text_close(file); //closes file
	}
}