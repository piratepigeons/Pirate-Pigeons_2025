using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class GameStateExecutor : MonoBehaviour
{

    public class OnChangeGameStateEventArgs : EventArgs
    {
    }


    public static event EventHandler<OnChangeGameStateEventArgs> OnStateStorm;
    public static event EventHandler<OnChangeGameStateEventArgs> OnStateGame;
    public static event EventHandler<OnChangeGameStateEventArgs> OnStateWin;
    public static event EventHandler<OnChangeGameStateEventArgs> OnStateLose;
    private void OnEnable()
    {
        GameStateManager.OnStateChanged += RecieveGameStateChange;
    }

    private void OnDisable()
    {
        GameStateManager.OnStateChanged -= RecieveGameStateChange;
    }


    void RecieveGameStateChange(object sender, GameStateManager.OnChangeGameStateEventArgs e)
    {
        Debug.Log("Recieved State Change");
        switch (e.state)
        {
            case GameStateManager.GameState.game:
                SetGameCondition();
                break;
            case GameStateManager.GameState.storm:
                SetStormCondition();
                break;
            case GameStateManager.GameState.win:
                SetWinCondition();
                break;
            case GameStateManager.GameState.lose:
                SetLoseCondition();
                break;
        }
    }

    public void SetLoseCondition()
    {
        if (OnStateLose != null) OnStateLose(this, new OnChangeGameStateEventArgs {  });
    }
    public void SetWinCondition()
    {
        if (OnStateWin != null) OnStateWin(this, new OnChangeGameStateEventArgs { });
    }

    public void SetStormCondition()
    {
        if (OnStateStorm != null) OnStateStorm(this, new OnChangeGameStateEventArgs { });
    }

    public void SetGameCondition()
    {
        if (OnStateGame != null) OnStateGame(this, new OnChangeGameStateEventArgs { });
    }
}
