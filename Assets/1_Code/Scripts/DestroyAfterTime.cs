using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyAfterTime : MonoBehaviour
{
    public float deathTime;
    [Tooltip("Keep this empty if you want to destroy this GameObject")]
    public GameObject objectToDestroy;
    void Start()
    {
        if(objectToDestroy == null)
        {
            objectToDestroy = gameObject;
        }
    }

    // Update is called once per frame
    void Update()
    {
        deathTime -= Time.deltaTime;
        if(deathTime <= 0)
        {
            Destroy(objectToDestroy);
        }
    }
}
