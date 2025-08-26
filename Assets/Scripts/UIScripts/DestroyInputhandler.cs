using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyInputhandler : MonoBehaviour
{
    public void DestroyInputHandler()
    {
        if(FindObjectOfType<PlayerConfigurationManager>() == null)
        {
            Debug.Log("nothing found");
        }
        else
        {
            Destroy(FindObjectOfType<PlayerConfigurationManager>().gameObject);
            Debug.Log("destroyed");
        }
    }
}
