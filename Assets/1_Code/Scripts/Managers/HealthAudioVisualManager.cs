using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HealthAudioVisualManager : MonoBehaviour
{
    public Slider healthSlider;
    private void OnEnable()
    {
        HealthManager.OnUpdateHealthVisual += RecieveHealthUpdate;
    }

    private void OnDisable()
    {
        HealthManager.OnUpdateHealthVisual -= RecieveHealthUpdate;
    }


    void RecieveHealthUpdate(object sender, HealthManager.OnHealthUpdateEventArgs e)
    {
        healthSlider.value = e.currentHealth;
    }
}
