// Write by iMixBlue

#pragma once

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"


struct Attributes
{
    float3 positionOS   : POSITION;
    half3 normalOS      : NORMAL;
    half4 tangentOS     : TANGENT;
    float2 uv           : TEXCOORD0;
    float4 uv7          : TEXCOORD7;
    float4 vertexColor  : COLOR;
};


struct Varyings
{
    float2 uv                       : TEXCOORD0;
    float4 positionWSAndFogFactor   : TEXCOORD1; // xyz: positionWS, w: vertex fog factor
    half3 normalWS                  : TEXCOORD2;
    float4 positionCS               : SV_POSITION;
    float3 positionVS               : TEXCOORD3;
    float4 positionNDC              : TEXCOORD4;
    float3 viewDirWS                : TEXCOORD5;
    float3 normalDirVS              : TEXCOORD6;
    float3 tangentWS                : TEXCOORD7;
    float3 bitangentWS              : TEXCOORD8;
    float4 screenPos                : TEXCOORD9;
    float4 shadowCoord              : TEXCOORD10;
    float4 vertexColor              : COLOR;
};

CBUFFER_START(UnityPerMaterial)
    
    // high level settings
    float   _IsFace;

    // base color
    float4  _BaseMap_ST;
    half4   _BaseColor;

    // alpha
    half    _Cutoff;

    // emission

    float   _UseEmission;
    half3   _EmissionColor;
    half    _EmissionMulByBaseColor;
    half3   _EmissionMapChannelMask;

    //Ramp
    float   _UseToonRamp;


    // lightmap
    float   _UseLightMap;
    half    _LightMapStrength;
    half4   _LightMapChannelMask;
    half    _LightMapRemapStart;
    half    _LightMapRemapEnd; 
    float3 _HeadForward;
    float3 _HeadRight;
    half _LightMapIntensity;

    // specular
    float _UseNPRSpecular;
    int _SpecularMode;
    float3 _SpecularColor;
    float _SpecularGlossness;
    float _SpecularSmoothstep;

    // lighting
    half3   _IndirectLightMinColor;
    half    _CelShadeMidPoint;
    half    _CelShadeSoftness;

    // shadow mapping
    half    _ReceiveShadowMappingAmount;
    float   _ReceiveShadowMappingPosOffset;
    half3   _ShadowMapColor;

    // outline
    float   _OutlineWidth;
    half3   _OutlineColor;
    float   _OutlineZOffset;
    float   _OutlineColorBlend;
    float   _OutlineZOffsetMaskRemapStart;
    float   _OutlineZOffsetMaskRemapEnd;

    //rimlight 
    half _RimWidth;
    half _RimThreshold;
    float4 _RimColor;
    // half _FresnelIntensity;
    half _RimBlend;
    half _ISRIMBLEND;


    // PBR Light    
    float _WeightFinalPBR;
    float _WeightFinalNPR;
    float _WeightPBR;
    float _SpecularWeightPBR;
    // float _DiffuseWeightPBR;
    float _SSSWeightPBR;
    float _roughness;
    float _metallic;
    float _anisotropic;
    float _subsurface;
    float4 _sssColor;
    float _ior;

    // EnvLight
    float _WeightEnvLight;
    samplerCUBE _Cubemap;
    float _CubemapMip;
    float _FresnelPow;
    float4 _FresnelColor;
    half _ToonRampMapFac;
    float _CelShadowBias;

    half _LightingDirectionFix;
    float _UseCustomLightColor;
    half3 _CustomLightColor;

    //others
    float4 _FaceShadowColor;

CBUFFER_END

    TEXTURE2D_X_FLOAT(_CameraDepthTexture);
    SAMPLER(sampler_CameraDepthTexture);

    TEXTURE2D(_BaseMap);
    SAMPLER(sampler_BaseMap);

    TEXTURE2D(_ToonRampMap);
    SAMPLER(sampler_ToonRampMap);

    TEXTURE2D(_EmissionMap);
    SAMPLER(sampler_EmissionMap);

    TEXTURE2D(_LightMap);
    SAMPLER(sampler_LightMap);

    TEXTURE2D(_OutlineZOffsetMaskTex);
    SAMPLER(sampler_OutlineZOffsetMaskTex);

    TEXTURE2D(_IBL_LUT);
    SAMPLER(sampler_IBL_LUT);

    TEXTURE2D(_FaceShadowMap);
    SAMPLER(sampler_FaceShadowMap);


//a special uniform for applyShadowBiasFixToHClipPos() only, it is not a per material uniform, 
//so it is fine to write it outside our UnityPerMaterial CBUFFER
float3 _LightDirection;

//slow but convenient
//e.g. write cmd.SetGlobalFloat("_CurrentCameraFOV",cameraFOV) using a new RendererFeature in C# to improve it.
float GetCameraFOV()
{
    //https://answers.unity.com/questions/770838/how-can-i-extract-the-fov-information-from-the-pro.html
    float t = unity_CameraProjection._m11;
    float Rad2Deg = 180 / 3.1415;
    float fov = atan(1.0f / t) * 2.0 * Rad2Deg;
    return fov;
}
float ApplyOutlineDistanceFadeOut(float inputMulFix)
{
    //make outline "fadeout" if character is too small in camera's view
    return saturate(inputMulFix);
}
float GetOutlineCameraFovAndDistanceFixMultiplier(float positionVS_Z)
{
    float cameraMulFix;
    if(unity_OrthoParams.w == 0)
    {
        ////////////////////////////////
        // Perspective camera case
        ////////////////////////////////

        // keep outline similar width on screen accoss all camera distance       
        cameraMulFix = abs(positionVS_Z);

        // can replace to a tonemap function if a smooth stop is needed
        cameraMulFix = ApplyOutlineDistanceFadeOut(cameraMulFix);

        // keep outline similar width on screen accoss all camera fov
        cameraMulFix *= GetCameraFOV();       
    }
    else
    {
        ////////////////////////////////
        // Orthographic camera case
        ////////////////////////////////
        float orthoSize = abs(unity_OrthoParams.y);
        orthoSize = ApplyOutlineDistanceFadeOut(orthoSize);
        cameraMulFix = orthoSize * 50; // 50 is a magic number to match perspective camera's outline width
    }

    return cameraMulFix * 0.00005; // mul a const to make return result = default normal expand amount WS
}

//float version lerp
float3 float3Lerp(float3 a, float3 b, float c)
{
    return a * (1 - c) + b * c;
}

float floatLerp(float a, float b, float c)
{
    return a * (1 - c) + b * c;
}


float3 TransformPositionWSToOutlinePositionWS(float3 positionWS, float positionVS_Z, float3 normalWS, float3 tangentWS, float3 bitangentWS, float4 uv11)
{
    float outlineExpandAmount = _OutlineWidth * GetOutlineCameraFovAndDistanceFixMultiplier(positionVS_Z);
    #if _OUTLINE_UV7_SMOOTH_NORMAL
        float3x3 tbn = float3x3(tangentWS, bitangentWS, normalWS);
        // return positionWS + normalWS * outlineExpandAmount; 
        return positionWS += mul(uv11.rgb, tbn) * outlineExpandAmount;
    #else
       return positionWS += normalWS * outlineExpandAmount;
    #endif
    //you can replace it to your own method! Here we will write a simple world space method for tutorial reason, it is not the best method!
}
//InvLerpRemap
// .......begin
float invLerp(float from, float to, float value) 
{
    return (value - from) / (to - from);
}
float invLerpClamp(float from, float to, float value)
{
    return saturate(invLerp(from,to,value));
}
// full control remap, but slower
half remap(float origFrom, float origTo, float targetFrom, float targetTo, float value)
{
    float rel = invLerp(origFrom, origTo, value);
    return lerp(targetFrom, targetTo, rel);
}
// .......end

//ZOffset

float4 iMixGetNewClipPosWithZOffset(float4 originalPositionCS, float viewSpaceZOffsetAmount)
{
    if(unity_OrthoParams.w == 0)
    {
        //Perspective camera case
        float2 ProjM_ZRow_ZW = UNITY_MATRIX_P[2].zw;
        float modifiedPositionVS_Z = -originalPositionCS.w + -viewSpaceZOffsetAmount; // push imaginary vertex
        float modifiedPositionCS_Z = modifiedPositionVS_Z * ProjM_ZRow_ZW[0] + ProjM_ZRow_ZW[1];
        originalPositionCS.z = modifiedPositionCS_Z * originalPositionCS.w / (-modifiedPositionVS_Z); // overwrite positionCS.z
        return originalPositionCS;    
    }
    else
    {
        //Orthographic camera case
        originalPositionCS.z += -viewSpaceZOffsetAmount / _ProjectionParams.z; // push imaginary vertex and overwrite positionCS.z
        return originalPositionCS;
    }
}

float4 TransformHClipToViewPortPos(float4 positionCS){
    float4 o = positionCS * 0.5f;
    o.xy = float2(o.x,o.y*_ProjectionParams.x)+o.w;
    o.zw = positionCS.zw;
    return o/o.w;
}

Varyings VertexShaderWork(Attributes input)
{
    Varyings output;

    // There is more flexibility at no additional cost with this struct.
    VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS);
    VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);

    float3 positionWS = vertexInput.positionWS;

    #if defined ToonShaderIsOutline
        positionWS = TransformPositionWSToOutlinePositionWS(vertexInput.positionWS, vertexInput.positionVS.z, vertexNormalInput.normalWS, vertexNormalInput.tangentWS, vertexNormalInput.bitangentWS, input.uv7);
    #endif

    // Computes fog factor per-vertex.
    float fogFactor = ComputeFogFactor(vertexInput.positionCS.z);

    // TRANSFORM_TEX is the same as the old shader library.
    output.uv = TRANSFORM_TEX(input.uv,_BaseMap);

    // packing positionWS(xyz) & fog(w) into a vector4

    //可以直接用VertexInput获取，这样手动计算是为了复习，快速看到实现过程
    output.positionWSAndFogFactor = float4(positionWS, fogFactor);
    output.normalWS = vertexNormalInput.normalWS; //normlaized already by GetVertexNormalInputs(...)
    
    output.positionCS = TransformWorldToHClip(positionWS);
    output.positionVS = vertexInput.positionVS;
    output.positionNDC = vertexInput.positionNDC;
    // output.viewDirWS = normalize(GetCameraPositionWS() - vertexInput.positionWS);
    output.viewDirWS = SafeNormalize(GetCameraPositionWS() - vertexInput.positionWS);
    output.normalDirVS = mul((real3x3)UNITY_MATRIX_IT_MV,input.normalOS);
    output.screenPos = ComputeScreenPos(output.positionCS);
    output.tangentWS = normalize(mul(unity_ObjectToWorld, float4(input.tangentOS.xyz, 0.0)).xyz);
    output.bitangentWS = normalize(cross(output.normalWS, output.tangentWS) * input.tangentOS.w);
    output.vertexColor = input.vertexColor;
    output.shadowCoord = TransformWorldToShadowCoord(vertexInput.positionWS);

    #if defined ToonShaderIsOutline
        // [Read ZOffset mask texture]
        // we can't use tex2D() in vertex shader because ddx & ddy is unknown before rasterization, 
        // so use tex2Dlod() with an explict mip level 0, put explict mip level 0 inside the 4th component of param uv)
        float outlineZOffsetMaskTexExplictMipLevel = 0;
        float outlineZOffsetMask = SAMPLE_TEXTURE2D_LOD(_OutlineZOffsetMaskTex, sampler_OutlineZOffsetMaskTex,input.uv,outlineZOffsetMaskTexExplictMipLevel).r; //we assume it is a Black/White texture

        // [Remap ZOffset texture value]
        // flip texture read value so default black area = apply ZOffset, because usually outline mask texture are using this format(black = hide outline)
        outlineZOffsetMask = 1-outlineZOffsetMask;
        outlineZOffsetMask = invLerpClamp(_OutlineZOffsetMaskRemapStart,_OutlineZOffsetMaskRemapEnd,outlineZOffsetMask);// allow user to flip value or remap

        // [Apply ZOffset, Use remapped value as ZOffset mask]
        output.positionCS = iMixGetNewClipPosWithZOffset(output.positionCS, _OutlineZOffset * outlineZOffsetMask + 0.03 * _IsFace);
    #endif

    // ShadowCaster pass needs special process to positionCS, else shadow artifact will appear
    //--------------------------------------------------------------------------------------
    #if defined ToonShaderApplyShadowBiasFix
        // see GetShadowPositionHClip() in URP/Shaders/ShadowCasterPass.hlsl
        // https://github.com/Unity-Technologies/Graphics/blob/master/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl
        float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, output.normalWS, _LightDirection));

        #if UNITY_REVERSED_Z
            positionCS.z = min(positionCS.z, positionCS.w * UNITY_NEAR_CLIP_VALUE);
        #else
            positionCS.z = max(positionCS.z, positionCS.w * UNITY_NEAR_CLIP_VALUE);
        #endif
        output.positionCS = positionCS;
    #endif
    //--------------------------------------------------------------------------------------    

    return output;
}

// PBR
float3 mon2lin(float3 x)
{
    return float3(pow(x[0], 2.2), pow(x[1], 2.2), pow(x[2], 2.2));
}
float sqr(float x) { return x*x; }
///
/// PBR direct
///            
float3 compute_F0(float eta)
{
    return pow((eta-1)/(eta+1), 2);
}
float3 F_fresnelSchlick(float VdotH, float3 F0)  // F
{
    return F0 + (1.0 - F0) * pow(1.0 - VdotH, 5.0);
}
float3 F_SimpleSchlick(float HdotL, float3 F0)
{
    return lerp(exp2((-5.55473*HdotL-6.98316)*HdotL), 1, F0);
}
float SchlickFresnel(float u)
{
    float m = clamp(1-u, 0, 1);
    float m2 = m*m;
    return m2*m2*m; // pow(m,5)
}
float3 fresnelSchlickRoughness(float cosTheta, float3 F0, float roughness)
{
    return F0 + (max(float3(1.0 - roughness,1.0 - roughness,1.0 - roughness), F0) - F0) * pow(1.0 - cosTheta, 5.0);
}   
float D_GTR2(float NdotH, float a)    // D
{
    float a2 = a*a;
    float t = 1 + (a2-1)*NdotH*NdotH;
    return a2 / (PI * t*t);
}
// X: tangent
// Y: bitangent
// ax: roughness along x-axis
float GTR2_aniso(float NdotH, float HdotX, float HdotY, float ax, float ay)
{
    return 1 / (PI * ax*ay * sqr( sqr(HdotX/ax) + sqr(HdotY/ay) + NdotH*NdotH ));
}
float GeometrySchlickGGX(float NdotV, float k)
{
    float nom   = NdotV;
    float denom = NdotV * (1.0 - k) + k;
    
    return nom / denom;
}
float G_Smith(float3 N, float3 V, float3 L)
{
    float k = pow(_roughness+1, 2)/8;
    float NdotV = max(dot(N, V), 0.0);
    float NdotL = max(dot(N, L), 0.0);
    float ggx1 = GeometrySchlickGGX(NdotV, k);
    float ggx2 = GeometrySchlickGGX(NdotL, k);
    
    return ggx1 * ggx2;
}
float3 Diffuse_Simple(float3 DiffuseColor, float3 F, float NdotL)
{
    float3 KD = (1-F)*(1-_metallic);
    return KD*DiffuseColor*GetMainLight().color*NdotL;
}
float SSS( float3 L, float3 V, float3 N, float3 baseColor)
{
    float NdotL = dot(N,L);
    float NdotV = dot(N,V);
    if (NdotL < 0 || NdotV < 0)
    {
        //NdotL = 0.15f;
    }
    float3 H = normalize(L+V);
    float LdotH = dot(L,H);

    float3 Cdlin = mon2lin(baseColor);
    if (NdotL < 0 || NdotV < 0)
    {
        return (1/PI)*Cdlin * (1-_metallic);
    }

    float FL = SchlickFresnel(NdotL), FV = SchlickFresnel(NdotV);
    float Fd90 = 0.5 + 2 * LdotH*LdotH * _roughness;
    float Fd = lerp(1.0, Fd90, FL) * lerp(1.0, Fd90, FV);
    
    float Fss90 = LdotH*LdotH*_roughness;
    float Fss = lerp(1.0, Fss90, FL) * lerp(1.0, Fss90, FV);
    float ss = 1.25 * (Fss * (1 / (NdotL + NdotV) - .5) + .5);

    
    return (1/PI) * lerp(Fd, ss, _subsurface)*Cdlin * (1-_metallic);
}
float3 BRDF_Simple( float3 L, float3 V, float3 N, float3 X, float3 Y, float3 baseColor)
{
    float NdotL = dot(N,L);
    float NdotV = dot(N,V);
    
    float3 H = normalize(L+V);
    float NdotH = dot(N,H);
    float LdotH = dot(L,H);
    float VdotH = dot(V,H);
    float HdotL = dot(H,L);

    float D;

    if (_anisotropic < 0.1f)
    {
        D = D_GTR2(NdotH, _roughness);
    }
    else
    {
        float aspect = sqrt(1-_anisotropic*.9);
        float ax = max(.001, sqr(_roughness)/aspect);
        float ay = max(.001, sqr(_roughness)*aspect);
        D = GTR2_aniso(NdotH, dot(H, X), dot(H, Y), ax, ay);
    }
    
    //float F = F_fresnelSchlick(VdotH, compute_F0(_ior));
    float3 F = F_SimpleSchlick(HdotL, compute_F0(_ior));
    float G = G_Smith(N,V,L);

    float3 brdf = D*F*G / (4*NdotL*NdotV);

    // float3 brdf_diff = Diffuse_Simple(baseColor, F, NdotL);
    
    return saturate(brdf * GetMainLight().color * NdotL * PI*_SpecularWeightPBR);
    // return brdf;
}
///
/// PBR indirect
///
float3 F_Indir(float NdotV,float3 F0,float roughness)
{
    float Fre=exp2((-5.55473*NdotV-6.98316)*NdotV);
    return F0+Fre*saturate(1-roughness-F0);
}
// sample spherical harmonics
float3 Env_Diffuse(float3 N)
{
    real4 SHCoefficients[7];
    SHCoefficients[0] = unity_SHAr;
    SHCoefficients[1] = unity_SHAg;
    SHCoefficients[2] = unity_SHAb;
    SHCoefficients[3] = unity_SHBr;
    SHCoefficients[4] = unity_SHBg;
    SHCoefficients[5] = unity_SHBb;
    SHCoefficients[6] = unity_SHC;
    
    return max(float3(0, 0, 0), SampleSH9(SHCoefficients, N));
}
// sample reflection probe
float3 Env_SpecularProbe(float3 N, float3 V)
{
    float3 reflectWS = reflect(-V, N);
    float mip = _roughness * (1.7 - 0.7 * _roughness) * 6;

    float4 specColorProbe = SAMPLE_TEXTURECUBE_LOD(unity_SpecCube0, samplerunity_SpecCube0, reflectWS, mip);
    float3 decode_specColorProbe = DecodeHDREnvironment(specColorProbe, unity_SpecCube0_HDR);
    return decode_specColorProbe;
}
float3 BRDF_Indirect_Simple( float3 L, float3 V, float3 N, float3 X, float3 Y, float3 baseColor)
{
    float3 relfectWS = reflect(-V, N);
    float3 env_Cubemap = texCUBElod(_Cubemap, float4(relfectWS, _CubemapMip)).rgb;
    float fresnel = pow(max(0.0, 1.0 - dot(N,V)), _FresnelPow);
    float3 env_Fresnel = env_Cubemap * fresnel + _FresnelColor * fresnel;

    return env_Fresnel;
}
float3 BRDF_Indirect( float3 L, float3 V, float3 N, float3 X, float3 Y, float3 baseColor)
{
    // diff
    float3 F = F_Indir(dot(N,V), compute_F0(_ior), _roughness);
    float3 env_diff = Env_Diffuse(N)*(1-F)*(1-_metallic)*baseColor;

    // specular
    float3 env_specProbe = Env_SpecularProbe(N,V);
    float3 Flast = fresnelSchlickRoughness(max(dot(N,V), 0.0), compute_F0(_ior), _roughness);
    float2 envBDRF = SAMPLE_TEXTURE2D(_IBL_LUT, sampler_IBL_LUT, float2(dot(N,V), _roughness)).rg;
    float3 env_specular = env_specProbe * (Flast * envBDRF.r + envBDRF.g);

    return saturate(env_diff + env_specular);
}




float4 ShadeFinalColor(Varyings input) : SV_TARGET
{
    Light mainLight = GetMainLight(input.shadowCoord);

    // ToonSurfaceData surfaceData = InitializeSurfaceData(input);
    float4 albedo = SAMPLE_TEXTURE2D(_BaseMap,sampler_BaseMap,input.uv) * _BaseColor;


    float3 lightDirection = normalize(mainLight.direction);
    float3 normal = normalize(input.normalWS);
    float3 tangent = normalize(input.tangentWS);
    float3 bitangent = normalize(input.bitangentWS);

    float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - input.positionWSAndFogFactor.xyz);
    float3 halfDirection = normalize(lightDirection + viewDirection);

    float NdotV = dot(normal, viewDirection);
    float NdotL = dot(normal, lightDirection);
    float NdotH = dot(normal, halfDirection);
    float VdotL = dot(viewDirection, lightDirection);
    float VdotH = dot(viewDirection, halfDirection);
    float LdotH = dot(lightDirection, halfDirection);
    float BdotH = dot(bitangent, halfDirection);
    float LdotB = dot(lightDirection, bitangent);
	float VdotB = dot(viewDirection, bitangent);

    half3 finalNPR = (0,0,0);

    // occlusion
    half lightmapResult = 1;
    if(_UseLightMap && !_IsFace)
    {
        half4 texValue = SAMPLE_TEXTURE2D(_LightMap,sampler_LightMap, input.uv);  
        half lightmapValue = dot(texValue, _LightMapChannelMask);      
        lightmapValue = floatLerp(1, lightmapValue, _LightMapStrength);
        lightmapValue = invLerpClamp(_LightMapRemapStart, _LightMapRemapEnd, lightmapValue);
        lightmapResult = lightmapValue;
    }
    if(_UseLightMap && _IsFace){
    half4 texValue = SAMPLE_TEXTURE2D(_LightMap,sampler_LightMap, input.uv);  
    half4 texValueInverse = SAMPLE_TEXTURE2D(_LightMap,sampler_LightMap, -input.uv);
    half faceShadowLeft = dot(texValue, _LightMapChannelMask);
    half faceShadowRight = dot(texValueInverse, _LightMapChannelMask);

    float2 lightHorizontalDirection = normalize(lightDirection.xz);

    float HeadForwardDotLight = dot(normalize(_HeadForward.xz), normalize(lightHorizontalDirection));
    float RightDotLight =  dot(normalize(_HeadRight.xz), normalize(lightHorizontalDirection));
    RightDotLight = -(acos(RightDotLight)/3.14159265-0.5)*2;

    half faceLightData = lerp(faceShadowRight,faceShadowLeft,step(RightDotLight,0));
    faceLightData = pow(faceLightData,_LightMapIntensity);
    
    //face shadow mask
    half faceShadowMask = SAMPLE_TEXTURE2D(_FaceShadowMap,sampler_FaceShadowMap,input.uv).r;

    lightmapResult = smoothstep((-HeadForwardDotLight+1)/2-0.01,(-HeadForwardDotLight+1)/2+0.01,faceLightData) * faceShadowMask;  
}
           
    //main light (diffuse)
    float3 fixedLightDirection = normalize(float3Lerp(lightDirection, float3(lightDirection.x, 0, lightDirection.z), _LightingDirectionFix));
    float NdotFL = dot(normal, fixedLightDirection);

    half3 averageSH = SampleSH(0);
    averageSH = max(_IndirectLightMinColor,averageSH);

    // indirect occlusion (maximum 50% darken for indirect to prevent result becomes completely black)
    half indirectOcclusion = floatLerp(1, lightmapResult, 0.5);
    half3 indirectResult = averageSH * indirectOcclusion;

    float3 shadowTestPosWS = input.positionWSAndFogFactor.xyz + mainLight.direction * (_ReceiveShadowMappingPosOffset + _IsFace);
    // #if defined _MAIN_LIGHT_SHADOWS
        // doing this is usually for hide ugly self shadow for shadow sensitive area like face
        float4 shadowCoord = TransformWorldToShadowCoord(shadowTestPosWS);
        mainLight.shadowAttenuation = MainLightRealtimeShadow(shadowCoord);
    // #endif 
    //separated from UCTS2 
    half litOrShadowArea = smoothstep(_CelShadeMidPoint-_CelShadeSoftness,_CelShadeMidPoint+_CelShadeSoftness, NdotFL-_CelShadowBias);
    // half litOrShadowArea = smoothstep(_CelShadeMidPoint-_CelShadeSoftness,_CelShadeMidPoint+_CelShadeSoftness, NdotL-_CelShadowBias);
    litOrShadowArea *= lightmapResult;

    // face ignore celshade 
    if(_IsFace && !_UseLightMap){  
        litOrShadowArea = floatLerp(0.5,1,litOrShadowArea);
    }

    // light's shadow map
    litOrShadowArea *= floatLerp(1,mainLight.shadowAttenuation,_ReceiveShadowMappingAmount);
    half3 litOrShadowColor = float3Lerp(_ShadowMapColor,1, litOrShadowArea);
        
    //main light's result is diffuse color
    half3 mainLightColor = mainLight.color;
    if(_UseCustomLightColor){
        mainLightColor = _CustomLightColor;
    }
    half3 mainLightResult = saturate(mainLightColor) * min(4,mainLight.distanceAttenuation)* litOrShadowColor; 


    //addition light (diffuse)
    half3 additionalLightResultSum = 0;

    #if defined _ADDITIONAL_LIGHTS
        // These lights are culled per-object in the forward renderer of URP.
        int additionalLightsCount = GetAdditionalLightsCount();
        for (int i = 0; i < additionalLightsCount; ++i)
        {
            int perObjectLightIndex = GetPerObjectLightIndex(i);
            Light additionalLight = GetAdditionalPerObjectLight(perObjectLightIndex, input.positionWSAndFogFactor.xyz); // use original positionWS for lighting
            float NdotAL = dot(normal, normalize(additionalLight.direction));
            
            additionalLight.shadowAttenuation = AdditionalLightRealtimeShadow(perObjectLightIndex, shadowTestPosWS); // use offseted positionWS for shadow test

    half litOrShadowArea = smoothstep(_CelShadeMidPoint-_CelShadeSoftness,_CelShadeMidPoint+_CelShadeSoftness, NdotAL-_CelShadowBias);

    litOrShadowArea *= lightmapResult;

    // face ignore celshade since it is usually very ugly using NoL method
    
    if(_IsFace && !_UseLightMap){        
        litOrShadowArea = floatLerp(0.5,1,litOrShadowArea);
    }
    
    // light's shadow map
    litOrShadowArea *= floatLerp(1,additionalLight.shadowAttenuation,_ReceiveShadowMappingAmount);

    half3 litOrShadowColor = float3Lerp(_ShadowMapColor,1, litOrShadowArea);

    additionalLightResultSum += saturate(additionalLight.color) * litOrShadowColor * min(4,mainLight.distanceAttenuation) *  0.25 ;
        }
    #endif

    //Specular
    float3 finalSpecularColor = (0,0,0);
    if(_UseNPRSpecular){
    float linear01SpecularFactorCommon = pow(saturate(NdotH), _SpecularGlossness);
    float linear01SpecularFactorAnisotropic = pow(saturate(sqrt(1 - BdotH * BdotH)), _SpecularGlossness);
    float linear01SpecularFactor = smoothstep(0.5 - _SpecularSmoothstep * 0.5, 0.5 + _SpecularSmoothstep * 0.5, floatLerp(linear01SpecularFactorCommon, linear01SpecularFactorAnisotropic, _SpecularMode));
    finalSpecularColor = _SpecularColor.rgb * linear01SpecularFactor * mainLightResult;
    }
    
    // float3 normalVS = normalize(mul((float3x3)UNITY_MATRIX_V,N));specular
    float2 matcapUV = input.normalDirVS.xy * 0.5 + 0.5;
            if(_UseToonRamp
    ){
    float4 toonRampMap = SAMPLE_TEXTURE2D(_ToonRampMap,sampler_ToonRampMap,matcapUV);
    albedo.rgb = float3Lerp(albedo.rgb,albedo.rgb * toonRampMap.rgb, _ToonRampMapFac);
            }

    //alpha
    #if _UseAlphaClipping
        clip(albedo.a - _Cutoff);
    #endif

    // emission
    half3 emission = 0;
    if(_UseEmission)
    {
        emission = SAMPLE_TEXTURE2D(_EmissionMap,sampler_EmissionMap,input.uv).rgb * _EmissionMapChannelMask * _EmissionColor.rgb;
    }
    half3 emissionResult = float3Lerp(emission, emission * albedo, _EmissionMulByBaseColor); // optional mul albedo

    //rimLight : 屏幕空间深度边缘光
    // float linear01RimLightFactor = smoothstep(0.5 - _RimLightSmoothstep * 0.5, 0.5 + _RimLightSmoothstep * 0.5, (1 - saturate(NdotV - _RimLightBias * 0.5)));
    // linear01RimLightFactor *= floatLerp(linear01DiffuseFactor, 1, _ShadingSideRimLight);
    // float3 finalRimLightColor = _RimLightColor.rgb * linear01RimLightFactor * float3Lerp(float3(1, 1, 1), albedo, _RimLightAlbedoMix) * finalDiffuseColor * (float3(1, 1, 1) + finalAdditionalLightingColor);

    float3 nonHomogeneousCoord = input.positionNDC.xyz / input.positionNDC.w;
    float2 screenUV = nonHomogeneousCoord.xy;
    // 保持z不变
    float3 offsetPosVS = float3(input.positionVS.xy + input.normalDirVS.xy * _RimWidth*0.1, input.positionVS.z);
    float4 offsetPosCS = TransformWViewToHClip(offsetPosVS);
    float4 offsetPosVP = TransformHClipToViewPortPos(offsetPosCS);

    float depth = SAMPLE_TEXTURE2D_X(_CameraDepthTexture,sampler_CameraDepthTexture,screenUV);
    float linearEyeDepth = LinearEyeDepth(depth, _ZBufferParams); // 离相机越近越大

    float offsetDepth =  SAMPLE_TEXTURE2D_X(_CameraDepthTexture,sampler_CameraDepthTexture,offsetPosVP);
    float linearEyeOffsetDepth = LinearEyeDepth(offsetDepth, _ZBufferParams);

    float depthDiff = linearEyeOffsetDepth - linearEyeDepth;
    float rimMask = smoothstep(0, _RimThreshold, depthDiff);

    float3 rimLight = rimMask* float3Lerp(_RimColor.rgb,float3Lerp(min(_RimColor.rgb,albedo.rgb),
    max(_RimColor.rgb,albedo.rgb),_RimBlend),_ISRIMBLEND) ;


    half3 rawLightSum = max(indirectResult, mainLightResult + additionalLightResultSum); // pick the highest between indirect and direct light
    
    // finalNPR = rawLightSum * albedo + emissionResult + rimLight;
    //copy colin(rimlight be affected by light)
    finalNPR = (rawLightSum + finalSpecularColor) * albedo+rimLight*litOrShadowArea + emissionResult ;
    // finalNPR = finalSpecularColor+rawLightSum * albedo+rimLight*litOrShadowArea + emissionResult ;
    
    #if defined ToonShaderIsOutline //只有 Outline的 frag 输出乘以_OutlineColor, 因为outline的shader里define了ToonShaderIsOutline
        finalNPR = lerp(_OutlineColor.rgb,finalNPR.rgb,_OutlineColorBlend);
        // finalNPR = finalNPR * _OutlineColor;
    #endif

    half fogFactor = input.positionWSAndFogFactor.w;
    finalNPR = MixFog(finalNPR, fogFactor);

    // float3 characterFront = unity_ObjectToWorld._12_22_32;   // 角色朝向
    //PBR
    half3 finalPBR  = (0,0,0);
    float3 brdf_simple = BRDF_Simple(lightDirection, viewDirection, normal, tangent, bitangent, albedo);

    float3 sss = SSS(lightDirection, viewDirection, normal, albedo);

    float3 pbr_result = brdf_simple;
    
    //  PBR Env Light 
    float3 brdf_env_simple = BRDF_Indirect_Simple(lightDirection, viewDirection, normal, tangent, bitangent, albedo);
    float3 brdf_env = BRDF_Indirect(lightDirection, viewDirection, normal, tangent, bitangent, albedo);
    
    float3 env_result = brdf_env;

    finalPBR = _WeightPBR * pbr_result + _WeightEnvLight * env_result + sss*_sssColor*_SSSWeightPBR;
    
    float4 color = (1,1,1,1);
    color.rgb = finalNPR*_WeightFinalNPR+finalPBR*_WeightFinalPBR;
    color.a = albedo.a;
    // return input.vertexColor;

    return color;
    // return float4(1,1,1,1);
    // return toonRampMap;
    // return lightmapResult;
    // return litOrShadowArea;
    // return mainLight.shadowAttenuation;
    // return float4(0,0,0,1);
    // return half4(surfaceData.rimLight,1);
}

