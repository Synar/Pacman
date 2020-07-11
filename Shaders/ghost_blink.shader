shader_type canvas_item;

uniform bool blink_shade;

vec4 swap_color(vec4 cur_color, vec4 old_c_to_swap, vec4 new_c_to_swap) {
    if(distance (cur_color, old_c_to_swap) < 0.01) {
        return new_c_to_swap;
        }
    return cur_color;        
}

void fragment(){
    COLOR = texture(TEXTURE, UV);
    if (blink_shade){
        COLOR = swap_color(COLOR,vec4(0.98,0.725,0.69,1),vec4(0.75,0.043,0.145,1));
        COLOR = swap_color(COLOR,vec4(0.13,0.13,1,1),vec4(0.86,0.86,1,1));
       }        
}