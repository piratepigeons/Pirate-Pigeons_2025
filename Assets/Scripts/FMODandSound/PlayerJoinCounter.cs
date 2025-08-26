using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerJoinCounter : MonoBehaviour
{
    public int playerAmount;
    MusicManager mM;
    SoundManager sM;

    void Start()
    {
        mM = FindObjectOfType<MusicManager>();
        sM = FindObjectOfType<SoundManager>();
    }

    public void NewPlayerJoin()
    {
        playerAmount++;
        //do fmod stuff here
        //instance.setParameterByName("playerselect", playerAmount);
        mM.PlayerCountMusic(playerAmount);
        sM.UIButtonPlay();
    }

}