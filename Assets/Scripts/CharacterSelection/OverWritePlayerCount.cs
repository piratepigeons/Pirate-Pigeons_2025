using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class OverWritePlayerCount : MonoBehaviour
{
    public PlayerConfigurationManager pc;
    public PlayerInputManager piM;
    public bool overwrite = false;
    public int a;
    // Start is called before the first frame update
    void Awake()
    {
        if (overwrite)
        {
            pc.MaxPlayers = PlayerPrefs.GetInt("Players");
            //piM.maxPlayerCount = PlayerPrefs.GetInt("Players");
        }
    }

    
}
