using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class PlayerConfigurationManager : MonoBehaviour
{
    private List<PlayerConfiguration> playerConfigs;

    //[SerializeField]
    public int MaxPlayers = 4;

    [SerializeField]
    private float ayeLoadTime = 2f;

    public static PlayerConfigurationManager Instance { get; private set; }

    [SerializeField]
    private CanvasGroup blackscreen;

    [SerializeField]
    private CanvasGroup readyScreen;


    private void Awake()
    {
        if (Instance != null)
        {
            Debug.Log("SINGLETON - Trying to create another instance of singleton!!");


        }

        else
        {
            Instance = this;
            DontDestroyOnLoad(Instance);
            playerConfigs = new List<PlayerConfiguration>();
        }
    }

    public void SetPlayerColor(int index, Material color)
    {
        playerConfigs[index].PlayerMaterial = color;
    }
    public void SetFatPlayerColor(int index, Material color)
    {
        playerConfigs[index].PuffedUpMaterial = color;
    }



    public void SetPlayerName(int index, string name)
    {
        
        playerConfigs[index].PlayerName = "P" + (index +1).ToString() + ": "+ name;
    }


    public void SetPlayerHat(int index, GameObject hat)
    {

        playerConfigs[index].PlayerHat = hat;
    }

    public List<PlayerConfiguration> GetPlayerConfigs()
    {
        return playerConfigs;
    }





    public void ReadyPlayer(int index)
    {
        playerConfigs[index].IsReady = true;
        
        if(playerConfigs.Count == MaxPlayers && playerConfigs.All(p => p.IsReady == true))
        {
            LeanTween.alphaCanvas(readyScreen, 1, 0.1f).setEase(LeanTweenType.easeOutSine);
            LeanTween.alphaCanvas(blackscreen, 1, 0.1f).setEase(LeanTweenType.easeOutSine).setDelay(1.5f);
            StartCoroutine(LoadPlayScene());
        }
        
    }

    IEnumerator LoadPlayScene()
    {
        yield return new WaitForSeconds(ayeLoadTime);
        SceneManager.LoadScene("SampleScene");
    }
    public void HandlePlayerJoin(PlayerInput pi)
    {
        Debug.Log("Player Joined" + pi.playerIndex);
        FindObjectOfType<PlayerJoinCounter>().GetComponent<PlayerJoinCounter>().NewPlayerJoin();
        
        if(!playerConfigs.Any(p => p.PlayerIndex == pi.playerIndex))
        {

            pi.transform.SetParent(transform); 
            playerConfigs.Add(new PlayerConfiguration(pi));
        }
    }
}



public class PlayerConfiguration
{
    
    public PlayerConfiguration(PlayerInput pi)
    {
        PlayerIndex = pi.playerIndex;
        Input = pi;
    }
    public PlayerInput Input { get; set; }
    public int PlayerIndex { get; set; }
    public bool IsReady { get; set; }


    public Material PlayerMaterial { get; set; }
    public Material PuffedUpMaterial { get; set; }

    public GameObject PlayerHat { get; set; }

    public string PlayerName { get; set; }

}
