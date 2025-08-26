using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CharacterSelectionChecker : MonoBehaviour
{
    public bool lockCharacters;

    public bool redSelected;
    public bool blueSelected;
    public bool yellowSelected;
    public bool greenSelected;

    //public Button[] redButtons;
    

    public List<Button> redButtons = new List<Button>();
    public List<Button> blueButtons = new List<Button>();
    public List<Button> greenButtons = new List<Button>();
    public List<Button> yellowButtons = new List<Button>();


    public void AddButtonsToArrays(Button redB, Button blueB, Button greenB, Button yellowB)
    {
        redButtons.Add(redB);
        blueButtons.Add(blueB);
        greenButtons.Add(greenB);
        yellowButtons.Add(yellowB);
    }

    

    public void DisableAllReds()
    {
        if (lockCharacters)
        {
            redSelected = true;
            foreach(Button b in redButtons)
            {
                b.interactable = false;
            }
        }
    }
    public void DisableAllBlues()
    {
        if (lockCharacters)
        {
            blueSelected = true;
            foreach (Button b in blueButtons)
            {
                b.interactable = false;
            }
        }
    }
    public void DisableAllGreens()
    {
        if (lockCharacters)
        {
            greenSelected = true;
            foreach (Button b in greenButtons)
            {
                b.interactable = false;
            }
        }
    }
    public void DisableAllYellows()
    {
        if (lockCharacters)
        {
            yellowSelected = true;
            foreach (Button b in yellowButtons)
            {
                b.interactable = false;
            }
        }
    }
}
