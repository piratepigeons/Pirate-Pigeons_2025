using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveWithWater : MonoBehaviour
{
    [Tooltip ("If kept empty, it will take the Transform this script is sitting on")]
    public Transform transformToInfluence;
    Transform originalParent;
    bool hasOriginalParent;

    public bool isPlayer;
    [Tooltip("dont change this, the script will take care of this")]
    public bool shouldMoveWithWater;
    private void Awake()
    {

        if (transformToInfluence == null)
        {
            transformToInfluence = transform;
        }

        if (transformToInfluence.parent != null)
        {
            hasOriginalParent = true;
            originalParent = transformToInfluence.parent;
        }
        else
        {
            hasOriginalParent = false;
        }
        
    }

    

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Water"))
        {
            if (isPlayer)
            {
                if(shouldMoveWithWater)
                {
                    transformToInfluence.parent = other.transform.parent.parent;
                }

                return;
            }
            else
            {
                transformToInfluence.parent = other.transform.parent.parent;
            }
            
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (!other.CompareTag("Water"))
        {
            return;
            
        }
        if (hasOriginalParent)
        {
            transformToInfluence.parent = originalParent;
        }
        else
        {
            transformToInfluence.parent = null;
        }

    }
}
