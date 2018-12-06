//
//  BackwardsTimedStroke.metal
//  ArtzyCamera
//
//  Created by Oscar De la Hera Gomez on 12/6/18.
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


//constant float loopTime = 10; // In Seconds
//constant float startTime = 1.25;
//constant float endTime = 9.25;

struct TimeVariables {
    float loopTime;
    float startTime;
    float endTime;
};

struct DisplayVariables {
    float show;
};

struct Vertex
{
    float4 position [[position]];
    float2 uv;
    half4 color;
    float2 texCoords [[user(tex_coords)]];
    float time;
    float4 modelViewProjectionTransformColumn;
};

vertex Vertex BackwardsTimedStrokeVertexShader(VertexInput in [[ stage_in ]],
                                      uint vertexID [[vertex_id]],
                                      constant SCNSceneBuffer& scn_frame [[buffer(0)]],
                                      constant NodeBuffer& scn_node [[buffer(1)]])
{
    Vertex vert;
    vert.color = half4( half3(1,1,1), 0.1);
    vert.uv = in.texCoords0;
    vert.time = scn_frame.time;
    vert.modelViewProjectionTransformColumn = scn_node.modelViewProjectionTransform[3];
    vert.position = scn_node.modelViewProjectionTransform * float4(in.position, 1.0);
    return vert;
}



fragment half4 BackwardsTimedStrokeSurfaceFragment(Vertex in [[stage_in]],
                                          constant SCNSceneBuffer& scn_frame [[buffer(0)]],
                                          constant NodeBuffer& scn_node [[buffer(1)]],
                                          constant TimeVariables& timeVariables [[buffer(2)]],
                                          constant DisplayVariables& displayVariables [[buffer(3)]])
{
    
//    float currentTime = in.time;
//    float timerMilestone = floor(currentTime/timeVariables.loopTime);
//
//    float loopTimer = (currentTime - timerMilestone*timeVariables.loopTime);
//
//    if ( loopTimer < timeVariables.startTime) {
//        // hasnt started
//        discard_fragment();
//    }
//    else if (loopTimer < timeVariables.endTime) {
//        // has started
//
//        float showUVsIfSmallerThan = (loopTimer-timeVariables.startTime)/(timeVariables.endTime-timeVariables.startTime);
//
//        if ((in.uv.y) > showUVsIfSmallerThan) {
//            // These Are Invalid, remove
//            discard_fragment();
//        }
//
//    }
//    else {
//        // SHOW ALL
//    }
    
    if ((in.uv.y) > displayVariables.show) {
        // These Are Invalid, remove
        discard_fragment();
    }
    else {
        // show
    }

    
    
    half4 fragColor;
    fragColor.rgb = half3(in.color.rgb);
    fragColor.a = in.color.a;
    //    fragColor.rgb *= fragColor.a;
    return fragColor;
    
}
