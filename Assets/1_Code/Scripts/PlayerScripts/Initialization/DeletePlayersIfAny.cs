using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class DeletePlayersIfAny : MonoBehaviour
{
    PlayerInput[] playerInputs;
    PlayerConfigurationManager[] managers;
    PlayerConfigurationManager pcm;

    public bool manualReset;
    // Start is called before the first frame update
    void Start()
    {
        if (!manualReset)
        {
            ResetPlayers();
        }

        /*for (int i = pcm.transform.childCount - 1; i >= 0; i--)
        {
            Destroy(pcm.transform.GetChild(i).gameObject);
            Debug.Log("Destoyed child");
        }*/
        
    }


    public void ResetPlayers()
    {
        playerInputs = FindObjectsOfType<PlayerInput>();

        
        foreach (PlayerInput player in playerInputs)
        {

            GameObject playerObject = player.gameObject;
            player.enabled = false; // Or use Destroy(player);
            Destroy(playerObject);
        }

        if (manualReset)
        {
            managers = FindObjectsOfType<PlayerConfigurationManager>();
            foreach (PlayerConfigurationManager p in managers)
            {
                p.currentPlayersCount = 0;
                p.GetComponent<PlayerInputManager>().enabled = false;
                Destroy(p.gameObject);
            }
        }
    }

}
