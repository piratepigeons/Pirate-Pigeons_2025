using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HatChanger : MonoBehaviour
{
    public HatChangerData hatData;
    PlayerData currentPlayerData;
    Menu_PlayerIndex mp;
    public MeshFilter mf;

    private void Start()
    {
        mf.mesh = hatData.hatMesh;
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            mp = other.GetComponent < Menu_PlayerIndex >();
            currentPlayerData = mp.myPlayerData;

            currentPlayerData.hat = hatData.hatMesh;
            currentPlayerData.playerHatSprite = hatData.hatSprite;
            if(SoundManager.Instance != null)
            {
                SoundManager.Instance.PigeonAnxiousSound();
                SoundManager.Instance.UIButtonSelect();
            }
            other.GetComponent<SpawnParticlesOn>().SpawnParticles();
            mp.LoadNewHat();
        }
    }
}
