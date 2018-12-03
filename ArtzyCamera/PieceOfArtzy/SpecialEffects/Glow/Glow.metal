//
//  TextureGlow.metal
//  Artzy
//
//  Created by Oscar De la Hera Gomez on 11/20/18.
//  Copyright © 2018 Delasign. All rights reserved.
//
#include <metal_stdlib>

using namespace metal;
#include <SceneKit/scn_metal>
#include <simd/simd.h>


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

struct modelViewProjectionTransform
{
    float4x4 transform;
};

struct custom_vertex_t
{
    float4 position [[attribute(SCNVertexSemanticPosition)]];
    float4 normal [[attribute(SCNVertexSemanticNormal)]];
    half4 color [[attribute(SCNVertexSemanticColor)]];
    float3 boneWeights [[attribute(SCNVertexSemanticBoneWeights)]];
};

struct out_vertex_t
{
    float4 position [[position]];
    float2 uv;
};

typedef struct {
    float red;
    float blue;
    float green;
    float offset;
    float weight;
    float distanceToCamera;
} Uniforms;


vertex out_vertex_t texture_mask_vertex(custom_vertex_t in [[stage_in]])
{
    out_vertex_t out;
    out.position = in.position;
    return out;
};


fragment half4 texture_mask_fragment(out_vertex_t in [[stage_in]],
                             texture2d<float, access::sample> colorSampler [[texture(0)]])
{
    constexpr sampler sampler2d(coord::normalized, filter::linear, address::repeat);
    return half4(1.0);
};


////////////

constexpr sampler s = sampler(coord::normalized,
                              r_address::clamp_to_edge,
                              t_address::repeat,
                              filter::linear);

vertex out_vertex_t texture_combine_vertex(custom_vertex_t in [[stage_in]])
{
    out_vertex_t out;
    out.position = in.position;
    out.uv = float2( (in.position.x + 1.0) * 0.5, 1.0 - (in.position.y + 1.0) * 0.5 );
    return out;
};


fragment half4 texture_combine_fragment(out_vertex_t vert [[stage_in]],
                                texture2d<float, access::sample> colorSampler [[texture(0)]],
                                texture2d<float, access::sample> maskSampler [[texture(1)]],
                                constant Uniforms& uniforms [[ buffer(0) ]])
{
    
    float4 FragmentColor = colorSampler.sample( s, vert.uv);
    float4 maskColor = maskSampler.sample(s, vert.uv);
    // Don't render glow on top of the object itself
    if ( maskColor.g > 0.5 ) {
        return half4(FragmentColor);
    }
    

    
    float3 glowColor = float3(uniforms.red, uniforms.green, uniforms.blue);
    
    float alpha = maskColor.r;
    float3 out = FragmentColor.rgb * ( 1.0 - alpha ) + alpha * glowColor;
    return half4( float4(out.rgb, 1.0) );
}

///// Blur //////

vertex out_vertex_t texture_blur_vertex(custom_vertex_t in [[stage_in]])
{
    out_vertex_t out;
    out.position = in.position;
    out.uv = float2( (in.position.x + 1.0) * 0.5, 1.0 - (in.position.y + 1.0) * 0.5 );
    return out;
};

// http://rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/
//constant float weightConstant = 0.175;//0.175
constant float offset[] = { 0.0, 1.0, 2.0, 3.0, 4.0 };
//constant float weight[] = { weightConstant, weightConstant, weightConstant, weightConstant, weightConstant }; //{ 0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162 };
constant float bufferSize = 512.0;

fragment half4 texture_blur_fragment_h(out_vertex_t vert [[stage_in]],
                               texture2d<float, access::sample> maskSampler [[texture(0)]],
                               constant Uniforms& uniforms [[ buffer(0) ]])
{
    //    float4 modelViewProjectionTransform = vert.modelViewProjectionTransformColumn;
    
    float4 FragmentColor = maskSampler.sample( s, vert.uv);
    float FragmentR = FragmentColor.r * uniforms.weight;
    
    
    for (int i=1; i<5; i++) {
        FragmentR += maskSampler.sample( s, ( vert.uv + float2(offset[i] * uniforms.offset, 0.0)/bufferSize / uniforms.distanceToCamera ) ).r * uniforms.weight;
        FragmentR += maskSampler.sample( s, ( vert.uv - float2(offset[i] * uniforms.offset, 0.0)/bufferSize / uniforms.distanceToCamera ) ).r * uniforms.weight;
    }
    return half4(FragmentR, FragmentColor.g, FragmentColor.b, 1.0);
}

fragment half4 texture_blur_fragment_v(out_vertex_t vert [[stage_in]],
                               texture2d<float, access::sample> maskSampler [[texture(0)]],
                               constant Uniforms& uniforms [[ buffer(0) ]])
{
    
    //    float4 modelViewProjectionTransform = vert.modelViewProjectionTransformColumn;
    
    float4 FragmentColor = maskSampler.sample( s, vert.uv);
    float FragmentR = FragmentColor.r * uniforms.weight;
    
    for (int i=1; i<5; i++) {
        FragmentR += maskSampler.sample( s, ( vert.uv + float2(0.0, offset[i] * uniforms.offset)/bufferSize / uniforms.distanceToCamera ) ).r * uniforms.weight;
        FragmentR += maskSampler.sample( s, ( vert.uv - float2(0.0, offset[i] * uniforms.offset)/bufferSize / uniforms.distanceToCamera ) ).r * uniforms.weight;
    }
    
    return half4(FragmentR, FragmentColor.g, FragmentColor.b, 1.0);
    
};


