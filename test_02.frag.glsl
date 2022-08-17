#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float Star(in float radius, in vec2 position) {
  return radius / length(position);
}

void main() {
  // vec2 coord = gl_FragCoord.xy / u_resolution;
  vec2 coord = (gl_FragCoord.xy -0.5 * u_resolution.xy) / u_resolution.y;

  vec3 canvas = vec3(0., 0., 0.);

	float star = Star(.01, coord);
  canvas += star * vec3(0.9, 0.65, 0.5);

  gl_FragColor = vec4(canvas, 1.);
}