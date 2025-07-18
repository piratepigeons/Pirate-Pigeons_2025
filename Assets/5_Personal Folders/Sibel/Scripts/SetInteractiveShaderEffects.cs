using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetInteractiveShaderEffects : MonoBehaviour
{
    
    [SerializeField]
    RenderTexture rt;
    
    void Awake()
    {
        Shader.SetGlobalTexture("_GlobalEffectRT", rt);
    }
 
}
