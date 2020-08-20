shader_type canvas_item;

uniform float dissolve_amount: hint_range(0.0, 1.0);
uniform sampler2D noise_texture;

void fragment(){
	
	vec4 current_pixel = texture(TEXTURE, UV);
	vec4 noise_pixel = texture(noise_texture, UV);
	
	if(noise_pixel.r < dissolve_amount) {
		COLOR.a = 0f;
	}
	else{
		COLOR = current_pixel
	}
	
	if (distance(UV, vec2(0.5, 0.5)) > (sqrt(2)-dissolve_amount*sqrt(2))/2.0){
		COLOR.a = 0f;
	}

	
	
}