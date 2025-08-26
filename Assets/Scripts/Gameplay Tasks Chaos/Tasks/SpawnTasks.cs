using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnTasks : MonoBehaviour
{
    bool spawnTaskAtStart;
    public Transform parent;
    public float normalSpawnIntervall = 10f;
    public float shortSpawnIntervall = 3f;

    float currentSpawnIntervall = 5f;
    public float spawnIntervallRange = 2f;


    float timer;

    public GameObject plane;
    GameObject task;
    public GameObject[] tasksToSpawn;
    public GameObject coopTask;

    public AnimationCurve difficultyCurve;

    Vector3 RndPointonPlane;

    float difficulty;
    private SoundManager sM;

    // Start is called before the first frame update
    void Awake()
    {
        sM = FindObjectOfType<SoundManager>();
        currentSpawnIntervall = normalSpawnIntervall;
        difficulty = PlayerPrefs.GetInt("Difficulty");
        timer = currentSpawnIntervall;
        
    }

    private void Start()
    {
        if (spawnTaskAtStart)
        {
            SpawnTask();
        }
    }

    // Update is called once per frame
    void Update()
    {
        timer -= Time.deltaTime;
        if (timer <= 0)
        {
            
            SpawnTask();
        }
    }


    void CalculateNewSpawnPosition()
    {
        //newXPos = Random.Range(z, lrAnchorValue);
        List<Vector3> VerticeList = new List<Vector3>(plane.GetComponent<MeshFilter>().sharedMesh.vertices);
        Vector3 leftTop = plane.transform.TransformPoint(VerticeList[0]);
        Vector3 rightTop = plane.transform.TransformPoint(VerticeList[10]);
        Vector3 leftBottom = plane.transform.TransformPoint(VerticeList[110]);
        Vector3 rightBottom = plane.transform.TransformPoint(VerticeList[120]);
        Vector3 XAxis = rightTop - leftTop;
        Vector3 ZAxis = leftBottom - leftTop;
        RndPointonPlane = leftTop + XAxis * Random.value + ZAxis * Random.value;
        

        /*// spawn a sphere on the plane to test the position
        GameObject sphere = GameObject.CreatePrimitive(PrimitiveType.Sphere);
        sphere.transform.position = RndPointonPlane + plane.transform.up * 0.5f;

        Debug.Log(RndPointonPlane.ToString("F4"));*/

    }
    void SpawnTask()
    {
        sM.WaterLeakStart();
        //sM.WaterLeakRunningStart();
        CalculateNewSpawnPosition();
        RndPointonPlane.y = -3f;
        task = tasksToSpawn[Random.Range(0, tasksToSpawn.Length)];
        Instantiate(task, RndPointonPlane, Quaternion.identity, parent);
        timer = currentSpawnIntervall + Random.Range(-spawnIntervallRange, spawnIntervallRange);
    }
    public void DecreaseSpawnTime()
    {
        /*difficulty = PlayerPrefs.GetInt("Difficulty");
        //spawnIntervall = spawnIntervall - (diff)
        Debug.Log(difficultyCurve.Evaluate(difficulty));
        spawnIntervall = spawnIntervall - (difficultyCurve.Evaluate(difficulty));*/
        currentSpawnIntervall = shortSpawnIntervall;
    }

    public void NormalSpawnTime()
    {
        currentSpawnIntervall = normalSpawnIntervall;
    }
}
