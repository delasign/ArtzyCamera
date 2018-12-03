//
//  Texture.metal
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



struct Vertex
{
    float4 position [[position]];
    float2 uv;
    half4 color;
    float2 texCoords;
    float time;
};

vertex Vertex TextureVertexShader(VertexInput in [[ stage_in ]],
                                        uint vertexID [[vertex_id]],
                                        constant SCNSceneBuffer& scn_frame [[buffer(0)]],
                                        constant NodeBuffer& scn_node [[buffer(1)]])
{
    Vertex vert;
    vert.texCoords = in.texCoords0;
    vert.time = scn_frame.time;
    vert.position = scn_node.modelViewProjectionTransform * float4(in.position, 1.0);
    return vert;
}



fragment half4 TextureSurfaceFragment(Vertex in [[stage_in]],
                                            constant SCNSceneBuffer& scn_frame [[buffer(0)]],
                                            constant NodeBuffer& scn_node [[buffer(1)]],
                                            texture2d<float, access::sample> diffuseTexture [[texture(1)]])
{
    
    constexpr sampler sampler2d(coord::normalized, filter::linear, address::repeat);
    float4 color = diffuseTexture.sample(sampler2d, in.texCoords);
    return half4(color);
    
}
