using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WindManager : MonoBehaviour
{
    public ParticleSystem strongWindParticles;

    private void Start()
    {
        strongWindParticles.Stop();
    }
    private void OnEnable()
    {
        MotorTask.OnMotorActivate += EnableStrongWind;
        MotorTask.OnMotorEnd += DisableStrongWind;
    }

    private void OnDisable()
    {
        MotorTask.OnMotorActivate -= EnableStrongWind;
        MotorTask.OnMotorEnd -= DisableStrongWind;
    }

    void EnableStrongWind(object sender, MotorTask.OnMotorEventArgs e)
    {
        strongWindParticles.Play();
    }

    void DisableStrongWind(object sender, MotorTask.OnMotorEventArgs e)
    {
        strongWindParticles.Stop();
    }
}
