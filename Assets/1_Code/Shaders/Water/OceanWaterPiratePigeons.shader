// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Pirate Pigeons/Ocean"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_GlobalEffectRT("_GlobalEffectRT", 2D) = "white" {}
		_foam("_foam", 2D) = "white" {}
		_heightFoam("heightFoam", 2D) = "white" {}
		[Header(Indentations)][Header()]_NoiseStrength("Noise Strength", Range( 0 , 25)) = 0.05
		_NoiseScale("Noise Scale", Float) = 13
		_NoiseSmoothness("Noise Smoothness", Float) = 0.2
		[Header(Fingerprints)]_FingerprintStrength("Fingerprint Strength", Range( 0 , 1)) = 0.35
		_Scale("Scale", Float) = 1
		[PerRendererData]_Roughness("Roughness", 2D) = "white" {}
		[PerRendererData]_FingerprintNormal("FingerprintNormal", 2D) = "white" {}
		[HDR]_ShallowColor("Shallow Color", Color) = (0.2509804,1,0.9529412,1)
		[HDR]_DeepColor("Deep Color", Color) = (0,0.1748825,1.907273,1)
		[HDR]_Horizon("Horizon", Color) = (0,1,0.2901961,1)
		_HorizonDistance("Horizon Distance", Float) = 4
		_WaterDepth("Water Depth", Range( 0 , 5)) = 5
		[HideInInspector]_WaterNormal("Water Normal", 2D) = "bump" {}
		_NormalIntensity("NormalIntensity", Float) = 0
		_RefractionDistortion("RefractionDistortion", Float) = 0.5
		_Foam("Foam", Range( 0 , 20)) = 0
		_Speed("Speed", Float) = 1
		_NormalScale("NormalScale", Float) = 0
		_Caust("Caust", 2D) = "white" {}
		_LightingSmoothness("LightingSmoothness", Float) = 0
		_LightingHardness("Lighting Hardness", Float) = 0
		[HDR]_SpecularColor("Specular Color", Color) = (1,1,1,0)
		_HeightFoamH("HeightFoamH", Float) = 0
		_WaveLength("WaveLength", Float) = 0
		_Steepness("Steepness", Float) = 0
		_FoamClayColor("FoamClayColor", Color) = (1,1,1,0)
		_WaveSpeed("WaveSpeed", Float) = 5
		_wavesZ("Water Mover", Float) = 0
		_Float5("Float 5", Float) = 0.5
		_Caustics("Caustics", Float) = 0.05
		_RippleCutoff("Ripple Cutoff", Float) = 0.6
		_ClayNormal("ClayNormal", Float) = 125


		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Trans Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Trans Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Trans Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Trans Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Trans Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Trans Shadow", Range( 0, 1 ) ) = 0.5
		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 16
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25

		[HideInInspector][ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[HideInInspector][ToggleOff] _EnvironmentReflections("Environment Reflections", Float) = 1.0
		[HideInInspector][ToggleOff] _ReceiveShadows("Receive Shadows", Float) = 1.0

		[HideInInspector] _QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector] _QueueControl("_QueueControl", Float) = -1

        [HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" "UniversalMaterialType"="Lit" }

		Cull Back
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		AlphaToMask Off

		

		HLSLINCLUDE
		#pragma target 3.5
		#pragma prefer_hlslcc gles
		// ensure rendering platforms toggle list is visible

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"

		#ifndef ASE_TESS_FUNCS
		#define ASE_TESS_FUNCS
		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}

		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		#endif //ASE_TESS_FUNCS
		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForwardOnly" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			

			HLSLPROGRAM

			#pragma multi_compile_instancing
			#pragma instancing_options renderinglayer
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_TESSELLATION 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_DISTANCE_TESSELLATION
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120110
			#define REQUIRE_OPAQUE_TEXTURE 1
			#define REQUIRE_DEPTH_TEXTURE 1


			#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile_fragment _ _LIGHT_LAYERS
			#pragma multi_compile_fragment _ _LIGHT_COOKIES
			#pragma multi_compile _ _CLUSTERED_RENDERING

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile_fragment _ DEBUG_DISPLAY

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_FORWARD

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 clipPos : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				float4 lightmapUVOrVertexSH : TEXCOORD1;
				half4 fogFactorAndVertexLight : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					float4 shadowCoord : TEXCOORD6;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
					float2 dynamicLightmapUV : TEXCOORD7;
				#endif
				float4 ase_texcoord8 : TEXCOORD8;
				float4 ase_tangent : TANGENT;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Horizon;
			float4 _ShallowColor;
			float4 _DeepColor;
			float4 _SpecularColor;
			float4 _FingerprintNormal_TexelSize;
			float4 _FoamClayColor;
			float4 _WaterNormal_ST;
			float _FingerprintStrength;
			float _Foam;
			float _NoiseSmoothness;
			float _ClayNormal;
			float _NoiseStrength;
			float _Float5;
			float _RippleCutoff;
			float _Speed;
			float _NoiseScale;
			float _Scale;
			float _WaveLength;
			float _HeightFoamH;
			float _WaterDepth;
			float _RefractionDistortion;
			float _LightingHardness;
			float _LightingSmoothness;
			float _NormalIntensity;
			float _NormalScale;
			float _Steepness;
			float _WaveSpeed;
			float _wavesZ;
			float _HorizonDistance;
			float _Caustics;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _FingerprintNormal;
			sampler2D _Roughness;
			sampler2D _GlobalEffectRT;
			sampler2D _WaterNormal;
			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _foam;
			sampler2D _heightFoam;
			sampler2D _Caust;


			float3 TangentToWorld13_g21( float3 NormalTS, float3x3 TBN )
			{
				float3 NormalWS = TransformTangentToWorld(NormalTS, TBN);
				NormalWS = NormalizeNormalPerPixel(NormalWS);
				return NormalWS;
			}
			
			float3 AdditionalLightsSpecular10x12x( float3 WorldPosition, float3 WorldNormal, float3 WorldView, float3 SpecColor, float Smoothness )
			{
				float3 Color = 0;
				#ifdef _ADDITIONAL_LIGHTS
					Smoothness = exp2(10 * Smoothness + 1);
					uint lightCount = GetAdditionalLightsCount();
					LIGHT_LOOP_BEGIN( lightCount )
						Light light = GetAdditionalLight(lightIndex, WorldPosition);
						half3 AttLightColor = light.color *(light.distanceAttenuation * light.shadowAttenuation);
						Color += LightingSpecular(AttLightColor, light.direction, WorldNormal, WorldView, half4(SpecColor, 0), Smoothness);	
					LIGHT_LOOP_END
				#endif
				return Color;
			}
			
			inline float3 TriplanarSampling9_g92( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				xNorm.xyz  = half3( UnpackNormalScale( xNorm , 1.0 ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
				yNorm.xyz  = half3( UnpackNormalScale( yNorm , 1.0 ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
				zNorm.xyz  = half3( UnpackNormalScale( zNorm , 1.0 ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
				return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
			}
			
			real3 ASESafeNormalize(float3 inVec)
			{
				real dp3 = max(FLT_MIN, dot(inVec, inVec));
				return inVec* rsqrt( dp3);
			}
			
			float3 PerturbNormal107_g53( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			float3 CombineSamplesSharp128_g70( float S0, float S1, float S2, float Strength )
			{
				{
				    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
				    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
				    return normalize( cross( va, vb ) );
				}
			}
			
					float2 voronoihash8_g69( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi8_g69( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash8_g69( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 //		if( d<F1 ) {
						 //			F2 = F1;
						 			float h = smoothstep(0.0, 1.0, 0.5 + 0.5 * (F1 - d) / smoothness); F1 = lerp(F1, d, h) - smoothness * h * (1.0 - h);mg = g; mr = r; id = o;
						 //		} else if( d<F2 ) {
						 //			F2 = d;
						
						 //		}
						 	}
						}
						return F1;
					}
			
			float3 PerturbNormal107_g71( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			float2 UnStereo( float2 UV )
			{
				#if UNITY_SINGLE_PASS_STEREO
				float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
				UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
				#endif
				return UV;
			}
			
			float3 InvertDepthDirURP75_g72( float3 In )
			{
				float3 result = In;
				#if !defined(ASE_SRP_VERSION) || ASE_SRP_VERSION <= 70301 || ASE_SRP_VERSION == 70503 || ASE_SRP_VERSION == 70600 || ASE_SRP_VERSION == 70700 || ASE_SRP_VERSION == 70701 || ASE_SRP_VERSION >= 80301
				result *= float3(1,1,-1);
				#endif
				return result;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float4 temp_output_5_0_g79 = float4(0.02,-0.34,0.16,2.23);
				float2 appendResult19_g80 = (float2(cos( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g80 = normalize( appendResult19_g80 );
				float2 d26_g80 = normalizeResult15_g80;
				float temp_output_3_0_g79 = _WaveLength;
				float k25_g80 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float _0waterMover900 = _wavesZ;
				float3 appendResult758 = (float3(ase_worldPos.x , ase_worldPos.y , ( ase_worldPos.z + _0waterMover900 )));
				float3 temp_output_1_0_g79 = appendResult758;
				float dotResult29_g80 = dot( d26_g80 , (temp_output_1_0_g79).xz );
				float temp_output_4_0_g79 = _WaveSpeed;
				float mulTime33_g80 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g80 = ( k25_g80 * ( dotResult29_g80 - mulTime33_g80 ) );
				float temp_output_2_0_g79 = _Steepness;
				float temp_output_3_0_g80 = temp_output_2_0_g79;
				float a37_g80 = ( temp_output_3_0_g80 / k25_g80 );
				float temp_output_91_0_g80 = ( cos( f34_g80 ) * a37_g80 );
				float3 appendResult86_g80 = (float3(( (d26_g80).x * temp_output_91_0_g80 ) , ( a37_g80 * sin( f34_g80 ) ) , ( temp_output_91_0_g80 * (d26_g80).y )));
				float2 appendResult19_g81 = (float2(cos( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g81 = normalize( appendResult19_g81 );
				float2 d26_g81 = normalizeResult15_g81;
				float k25_g81 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g81 = dot( d26_g81 , (temp_output_1_0_g79).xz );
				float mulTime33_g81 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g81 = ( k25_g81 * ( dotResult29_g81 - mulTime33_g81 ) );
				float temp_output_3_0_g81 = temp_output_2_0_g79;
				float a37_g81 = ( temp_output_3_0_g81 / k25_g81 );
				float temp_output_91_0_g81 = ( cos( f34_g81 ) * a37_g81 );
				float3 appendResult86_g81 = (float3(( (d26_g81).x * temp_output_91_0_g81 ) , ( a37_g81 * sin( f34_g81 ) ) , ( temp_output_91_0_g81 * (d26_g81).y )));
				float2 appendResult19_g83 = (float2(cos( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g83 = normalize( appendResult19_g83 );
				float2 d26_g83 = normalizeResult15_g83;
				float k25_g83 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g83 = dot( d26_g83 , (temp_output_1_0_g79).xz );
				float mulTime33_g83 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g83 = ( k25_g83 * ( dotResult29_g83 - mulTime33_g83 ) );
				float temp_output_3_0_g83 = temp_output_2_0_g79;
				float a37_g83 = ( temp_output_3_0_g83 / k25_g83 );
				float temp_output_91_0_g83 = ( cos( f34_g83 ) * a37_g83 );
				float3 appendResult86_g83 = (float3(( (d26_g83).x * temp_output_91_0_g83 ) , ( a37_g83 * sin( f34_g83 ) ) , ( temp_output_91_0_g83 * (d26_g83).y )));
				float2 appendResult19_g82 = (float2(cos( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g82 = normalize( appendResult19_g82 );
				float2 d26_g82 = normalizeResult15_g82;
				float k25_g82 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g82 = dot( d26_g82 , (temp_output_1_0_g79).xz );
				float mulTime33_g82 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g82 = ( k25_g82 * ( dotResult29_g82 - mulTime33_g82 ) );
				float temp_output_3_0_g82 = temp_output_2_0_g79;
				float a37_g82 = ( temp_output_3_0_g82 / k25_g82 );
				float temp_output_91_0_g82 = ( cos( f34_g82 ) * a37_g82 );
				float3 appendResult86_g82 = (float3(( (d26_g82).x * temp_output_91_0_g82 ) , ( a37_g82 * sin( f34_g82 ) ) , ( temp_output_91_0_g82 * (d26_g82).y )));
				float3 worldToObj485 = mul( GetWorldToObjectMatrix(), float4( ( ase_worldPos + ( ( appendResult86_g80 + appendResult86_g81 ) + ( appendResult86_g83 + appendResult86_g82 ) ) ), 1 ) ).xyz;
				float3 waveDisplacement493 = worldToObj485;
				
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord8.z = eyeDepth;
				
				o.ase_texcoord8.xy = v.texcoord.xy;
				o.ase_tangent = v.ase_tangent;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord8.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = waveDisplacement493;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				#endif

				#if !defined(LIGHTMAP_ON)
					OUTPUT_SH( normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz );
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					o.dynamicLightmapUV.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord.xy;
					o.lightmapUVOrVertexSH.xy = v.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );

				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( positionCS.z );
				#else
					half fogFactor = 0;
				#endif

				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;
				o.clipPosV = positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag ( VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif

				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				float2 NormalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#endif

				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float _0waterMover900 = _wavesZ;
				float2 appendResult903 = (float2(0.0 , -_0waterMover900));
				float2 uv_WaterNormal = IN.ase_texcoord8.xy * _WaterNormal_ST.xy + _WaterNormal_ST.zw;
				float2 temp_output_907_0 = ( ( appendResult903 * 0.05 ) + ( uv_WaterNormal * _NormalScale ) );
				float2 panner22 = ( 1.0 * _Time.y * float2( -0.03,0 ) + temp_output_907_0);
				float3 unpack23 = UnpackNormalScale( tex2D( _WaterNormal, panner22 ), _NormalIntensity );
				unpack23.z = lerp( 1, unpack23.z, saturate(_NormalIntensity) );
				float2 panner19 = ( 1.0 * _Time.y * float2( 0.04,0.04 ) + temp_output_907_0);
				float3 unpack17 = UnpackNormalScale( tex2D( _WaterNormal, panner19 ), _NormalIntensity );
				unpack17.z = lerp( 1, unpack17.z, saturate(_NormalIntensity) );
				float3 _normals210 = BlendNormal( unpack23 , unpack17 );
				float3 NormalTS13_g21 = _normals210;
				float3 Binormal5_g21 = ( ( IN.ase_tangent.w > 0.0 ? 1.0 : -1.0 ) * cross( WorldNormal , WorldTangent ) );
				float3x3 TBN1_g21 = float3x3(WorldTangent, Binormal5_g21, WorldNormal);
				float3x3 TBN13_g21 = TBN1_g21;
				float3 localTangentToWorld13_g21 = TangentToWorld13_g21( NormalTS13_g21 , TBN13_g21 );
				float3 temp_output_430_0 = localTangentToWorld13_g21;
				float dotResult383 = dot( SafeNormalize(_MainLightPosition.xyz) , temp_output_430_0 );
				float temp_output_385_0 = pow( saturate( dotResult383 ) , exp2( ( ( _LightingSmoothness * 10.0 ) + 1.0 ) ) );
				float lerpResult357 = lerp( temp_output_385_0 , step( 0.5 , temp_output_385_0 ) , _LightingHardness);
				float3 worldPosValue44_g22 = WorldPosition;
				float3 WorldPosition13_g22 = worldPosValue44_g22;
				float3 worldNormalValue50_g22 = temp_output_430_0;
				float3 WorldNormal13_g22 = worldNormalValue50_g22;
				float3 temp_output_15_0_g22 = WorldViewDirection;
				float3 WorldView13_g22 = temp_output_15_0_g22;
				float3 temp_output_14_0_g22 = _SpecularColor.rgb;
				float3 SpecColor13_g22 = temp_output_14_0_g22;
				float temp_output_18_0_g22 = _LightingSmoothness;
				float Smoothness13_g22 = temp_output_18_0_g22;
				float3 localAdditionalLightsSpecular10x12x13_g22 = AdditionalLightsSpecular10x12x( WorldPosition13_g22 , WorldNormal13_g22 , WorldView13_g22 , SpecColor13_g22 , Smoothness13_g22 );
				float3 specularResult61_g22 = localAdditionalLightsSpecular10x12x13_g22;
				float4 _lights438 = ( ( ( lerpResult357 * _SpecularColor ) * _SpecularColor.a ) + float4( specularResult61_g22 , 0.0 ) );
				float eyeDepth = IN.ase_texcoord8.z;
				float4 ase_screenPosNorm = ScreenPos / ScreenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float eyeDepth28_g78 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float2 temp_output_20_0_g78 = ( (_normals210).xy * ( _RefractionDistortion / max( eyeDepth , 0.1 ) ) * saturate( ( eyeDepth28_g78 - eyeDepth ) ) );
				float eyeDepth2_g78 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ( float4( temp_output_20_0_g78, 0.0 , 0.0 ) + ase_screenPosNorm ).xy ),_ZBufferParams);
				float2 temp_output_32_0_g78 = (( float4( ( temp_output_20_0_g78 * saturate( ( eyeDepth2_g78 - eyeDepth ) ) ), 0.0 , 0.0 ) + ase_screenPosNorm )).xy;
				float2 temp_output_246_38 = temp_output_32_0_g78;
				float4 fetchOpaqueVal65 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( temp_output_246_38 ), 1.0 );
				float4 _refraction254 = fetchOpaqueVal65;
				float2 _refractUV290 = temp_output_246_38;
				float eyeDepth2_g77 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( float4( _refractUV290, 0.0 , 0.0 ).xy ),_ZBufferParams);
				float depthToLinear6_g77 = LinearEyeDepth(ase_screenPosNorm.z,_ZBufferParams);
				float _depthMask614 = ( 1.0 - saturate( ( ( abs( ( ( eyeDepth2_g77 - depthToLinear6_g77 ) / _WaterDepth ) ) * 0.07 ) + -0.05 ) ) );
				float4 lerpResult13 = lerp( _DeepColor , _ShallowColor , _depthMask614);
				float fresnelNdotV316 = dot( WorldNormal, WorldViewDirection );
				float fresnelNode316 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV316, _HorizonDistance ) );
				float4 lerpResult320 = lerp( ( _refraction254 * lerpResult13 ) , _Horizon , fresnelNode316);
				float4 _colors292 = lerpResult320;
				float screenDepth71_g93 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth71_g93 = saturate( abs( ( screenDepth71_g93 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( ( _Foam * 2.0 ) ) ) );
				float _foamDiff63_g93 = ( distanceDepth71_g93 * 11.25 );
				float _speedVar231 = _Speed;
				float speedVar31_g93 = _speedVar231;
				float mulTime19_g93 = _TimeParameters.x * speedVar31_g93;
				float temp_output_26_0_g93 = ( _foamDiff63_g93 - saturate( sin( ( ( _foamDiff63_g93 - mulTime19_g93 ) * ( 4.0 * PI ) ) ) ) );
				float _foamHarry25_g93 = temp_output_26_0_g93;
				float2 temp_cast_5 = (speedVar31_g93).xx;
				float2 appendResult5_g93 = (float2(WorldPosition.x , WorldPosition.z));
				float2 worldPosUV51_g93 = appendResult5_g93;
				float2 panner1_g93 = ( 1.0 * _Time.y * temp_cast_5 + ( worldPosUV51_g93 * 0.22 ));
				float3 lerpResult8_g93 = lerp( float3( panner1_g93 ,  0.0 ) , _normals210 , 0.35);
				float4 break77_g93 = ( float4(1,1,1,1) * step( _foamHarry25_g93 , tex2D( _foam, lerpResult8_g93.xy ).r ) );
				float smoothstepResult70_g93 = smoothstep( 0.0 , ( distanceDepth71_g93 + 0.3 ) , ( 1.0 - 0.0 ));
				float4 appendResult79_g93 = (float4(break77_g93.r , break77_g93.g , break77_g93.b , ( ( 1.0 - smoothstepResult70_g93 ) * break77_g93.a )));
				float4 _shoreLines655 = appendResult79_g93;
				float temp_output_11_0_g92 = _RippleCutoff;
				float2 temp_cast_8 = (0.005).xx;
				float3x3 ase_worldToTangent = float3x3(WorldTangent,WorldBiTangent,WorldNormal);
				float3 appendResult8_g92 = (float3(( WorldPosition.x + 100.0 ) , WorldPosition.y , ( WorldPosition.z + 100.0 )));
				float3 triplanar9_g92 = TriplanarSampling9_g92( _GlobalEffectRT, appendResult8_g92, WorldNormal, 1.0, temp_cast_8, -50.0, 0 );
				float3 tanTriplanarNormal9_g92 = mul( ase_worldToTangent, triplanar9_g92 );
				float _rt500 = step( temp_output_11_0_g92 , tanTriplanarNormal9_g92.z );
				float4 _combinedLines687 = ( _shoreLines655 + _rt500 );
				float4 lerpResult689 = lerp( ( _lights438 + _colors292 ) , _FoamClayColor , _combinedLines687);
				float4 _endColor892 = lerpResult689;
				
				float3 _tangent = float3(1,0,0);
				float4 temp_output_5_0_g79 = float4(0.02,-0.34,0.16,2.23);
				float2 appendResult19_g80 = (float2(cos( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g80 = normalize( appendResult19_g80 );
				float2 d26_g80 = normalizeResult15_g80;
				float temp_output_47_0_g80 = (d26_g80).x;
				float temp_output_2_0_g79 = _Steepness;
				float temp_output_3_0_g80 = temp_output_2_0_g79;
				float temp_output_3_0_g79 = _WaveLength;
				float k25_g80 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float3 appendResult758 = (float3(WorldPosition.x , WorldPosition.y , ( WorldPosition.z + _0waterMover900 )));
				float3 temp_output_1_0_g79 = appendResult758;
				float dotResult29_g80 = dot( d26_g80 , (temp_output_1_0_g79).xz );
				float temp_output_4_0_g79 = _WaveSpeed;
				float mulTime33_g80 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g80 = ( k25_g80 * ( dotResult29_g80 - mulTime33_g80 ) );
				float temp_output_53_0_g80 = ( temp_output_3_0_g80 * sin( f34_g80 ) );
				float3 appendResult56_g80 = (float3(( ( temp_output_47_0_g80 * -temp_output_47_0_g80 ) * temp_output_53_0_g80 ) , ( ( cos( f34_g80 ) * temp_output_3_0_g80 ) * temp_output_47_0_g80 ) , ( temp_output_53_0_g80 * ( -temp_output_47_0_g80 * (d26_g80).y ) )));
				float3 tangent45_g80 = ( _tangent + appendResult56_g80 );
				float2 appendResult19_g81 = (float2(cos( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g81 = normalize( appendResult19_g81 );
				float2 d26_g81 = normalizeResult15_g81;
				float temp_output_47_0_g81 = (d26_g81).x;
				float temp_output_3_0_g81 = temp_output_2_0_g79;
				float k25_g81 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g81 = dot( d26_g81 , (temp_output_1_0_g79).xz );
				float mulTime33_g81 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g81 = ( k25_g81 * ( dotResult29_g81 - mulTime33_g81 ) );
				float temp_output_53_0_g81 = ( temp_output_3_0_g81 * sin( f34_g81 ) );
				float3 appendResult56_g81 = (float3(( ( temp_output_47_0_g81 * -temp_output_47_0_g81 ) * temp_output_53_0_g81 ) , ( ( cos( f34_g81 ) * temp_output_3_0_g81 ) * temp_output_47_0_g81 ) , ( temp_output_53_0_g81 * ( -temp_output_47_0_g81 * (d26_g81).y ) )));
				float3 tangent45_g81 = ( _tangent + appendResult56_g81 );
				float2 appendResult19_g83 = (float2(cos( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g83 = normalize( appendResult19_g83 );
				float2 d26_g83 = normalizeResult15_g83;
				float temp_output_47_0_g83 = (d26_g83).x;
				float temp_output_3_0_g83 = temp_output_2_0_g79;
				float k25_g83 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g83 = dot( d26_g83 , (temp_output_1_0_g79).xz );
				float mulTime33_g83 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g83 = ( k25_g83 * ( dotResult29_g83 - mulTime33_g83 ) );
				float temp_output_53_0_g83 = ( temp_output_3_0_g83 * sin( f34_g83 ) );
				float3 appendResult56_g83 = (float3(( ( temp_output_47_0_g83 * -temp_output_47_0_g83 ) * temp_output_53_0_g83 ) , ( ( cos( f34_g83 ) * temp_output_3_0_g83 ) * temp_output_47_0_g83 ) , ( temp_output_53_0_g83 * ( -temp_output_47_0_g83 * (d26_g83).y ) )));
				float3 tangent45_g83 = ( _tangent + appendResult56_g83 );
				float2 appendResult19_g82 = (float2(cos( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g82 = normalize( appendResult19_g82 );
				float2 d26_g82 = normalizeResult15_g82;
				float temp_output_47_0_g82 = (d26_g82).x;
				float temp_output_3_0_g82 = temp_output_2_0_g79;
				float k25_g82 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g82 = dot( d26_g82 , (temp_output_1_0_g79).xz );
				float mulTime33_g82 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g82 = ( k25_g82 * ( dotResult29_g82 - mulTime33_g82 ) );
				float temp_output_53_0_g82 = ( temp_output_3_0_g82 * sin( f34_g82 ) );
				float3 appendResult56_g82 = (float3(( ( temp_output_47_0_g82 * -temp_output_47_0_g82 ) * temp_output_53_0_g82 ) , ( ( cos( f34_g82 ) * temp_output_3_0_g82 ) * temp_output_47_0_g82 ) , ( temp_output_53_0_g82 * ( -temp_output_47_0_g82 * (d26_g82).y ) )));
				float3 tangent45_g82 = ( _tangent + appendResult56_g82 );
				float3 _binormal = float3(0,0,1);
				float temp_output_67_0_g80 = (d26_g80).y;
				float temp_output_66_0_g80 = ( temp_output_3_0_g80 * sin( f34_g80 ) );
				float3 appendResult72_g80 = (float3(( ( temp_output_67_0_g80 * -temp_output_67_0_g80 ) * temp_output_66_0_g80 ) , ( ( cos( f34_g80 ) * temp_output_3_0_g80 ) * temp_output_67_0_g80 ) , ( temp_output_66_0_g80 * ( -temp_output_67_0_g80 * temp_output_67_0_g80 ) )));
				float3 binormal79_g80 = ( _binormal + appendResult72_g80 );
				float temp_output_67_0_g81 = (d26_g81).y;
				float temp_output_66_0_g81 = ( temp_output_3_0_g81 * sin( f34_g81 ) );
				float3 appendResult72_g81 = (float3(( ( temp_output_67_0_g81 * -temp_output_67_0_g81 ) * temp_output_66_0_g81 ) , ( ( cos( f34_g81 ) * temp_output_3_0_g81 ) * temp_output_67_0_g81 ) , ( temp_output_66_0_g81 * ( -temp_output_67_0_g81 * temp_output_67_0_g81 ) )));
				float3 binormal79_g81 = ( _binormal + appendResult72_g81 );
				float temp_output_67_0_g83 = (d26_g83).y;
				float temp_output_66_0_g83 = ( temp_output_3_0_g83 * sin( f34_g83 ) );
				float3 appendResult72_g83 = (float3(( ( temp_output_67_0_g83 * -temp_output_67_0_g83 ) * temp_output_66_0_g83 ) , ( ( cos( f34_g83 ) * temp_output_3_0_g83 ) * temp_output_67_0_g83 ) , ( temp_output_66_0_g83 * ( -temp_output_67_0_g83 * temp_output_67_0_g83 ) )));
				float3 binormal79_g83 = ( _binormal + appendResult72_g83 );
				float temp_output_67_0_g82 = (d26_g82).y;
				float temp_output_66_0_g82 = ( temp_output_3_0_g82 * sin( f34_g82 ) );
				float3 appendResult72_g82 = (float3(( ( temp_output_67_0_g82 * -temp_output_67_0_g82 ) * temp_output_66_0_g82 ) , ( ( cos( f34_g82 ) * temp_output_3_0_g82 ) * temp_output_67_0_g82 ) , ( temp_output_66_0_g82 * ( -temp_output_67_0_g82 * temp_output_67_0_g82 ) )));
				float3 binormal79_g82 = ( _binormal + appendResult72_g82 );
				float3 normalizeResult20_g79 = normalize( cross( ( tangent45_g80 + tangent45_g81 + tangent45_g83 + tangent45_g82 ) , ( binormal79_g80 + binormal79_g81 + binormal79_g83 + binormal79_g82 ) ) );
				float3 worldToObjDir773 = ASESafeNormalize( mul( GetWorldToObjectMatrix(), float4( normalizeResult20_g79, 0 ) ).xyz );
				float3 normalizeResult844 = ASESafeNormalize( ( worldToObjDir773 + IN.ase_normal ) );
				float3 objectToTangentDir847 = normalize( mul( ase_worldToTangent, mul( GetObjectToWorldMatrix(), float4( normalizeResult844, 0 ) ).xyz) );
				float3 vertexNormal841 = objectToTangentDir847;
				float3 _rTNormal551 = tanTriplanarNormal9_g92;
				float3 lerpResult561 = lerp( _rTNormal551 , _normals210 , 50.0);
				float3 _combinedNormalsRT660 = lerpResult561;
				float4 color667 = IsGammaSpace() ? float4(0,0,1,0) : float4(0,0,1,0);
				float4 lerpResult664 = lerp( float4( _combinedNormalsRT660 , 0.0 ) , color667 , _combinedLines687);
				float3 surf_pos107_g53 = WorldPosition;
				float3 surf_norm107_g53 = WorldNormal;
				float smoothstepResult13_g92 = smoothstep( 0.0 , temp_output_11_0_g92 , tanTriplanarNormal9_g92.b);
				float _rtSmooth888 = smoothstepResult13_g92;
				float temp_output_704_0 = ( _rtSmooth888 + (0) );
				float smoothstepResult674 = smoothstep( 0.0 , 1.06 , temp_output_704_0);
				float height107_g53 = smoothstepResult674;
				float scale107_g53 = _ClayNormal;
				float3 localPerturbNormal107_g53 = PerturbNormal107_g53( surf_pos107_g53 , surf_norm107_g53 , height107_g53 , scale107_g53 );
				float3 worldToTangentDir42_g53 = mul( ase_worldToTangent, localPerturbNormal107_g53);
				float localCalculateUVsSharp110_g70 = ( 0.0 );
				float2 temp_cast_13 = (125.0).xx;
				float2 texCoord5_g69 = IN.ase_texcoord8.xy * ( _Scale * temp_cast_13 ) + float2( 0,0 );
				float2 temp_cast_14 = (-0.1).xx;
				float2 panner30_g69 = ( _TimeParameters.x * temp_cast_14 + texCoord5_g69);
				float2 appendResult34_g69 = (float2(texCoord5_g69.x , (panner30_g69).y));
				float2 temp_output_85_0_g70 = appendResult34_g69;
				float2 UV110_g70 = temp_output_85_0_g70;
				float4 TexelSize110_g70 = _FingerprintNormal_TexelSize;
				float2 UV0110_g70 = float2( 0,0 );
				float2 UV1110_g70 = float2( 0,0 );
				float2 UV2110_g70 = float2( 0,0 );
				{
				{
				    UV110_g70.y -= TexelSize110_g70.y * 0.5;
				    UV0110_g70 = UV110_g70;
				    UV1110_g70 = UV110_g70 + float2( TexelSize110_g70.x, 0 );
				    UV2110_g70 = UV110_g70 + float2( 0, TexelSize110_g70.y );
				}
				}
				float4 break134_g70 = tex2D( _FingerprintNormal, UV0110_g70 );
				float S0128_g70 = break134_g70.r;
				float4 break136_g70 = tex2D( _FingerprintNormal, UV1110_g70 );
				float S1128_g70 = break136_g70.r;
				float4 break138_g70 = tex2D( _FingerprintNormal, UV2110_g70 );
				float S2128_g70 = break138_g70.r;
				float temp_output_91_0_g70 = _FingerprintStrength;
				float Strength128_g70 = temp_output_91_0_g70;
				float3 localCombineSamplesSharp128_g70 = CombineSamplesSharp128_g70( S0128_g70 , S1128_g70 , S2128_g70 , Strength128_g70 );
				float3 surf_pos107_g71 = WorldPosition;
				float3 surf_norm107_g71 = WorldNormal;
				float time8_g69 = -2.7;
				float2 voronoiSmoothId8_g69 = 0;
				float voronoiSmooth8_g69 = _NoiseSmoothness;
				float2 coords8_g69 = appendResult34_g69 * _NoiseScale;
				float2 id8_g69 = 0;
				float2 uv8_g69 = 0;
				float voroi8_g69 = voronoi8_g69( coords8_g69, time8_g69, id8_g69, uv8_g69, voronoiSmooth8_g69, voronoiSmoothId8_g69 );
				float height107_g71 = voroi8_g69;
				float scale107_g71 = _NoiseStrength;
				float3 localPerturbNormal107_g71 = PerturbNormal107_g71( surf_pos107_g71 , surf_norm107_g71 , height107_g71 , scale107_g71 );
				float3 worldToTangentDir42_g71 = mul( ase_worldToTangent, localPerturbNormal107_g71);
				float4 lerpResult686 = lerp( lerpResult664 , float4( BlendNormal( worldToTangentDir42_g53 , BlendNormal( localCombineSamplesSharp128_g70 , worldToTangentDir42_g71 ) ) , 0.0 ) , _combinedLines687);
				float4 _normalsMitRipples665 = lerpResult686;
				float3 temp_output_848_0 = BlendNormalRNM( vertexNormal841 , _normalsMitRipples665.rgb );
				float4 lerpResult853 = lerp( float4( temp_output_848_0 , 0.0 ) , _normalsMitRipples665 , _Float5);
				float4 _endNormals896 = lerpResult853;
				
				float4 temp_cast_20 = (0.43).xxxx;
				float4 temp_cast_21 = (0.01).xxxx;
				float2 temp_cast_22 = (( speedVar31_g93 * -0.15 )).xx;
				float2 panner39_g93 = ( 1.0 * _Time.y * temp_cast_22 + ( 0.15 * worldPosUV51_g93 ));
				float4 lerpResult42_g93 = lerp( temp_cast_21 , tex2D( _heightFoam, panner39_g93 ) , ( WorldPosition.y + _HeightFoamH ));
				float4 smoothstepResult45_g93 = smoothstep( float4( 0,0,0,0 ) , temp_cast_20 , lerpResult42_g93);
				float4 _foam259 = smoothstepResult45_g93;
				float4 temp_cast_24 = (_Caustics).xxxx;
				float2 UV22_g73 = ase_screenPosNorm.xy;
				float2 localUnStereo22_g73 = UnStereo( UV22_g73 );
				float2 break64_g72 = localUnStereo22_g73;
				float clampDepth69_g72 = SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy );
				#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g72 = ( 1.0 - clampDepth69_g72 );
				#else
				float staticSwitch38_g72 = clampDepth69_g72;
				#endif
				float3 appendResult39_g72 = (float3(break64_g72.x , break64_g72.y , staticSwitch38_g72));
				float4 appendResult42_g72 = (float4((appendResult39_g72*2.0 + -1.0) , 1.0));
				float4 temp_output_43_0_g72 = mul( unity_CameraInvProjection, appendResult42_g72 );
				float3 temp_output_46_0_g72 = ( (temp_output_43_0_g72).xyz / (temp_output_43_0_g72).w );
				float3 In75_g72 = temp_output_46_0_g72;
				float3 localInvertDepthDirURP75_g72 = InvertDepthDirURP75_g72( In75_g72 );
				float4 appendResult49_g72 = (float4(localInvertDepthDirURP75_g72 , 1.0));
				float2 temp_output_30_0_g76 = (( mul( unity_CameraToWorld, appendResult49_g72 ) * 0.04 )).xz;
				float temp_output_1_0_g76 = 0.05;
				float2 temp_output_15_0_g76 = ( temp_output_30_0_g76 + ( float2( 0.1,0 ) * temp_output_1_0_g76 ) );
				float2 panner32_g76 = ( 1.0 * _Time.y * float2( 0.09,0.06 ) + temp_output_15_0_g76);
				float4 tex2DNode31_g76 = tex2D( _Caust, panner32_g76 );
				float3 appendResult36_g76 = (float3(tex2DNode31_g76.r , tex2DNode31_g76.g , tex2DNode31_g76.b));
				float2 panner35_g76 = ( 1.0 * _Time.y * float2( -0.05,-0.07 ) + temp_output_15_0_g76);
				float4 tex2DNode34_g76 = tex2D( _Caust, panner35_g76 );
				float3 appendResult39_g76 = (float3(tex2DNode34_g76.r , tex2DNode34_g76.g , tex2DNode34_g76.b));
				float2 temp_output_16_0_g76 = ( temp_output_30_0_g76 + ( float2( 0,0.1 ) * temp_output_1_0_g76 ) );
				float2 panner46_g76 = ( 1.0 * _Time.y * float2( 0.09,0.06 ) + temp_output_16_0_g76);
				float4 tex2DNode45_g76 = tex2D( _Caust, panner46_g76 );
				float3 appendResult47_g76 = (float3(tex2DNode45_g76.r , tex2DNode45_g76.g , tex2DNode45_g76.b));
				float2 panner49_g76 = ( 1.0 * _Time.y * float2( -0.05,-0.07 ) + temp_output_16_0_g76);
				float4 tex2DNode50_g76 = tex2D( _Caust, panner49_g76 );
				float3 appendResult51_g76 = (float3(tex2DNode50_g76.r , tex2DNode50_g76.g , tex2DNode50_g76.b));
				float2 temp_output_17_0_g76 = ( temp_output_30_0_g76 + ( float2( -0.1,-0.1 ) * temp_output_1_0_g76 ) );
				float2 panner54_g76 = ( 1.0 * _Time.y * float2( 0.09,0.06 ) + temp_output_17_0_g76);
				float4 tex2DNode53_g76 = tex2D( _Caust, panner54_g76 );
				float3 appendResult55_g76 = (float3(tex2DNode53_g76.r , tex2DNode53_g76.g , tex2DNode53_g76.b));
				float2 panner57_g76 = ( 1.0 * _Time.y * float2( -0.05,-0.07 ) + temp_output_17_0_g76);
				float4 tex2DNode58_g76 = tex2D( _Caust, panner57_g76 );
				float3 appendResult59_g76 = (float3(tex2DNode58_g76.r , tex2DNode58_g76.g , tex2DNode58_g76.b));
				float3 appendResult44_g76 = (float3((min( appendResult36_g76 , appendResult39_g76 )).x , (min( appendResult47_g76 , appendResult51_g76 )).y , (min( appendResult55_g76 , appendResult59_g76 )).z));
				float4 appendResult8_g76 = (float4(appendResult44_g76 , 1.0));
				float4 smoothstepResult610 = smoothstep( float4( 0,0,0,0 ) , temp_cast_24 , appendResult8_g76);
				float4 temp_output_616_0 = ( saturate( smoothstepResult610 ) * _depthMask614 );
				float4 _caustics626 = temp_output_616_0;
				float4 blendOpSrc627 = ( _colors292 + _foam259 );
				float4 blendOpDest627 = _caustics626;
				float4 lerpResult692 = lerp( ( saturate( ( 1.0 - ( 1.0 - blendOpSrc627 ) * ( 1.0 - blendOpDest627 ) ) )) , float4( 0,0,0,0 ) , _combinedLines687);
				float4 _emission894 = lerpResult692;
				

				float3 BaseColor = _endColor892.rgb;
				float3 Normal = _endNormals896.rgb;
				float3 Emission = _emission894.xyz;
				float3 Specular = 0.5;
				float Metallic = 0;
				float Smoothness = 0.5;
				float Occlusion = 1;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.clipPos.z;
				#endif

				#ifdef _CLEARCOAT
					float CoatMask = 0;
					float CoatSmoothness = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = WorldPosition;
				inputData.viewDirectionWS = WorldViewDirection;

				#ifdef _NORMALMAP
						#if _NORMAL_DROPOFF_TS
							inputData.normalWS = TransformTangentToWorld(Normal, half3x3(WorldTangent, WorldBiTangent, WorldNormal));
						#elif _NORMAL_DROPOFF_OS
							inputData.normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							inputData.normalWS = Normal;
						#endif
					inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				#else
					inputData.normalWS = WorldNormal;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					inputData.shadowCoord = ShadowCoords;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					inputData.shadowCoord = TransformWorldToShadowCoord(inputData.positionWS);
				#else
					inputData.shadowCoord = float4(0, 0, 0, 0);
				#endif

				#ifdef ASE_FOG
					inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				#endif
					inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, IN.dynamicLightmapUV.xy, SH, inputData.normalWS);
				#else
					inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS);
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif

				inputData.normalizedScreenSpaceUV = NormalizedScreenSpaceUV;
				inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = IN.dynamicLightmapUV.xy;
					#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = IN.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
				#endif

				SurfaceData surfaceData;
				surfaceData.albedo              = BaseColor;
				surfaceData.metallic            = saturate(Metallic);
				surfaceData.specular            = Specular;
				surfaceData.smoothness          = saturate(Smoothness),
				surfaceData.occlusion           = Occlusion,
				surfaceData.emission            = Emission,
				surfaceData.alpha               = saturate(Alpha);
				surfaceData.normalTS            = Normal;
				surfaceData.clearCoatMask       = 0;
				surfaceData.clearCoatSmoothness = 1;

				#ifdef _CLEARCOAT
					surfaceData.clearCoatMask       = saturate(CoatMask);
					surfaceData.clearCoatSmoothness = saturate(CoatSmoothness);
				#endif

				#ifdef _DBUFFER
					ApplyDecalToSurfaceData(IN.clipPos, surfaceData, inputData);
				#endif

				half4 color = UniversalFragmentPBR( inputData, surfaceData);

				#ifdef ASE_TRANSMISSION
				{
					float shadow = _TransmissionShadow;

					Light mainLight = GetMainLight( inputData.shadowCoord );
					float3 mainAtten = mainLight.color * mainLight.distanceAttenuation;
					mainAtten = lerp( mainAtten, mainAtten * mainLight.shadowAttenuation, shadow );
					half3 mainTransmission = max(0 , -dot(inputData.normalWS, mainLight.direction)) * mainAtten * Transmission;
					color.rgb += BaseColor * mainTransmission;

					#ifdef _ADDITIONAL_LIGHTS
						int transPixelLightCount = GetAdditionalLightsCount();
						for (int i = 0; i < transPixelLightCount; ++i)
						{
							Light light = GetAdditionalLight(i, inputData.positionWS);
							float3 atten = light.color * light.distanceAttenuation;
							atten = lerp( atten, atten * light.shadowAttenuation, shadow );

							half3 transmission = max(0 , -dot(inputData.normalWS, light.direction)) * atten * Transmission;
							color.rgb += BaseColor * transmission;
						}
					#endif
				}
				#endif

				#ifdef ASE_TRANSLUCENCY
				{
					float shadow = _TransShadow;
					float normal = _TransNormal;
					float scattering = _TransScattering;
					float direct = _TransDirect;
					float ambient = _TransAmbient;
					float strength = _TransStrength;

					Light mainLight = GetMainLight( inputData.shadowCoord );
					float3 mainAtten = mainLight.color * mainLight.distanceAttenuation;
					mainAtten = lerp( mainAtten, mainAtten * mainLight.shadowAttenuation, shadow );

					half3 mainLightDir = mainLight.direction + inputData.normalWS * normal;
					half mainVdotL = pow( saturate( dot( inputData.viewDirectionWS, -mainLightDir ) ), scattering );
					half3 mainTranslucency = mainAtten * ( mainVdotL * direct + inputData.bakedGI * ambient ) * Translucency;
					color.rgb += BaseColor * mainTranslucency * strength;

					#ifdef _ADDITIONAL_LIGHTS
						int transPixelLightCount = GetAdditionalLightsCount();
						for (int i = 0; i < transPixelLightCount; ++i)
						{
							Light light = GetAdditionalLight(i, inputData.positionWS);
							float3 atten = light.color * light.distanceAttenuation;
							atten = lerp( atten, atten * light.shadowAttenuation, shadow );

							half3 lightDir = light.direction + inputData.normalWS * normal;
							half VdotL = pow( saturate( dot( inputData.viewDirectionWS, -lightDir ) ), scattering );
							half3 translucency = atten * ( VdotL * direct + inputData.bakedGI * ambient ) * Translucency;
							color.rgb += BaseColor * translucency * strength;
						}
					#endif
				}
				#endif

				#ifdef ASE_REFRACTION
					float4 projScreenPos = ScreenPos / ScreenPos.w;
					float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, float4( WorldNormal,0 ) ).xyz * ( 1.0 - dot( WorldNormal, WorldViewDirection ) );
					projScreenPos.xy += refractionOffset.xy;
					float3 refraction = SHADERGRAPH_SAMPLE_SCENE_COLOR( projScreenPos.xy ) * RefractionColor;
					color.rgb = lerp( refraction, color.rgb, color.a );
					color.a = 1;
				#endif

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
					#endif
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual
			AlphaToMask Off
			ColorMask 0

			HLSLPROGRAM

			#pragma multi_compile_instancing
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_TESSELLATION 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_DISTANCE_TESSELLATION
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120110


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW

			#define SHADERPASS SHADERPASS_SHADOWCASTER

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 clipPos : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD1;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD2;
				#endif				
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Horizon;
			float4 _ShallowColor;
			float4 _DeepColor;
			float4 _SpecularColor;
			float4 _FingerprintNormal_TexelSize;
			float4 _FoamClayColor;
			float4 _WaterNormal_ST;
			float _FingerprintStrength;
			float _Foam;
			float _NoiseSmoothness;
			float _ClayNormal;
			float _NoiseStrength;
			float _Float5;
			float _RippleCutoff;
			float _Speed;
			float _NoiseScale;
			float _Scale;
			float _WaveLength;
			float _HeightFoamH;
			float _WaterDepth;
			float _RefractionDistortion;
			float _LightingHardness;
			float _LightingSmoothness;
			float _NormalIntensity;
			float _NormalScale;
			float _Steepness;
			float _WaveSpeed;
			float _wavesZ;
			float _HorizonDistance;
			float _Caustics;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _FingerprintNormal;
			sampler2D _Roughness;
			sampler2D _GlobalEffectRT;


			
			float3 _LightDirection;
			float3 _LightPosition;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float4 temp_output_5_0_g79 = float4(0.02,-0.34,0.16,2.23);
				float2 appendResult19_g80 = (float2(cos( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g80 = normalize( appendResult19_g80 );
				float2 d26_g80 = normalizeResult15_g80;
				float temp_output_3_0_g79 = _WaveLength;
				float k25_g80 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float _0waterMover900 = _wavesZ;
				float3 appendResult758 = (float3(ase_worldPos.x , ase_worldPos.y , ( ase_worldPos.z + _0waterMover900 )));
				float3 temp_output_1_0_g79 = appendResult758;
				float dotResult29_g80 = dot( d26_g80 , (temp_output_1_0_g79).xz );
				float temp_output_4_0_g79 = _WaveSpeed;
				float mulTime33_g80 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g80 = ( k25_g80 * ( dotResult29_g80 - mulTime33_g80 ) );
				float temp_output_2_0_g79 = _Steepness;
				float temp_output_3_0_g80 = temp_output_2_0_g79;
				float a37_g80 = ( temp_output_3_0_g80 / k25_g80 );
				float temp_output_91_0_g80 = ( cos( f34_g80 ) * a37_g80 );
				float3 appendResult86_g80 = (float3(( (d26_g80).x * temp_output_91_0_g80 ) , ( a37_g80 * sin( f34_g80 ) ) , ( temp_output_91_0_g80 * (d26_g80).y )));
				float2 appendResult19_g81 = (float2(cos( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g81 = normalize( appendResult19_g81 );
				float2 d26_g81 = normalizeResult15_g81;
				float k25_g81 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g81 = dot( d26_g81 , (temp_output_1_0_g79).xz );
				float mulTime33_g81 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g81 = ( k25_g81 * ( dotResult29_g81 - mulTime33_g81 ) );
				float temp_output_3_0_g81 = temp_output_2_0_g79;
				float a37_g81 = ( temp_output_3_0_g81 / k25_g81 );
				float temp_output_91_0_g81 = ( cos( f34_g81 ) * a37_g81 );
				float3 appendResult86_g81 = (float3(( (d26_g81).x * temp_output_91_0_g81 ) , ( a37_g81 * sin( f34_g81 ) ) , ( temp_output_91_0_g81 * (d26_g81).y )));
				float2 appendResult19_g83 = (float2(cos( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g83 = normalize( appendResult19_g83 );
				float2 d26_g83 = normalizeResult15_g83;
				float k25_g83 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g83 = dot( d26_g83 , (temp_output_1_0_g79).xz );
				float mulTime33_g83 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g83 = ( k25_g83 * ( dotResult29_g83 - mulTime33_g83 ) );
				float temp_output_3_0_g83 = temp_output_2_0_g79;
				float a37_g83 = ( temp_output_3_0_g83 / k25_g83 );
				float temp_output_91_0_g83 = ( cos( f34_g83 ) * a37_g83 );
				float3 appendResult86_g83 = (float3(( (d26_g83).x * temp_output_91_0_g83 ) , ( a37_g83 * sin( f34_g83 ) ) , ( temp_output_91_0_g83 * (d26_g83).y )));
				float2 appendResult19_g82 = (float2(cos( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g82 = normalize( appendResult19_g82 );
				float2 d26_g82 = normalizeResult15_g82;
				float k25_g82 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g82 = dot( d26_g82 , (temp_output_1_0_g79).xz );
				float mulTime33_g82 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g82 = ( k25_g82 * ( dotResult29_g82 - mulTime33_g82 ) );
				float temp_output_3_0_g82 = temp_output_2_0_g79;
				float a37_g82 = ( temp_output_3_0_g82 / k25_g82 );
				float temp_output_91_0_g82 = ( cos( f34_g82 ) * a37_g82 );
				float3 appendResult86_g82 = (float3(( (d26_g82).x * temp_output_91_0_g82 ) , ( a37_g82 * sin( f34_g82 ) ) , ( temp_output_91_0_g82 * (d26_g82).y )));
				float3 worldToObj485 = mul( GetWorldToObjectMatrix(), float4( ( ase_worldPos + ( ( appendResult86_g80 + appendResult86_g81 ) + ( appendResult86_g83 + appendResult86_g82 ) ) ), 1 ) ).xyz;
				float3 waveDisplacement493 = worldToObj485;
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = waveDisplacement493;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

				#if _CASTING_PUNCTUAL_LIGHT_SHADOW
					float3 lightDirectionWS = normalize(_LightPosition - positionWS);
				#else
					float3 lightDirectionWS = _LightDirection;
				#endif

				float4 clipPos = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDirectionWS));

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, UNITY_NEAR_CLIP_VALUE);
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = clipPos;
				o.clipPosV = clipPos;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(	VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				

				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.clipPos.z;
				#endif

				#ifdef _ALPHATEST_ON
					#ifdef _ALPHATEST_SHADOW_ON
						clip(Alpha - AlphaClipThresholdShadow);
					#else
						clip(Alpha - AlphaClipThreshold);
					#endif
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0
			AlphaToMask Off

			HLSLPROGRAM

			#pragma multi_compile_instancing
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_TESSELLATION 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_DISTANCE_TESSELLATION
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120110


			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 clipPos : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD1;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD2;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Horizon;
			float4 _ShallowColor;
			float4 _DeepColor;
			float4 _SpecularColor;
			float4 _FingerprintNormal_TexelSize;
			float4 _FoamClayColor;
			float4 _WaterNormal_ST;
			float _FingerprintStrength;
			float _Foam;
			float _NoiseSmoothness;
			float _ClayNormal;
			float _NoiseStrength;
			float _Float5;
			float _RippleCutoff;
			float _Speed;
			float _NoiseScale;
			float _Scale;
			float _WaveLength;
			float _HeightFoamH;
			float _WaterDepth;
			float _RefractionDistortion;
			float _LightingHardness;
			float _LightingSmoothness;
			float _NormalIntensity;
			float _NormalScale;
			float _Steepness;
			float _WaveSpeed;
			float _wavesZ;
			float _HorizonDistance;
			float _Caustics;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _FingerprintNormal;
			sampler2D _Roughness;
			sampler2D _GlobalEffectRT;


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float4 temp_output_5_0_g79 = float4(0.02,-0.34,0.16,2.23);
				float2 appendResult19_g80 = (float2(cos( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g80 = normalize( appendResult19_g80 );
				float2 d26_g80 = normalizeResult15_g80;
				float temp_output_3_0_g79 = _WaveLength;
				float k25_g80 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float _0waterMover900 = _wavesZ;
				float3 appendResult758 = (float3(ase_worldPos.x , ase_worldPos.y , ( ase_worldPos.z + _0waterMover900 )));
				float3 temp_output_1_0_g79 = appendResult758;
				float dotResult29_g80 = dot( d26_g80 , (temp_output_1_0_g79).xz );
				float temp_output_4_0_g79 = _WaveSpeed;
				float mulTime33_g80 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g80 = ( k25_g80 * ( dotResult29_g80 - mulTime33_g80 ) );
				float temp_output_2_0_g79 = _Steepness;
				float temp_output_3_0_g80 = temp_output_2_0_g79;
				float a37_g80 = ( temp_output_3_0_g80 / k25_g80 );
				float temp_output_91_0_g80 = ( cos( f34_g80 ) * a37_g80 );
				float3 appendResult86_g80 = (float3(( (d26_g80).x * temp_output_91_0_g80 ) , ( a37_g80 * sin( f34_g80 ) ) , ( temp_output_91_0_g80 * (d26_g80).y )));
				float2 appendResult19_g81 = (float2(cos( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g81 = normalize( appendResult19_g81 );
				float2 d26_g81 = normalizeResult15_g81;
				float k25_g81 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g81 = dot( d26_g81 , (temp_output_1_0_g79).xz );
				float mulTime33_g81 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g81 = ( k25_g81 * ( dotResult29_g81 - mulTime33_g81 ) );
				float temp_output_3_0_g81 = temp_output_2_0_g79;
				float a37_g81 = ( temp_output_3_0_g81 / k25_g81 );
				float temp_output_91_0_g81 = ( cos( f34_g81 ) * a37_g81 );
				float3 appendResult86_g81 = (float3(( (d26_g81).x * temp_output_91_0_g81 ) , ( a37_g81 * sin( f34_g81 ) ) , ( temp_output_91_0_g81 * (d26_g81).y )));
				float2 appendResult19_g83 = (float2(cos( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g83 = normalize( appendResult19_g83 );
				float2 d26_g83 = normalizeResult15_g83;
				float k25_g83 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g83 = dot( d26_g83 , (temp_output_1_0_g79).xz );
				float mulTime33_g83 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g83 = ( k25_g83 * ( dotResult29_g83 - mulTime33_g83 ) );
				float temp_output_3_0_g83 = temp_output_2_0_g79;
				float a37_g83 = ( temp_output_3_0_g83 / k25_g83 );
				float temp_output_91_0_g83 = ( cos( f34_g83 ) * a37_g83 );
				float3 appendResult86_g83 = (float3(( (d26_g83).x * temp_output_91_0_g83 ) , ( a37_g83 * sin( f34_g83 ) ) , ( temp_output_91_0_g83 * (d26_g83).y )));
				float2 appendResult19_g82 = (float2(cos( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g82 = normalize( appendResult19_g82 );
				float2 d26_g82 = normalizeResult15_g82;
				float k25_g82 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g82 = dot( d26_g82 , (temp_output_1_0_g79).xz );
				float mulTime33_g82 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g82 = ( k25_g82 * ( dotResult29_g82 - mulTime33_g82 ) );
				float temp_output_3_0_g82 = temp_output_2_0_g79;
				float a37_g82 = ( temp_output_3_0_g82 / k25_g82 );
				float temp_output_91_0_g82 = ( cos( f34_g82 ) * a37_g82 );
				float3 appendResult86_g82 = (float3(( (d26_g82).x * temp_output_91_0_g82 ) , ( a37_g82 * sin( f34_g82 ) ) , ( temp_output_91_0_g82 * (d26_g82).y )));
				float3 worldToObj485 = mul( GetWorldToObjectMatrix(), float4( ( ase_worldPos + ( ( appendResult86_g80 + appendResult86_g81 ) + ( appendResult86_g83 + appendResult86_g82 ) ) ), 1 ) ).xyz;
				float3 waveDisplacement493 = worldToObj485;
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = waveDisplacement493;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;
				o.clipPosV = positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(	VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				

				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.clipPos.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM

			#define ASE_TESSELLATION 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_DISTANCE_TESSELLATION
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120110
			#define REQUIRE_OPAQUE_TEXTURE 1
			#define REQUIRE_DEPTH_TEXTURE 1


			#pragma vertex vert
			#pragma fragment frag

			#pragma shader_feature EDITOR_VISUALIZATION

			#define SHADERPASS SHADERPASS_META

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_POSITION


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				#ifdef EDITOR_VISUALIZATION
					float4 VizUV : TEXCOORD2;
					float4 LightCoord : TEXCOORD3;
				#endif
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_tangent : TANGENT;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
				float4 ase_texcoord8 : TEXCOORD8;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Horizon;
			float4 _ShallowColor;
			float4 _DeepColor;
			float4 _SpecularColor;
			float4 _FingerprintNormal_TexelSize;
			float4 _FoamClayColor;
			float4 _WaterNormal_ST;
			float _FingerprintStrength;
			float _Foam;
			float _NoiseSmoothness;
			float _ClayNormal;
			float _NoiseStrength;
			float _Float5;
			float _RippleCutoff;
			float _Speed;
			float _NoiseScale;
			float _Scale;
			float _WaveLength;
			float _HeightFoamH;
			float _WaterDepth;
			float _RefractionDistortion;
			float _LightingHardness;
			float _LightingSmoothness;
			float _NormalIntensity;
			float _NormalScale;
			float _Steepness;
			float _WaveSpeed;
			float _wavesZ;
			float _HorizonDistance;
			float _Caustics;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _FingerprintNormal;
			sampler2D _Roughness;
			sampler2D _GlobalEffectRT;
			sampler2D _WaterNormal;
			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _foam;
			sampler2D _heightFoam;
			sampler2D _Caust;


			float3 TangentToWorld13_g21( float3 NormalTS, float3x3 TBN )
			{
				float3 NormalWS = TransformTangentToWorld(NormalTS, TBN);
				NormalWS = NormalizeNormalPerPixel(NormalWS);
				return NormalWS;
			}
			
			float3 AdditionalLightsSpecular10x12x( float3 WorldPosition, float3 WorldNormal, float3 WorldView, float3 SpecColor, float Smoothness )
			{
				float3 Color = 0;
				#ifdef _ADDITIONAL_LIGHTS
					Smoothness = exp2(10 * Smoothness + 1);
					uint lightCount = GetAdditionalLightsCount();
					LIGHT_LOOP_BEGIN( lightCount )
						Light light = GetAdditionalLight(lightIndex, WorldPosition);
						half3 AttLightColor = light.color *(light.distanceAttenuation * light.shadowAttenuation);
						Color += LightingSpecular(AttLightColor, light.direction, WorldNormal, WorldView, half4(SpecColor, 0), Smoothness);	
					LIGHT_LOOP_END
				#endif
				return Color;
			}
			
			inline float3 TriplanarSampling9_g92( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				xNorm.xyz  = half3( UnpackNormalScale( xNorm , 1.0 ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
				yNorm.xyz  = half3( UnpackNormalScale( yNorm , 1.0 ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
				zNorm.xyz  = half3( UnpackNormalScale( zNorm , 1.0 ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
				return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
			}
			
			float2 UnStereo( float2 UV )
			{
				#if UNITY_SINGLE_PASS_STEREO
				float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
				UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
				#endif
				return UV;
			}
			
			float3 InvertDepthDirURP75_g72( float3 In )
			{
				float3 result = In;
				#if !defined(ASE_SRP_VERSION) || ASE_SRP_VERSION <= 70301 || ASE_SRP_VERSION == 70503 || ASE_SRP_VERSION == 70600 || ASE_SRP_VERSION == 70700 || ASE_SRP_VERSION == 70701 || ASE_SRP_VERSION >= 80301
				result *= float3(1,1,-1);
				#endif
				return result;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float4 temp_output_5_0_g79 = float4(0.02,-0.34,0.16,2.23);
				float2 appendResult19_g80 = (float2(cos( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g80 = normalize( appendResult19_g80 );
				float2 d26_g80 = normalizeResult15_g80;
				float temp_output_3_0_g79 = _WaveLength;
				float k25_g80 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float _0waterMover900 = _wavesZ;
				float3 appendResult758 = (float3(ase_worldPos.x , ase_worldPos.y , ( ase_worldPos.z + _0waterMover900 )));
				float3 temp_output_1_0_g79 = appendResult758;
				float dotResult29_g80 = dot( d26_g80 , (temp_output_1_0_g79).xz );
				float temp_output_4_0_g79 = _WaveSpeed;
				float mulTime33_g80 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g80 = ( k25_g80 * ( dotResult29_g80 - mulTime33_g80 ) );
				float temp_output_2_0_g79 = _Steepness;
				float temp_output_3_0_g80 = temp_output_2_0_g79;
				float a37_g80 = ( temp_output_3_0_g80 / k25_g80 );
				float temp_output_91_0_g80 = ( cos( f34_g80 ) * a37_g80 );
				float3 appendResult86_g80 = (float3(( (d26_g80).x * temp_output_91_0_g80 ) , ( a37_g80 * sin( f34_g80 ) ) , ( temp_output_91_0_g80 * (d26_g80).y )));
				float2 appendResult19_g81 = (float2(cos( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g81 = normalize( appendResult19_g81 );
				float2 d26_g81 = normalizeResult15_g81;
				float k25_g81 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g81 = dot( d26_g81 , (temp_output_1_0_g79).xz );
				float mulTime33_g81 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g81 = ( k25_g81 * ( dotResult29_g81 - mulTime33_g81 ) );
				float temp_output_3_0_g81 = temp_output_2_0_g79;
				float a37_g81 = ( temp_output_3_0_g81 / k25_g81 );
				float temp_output_91_0_g81 = ( cos( f34_g81 ) * a37_g81 );
				float3 appendResult86_g81 = (float3(( (d26_g81).x * temp_output_91_0_g81 ) , ( a37_g81 * sin( f34_g81 ) ) , ( temp_output_91_0_g81 * (d26_g81).y )));
				float2 appendResult19_g83 = (float2(cos( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g83 = normalize( appendResult19_g83 );
				float2 d26_g83 = normalizeResult15_g83;
				float k25_g83 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g83 = dot( d26_g83 , (temp_output_1_0_g79).xz );
				float mulTime33_g83 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g83 = ( k25_g83 * ( dotResult29_g83 - mulTime33_g83 ) );
				float temp_output_3_0_g83 = temp_output_2_0_g79;
				float a37_g83 = ( temp_output_3_0_g83 / k25_g83 );
				float temp_output_91_0_g83 = ( cos( f34_g83 ) * a37_g83 );
				float3 appendResult86_g83 = (float3(( (d26_g83).x * temp_output_91_0_g83 ) , ( a37_g83 * sin( f34_g83 ) ) , ( temp_output_91_0_g83 * (d26_g83).y )));
				float2 appendResult19_g82 = (float2(cos( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g82 = normalize( appendResult19_g82 );
				float2 d26_g82 = normalizeResult15_g82;
				float k25_g82 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g82 = dot( d26_g82 , (temp_output_1_0_g79).xz );
				float mulTime33_g82 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g82 = ( k25_g82 * ( dotResult29_g82 - mulTime33_g82 ) );
				float temp_output_3_0_g82 = temp_output_2_0_g79;
				float a37_g82 = ( temp_output_3_0_g82 / k25_g82 );
				float temp_output_91_0_g82 = ( cos( f34_g82 ) * a37_g82 );
				float3 appendResult86_g82 = (float3(( (d26_g82).x * temp_output_91_0_g82 ) , ( a37_g82 * sin( f34_g82 ) ) , ( temp_output_91_0_g82 * (d26_g82).y )));
				float3 worldToObj485 = mul( GetWorldToObjectMatrix(), float4( ( ase_worldPos + ( ( appendResult86_g80 + appendResult86_g81 ) + ( appendResult86_g83 + appendResult86_g82 ) ) ), 1 ) ).xyz;
				float3 waveDisplacement493 = worldToObj485;
				
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord5.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord6.xyz = ase_worldNormal;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord4.z = eyeDepth;
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord7 = screenPos;
				float ase_vertexTangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord8.xyz = ase_worldBitangent;
				
				o.ase_texcoord4.xy = v.texcoord0.xy;
				o.ase_tangent = v.ase_tangent;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.w = 0;
				o.ase_texcoord5.w = 0;
				o.ase_texcoord6.w = 0;
				o.ase_texcoord8.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = waveDisplacement493;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );

				#ifdef EDITOR_VISUALIZATION
					float2 VizUV = 0;
					float4 LightCoord = 0;
					UnityEditorVizData(v.vertex.xyz, v.texcoord0.xy, v.texcoord1.xy, v.texcoord2.xy, VizUV, LightCoord);
					o.VizUV = float4(VizUV, 0, 0);
					o.LightCoord = LightCoord;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = o.clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_tangent : TANGENT;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.texcoord0 = v.texcoord0;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				o.ase_tangent = v.ase_tangent;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.texcoord0 = patch[0].texcoord0 * bary.x + patch[1].texcoord0 * bary.y + patch[2].texcoord0 * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float _0waterMover900 = _wavesZ;
				float2 appendResult903 = (float2(0.0 , -_0waterMover900));
				float2 uv_WaterNormal = IN.ase_texcoord4.xy * _WaterNormal_ST.xy + _WaterNormal_ST.zw;
				float2 temp_output_907_0 = ( ( appendResult903 * 0.05 ) + ( uv_WaterNormal * _NormalScale ) );
				float2 panner22 = ( 1.0 * _Time.y * float2( -0.03,0 ) + temp_output_907_0);
				float3 unpack23 = UnpackNormalScale( tex2D( _WaterNormal, panner22 ), _NormalIntensity );
				unpack23.z = lerp( 1, unpack23.z, saturate(_NormalIntensity) );
				float2 panner19 = ( 1.0 * _Time.y * float2( 0.04,0.04 ) + temp_output_907_0);
				float3 unpack17 = UnpackNormalScale( tex2D( _WaterNormal, panner19 ), _NormalIntensity );
				unpack17.z = lerp( 1, unpack17.z, saturate(_NormalIntensity) );
				float3 _normals210 = BlendNormal( unpack23 , unpack17 );
				float3 NormalTS13_g21 = _normals210;
				float3 ase_worldTangent = IN.ase_texcoord5.xyz;
				float3 ase_worldNormal = IN.ase_texcoord6.xyz;
				float3 Binormal5_g21 = ( ( IN.ase_tangent.w > 0.0 ? 1.0 : -1.0 ) * cross( ase_worldNormal , ase_worldTangent ) );
				float3x3 TBN1_g21 = float3x3(ase_worldTangent, Binormal5_g21, ase_worldNormal);
				float3x3 TBN13_g21 = TBN1_g21;
				float3 localTangentToWorld13_g21 = TangentToWorld13_g21( NormalTS13_g21 , TBN13_g21 );
				float3 temp_output_430_0 = localTangentToWorld13_g21;
				float dotResult383 = dot( SafeNormalize(_MainLightPosition.xyz) , temp_output_430_0 );
				float temp_output_385_0 = pow( saturate( dotResult383 ) , exp2( ( ( _LightingSmoothness * 10.0 ) + 1.0 ) ) );
				float lerpResult357 = lerp( temp_output_385_0 , step( 0.5 , temp_output_385_0 ) , _LightingHardness);
				float3 worldPosValue44_g22 = WorldPosition;
				float3 WorldPosition13_g22 = worldPosValue44_g22;
				float3 worldNormalValue50_g22 = temp_output_430_0;
				float3 WorldNormal13_g22 = worldNormalValue50_g22;
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = SafeNormalize( ase_worldViewDir );
				float3 temp_output_15_0_g22 = ase_worldViewDir;
				float3 WorldView13_g22 = temp_output_15_0_g22;
				float3 temp_output_14_0_g22 = _SpecularColor.rgb;
				float3 SpecColor13_g22 = temp_output_14_0_g22;
				float temp_output_18_0_g22 = _LightingSmoothness;
				float Smoothness13_g22 = temp_output_18_0_g22;
				float3 localAdditionalLightsSpecular10x12x13_g22 = AdditionalLightsSpecular10x12x( WorldPosition13_g22 , WorldNormal13_g22 , WorldView13_g22 , SpecColor13_g22 , Smoothness13_g22 );
				float3 specularResult61_g22 = localAdditionalLightsSpecular10x12x13_g22;
				float4 _lights438 = ( ( ( lerpResult357 * _SpecularColor ) * _SpecularColor.a ) + float4( specularResult61_g22 , 0.0 ) );
				float eyeDepth = IN.ase_texcoord4.z;
				float4 screenPos = IN.ase_texcoord7;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float eyeDepth28_g78 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float2 temp_output_20_0_g78 = ( (_normals210).xy * ( _RefractionDistortion / max( eyeDepth , 0.1 ) ) * saturate( ( eyeDepth28_g78 - eyeDepth ) ) );
				float eyeDepth2_g78 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ( float4( temp_output_20_0_g78, 0.0 , 0.0 ) + ase_screenPosNorm ).xy ),_ZBufferParams);
				float2 temp_output_32_0_g78 = (( float4( ( temp_output_20_0_g78 * saturate( ( eyeDepth2_g78 - eyeDepth ) ) ), 0.0 , 0.0 ) + ase_screenPosNorm )).xy;
				float2 temp_output_246_38 = temp_output_32_0_g78;
				float4 fetchOpaqueVal65 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( temp_output_246_38 ), 1.0 );
				float4 _refraction254 = fetchOpaqueVal65;
				float2 _refractUV290 = temp_output_246_38;
				float eyeDepth2_g77 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( float4( _refractUV290, 0.0 , 0.0 ).xy ),_ZBufferParams);
				float depthToLinear6_g77 = LinearEyeDepth(ase_screenPosNorm.z,_ZBufferParams);
				float _depthMask614 = ( 1.0 - saturate( ( ( abs( ( ( eyeDepth2_g77 - depthToLinear6_g77 ) / _WaterDepth ) ) * 0.07 ) + -0.05 ) ) );
				float4 lerpResult13 = lerp( _DeepColor , _ShallowColor , _depthMask614);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float fresnelNdotV316 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode316 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV316, _HorizonDistance ) );
				float4 lerpResult320 = lerp( ( _refraction254 * lerpResult13 ) , _Horizon , fresnelNode316);
				float4 _colors292 = lerpResult320;
				float screenDepth71_g93 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth71_g93 = saturate( abs( ( screenDepth71_g93 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( ( _Foam * 2.0 ) ) ) );
				float _foamDiff63_g93 = ( distanceDepth71_g93 * 11.25 );
				float _speedVar231 = _Speed;
				float speedVar31_g93 = _speedVar231;
				float mulTime19_g93 = _TimeParameters.x * speedVar31_g93;
				float temp_output_26_0_g93 = ( _foamDiff63_g93 - saturate( sin( ( ( _foamDiff63_g93 - mulTime19_g93 ) * ( 4.0 * PI ) ) ) ) );
				float _foamHarry25_g93 = temp_output_26_0_g93;
				float2 temp_cast_5 = (speedVar31_g93).xx;
				float2 appendResult5_g93 = (float2(WorldPosition.x , WorldPosition.z));
				float2 worldPosUV51_g93 = appendResult5_g93;
				float2 panner1_g93 = ( 1.0 * _Time.y * temp_cast_5 + ( worldPosUV51_g93 * 0.22 ));
				float3 lerpResult8_g93 = lerp( float3( panner1_g93 ,  0.0 ) , _normals210 , 0.35);
				float4 break77_g93 = ( float4(1,1,1,1) * step( _foamHarry25_g93 , tex2D( _foam, lerpResult8_g93.xy ).r ) );
				float smoothstepResult70_g93 = smoothstep( 0.0 , ( distanceDepth71_g93 + 0.3 ) , ( 1.0 - 0.0 ));
				float4 appendResult79_g93 = (float4(break77_g93.r , break77_g93.g , break77_g93.b , ( ( 1.0 - smoothstepResult70_g93 ) * break77_g93.a )));
				float4 _shoreLines655 = appendResult79_g93;
				float temp_output_11_0_g92 = _RippleCutoff;
				float2 temp_cast_8 = (0.005).xx;
				float3 ase_worldBitangent = IN.ase_texcoord8.xyz;
				float3x3 ase_worldToTangent = float3x3(ase_worldTangent,ase_worldBitangent,ase_worldNormal);
				float3 appendResult8_g92 = (float3(( WorldPosition.x + 100.0 ) , WorldPosition.y , ( WorldPosition.z + 100.0 )));
				float3 triplanar9_g92 = TriplanarSampling9_g92( _GlobalEffectRT, appendResult8_g92, ase_worldNormal, 1.0, temp_cast_8, -50.0, 0 );
				float3 tanTriplanarNormal9_g92 = mul( ase_worldToTangent, triplanar9_g92 );
				float _rt500 = step( temp_output_11_0_g92 , tanTriplanarNormal9_g92.z );
				float4 _combinedLines687 = ( _shoreLines655 + _rt500 );
				float4 lerpResult689 = lerp( ( _lights438 + _colors292 ) , _FoamClayColor , _combinedLines687);
				float4 _endColor892 = lerpResult689;
				
				float4 temp_cast_11 = (0.43).xxxx;
				float4 temp_cast_12 = (0.01).xxxx;
				float2 temp_cast_13 = (( speedVar31_g93 * -0.15 )).xx;
				float2 panner39_g93 = ( 1.0 * _Time.y * temp_cast_13 + ( 0.15 * worldPosUV51_g93 ));
				float4 lerpResult42_g93 = lerp( temp_cast_12 , tex2D( _heightFoam, panner39_g93 ) , ( WorldPosition.y + _HeightFoamH ));
				float4 smoothstepResult45_g93 = smoothstep( float4( 0,0,0,0 ) , temp_cast_11 , lerpResult42_g93);
				float4 _foam259 = smoothstepResult45_g93;
				float4 temp_cast_15 = (_Caustics).xxxx;
				float2 UV22_g73 = ase_screenPosNorm.xy;
				float2 localUnStereo22_g73 = UnStereo( UV22_g73 );
				float2 break64_g72 = localUnStereo22_g73;
				float clampDepth69_g72 = SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy );
				#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g72 = ( 1.0 - clampDepth69_g72 );
				#else
				float staticSwitch38_g72 = clampDepth69_g72;
				#endif
				float3 appendResult39_g72 = (float3(break64_g72.x , break64_g72.y , staticSwitch38_g72));
				float4 appendResult42_g72 = (float4((appendResult39_g72*2.0 + -1.0) , 1.0));
				float4 temp_output_43_0_g72 = mul( unity_CameraInvProjection, appendResult42_g72 );
				float3 temp_output_46_0_g72 = ( (temp_output_43_0_g72).xyz / (temp_output_43_0_g72).w );
				float3 In75_g72 = temp_output_46_0_g72;
				float3 localInvertDepthDirURP75_g72 = InvertDepthDirURP75_g72( In75_g72 );
				float4 appendResult49_g72 = (float4(localInvertDepthDirURP75_g72 , 1.0));
				float2 temp_output_30_0_g76 = (( mul( unity_CameraToWorld, appendResult49_g72 ) * 0.04 )).xz;
				float temp_output_1_0_g76 = 0.05;
				float2 temp_output_15_0_g76 = ( temp_output_30_0_g76 + ( float2( 0.1,0 ) * temp_output_1_0_g76 ) );
				float2 panner32_g76 = ( 1.0 * _Time.y * float2( 0.09,0.06 ) + temp_output_15_0_g76);
				float4 tex2DNode31_g76 = tex2D( _Caust, panner32_g76 );
				float3 appendResult36_g76 = (float3(tex2DNode31_g76.r , tex2DNode31_g76.g , tex2DNode31_g76.b));
				float2 panner35_g76 = ( 1.0 * _Time.y * float2( -0.05,-0.07 ) + temp_output_15_0_g76);
				float4 tex2DNode34_g76 = tex2D( _Caust, panner35_g76 );
				float3 appendResult39_g76 = (float3(tex2DNode34_g76.r , tex2DNode34_g76.g , tex2DNode34_g76.b));
				float2 temp_output_16_0_g76 = ( temp_output_30_0_g76 + ( float2( 0,0.1 ) * temp_output_1_0_g76 ) );
				float2 panner46_g76 = ( 1.0 * _Time.y * float2( 0.09,0.06 ) + temp_output_16_0_g76);
				float4 tex2DNode45_g76 = tex2D( _Caust, panner46_g76 );
				float3 appendResult47_g76 = (float3(tex2DNode45_g76.r , tex2DNode45_g76.g , tex2DNode45_g76.b));
				float2 panner49_g76 = ( 1.0 * _Time.y * float2( -0.05,-0.07 ) + temp_output_16_0_g76);
				float4 tex2DNode50_g76 = tex2D( _Caust, panner49_g76 );
				float3 appendResult51_g76 = (float3(tex2DNode50_g76.r , tex2DNode50_g76.g , tex2DNode50_g76.b));
				float2 temp_output_17_0_g76 = ( temp_output_30_0_g76 + ( float2( -0.1,-0.1 ) * temp_output_1_0_g76 ) );
				float2 panner54_g76 = ( 1.0 * _Time.y * float2( 0.09,0.06 ) + temp_output_17_0_g76);
				float4 tex2DNode53_g76 = tex2D( _Caust, panner54_g76 );
				float3 appendResult55_g76 = (float3(tex2DNode53_g76.r , tex2DNode53_g76.g , tex2DNode53_g76.b));
				float2 panner57_g76 = ( 1.0 * _Time.y * float2( -0.05,-0.07 ) + temp_output_17_0_g76);
				float4 tex2DNode58_g76 = tex2D( _Caust, panner57_g76 );
				float3 appendResult59_g76 = (float3(tex2DNode58_g76.r , tex2DNode58_g76.g , tex2DNode58_g76.b));
				float3 appendResult44_g76 = (float3((min( appendResult36_g76 , appendResult39_g76 )).x , (min( appendResult47_g76 , appendResult51_g76 )).y , (min( appendResult55_g76 , appendResult59_g76 )).z));
				float4 appendResult8_g76 = (float4(appendResult44_g76 , 1.0));
				float4 smoothstepResult610 = smoothstep( float4( 0,0,0,0 ) , temp_cast_15 , appendResult8_g76);
				float4 temp_output_616_0 = ( saturate( smoothstepResult610 ) * _depthMask614 );
				float4 _caustics626 = temp_output_616_0;
				float4 blendOpSrc627 = ( _colors292 + _foam259 );
				float4 blendOpDest627 = _caustics626;
				float4 lerpResult692 = lerp( ( saturate( ( 1.0 - ( 1.0 - blendOpSrc627 ) * ( 1.0 - blendOpDest627 ) ) )) , float4( 0,0,0,0 ) , _combinedLines687);
				float4 _emission894 = lerpResult692;
				

				float3 BaseColor = _endColor892.rgb;
				float3 Emission = _emission894.xyz;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = BaseColor;
				metaInput.Emission = Emission;
				#ifdef EDITOR_VISUALIZATION
					metaInput.VizUV = IN.VizUV.xy;
					metaInput.LightCoord = IN.LightCoord;
				#endif

				return UnityMetaFragment(metaInput);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM

			#define ASE_TESSELLATION 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_DISTANCE_TESSELLATION
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120110
			#define REQUIRE_OPAQUE_TEXTURE 1
			#define REQUIRE_DEPTH_TEXTURE 1


			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_2D

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_POSITION


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_tangent : TANGENT;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Horizon;
			float4 _ShallowColor;
			float4 _DeepColor;
			float4 _SpecularColor;
			float4 _FingerprintNormal_TexelSize;
			float4 _FoamClayColor;
			float4 _WaterNormal_ST;
			float _FingerprintStrength;
			float _Foam;
			float _NoiseSmoothness;
			float _ClayNormal;
			float _NoiseStrength;
			float _Float5;
			float _RippleCutoff;
			float _Speed;
			float _NoiseScale;
			float _Scale;
			float _WaveLength;
			float _HeightFoamH;
			float _WaterDepth;
			float _RefractionDistortion;
			float _LightingHardness;
			float _LightingSmoothness;
			float _NormalIntensity;
			float _NormalScale;
			float _Steepness;
			float _WaveSpeed;
			float _wavesZ;
			float _HorizonDistance;
			float _Caustics;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _FingerprintNormal;
			sampler2D _Roughness;
			sampler2D _GlobalEffectRT;
			sampler2D _WaterNormal;
			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _foam;


			float3 TangentToWorld13_g21( float3 NormalTS, float3x3 TBN )
			{
				float3 NormalWS = TransformTangentToWorld(NormalTS, TBN);
				NormalWS = NormalizeNormalPerPixel(NormalWS);
				return NormalWS;
			}
			
			float3 AdditionalLightsSpecular10x12x( float3 WorldPosition, float3 WorldNormal, float3 WorldView, float3 SpecColor, float Smoothness )
			{
				float3 Color = 0;
				#ifdef _ADDITIONAL_LIGHTS
					Smoothness = exp2(10 * Smoothness + 1);
					uint lightCount = GetAdditionalLightsCount();
					LIGHT_LOOP_BEGIN( lightCount )
						Light light = GetAdditionalLight(lightIndex, WorldPosition);
						half3 AttLightColor = light.color *(light.distanceAttenuation * light.shadowAttenuation);
						Color += LightingSpecular(AttLightColor, light.direction, WorldNormal, WorldView, half4(SpecColor, 0), Smoothness);	
					LIGHT_LOOP_END
				#endif
				return Color;
			}
			
			inline float3 TriplanarSampling9_g92( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				xNorm.xyz  = half3( UnpackNormalScale( xNorm , 1.0 ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
				yNorm.xyz  = half3( UnpackNormalScale( yNorm , 1.0 ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
				zNorm.xyz  = half3( UnpackNormalScale( zNorm , 1.0 ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
				return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float4 temp_output_5_0_g79 = float4(0.02,-0.34,0.16,2.23);
				float2 appendResult19_g80 = (float2(cos( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g80 = normalize( appendResult19_g80 );
				float2 d26_g80 = normalizeResult15_g80;
				float temp_output_3_0_g79 = _WaveLength;
				float k25_g80 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float _0waterMover900 = _wavesZ;
				float3 appendResult758 = (float3(ase_worldPos.x , ase_worldPos.y , ( ase_worldPos.z + _0waterMover900 )));
				float3 temp_output_1_0_g79 = appendResult758;
				float dotResult29_g80 = dot( d26_g80 , (temp_output_1_0_g79).xz );
				float temp_output_4_0_g79 = _WaveSpeed;
				float mulTime33_g80 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g80 = ( k25_g80 * ( dotResult29_g80 - mulTime33_g80 ) );
				float temp_output_2_0_g79 = _Steepness;
				float temp_output_3_0_g80 = temp_output_2_0_g79;
				float a37_g80 = ( temp_output_3_0_g80 / k25_g80 );
				float temp_output_91_0_g80 = ( cos( f34_g80 ) * a37_g80 );
				float3 appendResult86_g80 = (float3(( (d26_g80).x * temp_output_91_0_g80 ) , ( a37_g80 * sin( f34_g80 ) ) , ( temp_output_91_0_g80 * (d26_g80).y )));
				float2 appendResult19_g81 = (float2(cos( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g81 = normalize( appendResult19_g81 );
				float2 d26_g81 = normalizeResult15_g81;
				float k25_g81 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g81 = dot( d26_g81 , (temp_output_1_0_g79).xz );
				float mulTime33_g81 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g81 = ( k25_g81 * ( dotResult29_g81 - mulTime33_g81 ) );
				float temp_output_3_0_g81 = temp_output_2_0_g79;
				float a37_g81 = ( temp_output_3_0_g81 / k25_g81 );
				float temp_output_91_0_g81 = ( cos( f34_g81 ) * a37_g81 );
				float3 appendResult86_g81 = (float3(( (d26_g81).x * temp_output_91_0_g81 ) , ( a37_g81 * sin( f34_g81 ) ) , ( temp_output_91_0_g81 * (d26_g81).y )));
				float2 appendResult19_g83 = (float2(cos( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g83 = normalize( appendResult19_g83 );
				float2 d26_g83 = normalizeResult15_g83;
				float k25_g83 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g83 = dot( d26_g83 , (temp_output_1_0_g79).xz );
				float mulTime33_g83 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g83 = ( k25_g83 * ( dotResult29_g83 - mulTime33_g83 ) );
				float temp_output_3_0_g83 = temp_output_2_0_g79;
				float a37_g83 = ( temp_output_3_0_g83 / k25_g83 );
				float temp_output_91_0_g83 = ( cos( f34_g83 ) * a37_g83 );
				float3 appendResult86_g83 = (float3(( (d26_g83).x * temp_output_91_0_g83 ) , ( a37_g83 * sin( f34_g83 ) ) , ( temp_output_91_0_g83 * (d26_g83).y )));
				float2 appendResult19_g82 = (float2(cos( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g82 = normalize( appendResult19_g82 );
				float2 d26_g82 = normalizeResult15_g82;
				float k25_g82 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g82 = dot( d26_g82 , (temp_output_1_0_g79).xz );
				float mulTime33_g82 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g82 = ( k25_g82 * ( dotResult29_g82 - mulTime33_g82 ) );
				float temp_output_3_0_g82 = temp_output_2_0_g79;
				float a37_g82 = ( temp_output_3_0_g82 / k25_g82 );
				float temp_output_91_0_g82 = ( cos( f34_g82 ) * a37_g82 );
				float3 appendResult86_g82 = (float3(( (d26_g82).x * temp_output_91_0_g82 ) , ( a37_g82 * sin( f34_g82 ) ) , ( temp_output_91_0_g82 * (d26_g82).y )));
				float3 worldToObj485 = mul( GetWorldToObjectMatrix(), float4( ( ase_worldPos + ( ( appendResult86_g80 + appendResult86_g81 ) + ( appendResult86_g83 + appendResult86_g82 ) ) ), 1 ) ).xyz;
				float3 waveDisplacement493 = worldToObj485;
				
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord3.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord4.xyz = ase_worldNormal;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord2.z = eyeDepth;
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord5 = screenPos;
				float ase_vertexTangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord6.xyz = ase_worldBitangent;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				o.ase_tangent = v.ase_tangent;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				o.ase_texcoord6.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = waveDisplacement493;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_tangent = v.ase_tangent;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float _0waterMover900 = _wavesZ;
				float2 appendResult903 = (float2(0.0 , -_0waterMover900));
				float2 uv_WaterNormal = IN.ase_texcoord2.xy * _WaterNormal_ST.xy + _WaterNormal_ST.zw;
				float2 temp_output_907_0 = ( ( appendResult903 * 0.05 ) + ( uv_WaterNormal * _NormalScale ) );
				float2 panner22 = ( 1.0 * _Time.y * float2( -0.03,0 ) + temp_output_907_0);
				float3 unpack23 = UnpackNormalScale( tex2D( _WaterNormal, panner22 ), _NormalIntensity );
				unpack23.z = lerp( 1, unpack23.z, saturate(_NormalIntensity) );
				float2 panner19 = ( 1.0 * _Time.y * float2( 0.04,0.04 ) + temp_output_907_0);
				float3 unpack17 = UnpackNormalScale( tex2D( _WaterNormal, panner19 ), _NormalIntensity );
				unpack17.z = lerp( 1, unpack17.z, saturate(_NormalIntensity) );
				float3 _normals210 = BlendNormal( unpack23 , unpack17 );
				float3 NormalTS13_g21 = _normals210;
				float3 ase_worldTangent = IN.ase_texcoord3.xyz;
				float3 ase_worldNormal = IN.ase_texcoord4.xyz;
				float3 Binormal5_g21 = ( ( IN.ase_tangent.w > 0.0 ? 1.0 : -1.0 ) * cross( ase_worldNormal , ase_worldTangent ) );
				float3x3 TBN1_g21 = float3x3(ase_worldTangent, Binormal5_g21, ase_worldNormal);
				float3x3 TBN13_g21 = TBN1_g21;
				float3 localTangentToWorld13_g21 = TangentToWorld13_g21( NormalTS13_g21 , TBN13_g21 );
				float3 temp_output_430_0 = localTangentToWorld13_g21;
				float dotResult383 = dot( SafeNormalize(_MainLightPosition.xyz) , temp_output_430_0 );
				float temp_output_385_0 = pow( saturate( dotResult383 ) , exp2( ( ( _LightingSmoothness * 10.0 ) + 1.0 ) ) );
				float lerpResult357 = lerp( temp_output_385_0 , step( 0.5 , temp_output_385_0 ) , _LightingHardness);
				float3 worldPosValue44_g22 = WorldPosition;
				float3 WorldPosition13_g22 = worldPosValue44_g22;
				float3 worldNormalValue50_g22 = temp_output_430_0;
				float3 WorldNormal13_g22 = worldNormalValue50_g22;
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = SafeNormalize( ase_worldViewDir );
				float3 temp_output_15_0_g22 = ase_worldViewDir;
				float3 WorldView13_g22 = temp_output_15_0_g22;
				float3 temp_output_14_0_g22 = _SpecularColor.rgb;
				float3 SpecColor13_g22 = temp_output_14_0_g22;
				float temp_output_18_0_g22 = _LightingSmoothness;
				float Smoothness13_g22 = temp_output_18_0_g22;
				float3 localAdditionalLightsSpecular10x12x13_g22 = AdditionalLightsSpecular10x12x( WorldPosition13_g22 , WorldNormal13_g22 , WorldView13_g22 , SpecColor13_g22 , Smoothness13_g22 );
				float3 specularResult61_g22 = localAdditionalLightsSpecular10x12x13_g22;
				float4 _lights438 = ( ( ( lerpResult357 * _SpecularColor ) * _SpecularColor.a ) + float4( specularResult61_g22 , 0.0 ) );
				float eyeDepth = IN.ase_texcoord2.z;
				float4 screenPos = IN.ase_texcoord5;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float eyeDepth28_g78 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float2 temp_output_20_0_g78 = ( (_normals210).xy * ( _RefractionDistortion / max( eyeDepth , 0.1 ) ) * saturate( ( eyeDepth28_g78 - eyeDepth ) ) );
				float eyeDepth2_g78 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ( float4( temp_output_20_0_g78, 0.0 , 0.0 ) + ase_screenPosNorm ).xy ),_ZBufferParams);
				float2 temp_output_32_0_g78 = (( float4( ( temp_output_20_0_g78 * saturate( ( eyeDepth2_g78 - eyeDepth ) ) ), 0.0 , 0.0 ) + ase_screenPosNorm )).xy;
				float2 temp_output_246_38 = temp_output_32_0_g78;
				float4 fetchOpaqueVal65 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( temp_output_246_38 ), 1.0 );
				float4 _refraction254 = fetchOpaqueVal65;
				float2 _refractUV290 = temp_output_246_38;
				float eyeDepth2_g77 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( float4( _refractUV290, 0.0 , 0.0 ).xy ),_ZBufferParams);
				float depthToLinear6_g77 = LinearEyeDepth(ase_screenPosNorm.z,_ZBufferParams);
				float _depthMask614 = ( 1.0 - saturate( ( ( abs( ( ( eyeDepth2_g77 - depthToLinear6_g77 ) / _WaterDepth ) ) * 0.07 ) + -0.05 ) ) );
				float4 lerpResult13 = lerp( _DeepColor , _ShallowColor , _depthMask614);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float fresnelNdotV316 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode316 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV316, _HorizonDistance ) );
				float4 lerpResult320 = lerp( ( _refraction254 * lerpResult13 ) , _Horizon , fresnelNode316);
				float4 _colors292 = lerpResult320;
				float screenDepth71_g93 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth71_g93 = saturate( abs( ( screenDepth71_g93 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( ( _Foam * 2.0 ) ) ) );
				float _foamDiff63_g93 = ( distanceDepth71_g93 * 11.25 );
				float _speedVar231 = _Speed;
				float speedVar31_g93 = _speedVar231;
				float mulTime19_g93 = _TimeParameters.x * speedVar31_g93;
				float temp_output_26_0_g93 = ( _foamDiff63_g93 - saturate( sin( ( ( _foamDiff63_g93 - mulTime19_g93 ) * ( 4.0 * PI ) ) ) ) );
				float _foamHarry25_g93 = temp_output_26_0_g93;
				float2 temp_cast_5 = (speedVar31_g93).xx;
				float2 appendResult5_g93 = (float2(WorldPosition.x , WorldPosition.z));
				float2 worldPosUV51_g93 = appendResult5_g93;
				float2 panner1_g93 = ( 1.0 * _Time.y * temp_cast_5 + ( worldPosUV51_g93 * 0.22 ));
				float3 lerpResult8_g93 = lerp( float3( panner1_g93 ,  0.0 ) , _normals210 , 0.35);
				float4 break77_g93 = ( float4(1,1,1,1) * step( _foamHarry25_g93 , tex2D( _foam, lerpResult8_g93.xy ).r ) );
				float smoothstepResult70_g93 = smoothstep( 0.0 , ( distanceDepth71_g93 + 0.3 ) , ( 1.0 - 0.0 ));
				float4 appendResult79_g93 = (float4(break77_g93.r , break77_g93.g , break77_g93.b , ( ( 1.0 - smoothstepResult70_g93 ) * break77_g93.a )));
				float4 _shoreLines655 = appendResult79_g93;
				float temp_output_11_0_g92 = _RippleCutoff;
				float2 temp_cast_8 = (0.005).xx;
				float3 ase_worldBitangent = IN.ase_texcoord6.xyz;
				float3x3 ase_worldToTangent = float3x3(ase_worldTangent,ase_worldBitangent,ase_worldNormal);
				float3 appendResult8_g92 = (float3(( WorldPosition.x + 100.0 ) , WorldPosition.y , ( WorldPosition.z + 100.0 )));
				float3 triplanar9_g92 = TriplanarSampling9_g92( _GlobalEffectRT, appendResult8_g92, ase_worldNormal, 1.0, temp_cast_8, -50.0, 0 );
				float3 tanTriplanarNormal9_g92 = mul( ase_worldToTangent, triplanar9_g92 );
				float _rt500 = step( temp_output_11_0_g92 , tanTriplanarNormal9_g92.z );
				float4 _combinedLines687 = ( _shoreLines655 + _rt500 );
				float4 lerpResult689 = lerp( ( _lights438 + _colors292 ) , _FoamClayColor , _combinedLines687);
				float4 _endColor892 = lerpResult689;
				

				float3 BaseColor = _endColor892.rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				half4 color = half4(BaseColor, Alpha );

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				return color;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthNormals"
			Tags { "LightMode"="DepthNormalsOnly" }

			ZWrite On
			Blend One Zero
			ZTest LEqual
			ZWrite On

			HLSLPROGRAM

			#pragma multi_compile_instancing
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_TESSELLATION 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_DISTANCE_TESSELLATION
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120110
			#define REQUIRE_DEPTH_TEXTURE 1


			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_TANGENT
			#define ASE_NEEDS_FRAG_SCREEN_POSITION


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 clipPos : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				float3 worldNormal : TEXCOORD1;
				float4 worldTangent : TEXCOORD2;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD3;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD4;
				#endif
				float3 ase_normal : NORMAL;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Horizon;
			float4 _ShallowColor;
			float4 _DeepColor;
			float4 _SpecularColor;
			float4 _FingerprintNormal_TexelSize;
			float4 _FoamClayColor;
			float4 _WaterNormal_ST;
			float _FingerprintStrength;
			float _Foam;
			float _NoiseSmoothness;
			float _ClayNormal;
			float _NoiseStrength;
			float _Float5;
			float _RippleCutoff;
			float _Speed;
			float _NoiseScale;
			float _Scale;
			float _WaveLength;
			float _HeightFoamH;
			float _WaterDepth;
			float _RefractionDistortion;
			float _LightingHardness;
			float _LightingSmoothness;
			float _NormalIntensity;
			float _NormalScale;
			float _Steepness;
			float _WaveSpeed;
			float _wavesZ;
			float _HorizonDistance;
			float _Caustics;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _FingerprintNormal;
			sampler2D _Roughness;
			sampler2D _GlobalEffectRT;
			sampler2D _WaterNormal;
			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _foam;


			real3 ASESafeNormalize(float3 inVec)
			{
				real dp3 = max(FLT_MIN, dot(inVec, inVec));
				return inVec* rsqrt( dp3);
			}
			
			inline float3 TriplanarSampling9_g92( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				xNorm.xyz  = half3( UnpackNormalScale( xNorm , 1.0 ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
				yNorm.xyz  = half3( UnpackNormalScale( yNorm , 1.0 ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
				zNorm.xyz  = half3( UnpackNormalScale( zNorm , 1.0 ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
				return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
			}
			
			float3 PerturbNormal107_g53( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			float3 CombineSamplesSharp128_g70( float S0, float S1, float S2, float Strength )
			{
				{
				    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
				    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
				    return normalize( cross( va, vb ) );
				}
			}
			
					float2 voronoihash8_g69( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi8_g69( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash8_g69( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 //		if( d<F1 ) {
						 //			F2 = F1;
						 			float h = smoothstep(0.0, 1.0, 0.5 + 0.5 * (F1 - d) / smoothness); F1 = lerp(F1, d, h) - smoothness * h * (1.0 - h);mg = g; mr = r; id = o;
						 //		} else if( d<F2 ) {
						 //			F2 = d;
						
						 //		}
						 	}
						}
						return F1;
					}
			
			float3 PerturbNormal107_g71( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float4 temp_output_5_0_g79 = float4(0.02,-0.34,0.16,2.23);
				float2 appendResult19_g80 = (float2(cos( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g80 = normalize( appendResult19_g80 );
				float2 d26_g80 = normalizeResult15_g80;
				float temp_output_3_0_g79 = _WaveLength;
				float k25_g80 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float _0waterMover900 = _wavesZ;
				float3 appendResult758 = (float3(ase_worldPos.x , ase_worldPos.y , ( ase_worldPos.z + _0waterMover900 )));
				float3 temp_output_1_0_g79 = appendResult758;
				float dotResult29_g80 = dot( d26_g80 , (temp_output_1_0_g79).xz );
				float temp_output_4_0_g79 = _WaveSpeed;
				float mulTime33_g80 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g80 = ( k25_g80 * ( dotResult29_g80 - mulTime33_g80 ) );
				float temp_output_2_0_g79 = _Steepness;
				float temp_output_3_0_g80 = temp_output_2_0_g79;
				float a37_g80 = ( temp_output_3_0_g80 / k25_g80 );
				float temp_output_91_0_g80 = ( cos( f34_g80 ) * a37_g80 );
				float3 appendResult86_g80 = (float3(( (d26_g80).x * temp_output_91_0_g80 ) , ( a37_g80 * sin( f34_g80 ) ) , ( temp_output_91_0_g80 * (d26_g80).y )));
				float2 appendResult19_g81 = (float2(cos( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g81 = normalize( appendResult19_g81 );
				float2 d26_g81 = normalizeResult15_g81;
				float k25_g81 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g81 = dot( d26_g81 , (temp_output_1_0_g79).xz );
				float mulTime33_g81 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g81 = ( k25_g81 * ( dotResult29_g81 - mulTime33_g81 ) );
				float temp_output_3_0_g81 = temp_output_2_0_g79;
				float a37_g81 = ( temp_output_3_0_g81 / k25_g81 );
				float temp_output_91_0_g81 = ( cos( f34_g81 ) * a37_g81 );
				float3 appendResult86_g81 = (float3(( (d26_g81).x * temp_output_91_0_g81 ) , ( a37_g81 * sin( f34_g81 ) ) , ( temp_output_91_0_g81 * (d26_g81).y )));
				float2 appendResult19_g83 = (float2(cos( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g83 = normalize( appendResult19_g83 );
				float2 d26_g83 = normalizeResult15_g83;
				float k25_g83 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g83 = dot( d26_g83 , (temp_output_1_0_g79).xz );
				float mulTime33_g83 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g83 = ( k25_g83 * ( dotResult29_g83 - mulTime33_g83 ) );
				float temp_output_3_0_g83 = temp_output_2_0_g79;
				float a37_g83 = ( temp_output_3_0_g83 / k25_g83 );
				float temp_output_91_0_g83 = ( cos( f34_g83 ) * a37_g83 );
				float3 appendResult86_g83 = (float3(( (d26_g83).x * temp_output_91_0_g83 ) , ( a37_g83 * sin( f34_g83 ) ) , ( temp_output_91_0_g83 * (d26_g83).y )));
				float2 appendResult19_g82 = (float2(cos( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g82 = normalize( appendResult19_g82 );
				float2 d26_g82 = normalizeResult15_g82;
				float k25_g82 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g82 = dot( d26_g82 , (temp_output_1_0_g79).xz );
				float mulTime33_g82 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g82 = ( k25_g82 * ( dotResult29_g82 - mulTime33_g82 ) );
				float temp_output_3_0_g82 = temp_output_2_0_g79;
				float a37_g82 = ( temp_output_3_0_g82 / k25_g82 );
				float temp_output_91_0_g82 = ( cos( f34_g82 ) * a37_g82 );
				float3 appendResult86_g82 = (float3(( (d26_g82).x * temp_output_91_0_g82 ) , ( a37_g82 * sin( f34_g82 ) ) , ( temp_output_91_0_g82 * (d26_g82).y )));
				float3 worldToObj485 = mul( GetWorldToObjectMatrix(), float4( ( ase_worldPos + ( ( appendResult86_g80 + appendResult86_g81 ) + ( appendResult86_g83 + appendResult86_g82 ) ) ), 1 ) ).xyz;
				float3 waveDisplacement493 = worldToObj485;
				
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				float ase_vertexTangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord5.xyz = ase_worldBitangent;
				
				o.ase_normal = v.ase_normal;
				o.ase_texcoord6.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord5.w = 0;
				o.ase_texcoord6.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = waveDisplacement493;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 normalWS = TransformObjectToWorldNormal( v.ase_normal );
				float4 tangentWS = float4(TransformObjectToWorldDir( v.ase_tangent.xyz), v.ase_tangent.w);
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				o.worldNormal = normalWS;
				o.worldTangent = tangentWS;

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;
				o.clipPosV = positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(	VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				float3 WorldNormal = IN.worldNormal;
				float4 WorldTangent = IN.worldTangent;

				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float3 _tangent = float3(1,0,0);
				float4 temp_output_5_0_g79 = float4(0.02,-0.34,0.16,2.23);
				float2 appendResult19_g80 = (float2(cos( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g80 = normalize( appendResult19_g80 );
				float2 d26_g80 = normalizeResult15_g80;
				float temp_output_47_0_g80 = (d26_g80).x;
				float temp_output_2_0_g79 = _Steepness;
				float temp_output_3_0_g80 = temp_output_2_0_g79;
				float temp_output_3_0_g79 = _WaveLength;
				float k25_g80 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float _0waterMover900 = _wavesZ;
				float3 appendResult758 = (float3(WorldPosition.x , WorldPosition.y , ( WorldPosition.z + _0waterMover900 )));
				float3 temp_output_1_0_g79 = appendResult758;
				float dotResult29_g80 = dot( d26_g80 , (temp_output_1_0_g79).xz );
				float temp_output_4_0_g79 = _WaveSpeed;
				float mulTime33_g80 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g80 = ( k25_g80 * ( dotResult29_g80 - mulTime33_g80 ) );
				float temp_output_53_0_g80 = ( temp_output_3_0_g80 * sin( f34_g80 ) );
				float3 appendResult56_g80 = (float3(( ( temp_output_47_0_g80 * -temp_output_47_0_g80 ) * temp_output_53_0_g80 ) , ( ( cos( f34_g80 ) * temp_output_3_0_g80 ) * temp_output_47_0_g80 ) , ( temp_output_53_0_g80 * ( -temp_output_47_0_g80 * (d26_g80).y ) )));
				float3 tangent45_g80 = ( _tangent + appendResult56_g80 );
				float2 appendResult19_g81 = (float2(cos( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g81 = normalize( appendResult19_g81 );
				float2 d26_g81 = normalizeResult15_g81;
				float temp_output_47_0_g81 = (d26_g81).x;
				float temp_output_3_0_g81 = temp_output_2_0_g79;
				float k25_g81 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g81 = dot( d26_g81 , (temp_output_1_0_g79).xz );
				float mulTime33_g81 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g81 = ( k25_g81 * ( dotResult29_g81 - mulTime33_g81 ) );
				float temp_output_53_0_g81 = ( temp_output_3_0_g81 * sin( f34_g81 ) );
				float3 appendResult56_g81 = (float3(( ( temp_output_47_0_g81 * -temp_output_47_0_g81 ) * temp_output_53_0_g81 ) , ( ( cos( f34_g81 ) * temp_output_3_0_g81 ) * temp_output_47_0_g81 ) , ( temp_output_53_0_g81 * ( -temp_output_47_0_g81 * (d26_g81).y ) )));
				float3 tangent45_g81 = ( _tangent + appendResult56_g81 );
				float2 appendResult19_g83 = (float2(cos( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g83 = normalize( appendResult19_g83 );
				float2 d26_g83 = normalizeResult15_g83;
				float temp_output_47_0_g83 = (d26_g83).x;
				float temp_output_3_0_g83 = temp_output_2_0_g79;
				float k25_g83 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g83 = dot( d26_g83 , (temp_output_1_0_g79).xz );
				float mulTime33_g83 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g83 = ( k25_g83 * ( dotResult29_g83 - mulTime33_g83 ) );
				float temp_output_53_0_g83 = ( temp_output_3_0_g83 * sin( f34_g83 ) );
				float3 appendResult56_g83 = (float3(( ( temp_output_47_0_g83 * -temp_output_47_0_g83 ) * temp_output_53_0_g83 ) , ( ( cos( f34_g83 ) * temp_output_3_0_g83 ) * temp_output_47_0_g83 ) , ( temp_output_53_0_g83 * ( -temp_output_47_0_g83 * (d26_g83).y ) )));
				float3 tangent45_g83 = ( _tangent + appendResult56_g83 );
				float2 appendResult19_g82 = (float2(cos( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g82 = normalize( appendResult19_g82 );
				float2 d26_g82 = normalizeResult15_g82;
				float temp_output_47_0_g82 = (d26_g82).x;
				float temp_output_3_0_g82 = temp_output_2_0_g79;
				float k25_g82 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g82 = dot( d26_g82 , (temp_output_1_0_g79).xz );
				float mulTime33_g82 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g82 = ( k25_g82 * ( dotResult29_g82 - mulTime33_g82 ) );
				float temp_output_53_0_g82 = ( temp_output_3_0_g82 * sin( f34_g82 ) );
				float3 appendResult56_g82 = (float3(( ( temp_output_47_0_g82 * -temp_output_47_0_g82 ) * temp_output_53_0_g82 ) , ( ( cos( f34_g82 ) * temp_output_3_0_g82 ) * temp_output_47_0_g82 ) , ( temp_output_53_0_g82 * ( -temp_output_47_0_g82 * (d26_g82).y ) )));
				float3 tangent45_g82 = ( _tangent + appendResult56_g82 );
				float3 _binormal = float3(0,0,1);
				float temp_output_67_0_g80 = (d26_g80).y;
				float temp_output_66_0_g80 = ( temp_output_3_0_g80 * sin( f34_g80 ) );
				float3 appendResult72_g80 = (float3(( ( temp_output_67_0_g80 * -temp_output_67_0_g80 ) * temp_output_66_0_g80 ) , ( ( cos( f34_g80 ) * temp_output_3_0_g80 ) * temp_output_67_0_g80 ) , ( temp_output_66_0_g80 * ( -temp_output_67_0_g80 * temp_output_67_0_g80 ) )));
				float3 binormal79_g80 = ( _binormal + appendResult72_g80 );
				float temp_output_67_0_g81 = (d26_g81).y;
				float temp_output_66_0_g81 = ( temp_output_3_0_g81 * sin( f34_g81 ) );
				float3 appendResult72_g81 = (float3(( ( temp_output_67_0_g81 * -temp_output_67_0_g81 ) * temp_output_66_0_g81 ) , ( ( cos( f34_g81 ) * temp_output_3_0_g81 ) * temp_output_67_0_g81 ) , ( temp_output_66_0_g81 * ( -temp_output_67_0_g81 * temp_output_67_0_g81 ) )));
				float3 binormal79_g81 = ( _binormal + appendResult72_g81 );
				float temp_output_67_0_g83 = (d26_g83).y;
				float temp_output_66_0_g83 = ( temp_output_3_0_g83 * sin( f34_g83 ) );
				float3 appendResult72_g83 = (float3(( ( temp_output_67_0_g83 * -temp_output_67_0_g83 ) * temp_output_66_0_g83 ) , ( ( cos( f34_g83 ) * temp_output_3_0_g83 ) * temp_output_67_0_g83 ) , ( temp_output_66_0_g83 * ( -temp_output_67_0_g83 * temp_output_67_0_g83 ) )));
				float3 binormal79_g83 = ( _binormal + appendResult72_g83 );
				float temp_output_67_0_g82 = (d26_g82).y;
				float temp_output_66_0_g82 = ( temp_output_3_0_g82 * sin( f34_g82 ) );
				float3 appendResult72_g82 = (float3(( ( temp_output_67_0_g82 * -temp_output_67_0_g82 ) * temp_output_66_0_g82 ) , ( ( cos( f34_g82 ) * temp_output_3_0_g82 ) * temp_output_67_0_g82 ) , ( temp_output_66_0_g82 * ( -temp_output_67_0_g82 * temp_output_67_0_g82 ) )));
				float3 binormal79_g82 = ( _binormal + appendResult72_g82 );
				float3 normalizeResult20_g79 = normalize( cross( ( tangent45_g80 + tangent45_g81 + tangent45_g83 + tangent45_g82 ) , ( binormal79_g80 + binormal79_g81 + binormal79_g83 + binormal79_g82 ) ) );
				float3 worldToObjDir773 = ASESafeNormalize( mul( GetWorldToObjectMatrix(), float4( normalizeResult20_g79, 0 ) ).xyz );
				float3 normalizeResult844 = ASESafeNormalize( ( worldToObjDir773 + IN.ase_normal ) );
				float3 ase_worldBitangent = IN.ase_texcoord5.xyz;
				float3x3 ase_worldToTangent = float3x3(WorldTangent.xyz,ase_worldBitangent,WorldNormal);
				float3 objectToTangentDir847 = normalize( mul( ase_worldToTangent, mul( GetObjectToWorldMatrix(), float4( normalizeResult844, 0 ) ).xyz) );
				float3 vertexNormal841 = objectToTangentDir847;
				float2 temp_cast_0 = (0.005).xx;
				float3 appendResult8_g92 = (float3(( WorldPosition.x + 100.0 ) , WorldPosition.y , ( WorldPosition.z + 100.0 )));
				float3 triplanar9_g92 = TriplanarSampling9_g92( _GlobalEffectRT, appendResult8_g92, WorldNormal, 1.0, temp_cast_0, -50.0, 0 );
				float3 tanTriplanarNormal9_g92 = mul( ase_worldToTangent, triplanar9_g92 );
				float3 _rTNormal551 = tanTriplanarNormal9_g92;
				float2 appendResult903 = (float2(0.0 , -_0waterMover900));
				float2 uv_WaterNormal = IN.ase_texcoord6.xy * _WaterNormal_ST.xy + _WaterNormal_ST.zw;
				float2 temp_output_907_0 = ( ( appendResult903 * 0.05 ) + ( uv_WaterNormal * _NormalScale ) );
				float2 panner22 = ( 1.0 * _Time.y * float2( -0.03,0 ) + temp_output_907_0);
				float3 unpack23 = UnpackNormalScale( tex2D( _WaterNormal, panner22 ), _NormalIntensity );
				unpack23.z = lerp( 1, unpack23.z, saturate(_NormalIntensity) );
				float2 panner19 = ( 1.0 * _Time.y * float2( 0.04,0.04 ) + temp_output_907_0);
				float3 unpack17 = UnpackNormalScale( tex2D( _WaterNormal, panner19 ), _NormalIntensity );
				unpack17.z = lerp( 1, unpack17.z, saturate(_NormalIntensity) );
				float3 _normals210 = BlendNormal( unpack23 , unpack17 );
				float3 lerpResult561 = lerp( _rTNormal551 , _normals210 , 50.0);
				float3 _combinedNormalsRT660 = lerpResult561;
				float4 color667 = IsGammaSpace() ? float4(0,0,1,0) : float4(0,0,1,0);
				float4 ase_screenPosNorm = ScreenPos / ScreenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth71_g93 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth71_g93 = saturate( abs( ( screenDepth71_g93 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( ( _Foam * 2.0 ) ) ) );
				float _foamDiff63_g93 = ( distanceDepth71_g93 * 11.25 );
				float _speedVar231 = _Speed;
				float speedVar31_g93 = _speedVar231;
				float mulTime19_g93 = _TimeParameters.x * speedVar31_g93;
				float temp_output_26_0_g93 = ( _foamDiff63_g93 - saturate( sin( ( ( _foamDiff63_g93 - mulTime19_g93 ) * ( 4.0 * PI ) ) ) ) );
				float _foamHarry25_g93 = temp_output_26_0_g93;
				float2 temp_cast_2 = (speedVar31_g93).xx;
				float2 appendResult5_g93 = (float2(WorldPosition.x , WorldPosition.z));
				float2 worldPosUV51_g93 = appendResult5_g93;
				float2 panner1_g93 = ( 1.0 * _Time.y * temp_cast_2 + ( worldPosUV51_g93 * 0.22 ));
				float3 lerpResult8_g93 = lerp( float3( panner1_g93 ,  0.0 ) , _normals210 , 0.35);
				float4 break77_g93 = ( float4(1,1,1,1) * step( _foamHarry25_g93 , tex2D( _foam, lerpResult8_g93.xy ).r ) );
				float smoothstepResult70_g93 = smoothstep( 0.0 , ( distanceDepth71_g93 + 0.3 ) , ( 1.0 - 0.0 ));
				float4 appendResult79_g93 = (float4(break77_g93.r , break77_g93.g , break77_g93.b , ( ( 1.0 - smoothstepResult70_g93 ) * break77_g93.a )));
				float4 _shoreLines655 = appendResult79_g93;
				float temp_output_11_0_g92 = _RippleCutoff;
				float _rt500 = step( temp_output_11_0_g92 , tanTriplanarNormal9_g92.b );
				float4 _combinedLines687 = ( _shoreLines655 + _rt500 );
				float4 lerpResult664 = lerp( float4( _combinedNormalsRT660 , 0.0 ) , color667 , _combinedLines687);
				float3 surf_pos107_g53 = WorldPosition;
				float3 surf_norm107_g53 = WorldNormal;
				float smoothstepResult13_g92 = smoothstep( 0.0 , temp_output_11_0_g92 , tanTriplanarNormal9_g92.b);
				float _rtSmooth888 = smoothstepResult13_g92;
				float temp_output_704_0 = ( _rtSmooth888 + (0) );
				float smoothstepResult674 = smoothstep( 0.0 , 1.06 , temp_output_704_0);
				float height107_g53 = smoothstepResult674;
				float scale107_g53 = _ClayNormal;
				float3 localPerturbNormal107_g53 = PerturbNormal107_g53( surf_pos107_g53 , surf_norm107_g53 , height107_g53 , scale107_g53 );
				float3 worldToTangentDir42_g53 = mul( ase_worldToTangent, localPerturbNormal107_g53);
				float localCalculateUVsSharp110_g70 = ( 0.0 );
				float2 temp_cast_6 = (125.0).xx;
				float2 texCoord5_g69 = IN.ase_texcoord6.xy * ( _Scale * temp_cast_6 ) + float2( 0,0 );
				float2 temp_cast_7 = (-0.1).xx;
				float2 panner30_g69 = ( _TimeParameters.x * temp_cast_7 + texCoord5_g69);
				float2 appendResult34_g69 = (float2(texCoord5_g69.x , (panner30_g69).y));
				float2 temp_output_85_0_g70 = appendResult34_g69;
				float2 UV110_g70 = temp_output_85_0_g70;
				float4 TexelSize110_g70 = _FingerprintNormal_TexelSize;
				float2 UV0110_g70 = float2( 0,0 );
				float2 UV1110_g70 = float2( 0,0 );
				float2 UV2110_g70 = float2( 0,0 );
				{
				{
				    UV110_g70.y -= TexelSize110_g70.y * 0.5;
				    UV0110_g70 = UV110_g70;
				    UV1110_g70 = UV110_g70 + float2( TexelSize110_g70.x, 0 );
				    UV2110_g70 = UV110_g70 + float2( 0, TexelSize110_g70.y );
				}
				}
				float4 break134_g70 = tex2D( _FingerprintNormal, UV0110_g70 );
				float S0128_g70 = break134_g70.r;
				float4 break136_g70 = tex2D( _FingerprintNormal, UV1110_g70 );
				float S1128_g70 = break136_g70.r;
				float4 break138_g70 = tex2D( _FingerprintNormal, UV2110_g70 );
				float S2128_g70 = break138_g70.r;
				float temp_output_91_0_g70 = _FingerprintStrength;
				float Strength128_g70 = temp_output_91_0_g70;
				float3 localCombineSamplesSharp128_g70 = CombineSamplesSharp128_g70( S0128_g70 , S1128_g70 , S2128_g70 , Strength128_g70 );
				float3 surf_pos107_g71 = WorldPosition;
				float3 surf_norm107_g71 = WorldNormal;
				float time8_g69 = -2.7;
				float2 voronoiSmoothId8_g69 = 0;
				float voronoiSmooth8_g69 = _NoiseSmoothness;
				float2 coords8_g69 = appendResult34_g69 * _NoiseScale;
				float2 id8_g69 = 0;
				float2 uv8_g69 = 0;
				float voroi8_g69 = voronoi8_g69( coords8_g69, time8_g69, id8_g69, uv8_g69, voronoiSmooth8_g69, voronoiSmoothId8_g69 );
				float height107_g71 = voroi8_g69;
				float scale107_g71 = _NoiseStrength;
				float3 localPerturbNormal107_g71 = PerturbNormal107_g71( surf_pos107_g71 , surf_norm107_g71 , height107_g71 , scale107_g71 );
				float3 worldToTangentDir42_g71 = mul( ase_worldToTangent, localPerturbNormal107_g71);
				float4 lerpResult686 = lerp( lerpResult664 , float4( BlendNormal( worldToTangentDir42_g53 , BlendNormal( localCombineSamplesSharp128_g70 , worldToTangentDir42_g71 ) ) , 0.0 ) , _combinedLines687);
				float4 _normalsMitRipples665 = lerpResult686;
				float3 temp_output_848_0 = BlendNormalRNM( vertexNormal841 , _normalsMitRipples665.rgb );
				float4 lerpResult853 = lerp( float4( temp_output_848_0 , 0.0 ) , _normalsMitRipples665 , _Float5);
				float4 _endNormals896 = lerpResult853;
				

				float3 Normal = _endNormals896.rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.clipPos.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				#if defined(_GBUFFER_NORMALS_OCT)
					float2 octNormalWS = PackNormalOctQuadEncode(WorldNormal);
					float2 remappedOctNormalWS = saturate(octNormalWS * 0.5 + 0.5);
					half3 packedNormalWS = PackFloat2To888(remappedOctNormalWS);
					return half4(packedNormalWS, 0.0);
				#else
					#if defined(_NORMALMAP)
						#if _NORMAL_DROPOFF_TS
							float crossSign = (WorldTangent.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
							float3 bitangent = crossSign * cross(WorldNormal.xyz, WorldTangent.xyz);
							float3 normalWS = TransformTangentToWorld(Normal, half3x3(WorldTangent.xyz, bitangent, WorldNormal.xyz));
						#elif _NORMAL_DROPOFF_OS
							float3 normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							float3 normalWS = Normal;
						#endif
					#else
						float3 normalWS = WorldNormal;
					#endif
					return half4(NormalizeNormalPerPixel(normalWS), 0.0);
				#endif
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "GBuffer"
			Tags { "LightMode"="UniversalGBuffer" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#pragma multi_compile_instancing
			#pragma instancing_options renderinglayer
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_TESSELLATION 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_DISTANCE_TESSELLATION
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120110
			#define REQUIRE_OPAQUE_TEXTURE 1
			#define REQUIRE_DEPTH_TEXTURE 1


			#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile_fragment _ _LIGHT_LAYERS
			#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_GBUFFER

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 clipPos : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				float4 lightmapUVOrVertexSH : TEXCOORD1;
				half4 fogFactorAndVertexLight : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord : TEXCOORD6;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
				float2 dynamicLightmapUV : TEXCOORD7;
				#endif
				float4 ase_texcoord8 : TEXCOORD8;
				float4 ase_tangent : TANGENT;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Horizon;
			float4 _ShallowColor;
			float4 _DeepColor;
			float4 _SpecularColor;
			float4 _FingerprintNormal_TexelSize;
			float4 _FoamClayColor;
			float4 _WaterNormal_ST;
			float _FingerprintStrength;
			float _Foam;
			float _NoiseSmoothness;
			float _ClayNormal;
			float _NoiseStrength;
			float _Float5;
			float _RippleCutoff;
			float _Speed;
			float _NoiseScale;
			float _Scale;
			float _WaveLength;
			float _HeightFoamH;
			float _WaterDepth;
			float _RefractionDistortion;
			float _LightingHardness;
			float _LightingSmoothness;
			float _NormalIntensity;
			float _NormalScale;
			float _Steepness;
			float _WaveSpeed;
			float _wavesZ;
			float _HorizonDistance;
			float _Caustics;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _FingerprintNormal;
			sampler2D _Roughness;
			sampler2D _GlobalEffectRT;
			sampler2D _WaterNormal;
			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _foam;
			sampler2D _heightFoam;
			sampler2D _Caust;


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"

			float3 TangentToWorld13_g21( float3 NormalTS, float3x3 TBN )
			{
				float3 NormalWS = TransformTangentToWorld(NormalTS, TBN);
				NormalWS = NormalizeNormalPerPixel(NormalWS);
				return NormalWS;
			}
			
			float3 AdditionalLightsSpecular10x12x( float3 WorldPosition, float3 WorldNormal, float3 WorldView, float3 SpecColor, float Smoothness )
			{
				float3 Color = 0;
				#ifdef _ADDITIONAL_LIGHTS
					Smoothness = exp2(10 * Smoothness + 1);
					uint lightCount = GetAdditionalLightsCount();
					LIGHT_LOOP_BEGIN( lightCount )
						Light light = GetAdditionalLight(lightIndex, WorldPosition);
						half3 AttLightColor = light.color *(light.distanceAttenuation * light.shadowAttenuation);
						Color += LightingSpecular(AttLightColor, light.direction, WorldNormal, WorldView, half4(SpecColor, 0), Smoothness);	
					LIGHT_LOOP_END
				#endif
				return Color;
			}
			
			inline float3 TriplanarSampling9_g92( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				xNorm.xyz  = half3( UnpackNormalScale( xNorm , 1.0 ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
				yNorm.xyz  = half3( UnpackNormalScale( yNorm , 1.0 ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
				zNorm.xyz  = half3( UnpackNormalScale( zNorm , 1.0 ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
				return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
			}
			
			real3 ASESafeNormalize(float3 inVec)
			{
				real dp3 = max(FLT_MIN, dot(inVec, inVec));
				return inVec* rsqrt( dp3);
			}
			
			float3 PerturbNormal107_g53( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			float3 CombineSamplesSharp128_g70( float S0, float S1, float S2, float Strength )
			{
				{
				    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
				    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
				    return normalize( cross( va, vb ) );
				}
			}
			
					float2 voronoihash8_g69( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi8_g69( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash8_g69( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 //		if( d<F1 ) {
						 //			F2 = F1;
						 			float h = smoothstep(0.0, 1.0, 0.5 + 0.5 * (F1 - d) / smoothness); F1 = lerp(F1, d, h) - smoothness * h * (1.0 - h);mg = g; mr = r; id = o;
						 //		} else if( d<F2 ) {
						 //			F2 = d;
						
						 //		}
						 	}
						}
						return F1;
					}
			
			float3 PerturbNormal107_g71( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			float2 UnStereo( float2 UV )
			{
				#if UNITY_SINGLE_PASS_STEREO
				float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
				UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
				#endif
				return UV;
			}
			
			float3 InvertDepthDirURP75_g72( float3 In )
			{
				float3 result = In;
				#if !defined(ASE_SRP_VERSION) || ASE_SRP_VERSION <= 70301 || ASE_SRP_VERSION == 70503 || ASE_SRP_VERSION == 70600 || ASE_SRP_VERSION == 70700 || ASE_SRP_VERSION == 70701 || ASE_SRP_VERSION >= 80301
				result *= float3(1,1,-1);
				#endif
				return result;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float4 temp_output_5_0_g79 = float4(0.02,-0.34,0.16,2.23);
				float2 appendResult19_g80 = (float2(cos( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g80 = normalize( appendResult19_g80 );
				float2 d26_g80 = normalizeResult15_g80;
				float temp_output_3_0_g79 = _WaveLength;
				float k25_g80 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float _0waterMover900 = _wavesZ;
				float3 appendResult758 = (float3(ase_worldPos.x , ase_worldPos.y , ( ase_worldPos.z + _0waterMover900 )));
				float3 temp_output_1_0_g79 = appendResult758;
				float dotResult29_g80 = dot( d26_g80 , (temp_output_1_0_g79).xz );
				float temp_output_4_0_g79 = _WaveSpeed;
				float mulTime33_g80 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g80 = ( k25_g80 * ( dotResult29_g80 - mulTime33_g80 ) );
				float temp_output_2_0_g79 = _Steepness;
				float temp_output_3_0_g80 = temp_output_2_0_g79;
				float a37_g80 = ( temp_output_3_0_g80 / k25_g80 );
				float temp_output_91_0_g80 = ( cos( f34_g80 ) * a37_g80 );
				float3 appendResult86_g80 = (float3(( (d26_g80).x * temp_output_91_0_g80 ) , ( a37_g80 * sin( f34_g80 ) ) , ( temp_output_91_0_g80 * (d26_g80).y )));
				float2 appendResult19_g81 = (float2(cos( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g81 = normalize( appendResult19_g81 );
				float2 d26_g81 = normalizeResult15_g81;
				float k25_g81 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g81 = dot( d26_g81 , (temp_output_1_0_g79).xz );
				float mulTime33_g81 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g81 = ( k25_g81 * ( dotResult29_g81 - mulTime33_g81 ) );
				float temp_output_3_0_g81 = temp_output_2_0_g79;
				float a37_g81 = ( temp_output_3_0_g81 / k25_g81 );
				float temp_output_91_0_g81 = ( cos( f34_g81 ) * a37_g81 );
				float3 appendResult86_g81 = (float3(( (d26_g81).x * temp_output_91_0_g81 ) , ( a37_g81 * sin( f34_g81 ) ) , ( temp_output_91_0_g81 * (d26_g81).y )));
				float2 appendResult19_g83 = (float2(cos( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g83 = normalize( appendResult19_g83 );
				float2 d26_g83 = normalizeResult15_g83;
				float k25_g83 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g83 = dot( d26_g83 , (temp_output_1_0_g79).xz );
				float mulTime33_g83 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g83 = ( k25_g83 * ( dotResult29_g83 - mulTime33_g83 ) );
				float temp_output_3_0_g83 = temp_output_2_0_g79;
				float a37_g83 = ( temp_output_3_0_g83 / k25_g83 );
				float temp_output_91_0_g83 = ( cos( f34_g83 ) * a37_g83 );
				float3 appendResult86_g83 = (float3(( (d26_g83).x * temp_output_91_0_g83 ) , ( a37_g83 * sin( f34_g83 ) ) , ( temp_output_91_0_g83 * (d26_g83).y )));
				float2 appendResult19_g82 = (float2(cos( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g82 = normalize( appendResult19_g82 );
				float2 d26_g82 = normalizeResult15_g82;
				float k25_g82 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g82 = dot( d26_g82 , (temp_output_1_0_g79).xz );
				float mulTime33_g82 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g82 = ( k25_g82 * ( dotResult29_g82 - mulTime33_g82 ) );
				float temp_output_3_0_g82 = temp_output_2_0_g79;
				float a37_g82 = ( temp_output_3_0_g82 / k25_g82 );
				float temp_output_91_0_g82 = ( cos( f34_g82 ) * a37_g82 );
				float3 appendResult86_g82 = (float3(( (d26_g82).x * temp_output_91_0_g82 ) , ( a37_g82 * sin( f34_g82 ) ) , ( temp_output_91_0_g82 * (d26_g82).y )));
				float3 worldToObj485 = mul( GetWorldToObjectMatrix(), float4( ( ase_worldPos + ( ( appendResult86_g80 + appendResult86_g81 ) + ( appendResult86_g83 + appendResult86_g82 ) ) ), 1 ) ).xyz;
				float3 waveDisplacement493 = worldToObj485;
				
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord8.z = eyeDepth;
				
				o.ase_texcoord8.xy = v.texcoord.xy;
				o.ase_tangent = v.ase_tangent;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord8.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = waveDisplacement493;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy);
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					o.dynamicLightmapUV.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if !defined(LIGHTMAP_ON)
					OUTPUT_SH(normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz);
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord.xy;
					o.lightmapUVOrVertexSH.xy = v.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );

				o.fogFactorAndVertexLight = half4(0, vertexLight);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;
				o.clipPosV = positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			FragmentOutput frag ( VertexOutput IN
								#ifdef ASE_DEPTH_WRITE_ON
								,out float outputDepth : ASE_SV_DEPTH
								#endif
								 )
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif

				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				float2 NormalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#else
					ShadowCoords = float4(0, 0, 0, 0);
				#endif

				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float _0waterMover900 = _wavesZ;
				float2 appendResult903 = (float2(0.0 , -_0waterMover900));
				float2 uv_WaterNormal = IN.ase_texcoord8.xy * _WaterNormal_ST.xy + _WaterNormal_ST.zw;
				float2 temp_output_907_0 = ( ( appendResult903 * 0.05 ) + ( uv_WaterNormal * _NormalScale ) );
				float2 panner22 = ( 1.0 * _Time.y * float2( -0.03,0 ) + temp_output_907_0);
				float3 unpack23 = UnpackNormalScale( tex2D( _WaterNormal, panner22 ), _NormalIntensity );
				unpack23.z = lerp( 1, unpack23.z, saturate(_NormalIntensity) );
				float2 panner19 = ( 1.0 * _Time.y * float2( 0.04,0.04 ) + temp_output_907_0);
				float3 unpack17 = UnpackNormalScale( tex2D( _WaterNormal, panner19 ), _NormalIntensity );
				unpack17.z = lerp( 1, unpack17.z, saturate(_NormalIntensity) );
				float3 _normals210 = BlendNormal( unpack23 , unpack17 );
				float3 NormalTS13_g21 = _normals210;
				float3 Binormal5_g21 = ( ( IN.ase_tangent.w > 0.0 ? 1.0 : -1.0 ) * cross( WorldNormal , WorldTangent ) );
				float3x3 TBN1_g21 = float3x3(WorldTangent, Binormal5_g21, WorldNormal);
				float3x3 TBN13_g21 = TBN1_g21;
				float3 localTangentToWorld13_g21 = TangentToWorld13_g21( NormalTS13_g21 , TBN13_g21 );
				float3 temp_output_430_0 = localTangentToWorld13_g21;
				float dotResult383 = dot( SafeNormalize(_MainLightPosition.xyz) , temp_output_430_0 );
				float temp_output_385_0 = pow( saturate( dotResult383 ) , exp2( ( ( _LightingSmoothness * 10.0 ) + 1.0 ) ) );
				float lerpResult357 = lerp( temp_output_385_0 , step( 0.5 , temp_output_385_0 ) , _LightingHardness);
				float3 worldPosValue44_g22 = WorldPosition;
				float3 WorldPosition13_g22 = worldPosValue44_g22;
				float3 worldNormalValue50_g22 = temp_output_430_0;
				float3 WorldNormal13_g22 = worldNormalValue50_g22;
				float3 temp_output_15_0_g22 = WorldViewDirection;
				float3 WorldView13_g22 = temp_output_15_0_g22;
				float3 temp_output_14_0_g22 = _SpecularColor.rgb;
				float3 SpecColor13_g22 = temp_output_14_0_g22;
				float temp_output_18_0_g22 = _LightingSmoothness;
				float Smoothness13_g22 = temp_output_18_0_g22;
				float3 localAdditionalLightsSpecular10x12x13_g22 = AdditionalLightsSpecular10x12x( WorldPosition13_g22 , WorldNormal13_g22 , WorldView13_g22 , SpecColor13_g22 , Smoothness13_g22 );
				float3 specularResult61_g22 = localAdditionalLightsSpecular10x12x13_g22;
				float4 _lights438 = ( ( ( lerpResult357 * _SpecularColor ) * _SpecularColor.a ) + float4( specularResult61_g22 , 0.0 ) );
				float eyeDepth = IN.ase_texcoord8.z;
				float4 ase_screenPosNorm = ScreenPos / ScreenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float eyeDepth28_g78 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float2 temp_output_20_0_g78 = ( (_normals210).xy * ( _RefractionDistortion / max( eyeDepth , 0.1 ) ) * saturate( ( eyeDepth28_g78 - eyeDepth ) ) );
				float eyeDepth2_g78 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ( float4( temp_output_20_0_g78, 0.0 , 0.0 ) + ase_screenPosNorm ).xy ),_ZBufferParams);
				float2 temp_output_32_0_g78 = (( float4( ( temp_output_20_0_g78 * saturate( ( eyeDepth2_g78 - eyeDepth ) ) ), 0.0 , 0.0 ) + ase_screenPosNorm )).xy;
				float2 temp_output_246_38 = temp_output_32_0_g78;
				float4 fetchOpaqueVal65 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( temp_output_246_38 ), 1.0 );
				float4 _refraction254 = fetchOpaqueVal65;
				float2 _refractUV290 = temp_output_246_38;
				float eyeDepth2_g77 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( float4( _refractUV290, 0.0 , 0.0 ).xy ),_ZBufferParams);
				float depthToLinear6_g77 = LinearEyeDepth(ase_screenPosNorm.z,_ZBufferParams);
				float _depthMask614 = ( 1.0 - saturate( ( ( abs( ( ( eyeDepth2_g77 - depthToLinear6_g77 ) / _WaterDepth ) ) * 0.07 ) + -0.05 ) ) );
				float4 lerpResult13 = lerp( _DeepColor , _ShallowColor , _depthMask614);
				float fresnelNdotV316 = dot( WorldNormal, WorldViewDirection );
				float fresnelNode316 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV316, _HorizonDistance ) );
				float4 lerpResult320 = lerp( ( _refraction254 * lerpResult13 ) , _Horizon , fresnelNode316);
				float4 _colors292 = lerpResult320;
				float screenDepth71_g93 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth71_g93 = saturate( abs( ( screenDepth71_g93 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( ( _Foam * 2.0 ) ) ) );
				float _foamDiff63_g93 = ( distanceDepth71_g93 * 11.25 );
				float _speedVar231 = _Speed;
				float speedVar31_g93 = _speedVar231;
				float mulTime19_g93 = _TimeParameters.x * speedVar31_g93;
				float temp_output_26_0_g93 = ( _foamDiff63_g93 - saturate( sin( ( ( _foamDiff63_g93 - mulTime19_g93 ) * ( 4.0 * PI ) ) ) ) );
				float _foamHarry25_g93 = temp_output_26_0_g93;
				float2 temp_cast_5 = (speedVar31_g93).xx;
				float2 appendResult5_g93 = (float2(WorldPosition.x , WorldPosition.z));
				float2 worldPosUV51_g93 = appendResult5_g93;
				float2 panner1_g93 = ( 1.0 * _Time.y * temp_cast_5 + ( worldPosUV51_g93 * 0.22 ));
				float3 lerpResult8_g93 = lerp( float3( panner1_g93 ,  0.0 ) , _normals210 , 0.35);
				float4 break77_g93 = ( float4(1,1,1,1) * step( _foamHarry25_g93 , tex2D( _foam, lerpResult8_g93.xy ).r ) );
				float smoothstepResult70_g93 = smoothstep( 0.0 , ( distanceDepth71_g93 + 0.3 ) , ( 1.0 - 0.0 ));
				float4 appendResult79_g93 = (float4(break77_g93.r , break77_g93.g , break77_g93.b , ( ( 1.0 - smoothstepResult70_g93 ) * break77_g93.a )));
				float4 _shoreLines655 = appendResult79_g93;
				float temp_output_11_0_g92 = _RippleCutoff;
				float2 temp_cast_8 = (0.005).xx;
				float3x3 ase_worldToTangent = float3x3(WorldTangent,WorldBiTangent,WorldNormal);
				float3 appendResult8_g92 = (float3(( WorldPosition.x + 100.0 ) , WorldPosition.y , ( WorldPosition.z + 100.0 )));
				float3 triplanar9_g92 = TriplanarSampling9_g92( _GlobalEffectRT, appendResult8_g92, WorldNormal, 1.0, temp_cast_8, -50.0, 0 );
				float3 tanTriplanarNormal9_g92 = mul( ase_worldToTangent, triplanar9_g92 );
				float _rt500 = step( temp_output_11_0_g92 , tanTriplanarNormal9_g92.z );
				float4 _combinedLines687 = ( _shoreLines655 + _rt500 );
				float4 lerpResult689 = lerp( ( _lights438 + _colors292 ) , _FoamClayColor , _combinedLines687);
				float4 _endColor892 = lerpResult689;
				
				float3 _tangent = float3(1,0,0);
				float4 temp_output_5_0_g79 = float4(0.02,-0.34,0.16,2.23);
				float2 appendResult19_g80 = (float2(cos( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g80 = normalize( appendResult19_g80 );
				float2 d26_g80 = normalizeResult15_g80;
				float temp_output_47_0_g80 = (d26_g80).x;
				float temp_output_2_0_g79 = _Steepness;
				float temp_output_3_0_g80 = temp_output_2_0_g79;
				float temp_output_3_0_g79 = _WaveLength;
				float k25_g80 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float3 appendResult758 = (float3(WorldPosition.x , WorldPosition.y , ( WorldPosition.z + _0waterMover900 )));
				float3 temp_output_1_0_g79 = appendResult758;
				float dotResult29_g80 = dot( d26_g80 , (temp_output_1_0_g79).xz );
				float temp_output_4_0_g79 = _WaveSpeed;
				float mulTime33_g80 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g80 = ( k25_g80 * ( dotResult29_g80 - mulTime33_g80 ) );
				float temp_output_53_0_g80 = ( temp_output_3_0_g80 * sin( f34_g80 ) );
				float3 appendResult56_g80 = (float3(( ( temp_output_47_0_g80 * -temp_output_47_0_g80 ) * temp_output_53_0_g80 ) , ( ( cos( f34_g80 ) * temp_output_3_0_g80 ) * temp_output_47_0_g80 ) , ( temp_output_53_0_g80 * ( -temp_output_47_0_g80 * (d26_g80).y ) )));
				float3 tangent45_g80 = ( _tangent + appendResult56_g80 );
				float2 appendResult19_g81 = (float2(cos( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g81 = normalize( appendResult19_g81 );
				float2 d26_g81 = normalizeResult15_g81;
				float temp_output_47_0_g81 = (d26_g81).x;
				float temp_output_3_0_g81 = temp_output_2_0_g79;
				float k25_g81 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g81 = dot( d26_g81 , (temp_output_1_0_g79).xz );
				float mulTime33_g81 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g81 = ( k25_g81 * ( dotResult29_g81 - mulTime33_g81 ) );
				float temp_output_53_0_g81 = ( temp_output_3_0_g81 * sin( f34_g81 ) );
				float3 appendResult56_g81 = (float3(( ( temp_output_47_0_g81 * -temp_output_47_0_g81 ) * temp_output_53_0_g81 ) , ( ( cos( f34_g81 ) * temp_output_3_0_g81 ) * temp_output_47_0_g81 ) , ( temp_output_53_0_g81 * ( -temp_output_47_0_g81 * (d26_g81).y ) )));
				float3 tangent45_g81 = ( _tangent + appendResult56_g81 );
				float2 appendResult19_g83 = (float2(cos( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g83 = normalize( appendResult19_g83 );
				float2 d26_g83 = normalizeResult15_g83;
				float temp_output_47_0_g83 = (d26_g83).x;
				float temp_output_3_0_g83 = temp_output_2_0_g79;
				float k25_g83 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g83 = dot( d26_g83 , (temp_output_1_0_g79).xz );
				float mulTime33_g83 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g83 = ( k25_g83 * ( dotResult29_g83 - mulTime33_g83 ) );
				float temp_output_53_0_g83 = ( temp_output_3_0_g83 * sin( f34_g83 ) );
				float3 appendResult56_g83 = (float3(( ( temp_output_47_0_g83 * -temp_output_47_0_g83 ) * temp_output_53_0_g83 ) , ( ( cos( f34_g83 ) * temp_output_3_0_g83 ) * temp_output_47_0_g83 ) , ( temp_output_53_0_g83 * ( -temp_output_47_0_g83 * (d26_g83).y ) )));
				float3 tangent45_g83 = ( _tangent + appendResult56_g83 );
				float2 appendResult19_g82 = (float2(cos( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g82 = normalize( appendResult19_g82 );
				float2 d26_g82 = normalizeResult15_g82;
				float temp_output_47_0_g82 = (d26_g82).x;
				float temp_output_3_0_g82 = temp_output_2_0_g79;
				float k25_g82 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g82 = dot( d26_g82 , (temp_output_1_0_g79).xz );
				float mulTime33_g82 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g82 = ( k25_g82 * ( dotResult29_g82 - mulTime33_g82 ) );
				float temp_output_53_0_g82 = ( temp_output_3_0_g82 * sin( f34_g82 ) );
				float3 appendResult56_g82 = (float3(( ( temp_output_47_0_g82 * -temp_output_47_0_g82 ) * temp_output_53_0_g82 ) , ( ( cos( f34_g82 ) * temp_output_3_0_g82 ) * temp_output_47_0_g82 ) , ( temp_output_53_0_g82 * ( -temp_output_47_0_g82 * (d26_g82).y ) )));
				float3 tangent45_g82 = ( _tangent + appendResult56_g82 );
				float3 _binormal = float3(0,0,1);
				float temp_output_67_0_g80 = (d26_g80).y;
				float temp_output_66_0_g80 = ( temp_output_3_0_g80 * sin( f34_g80 ) );
				float3 appendResult72_g80 = (float3(( ( temp_output_67_0_g80 * -temp_output_67_0_g80 ) * temp_output_66_0_g80 ) , ( ( cos( f34_g80 ) * temp_output_3_0_g80 ) * temp_output_67_0_g80 ) , ( temp_output_66_0_g80 * ( -temp_output_67_0_g80 * temp_output_67_0_g80 ) )));
				float3 binormal79_g80 = ( _binormal + appendResult72_g80 );
				float temp_output_67_0_g81 = (d26_g81).y;
				float temp_output_66_0_g81 = ( temp_output_3_0_g81 * sin( f34_g81 ) );
				float3 appendResult72_g81 = (float3(( ( temp_output_67_0_g81 * -temp_output_67_0_g81 ) * temp_output_66_0_g81 ) , ( ( cos( f34_g81 ) * temp_output_3_0_g81 ) * temp_output_67_0_g81 ) , ( temp_output_66_0_g81 * ( -temp_output_67_0_g81 * temp_output_67_0_g81 ) )));
				float3 binormal79_g81 = ( _binormal + appendResult72_g81 );
				float temp_output_67_0_g83 = (d26_g83).y;
				float temp_output_66_0_g83 = ( temp_output_3_0_g83 * sin( f34_g83 ) );
				float3 appendResult72_g83 = (float3(( ( temp_output_67_0_g83 * -temp_output_67_0_g83 ) * temp_output_66_0_g83 ) , ( ( cos( f34_g83 ) * temp_output_3_0_g83 ) * temp_output_67_0_g83 ) , ( temp_output_66_0_g83 * ( -temp_output_67_0_g83 * temp_output_67_0_g83 ) )));
				float3 binormal79_g83 = ( _binormal + appendResult72_g83 );
				float temp_output_67_0_g82 = (d26_g82).y;
				float temp_output_66_0_g82 = ( temp_output_3_0_g82 * sin( f34_g82 ) );
				float3 appendResult72_g82 = (float3(( ( temp_output_67_0_g82 * -temp_output_67_0_g82 ) * temp_output_66_0_g82 ) , ( ( cos( f34_g82 ) * temp_output_3_0_g82 ) * temp_output_67_0_g82 ) , ( temp_output_66_0_g82 * ( -temp_output_67_0_g82 * temp_output_67_0_g82 ) )));
				float3 binormal79_g82 = ( _binormal + appendResult72_g82 );
				float3 normalizeResult20_g79 = normalize( cross( ( tangent45_g80 + tangent45_g81 + tangent45_g83 + tangent45_g82 ) , ( binormal79_g80 + binormal79_g81 + binormal79_g83 + binormal79_g82 ) ) );
				float3 worldToObjDir773 = ASESafeNormalize( mul( GetWorldToObjectMatrix(), float4( normalizeResult20_g79, 0 ) ).xyz );
				float3 normalizeResult844 = ASESafeNormalize( ( worldToObjDir773 + IN.ase_normal ) );
				float3 objectToTangentDir847 = normalize( mul( ase_worldToTangent, mul( GetObjectToWorldMatrix(), float4( normalizeResult844, 0 ) ).xyz) );
				float3 vertexNormal841 = objectToTangentDir847;
				float3 _rTNormal551 = tanTriplanarNormal9_g92;
				float3 lerpResult561 = lerp( _rTNormal551 , _normals210 , 50.0);
				float3 _combinedNormalsRT660 = lerpResult561;
				float4 color667 = IsGammaSpace() ? float4(0,0,1,0) : float4(0,0,1,0);
				float4 lerpResult664 = lerp( float4( _combinedNormalsRT660 , 0.0 ) , color667 , _combinedLines687);
				float3 surf_pos107_g53 = WorldPosition;
				float3 surf_norm107_g53 = WorldNormal;
				float smoothstepResult13_g92 = smoothstep( 0.0 , temp_output_11_0_g92 , tanTriplanarNormal9_g92.b);
				float _rtSmooth888 = smoothstepResult13_g92;
				float temp_output_704_0 = ( _rtSmooth888 + (0) );
				float smoothstepResult674 = smoothstep( 0.0 , 1.06 , temp_output_704_0);
				float height107_g53 = smoothstepResult674;
				float scale107_g53 = _ClayNormal;
				float3 localPerturbNormal107_g53 = PerturbNormal107_g53( surf_pos107_g53 , surf_norm107_g53 , height107_g53 , scale107_g53 );
				float3 worldToTangentDir42_g53 = mul( ase_worldToTangent, localPerturbNormal107_g53);
				float localCalculateUVsSharp110_g70 = ( 0.0 );
				float2 temp_cast_13 = (125.0).xx;
				float2 texCoord5_g69 = IN.ase_texcoord8.xy * ( _Scale * temp_cast_13 ) + float2( 0,0 );
				float2 temp_cast_14 = (-0.1).xx;
				float2 panner30_g69 = ( _TimeParameters.x * temp_cast_14 + texCoord5_g69);
				float2 appendResult34_g69 = (float2(texCoord5_g69.x , (panner30_g69).y));
				float2 temp_output_85_0_g70 = appendResult34_g69;
				float2 UV110_g70 = temp_output_85_0_g70;
				float4 TexelSize110_g70 = _FingerprintNormal_TexelSize;
				float2 UV0110_g70 = float2( 0,0 );
				float2 UV1110_g70 = float2( 0,0 );
				float2 UV2110_g70 = float2( 0,0 );
				{
				{
				    UV110_g70.y -= TexelSize110_g70.y * 0.5;
				    UV0110_g70 = UV110_g70;
				    UV1110_g70 = UV110_g70 + float2( TexelSize110_g70.x, 0 );
				    UV2110_g70 = UV110_g70 + float2( 0, TexelSize110_g70.y );
				}
				}
				float4 break134_g70 = tex2D( _FingerprintNormal, UV0110_g70 );
				float S0128_g70 = break134_g70.r;
				float4 break136_g70 = tex2D( _FingerprintNormal, UV1110_g70 );
				float S1128_g70 = break136_g70.r;
				float4 break138_g70 = tex2D( _FingerprintNormal, UV2110_g70 );
				float S2128_g70 = break138_g70.r;
				float temp_output_91_0_g70 = _FingerprintStrength;
				float Strength128_g70 = temp_output_91_0_g70;
				float3 localCombineSamplesSharp128_g70 = CombineSamplesSharp128_g70( S0128_g70 , S1128_g70 , S2128_g70 , Strength128_g70 );
				float3 surf_pos107_g71 = WorldPosition;
				float3 surf_norm107_g71 = WorldNormal;
				float time8_g69 = -2.7;
				float2 voronoiSmoothId8_g69 = 0;
				float voronoiSmooth8_g69 = _NoiseSmoothness;
				float2 coords8_g69 = appendResult34_g69 * _NoiseScale;
				float2 id8_g69 = 0;
				float2 uv8_g69 = 0;
				float voroi8_g69 = voronoi8_g69( coords8_g69, time8_g69, id8_g69, uv8_g69, voronoiSmooth8_g69, voronoiSmoothId8_g69 );
				float height107_g71 = voroi8_g69;
				float scale107_g71 = _NoiseStrength;
				float3 localPerturbNormal107_g71 = PerturbNormal107_g71( surf_pos107_g71 , surf_norm107_g71 , height107_g71 , scale107_g71 );
				float3 worldToTangentDir42_g71 = mul( ase_worldToTangent, localPerturbNormal107_g71);
				float4 lerpResult686 = lerp( lerpResult664 , float4( BlendNormal( worldToTangentDir42_g53 , BlendNormal( localCombineSamplesSharp128_g70 , worldToTangentDir42_g71 ) ) , 0.0 ) , _combinedLines687);
				float4 _normalsMitRipples665 = lerpResult686;
				float3 temp_output_848_0 = BlendNormalRNM( vertexNormal841 , _normalsMitRipples665.rgb );
				float4 lerpResult853 = lerp( float4( temp_output_848_0 , 0.0 ) , _normalsMitRipples665 , _Float5);
				float4 _endNormals896 = lerpResult853;
				
				float4 temp_cast_20 = (0.43).xxxx;
				float4 temp_cast_21 = (0.01).xxxx;
				float2 temp_cast_22 = (( speedVar31_g93 * -0.15 )).xx;
				float2 panner39_g93 = ( 1.0 * _Time.y * temp_cast_22 + ( 0.15 * worldPosUV51_g93 ));
				float4 lerpResult42_g93 = lerp( temp_cast_21 , tex2D( _heightFoam, panner39_g93 ) , ( WorldPosition.y + _HeightFoamH ));
				float4 smoothstepResult45_g93 = smoothstep( float4( 0,0,0,0 ) , temp_cast_20 , lerpResult42_g93);
				float4 _foam259 = smoothstepResult45_g93;
				float4 temp_cast_24 = (_Caustics).xxxx;
				float2 UV22_g73 = ase_screenPosNorm.xy;
				float2 localUnStereo22_g73 = UnStereo( UV22_g73 );
				float2 break64_g72 = localUnStereo22_g73;
				float clampDepth69_g72 = SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy );
				#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g72 = ( 1.0 - clampDepth69_g72 );
				#else
				float staticSwitch38_g72 = clampDepth69_g72;
				#endif
				float3 appendResult39_g72 = (float3(break64_g72.x , break64_g72.y , staticSwitch38_g72));
				float4 appendResult42_g72 = (float4((appendResult39_g72*2.0 + -1.0) , 1.0));
				float4 temp_output_43_0_g72 = mul( unity_CameraInvProjection, appendResult42_g72 );
				float3 temp_output_46_0_g72 = ( (temp_output_43_0_g72).xyz / (temp_output_43_0_g72).w );
				float3 In75_g72 = temp_output_46_0_g72;
				float3 localInvertDepthDirURP75_g72 = InvertDepthDirURP75_g72( In75_g72 );
				float4 appendResult49_g72 = (float4(localInvertDepthDirURP75_g72 , 1.0));
				float2 temp_output_30_0_g76 = (( mul( unity_CameraToWorld, appendResult49_g72 ) * 0.04 )).xz;
				float temp_output_1_0_g76 = 0.05;
				float2 temp_output_15_0_g76 = ( temp_output_30_0_g76 + ( float2( 0.1,0 ) * temp_output_1_0_g76 ) );
				float2 panner32_g76 = ( 1.0 * _Time.y * float2( 0.09,0.06 ) + temp_output_15_0_g76);
				float4 tex2DNode31_g76 = tex2D( _Caust, panner32_g76 );
				float3 appendResult36_g76 = (float3(tex2DNode31_g76.r , tex2DNode31_g76.g , tex2DNode31_g76.b));
				float2 panner35_g76 = ( 1.0 * _Time.y * float2( -0.05,-0.07 ) + temp_output_15_0_g76);
				float4 tex2DNode34_g76 = tex2D( _Caust, panner35_g76 );
				float3 appendResult39_g76 = (float3(tex2DNode34_g76.r , tex2DNode34_g76.g , tex2DNode34_g76.b));
				float2 temp_output_16_0_g76 = ( temp_output_30_0_g76 + ( float2( 0,0.1 ) * temp_output_1_0_g76 ) );
				float2 panner46_g76 = ( 1.0 * _Time.y * float2( 0.09,0.06 ) + temp_output_16_0_g76);
				float4 tex2DNode45_g76 = tex2D( _Caust, panner46_g76 );
				float3 appendResult47_g76 = (float3(tex2DNode45_g76.r , tex2DNode45_g76.g , tex2DNode45_g76.b));
				float2 panner49_g76 = ( 1.0 * _Time.y * float2( -0.05,-0.07 ) + temp_output_16_0_g76);
				float4 tex2DNode50_g76 = tex2D( _Caust, panner49_g76 );
				float3 appendResult51_g76 = (float3(tex2DNode50_g76.r , tex2DNode50_g76.g , tex2DNode50_g76.b));
				float2 temp_output_17_0_g76 = ( temp_output_30_0_g76 + ( float2( -0.1,-0.1 ) * temp_output_1_0_g76 ) );
				float2 panner54_g76 = ( 1.0 * _Time.y * float2( 0.09,0.06 ) + temp_output_17_0_g76);
				float4 tex2DNode53_g76 = tex2D( _Caust, panner54_g76 );
				float3 appendResult55_g76 = (float3(tex2DNode53_g76.r , tex2DNode53_g76.g , tex2DNode53_g76.b));
				float2 panner57_g76 = ( 1.0 * _Time.y * float2( -0.05,-0.07 ) + temp_output_17_0_g76);
				float4 tex2DNode58_g76 = tex2D( _Caust, panner57_g76 );
				float3 appendResult59_g76 = (float3(tex2DNode58_g76.r , tex2DNode58_g76.g , tex2DNode58_g76.b));
				float3 appendResult44_g76 = (float3((min( appendResult36_g76 , appendResult39_g76 )).x , (min( appendResult47_g76 , appendResult51_g76 )).y , (min( appendResult55_g76 , appendResult59_g76 )).z));
				float4 appendResult8_g76 = (float4(appendResult44_g76 , 1.0));
				float4 smoothstepResult610 = smoothstep( float4( 0,0,0,0 ) , temp_cast_24 , appendResult8_g76);
				float4 temp_output_616_0 = ( saturate( smoothstepResult610 ) * _depthMask614 );
				float4 _caustics626 = temp_output_616_0;
				float4 blendOpSrc627 = ( _colors292 + _foam259 );
				float4 blendOpDest627 = _caustics626;
				float4 lerpResult692 = lerp( ( saturate( ( 1.0 - ( 1.0 - blendOpSrc627 ) * ( 1.0 - blendOpDest627 ) ) )) , float4( 0,0,0,0 ) , _combinedLines687);
				float4 _emission894 = lerpResult692;
				

				float3 BaseColor = _endColor892.rgb;
				float3 Normal = _endNormals896.rgb;
				float3 Emission = _emission894.xyz;
				float3 Specular = 0.5;
				float Metallic = 0;
				float Smoothness = 0.5;
				float Occlusion = 1;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.clipPos.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = WorldPosition;
				inputData.positionCS = IN.clipPos;
				inputData.shadowCoord = ShadowCoords;

				#ifdef _NORMALMAP
					#if _NORMAL_DROPOFF_TS
						inputData.normalWS = TransformTangentToWorld(Normal, half3x3( WorldTangent, WorldBiTangent, WorldNormal ));
					#elif _NORMAL_DROPOFF_OS
						inputData.normalWS = TransformObjectToWorldNormal(Normal);
					#elif _NORMAL_DROPOFF_WS
						inputData.normalWS = Normal;
					#endif
				#else
					inputData.normalWS = WorldNormal;
				#endif

				inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				inputData.viewDirectionWS = SafeNormalize( WorldViewDirection );

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#else
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, IN.dynamicLightmapUV.xy, SH, inputData.normalWS);
					#else
						inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS );
					#endif
				#endif

				inputData.normalizedScreenSpaceUV = NormalizedScreenSpaceUV;
				inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = IN.dynamicLightmapUV.xy;
						#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = IN.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
				#endif

				#ifdef _DBUFFER
					ApplyDecal(IN.clipPos,
						BaseColor,
						Specular,
						inputData.normalWS,
						Metallic,
						Occlusion,
						Smoothness);
				#endif

				BRDFData brdfData;
				InitializeBRDFData
				(BaseColor, Metallic, Specular, Smoothness, Alpha, brdfData);

				Light mainLight = GetMainLight(inputData.shadowCoord, inputData.positionWS, inputData.shadowMask);
				half4 color;
				MixRealtimeAndBakedGI(mainLight, inputData.normalWS, inputData.bakedGI, inputData.shadowMask);
				color.rgb = GlobalIllumination(brdfData, inputData.bakedGI, Occlusion, inputData.positionWS, inputData.normalWS, inputData.viewDirectionWS);
				color.a = Alpha;

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return BRDFDataToGbuffer(brdfData, inputData, Smoothness, Emission + color.rgb, Occlusion);
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "SceneSelectionPass"
			Tags { "LightMode"="SceneSelectionPass" }

			Cull Off
			AlphaToMask Off

			HLSLPROGRAM

			#define ASE_TESSELLATION 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_DISTANCE_TESSELLATION
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120110


			#pragma vertex vert
			#pragma fragment frag

			#define SCENESELECTIONPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Horizon;
			float4 _ShallowColor;
			float4 _DeepColor;
			float4 _SpecularColor;
			float4 _FingerprintNormal_TexelSize;
			float4 _FoamClayColor;
			float4 _WaterNormal_ST;
			float _FingerprintStrength;
			float _Foam;
			float _NoiseSmoothness;
			float _ClayNormal;
			float _NoiseStrength;
			float _Float5;
			float _RippleCutoff;
			float _Speed;
			float _NoiseScale;
			float _Scale;
			float _WaveLength;
			float _HeightFoamH;
			float _WaterDepth;
			float _RefractionDistortion;
			float _LightingHardness;
			float _LightingSmoothness;
			float _NormalIntensity;
			float _NormalScale;
			float _Steepness;
			float _WaveSpeed;
			float _wavesZ;
			float _HorizonDistance;
			float _Caustics;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _FingerprintNormal;
			sampler2D _Roughness;
			sampler2D _GlobalEffectRT;


			
			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float4 temp_output_5_0_g79 = float4(0.02,-0.34,0.16,2.23);
				float2 appendResult19_g80 = (float2(cos( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g80 = normalize( appendResult19_g80 );
				float2 d26_g80 = normalizeResult15_g80;
				float temp_output_3_0_g79 = _WaveLength;
				float k25_g80 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float _0waterMover900 = _wavesZ;
				float3 appendResult758 = (float3(ase_worldPos.x , ase_worldPos.y , ( ase_worldPos.z + _0waterMover900 )));
				float3 temp_output_1_0_g79 = appendResult758;
				float dotResult29_g80 = dot( d26_g80 , (temp_output_1_0_g79).xz );
				float temp_output_4_0_g79 = _WaveSpeed;
				float mulTime33_g80 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g80 = ( k25_g80 * ( dotResult29_g80 - mulTime33_g80 ) );
				float temp_output_2_0_g79 = _Steepness;
				float temp_output_3_0_g80 = temp_output_2_0_g79;
				float a37_g80 = ( temp_output_3_0_g80 / k25_g80 );
				float temp_output_91_0_g80 = ( cos( f34_g80 ) * a37_g80 );
				float3 appendResult86_g80 = (float3(( (d26_g80).x * temp_output_91_0_g80 ) , ( a37_g80 * sin( f34_g80 ) ) , ( temp_output_91_0_g80 * (d26_g80).y )));
				float2 appendResult19_g81 = (float2(cos( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g81 = normalize( appendResult19_g81 );
				float2 d26_g81 = normalizeResult15_g81;
				float k25_g81 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g81 = dot( d26_g81 , (temp_output_1_0_g79).xz );
				float mulTime33_g81 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g81 = ( k25_g81 * ( dotResult29_g81 - mulTime33_g81 ) );
				float temp_output_3_0_g81 = temp_output_2_0_g79;
				float a37_g81 = ( temp_output_3_0_g81 / k25_g81 );
				float temp_output_91_0_g81 = ( cos( f34_g81 ) * a37_g81 );
				float3 appendResult86_g81 = (float3(( (d26_g81).x * temp_output_91_0_g81 ) , ( a37_g81 * sin( f34_g81 ) ) , ( temp_output_91_0_g81 * (d26_g81).y )));
				float2 appendResult19_g83 = (float2(cos( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g83 = normalize( appendResult19_g83 );
				float2 d26_g83 = normalizeResult15_g83;
				float k25_g83 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g83 = dot( d26_g83 , (temp_output_1_0_g79).xz );
				float mulTime33_g83 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g83 = ( k25_g83 * ( dotResult29_g83 - mulTime33_g83 ) );
				float temp_output_3_0_g83 = temp_output_2_0_g79;
				float a37_g83 = ( temp_output_3_0_g83 / k25_g83 );
				float temp_output_91_0_g83 = ( cos( f34_g83 ) * a37_g83 );
				float3 appendResult86_g83 = (float3(( (d26_g83).x * temp_output_91_0_g83 ) , ( a37_g83 * sin( f34_g83 ) ) , ( temp_output_91_0_g83 * (d26_g83).y )));
				float2 appendResult19_g82 = (float2(cos( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g82 = normalize( appendResult19_g82 );
				float2 d26_g82 = normalizeResult15_g82;
				float k25_g82 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g82 = dot( d26_g82 , (temp_output_1_0_g79).xz );
				float mulTime33_g82 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g82 = ( k25_g82 * ( dotResult29_g82 - mulTime33_g82 ) );
				float temp_output_3_0_g82 = temp_output_2_0_g79;
				float a37_g82 = ( temp_output_3_0_g82 / k25_g82 );
				float temp_output_91_0_g82 = ( cos( f34_g82 ) * a37_g82 );
				float3 appendResult86_g82 = (float3(( (d26_g82).x * temp_output_91_0_g82 ) , ( a37_g82 * sin( f34_g82 ) ) , ( temp_output_91_0_g82 * (d26_g82).y )));
				float3 worldToObj485 = mul( GetWorldToObjectMatrix(), float4( ( ase_worldPos + ( ( appendResult86_g80 + appendResult86_g81 ) + ( appendResult86_g83 + appendResult86_g82 ) ) ), 1 ) ).xyz;
				float3 waveDisplacement493 = worldToObj485;
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = waveDisplacement493;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				o.clipPos = TransformWorldToHClip(positionWS);

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				

				surfaceDescription.Alpha = 1;
				surfaceDescription.AlphaClipThreshold = 0.5;

				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
					clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = 0;

				#ifdef SCENESELECTIONPASS
					outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				#elif defined(SCENEPICKINGPASS)
					outColor = _SelectionID;
				#endif

				return outColor;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ScenePickingPass"
			Tags { "LightMode"="Picking" }

			AlphaToMask Off

			HLSLPROGRAM

			#define ASE_TESSELLATION 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_DISTANCE_TESSELLATION
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120110


			#pragma vertex vert
			#pragma fragment frag

		    #define SCENEPICKINGPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Horizon;
			float4 _ShallowColor;
			float4 _DeepColor;
			float4 _SpecularColor;
			float4 _FingerprintNormal_TexelSize;
			float4 _FoamClayColor;
			float4 _WaterNormal_ST;
			float _FingerprintStrength;
			float _Foam;
			float _NoiseSmoothness;
			float _ClayNormal;
			float _NoiseStrength;
			float _Float5;
			float _RippleCutoff;
			float _Speed;
			float _NoiseScale;
			float _Scale;
			float _WaveLength;
			float _HeightFoamH;
			float _WaterDepth;
			float _RefractionDistortion;
			float _LightingHardness;
			float _LightingSmoothness;
			float _NormalIntensity;
			float _NormalScale;
			float _Steepness;
			float _WaveSpeed;
			float _wavesZ;
			float _HorizonDistance;
			float _Caustics;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _FingerprintNormal;
			sampler2D _Roughness;
			sampler2D _GlobalEffectRT;


			
			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float4 temp_output_5_0_g79 = float4(0.02,-0.34,0.16,2.23);
				float2 appendResult19_g80 = (float2(cos( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).x * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g80 = normalize( appendResult19_g80 );
				float2 d26_g80 = normalizeResult15_g80;
				float temp_output_3_0_g79 = _WaveLength;
				float k25_g80 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float _0waterMover900 = _wavesZ;
				float3 appendResult758 = (float3(ase_worldPos.x , ase_worldPos.y , ( ase_worldPos.z + _0waterMover900 )));
				float3 temp_output_1_0_g79 = appendResult758;
				float dotResult29_g80 = dot( d26_g80 , (temp_output_1_0_g79).xz );
				float temp_output_4_0_g79 = _WaveSpeed;
				float mulTime33_g80 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g80 = ( k25_g80 * ( dotResult29_g80 - mulTime33_g80 ) );
				float temp_output_2_0_g79 = _Steepness;
				float temp_output_3_0_g80 = temp_output_2_0_g79;
				float a37_g80 = ( temp_output_3_0_g80 / k25_g80 );
				float temp_output_91_0_g80 = ( cos( f34_g80 ) * a37_g80 );
				float3 appendResult86_g80 = (float3(( (d26_g80).x * temp_output_91_0_g80 ) , ( a37_g80 * sin( f34_g80 ) ) , ( temp_output_91_0_g80 * (d26_g80).y )));
				float2 appendResult19_g81 = (float2(cos( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).y * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g81 = normalize( appendResult19_g81 );
				float2 d26_g81 = normalizeResult15_g81;
				float k25_g81 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g81 = dot( d26_g81 , (temp_output_1_0_g79).xz );
				float mulTime33_g81 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g81 = ( k25_g81 * ( dotResult29_g81 - mulTime33_g81 ) );
				float temp_output_3_0_g81 = temp_output_2_0_g79;
				float a37_g81 = ( temp_output_3_0_g81 / k25_g81 );
				float temp_output_91_0_g81 = ( cos( f34_g81 ) * a37_g81 );
				float3 appendResult86_g81 = (float3(( (d26_g81).x * temp_output_91_0_g81 ) , ( a37_g81 * sin( f34_g81 ) ) , ( temp_output_91_0_g81 * (d26_g81).y )));
				float2 appendResult19_g83 = (float2(cos( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).z * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g83 = normalize( appendResult19_g83 );
				float2 d26_g83 = normalizeResult15_g83;
				float k25_g83 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g83 = dot( d26_g83 , (temp_output_1_0_g79).xz );
				float mulTime33_g83 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g83 = ( k25_g83 * ( dotResult29_g83 - mulTime33_g83 ) );
				float temp_output_3_0_g83 = temp_output_2_0_g79;
				float a37_g83 = ( temp_output_3_0_g83 / k25_g83 );
				float temp_output_91_0_g83 = ( cos( f34_g83 ) * a37_g83 );
				float3 appendResult86_g83 = (float3(( (d26_g83).x * temp_output_91_0_g83 ) , ( a37_g83 * sin( f34_g83 ) ) , ( temp_output_91_0_g83 * (d26_g83).y )));
				float2 appendResult19_g82 = (float2(cos( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) ) , sin( ( ( ( (temp_output_5_0_g79).w * 2.0 ) - 1.0 ) * PI ) )));
				float2 normalizeResult15_g82 = normalize( appendResult19_g82 );
				float2 d26_g82 = normalizeResult15_g82;
				float k25_g82 = ( ( 2.0 * PI ) / temp_output_3_0_g79 );
				float dotResult29_g82 = dot( d26_g82 , (temp_output_1_0_g79).xz );
				float mulTime33_g82 = _TimeParameters.x * temp_output_4_0_g79;
				float f34_g82 = ( k25_g82 * ( dotResult29_g82 - mulTime33_g82 ) );
				float temp_output_3_0_g82 = temp_output_2_0_g79;
				float a37_g82 = ( temp_output_3_0_g82 / k25_g82 );
				float temp_output_91_0_g82 = ( cos( f34_g82 ) * a37_g82 );
				float3 appendResult86_g82 = (float3(( (d26_g82).x * temp_output_91_0_g82 ) , ( a37_g82 * sin( f34_g82 ) ) , ( temp_output_91_0_g82 * (d26_g82).y )));
				float3 worldToObj485 = mul( GetWorldToObjectMatrix(), float4( ( ase_worldPos + ( ( appendResult86_g80 + appendResult86_g81 ) + ( appendResult86_g83 + appendResult86_g82 ) ) ), 1 ) ).xyz;
				float3 waveDisplacement493 = worldToObj485;
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = waveDisplacement493;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				o.clipPos = TransformWorldToHClip(positionWS);

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				

				surfaceDescription.Alpha = 1;
				surfaceDescription.AlphaClipThreshold = 0.5;

				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
						clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = 0;

				#ifdef SCENESELECTIONPASS
					outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				#elif defined(SCENEPICKINGPASS)
					outColor = _SelectionID;
				#endif

				return outColor;
			}

			ENDHLSL
		}
		
	}
	
	CustomEditor "UnityEditor.ShaderGraphLitGUI"
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Fallback Off
}
/*ASEBEGIN
Version=19201
Node;AmplifyShaderEditor.CommentaryNode;884;-1719.503,-1202.968;Inherit;False;990.3203;396.0302;Comment;6;111;229;227;451;259;655;FOAM;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;736;-1237.674,3150.315;Inherit;False;938.5181;561.7251;Comment;9;744;745;740;742;739;743;738;737;735;Interaction Offset;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;690;684.5692,-1306.548;Inherit;False;430.7997;266.8999;Comment;1;892;Mask Foam Out;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;579;236.8865,-1360.073;Inherit;False;888.1486;677.2177;Blend Everything;20;365;439;688;456;294;627;628;574;575;540;262;503;693;689;690;691;694;696;692;894;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;653;1755.522,2373.734;Inherit;False;1811.379;948.0991;;10;656;657;665;668;675;682;683;686;695;701;FOAM EXTRUSION;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;668;1783.1,2960.433;Inherit;False;503.5037;340.7178;Comment;3;664;661;667;Mask Out;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;625;-918.8427,-1963.874;Inherit;False;967.5317;606.1111;Comment;18;626;632;629;631;616;630;612;592;611;610;609;585;624;623;589;622;586;595;CAUSTICS;1,0.495283,0.9491565,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;151;-1765.234,-2513.942;Inherit;False;1371.44;458.1781;Normals;11;210;24;17;23;48;19;22;324;325;21;578;NORMALS;0,0.1354229,0.7924528,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;578;-742.6724,-2434.264;Inherit;False;361.2695;339.4417;Add Normals;4;660;561;555;563;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;504;-1708.536,-705.5195;Inherit;False;876.3251;243.5325;Comment;5;551;500;887;501;888;RenderTextureRipples;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;492;677.7833,-2628.422;Inherit;False;1406.787;537.3198;Comment;18;841;844;839;847;493;485;484;840;773;827;758;757;483;491;748;461;463;901;Waves;0.5707547,0.8221696,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;433;-3322.795,-2535.901;Inherit;False;1522.495;845.9672;LIGHT;11;438;362;387;435;436;361;360;432;358;357;434;LIGHT;1,0.9523678,0.514151,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;434;-3307.795,-2492.778;Inherit;False;768.0571;563.3;GetMainLight;11;355;366;430;383;354;385;367;370;371;369;384;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;263;3069.204,-1425.676;Inherit;False;442.3435;202.542;Time;4;231;230;752;900;Variables;1,0.7807935,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;244;2900.057,-1175.442;Inherit;False;620.6476;354.5237;Output;14;203;895;897;420;893;428;427;426;425;424;423;422;421;419;OUTPUT;0.1302564,1,0.1084906,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;152;-3320.139,-1637.946;Inherit;False;610.9382;360.995;Depth Fade;11;614;279;280;278;277;274;276;275;245;291;6;DEPTH;0.1037736,0.1037736,0.1037736,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;150;-2665.927,-1612.743;Inherit;False;675.7673;299.4336;Refraction;6;65;246;242;254;97;290;REFRACTION;0.6705883,0.3746997,0.2941177,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;159;-1722.133,-1977.598;Inherit;False;707.4646;642.0154;Colors;11;321;12;11;288;292;289;13;320;316;322;873;COLORS;1,0.25,0.25,1;0;0
Node;AmplifyShaderEditor.LerpOp;13;-1475.185,-1805.826;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;-1236.879,-1898.309;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;320;-1355.244,-1604.204;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;321;-1651.538,-1583.347;Inherit;False;Property;_Horizon;Horizon;17;1;[HDR];Create;True;0;0;0;False;0;False;0,1,0.2901961,1;0,0.9245283,0.1766248,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;12;-1714.915,-1767.268;Float;False;Property;_DeepColor;Deep Color;16;1;[HDR];Create;True;0;0;0;False;0;False;0,0.1748825,1.907273,1;0,0.2533045,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;11;-1690.946,-1937.098;Float;False;Property;_ShallowColor;Shallow Color;15;1;[HDR];Create;True;0;0;0;False;0;False;0.2509804,1,0.9529412,1;0,0.004176185,0.4156863,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;316;-1431.313,-1500.527;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;322;-1704.786,-1406.996;Inherit;False;Property;_HorizonDistance;Horizon Distance;18;0;Create;True;0;0;0;False;0;False;4;5.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;292;-1220.896,-1712.042;Inherit;False;_colors;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;419;3266.728,-1077.973;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;0;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;421;2376.702,-762.5889;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;422;2376.702,-762.5889;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;True;1;LightMode=DepthOnly;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;423;2376.702,-762.5889;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;424;2376.702,-762.5889;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;425;2376.702,-762.5889;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthNormals;0;6;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=DepthNormalsOnly;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;426;2376.702,-762.5889;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;GBuffer;0;7;GBuffer;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalGBuffer;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;427;2376.702,-762.5889;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;SceneSelectionPass;0;8;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;428;2376.702,-762.5889;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ScenePickingPass;0;9;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;355;-3267.659,-2454.778;Inherit;False;210;_normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;430;-3101.888,-2443.292;Inherit;False;URP Tangent To World Normal;-1;;21;e73075222d6e6944aa84a1f1cd458852;0;1;14;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;383;-3034.33,-2362.543;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;354;-3225.546,-2180.538;Inherit;False;Property;_LightingSmoothness;LightingSmoothness;28;0;Create;True;0;0;0;False;0;False;0;0.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;384;-2869.638,-2381.802;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;369;-3038.071,-2272.458;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;370;-2995.929,-2140.488;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;371;-3171.957,-2058.478;Inherit;False;Constant;_Float3;Float 3;27;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Exp2OpNode;367;-2891.239,-2249.403;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;385;-2750.738,-2330.703;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;357;-2330.608,-2322.907;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;358;-2468.407,-2271.007;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;432;-2492.101,-2160.301;Inherit;False;Property;_LightingHardness;Lighting Hardness;29;0;Create;True;0;0;0;False;0;False;0;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;360;-2142.657,-2289.365;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;361;-1977.535,-2244.917;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;366;-3297.795,-2369.295;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;436;-3272.739,-1879.019;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;435;-2965.945,-1885.309;Inherit;False;SRP Additional Light;-1;;22;6c86746ad131a0a408ca599df5f40861;7,6,2,9,1,23,0,27,0,25,0,24,0,26,0;6;2;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;15;FLOAT3;0,0,0;False;14;FLOAT3;1,1,1;False;18;FLOAT;0.5;False;32;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;362;-2408.048,-2005.908;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;438;-2196.564,-1983.58;Inherit;False;_lights;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;463;1124.705,-2578.422;Inherit;False;Property;_Steepness;Steepness;33;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;461;923.3011,-2565.171;Inherit;False;Property;_WaveLength;WaveLength;32;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;387;-2286.833,-2483.85;Inherit;False;Property;_SpecularColor;Specular Color;30;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;290;-2413.555,-1396.498;Inherit;False;_refractUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;595;-366.2147,-1898.952;Inherit;False;Constant;_Intensity;Intensity;23;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;667;1829.601,3108.151;Inherit;False;Constant;_nrmClr;nrmClr;25;0;Create;True;0;0;0;False;0;False;0,0,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;656;2045.017,2448.03;Inherit;True;Normal From Height;-1;;53;1942fe2c5f1a1f94881a33d532e4afeb;0;2;20;FLOAT;0;False;110;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;664;2103.604,3057.985;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;682;1989.402,2802.115;Inherit;False;Constant;_Float8;Float 8;33;0;Create;True;0;0;0;False;0;False;125;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;704;1442.609,2425.74;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;658;1267.571,2768.449;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;657;1910.688,2702.243;Inherit;False;Property;_ClaySpeed;ClaySpeed;45;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;683;2161.567,2700.989;Inherit;False;ClayFunc;5;;69;7c6b04f1a66725341a1e0b619273757b;0;2;33;FLOAT;-0.1;False;27;FLOAT2;0,0;False;2;FLOAT3;0;FLOAT;24
Node;AmplifyShaderEditor.LerpOp;686;2604.361,2887.53;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;695;2837.07,2686.656;Inherit;False;_clayRough;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;674;1581.26,2491.279;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.06;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;675;2502.441,2584.436;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;701;1834.51,2564.505;Inherit;False;Property;_ClayNormal;ClayNormal;44;0;Create;True;0;0;0;False;0;False;125;125;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;711;2605.829,3710.473;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;687;1449.012,2654.045;Inherit;False;_combinedLines;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PosVertexDataNode;706;2364.972,3475.96;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;730;2324.683,4017.529;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;731;2424.613,4217.009;Inherit;False;Property;_poff;poff;35;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;729;2159.289,3811.007;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;732;2813.437,3724.791;Inherit;False;shoreOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;734;1687.982,3408.826;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;735;-1187.674,3200.315;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;712;1734.409,4028.997;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;718;1901.102,4036.129;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;713;1541.01,4144.995;Inherit;False;Property;_Float9;Float 9;37;0;Create;True;0;0;0;False;0;False;1.58;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;728;2115.495,3999.197;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;719;1912.501,4193.528;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;2.14;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;717;1489.002,3977.63;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;737;-950.7675,3378.24;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;738;-784.0745,3385.372;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;743;-1196.175,3326.873;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;739;-1144.167,3494.238;Inherit;False;Property;_InteractionRippleHeight;InteractionRippleHeight;39;0;Create;True;0;0;0;False;0;False;1.58;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;742;-850.6756,3488.172;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;2.14;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;707;2038.848,3465.122;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;710;2298.761,3656.719;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;740;-604.7814,3365.34;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;745;-432.4178,3458.614;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;744;-713.1305,3202.017;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;746;1524.183,3475.128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;747;1440.983,3533.628;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;720;1622.003,4216.327;Inherit;False;Property;_pow;pow;36;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;748;974.6683,-2490.974;Inherit;False;Property;_WaveSpeed;WaveSpeed;38;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;491;727.7833,-2458.661;Inherit;False;Constant;_WaveDirections;WaveDirections;26;0;Create;True;0;0;0;False;0;False;0.02,-0.34,0.16,2.23;0.02,-0.34,0.16,2.23;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;822;2090.569,-151.1558;Inherit;False;Property;_Float5;Float 5;41;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;842;2087.527,-306.2209;Inherit;False;841;vertexNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;851;2497.479,-157.5602;Inherit;False;Screen;True;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;848;2495.479,-342.5602;Inherit;False;1;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;852;2696.479,-321.5602;Inherit;False;1;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;586;-905.8038,-1836.53;Inherit;False;290;_refractUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;622;-907.7047,-1921.806;Inherit;False;Reconstruct World Position From Depth;-1;;72;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;589;-857.6493,-1748.875;Inherit;False;ReconstructCustom;-1;;74;462234d94ac560642a3fa43390f4a89e;0;1;2;FLOAT2;0,0;False;1;FLOAT4;22
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;623;-634.0859,-1820.566;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;624;-887.8583,-1638.177;Inherit;False;Constant;_scaleee;scaleee;25;0;Create;True;0;0;0;False;0;False;0.04;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;585;-570.9141,-1895.769;Inherit;False;True;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;609;-437.6631,-1821.138;Inherit;True;Caustics;26;;76;58a054d48ea59ab49a9d260b02757f90;0;2;30;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SmoothstepOpNode;610;-172.69,-1859.437;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;611;-650.3433,-1689.109;Inherit;False;Property;_Caustics;Caustics;41;0;Create;True;0;0;0;False;0;False;0.05;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;592;-881.5311,-1561.527;Inherit;False;614;_depthMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;612;-178.0183,-1722.095;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;630;-854.0892,-1460.53;Inherit;False;254;_refraction;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;616;-583.1893,-1602.479;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;631;-537.7452,-1499.023;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;629;-317.6858,-1543.053;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;632;-183.8799,-1532.471;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;626;-174.1023,-1633.707;Inherit;False;_caustics;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-1688.107,-2176.968;Float;False;Property;_NormalIntensity;NormalIntensity;21;0;Create;True;0;0;0;False;0;False;0;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-1327.254,-2266.802;Inherit;True;Property;_WaterNormal;Water Normal;20;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;dd2fd2df93418444c8e280f1d34deeb5;9996cfa4c8fcb554cada1cd31435f085;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;24;-1023.367,-2395.078;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;563;-728.1024,-2279.112;Inherit;False;Constant;_Float1;Float 1;23;0;Create;True;0;0;0;False;0;False;50;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;561;-558.082,-2354.571;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-3312.67,-1592.406;Float;False;Property;_WaterDepth;Water Depth;19;0;Create;True;0;0;0;False;0;False;5;0.95;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;245;-3301.085,-1529.323;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;275;-3301.496,-1434.092;Inherit;False;Constant;_depthmask;depthmask;24;0;Create;True;0;0;0;False;0;False;0.07;0.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;276;-3289.669,-1372.969;Inherit;False;Constant;_depthmask2;depthmask2;25;0;Create;True;0;0;0;False;0;False;-0.05;-0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;274;-2952.875,-1606.828;Inherit;False;RefractedDepth;-1;;77;a7ac98564130b5e458f7cfe4ad7f0b0f;0;2;4;FLOAT2;0,0;False;5;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;277;-3047.088,-1525.968;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;278;-2906.216,-1505.085;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;280;-3068.913,-1359.403;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;279;-3061.478,-1423.092;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;614;-2922.339,-1373.29;Inherit;False;_depthMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;288;-1401.006,-1934.195;Inherit;False;254;_refraction;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;873;-1506.508,-1671.917;Inherit;False;614;_depthMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;291;-3118.439,-1615.596;Inherit;False;290;_refractUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;242;-2657.945,-1576.179;Inherit;False;210;_normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;246;-2633.958,-1516.015;Inherit;False;DepthMaskedRefraction;-1;;78;c805f061214177c42bca056464193f81;2,40,0,103,0;2;35;FLOAT3;0,0,0;False;37;FLOAT;0.02;False;1;FLOAT2;38
Node;AmplifyShaderEditor.RangedFloatNode;97;-2634.536,-1416.644;Float;False;Property;_RefractionDistortion;RefractionDistortion;22;0;Create;True;0;0;0;False;0;False;0.5;4.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;65;-2313.505,-1574.373;Float;False;Global;_WaterGrab;WaterGrab;-1;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;254;-2204.69,-1406.791;Inherit;False;_refraction;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;483;964.5964,-2391.959;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;757;991.8442,-2236.99;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;758;1216.255,-2301.811;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;827;1260.709,-2512.729;Inherit;False;CustomWaves;-1;;79;dfa0eb93ea606284ba22cf96e55e1659;0;5;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT4;0,0,0,0;False;2;FLOAT3;0;FLOAT3;6
Node;AmplifyShaderEditor.TransformDirectionNode;773;1502.463,-2592.708;Inherit;False;World;Object;True;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalVertexDataNode;840;1502.562,-2395.843;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;484;1444.307,-2235.868;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformPositionNode;485;1603.78,-2248.549;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;493;1822.632,-2192.16;Inherit;False;waveDisplacement;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformDirectionNode;847;1870.179,-2351.605;Inherit;False;Object;Tangent;True;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;839;1712.558,-2550.121;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;844;1703.494,-2395.282;Inherit;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;841;1856.769,-2478.819;Inherit;False;vertexNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-1669.503,-1152.968;Float;False;Property;_Foam;Foam;23;0;Create;True;0;0;0;False;0;False;0;20;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;229;-1568.501,-1059.237;Inherit;False;231;_speedVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;227;-1565.994,-992.759;Inherit;False;210;_normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;259;-971.1831,-1015.221;Inherit;False;_foam;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;655;-983.2766,-1087.741;Inherit;False;_shoreLines;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;501;-1668.064,-649.4852;Inherit;False;Property;_RippleCutoff;Ripple Cutoff;42;0;Create;True;0;0;0;False;0;False;0.6;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;887;-1483.903,-662.5134;Inherit;False;InteractiveRipples;0;;92;f0b290d6109da814cb23f097610e9998;0;1;11;FLOAT;0;False;3;FLOAT;14;FLOAT;0;FLOAT3;12
Node;AmplifyShaderEditor.RegisterLocalVarNode;857;-691.3502,2703.507;Inherit;False;_trailVoronoi;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;654;1022.648,2704.201;Inherit;False;655;_shoreLines;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;889;1065.663,2798.501;Inherit;False;500;_rt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;891;-1342.689,3207.149;Inherit;False;888;_rtSmooth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;551;-1133.635,-546.8933;Inherit;False;_rTNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;500;-1106.929,-612.6193;Inherit;False;_rt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;888;-1102.637,-670.596;Inherit;False;_rtSmooth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;230;3079.248,-1380.116;Inherit;False;Property;_Speed;Speed;24;0;Create;True;0;0;0;False;0;False;1;0.96;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;231;3227.613,-1385.75;Inherit;False;_speedVar;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;862;1955.123,351.5381;Inherit;False;Constant;_Color1;Color 1;36;0;Create;True;0;0;0;False;0;False;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;858;1945.496,576.8754;Inherit;False;857;_trailVoronoi;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;865;2178.848,526.8547;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;864;2247.846,392.4288;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;503;258.6988,-975.7738;Inherit;False;500;_rt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;262;255.6996,-1060.165;Inherit;False;259;_foam;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;540;456.6169,-955.7615;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;575;289.2302,-832.5002;Inherit;False;Property;_blend;blend;43;0;Create;True;0;0;0;False;0;False;50;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LayeredBlendNode;574;569.498,-969.6498;Inherit;False;6;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;628;274.747,-766.7018;Inherit;False;626;_caustics;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BlendOpsNode;627;492.9281,-823.5372;Inherit;False;Screen;True;3;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;294;259.4579,-1219.744;Inherit;False;292;_colors;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;456;489.006,-1146.685;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;688;605.9588,-1074.926;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;439;296.4106,-1312.989;Inherit;False;438;_lights;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;365;496.2514,-1258.164;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;693;701.0981,-1270.384;Inherit;False;Property;_FoamClayColor;FoamClayColor;34;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;691;700.6939,-1109.806;Inherit;False;687;_combinedLines;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;689;916.3807,-1236.817;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;892;919.0828,-1112.019;Inherit;False;_endColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;696;737.122,-1026.542;Inherit;False;695;_clayRough;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;694;913.5442,-993.5235;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;692;771.8942,-863.6965;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;894;910.6263,-782.2219;Inherit;False;_emission;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;666;1780.066,-209.9686;Inherit;False;665;_normalsMitRipples;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;893;2953.533,-1135.66;Inherit;False;892;_endColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;420;3272.366,-1130.12;Float;False;True;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;Pirate Pigeons/Ocean;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;1;Forward;20;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForwardOnly;False;False;0;;0;0;Standard;41;Workflow;1;638304680135930730;Surface;0;0;  Refraction Model;0;0;  Blend;0;0;Two Sided;1;638276158033233846;Fragment Normal Space,InvertActionOnDeselection;0;638305067323297848;Forward Only;1;0;Transmission;0;0;  Transmission Shadow;0.5,False,;0;Translucency;0;638305094152159300;  Translucency Strength;1,False,;0;  Normal Distortion;0.5,False,;0;  Scattering;2,False,;0;  Direct;0.9,False,;0;  Ambient;0.1,False,;0;  Shadow;0.5,False,;0;Cast Shadows;1;0;  Use Shadow Threshold;0;0;Receive Shadows;1;0;GPU Instancing;1;0;LOD CrossFade;1;0;Built-in Fog;0;638304829435369808;_FinalColorxAlpha;0;0;Meta Pass;1;0;Override Baked GI;0;0;Extra Pre Pass;0;0;DOTS Instancing;0;0;Tessellation;1;638285590814277039;  Phong;0;638285590049439916;  Strength;0.5,False,;0;  Type;1;638305094310111880;  Tess;16,False,;638285588816852155;  Min;10,False,;0;  Max;25,False,;0;  Edge Length;16,False,;638285590834880536;  Max Displacement;25,False,;0;Write Depth;0;638276157149518352;  Early Z;0;0;Vertex Position,InvertActionOnDeselection;1;638305072344051975;Debug Display;0;0;Clear Coat;0;0;0;10;False;True;True;True;True;True;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;733;1760.261,-539.6539;Inherit;False;732;shoreOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;853;2291.407,6.942524;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;897;2956.352,-1083.513;Inherit;False;896;_endNormals;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;895;2949.306,-1020.09;Inherit;False;894;_emission;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;203;2944.123,-943.905;Inherit;False;493;waveDisplacement;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;210;-990.7297,-2248.064;Inherit;False;_normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;325;-1753.375,-2363.042;Inherit;False;Property;_NormalScale;NormalScale;25;0;Create;True;0;0;0;False;0;False;0;15.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;324;-1730.112,-2289.407;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;22;-1530.094,-2476.134;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.03,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;19;-1534.143,-2343.768;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.04,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;555;-732.2781,-2369.741;Inherit;False;551;_rTNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;900;3249.149,-1314.659;Inherit;False;_0waterMover;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;901;761.0088,-2228.917;Inherit;False;900;_0waterMover;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;752;3079.689,-1302.913;Inherit;False;Property;_wavesZ;Water Mover;40;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;907;-1593.94,-2637.296;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;905;-1756.454,-2659.091;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;906;-2049.454,-2624.091;Inherit;False;Constant;_wavemovespeednormals;wavemovespeednormals;34;0;Create;True;0;0;0;False;0;False;0.05;-0.003;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;903;-1922.425,-2740.688;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;902;-2141.413,-2694.392;Inherit;False;900;_0waterMover;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;909;-2074.94,-2761.296;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-1759.018,-2478.027;Inherit;False;0;17;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;23;-1321.313,-2470.052;Inherit;True;Property;_Normal2;Normal2;20;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Instance;17;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;660;-688.8238,-2197.259;Inherit;False;_combinedNormalsRT;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;661;1828.1,3026.433;Inherit;False;660;_combinedNormalsRT;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;665;2802.465,2889.449;Inherit;False;_normalsMitRipples;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;896;2563.84,29.58606;Inherit;False;_endNormals;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;703;1126.466,2445.138;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;890;1163.826,2322.694;Inherit;False;888;_rtSmooth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;451;-1573.358,-919.9382;Inherit;False;Property;_HeightFoamH;HeightFoamH;31;0;Create;True;0;0;0;False;0;False;0;1.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;910;-1319.509,-1070.562;Inherit;False;FoamFunction;2;;93;48aea8bc384a51b498a76f24f80583e7;0;4;49;FLOAT;0;False;12;FLOAT;1;False;13;FLOAT3;0,0,0;False;48;FLOAT;0;False;2;FLOAT4;0;COLOR;85
WireConnection;13;0;12;0
WireConnection;13;1;11;0
WireConnection;13;2;873;0
WireConnection;289;0;288;0
WireConnection;289;1;13;0
WireConnection;320;0;289;0
WireConnection;320;1;321;0
WireConnection;320;2;316;0
WireConnection;316;3;322;0
WireConnection;292;0;320;0
WireConnection;430;14;355;0
WireConnection;383;0;366;0
WireConnection;383;1;430;0
WireConnection;384;0;383;0
WireConnection;369;0;354;0
WireConnection;370;0;369;0
WireConnection;370;1;371;0
WireConnection;367;0;370;0
WireConnection;385;0;384;0
WireConnection;385;1;367;0
WireConnection;357;0;385;0
WireConnection;357;1;358;0
WireConnection;357;2;432;0
WireConnection;358;1;385;0
WireConnection;360;0;357;0
WireConnection;360;1;387;0
WireConnection;361;0;360;0
WireConnection;361;1;387;4
WireConnection;435;11;430;0
WireConnection;435;15;436;0
WireConnection;435;14;387;0
WireConnection;435;18;354;0
WireConnection;362;0;361;0
WireConnection;362;1;435;0
WireConnection;438;0;362;0
WireConnection;290;0;246;38
WireConnection;656;20;674;0
WireConnection;656;110;701;0
WireConnection;664;0;661;0
WireConnection;664;1;667;0
WireConnection;664;2;687;0
WireConnection;704;0;890;0
WireConnection;704;1;703;0
WireConnection;658;0;654;0
WireConnection;658;1;889;0
WireConnection;683;27;682;0
WireConnection;686;0;664;0
WireConnection;686;1;675;0
WireConnection;686;2;687;0
WireConnection;695;0;683;24
WireConnection;674;0;704;0
WireConnection;675;0;656;40
WireConnection;675;1;683;0
WireConnection;711;0;706;0
WireConnection;711;1;710;0
WireConnection;687;0;658;0
WireConnection;730;0;728;0
WireConnection;730;1;720;0
WireConnection;730;2;731;0
WireConnection;729;0;728;0
WireConnection;732;0;711;0
WireConnection;734;0;747;0
WireConnection;735;0;891;0
WireConnection;712;0;717;2
WireConnection;712;1;713;0
WireConnection;718;0;712;0
WireConnection;728;0;734;0
WireConnection;728;1;719;0
WireConnection;719;0;718;0
WireConnection;719;1;720;0
WireConnection;737;0;743;2
WireConnection;737;1;739;0
WireConnection;738;0;737;0
WireConnection;742;0;738;0
WireConnection;710;0;707;0
WireConnection;710;1;728;0
WireConnection;740;0;735;0
WireConnection;740;1;742;0
WireConnection;745;0;744;0
WireConnection;745;1;740;0
WireConnection;746;0;674;0
WireConnection;747;0;704;0
WireConnection;851;0;842;0
WireConnection;851;1;666;0
WireConnection;851;2;822;0
WireConnection;848;0;842;0
WireConnection;848;1;666;0
WireConnection;852;0;848;0
WireConnection;852;1;666;0
WireConnection;589;2;586;0
WireConnection;623;0;622;0
WireConnection;623;1;624;0
WireConnection;585;0;623;0
WireConnection;609;30;585;0
WireConnection;609;1;595;0
WireConnection;610;0;609;0
WireConnection;610;2;611;0
WireConnection;612;0;610;0
WireConnection;616;0;612;0
WireConnection;616;1;592;0
WireConnection;631;0;592;0
WireConnection;631;1;630;0
WireConnection;629;0;616;0
WireConnection;629;1;631;0
WireConnection;632;0;629;0
WireConnection;626;0;616;0
WireConnection;17;1;19;0
WireConnection;17;5;48;0
WireConnection;24;0;23;0
WireConnection;24;1;17;0
WireConnection;561;0;555;0
WireConnection;561;1;210;0
WireConnection;561;2;563;0
WireConnection;245;0;6;0
WireConnection;274;4;291;0
WireConnection;274;5;6;0
WireConnection;277;0;274;0
WireConnection;277;1;275;0
WireConnection;278;0;277;0
WireConnection;278;1;276;0
WireConnection;280;0;279;0
WireConnection;279;0;278;0
WireConnection;614;0;280;0
WireConnection;246;35;242;0
WireConnection;246;37;97;0
WireConnection;65;0;246;38
WireConnection;254;0;65;0
WireConnection;757;0;483;3
WireConnection;757;1;901;0
WireConnection;758;0;483;1
WireConnection;758;1;483;2
WireConnection;758;2;757;0
WireConnection;827;1;758;0
WireConnection;827;2;463;0
WireConnection;827;3;461;0
WireConnection;827;4;748;0
WireConnection;827;5;491;0
WireConnection;773;0;827;6
WireConnection;484;0;483;0
WireConnection;484;1;827;0
WireConnection;485;0;484;0
WireConnection;493;0;485;0
WireConnection;847;0;844;0
WireConnection;839;0;773;0
WireConnection;839;1;840;0
WireConnection;844;0;839;0
WireConnection;841;0;847;0
WireConnection;259;0;910;85
WireConnection;655;0;910;0
WireConnection;887;11;501;0
WireConnection;551;0;887;12
WireConnection;500;0;887;0
WireConnection;888;0;887;14
WireConnection;231;0;230;0
WireConnection;865;0;858;0
WireConnection;864;1;862;0
WireConnection;864;2;865;0
WireConnection;540;0;262;0
WireConnection;540;1;503;0
WireConnection;574;0;575;0
WireConnection;574;1;294;0
WireConnection;574;2;540;0
WireConnection;627;0;688;0
WireConnection;627;1;628;0
WireConnection;456;0;294;0
WireConnection;456;1;262;0
WireConnection;456;2;503;0
WireConnection;688;0;294;0
WireConnection;688;1;262;0
WireConnection;365;0;439;0
WireConnection;365;1;294;0
WireConnection;689;0;365;0
WireConnection;689;1;693;0
WireConnection;689;2;691;0
WireConnection;892;0;689;0
WireConnection;694;1;696;0
WireConnection;694;2;691;0
WireConnection;692;0;627;0
WireConnection;692;2;691;0
WireConnection;894;0;692;0
WireConnection;420;0;893;0
WireConnection;420;1;897;0
WireConnection;420;2;895;0
WireConnection;420;8;203;0
WireConnection;853;0;848;0
WireConnection;853;1;666;0
WireConnection;853;2;822;0
WireConnection;210;0;24;0
WireConnection;324;0;21;0
WireConnection;324;1;325;0
WireConnection;22;0;907;0
WireConnection;19;0;907;0
WireConnection;900;0;752;0
WireConnection;907;0;905;0
WireConnection;907;1;324;0
WireConnection;905;0;903;0
WireConnection;905;1;906;0
WireConnection;903;1;909;0
WireConnection;909;0;902;0
WireConnection;23;1;22;0
WireConnection;23;5;48;0
WireConnection;660;0;561;0
WireConnection;665;0;686;0
WireConnection;896;0;853;0
WireConnection;910;49;111;0
WireConnection;910;12;229;0
WireConnection;910;13;227;0
WireConnection;910;48;451;0
ASEEND*/
//CHKSM=165925782544AE2836C6918D9CB4381F62E53481