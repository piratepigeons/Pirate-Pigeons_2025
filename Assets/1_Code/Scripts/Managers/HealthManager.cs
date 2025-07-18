using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class HealthManager : MonoBehaviour
{
    public static HealthManager Instance { get; private set; }


    public float maxHealth = 100;
    public float currentHealth;
    float currentHealthRemoveAmt;
    float currentHealthAddAmt;

    public float lowFloatOffset;
    public float highFloatOffset;
    public float deathOffset = -5f;
    float currentFloatOffset;
    float range;
    public class OnHealthUpdateEventArgs : EventArgs
    {
        public float newFloaterOffset;
        public float currentHealth = 0f;
    }

    public static event EventHandler<OnHealthUpdateEventArgs> OnUpdateHealthLevel;
    public static event EventHandler<OnHealthUpdateEventArgs> OnUpdateHealthVisual;

    bool loseState;
    private void Awake()
    {
        // If there is an instance, and it's not me, delete myself.

        if (Instance != null && Instance != this)
        {
            Destroy(this);
        }
        else
        {
            Instance = this;
        }
    }

    private void OnEnable()
    {
        range = highFloatOffset - lowFloatOffset;
        currentHealth = maxHealth;
        /*currentFloatOffset = lowFloatOffset + ((currentHealth / 100) * range);
        if (OnUpdateHealthLevel != null) OnUpdateHealthLevel(this, new OnHealthUpdateEventArgs { newFloaterOffset = currentFloatOffset });*/

        DifficultyManager.OnSetDifficultyLevel += RecieveDifficultySet;

        GameStateExecutor.OnStateLose += RecieveLoseState;

        if (OnUpdateHealthVisual != null) OnUpdateHealthVisual(this, new OnHealthUpdateEventArgs { currentHealth = currentHealth });

        /*GameStateManager.OnStateChanged += delegate (object sender, GameStateManager.OnChangeGameStateEventArgs e)
        {
            if (e.state == GameStateManager.GameState.lose)
            {
                
            }
        };*/
    }

    private void OnDisable()
    {
        DifficultyManager.OnSetDifficultyLevel -= RecieveDifficultySet;
        GameStateExecutor.OnStateLose -= RecieveLoseState;
    }


    void RecieveDifficultySet(object sender, DifficultyManager.OnLoadDifficultyArgs e)
    {
        currentHealthRemoveAmt = e.healthRemoveAmount;
        currentHealthAddAmt = e.healthAddAmount;
    }


    void RecieveLoseState(object sender, GameStateExecutor.OnChangeGameStateEventArgs e)
    {
        if (OnUpdateHealthLevel != null) OnUpdateHealthLevel(this, new OnHealthUpdateEventArgs { newFloaterOffset = deathOffset });
    }

    public void RemoveHealth(float removeAmount)
    {
        
        currentHealth -= currentHealthRemoveAmt*Time.deltaTime * removeAmount;

        
        if (currentHealth <= 0)
        {
            if (!loseState)
            {
                loseState = true;
                currentHealth = 0;
                GameStateManager.Instance.SetGameState(GameStateManager.GameState.lose);
            }

        }
        else
        {
            currentFloatOffset = lowFloatOffset + ((currentHealth / 100) * range);
            if (OnUpdateHealthLevel != null) OnUpdateHealthLevel(this, new OnHealthUpdateEventArgs { newFloaterOffset = currentFloatOffset });
        }

        if (OnUpdateHealthVisual != null) OnUpdateHealthVisual(this, new OnHealthUpdateEventArgs { currentHealth = currentHealth });
    }

    public void AddHealth()
    {
        currentHealth+= currentHealthAddAmt;
        if(currentHealth >= maxHealth)
        {
            currentHealth = maxHealth;
        }

        if (OnUpdateHealthVisual != null) OnUpdateHealthVisual(this, new OnHealthUpdateEventArgs { currentHealth = currentHealth });
    }

    void SinkBoat()
    {

    }
}
