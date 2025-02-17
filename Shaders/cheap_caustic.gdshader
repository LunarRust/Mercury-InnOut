shader_type spatial;
render_mode specular_schlick_ggx, cull_back, unshaded;

uniform vec4 tint_color : source_color = vec4( 0.3, 0.4, 0.45, 1.0);
uniform sampler2D ground_rgb : hint_default_transparent;
uniform sampler2D caustics_bw: hint_default_white;
uniform float alpha_amount = 1;
uniform float slowdown : hint_range( 0.1, 10.0, 0.1 ) = 5.0;
uniform float time_caust : hint_range( 0.01, 1.0, 0.01 ) = 0.13;
uniform float tile_caust: hint_range( 0.1, 16.0, 0.1 ) = 4.0;
uniform float tile_ground: hint_range( 0.1, 16.0, 0.1 ) = 8.0;

void fragment() {

// caustics_bw
    vec2 caustics_bw_uv1 = UV * (tile_caust + sin(TIME / slowdown) * time_caust);
	vec2 caustics_bw_uv2 = UV * (tile_caust + cos(TIME / slowdown) * time_caust);
	
	float caustics_bw1_read = texture(caustics_bw, caustics_bw_uv1.xy).r;
	float caustics_bw2_read = texture(caustics_bw, caustics_bw_uv2.yx).r;
	
	// ground_rgb
	vec3 ground_rgb_read = texture(ground_rgb, UV * (tile_ground)).rgb;

	ALBEDO = vec3(1) * tint_color.rgb;
	ALPHA =  (caustics_bw1_read * caustics_bw2_read) * alpha_amount;

}