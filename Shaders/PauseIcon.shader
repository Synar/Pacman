shader_type canvas_item;


vec4 swap_color(vec4 cur_color, vec4 old_c_to_swap, vec4 new_c_to_swap) {
    if(distance (cur_color, old_c_to_swap) < 0.01) {
        return new_c_to_swap;
        }
    return cur_color;        
}

void fragment(){
    COLOR = texture(TEXTURE, UV);
    COLOR = swap_color(COLOR,vec4(0,0,0,1),vec4(0.85,0,0,1));
}