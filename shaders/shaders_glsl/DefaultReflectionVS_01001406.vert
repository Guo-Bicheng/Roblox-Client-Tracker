#version 110

#extension GL_ARB_shading_language_include : require
#include <Globals.h>
uniform vec4 CB0[58];
uniform vec4 CB1[216];
attribute vec4 POSITION;
attribute vec4 NORMAL;
attribute vec2 TEXCOORD0;
attribute vec4 COLOR0;
attribute vec4 COLOR1;
attribute vec4 TEXCOORD4;
attribute vec4 TEXCOORD5;
varying vec2 VARYING0;
varying vec3 VARYING1;
varying vec4 VARYING2;
varying vec4 VARYING3;
varying vec4 VARYING4;
varying vec4 VARYING5;
varying vec4 VARYING6;
varying vec4 VARYING7;

void main()
{
    vec3 v0 = (NORMAL.xyz * 0.0078740157186985015869140625) - vec3(1.0);
    vec4 v1 = TEXCOORD5 * vec4(0.0039215688593685626983642578125);
    ivec4 v2 = ivec4(TEXCOORD4) * ivec4(3);
    float v3 = v1.x;
    float v4 = v1.y;
    float v5 = v1.z;
    float v6 = v1.w;
    vec4 v7 = (((CB1[v2.x * 1 + 0] * v3) + (CB1[v2.y * 1 + 0] * v4)) + (CB1[v2.z * 1 + 0] * v5)) + (CB1[v2.w * 1 + 0] * v6);
    ivec4 v8 = v2 + ivec4(1);
    vec4 v9 = (((CB1[v8.x * 1 + 0] * v3) + (CB1[v8.y * 1 + 0] * v4)) + (CB1[v8.z * 1 + 0] * v5)) + (CB1[v8.w * 1 + 0] * v6);
    ivec4 v10 = v2 + ivec4(2);
    vec4 v11 = (((CB1[v10.x * 1 + 0] * v3) + (CB1[v10.y * 1 + 0] * v4)) + (CB1[v10.z * 1 + 0] * v5)) + (CB1[v10.w * 1 + 0] * v6);
    float v12 = dot(v7, POSITION);
    float v13 = dot(v9, POSITION);
    float v14 = dot(v11, POSITION);
    vec3 v15 = vec3(v12, v13, v14);
    vec3 v16 = vec3(dot(v7.xyz, v0), dot(v9.xyz, v0), dot(v11.xyz, v0));
    vec3 v17 = CB0[11].xyz - v15;
    vec3 v18 = normalize(v17);
    vec3 v19 = v16 * ((dot(v16, v18) > 0.0) ? 1.0 : (-1.0));
    vec2 v20 = vec2(TEXCOORD0.x * 4.0, TEXCOORD0.y) * clamp(NORMAL.w, 0.0, 1.0);
    vec3 v21 = vec3(0.0);
    v21.z = NORMAL.w - 1.0;
    vec3 v22 = -CB0[16].xyz;
    float v23 = dot(v19, v22);
    vec4 v24 = vec4(v12, v13, v14, 1.0);
    vec4 v25 = v24 * mat4(CB0[0], CB0[1], CB0[2], CB0[3]);
    vec3 v26 = v21;
    v26.x = v20.x;
    vec3 v27 = v26;
    v27.y = v20.y;
    vec3 v28 = ((v15 + (v19 * 6.0)).yxz * CB0[21].xyz) + CB0[22].xyz;
    vec4 v29 = vec4(0.0);
    v29.x = v28.x;
    vec4 v30 = v29;
    v30.y = v28.y;
    vec4 v31 = v30;
    v31.z = v28.z;
    vec4 v32 = v31;
    v32.w = 0.0;
    vec4 v33 = vec4(dot(CB0[25], v24), dot(CB0[26], v24), dot(CB0[27], v24), 0.0);
    v33.w = COLOR1.w * 0.0039215688593685626983642578125;
    float v34 = COLOR1.y * 0.50359570980072021484375;
    float v35 = clamp(v23, 0.0, 1.0);
    vec3 v36 = (CB0[15].xyz * v35) + (CB0[17].xyz * clamp(-v23, 0.0, 1.0));
    vec4 v37 = vec4(0.0);
    v37.x = v36.x;
    vec4 v38 = v37;
    v38.y = v36.y;
    vec4 v39 = v38;
    v39.z = v36.z;
    vec4 v40 = v39;
    v40.w = (v35 * CB0[28].w) * (COLOR1.y * exp2((v34 * dot(v19, normalize(v22 + v18))) - v34));
    gl_Position = v25;
    VARYING0 = TEXCOORD0;
    VARYING1 = v27;
    VARYING2 = COLOR0;
    VARYING3 = v32;
    VARYING4 = vec4(v17, v25.w);
    VARYING5 = vec4(v19, COLOR1.z);
    VARYING6 = v40;
    VARYING7 = v33;
}

