using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FullscreenEffects : MonoBehaviour
{
    public Shader fullscreenShader = null;
    private Material m_renderMaterial;
    
    void Start()
    {
        if (fullscreenShader == null)
        {
            //Debug.LogError("no shader.");
            m_renderMaterial = null;
            return;
        }
        m_renderMaterial = new Material(fullscreenShader);
    }
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, m_renderMaterial);
    }
}
