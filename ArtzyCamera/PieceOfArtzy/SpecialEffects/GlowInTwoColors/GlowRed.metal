#include <metal_stdlib>

using namespace metal;
#include <SceneKit/scn_metal>
#include <simd/simd.h>





struct custom_node_t3 {
    float4x4 modelTransform;
    float4x4 inverseModelTransform;
    float4x4 modelViewTransform;
    float4x4 inverseModelViewTransform;
    float4x4 normalTransform; // Inverse transpose of modelViewTransform
    float4x4 modelViewProjectionTransform;
    float4x4 inverseModelViewProjectionTransform;
    float2x3 boundingBox;
    float2x3 worldBoundingBox;
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
    float symbolAsCalledInMetal;
} Uniforms;


vertex out_vertex_t red_mask_vertex(custom_vertex_t in [[stage_in]],
                                    constant Uniforms& uniforms [[ buffer(0) ]])
{
    out_vertex_t out;
    out.position = in.position;
    return out;
};


fragment half4 red_mask_fragment(out_vertex_t in [[stage_in]],
                                 texture2d<float, access::sample> colorSampler [[texture(0)]],
                                 constant Uniforms& uniforms [[ buffer(0) ]])
{
    constexpr sampler sampler2d(coord::normalized, filter::linear, address::repeat);
    return half4(1.0);
};


////////////

constexpr sampler s = sampler(coord::normalized,
                              r_address::clamp_to_edge,
                              t_address::repeat,
                              filter::linear);

struct MyNodeBuffer {
    float4x4 modelTransform;
    float4x4 modelViewTransform;
    float4x4 normalTransform;
    float4x4 modelViewProjectionTransform;
};


vertex out_vertex_t red_combine_vertex(custom_vertex_t in [[stage_in]],
                                       constant Uniforms& uniforms [[ buffer(0) ]])
{
    float test = uniforms.symbolAsCalledInMetal;
    out_vertex_t out;
    out.position = in.position;
    out.uv = float2( (in.position.x + 1.0) * 0.5, 1.0 - (in.position.y + 1.0) * 0.5 );
    return out;
};


fragment half4 red_combine_fragment(out_vertex_t vert [[stage_in]],
                                    texture2d<float, access::sample> colorSampler [[texture(0)]],
                                    texture2d<float, access::sample> maskSampler [[texture(1)]],
                                    constant Uniforms& uniforms [[ buffer(0) ]])
{
    float test = uniforms.symbolAsCalledInMetal;
    float4 FragmentColor = colorSampler.sample( s, vert.uv);
    float4 maskColor = maskSampler.sample(s, vert.uv);
    
    // Don't render glow on top of the object itself
    if ( maskColor.g > 0.5 ) {
        return half4(FragmentColor);
    }
    
    float r = 0.9176470588; // 0.56
    float g = 0.2392156863; // 0.84
    float b = 0.2666666667; // 0.95
    
    float3 glowColor = float3(r, g, b);
    
    float alpha = maskColor.r;
    float3 out = FragmentColor.rgb * ( 1.0 - alpha ) + alpha * glowColor;
    return half4( float4(out.rgb, 1.0) );
}

///// Blur //////

vertex out_vertex_t red_blur_vertex(custom_vertex_t in [[stage_in]],
                                    constant Uniforms& uniforms [[ buffer(0) ]])
{
    float test = uniforms.symbolAsCalledInMetal;
    out_vertex_t out;
    out.position = in.position;
    out.uv = float2( (in.position.x + 1.0) * 0.5, 1.0 - (in.position.y + 1.0) * 0.5 );
    return out;
};

// http://rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/
constant float weightConstant = 0.175;
constant float offset[] = { 0.0, 1.0, 2.0, 3.0, 4.0 };
constant float weight[] = { weightConstant, weightConstant, weightConstant, weightConstant, weightConstant }; //{ 0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162 };
constant float bufferSize = 512.0;

fragment half4 red_blur_fragment_h(out_vertex_t vert [[stage_in]],
                                   texture2d<float, access::sample> maskSampler [[texture(0)]],
                                   constant Uniforms& uniforms [[ buffer(0) ]])
{
    float test = uniforms.symbolAsCalledInMetal;
    float4 FragmentColor = maskSampler.sample( s, vert.uv);
    float FragmentR = FragmentColor.r * weight[0];
    
    
    for (int i=1; i<5; i++) {
        FragmentR += maskSampler.sample( s, ( vert.uv + float2(offset[i], 0.0)/bufferSize ) ).r * weight[i];
        FragmentR += maskSampler.sample( s, ( vert.uv - float2(offset[i], 0.0)/bufferSize ) ).r * weight[i];
    }
    return half4(FragmentR, FragmentColor.g, FragmentColor.b, 1.0);
}

fragment half4 red_blur_fragment_v(out_vertex_t vert [[stage_in]],
                                   texture2d<float, access::sample> maskSampler [[texture(0)]],
                                   constant Uniforms& uniforms [[ buffer(0) ]])
{
    float test = uniforms.symbolAsCalledInMetal;
    float4 FragmentColor = maskSampler.sample( s, vert.uv);
    float FragmentR = FragmentColor.r * weight[0];
    
    for (int i=1; i<5; i++) {
        FragmentR += maskSampler.sample( s, ( vert.uv + float2(0.0, offset[i])/bufferSize ) ).r * weight[i];
        FragmentR += maskSampler.sample( s, ( vert.uv - float2(0.0, offset[i])/bufferSize ) ).r * weight[i];
    }
    
    return half4(FragmentR, FragmentColor.g, FragmentColor.b, 1.0);
    
};


