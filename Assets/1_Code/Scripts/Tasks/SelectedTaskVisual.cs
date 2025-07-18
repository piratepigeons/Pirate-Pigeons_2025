using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SelectedTaskVisual : MonoBehaviour
{
    public GameObject selectedVisuals;

    private TaskListener task;

    private void Start()
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
        ShowVisuals();
    }

    private void Task_OnDeselectedTaskSelectedAction(object sender, System.EventArgs e)
    {
        HideVisuals();
    }
    public void ShowVisuals()
    {
        //Debug.Log("show");
        selectedVisuals.SetActive(true);
    }

    public void HideVisuals()
    {
        //Debug.Log("no show");
        selectedVisuals.SetActive(false);
    }
}
