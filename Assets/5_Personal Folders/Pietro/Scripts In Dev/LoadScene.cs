using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;

public class LoadScene : MonoBehaviour
{
    [SerializeField] private string sceneName;
    [SerializeField] private PlayerConfigurationManager playerConfigurationManager;
    [SerializeField] private PlayerInputManager playerInputManager;
    [SerializeField] private int playersReady = 0;

    private void Start()
    {
        //enable joining every time we enter this scene to a max of 4
        playerInputManager.EnableJoining();
    }

    private void Update()
    {
        if(playersReady == playerConfigurationManager.currentPlayersCount && playersReady !=0)
        {
            //disable joining so people cannot join during playtime
            playerInputManager.DisableJoining();
            SceneManager.LoadScene(sceneName);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Player") playersReady += 1;
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player") playersReady -= 1;
    }
}
