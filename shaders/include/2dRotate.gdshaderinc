mat3 rotation_matrix(vec3 fov, float x_rot_deg, float y_rot_deg){
	mat3 rotmat;
	float sin_b = sin(y_rot_deg / 180.0 * PI);
	float cos_b = cos(y_rot_deg / 180.0 * PI);
	float sin_c = sin(x_rot_deg / 180.0 * PI);
	float cos_c = cos(x_rot_deg / 180.0 * PI);
	
	rotmat[0][0] = cos_b;
	rotmat[0][1] = sin_b * sin_c;
	rotmat[0][2] = sin_b * cos_c;
	
	rotmat[1][0] = 0.0;
	rotmat[1][1] = cos_c;
	rotmat[1][2] = -sin_c;
	
	rotmat[2][0] = -sin_b;
	rotmat[2][1] = cos_b * sin_c;
	rotmat[2][2] = cos_b * cos_c;
	
	return rotmat;
}

vec2 rotate_vertex(vec2 vertex, vec2 uv, vec2 tex_pixel_size, vec2 rot_deg, float fov, float inset) {
	float tang = tan(fov / 360.0 * PI);
	return vertex + (uv - 0.5f) / tex_pixel_size * tang * (1.0 - inset) * 2.0;
}