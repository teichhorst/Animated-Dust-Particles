// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tutorial/DustParticles"
{
	Properties
	{
		_Texture0("Texture 0", 2D) = "white" {}
		_OutlineColor("Outline Color", Color) = (0,0,0,0)
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_tex4coord;
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture0;
		uniform float4 _OutlineColor;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 vertexColor47 = i.vertexColor;
			float vertexValue45 = i.uv_tex4coord.z;
			float temp_output_61_0 = (-0.25 + (vertexValue45 - 0.0) * (0.25 - -0.25) / (1.0 - 0.0));
			float2 temp_cast_0 = (( 1.0 + temp_output_61_0 )).xx;
			float2 temp_cast_1 = (vertexValue45).xx;
			float2 uv_TexCoord6 = i.uv_texcoord * temp_cast_0 + temp_cast_1;
			float2 panner7 = ( 1.0 * _Time.y * float2( 0.1,-0.02 ) + uv_TexCoord6);
			float4 tex2DNode3 = tex2D( _Texture0, panner7 );
			float2 temp_cast_2 = (( 1.0 + temp_output_61_0 )).xx;
			float2 temp_cast_3 = (vertexValue45).xx;
			float2 uv_TexCoord5 = i.uv_texcoord * temp_cast_2 + temp_cast_3;
			float2 panner8 = ( 1.0 * _Time.y * float2( -0.1,0.05 ) + uv_TexCoord5);
			float panningTexture10 = ( tex2DNode3.r + tex2D( _Texture0, panner8 ).r );
			float sphere22 = ( 1.0 - length( (float2( -1,-1 ) + (i.uv_texcoord - float2( 0,0 )) * (float2( 1,1 ) - float2( -1,-1 )) / (float2( 1,1 ) - float2( 0,0 ))) ) );
			float vertexAlpha49 = i.vertexColor.a;
			float temp_output_25_0 = (0.0 + (( panningTexture10 * sphere22 ) - 0.0) * ((0.0 + (vertexAlpha49 - 0.0) * (6.0 - 0.0) / (1.0 - 0.0)) - 0.0) / (1.0 - 0.0));
			float clampResult26 = clamp( temp_output_25_0 , 0.0 , 1.0 );
			float temp_output_27_0 = floor( clampResult26 );
			float clampResult30 = clamp( (0.0 + (temp_output_25_0 - 0.0) * ((0.99 + (vertexAlpha49 - 0.0) * (0.95 - 0.99) / (1.0 - 0.0)) - 0.0) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float temp_output_65_0 = (0.0 + (( panningTexture10 * sphere22 ) - 0.0) * ((0.5 + (vertexAlpha49 - 0.0) * (2.0 - 0.5) / (1.0 - 0.0)) - 0.0) / (1.0 - 0.0));
			float clampResult66 = clamp( temp_output_65_0 , 0.0 , 1.0 );
			float clampResult69 = clamp( (0.0 + (temp_output_65_0 - 0.0) * ((0.99 + (vertexAlpha49 - 0.0) * (0.95 - 0.99) / (1.0 - 0.0)) - 0.0) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float bubbleSeparator79 = tex2DNode3.r;
			float clampResult82 = clamp( (0.19 + (bubbleSeparator79 - 0.0) * (1.84 - 0.19) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float clampResult85 = clamp( ( ( temp_output_27_0 - floor( clampResult30 ) ) + ( ( floor( clampResult66 ) - floor( clampResult69 ) ) - floor( clampResult82 ) ) ) , 0.0 , 1.0 );
			float fill36 = ( temp_output_27_0 - clampResult85 );
			float outline33 = clampResult85;
			o.Emission = ( ( vertexColor47 * fill36 ) + ( _OutlineColor * outline33 ) ).rgb;
			float clampResult21 = clamp( temp_output_27_0 , 0.0 , 1.0 );
			float opacity19 = clampResult21;
			o.Alpha = opacity19;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float2 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xyzw = customInputData.uv_tex4coord;
				o.customPack1.xyzw = v.texcoord;
				o.customPack2.xy = customInputData.uv_texcoord;
				o.customPack2.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_tex4coord = IN.customPack1.xyzw;
				surfIN.uv_texcoord = IN.customPack2.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18909
702.4;863.2;1894.8;776.2001;6815.661;1019.003;5.096418;True;True
Node;AmplifyShaderEditor.TexCoordVertexDataNode;44;-3887.05,745.3369;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-3693.639,813.1179;Inherit;False;vertexValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-3392.604,-118.3975;Inherit;False;45;vertexValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;61;-3116.019,-420.7506;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.25;False;4;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-3105.82,-577.1505;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-2672.749,-569.1868;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-2715.848,-107.0869;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-2332.556,-358.599;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-2316.959,110.701;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-4467.3,310.3454;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;8;-2021.559,122.4013;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.1,0.05;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;14;-4240.301,311.3454;Inherit;False;5;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,1;False;3;FLOAT2;-1,-1;False;4;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;7;-2063.458,-358.599;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,-0.02;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-2140.494,-169.6829;Inherit;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;0;False;0;False;e6bf410888c1364469ce289b654db32b;e6bf410888c1364469ce289b654db32b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;3;-1742.457,-337.6984;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;16;-4062.298,308.3454;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-1743.658,45.70158;Inherit;True;Property;_TextureSample1;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;46;-4075.99,-96.05885;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;17;-3941.299,310.3454;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1375.451,-102.1199;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-1141.407,-95.96831;Inherit;False;panningTexture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-3717.863,329.5973;Inherit;False;sphere;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-3810.468,15.4809;Inherit;False;vertexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-2486.538,1429.12;Inherit;False;10;panningTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-2451.904,1506.681;Inherit;False;22;sphere;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;-2443.715,1834.985;Inherit;False;49;vertexAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;-2480.142,515.8504;Inherit;False;10;panningTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-2509.142,986.8341;Inherit;False;49;vertexAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-2447.639,620.0534;Inherit;False;22;sphere;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-2213.876,1424.55;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;73;-2199.715,1701.985;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2176.165,587.0043;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;-1380.571,-303.2521;Inherit;False;bubbleSeparator;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;53;-2266.142,853.8341;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;6;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;65;-1948.22,1457.501;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;75;-2198.116,1886.294;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.99;False;4;FLOAT;0.95;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;25;-1941.534,661.9938;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;6;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;54;-2263.544,1038.143;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.99;False;4;FLOAT;0.95;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;68;-1690.375,1795.951;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.95;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-1983.732,2127.02;Inherit;False;79;bubbleSeparator;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;81;-1694.927,2143.337;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.19;False;4;FLOAT;1.84;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;29;-1693.191,923.6396;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.95;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;66;-1662.672,1475.944;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;69;-1463.375,1801.951;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;82;-1391.231,2144.888;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;26;-1692.305,684.6109;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;70;-1302.375,1800.951;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;67;-1474.16,1468.572;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;30;-1497.164,951.7207;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;27;-1538.982,680.3517;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;31;-1345.164,958.7207;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;83;-1241.33,2146.261;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;71;-1151.53,1465.867;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;-1180.164,840.7207;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;84;-863.2898,1855.813;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-786.3018,1273.608;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;85;-520.4095,1174.757;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-263.1574,1013.109;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-3819.741,-86.08327;Inherit;False;vertexColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-276.4568,1197.675;Inherit;False;outline;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-38.15749,1004.109;Inherit;True;fill;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;37;-262.6867,-205.177;Inherit;False;Property;_OutlineColor;Outline Color;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;21;-1245.909,521.6369;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-298.0184,-549.0692;Inherit;False;47;vertexColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-305.6105,36.34344;Inherit;False;33;outline;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-307.6105,-393.6566;Inherit;False;36;fill;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-5.219196,-515.39;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-1098.869,518.4559;Inherit;False;opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;79.28082,-128.19;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;86;-2.715027,178.945;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;211.4231,195.763;Inherit;False;19;opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;336.3894,-175.6566;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;543.6928,-102.3837;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Tutorial/DustParticles;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;45;0;44;3
WireConnection;61;0;55;0
WireConnection;57;0;60;0
WireConnection;57;1;61;0
WireConnection;59;0;60;0
WireConnection;59;1;61;0
WireConnection;6;0;57;0
WireConnection;6;1;55;0
WireConnection;5;0;59;0
WireConnection;5;1;55;0
WireConnection;8;0;5;0
WireConnection;14;0;13;0
WireConnection;7;0;6;0
WireConnection;3;0;1;0
WireConnection;3;1;7;0
WireConnection;16;0;14;0
WireConnection;4;0;1;0
WireConnection;4;1;8;0
WireConnection;17;0;16;0
WireConnection;9;0;3;1
WireConnection;9;1;4;1
WireConnection;10;0;9;0
WireConnection;22;0;17;0
WireConnection;49;0;46;4
WireConnection;64;0;62;0
WireConnection;64;1;63;0
WireConnection;73;0;74;0
WireConnection;18;0;12;0
WireConnection;18;1;23;0
WireConnection;79;0;3;1
WireConnection;53;0;51;0
WireConnection;65;0;64;0
WireConnection;65;4;73;0
WireConnection;75;0;74;0
WireConnection;25;0;18;0
WireConnection;25;4;53;0
WireConnection;54;0;51;0
WireConnection;68;0;65;0
WireConnection;68;4;75;0
WireConnection;81;0;80;0
WireConnection;29;0;25;0
WireConnection;29;4;54;0
WireConnection;66;0;65;0
WireConnection;69;0;68;0
WireConnection;82;0;81;0
WireConnection;26;0;25;0
WireConnection;70;0;69;0
WireConnection;67;0;66;0
WireConnection;30;0;29;0
WireConnection;27;0;26;0
WireConnection;31;0;30;0
WireConnection;83;0;82;0
WireConnection;71;0;67;0
WireConnection;71;1;70;0
WireConnection;32;0;27;0
WireConnection;32;1;31;0
WireConnection;84;0;71;0
WireConnection;84;1;83;0
WireConnection;72;0;32;0
WireConnection;72;1;84;0
WireConnection;85;0;72;0
WireConnection;35;0;27;0
WireConnection;35;1;85;0
WireConnection;47;0;46;0
WireConnection;33;0;85;0
WireConnection;36;0;35;0
WireConnection;21;0;27;0
WireConnection;39;0;48;0
WireConnection;39;1;41;0
WireConnection;19;0;21;0
WireConnection;40;0;37;0
WireConnection;40;1;42;0
WireConnection;43;0;39;0
WireConnection;43;1;40;0
WireConnection;0;2;43;0
WireConnection;0;9;20;0
ASEEND*/
//CHKSM=E050095286A08D320A2276F549728F2AF69DC097