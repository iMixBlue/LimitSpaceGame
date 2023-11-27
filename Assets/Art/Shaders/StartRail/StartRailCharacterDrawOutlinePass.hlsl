struct Attributes
{
    float3 positionOS : POSITION;
    half3 normalOS    : NORMAL;
    half4 tangentOS   : TANGENT;
    float2 uv         : TEXCOORD0;
    float4 uv7        : TEXCOORD7;
    float4 color      : COLOR;
};

struct Varyings
{
    float2 uv                       : TEXCOORD0;
    float  fogFactor                : TEXCOORD1; 
    float4 positionCS               : SV_POSITION; 
    float4 color                    : TEXCOORD5;
};

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

Varyings vert(Attributes input){
    Varyings output = (Varyings)0;

    VertexPositionInputs vertexPositionInput = GetVertexPositionInputs(input.positionOS);
    VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);

    float width = _OutlineWidth;
    width *= GetOutlineCameraFovAndDistanceFixMultiplier(vertexPositionInput.positionVS.z);  // TODO:限定描边的最粗和最细值

    float3 positionWS = vertexPositionInput.positionWS;
    #if _OUTLINE_UV7_SMOOTH_NORMAL
        float3x3 tbn = float3x3(vertexNormalInput.tangentWS, vertexNormalInput.bitangentWS,vertexNormalInput.normalWS);
        positionWS += mul(input.uv7.rgb, tbn) * width;
    #else
       positionWS += vertexNormalInput.normalWS * width;
    #endif
    output.positionCS = TransformWorldToHClip(positionWS);

    output.uv = TRANSFORM_TEX(input.uv, _BaseMap);
    output.fogFactor = ComputeFogFactor(vertexPositionInput.positionCS.z);
    return output;
}

float4 frag(Varyings input) : SV_TARGET
{

   float3 coolRamp = 0;
   float3 warmRamp = 0;
    
   #if _AREA_HAIR
   {
    float2 outlineUV = float2(0,0.5);
    coolRamp = SAMPLE_TEXTURE2D(_HairCoolRamp, sampler_HairCoolRamp,outlineUV).rgb;
    warmRamp = SAMPLE_TEXTURE2D(_HairWarmRamp, sampler_HairWarmRamp, outlineUV).rgb;
   }
   # elif _AREA_UPPERBODY|| _AREA_LOWERBODY
   {
    float4 lightMap = 0;
    #if _AREA_UPPERBODY
        lightMap = SAMPLE_TEXTURE2D(_UpperBodyLightMap, sampler_UpperBodyLightMap, input.uv);
    #elif _AREA_LOWERBODY
        lightMap = SAMPLE_TEXTURE2D(_LowerBodyLightMap, sampler_LowerBodyLightMap, input.uv);
    #endif
    float materialEnum = lightMap.a;
    float materialEnumOffset = materialEnum + 0.0425;
    float outlineUVy = lerp(materialEnumOffset, materialEnumOffset + 0.5 < 1? materialEnumOffset + 0.5 : materialEnumOffset + 0.5 - 1, fmod((round(materialEnumOffset/0.0625)-1)/2,2));
    float2 outlineUV = float2(0, outlineUVy - 0.5); // -0.5是没有任何道理的trick
    coolRamp = SAMPLE_TEXTURE2D(_BodyCoolRamp, sampler_BodyCoolRamp,outlineUV).rgb;
    warmRamp = SAMPLE_TEXTURE2D(_BodyWarmRamp, sampler_BodyWarmRamp,outlineUV).rgb;
   }
   #elif _AREA_FACE
   {
   float2 outlineUV = float2(0,0.0625);
    coolRamp = SAMPLE_TEXTURE2D(_BodyCoolRamp,sampler_BodyCoolRamp,outlineUV).rgb;
    warmRamp = SAMPLE_TEXTURE2D(_BodyWarmRamp,sampler_BodyWarmRamp,outlineUV).rgb;
   }
   #endif

   float3 ramp = lerp(coolRamp, warmRamp,0.5);
   float3 albedo = pow(saturate(ramp) , _OutlineGamma);
   float4 color = float4(albedo,1);
   color.rgb = MixFog(color.rgb,input.fogFactor);
   return color;
}