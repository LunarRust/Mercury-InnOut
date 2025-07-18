shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float alpha : hint_range(0.0, 1.0) = 0.5;
uniform float stripe: hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float scan: hint_range(0.0, 1.0, 0.1) = 0.5;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec4 albedo_tex = texture(screen_texture,uv);
	vec4 color = texture(TEXTURE, UV);
	vec4 lcd = vec4(stripe,stripe,stripe,1.0);
	int rgb_stripe = int(mod(FRAGCOORD.x,3.0));
	if (rgb_stripe == 1) {
		lcd.r = 1.0;
	}
	else if (rgb_stripe == 2) {
		lcd.g = 1.0;
	}
	else {
		lcd.b = 1.0;
	}
	if (int(mod(FRAGCOORD.y,3.0)) == 0) {
		lcd.rgb = vec3(scan);
	}
	color.a = alpha;
	COLOR = color * lcd;
	
}