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
    vec2 f2 = clamp((vec2(0.0033333334140479564666748046875, CB0[28].y) * (-VARYING4.w)) + vec2(1.0), vec2(0.0), vec2(1.0));
    vec2 f3 = VARYING0 * CB2[0].x;
    float f4 = f2.y;
    vec4 f5 = mix(texture(DiffuseMapTexture, f3 * CB2[1].y), texture(DiffuseMapTexture, f3), vec4(clamp((f2.x * CB2[3].x) - (CB2[2].x * CB2[3].x), 0.0, 1.0)));
    vec4 f6 = texture(NormalMapTexture, f3 * CB2[1].z);
    vec4 f7 = texture(NormalMapTexture, f3);
    vec2 f8 = mix(f6, f7, vec4(clamp((f4 * CB2[3].y) - (CB2[2].y * CB2[3].y), 0.0, 1.0))).wy * 2.0;
    vec2 f9 = f8 - vec2(1.0);
    float f10 = sqrt(clamp(1.0 + dot(vec2(1.0) - f8, f9), 0.0, 1.0));
    vec3 f11 = vec3(f9, f10);
    vec2 f12 = f11.xy + (vec3((texture(NormalDetailMapTexture, f3 * CB2[0].w).wy * 2.0) - vec2(1.0), 0.0).xy * CB2[1].x);
    vec3 f13 = f11;
    f13.x = f12.x;
    vec3 f14 = f13;
    f14.y = f12.y;
    vec2 f15 = f14.xy * f4;
    float f16 = f15.x;
    vec4 f17 = texture(SpecularMapTexture, f3 * CB2[1].w);
    vec4 f18 = texture(SpecularMapTexture, f3);
    vec4 f19 = mix(f17, f18, vec4(clamp((f4 * CB2[3].z) - (CB2[2].z * CB2[3].z), 0.0, 1.0)));
    vec4 f20 = vec4((mix(vec3(1.0), VARYING2.xyz, vec3(mix(1.0, f5.w, CB2[3].w))) * f5.xyz) * (1.0 + (f16 * 0.20000000298023223876953125)), VARYING2.w);
    float f21 = gl_FrontFacing ? 1.0 : (-1.0);
    vec3 f22 = VARYING6.xyz * f21;
    vec3 f23 = VARYING5.xyz * f21;
    vec3 f24 = normalize(((f22 * f16) + (cross(f23, f22) * f15.y)) + (f23 * f10));
    vec3 f25 = f20.xyz;
    vec3 f26 = f25 * f25;
    vec4 f27 = f20;
    f27.x = f26.x;
    vec4 f28 = f27;
    f28.y = f26.y;
    vec4 f29 = f28;
    f29.z = f26.z;
    float f30 = CB0[31].w * clamp(1.0 - (VARYING4.w * CB0[28].y), 0.0, 1.0);
    float f31 = 0.08900000154972076416015625 + (f19.y * 0.9110000133514404296875);
    vec3 f32 = -f1;
    vec3 f33 = reflect(f32, f24);
    float f34 = f19.x * f30;
    vec3 f35 = mix(vec3(0.039999999105930328369140625), f29.xyz, vec3(f34));
    vec3 f36 = VARYING7.xyz - (CB0[16].xyz * VARYING3.w);
    float f37 = clamp(dot(step(CB0[24].xyz, abs(VARYING3.xyz - CB0[23].xyz)), vec3(1.0)), 0.0, 1.0);
    vec3 f38 = VARYING3.yzx - (VARYING3.yzx * f37);
    vec4 f39 = texture(LightMapTexture, f38);
    vec4 f40 = texture(LightGridSkylightTexture, f38);
    vec4 f41 = vec4(clamp(f37, 0.0, 1.0));
    vec4 f42 = mix(f39, vec4(0.0), f41);
    vec4 f43 = mix(f40, vec4(1.0), f41);
    float f44 = f43.x;
    vec4 f45 = texture(ShadowMapTexture, f36.xy);
    float f46 = f36.z;
    vec3 f47 = -CB0[16].xyz;
    float f48 = dot(f24, f47) * ((1.0 - ((step(f45.x, f46) * clamp(CB0[29].z + (CB0[29].w * abs(f46 - 0.5)), 0.0, 1.0)) * f45.y)) * f43.y);
    vec3 f49 = normalize(f1 + f47);
    float f50 = clamp(f48, 0.0, 1.0);
    float f51 = f31 * f31;
    float f52 = max(0.001000000047497451305389404296875, dot(f24, f49));
    float f53 = dot(f47, f49);
    float f54 = 1.0 - f53;
    float f55 = f54 * f54;
    float f56 = (f55 * f55) * f54;
    vec3 f57 = vec3(f56) + (f35 * (1.0 - f56));
    float f58 = f51 * f51;
    float f59 = (((f52 * f58) - f52) * f52) + 1.0;
    float f60 = 1.0 - f34;
    float f61 = f30 * f60;
    vec3 f62 = vec3(f60);
    float f63 = f31 * 5.0;
    vec3 f64 = vec4(f33, f63).xyz;
    vec3 f65 = textureLod(PrefilteredEnvIndoorTexture, f64, f63).xyz;
    vec3 f66;
    if (CB0[32].w == 0.0)
    {
        f66 = f65;
    }
    else
    {
        f66 = mix(f65, textureLod(PrefilteredEnvBlendTargetTexture, f64, f63).xyz, vec3(CB0[32].w));
    }
    vec4 f67 = texture(PrecomputedBRDFTexture, vec2(f31, max(9.9999997473787516355514526367188e-05, dot(f24, f1))));
    float f68 = f67.x;
    float f69 = f67.y;
    vec3 f70 = ((f35 * f68) + vec3(f69)) / vec3(f68 + f69);
    vec3 f71 = f24 * f24;
    bvec3 f72 = lessThan(f24, vec3(0.0));
    vec3 f73 = vec3(f72.x ? f71.x : vec3(0.0).x, f72.y ? f71.y : vec3(0.0).y, f72.z ? f71.z : vec3(0.0).z);
    vec3 f74 = f71 - f73;
    float f75 = f74.x;
    float f76 = f74.y;
    float f77 = f74.z;
    float f78 = f73.x;
    float f79 = f73.y;
    float f80 = f73.z;
    vec3 f81 = (((((f42.xyz * (f42.w * 120.0)) + ((((f62 - (f57 * f61)) * CB0[15].xyz) * f50) + (CB0[17].xyz * (f60 * clamp(-f48, 0.0, 1.0))))) + (((f62 - (f70 * f61)) * (((((((CB0[40].xyz * f75) + (CB0[42].xyz * f76)) + (CB0[44].xyz * f77)) + (CB0[41].xyz * f78)) + (CB0[43].xyz * f79)) + (CB0[45].xyz * f80)) + (((((((CB0[34].xyz * f75) + (CB0[36].xyz * f76)) + (CB0[38].xyz * f77)) + (CB0[35].xyz * f78)) + (CB0[37].xyz * f79)) + (CB0[39].xyz * f80)) * f44))) * 1.0)) + ((CB0[32].xyz + (CB0[33].xyz * f44)) * 1.0)) * f29.xyz) + ((((f57 * (((f58 + (f58 * f58)) / max(((f59 * f59) * ((f53 * 3.0) + 0.5)) * ((f52 * 0.75) + 0.25), 7.0000001869630068540573120117188e-05)) * f50)) * CB0[15].xyz) * 1.0) + ((mix(f66, textureLod(PrefilteredEnvTexture, f64, f63).xyz * mix(CB0[31].xyz, CB0[30].xyz, vec3(clamp(f33.y * 1.58823525905609130859375, 0.0, 1.0))), vec3(f44)) * f70) * f30));
    vec4 f82 = vec4(0.0);
    f82.x = f81.x;
    vec4 f83 = f82;
    f83.y = f81.y;
    vec4 f84 = f83;
    f84.z = f81.z;
    vec4 f85 = f84;
    f85.w = VARYING2.w;
    float f86 = clamp(exp2((CB0[18].z * f0) + CB0[18].x) - CB0[18].w, 0.0, 1.0);
    vec3 f87 = textureLod(PrefilteredEnvTexture, vec4(f32, 0.0).xyz, max(CB0[18].y, f86) * 5.0).xyz;
    bvec3 f88 = bvec3(!(CB0[18].w == 0.0));
    vec3 f89 = mix(vec3(f88.x ? CB0[19].xyz.x : f87.x, f88.y ? CB0[19].xyz.y : f87.y, f88.z ? CB0[19].xyz.z : f87.z), f85.xyz, vec3(f86));
    vec4 f90 = f85;
    f90.x = f89.x;
    vec4 f91 = f90;
    f91.y = f89.y;
    vec4 f92 = f91;
    f92.z = f89.z;
    vec3 f93 = sqrt(clamp(f92.xyz * CB0[20].y, vec3(0.0), vec3(1.0))) + vec3((-0.00048828125) + (0.0009765625 * fract(52.98291778564453125 * fract(dot(gl_FragCoord.xy, vec2(0.067110560834407806396484375, 0.005837149918079376220703125))))));
    vec4 f94 = f92;
    f94.x = f93.x;
    vec4 f95 = f94;
    f95.y = f93.y;
    vec4 f96 = f95;
    f96.z = f93.z;
    vec4 f97 = f96;
    f97.w = VARYING2.w;
    _entryPointOutput = f97;
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
