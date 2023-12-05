// Write by iMixBlue


#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"


//float version lerp
float3 float3Lerp(float3 a, float3 b, float c)
{
    return a * (1 - c) + b * c;
}

float floatLerp(float a, float b, float c)
{
    return a * (1 - c) + b * c;
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
    float3 KD = (1-F)*(1-_Metallic);
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
        return (1/PI)*Cdlin * (1-_Metallic);
    }

    float FL = SchlickFresnel(NdotL), FV = SchlickFresnel(NdotV);
    float Fd90 = 0.5 + 2 * LdotH*LdotH * _roughness;
    float Fd = lerp(1.0, Fd90, FL) * lerp(1.0, Fd90, FV);
    
    float Fss90 = LdotH*LdotH*_roughness;
    float Fss = lerp(1.0, Fss90, FL) * lerp(1.0, Fss90, FV);
    float ss = 1.25 * (Fss * (1 / (NdotL + NdotV) - .5) + .5);

    
    return (1/PI) * lerp(Fd, ss, _subsurface)*Cdlin * (1-_Metallic);
}
// float3 BRDF_Simple( float3 L, float3 V, float3 N, float3 X, float3 Y, float3 baseColor)
// {
//     float NdotL = dot(N,L);
//     float NdotV = dot(N,V);
    
//     float3 H = normalize(L+V);
//     float NdotH = dot(N,H);
//     float LdotH = dot(L,H);
//     float VdotH = dot(V,H);
//     float HdotL = dot(H,L);

//     float D;

//     if (_anisotropic < 0.1f)
//     {
//         D = D_GTR2(NdotH, _roughness);
//     }
//     else
//     {
//         float aspect = sqrt(1-_anisotropic*.9);
//         float ax = max(.001, sqr(_roughness)/aspect);
//         float ay = max(.001, sqr(_roughness)*aspect);
//         D = GTR2_aniso(NdotH, dot(H, X), dot(H, Y), ax, ay);
//     }
    
//     //float F = F_fresnelSchlick(VdotH, compute_F0(_ior));
//     float3 F = F_SimpleSchlick(HdotL, compute_F0(_ior));
//     float G = G_Smith(N,V,L);

//     float3 brdf = D*F*G / (4*NdotL*NdotV);

//     // float3 brdf_diff = Diffuse_Simple(baseColor, F, NdotL);
    
//     return saturate(brdf * GetMainLight().color * NdotL * PI*_SpecularWeightPBR);
//     // return brdf;
// }
//
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
    float3 env_diff = Env_Diffuse(N)*(1-F)*(1-_Metallic)*baseColor;

    // specular
    float3 env_specProbe = Env_SpecularProbe(N,V);
    float3 Flast = fresnelSchlickRoughness(max(dot(N,V), 0.0), compute_F0(_ior), _roughness);
    float2 envBDRF = SAMPLE_TEXTURE2D(_IBL_LUT, sampler_IBL_LUT, float2(dot(N,V), _roughness)).rg;
    float3 env_specular = env_specProbe * (Flast * envBDRF.r + envBDRF.g);

    return saturate(env_diff + env_specular);
}




