using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class CharacterSelectionButtonHandler : MonoBehaviour
{
    public EventSystem es;
    public Button redButton;

    public Button blueButton;
    public Button greenButton;
    public Button yellowButton;
    public GameObject nullSelection;

    CharacterSelectionChecker csc;


    private void Awake()
    {
        csc = FindObjectOfType<CharacterSelectionChecker>().GetComponent<CharacterSelectionChecker>();
        csc.AddButtonsToArrays(redButton, blueButton, greenButton, yellowButton);
        CheckSelectionStatus();
    }

    public void CheckSelectionStatus()
    {
        /*if(es.currentSelectedGameObject == null)
        {
            Debug.Log("No selected");
            es.SetSelectedGameObject(nullSelection);
        }*/
        if (csc.redSelected)
        {
            redButton.interactable = false;
        }
        if (csc.blueSelected)
        {
            blueButton.interactable = false;
        }
        if (csc.greenSelected)
        {
            greenButton.interactable = false;
        }
        if (csc.yellowSelected)
        {
            yellowButton.interactable = false;
        }
    }
    
    public void DisableRed()
    {
        csc.DisableAllReds();
       // Debug.Log("RedDisabled");
    }

    public void DisableBlue()
    {
        csc.DisableAllBlues();
        //Debug.Log("BlueDisabled");
    }

    public void DisableGreen()
    {
        csc.DisableAllGreens();
    }

    public void DisableYellow()
    {
        csc.DisableAllYellows();
    }
}
