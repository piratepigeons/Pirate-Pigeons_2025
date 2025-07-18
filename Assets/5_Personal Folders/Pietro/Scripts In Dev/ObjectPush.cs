using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class ObjectPush : MonoBehaviour
{
    [SerializeField] private float minPushForce;
    [SerializeField] private float maxPushForce;

    [SerializeField] private float forceAdded;
    private Rigidbody rb;

    private void Start()
    {
        forceAdded = minPushForce;
    }

    private void OnTriggerEnter(Collider other)
    {
        rb = other.GetComponent<Rigidbody>();
        if (rb != null) rb.AddForce(transform.forward * forceAdded);
    }
    private void OnTriggerStay(Collider other)
    {
        if(forceAdded >= minPushForce && forceAdded < maxPushForce)
        {
            forceAdded = forceAdded + 1;
        }else if (forceAdded >= maxPushForce)
        {
            forceAdded = maxPushForce;
        }


        rb = other.GetComponent<Rigidbody>();
        if(rb != null) rb.AddForce(transform.forward * forceAdded);
    }

    private void OnTriggerExit(Collider other)
    {
        forceAdded = minPushForce;
    }
}
