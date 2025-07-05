if (time > 0)
{
	a = min(a + fallof, 1)
}
else
{
	a = max(a - fallof, 0);
	if (a <= 0) instance_destroy();
}

x = x + random_range(shake, -shake);
y = y + random_range(shake, -shake);



y = y + moving;

time -= 1;