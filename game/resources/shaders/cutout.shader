shader_type canvas_item;

uniform float cut_off: hint_range(0.0, 1.0) = 0;

void fragment(){

	vec4 textur = texture(TEXTURE, UV);

	if (UV.y < cut_off){
		COLOR = vec4(textur.rgb, 0.0)		
	}
	else{
		COLOR = textur
	}
//	COLOR.g = cut_off;
}