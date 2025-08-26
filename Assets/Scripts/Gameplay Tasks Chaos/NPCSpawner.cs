using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NPCSpawner : MonoBehaviour
{
    public Transform npcToSpawn;
    public float normalSpawnIntervall = 30;
    public float fastSpawnIntervall = 10f;
    float currentSpawnIntervall;
    float timer;
    public bool initialSpawn;
    public GameObject plane;
    Vector3 RndPointonPlane;
    private void Awake()
    {
        if (initialSpawn)
        {
            CreateNPC();
        }
        timer = normalSpawnIntervall;
    }
    private void Update()
    {
        timer -= Time.deltaTime;
        if(timer <= 0)
        {
            timer = currentSpawnIntervall;
            CreateNPC();
        }
    }

    public void SpeedIntervallUp()
    {
        currentSpawnIntervall = fastSpawnIntervall;
        if (timer >= fastSpawnIntervall)
        {
            timer = fastSpawnIntervall;
        }
    }

    public void SlowIntervallDown()
    {
        currentSpawnIntervall = normalSpawnIntervall;
        if (timer <= (normalSpawnIntervall/2))
        {
            timer = (normalSpawnIntervall / 2);
        }
    }
    void CreateNPC()
    {
        Transform clone;
        CalculateNewSpawnPosition();
        clone = Instantiate(npcToSpawn, RndPointonPlane, Quaternion.identity, gameObject.transform);
        clone.GetComponent<Rigidbody>().isKinematic = false;

        //clone.GetComponent<Rigidbody>().drag  = 10;
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
}
