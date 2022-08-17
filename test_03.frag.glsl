#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

const float ZOOM  = 8.0;

float Star(in float radius, in vec2 position) {
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
  if(grid.x > .48 || grid.y > .48) canvas.r += 1.0;

  // Create grid cell id
  vec2 id = floor(coord);
  canvas.rg += id * 0.1 + 0.5;

  // Create star
	float star = Star(.03, grid);
  canvas += star * vec3(0.9, 0.65, 0.5);

  // Write pixel color
  gl_FragColor = vec4(canvas, 1.);
}