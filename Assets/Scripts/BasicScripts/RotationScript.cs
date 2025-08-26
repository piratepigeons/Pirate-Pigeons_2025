using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotationScript : MonoBehaviour
{
    public float x;
    public float y;
    public float z;
    

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(Time.deltaTime * x, Time.deltaTime * y, Time.deltaTime * z);
    }
}
