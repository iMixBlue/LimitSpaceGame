Shader "Custom/Ghost" {
    Properties{
        _BaseColor("Base Color",2D) = "white"{}
        _DiffuseColor("Diffuse Color",color) = (0.9245283,0.7195621,0.7607843,1)
        _RayPower("RayPower", Range(1, 10)) = 1.196581
        _RayColor("RayColor", Color) = (0.9245283,0.7195621,0.7607843,1)
        _LightPower("LightPower", Range(1, 10)) = 1.8
        _Alpha("Alpha", Range(0, 1)) = 0.427
        [HideInInspector]_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
    }
        SubShader{
            Tags {
                "RenderPipeline" = "UniversalPipeline"
                "IgnoreProjector" = "True"
                "Queue" = "Transparent"
                "RenderType" = "Transparent"
            }
             HLSLINCLUDE
                #pragma vertex vert
                #pragma fragment frag
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

                CBUFFER_START(UnityPerMaterial)
                float4 _BaseColor_ST;
                float _RayPower;
                float4 _RayColor;
                float _LightPower;
                float _Alpha;
                float4 _DiffuseColor;

                
                CBUFFER_END
                ENDHLSL
            Pass {
                
                Tags {
                      "LightMode" = "UniversalForward"
                }
                Blend SrcAlpha OneMinusSrcAlpha
                ZWrite Off
                HLSLPROGRAM 
                struct Attributes {
                    float2 uv : TEXCOORD0;
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                };
                struct Varings {
                    float4 pos : SV_POSITION;
                    float3 posWorld : TEXCOORD0;
                    float3 normalDir : TEXCOORD1;
                    float2 uv : TEXCOORD2;
                };

                Varings vert(Attributes IN)
            {
                 Varings OUT;
                VertexPositionInputs positionInputs = GetVertexPositionInputs(IN.vertex.xyz);
                OUT.uv = TRANSFORM_TEX(IN.uv,_BaseColor);
                OUT.posWorld = positionInputs.positionWS;
                OUT.pos = positionInputs.positionCS;
                
                return OUT;
            }

                TEXTURE2D(_BaseColor);
                SAMPLER(sampler_BaseColor);

                float4 frag(Varings i) :SV_Target {
                    float4 baseColor = SAMPLE_TEXTURE2D(_BaseColor,sampler_BaseColor,i.uv);

                    i.normalDir = normalize(i.normalDir);
                    float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                    float3 normalDirection = i.normalDir;
                    // Lighting and Emissive:
                    float emissive = pow((1 - saturate(dot(i.normalDir,viewDirection))),_RayPower);
                    float3 finalColor = ((emissive * _RayColor.rgb) * _LightPower);

                    return float4(finalColor,(emissive * _Alpha));
                    // return baseColor;
                     }
                ENDHLSL
             }
    }

}
