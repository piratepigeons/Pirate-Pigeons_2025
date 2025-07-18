using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MotorV3 : MonoBehaviour
{
    public SubMotorV3[] subMotors;
   public MotorTask mt;

    bool dontCheck;

    private void OnEnable()
    {
        MotorTask.OnMotorActivate += DoCheck;
        MotorTask.OnMotorEnd += UnCheck;

    }

    private void OnDisable()
    {
        MotorTask.OnMotorActivate -= DoCheck;
        MotorTask.OnMotorEnd -= UnCheck;
    }

    void DoCheck(object sender, MotorTask.OnMotorEventArgs e)
    {
        dontCheck = true;
    }

    void UnCheck(object sender, MotorTask.OnMotorEventArgs e)
    {
        dontCheck = false;
    }

    // Update is called once per frame
    void Update()
    {
        if(subMotors[0].baloonIsFull && subMotors[1].baloonIsFull)
        {
            mt.OnMotorDrive();
        }
    }
}
