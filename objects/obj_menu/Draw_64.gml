draw_set_font(fnt_big);
//page 0 of the menu
if (menu == 0) draw_menu(room_width / 2, 100, [["Start game!", floating_text, ["Pretend your game is starting!", room_width / 2, room_height / 2, 0]], ["Options", menu_swicth, [1]], ["Bindings", menu_swicth, [2]], ["Quit", game_end, [0]]]);
//first page of the menu
if (menu == 1)
{
	draw_set_color(c_yellow);
	draw_text(room_width / 2, 300, "Here are your options!")
	draw_set_color(c_white)
	draw_menu(room_width / 2, 100, [["Option 1", floating_text, ["You clicked option 1!", room_width / 2, room_height / 2, 0]], ["Option 2", floating_text, ["You clicked option 2!", room_width / 2, room_height / 2, 0]], ["Back", menu_swicth, [0]]]);
}
//drawimg the binding menu in the second page
if (menu == 2) draw_bindings_menu(fnt_big, 100, room_width / 2, fnt_small);