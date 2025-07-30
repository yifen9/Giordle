shader_type canvas_item;

uniform sampler2D bow_tex;

uniform vec2 bow_size   = vec2(64.0, 64.0);
uniform vec2 spacing    = vec2(64.0, 64.0);
uniform vec2 direction  = vec2(-0.7, -0.7);
uniform float speed     = 30.0;

void fragment() {
	vec4 base = COLOR;

    vec2 pix = FRAGCOORD.xy;

    float off = TIME * speed;
    vec2 shifted = pix + direction * off;

    vec2 tile = bow_size + spacing;

	vec2 idx = floor(shifted / tile);
	float row = idx.y;
	if(mod(row, 2.0) >= 1.0){
		shifted.x += tile.x * 0.5;
	}

    vec2 local = mod(shifted, tile);

    vec2 start = (tile - bow_size) * 0.5;
    bvec2 in_x = bvec2(local.x >= start.x, local.x <= start.x + bow_size.x);
    bvec2 in_y = bvec2(local.y >= start.y, local.y <= start.y + bow_size.y);

    if (in_x.x && in_x.y && in_y.x && in_y.y) {
        vec2 uv = (local - start) / bow_size;
        vec4 bow = texture(bow_tex, uv);
        COLOR = mix(base, bow, bow.a);
    } else {
        COLOR = base;
    }
}