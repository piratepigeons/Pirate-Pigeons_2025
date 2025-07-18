using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlasebalgTeleporter : MonoBehaviour
{
    public Transform pointToTeleportTo;
    private void OnTriggerEnter(Collider other)
    {
        if(other.CompareTag("Player"))
        {
            other.transform.position = pointToTeleportTo.position;
        }
    }

}
