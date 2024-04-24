shader_type canvas_item;

uniform float fade_value = 0;

void fragment() {
	float alpha = fade_value - UV.y;
	COLOR.a = alpha;
}
