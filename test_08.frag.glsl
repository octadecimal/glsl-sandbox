#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

const float ZOOM  = 1.0;
const float LAYERS = 11.;

float Hash21(vec2 p) {
  p = fract(p * vec2(123.45, 456.78));
  p += dot(p, p + 45.67);
  return fract(p.x * p.y);
}

mat2 Rot(float a) {
  float s = sin(a), c = cos(a);
  return mat2(c, -s, s, c);
}

float Star(in vec2 position, in float radius) {
  float length = length(position);
  float color =  radius / length;
  return color * smoothstep(0.99, 0.01, length);
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

      // Color star
      float r = fract(rand * 133.1) * 0.40;
      float g = fract(rand * 193.3) * 0.05;
      float b = fract(rand * 212.1) * 0.25;
      color += star * vec3(r, g, b) * size;
      color += star * vec3(0.6275, 0.4627, 0.3686) * size / 2.;
    }
  }

  // Debug
  // if(grid.x > .49 || grid.y > .49) color.r += 1.0;

  return color;
}

void main() {
  // Transform input pixel coordinate
  vec2 coord = (gl_FragCoord.xy -0.5 * u_resolution.xy) / u_resolution.y;
  vec2 mouse = (u_mouse.xy - u_resolution.xy * 0.5) / u_resolution.y;
  coord *= ZOOM;

  // Time
  float time = u_time * .025;

  // Mouse
  // coord += mouse.xy * 1.;
  vec2 parallax = mouse * 0.;
  
  // Rotate
  coord *= Rot(time * 0.5);

  // Create canvas
  vec3 canvas = vec3(0);

  // Draw star layers
  for(float i = 0.; i < 1.0; i += 1.0 / LAYERS) {
    float depth = fract(i + time);
    float fade = depth * smoothstep(1.0, 0.95, depth) * smoothstep(0.2, 0.5, depth);
    float scale = mix(20.0, 0.5, depth) / 2.;
    float offset = i * 420.;
    canvas += StarLayer(coord * scale + offset + (mouse*parallax)) * fade;
  }

  // Write pixel color
  gl_FragColor = vec4(canvas, 1.);
}