Shader "Unlit/RayMarch"
{
    Properties
    {
        _BoxPosition("BoxPosition",vector) = (0.2,0.2,0.2)
        _BoxSize("BoxSize",vector) = (0.2,0.2,0.2)
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           

            #include "UnityCG.cginc"

            #define MAX_STEPS 100
            #define MAX_DIST 100
            #define SURF_DIST .001

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;                
                float3 rayorigin : TEXCOORD1;
                float3 hitposition : TEXCOORD2;
                float4 vertex : SV_POSITION;
            };

            float3 _BoxPosition;
            float3 _BoxSize;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);                 
                o.rayorigin=mul(unity_WorldToObject,float4(_WorldSpaceCameraPos,1));
                o.hitposition=v.vertex;
                return o;
            }
            float smin(float a,float b,float k)
            {
                float h = clamp(0.5+0.5*(b-a)/k,0,1);
                return lerp(b,a,h)-k*h*(1-h);
            }
            float dCapsule(float3 p,float3 a,float3 b,float3 r)
            {
                float3 ab = b-a;
                float3 ap = p-a;
                float t = dot(ab,ap)/dot(ab,ab);
                t=clamp(t,0,1);
                float3 c = a +  t*ab;
                
                return length(p-c)-r;
            }
            float dBox(float3 p,float3 size)
            {
                float3 q = abs(p)-size;
                return length(max(q,0.0))+ min(max(q.x,max(q.y,q.z)),0.0);
            }

            float GetDist(float3 p)
            {
                float d;

                d = smin((length(p)-0.3),dBox(p-_BoxPosition,_BoxSize),0.2);
                 
                return d;
            }

            float RayMarch(float3 rayOrigin,float3 rayDirection)
            {
                float distfromOrigin = 0;
                float distfromScene;
                for(int i=0;i<MAX_STEPS;i++)
                {
                    float3 p = rayOrigin + distfromOrigin * rayDirection;
                    distfromScene = GetDist(p);
                    distfromOrigin +=distfromScene;
                    if(distfromScene<SURF_DIST||distfromOrigin>MAX_DIST)
                            break;

                }
                return distfromOrigin;
            }

            float3 GetNormal(float3 p)
            {
                float2 e = float2(0.01,0);
                float3 n = GetDist(p) - float3(GetDist(p+e.xyy),GetDist(p+e.yxy),GetDist(p+e.yyx));

                return normalize(n);
            }

            fixed4 frag (v2f i) : SV_Target
            {
               float4 col;                
                float3 rayOrigin = i.rayorigin;
                float3 rayDirection = normalize(i.hitposition-rayOrigin);
                float d = RayMarch(rayOrigin,rayDirection);
                if(d<MAX_DIST)
                {
                        float3 p = rayOrigin + rayDirection * d;
                        float3 n = GetNormal(p);
                        col.rgb=n;
                        
                }
                else
                    discard;
               
                
                return col;
            }
            ENDCG
        }
    }
}

