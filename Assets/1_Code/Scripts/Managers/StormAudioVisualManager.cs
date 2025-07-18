using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
public class StormAudioVisualManager : MonoBehaviour
{
    // Start is called before the first frame update
    public Volume stormVol;
    public ParticleSystem rain;
    float currentWeight;
    float targetWeight;

    private void Start()
    {
        stormVol.weight = 0;
        currentWeight = 0;
        targetWeight = 0;
        if(rain != null)
        {
            rain.Stop();
        }
        if(SoundManager.Instance != null)
        {
            SoundManager.Instance.PlayAmbientSounds();
        }
        
        GameStateExecutor.OnStateGame += RecieveGameState;
        GameStateExecutor.OnStateStorm += RecieveStormState;
    }

    private void OnDisable()
    {

        SoundManager.Instance.StopAmbient();

        GameStateExecutor.OnStateGame -= RecieveGameState;
        GameStateExecutor.OnStateStorm -= RecieveStormState;
    }

    void RecieveGameState(object sender, GameStateExecutor.OnChangeGameStateEventArgs e)
    {
        CalmWaters();
    }


    void RecieveStormState(object sender, GameStateExecutor.OnChangeGameStateEventArgs e)
    {
        Stormy();
    }

    private void Update()
    {
        if (Mathf.Abs(currentWeight - targetWeight) > 0.01f)
        {

            currentWeight = Mathf.Lerp(currentWeight, targetWeight, 0.1f);
            stormVol.weight = currentWeight;
        }
    }

    


    void Stormy()
    {
        targetWeight = 1;
        SoundManager.Instance.AmbientSoundsSwitch(1);
        if(rain != null)
        {
            rain.Play();
        }
        
    }


    void CalmWaters()
    {
        if(rain != null)
        {
            rain.Stop();
        }
        
        targetWeight = 0;
        SoundManager.Instance.AmbientSoundsSwitch(0);
    }
}
