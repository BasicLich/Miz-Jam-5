shader_type canvas_item;

uniform float amplitude = 1.0;
uniform float frequency = 2.0;

void vertex(){
	
	VERTEX.y += (1.0-UV.x) * sin((1.0-UV.x) * TIME*frequency) * amplitude;
	
}