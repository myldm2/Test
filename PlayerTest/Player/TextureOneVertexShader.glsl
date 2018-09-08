
// variable pass into
attribute vec2 aTexCoord; // texture of vertex
attribute vec3 Position;    // position of vertex
attribute vec3 SourceColor; // color of vertex



// variable pass out into fragment shader
// varying means that calculate the color of every pixel between two vertex linearly(smoothly) according to the 2 vertex's color
varying vec3 DestinationColor;
varying vec2 TexCoord;

//out vec4 vertexColor;

void main(void) {
    // gl_Position is built-in pass-out variable. Must config for in vertex shader
    gl_Position = vec4(Position, 1.0);
    DestinationColor = SourceColor;
    TexCoord = vec2(aTexCoord.x, 1.0-aTexCoord.y);
}

