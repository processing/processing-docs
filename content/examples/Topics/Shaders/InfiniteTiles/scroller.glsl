//---------------------------------------------------------
// Display endless moving background using a tile texture.
// Contributed by martiSteiger
//---------------------------------------------------------

uniform float time;
uniform vec2 resolution;
uniform sampler2D tileImage;

#define TILES_COUNT_X 4.0

void main() {
  vec2 pos = gl_FragCoord.xy - vec2(4.0 * time);
  vec2 p = (resolution - TILES_COUNT_X * pos) / resolution.x;
  vec3 col = texture2D (tileImage, p).xyz;
  gl_FragColor = vec4 (col, 1.0);
}