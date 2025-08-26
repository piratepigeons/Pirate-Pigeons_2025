using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using Pixelplacement;

public class HowToPlayHandler : MonoBehaviour
{
    public GameObject[] panels;
    //public GameObject firstSelectedButton;
    int currentIndex;
    StateMachine sm;
    MenuManager mm;

    private void OnEnable()
    {
        sm = FindObjectOfType<StateMachine>().GetComponent<StateMachine>();
        mm = FindObjectOfType<MenuManager>().GetComponent<MenuManager>();
        currentIndex = 0;
        foreach(GameObject p in panels){
            p.SetActive(false);

        }
        panels[0].SetActive(true);
    }

    public void NextButton()
    {
        currentIndex++;
        if(currentIndex >= panels.Length)
        {
            //sm.ChangeState("StartScreen");
            mm.ChangeToMainMenu();
        }
        panels[currentIndex].SetActive(true);

    }

    public void BackButton()
    {
        currentIndex--;
        if(currentIndex < 0)
        {
            //sm.ChangeState("StartScreen");
            mm.ChangeToMainMenu();
        }
        panels[currentIndex + 1].SetActive(false);
    }
    
}
