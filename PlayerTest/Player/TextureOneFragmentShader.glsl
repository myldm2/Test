//#ifdef GL_ES
//precision lowp float;
//#endif  //不加报错，详情见http://blog.csdn.net/cywn_d/article/details/19561543

precision mediump float;

//vec4 FragColor;

varying lowp vec3 DestinationColor;
varying lowp vec2 TexCoord;

uniform sampler2D ourTexture;

void main(void) {
//    gl_FragColor = vec4(DestinationColor, 1.0);
//    vec4 mask = texture2D(ourTexture, TexCoord);
//    gl_FragColor = vec4(mask.rgb, 1.0);
    
//    FragColor = texture2D(ourTexture, TexCoord);
    vec4 mask = texture2D(ourTexture, TexCoord);
    gl_FragColor = vec4(mask.rgb, 1.0);
//    gl_FragColor = vec4(TexCoord, 0.0, 1.0);
}
