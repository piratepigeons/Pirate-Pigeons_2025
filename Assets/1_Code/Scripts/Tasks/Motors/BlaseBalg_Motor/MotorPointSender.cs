using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MotorPointSender : MonoBehaviour
{
    
    public MotorPointManager mps;
    Transform selectedPlayer;
    private TaskListener task;

   /* private void Start()
    {

        task = GetComponent<TaskListener>();
        if (task == null)
        {
            Debug.LogError("Task has no TaskListener");
        }
        task.OnSelectedTaskSelected += Task_OnSelectedTaskSelectedAction;
        task.OnSelectedTaskDeselected += Task_OnDeselectedTaskSelectedAction;
    }


    private void OnDisable()
    {
        task.OnSelectedTaskSelected -= Task_OnSelectedTaskSelectedAction;
        task.OnSelectedTaskDeselected -= Task_OnDeselectedTaskSelectedAction;
    }

    private void Task_OnSelectedTaskSelectedAction(object sender, System.EventArgs e)
    {
        selectedPlayer = task.selectedPlayer;
        SendPlayer();
    }

    private void Task_OnDeselectedTaskSelectedAction(object sender, System.EventArgs e)
    {
        selectedPlayer = task.selectedPlayer;
        UnSendPlayer();
    }*/
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            if (!mps.players.Contains(other.GetComponent<PointManager>()))
            {
                mps.players.Add(other.GetComponent<PointManager>());
            }

        }

    }


    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            if (mps.players.Contains(other.GetComponent<PointManager>()))
            {
                mps.players.Remove(other.GetComponent<PointManager>());
            }

        }

    }


   /* public void SendPlayer()
    {
        if (!mps.players.Contains(selectedPlayer.GetComponent<PointManager>()))
        {
            mps.players.Add(selectedPlayer.GetComponent<PointManager>());
        }
    }


    public void UnSendPlayer()
    {
        if (mps.players.Contains(selectedPlayer.GetComponent<PointManager>()))
        {
            mps.players.Remove(selectedPlayer.GetComponent<PointManager>());
        }
    }*/

    
}
