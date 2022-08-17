#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

const float ZOOM  = 8.0;

float Hash21(vec2 p) {
  p = fract(p * vec2(123.45, 456.78));
  p += dot(p, p + 45.67);
  return fract(p.x * p.y);
}

float Star(in vec2 position, in float radius) {
  return radius / length(position);
}

void main() {
  // Transform input pixel coordinate
  vec2 coord = (gl_FragCoord.xy -0.5 * u_resolution.xy) / u_resolution.y;
  coord *= ZOOM;

  // Create canvas
  vec3 canvas = vec3(0);

  // Create grid
  vec2 grid = fract(coord) - 0.5;

  // Create grid cell id
  vec2 id = floor(coord);

  // Create random for cell
  float rand = Hash21(id);

  // Create star
	float star = Star(grid - vec2(rand - 0.5, fract(rand*34.0) - 0.5), 0.1);
  canvas += star * vec3(0.9, 0.65, 0.5);

  // Debug
  // canvas.rg += id * 0.2;
  // if(grid.x > .49 || grid.y > .49) canvas.r += 1.0;
  // canvas += Hash21(id);

  // Write pixel color
  gl_FragColor = vec4(canvas, 1.);
}