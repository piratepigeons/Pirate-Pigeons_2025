using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class TaskListener : MonoBehaviour
{
    public bool awardsPoints;
    public float pointsToAward;
    public UnityEvent taskEventsToPerform;
    public event EventHandler OnSelectedTaskSelected;
    public event EventHandler OnSelectedTaskDeselected;
    public Transform selectedPlayer;

    [ContextMenu("Invoke all Tasks")]
    public void PerformTasks()
    {
        taskEventsToPerform.Invoke();
    }

    public void SelectedTask(Transform player)
    {
        selectedPlayer = player;
        OnSelectedTaskSelected?.Invoke(this, EventArgs.Empty);
        
    }

    public void UnSelectedTask()
    {
        
        OnSelectedTaskDeselected?.Invoke(this, EventArgs.Empty);
        selectedPlayer = null;


    }


    private void OnDestroy()
    {
        UnSelectedTask();
    }
}
