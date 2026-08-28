shader_type canvas_item;
uniform vec4 color : source_color;
uniform float threshold;
uniform bool locked;
uniform vec4 replace_color_locked : source_color;
uniform bool cleared;
uniform vec4 replace_color_cleared : source_color;

uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform int outline_type : hint_enum("Disable", "Round", "Square") = 2;
uniform float outline_thickness = 1.0;
uniform bool outline;

const vec2[8] DIRECTIONS = {
	vec2(1.0, 0.0),
	vec2(0.0, 1.0),
	vec2(-1.0, 0.0),
	vec2(0.0, -1.0),
	vec2(1.0, 1.0),
	vec2(-1.0, 1.0),
	vec2(-1.0, -1.0),
	vec2(1.0, -1.0)
};

float gtz(float input) { return max(0, sign(input)); }
// returns 1 if input > 0, else 0

float check(sampler2D tex, vec2 from, vec2 size) {
	float result = 0.0;
	for (int i = 0; i < 4 * outline_type; i++) {
		result += texture(tex, from + DIRECTIONS[i] * size * outline_thickness).a;
	}
	return gtz(result);
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

	
    float dist = length(tex_color.rgb - color.rgb);
    if (cleared && dist < threshold) {
        tex_color.rgb = replace_color_cleared.rgb;
    }
    else if (locked && dist < threshold) {
        tex_color.rgb = replace_color_locked.rgb;
    }

    COLOR = tex_color;
	if (outline) {
		COLOR = mix( COLOR, outline_color, check(TEXTURE, UV, TEXTURE_PIXEL_SIZE) * (1.0 - gtz(COLOR.a)) );
	}
}
