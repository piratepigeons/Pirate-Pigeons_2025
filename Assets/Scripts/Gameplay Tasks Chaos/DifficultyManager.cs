using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DifficultyManager : MonoBehaviour
{
    public bool overwriteDifficulty;
    ProgressionManager pm;
    HealthManager hm;
    [SerializeField]
    AnimationCurve difficultyCurve;


    float currentProgress;
    float currentDecreaseAmount;

    int currentDifficulty;
    public int[] spawnAmtPigeonNormal;
    public int[] spawnAmtPigeonStorm;
    public int[] spawnAmtTaskNormal;
    public float[] spawnAmtTaskStorm;
    public float[] boatSpeeds;
    public float[] motorSpeeds;
    public AnimationCurve[] healthCurves;
    public float[] raftAngleRange;


    SpawnTasks st;
    public NPCSpawner npcSp;



    private void Awake()
    {
        pm = GetComponent<ProgressionManager>();
        hm = GetComponent<HealthManager>();
        st = GetComponent<SpawnTasks>();
        

        currentDifficulty = PlayerPrefs.GetInt("Difficulty");

        if (overwriteDifficulty)
        {
            npcSp.normalSpawnIntervall = spawnAmtPigeonNormal[currentDifficulty];
            npcSp.fastSpawnIntervall = spawnAmtPigeonStorm[currentDifficulty];
            st.normalSpawnIntervall = spawnAmtTaskNormal[currentDifficulty];
            st.shortSpawnIntervall = spawnAmtTaskStorm[currentDifficulty];
            pm.idleSpeed = motorSpeeds[currentDifficulty];
            pm.motorSpeed =  boatSpeeds[currentDifficulty];
            difficultyCurve = healthCurves[currentDifficulty];
            hm.raftAngleRange = raftAngleRange[currentDifficulty];
        }

    }

    void Update()
    {
        //better to map the values from 0-1 but idk
        currentProgress = pm.currentLength;
        currentDecreaseAmount = difficultyCurve.Evaluate(currentProgress);
        hm.healthDecreaseAmount = currentDecreaseAmount;
    }

   
}
