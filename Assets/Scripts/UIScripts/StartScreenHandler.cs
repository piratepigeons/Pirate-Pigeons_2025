using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class StartScreenHandler : MonoBehaviour
{
    public GameObject firstSelectedButton;
    private void OnEnable()
    {
        //FindObjectOfType<EventSystem>().GetComponent<EventSystem>().m_CurrentSelected = firstSelectedButton;
    }
}
