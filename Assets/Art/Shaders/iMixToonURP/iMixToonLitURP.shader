

/*
- face anime lighting (auto-fix face ugly lighting due to vertex normal without modifying .fbx, very important)
- TODO3(2022.10.8-9)smooth outline normal auto baking (fix ugly outlines without modifying .fbx once you attach a script on character, very important)
- auto 2D hair shadow on face (very important, it is very difficult to produce good looking shadow result using shadowmap)
- =>TODO1(2022.10.4):sharp const width rim light (Blue Protocol / Genshin Impact)
- tricks to render eye/eyebrow over hair
- hair "angel ring" reflection
- =>TODO2(2022.10.5-7)PBR specular lighting (GGX)
- HSV control shadow & outline color
- 2D mouth renderer
- almost all the extra texture input options like roughness, specular, normal map, detail map...
- LOTS of sliders to control lighting, final color & outline
- per character "dither fadeinout / rim light / tint / lerp..." control script
- volume override control of global "dither fadeinout / rim light / tint / lerp..."
- anime postprocessing
- auto phong tessellation
- perspective removal per character 
- ***just too much for me to write all removed feature here, the full / lite version shader is a totally different level product
*/
Shader "Custom/iMixToonLitURP"
{
    Properties
    {
        [Header(High Level Setting)]
        [ToggleUI]_IsFace("Is Face? (please turn on if this is a face material)", Float) = 0

        [Header(Base Color)]
        [MainTexture]_BaseMap("_BaseMap (Albedo)", 2D) = "white" {}
        [HDR][MainColor]_BaseColor("_BaseColor", Color) = (1,1,1,1)
        
        [Header(Alpha)]
        [Toggle(_UseAlphaClipping)]_UseAlphaClipping("_UseAlphaClipping", Float) = 0
        _Cutoff("_Cutoff (Alpha Cutoff)", Range(0.0, 1.0)) = 0.5

        [Header(LightMap)]
        [Toggle]_UseLightMap("_UseLightMap (on/off LightMap completely)", Float) = 0
        [NoScaleOffset]_LightMap("_LightMap", 2D) = "white" {}
        _LightMapStrength("_LightMapStrength", Range(0.0, 1.0)) = 1.0
        _LightMapIntensity("_FaceShadowMapIntensity",Range(0,1)) = 0.5
        [NoScaleOffset]_FaceShadowMap("Face Shadow Map",2D) = "white"{}
        _FaceShadowColor("face/body shadow color",color) = (1,1,1,1)
        _LightMapChannelMask("_LightMapChannelMask", Vector) = (1,0,0,0)
        _LightMapRemapStart("_LightMapRemapStart", Range(0,1)) = 0
        _LightMapRemapEnd("_LightMapRemapEnd", Range(0,1)) = 1

        [Header(Emission)]
        [Toggle]_UseEmission("_UseEmission (on/off Emission completely)", Float) = 0
        [HDR] _EmissionColor("_EmissionColor", Color) = (0,0,0)
        _EmissionMulByBaseColor("_EmissionMulByBaseColor", Range(0,1)) = 0
        [NoScaleOffset]_EmissionMap("_EmissionMap", 2D) = "white" {}
        _EmissionMapChannelMask("_EmissionMapChannelMask", Vector) = (1,1,1,0)

        [Header(Toon)]
        [Toggle]_UseToonRamp("_UseToon (on/off Toon completely)", Float) = 0
        _ToonRampMapFac("Toon Map Fac",Range(0,1)) = 1
        _ToonRampMap("Toon Map",2D) = "white" {}
        


        [Header(Specular Settings)]
        [Toggle]_UseNPRSpecular("_UseNPRSpecular (on/off NPR Specular completely)", Float) = 0
        [Enum(Common(NPR),0,Anisotropic,1)] _SpecularMode ("Specular Mode", int) = 0
        [HDR] _SpecularColor ("Specular Color", Color) = (1, 1, 1)
        _SpecularGlossness ("Specular Glossness", Range(1, 256)) = 50
        _SpecularSmoothstep ("Specular Smoothstep", Range(0, 1)) = 1

        [Header(Lighting)]
        _LightingDirectionFix ("Lighting Direction Fix", Range(0, 1)) = 0
        [Toggle]_UseCustomLightColor("Use Custom Light Color (on/off CustomLightColor completely)", Float) = 0
        _CustomLightColor("Custom Light Color",Color) = (1,1,1) 
        _IndirectLightMinColor("_IndirectLightMinColor", Color) = (0.1,0.1,0.1,1) 
        _CelShadowBias ("Cel Shadow Bias", Range(-1, 1)) = 0
        _CelShadeMidPoint("_CelShadeMidPoint", Range(-1,1)) = -0.5
        _CelShadeSoftness("_CelShadeSoftness", Range(0,1)) = 0.05

        [Header(Shadow mapping)]
        _ReceiveShadowMappingAmount("_ReceiveShadowMappingAmount", Range(0,1)) = 0.65
        _ReceiveShadowMappingPosOffset("_ReceiveShadowMappingPosOffset", Float) = 0
        _ShadowMapColor("_ShadowMapColor", Color) = (1,0.825,0.78)

        [Header(Outline)]
        [Toggle(_OUTLINE_UV7_SMOOTH_NORMAL)] _OutlineUseUV7SmoothNormal ("Use UV7 smooth normal (Default NO)", Float) = 0
        _OutlineWidth("_OutlineWidth (World Space)", Range(0,4)) = 1
        _OutlineColor("_OutlineColor", Color) = (0.5,0.5,0.5,1)
        _OutlineZOffset("_OutlineZOffset (View Space)", Range(0,1)) = 0.0001
        _OutlineColorBlend("_ColorBlend",Range(0,1)) = 0.2
        [NoScaleOffset]_OutlineZOffsetMaskTex("_OutlineZOffsetMask (black is apply ZOffset)", 2D) = "black" {}
        _OutlineZOffsetMaskRemapStart("_OutlineZOffsetMaskRemapStart", Range(0,1)) = 0
        _OutlineZOffsetMaskRemapEnd("_OutlineZOffsetMaskRemapEnd", Range(0,1)) = 1

        [Header(RimLight)]
        _RimWidth("_RimWidth",Range(0,1)) = 0.02
        _RimThreshold("_RimThreshold",Range(0,1)) = 0.5
        _RimColor("_RimColor",color) = (1,1,1,1)
        _FresnelIntensity("_FresnelIntensity",Range(0,10)) = 0.75
        [Toggle] _ISRIMBLEND("Use Rim Blend BaseColor",Float) = 0 
        _RimBlend("_RimBlend",Range(0,1)) = 0

        [Header(PBR Light)][Space(10)]
        _WeightFinalPBR("PBR Final Weight", Range(0, 1))=0
        _WeightFinalNPR("NPR Weight", Range(0, 1))=1.0
        _WeightPBR("PBR Weight", Range(0, 1))=0
        _SpecularWeightPBR("PBR Specular Weight",Range(0, 1)) = 1.0
        // _DiffuseWeightPBR("PBR Diffuse Weight",Range(0, 1)) = 1.0
        _SSSWeightPBR("PBR SSS Weight",Range(0, 1)) = 0
        _sssColor("_sssColor",color) = (1,1,1,1)
        _roughness       ("Roughness"    , Range(0, 1)) = 0.555
        _metallic        ("Metallic"     , Range(0, 1)) = 0.495
        _subsurface      ("Subsurface"   , Range(0, 1)) = 0.467
        _anisotropic     ("Anisotropic"  , Range(0, 1)) = 0
        _ior             ("index of refraction", Range(0, 10)) = 10

        [Header(Env Light)][Space(10)]
        _WeightEnvLight("Weight EnvLight", Range(0, 1)) = 0
        [NoScaleOffset] _Cubemap ("Envmap", cube) = "_Skybox" {}
        _CubemapMip ("Envmap Mip", Range(0, 7)) = 0
        _IBL_LUT("Precomputed integral LUT", 2D) = "white" {}
        _FresnelPow ("FresnelPow", Range(0, 5)) = 1
        _FresnelColor ("FresnelColor", Color) = (1,1,1,1)
        _EdgeColor("Edge Color", Color) = (1,1,1,1)
    }


    SubShader
    {       
        Tags 
        {
            "RenderPipeline" = "UniversalPipeline"

            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="Geometry"
        }
        HLSLINCLUDE

        #pragma shader_feature_local_fragment _UseAlphaClipping

        ENDHLSL

        Pass
        {               
            Name "ForwardLit"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
            Cull Back
            ZTest LEqual
            ZWrite On
            Blend One Zero

            HLSLPROGRAM

            // #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            // #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _SHADOWS_SOFT

            // Unity defined keywords
            #pragma multi_compile_fog
            // ---------------------------------------------------------------------------------------------
            

            #pragma vertex VertexShaderWork
            #pragma fragment ShadeFinalColor
            
            #include "iMixToonLitURP_Shared.hlsl"
            ENDHLSL
        }
        
        Pass 
        {
            Name "Outline"
            Tags 
            {
                // IMPORTANT: don't write this line for any custom pass! else this outline pass will not be rendered by URP!
                //"LightMode" = "UniversalForward" 

                // [Important CPU performance note]
                // If you need to add a custom pass to your shader (outline pass, planar shadow pass, XRay pass when blocked....),
                // (0) Add a new Pass{} to your shader
                // (1) Write "LightMode" = "YourCustomPassTag" inside new Pass's Tags{}
                // (2) Add a new custom RendererFeature(C#) to your renderer,
                // (3) write cmd.DrawRenderers() with ShaderPassName = "YourCustomPassTag"
                // (4) if done correctly, URP will render your new Pass{} for your shader, in a SRP-batcher friendly way (usually in 1 big SRP batch)

                // For tutorial purpose, current everything is just shader files without any C#, so this Outline pass is actually NOT SRP-batcher friendly.
                // If you are working on a project with lots of characters, make sure you use the above method to make Outline pass SRP-batcher friendly!
            }

            Cull Front 

            HLSLPROGRAM

            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            #pragma multi_compile_fog
            #pragma shader_feature_local _OUTLINE_UV7_SMOOTH_NORMAL

            #pragma vertex VertexShaderWork
            #pragma fragment ShadeFinalColor

            #define ToonShaderIsOutline

            #include "iMixToonLitURP_Shared.hlsl"
            ENDHLSL
        }
        
         Pass
        {
            Name "ShadowCaster"

            Cull [_CullMode]

            Tags 
            { 
                "LightMode" = "ShadowCaster"
            }

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            CBUFFER_START(UnityPerMaterial)
            float _Cutoff;
            CBUFFER_END

            TEXTURE2D(_BaseMap);
            float4 _BaseMap_ST;

            #define textureSampler1 SamplerState_Point_Repeat
            SAMPLER(textureSampler1);

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float2 uv : TEXCOORD0;
            };
            
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;

            };
            
            float3 _LightDirection;
            float4 _ShadowBias;
            half4 _MainLightShadowParams;

            float3 ApplyShadowBias(float3 positionWS, float3 normalWS, float3 lightDirection)
            {
                float invNdotL = 1.0 - saturate(dot(lightDirection, normalWS));
                float scale = invNdotL * _ShadowBias.y;
                positionWS = lightDirection * _ShadowBias.xxx + positionWS;
                positionWS = normalWS * scale.xxx + positionWS;
                return positionWS;
            }

            Varyings vert(Attributes v)
            {
                Varyings o = (Varyings)0;
                float3 positionWS = TransformObjectToWorld(v.positionOS.xyz);
                half3 normalWS = TransformObjectToWorldNormal(v.normalOS);
                positionWS = ApplyShadowBias(positionWS, normalWS, _LightDirection);
                o.positionCS = TransformWorldToHClip(positionWS);
                #if UNITY_REVERSED_Z
    	            o.positionCS.z = min(o.positionCS.z, o.positionCS.w * UNITY_NEAR_CLIP_VALUE);
                #else
    	            o.positionCS.z = max(o.positionCS.z, o.positionCS.w * UNITY_NEAR_CLIP_VALUE);
                #endif
                o.uv = v.uv;
                return o;
            }

            half4 frag(Varyings i) : SV_TARGET 
            {    
                float4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, textureSampler1, i.uv);
                clip(baseMap.a - _Cutoff);
                return float4(0, 0, 0, 1);
            }

            ENDHLSL
        }

        Pass
        {
            Name "Depth Rim"
            Tags
            {
                "LightMode" = "DepthOnly"
            }
            ZWrite On
            ColorMask 0
            Cull Off
            ZTest LEqual

            // #define ToonShaderIsOutline
            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma vertex DepthOnlyVertex
            #pragma fragment DepthOnlyFragment
            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"

            struct Attributes
            {
                float4 position     : POSITION;
                float2 texcoord     : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varings
            {
                float2 uv           : TEXCOORD0;
                float4 positionCS   : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };
            

            Varings DepthOnlyVertex(Attributes input)
            {
                Varings output = (Varings)0;
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

                output.uv = TRANSFORM_TEX(input.texcoord, _BaseMap);
                output.positionCS = TransformObjectToHClip(input.position.xyz);
                return output;
            }

            half4 DepthOnlyFragment(Varings input) : SV_TARGET
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);
                Alpha(SampleAlbedoAlpha(input.uv, TEXTURE2D_ARGS(_BaseMap, sampler_BaseMap)).a, _BaseColor, _Cutoff);
                return 0;
            }
            
            ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags{"LightMode" = "DepthNormals"}

            ZWrite On
            Cull[_Cull]

            HLSLPROGRAM
            #pragma only_renderers gles gles3 glcore d3d11
            #pragma target 2.0

            #pragma vertex DepthNormalsVertex
            #pragma fragment DepthNormalsFragment

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local _NORMALMAP
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _GlossnessINESS_FROM_BASE_ALPHA

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #include "Packages/com.unity.render-pipelines.universal/Shaders/SimpleLitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/DepthNormalsPass.hlsl"
            ENDHLSL
        }
        // Pass 遮挡部分shader
		// {
		// 	ZTest Greater
		// 	Blend One One

		// 	HLSLPROGRAM
		// 	#pragma vertex vert
		// 	#pragma fragment frag
        //     #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
		// 	struct Attributes
        //     {
        //         float4 positionOS : POSITION;
        //         float2 uv : TEXCOORD;
        //         float3 normal : NORMAL;
        //          half4 tangentOS     : TANGENT;
        //     };
        //     struct Varings
        //     {
        //         float4 positionCS : SV_POSITION;
        //         float2 uv : TEXCOORD0;
        //         float3 normal : TEXCOORD2;
		// 		float3 viewDir : TEXCOORD1;
        //     };
        //     float4 _BaseMap_ST;
		// 	   TEXTURE2D(_BaseMap);;
        //     SAMPLER(sampler_BaseMap);
        //     float4 _EdgeColor;
			
		// 	 Varings vert (Attributes v)
		// 	{
		// 		Varings o;
        //         VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS);
        //         VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(v.normal, v.tangentOS);
		// 		o.positionCS = vertexInput.positionCS;

        //         o.uv=TRANSFORM_TEX(v.uv,_BaseMap);

		// 		o.normal = vertexNormalInput.normalWS; 
        //         o.viewDir = SafeNormalize(GetCameraPositionWS() - vertexInput.positionWS);

		// 		return o;
		// 	}
			
		// 	half4 frag (Varings i) : SV_Target
		// 	{
		// 		float NdotV = 1 - dot(i.normal, i.viewDir) * 1.5;
		// 		return _EdgeColor * NdotV;
		// 	}
		// 	ENDHLSL
		// }
    }

}


