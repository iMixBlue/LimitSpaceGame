
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

CBUFFER_START(UnityPerMaterial)
float3 _HeadForward;
float3 _HeadRight;

TEXTURE2D(_BaseMap);
SAMPLER(sampler_BaseMap);
float4 _BaseMap_ST;

#if _AREA_FACE
TEXTURE2D(_FaceColorMap);
SAMPLER(sampler_FaceColorMap);
#elif _AREA_HAIR
TEXTURE2D(_HairColorMap);
SAMPLER(sampler_HairColorMap);
#elif _AREA_UPPERBODY
TEXTURE2D(_UpperBodyColorMap);
SAMPLER(sampler_UpperBodyColorMap);
#elif _AREA_LOWERBODY
TEXTURE2D(_LowerBodyColorMap);
SAMPLER(sampler_LowerBodyColorMap);
#endif

float3 _FrontFaceTintColor;
float3 _BackFaceTintColor;

float _Alpha;
float _AlphaClip;

#if _AREA_HAIR
TEXTURE2D(_HairLightMap);
SAMPLER(sampler_HairLightMap);
#elif _AREA_UPPERBODY
TEXTURE2D(_UpperBodyLightMap);
SAMPLER(sampler_UpperBodyLightMap);
#elif _AREA_LOWERBODY
TEXTURE2D(_LowerBodyLightMap);
SAMPLER(sampler_LowerBodyLightMap);
#endif

#if _AREA_HAIR
TEXTURE2D(_HairCoolRamp);
SAMPLER(sampler_HairCoolRamp);

TEXTURE2D(_HairWarmRamp);
SAMPLER(sampler_HairWarmRamp);

#elif _AREA_FACE || _AREA_UPPERBODY || _AREA_LOWERBODY
TEXTURE2D(_BodyCoolRamp);
SAMPLER(sampler_BodyCoolRamp);

TEXTURE2D(_BodyWarmRamp);
SAMPLER(sampler_BodyWarmRamp);
#endif


float _IndirectLightFlattenNormal;
float _IndirectLightUsage;
float _IndirectLightOcclusionUsage;
float _IndirectLightMixBaseColor;

float _MainLightColorUsage;
float _ShadowThresholdCenter;
float _ShadowThresholdSoftness;
float _ShadowRampOffset;


#if _AREA_FACE
TEXTURE2D(_FaceMap);
SAMPLER(sampler_FaceMap);
//TEXTURE2D(_FaceShadowMap);
//SAMPLER(sampler_FaceShadowMap);

    float _FaceShadowOffset;
    float _FaceShadowTransitionSoftness;
#endif

#if _AREA_HAIR || _AREA_UPPERBODY || _AREA_LOWERBODY
    float _SpecularExpon;
    float _SpecularKsNonMetal;
    float _SpecularKsMetal;
    float _SpecularBrightness;
#endif

#if _AREA_UPPERBODY || _AREA_LOWERBODY
    #if _AREA_UPPERBODY
    TEXTURE2D(_UpperBodyStockings);
SAMPLER(sampler_UpperBodyStockings);
    #elif _AREA_LOWERBODY
     TEXTURE2D(_LowerBodyStockings);
SAMPLER(sampler_LowerBodyStockings);
    #endif
    float3 _StockingsDarkColor;
    float3 _StockingsLightColor;
    float3 _StockingsTransitionColor;
    float _StockingsTransitionThreshold;
    float _StockingsTransitionPower;
    float _StockingsTransitionHardness;
    float _StockingsTextureUsage;
#endif

float _RimLightWidth;
float _RimLightThreshold;
float _RimLightFadeout;
float3 _RimLightTintColor;
float _RimLightBrightness;
float _RimLightMixAlbedo;

#if _EMISSION_ON
    float _EmissionMixBaseColor;
    float3 _EmissionTineColor;
    float _EmissionIntensity;
#endif

#if _OUTLINE_ON
    float _OutlineWidth;
    float _OutlineGamma;

    float _test1;
    float _test2;
    float _test3;
#endif

CBUFFER_END