shader_type canvas_item;

uniform float speed = 5;
uniform float direction = 5;
uniform float transparency = 1;

uniform sampler2D screen_texture;
void vertex() {
	VERTEX.x +=  mod(direction + TIME * speed,30);
}