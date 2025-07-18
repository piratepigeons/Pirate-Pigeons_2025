using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class MotorStateReciever : MonoBehaviour
{
    public UnityEvent motorActivationEventsToPerform;
    public UnityEvent motorEndEventsToPerform;
    private void OnEnable()
    {
        MotorTask.OnMotorActivate += StartMotorEvents;
        MotorTask.OnMotorEnd += EndMotorEvents;

    }


    private void OnDisable()
    {
        MotorTask.OnMotorActivate -= StartMotorEvents;
        MotorTask.OnMotorEnd -= EndMotorEvents;
    }

    void StartMotorEvents(object sender, MotorTask.OnMotorEventArgs e)
    {
        motorActivationEventsToPerform.Invoke();
    }

    void EndMotorEvents(object sender, MotorTask.OnMotorEventArgs e)
    {
        motorEndEventsToPerform.Invoke();
    }
}
