using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameStateManager : MonoBehaviour
{
    public static GameStateManager Instance { get; private set; }
    public enum GameState { menu, selection, game, storm, win, lose };
    public GameState currentState;

    [Header("This should only be on in the Titlescreen, Character Select and any GameMode")]
    public bool overRideStateOnStart;

    public class OnChangeGameStateEventArgs : EventArgs
    {
        public GameState state;
    }


    public static event EventHandler<OnChangeGameStateEventArgs> OnStateChanged;
    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(this);
            return;
        }
        Instance = this;
    }

    private void Start()
    {
        if (overRideStateOnStart)
        {
            SetGameState(currentState);
            //if (OnStateChanged != null) OnStateChanged(this, new OnChangeGameStateEventArgs { state = currentState });
        }
    }


    [ContextMenu("Set GameState")]
    public void SetGameState(GameState newState)
    {

        currentState = newState;
        if (OnStateChanged != null) OnStateChanged(this, new OnChangeGameStateEventArgs { state = currentState });
    }


    public void DelayedMusicStart()
    {
        StartCoroutine(SoundStartEnumerator());
    }

    IEnumerator SoundStartEnumerator()
    {
        yield return new WaitForSeconds(1f);
        SetGameState(GameState.game);
    }

    
}
