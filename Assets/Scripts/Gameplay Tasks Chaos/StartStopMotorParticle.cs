using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StartStopMotorParticle : MonoBehaviour
{
    public ParticleSystem smokeParticles;
    public ParticleSystem windParticles;
    private void OnEnable()
    {
        smokeParticles.Play();
        windParticles.Play();
    }

   

    private void OnDisable()
    {
        smokeParticles.Stop();
        windParticles.Stop();
    }
}
