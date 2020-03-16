shader_type canvas_item;

render_mode unshaded;

uniform int intensity : hint_range(0,200); 
uniform float precision : hint_range(0,0.02);
uniform vec4 outline_color : hint_color;

varying vec2 o;
varying vec2 f;

void vertex()
{
	o = VERTEX;
	vec2 uv = (UV - 0.5);
	VERTEX += uv * float(intensity);
	f = VERTEX;
}

float bwhite(vec4 col)
{
	return (col.r + col.g + col.b)/3.0;
}

void fragment()
{
	ivec2 t = ivec2(1920, 1080);
	vec2 regular_uv;
	regular_uv.x = UV.x + (f.x - o.x)/float(t.x);
	regular_uv.y = UV.y + (f.y - o.y)/float(t.y);
	
	vec4 regular_color = texture(TEXTURE, regular_uv);
	if((regular_uv.x < 0.0 || regular_uv.x > 1.0) || (regular_uv.y < 0.0 || regular_uv.y > 1.0) || regular_color.a <=0.25){
		regular_color = vec4(0.0); 
	}
	
	vec2 ps = TEXTURE_PIXEL_SIZE * float(intensity) * precision;
	
	vec4 final_color = regular_color;
	int similar_count = 0;
	if (regular_color.a <= 0.0)
	{
		for(int x = -1; x <= 1; x += 1){
			
			for(int y = -1; y <= 1; y += 1){
				if (x==0 && y==0)
					continue;
				if ((x == 1 || x == -1) && (y == 1 || y == -1)) // ignore diagonals
					continue;
					
				vec2 outline_uv = regular_uv + vec2(float(x) * ps.x, float(y) * ps.y); 
				//
				//Sample here, if we are out of bounds then fail
				vec4 outline_sample = texture(TEXTURE, outline_uv);
				if((outline_uv.x < 0.0 || outline_uv.x > 1.0) || (outline_uv.y < 0.0 || outline_uv.y > 1.0)){
					//We aren't a real color
					outline_sample = vec4(0);
				}
				
				
				
				//Is our sample empty? Is there something nearby?
				if(outline_sample.a > final_color.a){
					similar_count += 1;
					final_color = outline_color;
				}
			}
		}
		int colored_horizontal_neighbors = 0;
		for(int x = -1; x <= 1; x += 1) {
			if(x == 0)
				continue;
			vec2 outline_uv = regular_uv + vec2(float(x) * ps.x, float(0) * ps.y); 

			//Sample here, if we are out of bounds then fail
			vec4 outline_sample = texture(TEXTURE, outline_uv);
			if(outline_sample.a > 0.0)
				colored_horizontal_neighbors += 1;
			if(bwhite(outline_sample) < 0.1 && outline_sample.a > 0.0)
			{
				final_color = regular_color;
				break;
			}
		}
		if(colored_horizontal_neighbors > 1 && final_color.a <= 0.0)
		{
			final_color = outline_color;
		}
	}
	
	
	COLOR = final_color; 
}