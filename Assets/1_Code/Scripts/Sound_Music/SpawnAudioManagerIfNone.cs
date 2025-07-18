using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnAudioManagerIfNone : MonoBehaviour
{
    public GameObject audioManager;
    private void Awake()
    {
        if (MusicManager.Instance == null)
        {
            Instantiate(audioManager);
            
        }
    }
}
