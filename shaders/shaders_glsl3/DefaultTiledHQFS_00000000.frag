#version 150

#extension GL_ARB_shading_language_include : require
#include <Globals.h>
#include <MaterialParams.h>
uniform vec4 CB0[58];
uniform vec4 CB2[4];
uniform sampler2D ShadowMapTexture;
uniform sampler3D LightMapTexture;
uniform sampler3D LightGridSkylightTexture;
uniform samplerCube PrefilteredEnvTexture;
uniform samplerCube PrefilteredEnvIndoorTexture;
uniform samplerCube PrefilteredEnvBlendTargetTexture;
uniform sampler2D PrecomputedBRDFTexture;
uniform sampler2D DiffuseMapTexture;
uniform sampler2D NormalMapTexture;
uniform sampler2D NormalDetailMapTexture;
uniform sampler2D SpecularMapTexture;

in vec2 VARYING0;
in vec4 VARYING2;
in vec4 VARYING3;
in vec4 VARYING4;
in vec4 VARYING5;
in vec4 VARYING6;
in vec4 VARYING7;
out vec4 _entryPointOutput;

void main()
{
    float f0 = length(VARYING4.xyz);
    vec3 f1 = VARYING4.xyz / vec3(f0);
    vec2 f2 = VARYING0 * CB2[0].x;
    vec4 f3 = texture(DiffuseMapTexture, f2);
    vec4 f4 = texture(NormalMapTexture, f2);
    vec2 f5 = f4.wy * 2.0;
    vec2 f6 = f5 - vec2(1.0);
    float f7 = sqrt(clamp(1.0 + dot(vec2(1.0) - f5, f6), 0.0, 1.0));
    vec3 f8 = vec3(f6, f7);
    vec2 f9 = f8.xy + (vec3((texture(NormalDetailMapTexture, f2 * CB2[0].w).wy * 2.0) - vec2(1.0), 0.0).xy * CB2[1].x);
    vec3 f10 = f8;
    f10.x = f9.x;
    vec3 f11 = f10;
    f11.y = f9.y;
    vec2 f12 = f11.xy * clamp((vec2(0.0033333334140479564666748046875, CB0[28].y) * (-VARYING4.w)) + vec2(1.0), vec2(0.0), vec2(1.0)).y;
    float f13 = f12.x;
    vec4 f14 = texture(SpecularMapTexture, f2);
    vec4 f15 = vec4((mix(vec3(1.0), VARYING2.xyz, vec3(mix(1.0, f3.w, CB2[3].w))) * f3.xyz) * (1.0 + (f13 * 0.20000000298023223876953125)), VARYING2.w);
    float f16 = gl_FrontFacing ? 1.0 : (-1.0);
    vec3 f17 = VARYING6.xyz * f16;
    vec3 f18 = VARYING5.xyz * f16;
    vec3 f19 = normalize(((f17 * f13) + (cross(f18, f17) * f12.y)) + (f18 * f7));
    vec3 f20 = f15.xyz;
    vec3 f21 = f20 * f20;
    vec4 f22 = f15;
    f22.x = f21.x;
    vec4 f23 = f22;
    f23.y = f21.y;
    vec4 f24 = f23;
    f24.z = f21.z;
    float f25 = CB0[31].w * clamp(1.0 - (VARYING4.w * CB0[28].y), 0.0, 1.0);
    float f26 = 0.08900000154972076416015625 + (f14.y * 0.9110000133514404296875);
    vec3 f27 = -f1;
    vec3 f28 = reflect(f27, f19);
    float f29 = f14.x * f25;
    vec3 f30 = mix(vec3(0.039999999105930328369140625), f24.xyz, vec3(f29));
    vec3 f31 = VARYING7.xyz - (CB0[16].xyz * VARYING3.w);
    float f32 = clamp(dot(step(CB0[24].xyz, abs(VARYING3.xyz - CB0[23].xyz)), vec3(1.0)), 0.0, 1.0);
    vec3 f33 = VARYING3.yzx - (VARYING3.yzx * f32);
    vec4 f34 = texture(LightMapTexture, f33);
    vec4 f35 = texture(LightGridSkylightTexture, f33);
    vec4 f36 = vec4(clamp(f32, 0.0, 1.0));
    vec4 f37 = mix(f34, vec4(0.0), f36);
    vec4 f38 = mix(f35, vec4(1.0), f36);
    float f39 = f38.x;
    vec4 f40 = texture(ShadowMapTexture, f31.xy);
    float f41 = f31.z;
    vec3 f42 = -CB0[16].xyz;
    float f43 = dot(f19, f42) * ((1.0 - ((step(f40.x, f41) * clamp(CB0[29].z + (CB0[29].w * abs(f41 - 0.5)), 0.0, 1.0)) * f40.y)) * f38.y);
    vec3 f44 = normalize(f1 + f42);
    float f45 = clamp(f43, 0.0, 1.0);
    float f46 = f26 * f26;
    float f47 = max(0.001000000047497451305389404296875, dot(f19, f44));
    float f48 = dot(f42, f44);
    float f49 = 1.0 - f48;
    float f50 = f49 * f49;
    float f51 = (f50 * f50) * f49;
    vec3 f52 = vec3(f51) + (f30 * (1.0 - f51));
    float f53 = f46 * f46;
    float f54 = (((f47 * f53) - f47) * f47) + 1.0;
    float f55 = 1.0 - f29;
    float f56 = f25 * f55;
    vec3 f57 = vec3(f55);
    float f58 = f26 * 5.0;
    vec3 f59 = vec4(f28, f58).xyz;
    vec3 f60 = textureLod(PrefilteredEnvIndoorTexture, f59, f58).xyz;
    vec3 f61;
    if (CB0[32].w == 0.0)
    {
        f61 = f60;
    }
    else
    {
        f61 = mix(f60, textureLod(PrefilteredEnvBlendTargetTexture, f59, f58).xyz, vec3(CB0[32].w));
    }
    vec4 f62 = texture(PrecomputedBRDFTexture, vec2(f26, max(9.9999997473787516355514526367188e-05, dot(f19, f1))));
    float f63 = f62.x;
    float f64 = f62.y;
    vec3 f65 = ((f30 * f63) + vec3(f64)) / vec3(f63 + f64);
    vec3 f66 = f19 * f19;
    bvec3 f67 = lessThan(f19, vec3(0.0));
    vec3 f68 = vec3(f67.x ? f66.x : vec3(0.0).x, f67.y ? f66.y : vec3(0.0).y, f67.z ? f66.z : vec3(0.0).z);
    vec3 f69 = f66 - f68;
    float f70 = f69.x;
    float f71 = f69.y;
    float f72 = f69.z;
    float f73 = f68.x;
    float f74 = f68.y;
    float f75 = f68.z;
    vec3 f76 = (((((f37.xyz * (f37.w * 120.0)) + ((((f57 - (f52 * f56)) * CB0[15].xyz) * f45) + (CB0[17].xyz * (f55 * clamp(-f43, 0.0, 1.0))))) + (((f57 - (f65 * f56)) * (((((((CB0[40].xyz * f70) + (CB0[42].xyz * f71)) + (CB0[44].xyz * f72)) + (CB0[41].xyz * f73)) + (CB0[43].xyz * f74)) + (CB0[45].xyz * f75)) + (((((((CB0[34].xyz * f70) + (CB0[36].xyz * f71)) + (CB0[38].xyz * f72)) + (CB0[35].xyz * f73)) + (CB0[37].xyz * f74)) + (CB0[39].xyz * f75)) * f39))) * 1.0)) + ((CB0[32].xyz + (CB0[33].xyz * f39)) * 1.0)) * f24.xyz) + ((((f52 * (((f53 + (f53 * f53)) / max(((f54 * f54) * ((f48 * 3.0) + 0.5)) * ((f47 * 0.75) + 0.25), 7.0000001869630068540573120117188e-05)) * f45)) * CB0[15].xyz) * 1.0) + ((mix(f61, textureLod(PrefilteredEnvTexture, f59, f58).xyz * mix(CB0[31].xyz, CB0[30].xyz, vec3(clamp(f28.y * 1.58823525905609130859375, 0.0, 1.0))), vec3(f39)) * f65) * f25));
    vec4 f77 = vec4(0.0);
    f77.x = f76.x;
    vec4 f78 = f77;
    f78.y = f76.y;
    vec4 f79 = f78;
    f79.z = f76.z;
    vec4 f80 = f79;
    f80.w = VARYING2.w;
    float f81 = clamp(exp2((CB0[18].z * f0) + CB0[18].x) - CB0[18].w, 0.0, 1.0);
    vec3 f82 = textureLod(PrefilteredEnvTexture, vec4(f27, 0.0).xyz, max(CB0[18].y, f81) * 5.0).xyz;
    bvec3 f83 = bvec3(!(CB0[18].w == 0.0));
    vec3 f84 = mix(vec3(f83.x ? CB0[19].xyz.x : f82.x, f83.y ? CB0[19].xyz.y : f82.y, f83.z ? CB0[19].xyz.z : f82.z), f80.xyz, vec3(f81));
    vec4 f85 = f80;
    f85.x = f84.x;
    vec4 f86 = f85;
    f86.y = f84.y;
    vec4 f87 = f86;
    f87.z = f84.z;
    vec3 f88 = sqrt(clamp(f87.xyz * CB0[20].y, vec3(0.0), vec3(1.0))) + vec3((-0.00048828125) + (0.0009765625 * fract(52.98291778564453125 * fract(dot(gl_FragCoord.xy, vec2(0.067110560834407806396484375, 0.005837149918079376220703125))))));
    vec4 f89 = f87;
    f89.x = f88.x;
    vec4 f90 = f89;
    f90.y = f88.y;
    vec4 f91 = f90;
    f91.z = f88.z;
    vec4 f92 = f91;
    f92.w = VARYING2.w;
    _entryPointOutput = f92;
}

//$$ShadowMapTexture=s1
//$$LightMapTexture=s6
//$$LightGridSkylightTexture=s7
//$$PrefilteredEnvTexture=s15
//$$PrefilteredEnvIndoorTexture=s14
//$$PrefilteredEnvBlendTargetTexture=s2
//$$PrecomputedBRDFTexture=s11
//$$DiffuseMapTexture=s3
//$$NormalMapTexture=s4
//$$NormalDetailMapTexture=s8
//$$SpecularMapTexture=s5
