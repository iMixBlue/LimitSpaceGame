//iMix/Toon   mix from : UTS3/NiloToon/Genshin/StartRail/ZoneZero/BRDF
//imixgold@gmail.com

//Known Issues : Disabled "Depth Priming Mode" to support outline

Shader "iMixToonShader"
{
	Properties
	{
		[KeywordEnum(None, Body, Hair, Face)] _Area ("Material area", float) = 0
		[Header(Base Color Map)]
		_BaseMap ("BaseMap", 2D) = "white" { }
		_BaseColor ("BaseColor", Color) = (1, 1, 1, 1)

		[Header(Light Map)]
		[NoScaleOffset] _BodyLightMap ("Body light map (Default black)", 2D) = "black" { }
		[NoScaleOffset] _HairLightMap ("Hair light map (Default black)", 2D) = "black" { }

		[Header(Ramp Map)]
		[NoScaleOffset] _HairCoolRamp ("Hair cool ramp (Default white)", 2D) = "white" { }
		[NoScaleOffset] _HairWarmRamp ("Hair warm ramp (Default white)", 2D) = "white" { }
		[NoScaleOffset] _BodyCoolRamp ("Body cool ramp {Default white}", 2D) = "white" { }
		[NoScaleOffset] _BodyWarmRamp ("Body warm ramp (Default white)", 2D) = "white" { }
		

		_Color ("Color", Color) = (1, 1, 1, 1)
		_MainLightColorUsage ("Main light color usage (Default 1)", Range(0, 1)) = 1
		//
		[Toggle(_)] _Is_LightColor_Base ("Is_LightColor_Base", Float) = 1
		[NoScaleOffset]_1st_ShadeMap ("1st_ShadeMap", 2D) = "white" { }
		//v.2.0.5
		[Toggle(_)] _Use_BaseAs1st ("Use BaseMap as 1st_ShadeMap", Float) = 0
		[NoScaleOffset]_1st_ShadeColor ("1st_ShadeColor", Color) = (1, 1, 1, 1)
		[Toggle(_)] _Is_LightColor_1st_Shade ("Is_LightColor_1st_Shade", Float) = 1
		[NoScaleOffset]_2nd_ShadeMap ("2nd_ShadeMap", 2D) = "white" { }
		//v.2.0.5
		[Toggle(_)] _Use_1stAs2nd ("Use 1st_ShadeMap as 2nd_ShadeMap", Float) = 0
		_2nd_ShadeColor ("2nd_ShadeColor", Color) = (1, 1, 1, 1)
		[Toggle(_)] _Is_LightColor_2nd_Shade ("Is_LightColor_2nd_Shade", Float) = 1
		_NormalMap ("NormalMap", 2D) = "bump" { }
		_BumpScale ("Normal Scale", Range(0, 1)) = 1
		[Toggle(_)] _Is_NormalMapToBase ("Is_NormalMapToBase", Float) = 0
		//v.2.0.4.4
		[Toggle(_)] _Set_SystemShadowsToBase ("Receive Self Shadows", Float) = 1
		_Tweak_SystemShadowsLevel ("Tweak_SystemShadowsLevel", Range(-0.5, 0.5)) = 0
		//
		_1st_ShadeColor_Step ("1st_ShadeColor_Step", Range(0, 1)) = 0.5
		_1st_ShadeColor_Feather ("1st_ShadeColor_Feather", Range(0.0001, 1)) = 0.0001
		_2nd_ShadeColor_Step ("2nd_ShadeColor_Step", Range(0, 1)) = 0
		_2nd_ShadeColor_Feather ("2nd_ShadeColor_Feather", Range(0.0001, 1)) = 0.0001
		//v.2.0.5
		_StepOffset ("Step_Offset (ForwardAdd Only)", Range(-0.5, 0.5)) = 0
		[Toggle(_)] _Is_Filter_HiCutPointLightColor ("PointLights HiCut_Filter (ForwardAdd Only)", Float) = 1
		//
		[NoScaleOffset]_ShadingGradeMap ("ShadingGradeMap", 2D) = "white" { }
		//v.2.0.6
		_Tweak_ShadingGradeMapLevel ("Tweak_ShadingGradeMapLevel", Range(-0.5, 0.5)) = 0
		_BlurLevelSGM ("Blur Level of ShadingGradeMap", Range(0, 10)) = 0
		//
		_HighColor ("HighColor", Color) = (0, 0, 0, 1)

		[Header(Face)]
		[NoScaleOffset] _FaceMap ("Face SDF map (Default black)", 2D) = "black" { }
		_FaceShadowOffset ("Face shadow offset (Default -0.01)", Range(-1, 1)) = -0.01
		_FaceShadowTransitionSoftness ("Face shadow transition softness (Default 0.05)", Range(0, 1)) = 0.05

		//Specular
		[Header(Specular)]
		[NoScaleOffset]_HighColor_Tex ("HighColor_Tex", 2D) = "white" { }
		[Toggle(_)] _Is_LightColor_HighColor ("Is_LightColor_HighColor", Float) = 1
		[Toggle(_)] _Is_NormalMapToHighColor ("Is_NormalMapToHighColor", Float) = 0
		_HighColor_Power ("HighColor_Power", Range(0, 1)) = 0
		[Toggle(_)] _Is_SpecularToHighColor ("Is_SpecularToHighColor", Float) = 0
		[Toggle(_)] _Is_BlendAddToHiColor ("Is_BlendAddToHiColor", Float) = 0
		[Toggle(_)] _Is_UseTweakHighColorOnShadow ("Is_UseTweakHighColorOnShadow", Float) = 0
		_TweakHighColorOnShadow ("TweakHighColorOnShadow", Range(0, 1)) = 0
		
		//UTS3 RimLight
		[Header(RimLight)]
		[Toggle(_)] _RimLight ("Use RimLight", Float) = 0
		[Header(UTS3 RimLight)]
		[NoScaleOffset]_Set_HighColorMask ("Set_HighColorMask", 2D) = "white" { }
		_Tweak_HighColorMaskLevel ("Tweak_HighColorMaskLevel", Range(-1, 1)) = 0
		_RimLightColor ("RimLightColor", Color) = (1, 1, 1, 1)
		[Toggle(_)] _Is_LightColor_RimLight ("Is_LightColor_RimLight", Float) = 1
		[Toggle(_)] _Is_NormalMapToRimLight ("Is_NormalMapToRimLight", Float) = 0
		_RimLight_Power ("RimLight_Power", Range(0, 1)) = 0.1
		_RimLight_InsideMask ("RimLight_InsideMask", Range(0.0001, 1)) = 0.0001
		[Toggle(_)] _RimLight_FeatherOff ("RimLight_FeatherOff", Float) = 0
		[Toggle(_)] _LightDirection_MaskOn ("LightDirection_MaskOn", Float) = 0
		_Tweak_LightDirection_MaskLevel ("Tweak_LightDirection_MaskLevel", Range(0, 0.5)) = 0
		[Toggle(_)] _Add_Antipodean_RimLight ("Add_Antipodean_RimLight", Float) = 0
		_Ap_RimLightColor ("Ap_RimLightColor", Color) = (1, 1, 1, 1)
		[Toggle(_)] _Is_LightColor_Ap_RimLight ("Is_LightColor_Ap_RimLight", Float) = 1
		_Ap_RimLight_Power ("Ap_RimLight_Power", Range(0, 1)) = 0.1
		[Toggle(_)] _Ap_RimLight_FeatherOff ("Ap_RimLight_FeatherOff", Float) = 0
		//RimLightMask
		[NoScaleOffset]_Set_RimLightMask ("Set_RimLightMask", 2D) = "white" { }
		_Tweak_RimLightMaskLevel ("Tweak_RimLightMaskLevel", Range(-1, 1)) = 0
		
		
		//StartRail RimLight
		[Header(Start Rail RimLight)]
		[Toggle(_StartRailRimlight_ON)] _UseStartRailRimlight ("Use Start Rail Rimlight (Default NO)", float) = 0
		_RimLightWidth ("Rim light width (Default 1)", Range(0, 10)) = 1
		_RimLightThreshold ("Rim light threshold (Default 0.05)", Range(-1, 1)) = 0.05
		_RimLightFadeout ("Rim light fadeout (Default 1)", Range(0.01, 1)) = 1
		[HDR] _RimLightTintColor ("Rim light tint color (Default white)", Color) = (1, 1, 1)
		_RimLightBrightness ("Rim light brightness (Default 1)", Range(0, 10)) = 1
		_RimLightMixAlbedo ("Rim light mix albedo (Default 0.9)", Range(0, 1)) = 0.9
		
		
		[Header(MatCap)]
		[Toggle(_)] _MatCap ("MatCap", Float) = 0
		_MatCap_Sampler ("MatCap_Sampler", 2D) = "black" { }
		//v.2.0.6
		_BlurLevelMatcap ("Blur Level of MatCap_Sampler", Range(0, 10)) = 0
		_MatCapColor ("MatCapColor", Color) = (1, 1, 1, 1)
		[Toggle(_)] _Is_LightColor_MatCap ("Is_LightColor_MatCap", Float) = 1
		[Toggle(_)] _Is_BlendAddToMatCap ("Is_BlendAddToMatCap", Float) = 1
		_Tweak_MatCapUV ("Tweak_MatCapUV", Range(-0.5, 0.5)) = 0
		_Rotate_MatCapUV ("Rotate_MatCapUV", Range(-1, 1)) = 0
		//v.2.0.6
		[Toggle(_)] _CameraRolling_Stabilizer ("Activate CameraRolling_Stabilizer", Float) = 0
		[Toggle(_)] _Is_NormalMapForMatCap ("Is_NormalMapForMatCap", Float) = 0
		_NormalMapForMatCap ("NormalMapForMatCap", 2D) = "bump" { }
		_BumpScaleMatcap ("Scale for NormalMapforMatCap", Range(0, 1)) = 1
		_Rotate_NormalMapForMatCapUV ("Rotate_NormalMapForMatCapUV", Range(-1, 1)) = 0
		[Toggle(_)] _Is_UseTweakMatCapOnShadow ("Is_UseTweakMatCapOnShadow", Float) = 0
		_TweakMatCapOnShadow ("TweakMatCapOnShadow", Range(0, 1)) = 0
		//MatcapMask
		[NoScaleOffset]_Set_MatcapMask ("Set_MatcapMask", 2D) = "white" { }
		_Tweak_MatcapMaskLevel ("Tweak_MatcapMaskLevel", Range(-1, 1)) = 0
		[Toggle(_)] _Inverse_MatcapMask ("Inverse_MatcapMask", Float) = 0
		//v.2.0.5
		[Toggle(_)] _Is_Ortho ("Orthographic Projection for MatCap", Float) = 0
		//// Angel Rings
		[Header(Angeel Rings)]
		[Toggle(_)] _AngelRing ("AngelRing", Float) = 0
		_AngelRing_Sampler ("AngelRing_Sampler", 2D) = "black" { }
		_AngelRing_Color ("AngelRing_Color", Color) = (1, 1, 1, 1)
		[Toggle(_)] _Is_LightColor_AR ("Is_LightColor_AR", Float) = 1
		_AR_OffsetU ("AR_OffsetU", Range(0, 0.5)) = 0
		_AR_OffsetV ("AR_OffsetV", Range(0, 1)) = 0.3
		[Toggle(_)] _ARSampler_AlphaOn ("ARSampler_AlphaOn", Float) = 0
		//
		//v.2.0.7 Emissive
		[Header(Emissive)]
		[KeywordEnum(SIMPLE, ANIMATION)] _EMISSIVE ("EMISSIVE MODE", Float) = 0
		[NoScaleOffset]_Emissive_Tex ("Emissive_Tex", 2D) = "white" { }
		[HDR]_Emissive_Color ("Emissive_Color", Color) = (0, 0, 0, 1)
		_Base_Speed ("Base_Speed", Float) = 0
		_Scroll_EmissiveU ("Scroll_EmissiveU", Range(-1, 1)) = 0
		_Scroll_EmissiveV ("Scroll_EmissiveV", Range(-1, 1)) = 0
		_Rotate_EmissiveUV ("Rotate_EmissiveUV", Float) = 0
		[Toggle(_)] _Is_PingPong_Base ("Is_PingPong_Base", Float) = 0
		[Toggle(_)] _Is_ColorShift ("Activate ColorShift", Float) = 0
		[HDR]_ColorShift ("ColorSift", Color) = (0, 0, 0, 1)
		_ColorShift_Speed ("ColorShift_Speed", Float) = 0
		[Toggle(_)] _Is_ViewShift ("Activate ViewShift", Float) = 0
		[HDR]_ViewShift ("ViewSift", Color) = (0, 0, 0, 1)
		[Toggle(_)] _Is_ViewCoord_Scroll ("Is_ViewCoord_Scroll", Float) = 0
		//


		//Outline
		[Header(Outline)]
		[Toggle(_OUTLINE_ON)] _UseOutline ("Use outline (Default YES)", float) = 1
		[Toggle(_OUTLINE_UV7_SMOOTH_NORMAL)] _OutlineUseUV7SmoothNormal ("Use UV7 smooth normal (Default NO)", Float) = 0
		_OutlineWidth ("Outline width (Default 1)", Range(0, 10)) = 1
		_OutlineGamma ("Outline gamma (Default 16)", Range(1, 255)) = 16
		_test1 ("test1", Range(0, 1)) = 0
		_test2 ("test1", Range(0, 1)) = 0
		_test3 ("test1", Range(0, 1)) = 0

		
		//GI Intensity
		[Header(GI Intensity)]
		_GI_Intensity ("GI_Intensity", Range(0, 1)) = 0
		//For VR Chat under No effective light objects
		_Unlit_Intensity ("Unlit_Intensity", Range(0, 4)) = 0
		//v.2.0.5
		[Toggle(_)] _Is_Filter_LightColor ("VRChat : SceneLights HiCut_Filter", Float) = 1
		//Built-in Light Direction
		[Toggle(_)] _Is_BLD ("Advanced : Activate Built-in Light Direction", Float) = 0
		_Offset_X_Axis_BLD (" Offset X-Axis (Built-in Light Direction)", Range(-1, 1)) = -0.05
		_Offset_Y_Axis_BLD (" Offset Y-Axis (Built-in Light Direction)", Range(-1, 1)) = 0.09
		[Toggle(_)] _Inverse_Z_Axis_BLD (" Inverse Z-Axis (Built-in Light Direction)", Float) = 1

		
		////////////////// Avoid URP srp batcher error ///////////////////////////////
		_Metallic("_Metallic", Range(0.0, 1.0)) = 0
        _Smoothness("Smoothness", Range(0.0, 1.0)) = 0.5
		[NoScaleOffset]_MaskMap ("MaskMap", 2D) = "white" { }
		////////////////// Avoid URP srp batcher error ///////////////////////////////
		/// 
		[Header(PBR)]
		_SSSWeightPBR ("PBR SSS Weight", Range(0, 1)) = 0
		_sssColor ("_sssColor", color) = (1, 1, 1, 1)
		_roughness ("Roughness", Range(0, 1)) = 0.555
		_metallic ("Metallic", Range(0, 1)) = 0.495
		_subsurface ("Subsurface", Range(0, 1)) = 0.467
		_anisotropic ("Anisotropic", Range(0, 1)) = 0
		_ior ("index of refraction", Range(0, 10)) = 10

		[Header(PBR Env Light)][Space(10)]
		[NoScaleOffset] _Cubemap ("Envmap", cube) = "_Skybox" { }
		_CubemapMip ("Envmap Mip", Range(0, 7)) = 0
		_IBL_LUT ("Precomputed integral LUT", 2D) = "white" { }
		_FresnelPow ("FresnelPow", Range(0, 5)) = 1
		_FresnelColor ("FresnelColor", Color) = (1, 1, 1, 1)
		_EdgeColor ("Edge Color", Color) = (1, 1, 1, 1)

		


		[Header(Surface Options)]
		[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull (Default back)", Float) = 2
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlendMode ("Src blend mode (Default One)", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlendMode ("Dst blend mode (Default Zero)", Float) = 0
		[Enum(UnityEngine.Rendering.BlendOp)] _BlendOp ("Blend operation (Default Add)", Float) = 0
		[Enum(Off, 0, On, 1)] _ZWrite ("Zwrite (Default On)", Float) = 1
		_StencilRef ("Stencil reference (Default 0)", Range(0, 255)) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil comparison (Default disabled)", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilPassOp ("Stencil pass operation (Default keep)", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilFailOp ("Stencil fail operation (Default keep)", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilZFailOp ("Stencil Z fail operation (Default keep)", Int) = 0

		[Header(Draw Overlay)]
		[Toggle(_DRAW_OVERLAY_ON)] _UseDrawOverlay ("Use draw overlay (Default NO)", float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlendModeOverlay ("Overlay pass src blend mode (Default One)", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlendModeOverlay ("Overlay pass dst blend mode (Default Zero)", Float) = 0
		[Enum(UnityEngine.Rendering.BlendOp)] _BlendOpOverlay ("Overlay pass blend operation (Default Add)", Float) = 0
		_StencilRefOverlay ("Overlay pass stencil reference (Default 0) ", Range(0, 255)) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilCompOverlay ("Overlay pass stencil comparison (Default disabled)", Int) = 0
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }
		HLSLINCLUDE
		#pragma shader_feature_local _AREA_FACE
		#pragma shader_feature_local _AREA_HAIR
		#pragma shader_feature_local _AREA_BODY
		#pragma shader_feature_local _OUTLINE_ON
		#pragma shader_feature_local _OUTLINE_UV7_SMOOTH_NORMAL
		#pragma shader_feature_local _DRAW_OVERLAY_ON
		#pragma shader_feature_local _EMISSION_ON
		#pragma shader_feature_local _StartRailRimlight_ON
		ENDHLSL

		//ToonCoreStart
		Pass
		{
			Name "DrawCore"
			Tags { "LightMode" = "UniversalForward" }
			Cull[_Cull]
			Stencil
			{
				Ref [_StencilRef]
				Comp [_StencilComp]
				Pass [_StencilPassOp]
				Fail [_StencilFailOp]
				ZFail [_StencilZFailOp]
			}
			Blend [_SrcBlendMode] [_DstBlendMode]
			BlendOp [_BlendOp]
			ZWrite [_ZWrite]

			HLSLPROGRAM
			#pragma target 2.0
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment fragShadingGradeMap
			// #ifndef DISABLE_RP_SHADERS
				// -------------------------------------
				// urp Material Keywords
				// -------------------------------------
				#pragma shader_feature_local _ALPHAPREMULTIPLY_ON
				#pragma shader_feature_local _EMISSION
				#pragma shader_feature_local _METALLICSPECGLOSSMAP
				#pragma shader_feature_local _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
				//            #pragma shader_feature _OCCLUSIONMAP

				#pragma shader_feature_local _SPECULARHIGHLIGHTS_OFF
				#pragma shader_feature_local _ENVIRONMENTREFLECTIONS_OFF
				#pragma shader_feature_local _SPECULAR_SETUP
				#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
			// #endif

			// -------------------------------------
			// Lightweight Pipeline keywords
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _SHADOWS_SOFT

			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			// -------------------------------------
			// Unity defined keywords
			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile_fog

			#define _IS_PASS_FWDBASE
			#pragma shader_feature_local _ _SHADINGGRADEMAP

			#pragma shader_feature _IS_TRANSCLIPPING_OFF _IS_TRANSCLIPPING_ON
			#pragma shader_feature _IS_ANGELRING_OFF _IS_ANGELRING_ON

			// used in Shadow calculation
			#pragma shader_feature_local _ UTS_USE_RAYTRACING_SHADOW

			#pragma shader_feature _EMISSIVE_SIMPLE _EMISSIVE_ANIMATION
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"


				
            #include "iMixToonDrawCore.hlsl"





			ENDHLSL
		}
		//ToonCoreEnd

		Pass
		{
			Name "ShadowCaster"
			Tags { "LightMode" = "ShadowCaster" }

			ZWrite [_ZWrite]
			ZTest LEqual
			ColorMask 0
			Cull[_Cull]

			HLSLPROGRAM
			#pragma target 2.0
			
			// Required to compile gles 2.0 with standard srp library
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x


			#pragma shader_feature_local _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			#pragma vertex ShadowPassVertex
			#pragma fragment ShadowPassFragment

			#include "iMixToonInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
			ENDHLSL
		}
		Pass
		{
			Name "DrawOverlay"
			Tags { "RenderPipeline" = "UniversalPipeline" "RenderType" = "Opaque" "LightMode" = "UniversalForward" }
			cull [_Cull]
			Stencil
			{
				Ref [_StencilRefOverlay]
				Comp [_StencilCompOverlay]
			}
			Blend [_SrcBlendModeOverlay] [_DstBlendModeOverlay]
			BlendOp [_BlendOpOverlay]
			ZWrite [_ZWrite]

			HLSLPROGRAM
			#pragma multi_compile _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _SHADOWS_SOFT

			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_fog

			#if _DRAW_OVERLAY_ON
				#include "iMixToonInput.hlsl"
				#include "iMixToonDrawCore.hlsl"
			#else
				struct Attributes { };
				struct Varyings
				{
					float4 positionCS : SV_POSITION;
				};
				Varyings vert(Attributes input)
				{
					return (Varyings)0;
				}
				float4 frag(Varyings input) : SV_TARGET
				{
					return 0;
				}
			#endif
			ENDHLSL
		}

		Pass
		{
			Name "DepthOnly"
			Tags { "LightMode" = "DepthOnly" }

			ZWrite [_ZWrite]
			ColorMask 0
			Cull[_Cull]

			HLSLPROGRAM
			#pragma target 2.0
			
			// Required to compile gles 2.0 with standard srp library
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex DepthOnlyVertex
			#pragma fragment DepthOnlyFragment

			// -------------------------------------
			// Material Keywords
			#pragma shader_feature_local _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			#include "iMixToonInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/DepthOnlyPass.hlsl"
			ENDHLSL
		}
		// This pass is used when drawing to a _CameraNormalsTexture texture
		Pass
		{
			Name "DepthNormals"
			Tags { "LightMode" = "DepthNormals" }

			ZWrite[_ZWrite]
			Cull[_Cull]

			HLSLPROGRAM
			#pragma target 2.0
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Version.hlsl"


			// Required to compile gles 2.0 with standard srp library
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex DepthNormalsVertex
			#pragma fragment DepthNormalsFragment

			// -------------------------------------
			// Material Keywords
			#pragma shader_feature_local _PARALLAXMAP
			#pragma shader_feature_local _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A



			#include "iMixToonInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/DepthNormalsPass.hlsl"

			ENDHLSL
		}
		Pass
		{
			Name "DrawOutline"
			Tags { "RenderPipeline" = "UniversalPipeline" "RenderType" = "Opaque" "LightMode" = "UniversalForwardOnly" }
			cull Front
			ZWrite [_ZWrite]

			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_fog

			#if _OUTLINE_ON
				#include "iMixToonInput.hlsl"
				#include "iMixToonDrawOutline.hlsl"
			#else
				struct Attributes { };
				struct Varyings
				{
					float4 positionCS : SV_POSITION;
				};
				Varyings vert(Attributes input)
				{
					return (Varyings)0;
				}
				float4 frag(Varyings input) : SV_TARGET
				{
					return 0;
				}
			#endif
			
			ENDHLSL
		}
	}
}
