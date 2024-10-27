shader_type spatial;

uniform vec3 color: source_color;

void fragment() {
  SPECULAR = 0.0;
  ALBEDO = vec3(0.2, 0.2, 0.2);
  EMISSION = color;
}