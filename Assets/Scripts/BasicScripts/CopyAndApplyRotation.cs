using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CopyAndApplyRotation : MonoBehaviour
{
    public Transform referenceObject;
    public bool copyRotation = true;
    public bool copyPosition = true;
    public bool takeWrittenReference = false;
    public string objectName;


    private void Awake()
    {
        if (takeWrittenReference)
        {
            referenceObject = GameObject.Find(objectName).transform;
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (copyRotation)
        {
            transform.rotation = referenceObject.rotation;
        }
        if (copyPosition)
        {
            transform.position = referenceObject.position;
        }
        
        
    }
}
