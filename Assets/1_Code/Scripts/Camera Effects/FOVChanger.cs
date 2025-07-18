using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FOVChanger : MonoBehaviour
{
    public Camera cam;

    float normalFOV;
    public float fastFOV = 75;
    public float fastSpeed;
    public float slowSpeed;
    float speed;

    float targetFOV;
    float currentFOV;

    public void FastFOV()
    {
        targetFOV = fastFOV;
        speed = fastSpeed;
    }


    public void SlowFOV()
    {
        speed = slowSpeed;
        targetFOV = normalFOV;
    }
    // Start is called before the first frame update
    void Start()
    {
        normalFOV = cam.fieldOfView;
        targetFOV = normalFOV;
        currentFOV = normalFOV;
    }

    // Update is called once per frame
    void Update()
    {
        if(Mathf.Abs(currentFOV - targetFOV ) > 0.01f)
        {
            currentFOV = Mathf.Lerp(currentFOV, targetFOV, Time.deltaTime * speed);
            cam.fieldOfView = currentFOV;
        }

        
    }
}
