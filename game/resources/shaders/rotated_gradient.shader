shader_type canvas_item;

uniform float cut_off: hint_range(0.0, 1.0) = 0;
uniform float rotation_degrees: hint_range(0.0, 360.0) = 0;
uniform sampler2D gradient;

vec2 rotateUV(vec2 uv, vec2 piv, float rotation_deg) {
	
	float rotation = radians(rotation_deg);
    mat2 rotation_matrix=mat2(  vec2(sin(rotation),-cos(rotation)),
                                vec2(cos(rotation),sin(rotation))
                                );
    uv -= piv;
    uv= uv*rotation_matrix;
    uv += piv;
    return uv;
}


void fragment(){
	
	vec2 rotated_uvs = rotateUV(UV, vec2(0.5), rotation_degrees);
	vec4 textur = texture(gradient, rotated_uvs );
	
	COLOR = textur;
	
	
//	COLOR.g = cut_off;
}