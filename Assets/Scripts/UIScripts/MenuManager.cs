using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using Pixelplacement;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class MenuManager : MonoBehaviour
{
    StateMachine sm;
    public EventSystem es;
    public Button howToPlaySelected;
    public Button mainMenuSelected;
    public Button playerSelected;
    public Button difficultySelected;
    // Start is called before the first frame update
    void Awake()
    {
        sm = FindObjectOfType<StateMachine>().GetComponent<StateMachine>();
        PlayerPrefs.SetInt("Difficulty", 0);
        PlayerPrefs.SetInt("Players", 0);
    }

    public void ChangeToHowToPlay()
    {
        sm.ChangeState("How To Play");
        es.SetSelectedGameObject(howToPlaySelected.gameObject);
    }

    public void ChangeToMainMenu()
    {
        sm.ChangeState("StartScreen");
        es.SetSelectedGameObject(mainMenuSelected.gameObject);
    }
    public void ChangeStatePublic(string name)
    {
        sm.ChangeState(name);
        


    }

    public void SetDifficulty(int difficulty)
    {
        PlayerPrefs.SetInt("Difficulty", difficulty);
    }

    public void SetPlayerAmount(int players)
    {
        PlayerPrefs.SetInt("Players", players);
    }

    public void NewFocus(Button button)
    {
        es.SetSelectedGameObject(button.gameObject);
    }



    public void ChangeToExtras()
    {
        sm.ChangeState("Extras");
    }
    public void LoadLevel(string levelName)
    {
        SceneManager.LoadScene(levelName);
    }

    public void QuitLevel()
    {
        Application.Quit();
    }


}
