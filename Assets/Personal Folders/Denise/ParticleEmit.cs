using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleEmit : MonoBehaviour
{

    private void Awake()
    {
        this.GetComponent<ParticleSystem>().Emit(1);
    }
}
