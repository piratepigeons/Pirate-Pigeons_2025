using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckPlayerCollision : MonoBehaviour
{
    public bool playerCollides;
    public bool changeMaterial;
    public Material normalMat;
    public Material highlightedMat;

    private void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Player")
        {
            playerCollides = true;
            if (changeMaterial)
            {
                GetComponent<MeshRenderer>().material = highlightedMat;
            }
        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            playerCollides = false;
            if (changeMaterial)
            {
                GetComponent<MeshRenderer>().material = normalMat;
            }
        }
    }
}
