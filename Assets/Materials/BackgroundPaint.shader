Shader "Custom/PaintEffectShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {} 
        _TimeValue ("Time", Float) = 0
        _SpinTime ("Spin Time", Float) = 0
        _SpinAmount ("Spin Amount", Float) = 0
        _Contrast ("Contrast", Float) = 1
        _Scale ("Effect Scale", Float) = 1
        _NormalOffset ("Normal Offset", Vector) = (0.0, 0.0, 0.0, 0.0) // New property for normal offset
        _ScreenSize ("Screen Size", Vector) = (1920, 1080, 0, 0)
        _Colour1 ("Color 1", Color) = (1,1,1,1)
        _Colour2 ("Color 2", Color) = (1,0,0,1)
        _Colour3 ("Color 3", Color) = (0,0,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Cull Off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _TimeValue;
            float _SpinTime;
            float _SpinAmount;
            float _Contrast;
            float _Scale;
            float4 _NormalOffset; // Access normal offset
            float4 _ScreenSize;  // (Width, Height, 0, 0)
            float4 _Colour1;
            float4 _Colour2;
            float4 _Colour3;

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 screenPos : TEXCOORD1;
            };

            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.screenPos = (o.vertex.xy / o.vertex.w) * 0.5 + 0.5;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float2 screenSize = _ScreenSize.xy;
                float pixelSize = length(screenSize) / (700.0 * _Scale); // Scale the effect
                float2 uv = (floor(i.screenPos * screenSize / pixelSize) * pixelSize - 0.5 * screenSize) / length(screenSize) - float2(0.12, 0.0);
                
                // Apply normal offset to UV coordinates to align to the center
                uv += _NormalOffset.xy;

                float uvLen = length(uv);

                float speed = (_SpinTime * 0.5 * 0.2) + 302.2;
                float newPixelAngle = atan2(uv.y, uv.x) + speed - 0.5 * 20.0 * (_SpinAmount * uvLen + (1.0 - _SpinAmount));
                float2 mid = screenSize / length(screenSize) / 2.0;

                uv = float2(
                    uvLen * cos(newPixelAngle) + mid.x,
                    uvLen * sin(newPixelAngle) + mid.y
                ) - mid;

                uv *= 30.0;
                speed = _TimeValue * 2.0;
                float2 uv2 = float2(uv.x + uv.y, uv.x - uv.y);

                for (int i = 0; i < 5; i++)
                {
                    uv2 += sin(max(uv.x, uv.y)) + uv;
                    uv += 0.5 * float2(cos(5.1123314 + 0.353 * uv2.y + speed * 0.131121), sin(uv2.x - 0.113 * speed));
                    uv -= 1.0 * cos(uv.x + uv.y) - 1.0 * sin(uv.x * 0.711 - uv.y);
                }

                float contrastMod = (0.25 * _Contrast + 0.5 * _SpinAmount + 1.2);
                float paintRes = min(2.0, max(0.0, length(uv) * 0.035 * contrastMod));
                float c1p = max(0.0, 1.0 - contrastMod * abs(1.0 - paintRes));
                float c2p = max(0.0, 1.0 - contrastMod * abs(paintRes));
                float c3p = 1.0 - min(1.0, c1p + c2p);

                float4 retCol = (0.3 / _Contrast) * _Colour1 +
                                (1.0 - 0.3 / _Contrast) * (_Colour1 * c1p + _Colour2 * c2p + float4(c3p * _Colour3.rgb, c3p * _Colour1.a));

                return retCol;
            }
            ENDCG
        }
    }
}
