using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerInteract : MonoBehaviour
{
    public bool isPressed;
    GameObject focussedTask;
    private void Update()
    {
        if (isPressed)
        {
            
            isPressed = false;
        }
    }
    void OnInteract()
    {
        isPressed = true;
        Debug.Log("Success");
        if(focussedTask != null)
        {
            //focussedTask.GetComponent<BasicTask>().points--;
            focussedTask.GetComponent<BasicTask>().SubtractPoints();
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Task")
        {
            focussedTask = other.gameObject;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Task")
        {
            focussedTask = null;
        }
    }
}
