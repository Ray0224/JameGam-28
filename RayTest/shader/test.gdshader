shader_type canvas_item;


void fragment() {
	COLOR = texture(TEXTURE,UV);
	COLOR.r = 0.0;
}
void vertex(){
	VERTEX += vec2(cos(TIME)*20.0,sin(TIME)*20.0);
}
