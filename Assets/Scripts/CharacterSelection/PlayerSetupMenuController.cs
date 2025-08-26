using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class PlayerSetupMenuController : MonoBehaviour
{
    private int PlayerIndex;

    [SerializeField]
    private TextMeshProUGUI titleText;
    [SerializeField]
    private GameObject readyPanel;
    [SerializeField]
    private GameObject menuPanel;
    [SerializeField]
    private Button readyButton;

    private float ignoreInputTime = 0.1f;
    private bool inputEnabled;
    int playerindex;

    public void SetPlayerIndex(int pi)
    {
        PlayerIndex = pi;
        playerindex = pi + 1;
        titleText.SetText("Pigeon " + (pi + 1).ToString());
        ignoreInputTime = Time.time + ignoreInputTime;
        Debug.Log("Player " + PlayerIndex + " joined.");
    }

    // Update is called once per frame
    void Update()
    {
        
        if(Time.time > ignoreInputTime)
        {
            inputEnabled = true;
        }

        
    }

    public void SetColor(Material color)
    {
        if(!inputEnabled) { return; }

        PlayerConfigurationManager.Instance.SetPlayerColor(PlayerIndex, color);
        readyPanel.SetActive(true);
        readyButton.Select();
        menuPanel.SetActive(false);

    }

    public void SetFatColor(Material color)
    {
        if (!inputEnabled) { return; }

        PlayerConfigurationManager.Instance.SetFatPlayerColor(PlayerIndex, color);
        

    }

    public void SetName(string name)
    {
        if (!inputEnabled) { return; }
        PlayerConfigurationManager.Instance.SetPlayerName(PlayerIndex, name);
        titleText.SetText("P" + (playerindex).ToString() + ": " +name);
    }

    public void SetHat(GameObject hat)
    {
        if (!inputEnabled) { return; }
        PlayerConfigurationManager.Instance.SetPlayerHat(PlayerIndex, hat);

    }

    

    public void ReadyPlayer()
    {
        if(!inputEnabled) { return; }
        PlayerConfigurationManager.Instance.ReadyPlayer(PlayerIndex);
        readyButton.gameObject.SetActive(false);
    }

    public void LoadMainMenu()
    {
        if (FindObjectOfType<PlayerConfigurationManager>() == null)
        {
            Debug.Log("nothing found");
        }
        else
        {
            Destroy(FindObjectOfType<PlayerConfigurationManager>().gameObject);
            Debug.Log("destroyed");
        }
        SceneManager.LoadScene("MainMenuScreen");
    }
}
