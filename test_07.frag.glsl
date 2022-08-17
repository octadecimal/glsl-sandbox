#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

const float ZOOM  = 8.0;
const float LAYERS = 5.;

float Hash21(vec2 p) {
  p = fract(p * vec2(123.45, 456.78));
  p += dot(p, p + 45.67);
  return fract(p.x * p.y);
}

float Star(in vec2 position, in float radius) {
  float length = length(position);
  float color =  radius / length;
  return color * smoothstep(1., 0.01, length);
}

vec3 StarLayer(in vec2 coord) {
  // Create canvas
  vec3 color = vec3(0);

  // Create grid
  vec2 grid = fract(coord) - 0.5;

  // Create grid cell id
  vec2 id = floor(coord);

  // Create star
  for(int y = -1; y <= 1; y++) {
    for(int x = -1; x <= 1; x++) {

      // Get offset relative to current neighbor
      vec2 offset = vec2(x, y);

      // Create random for cell
      float rand = Hash21(id + offset);

      // Draw star
	    float star = Star(grid - offset - vec2(rand - 0.5, fract(rand*34.2) - 0.5), 0.1);
      float size = fract(rand * 73.4);
      color += star * vec3(0.6275, 0.4627, 0.3686) * size;
    }
  }

  // Debug
  // canvas.rg += id * 0.2;
  // if(grid.x > .49 || grid.y > .49) canvas.r += 1.0;
  // canvas += Hash21(id);

  return color;
}

void main() {
  // Transform input pixel coordinate
  vec2 coord = (gl_FragCoord.xy -0.5 * u_resolution.xy) / u_resolution.y;
  coord *= ZOOM;
  
  // Create canvas
  vec3 canvas = vec3(0);

  // Draw star layers
  for(float i = 0.; i < 1.0; i += 1.0 / LAYERS) {
    canvas += StarLayer(coord);
  }

  // Write pixel color
  gl_FragColor = vec4(canvas, 1.);
}