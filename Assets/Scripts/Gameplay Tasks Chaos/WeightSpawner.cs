using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeightSpawner : MonoBehaviour
{
    public float spawnIntervall = 3f;
    public float currentTime;
    public GameObject objectToSpawn;
    //bool gameOver;
    //Countdown countdownScr;

    // Start is called before the first frame update
    void Start()
    {
        //countdownScr = GameObject.FindObjectOfType<Countdown>().GetComponent<Countdown>();
        currentTime = spawnIntervall;

        Instantiate(objectToSpawn, transform.position, transform.rotation, gameObject.transform);
    }

    // Update is called once per frame
    void Update()
    {
        //gameOver = countdownScr.gameOver;
        //if (!gameOver)
        {
            currentTime -= Time.deltaTime;
            if (currentTime <= 0)
            {
                Instantiate(objectToSpawn, transform.position, transform.rotation);
                currentTime = spawnIntervall;
            }
        }

    }
}
