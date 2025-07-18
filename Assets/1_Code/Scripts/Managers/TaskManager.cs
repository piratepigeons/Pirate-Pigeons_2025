using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TaskManager : MonoBehaviour
{
    public Transform taskParent;
    Vector3 spawnPos;
    public Transform[] spawnBounds;
    [Tooltip("Has to be inside the Raft")]
    public Transform newSpawnPos;
    
    public GameObject waterLeakTask;


    float spawnIntervall = 3f;
    public float normalSpawnIntervall;
    public float stormSpawnIntervall;
    float currentTime = 3f;





    private void OnEnable()
    {

        currentTime = spawnIntervall;

        GameStateExecutor.OnStateGame += RecieveGameState;
        GameStateExecutor.OnStateStorm += RecieveStormState;
        DifficultyManager.OnSetDifficultyLevel += RevieveDifficultySet;
    }

    private void OnDisable()
    {
        GameStateExecutor.OnStateGame -= RecieveGameState;
        GameStateExecutor.OnStateStorm -= RecieveStormState;
        DifficultyManager.OnSetDifficultyLevel -= RevieveDifficultySet;
    }

    void RecieveGameState(object sender, GameStateExecutor.OnChangeGameStateEventArgs e)
    {
        spawnIntervall = normalSpawnIntervall;
    }

    void RecieveStormState(object sender, GameStateExecutor.OnChangeGameStateEventArgs e)
    {
        spawnIntervall = stormSpawnIntervall;
        if (currentTime > spawnIntervall)
        {
            currentTime = spawnIntervall;
        }
    }

    void RevieveDifficultySet(object sender, DifficultyManager.OnLoadDifficultyArgs e)
    {
        normalSpawnIntervall = e.leakSpawnTime.x;
        stormSpawnIntervall = e.leakSpawnTime.y;
        spawnIntervall = normalSpawnIntervall;
    }



    // Update is called once per frame
    void Update()
    {
        currentTime -= Time.deltaTime;
        if(currentTime < 0)
        {
            SpawnTask();
           
            currentTime = spawnIntervall;
        }
    }

    public void CalculateNewRandomSpawnPosition()
    {
        float randX;
        float randZ;

        randX = Random.Range(spawnBounds[0].localPosition.x, spawnBounds[2].localPosition.x);
        randZ = Random.Range(spawnBounds[0].localPosition.z, spawnBounds[1].localPosition.z);
        newSpawnPos.localPosition = new Vector3(randX, 0, randZ);
        newSpawnPos.localRotation = Quaternion.identity;

    }
    public void SpawnTask()
    {
        CalculateNewRandomSpawnPosition();
        GameObject newLeak = Instantiate(waterLeakTask, newSpawnPos.position,newSpawnPos.rotation , taskParent);
    }
}
