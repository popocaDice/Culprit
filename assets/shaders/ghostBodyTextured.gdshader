shader_type spatial;
//Simple 3D shader to create a force-field effect inspired by Faultless Defense from Guilty Gear Xrd.
//In summary, it takes logic used for simple rim lighting and uses it to create the alpha instead.

render_mode blend_mix,depth_draw_always,cull_back,diffuse_burley,specular_schlick_ggx;//depth_test_disable;
uniform vec4 albedo : source_color;
uniform vec4 emission_color : source_color;
uniform sampler2D texture_albedo : source_color;
uniform float emission_amount: hint_range(1.0, 2) = 1.0f; 
uniform float alpha_limit: hint_range(0.0, 1.0) = 0.0;
uniform float rim_limit : hint_range(0.0f, 10.0f) = 3.0f;
uniform float rim_steepness : hint_range(0.0f, 16.0f) = 3.0f; //higher values mean a smaller rim.
uniform vec3 uv_scale;
uniform vec3 uv_offset;


void vertex() {
	UV=UV*uv_scale.xy+uv_offset.xy;
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	float NdotV = dot(NORMAL, VIEW);
	float rim_light = pow(1.0 - NdotV, rim_steepness);
	float spot_light = NdotV * rim_limit;
	
	ALPHA = max(max(max(spot_light, rim_light) * emission_color.a, albedo_tex.a), alpha_limit);
	ALBEDO = albedo.rgb;
	EMISSION = emission_color.rgb * emission_amount * max(rim_light, spot_light) * (1.0 - albedo_tex.a) + (albedo_tex.rgb * albedo_tex.a);
}