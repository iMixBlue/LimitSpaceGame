struct Attributes
{
    float3 positionOS : POSITION;
    half3 normalOS    : NORMAL;
    half4 tangentOS   : TANGENT;
    float2 uv         : TEXCOORD0;
    float4 color      : COLOR;
};

struct Varyings
{
    float2 uv                       : TEXCOORD0;
    float4 positionWSAndFogFactor   : TEXCOORD1; // xyz: positionWS, w: vertex fog factor
    float3 normalWS                 : TEXCOORD2;
    float3 viewDirectionWS          : TEXCOORD3;
    float3 SH                       : TEXCOORD4;
    float4 positionCS               : SV_POSITION; 
    float4 color                    : TEXCOORD5;
};

struct Gradient
{
    int colorsLength;
    float4 colors[8];
};

Gradient GradientConstruct()
{
    Gradient g;
    g.colorsLength = 2;
    g.colors[0] = float4(1,1,1,0);
    g.colors[1] = float4(1,1,1,1);
    g.colors[2] = float4(0,0,0,0);
    g.colors[3] = float4(0,0,0,0);
    g.colors[4] = float4(0,0,0,0);
    g.colors[5] = float4(0,0,0,0);
    g.colors[6] = float4(0,0,0,0);
    g.colors[7] = float4(0,0,0,0);
    return g;
}

float3 SampleGradient(Gradient Gradient, float Time)
{
    float3 color = Gradient.colors[0].rgb;
    for(int c = 1; c< Gradient.colorsLength;c++){
        float colorPos = saturate((Time - Gradient.colors[c-1].w) / (Gradient.colors[c].w - Gradient.colors[c-1].w)) * step(c, Gradient.colorsLength -1);
        color = lerp(color,Gradient.colors[c].rgb, colorPos);
    }
    #ifdef UNITY_COLORSPACE_GAMMA
        COLOR = LinearToSRGB(color);
    #endif
        return color;
}
float3 desaturation(float3 color)
{
float3 grayXfer = float3(0.3,0.59,0.11);
float grayf = dot(color,grayXfer);
return float3(grayf,grayf,grayf);
}
Varyings vert(Attributes input)
{
    Varyings output = (Varyings)0;
    VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS); 
    VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);

    output.uv = TRANSFORM_TEX(input.uv, _BaseMap);
    output.positionWSAndFogFactor = float4(vertexInput.positionWS, ComputeFogFactor(vertexInput.positionCS.z));
    output.normalWS = vertexNormalInput.normalWS;
    output.viewDirectionWS = unity_OrthoParams.w == 0 ? GetCameraPositionWS() - vertexInput.positionWS : GetWorldToViewMatrix()[2].xyz;
    output.SH = SampleSH(lerp(vertexNormalInput.normalWS,float3(0,0,0), _IndirectLightFlattenNormal));
    output.positionCS = vertexInput.positionCS;

    return output;
}

float4 frag(Varyings input, bool isFrontFace : SV_IsFrontFace) : SV_TARGET
{
    float3 positionWS = input.positionWSAndFogFactor.xyz;
    float4 shadowCoord = TransformWorldToShadowCoord(positionWS);
    Light mainLight = GetMainLight(shadowCoord);
    float3 lightDirectionWS = normalize(mainLight.direction);
    float3 normalWS = normalize(input.normalWS);
    float3 viewDirectionWS = normalize(input.viewDirectionWS);

    float3 baseColor = SAMPLE_TEXTURE2D(_BaseMap,sampler_BaseMap,input.uv);
    
  
    float4 areaMap = 0;
    #if _AREA_FACE
        areaMap = SAMPLE_TEXTURE2D(_FaceColorMap,sampler_FaceColorMap,input.uv);
    #elif _AREA_HAIR
        areaMap = SAMPLE_TEXTURE2D(_HairColorMap,sampler_HairColorMap,input.uv);
    #elif _AREA_UPPERBODY
        areaMap = SAMPLE_TEXTURE2D(_UpperBodyColorMap,sampler_UpperBodyColorMap,input.uv);
    #elif _AREA_LOWERBODY
        areaMap = SAMPLE_TEXTURE2D(_LowerBodyColorMap,sampler_LowerBodyColorMap,input.uv);
    #endif
    baseColor = areaMap.rgb;
    baseColor *= lerp(_BackFaceTintColor, _FrontFaceTintColor, isFrontFace);

    float4 lightMap = 0;
    #if _AREA_HAIR || _AREA_UPPERBODY || _AREA_LOWERBODY
    {
        #if _AREA_HAIR
            lightMap = SAMPLE_TEXTURE2D(_HairLightMap,sampler_HairLightMap,input.uv);  // 三月七没有头发lightMap，只能先这样
            // lightMap.r = 0.5;
            lightMap.g = 0.5;
            lightMap.b = 0;
            lightMap.a = 0.015;
        #elif _AREA_UPPERBODY
            lightMap = SAMPLE_TEXTURE2D(_UpperBodyLightMap,sampler_UpperBodyLightMap,input.uv);
        #elif _AREA_LOWERBODY
            lightMap = SAMPLE_TEXTURE2D(_LowerBodyLightMap,sampler_LowerBodyLightMap,input.uv);
        #endif
    }
    #endif
    float4 faceMap = 0;
    #if _AREA_FACE
        faceMap = SAMPLE_TEXTURE2D(_FaceMap, sampler_FaceMap,input.uv);
    #endif

    float3 indirectLightColor = input.SH.rgb * _IndirectLightUsage;
    #if _AREA_HAIR || _AREA_UPPERBODY || _AREA_LOWERBODY
    indirectLightColor *= lerp(1,lightMap.r, _IndirectLightOcclusionUsage);
    #else
    indirectLightColor *= lerp(1, lerp(faceMap.g,1,step(faceMap.r,0.5)),_IndirectLightOcclusionUsage); 
    #endif
    indirectLightColor *= lerp(1,baseColor,_IndirectLightMixBaseColor);

    float3 mainLightColor = lerp(desaturation(mainLight.color),mainLight.color,_MainLightColorUsage);
    float mainLightShadow = 1;
    float mainLightShadowForRamp = 1;
    int rampRowIndex = 0;
    int rampRowNum = 1;
    #if _AREA_HAIR || _AREA_BODY || _AREA_LOWERBODY
    {
       float NoL = dot(normalWS, lightDirectionWS);
       //mainLightShadow = step(0,NoL);
       float remappedNoL = NoL * 0.5 + 0.5;
       //mainLightShadow = step(1-lightMap.g, remappedNoL); //硬阴影
       mainLightShadow = smoothstep(1 - lightMap.g + _ShadowThresholdCenter - _ShadowThresholdSoftness,1 - lightMap.g + _ShadowThresholdCenter + _ShadowThresholdSoftness, remappedNoL); //软阴影
       mainLightShadow *= lightMap.r;

    #if _AREA_HAIR
           rampRowIndex = 0;
           rampRowNum = 1;
    #elif _AREA_UPPERBODY || _AREA_LOWERBODY
          int rawIndex = (round((lightMap.a + 0.0425)/0.0625)-1)/2;
          rampRowIndex = lerp(rawIndex, rawIndex + 4<8? rawIndex +4: rawIndex +4-8,fmod(rawIndex,2));
          rampRowNum = 8;
    #endif
    }
    #elif _AREA_FACE
    {
    float3 headForward = normalize(_HeadForward);
    float3 headRight = normalize(_HeadRight);
    float3 headUp = cross(headForward, headRight);

    float3 fixedLightDirectionWS = normalize(lightDirectionWS - dot(lightDirectionWS, headUp) * headUp);
    float2 sdfUV = float2(sign(dot(fixedLightDirectionWS, headRight)),1) * input.uv ;
    float sdfValue = SAMPLE_TEXTURE2D(_FaceMap,sampler_FaceMap,sdfUV).a;
    sdfValue += _FaceShadowOffset;

    float sdfThreshold = 1- (dot(fixedLightDirectionWS, headForward) * 0.5 + 0.5);
    float sdf = smoothstep(sdfThreshold - _FaceShadowTransitionSoftness, sdfThreshold + _FaceShadowTransitionSoftness, sdfValue);
    //float sdf = step(sdfThreshold, sdfValue);

    mainLightShadow = lerp(faceMap.g,sdf, step(faceMap.r,0.5));
    //mainLightShadow = faceMap.r;

    rampRowIndex = 0;
    rampRowNum = 8;
    
    }
    #endif
    // mainLightShadow> 0.1 : ?
    // float rampUVx = _test1;
    float rampUVx = mainLightShadow * (1-_ShadowRampOffset) + _ShadowRampOffset;  // 变化集中在3/4处，挤压一下
    // float rampUVx = mainLightShadow;
    float rampUVy=(2*rampRowIndex + 1) * (1.0 / (rampRowNum * 2));
    float2 rampUV = float2(rampUVx,rampUVy);
    float3 coolRamp = 1;
    float3 warmRamp = 1;
    #if _AREA_HAIR 
        coolRamp = SAMPLE_TEXTURE2D(_HairCoolRamp,sampler_HairCoolRamp,rampUV).rgb;
        warmRamp = SAMPLE_TEXTURE2D(_HairWarmRamp,sampler_HairWarmRamp,rampUV).rgb;
    #elif _AREA_FACE || _AREA_UPPERBODY || _AREA_LOWERBODY
          coolRamp = SAMPLE_TEXTURE2D(_BodyCoolRamp,sampler_BodyCoolRamp,rampUV);
          warmRamp = SAMPLE_TEXTURE2D(_BodyWarmRamp,sampler_BodyWarmRamp,rampUV);
    #endif
    float isDay = lightDirectionWS.y * 0.5 + 0.5;
    float3 rampColor = lerp(coolRamp,warmRamp,isDay);
    mainLightColor *= baseColor;  //TODO : 减少平行光强度对基础色 色相的影响。(好像Saturate函数就是)
    mainLightColor *= rampColor;

    //--------------------------------------------------------------------高光---------------------------------------------------------------------
    //TODO: 头发提取刘海高光，并且做随视角的亮暗变化
    //TODO : 刘海投影   : fix bug : 
    //1》透过脸的眼睛可以看到脸(已经修复 总结： Stencil中，renderquene越小越先渲染，因为半透明是3000，要后渲染，数比较大
    // 大部分得设置都是Greater，并且Replace来达到修改模板顺序得效果，正常得材质就用ref 0 （如果ABC三个物体用了模板测试，C是一个普通材质但为了处理遮挡关系Ref被改成了X，那么
    //为了处理其他普通材质和这个C的遮挡关系，普通材质的ref也应该改成X）， Greater， zero) 
    // ---------- 1 fix
    //2修改刘海颜色=阴影颜色（重新渲染一遍脸部）
    // -----------2 fix
    //3 刘海投影半透明   
    // 半透明好像没有什么意义，不加了
    //TODO : 添加GT_ToneMapping  ， 添加曲线调色 ， 压暗衣服中蓝色的色相，添加Bloom仿原神就行了不用仿星穹铁道
    //TODO : 增强金属质感，增强衣服布料质感，混合一个皮肤的SSR次表面散射让它白里透红一些
    //TODO : 眼睛的高光可以随视角有亮暗变化，具体可以参考头发的刘海高光.
    //TODO : 详见 知乎：比较少人提到的卡通渲染方法 
    float3 specularColor = 0;

    #if _AREA_HAIR || _AREA_UPPERBODY || _AREA_LOWERBODY     
    {
    float3 halfVectorWS = normalize(viewDirectionWS + lightDirectionWS);
    float NoH = dot(normalWS, halfVectorWS);
    float blinnPhong = pow(saturate(NoH), _SpecularExpon);

    float nonMetalSpecular = step(1.04 - blinnPhong,lightMap.b) * _SpecularKsNonMetal;
    float metalSpecular = blinnPhong * lightMap.b * _SpecularKsMetal;

    float metallic = 0;
    #if _AREA_UPPERBODY || _AREA_LOWERBODY
    metallic = saturate((abs(lightMap.a - 0.52) - 0.1)/(0 - 0.1));
    #endif
    
    specularColor = lerp(nonMetalSpecular, metalSpecular * baseColor, metallic);
    specularColor *= mainLight.color;
    specularColor *= _SpecularBrightness;
    //specularColor = metallic;
    //specularColor = blinnPhong;
    }
    #endif

    float3 stockingsEffect = 1; //三月七没有黑丝，我也没有黑丝图
    #if _AREA_UPPERBODY || _AREA_LOWERBODY
    {
    float2 stockingsMapRG = 0;
    float stockingsMapB = 0;
    #if _AREA_UPPERBODY
    stockingsMapRG = SAMPLE_TEXTURE2D(_UpperBodyStockings,sampler_UpperBodyStockings,input.uv).rg;
    stockingsMapB = SAMPLE_TEXTURE2D(_UpperBodyStockings,sampler_UpperBodyStockings,input.uv * 20).b;
    #elif _AREA_LOWERBODY
    stockingsMapRG = SAMPLE_TEXTURE2D(_LowerBodyStockings,sampler_LowerBodyStockings,input.uv).rg;
    stockingsMapB = SAMPLE_TEXTURE2D(_LowerBodyStockings,sampler_LowerBodyStockings,input.uv * 20).b;
    #endif
    float NoV = dot(normalWS, viewDirectionWS);
    float fac = NoV;
    fac = pow(saturate(fac), _StockingsTransitionPower);
    fac = saturate((fac - _StockingsTransitionHardness/2)/(1 - _StockingsTransitionHardness));
    fac = fac * (stockingsMapB * _StockingsTextureUsage + (1 - _StockingsTextureUsage));
    fac = lerp(fac,1,stockingsMapRG.g);
    Gradient curve = GradientConstruct();
    curve.colorsLength = 3;
    curve.colors[0] = float4(_StockingsDarkColor,0);
    curve.colors[1] = float4(_StockingsTransitionColor, _StockingsTransitionThreshold);
    curve.colors[2] = float4(_StockingsLightColor,1);
    float3 stockingsColor = SampleGradient(curve, fac);
    
    stockingsEffect = lerp(1,stockingsColor,stockingsMapRG.r);
    }
    #endif

    //RimLight

    float linearEyeDepth = LinearEyeDepth(input.positionCS.z, _ZBufferParams);
    float3 normalVS = mul((float3x3)UNITY_MATRIX_V,normalWS);
    float2 uvOffset = float2(sign(normalVS.x),0) * _RimLightWidth / (1 + linearEyeDepth) / 100;
    int2 loadTexPos = input.positionCS.xy + uvOffset * _ScaledScreenParams.xy;
    loadTexPos = min(max(loadTexPos,0),_ScaledScreenParams.xy - 1);
    float offsetSceneDepth = LoadSceneDepth(loadTexPos);
    float offsetLinearEyeDepth = LinearEyeDepth(offsetSceneDepth , _ZBufferParams);
    float rimLight = saturate(offsetLinearEyeDepth - (linearEyeDepth + _RimLightThreshold))/ _RimLightFadeout;
    float3 rimLightColor = rimLight * mainLight.color.rgb;
    rimLightColor *= _RimLightTintColor;
    rimLightColor *= _RimLightBrightness;

    
    //Emmission
    
    float3 emissionColor = 0;
    #if _EMISSION_ON
    {
        emissionColor = areaMap.a;
        // emissionColor *= lerp(1,baesColor,_EmissionMixBaseColor);
        // emissionColor *= _EmissionTintColor;
        emissionColor *= _EmissionIntensity;
    }
    #endif

    float fakeOutlineEffect = 0;
    float3 fakeOutlineColor = 0;
    #if _AREA_FACE && _OUTLINE_ON
    {
        float fakeOutline = faceMap.b;
        float3 headForward = normalize(_HeadForward);
        fakeOutlineEffect = smoothstep(0.0,0.25,pow(saturate(dot(headForward,viewDirectionWS)),20)* fakeOutline);

        float2 outlineUV = float2(0,0.0625);
        float3 coolRamp = SAMPLE_TEXTURE2D(_BodyCoolRamp,sampler_BodyCoolRamp,outlineUV).rgb;
        float3 warmRamp = SAMPLE_TEXTURE2D(_BodyWarmRamp,sampler_BodyWarmRamp,outlineUV).rgb;
        float3 ramp = lerp(coolRamp,warmRamp,0.5);
        fakeOutlineColor = pow(ramp, _OutlineGamma);
    }
    #endif

    float3 albedo = 0;
    albedo += indirectLightColor;
    albedo += mainLightColor;
    albedo += specularColor;
    // albedo *= stockingsEffect;
    albedo += rimLightColor * lerp(1, albedo, _RimLightMixAlbedo);
    albedo += emissionColor;
    // albedo = lerp(albedo, fakeOutlineColor,fakeOutlineEffect);
    
    // albedo = rimLight;

    float alpha = _Alpha;

    #if _DRAW_OVERLAY_ON
    {
        float3 headForward = normalize(_HeadForward);
        alpha = lerp(1,alpha,saturate(dot(headForward, viewDirectionWS)));
    }
    #endif

    float4 color = float4(albedo,alpha); 
    clip(color.a - _AlphaClip);
    color.rgb = MixFog(color.rgb, input.positionWSAndFogFactor.w);
    return color;
    // return lightMap.g;
    // return mainLightShadow > _test1 && mainLightShadow < _test2;
    // return mainLightShadow;
    // return step(_test1,mainLightShadow);
    // return float4(warmRamp,1);
    // return areaMap.a*_EmissionIntensity;
    // return input.color;
}