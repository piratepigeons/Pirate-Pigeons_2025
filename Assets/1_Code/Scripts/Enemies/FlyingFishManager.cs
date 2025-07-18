using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlyingFishManager : MonoBehaviour
{
    public GameObject fishObject;
    public int fishSpawnAmount;
    public Transform fishHolder;
    public Transform p1;
    public Transform p2;
    public Transform p3;

    [ContextMenu("spawn")]
    public void SpawnFish()
    {
        for(int i = 0; i <= fishSpawnAmount; i++)
        {
            Vector3 spawnPosition = new Vector3(Random.Range(p1.position.x, p2.position.x), p1.position.y + Random.Range(-5f, 5f), Random.Range(p1.position.z, p3.position.z));
            Instantiate(fishObject, spawnPosition, Quaternion.identity, fishHolder);
        }
    }
}
