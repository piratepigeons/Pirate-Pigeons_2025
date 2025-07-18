using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
public class MotorBlockerManager : MonoBehaviour
{
    public class OnMotorBlockEventArgs : EventArgs
    {
        
    }
    public static event EventHandler<OnMotorBlockEventArgs> OnMotorBlock;
    public static event EventHandler<OnMotorBlockEventArgs> OnMotorUnBlock;
    public static MotorBlockerManager Instance { get; private set; }
    private void Awake()
    {
        // If there is an instance, and it's not me, delete myself.

        if (Instance != null && Instance != this)
        {
            Destroy(this);
        }
        else
        {
            Instance = this;
        }
    }


    public void BlockMotor()
    {
        OnMotorBlock?.Invoke(this, new OnMotorBlockEventArgs { }); 
    }



    public void UnBlockMotor()
    {
        OnMotorUnBlock?.Invoke(this, new OnMotorBlockEventArgs { });
    }
}
