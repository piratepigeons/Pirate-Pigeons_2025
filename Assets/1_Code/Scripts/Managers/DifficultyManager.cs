using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class DifficultyManager : MonoBehaviour
{
    public enum DifficultyLevel { easy, medium, hard, ultra };
    public DifficultyLevel currentDifficulty = DifficultyLevel.medium;
    public float[] healthRemoveAmounts;
    float currentHealthRemoveAmount;
    public float[] healthAddAmounts;
    float currentHealthAddAmount;
    public Vector2[] boatHurtAngles;
    Vector2 currentBoatHurtAngle;

    public float[] idleSpeeds;
    float currentIdleSpeed;
    public float[] motorTimes;
    float currentMotorTime;
    public float[] motorSpeeds;
    float currentMotorSpeed;


    public Vector2[] leakSpawnTimes;
    Vector2 currentLeakSpawnTime;


    public float[] goalDistances;
    float currentGoalDistance;

    public float[] balanceFloaterDistances;
    float currentBalanceFloaterDistance;

    public class OnLoadDifficultyArgs : EventArgs
    {
        public DifficultyLevel difficulty;
        public float healthRemoveAmount;
        public float healthAddAmount;
        public Vector2 boatHurtAngle;

        public float idleSpeed;
        public float motorTime;
        public float motorSpeed;

        public Vector2 leakSpawnTime;

        public float goalDistance;
        public float balanceFloaterDistance;
    }

    public static event EventHandler<OnLoadDifficultyArgs> OnSetDifficultyLevel;

    private void Start()
    {
        //PlayerPrefs.SetInt("Difficulty", 3);
        GetDifficultyLevel();
        SetDifficultyLevel();
    }

    [ContextMenu ("SET DIFFICULTY")]
    public void SetDifficultyLevel()
    {

        SetDifficultyValues();
        if (OnSetDifficultyLevel != null) OnSetDifficultyLevel(this, new OnLoadDifficultyArgs
        {
            difficulty = currentDifficulty,
            healthRemoveAmount = currentHealthRemoveAmount,
            healthAddAmount = currentHealthAddAmount,
            boatHurtAngle = currentBoatHurtAngle,

            idleSpeed = currentIdleSpeed,
            motorTime = currentMotorTime,
            motorSpeed = currentMotorSpeed,
            leakSpawnTime = currentLeakSpawnTime,
            goalDistance = currentGoalDistance,
            balanceFloaterDistance = currentBalanceFloaterDistance
           
            

        }) ;
    }

    void SetDifficultyValues()
    {
        switch (currentDifficulty)
        {
            case DifficultyLevel.easy:

                SetIndividualDifficultyValue(0);
                break;

            case DifficultyLevel.medium:
                SetIndividualDifficultyValue(1);
                break;

            case DifficultyLevel.hard:
                SetIndividualDifficultyValue(2);
                break;

            case DifficultyLevel.ultra:
                SetIndividualDifficultyValue(3);
                break;

            default:
                SetIndividualDifficultyValue(0);
                break;
        }
    }


    void SetIndividualDifficultyValue(int difficulty)
    {
        currentHealthRemoveAmount = healthRemoveAmounts[difficulty];
        currentHealthAddAmount = healthAddAmounts[difficulty];
        currentBoatHurtAngle = boatHurtAngles[difficulty];

        currentIdleSpeed = idleSpeeds[difficulty];
        currentMotorTime = motorTimes[difficulty];
        currentMotorSpeed = motorSpeeds[difficulty];
        currentLeakSpawnTime = leakSpawnTimes[difficulty];

        currentGoalDistance = goalDistances[difficulty];
        currentBalanceFloaterDistance = balanceFloaterDistances[difficulty];
    }

    public void GetDifficultyLevel()
    {
        switch(PlayerPrefs.GetInt("Difficulty", 0))
        {
            case 0:

                currentDifficulty = DifficultyLevel.easy;
                break;

            case 1:
                currentDifficulty = DifficultyLevel.medium;
                break;

            case 2:
                currentDifficulty = DifficultyLevel.hard;
                break;

            case 3:
                currentDifficulty = DifficultyLevel.ultra;
                break;

            default:
                currentDifficulty = DifficultyLevel.easy;
                break;
        }
    }


    [ContextMenu("Save DIFFICULTY")]
    public void SaveCurrentDifficulty()
    {
        switch (currentDifficulty)
        {
            case DifficultyLevel.easy:

                PlayerPrefs.SetInt("Difficulty", 0);
                break;

            case DifficultyLevel.medium:
                PlayerPrefs.SetInt("Difficulty", 1);
                break;

            case DifficultyLevel.hard:
                PlayerPrefs.SetInt("Difficulty", 2);
                break;

            case DifficultyLevel.ultra:
                PlayerPrefs.SetInt("Difficulty", 3);
                break;

            default:
                PlayerPrefs.SetInt("Difficulty", 0);
                break;
        }
    }
}
