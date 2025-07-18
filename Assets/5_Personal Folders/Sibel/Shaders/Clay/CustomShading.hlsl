void CustomShading_float(in float3 Normal, in float3 ObjPos, in float3 WorldPos, in float3 Tint,
 in float Ambient, out float3 Out, out float3 Direction)
{
 
    #ifdef SHADERGRAPH_PREVIEW
        Out = float3(0.5,0.5,0);
        Direction = float3(0.5,0.5,0);
    #else
 
        #if SHADOWS_SCREEN
            half4 shadowCoord = ComputeScreenPos(ObjPos);
        #else
            half4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
        #endif 
        #if _MAIN_LIGHT_SHADOWS_CASCADE || _MAIN_LIGHT_SHADOWS
            Light light = GetMainLight(shadowCoord);
        #else
            Light light = GetMainLight();
        #endif
 
        half d = dot(Normal, light.direction) * 0.5 + 0.5;
        
        half shadeRamp = smoothstep(0.77, 0.77+ 0.21, d );
        
        
 
        float3 extraLights;
        int pixelLightCount = GetAdditionalLightsCount();
        for (int j = 0; j < pixelLightCount; ++j) {
            Light aLight = GetAdditionalLight(j, WorldPos, half4(1, 1, 1, 1));
            
            float3 attenuatedLightColor = aLight.color * (aLight.distanceAttenuation * aLight.shadowAttenuation);
            
            half d = dot(Normal, aLight.direction) * 0.5 + 0.5;
            
            half moreLights = smoothstep(0.77, 0.77+ 0.21, d );
 
            extraLights += (attenuatedLightColor * moreLights);
        }
        
        shadeRamp *= light.shadowAttenuation;
 
        Out = light.color * (shadeRamp + Tint)  + Ambient;
 
        Out += extraLights;
        // direction for rim lights
        
        #if MAIN_LIGHT
            Direction = normalize(light.direction);
        #else
            Direction = float3(0.5,0.5,0);
        #endif
 
    #endif
}