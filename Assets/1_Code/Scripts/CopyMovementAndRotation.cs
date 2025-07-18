using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CopyMovementAndRotation : MonoBehaviour
{
    public Transform transformToCopy;
    

    // Update is called once per frame
    void Update()
    {
        transform.position = transformToCopy.position;
        transform.rotation = transformToCopy.rotation;
    }
}
