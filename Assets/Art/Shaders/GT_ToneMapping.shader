Shader "Custom/GT_ToneMapping"
{
    Properties
    {
        _MainTex("Base Color",2D) = "white"{}
    }
        SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline" "Queue"="Geometry"  "RenderType"="Opaque"
        }

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"  
        CBUFFER_START(UnityPerMaterial)
          float4 _MainTex_ST;
        CBUFFER_END
        ENDHLSL
        // LOD 300
       

        Pass
        {
             Name "GT_Tonemapping"
            Tags{"LightMode"="UniversalForward""Queue" = "Geometry"}
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varings
            {
                float2 uv : TEXCOORD0;
                float4 positionCS : SV_POSITION;
                float fogCoord : TEXCOORD1;
            };

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);
            

            Varings vert(Attributes IN)
            {
                Varings OUT;
                VertexPositionInputs positionInputs = GetVertexPositionInputs(IN.positionOS.xyz);
                OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
                OUT.positionCS = positionInputs.positionCS;

                OUT.fogCoord = ComputeFogFactor(positionInputs.positionCS.z);

                return OUT;
            }

            static const float e = 2.71828;

            float W_f(float x,float e0,float e1)
             {
                 if (x <= e0)
                    return 0;
                 if (x >= e1)
                    return 1;
                 float a = (x - e0) / (e1 - e0);
                 return a * a * (3 - 2 * a);
            }
            float H_f(float x, float e0, float e1) 
            {
                 if (x <= e0)
                    return 0;
                 if (x >= e1)
                    return 1;
                 return (x - e0) / (e1 - e0);
            }

            float GranTurismoTonemapper(float x) {
                float P = 1;
                float a = 1;
                float m = 0.22;
                float l = 0.4;
                float c = 1.33;
                float b = 0;
                float l0 = (P - m) * l / a;
                float L0 = m - m / a;
                float L1 = m + (1 - m) / a;
                float L_x = m + a * (x - m);
                float T_x = m * pow(abs(x / m), c) + b;
                float S0 = m + l0;
                float S1 = m + a * l0;
                float C2 = a * P / (P - S1);
                float S_x = P - (P - S1) * pow(e,-(C2 * (x - S0) / P));
                float w0_x = 1 - W_f(x, 0, m);
                float w2_x = H_f(x, m + l0, m + l0);
                float w1_x = 1 - w0_x - w2_x;
                float f_x = T_x * w0_x + L_x * w1_x + S_x * w2_x;
                return f_x;
            }

            float4 frag(Varings IN) : SV_Target
            {
            // sample the texture
            float4 col = SAMPLE_TEXTURE2D(_MainTex,sampler_MainTex,IN.uv);
            // apply fog
            MixFog(col,IN.fogCoord);
            float r = GranTurismoTonemapper(col.r);
            float g = GranTurismoTonemapper(col.g);
            float b = GranTurismoTonemapper(col.b);
            col = float4(r,g,b,col.a);

            return col;
            // return float4(IN.positionCS);
        }
        ENDHLSL
    }
    }
}
