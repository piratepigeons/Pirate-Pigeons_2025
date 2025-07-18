using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoatYStabilizer : MonoBehaviour
{
    Vector3 currentRot;
    Vector3 newRot;
    // Update is called once per frame
    void Update()
    {
        currentRot = transform.rotation.eulerAngles;
        currentRot.y = 90;
        transform.rotation = Quaternion.Euler( currentRot);
    }
}
