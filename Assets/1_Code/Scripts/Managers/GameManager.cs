using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance { get; private set; }
    public bool playerInWasser;
    public GameStateManager gameStateManager;
    


    private void Awake()
    {

        if (Instance != null && Instance != this)
        {
            Destroy(this);
        }
        else
        {
            Instance = this;
        }
    }

   /* private void OnEnable()
    {
        if (gameStateManager != null)
        {
            gameStateManager.DelayedMusicStart();
        }
    }*/
    [ContextMenu("Set GameState")]
    public void SetGameState()
    {
        if (gameStateManager != null)
        {
            gameStateManager.SetGameState(gameStateManager.currentState);
        }

    }
}
