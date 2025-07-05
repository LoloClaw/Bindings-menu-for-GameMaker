// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function floating_text(_txt, _x, _y, _a, _angle = 0, _shake = 0, _time = 120, _fallof = 0.03, _color = c_white, _moving = 0, _font = fnt_small)
{
	if (!instance_exists(obj_floating_text)) with (instance_create_layer(_x, _y, "Instances", obj_floating_text))
	{
		txt = _txt;
		a = _a;
		angle = _angle;
		color = _color;
		font = _font;
		moving = _moving;
		shake = _shake;
		time = _time;
	}
}