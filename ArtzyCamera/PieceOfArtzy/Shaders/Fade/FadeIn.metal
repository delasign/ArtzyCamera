//
//  Glow.swift
//  Artzy
//
//  Created by Oscar De la Hera Gomez on 8/12/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>

struct NodeBuffer {
    float4x4 modelTransform;
    float4x4 modelViewTransform;
    float4x4 normalTransform;
    float4x4 modelViewProjectionTransform;
    float2x3 boundingBox;
    
    float4x4 viewTransform;
    float4x4 inverseViewTransform; // view space to world space
    float4x4 projectionTransform;
    float4x4 viewProjectionTransform;
    float4x4 viewToCubeTransform; // view space to cube texture space (right-handed, y-axis-up)
    float4      ambientLightingColor;
    float4      fogColor;
    float3      fogParameters; // x: -1/(end-start) y: 1-start*x z: exponent
    float       time;     // system time elapsed since first render with this shader
    float       sinTime;  // precalculated sin(time)
    float       cosTime;  // precalculated cos(time)
    float       random01; // random value between 0.0 and 1.0
};

typedef struct {
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    float2 texCoords0 [[ attribute(SCNVertexSemanticTexcoord0) ]];
    half4 color [[ attribute(SCNVertexSemanticColor)]];
    
} VertexInput;

//static float rand(float2 uv)
//{
//    return fract(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
//}
//
//static float2 uv2tri(float2 uv)
//{
//    float sx = uv.x - uv.y / 2;
//    float sxf = fract(sx);
//    float offs = step(fract(1 - uv.y), sxf);
//    return float2(floor(sx) * 2 + sxf + offs, uv.y);
//}

constant float milestoneTimeBreadth = 5;


struct Vertex
{
    float4 position [[position]];
    float2 uv;
    half4 color;
    float2 texCoords [[user(tex_coords)]];
    float time;
};

vertex Vertex fadeInVertexShader(VertexInput in [[ stage_in ]],
                                                uint vertexID [[vertex_id]],
                                                constant SCNSceneBuffer& scn_frame [[buffer(0)]],
                                                constant NodeBuffer& scn_node [[buffer(1)]])
{
    Vertex vert;
    float alpha = 0.1;
    vert.color = half4( half3(1,1,1), alpha);
    vert.uv = in.texCoords0;
    vert.time = scn_frame.time;
    vert.position = scn_node.modelViewProjectionTransform * float4(in.position, 1.0);
    return vert;
}



fragment half4 fadeInSurfaceFragment(Vertex in [[stage_in]],
                                        constant SCNSceneBuffer& scn_frame [[buffer(0)]],
                                        constant NodeBuffer& scn_node [[buffer(1)]],
                                        texture2d<float, access::sample> texture [[texture(0)]],
                                        sampler texSampler [[sampler(0)]])
{
    float timerMilestone = floor(in.time/milestoneTimeBreadth);
    float currentTime = in.time;
    float timer = (currentTime - timerMilestone*milestoneTimeBreadth);

    
    half4 fragColor;
    fragColor.rgb = half3(in.color.rgb);
    fragColor.a = in.color.a;
    fragColor.rgb *= fragColor.a*timer;
    return fragColor;
    
}
