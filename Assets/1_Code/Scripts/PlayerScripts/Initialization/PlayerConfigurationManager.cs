using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerConfigurationManager : MonoBehaviour
{
    private List<PlayerConfiguration> playerConfigs;

    public int currentPlayersCount = 1;

    public static PlayerConfigurationManager instance { get; private set; }

    public List<PlayerInput> playerInputs;
    public GameObject currentPlayerCharacter; 

    private void Awake()
    {
        //check that singleton is not double and if is missing instantiate one
        if(instance != null)
        {
            Debug.Log("SINGLETON - trying to create another instance of singleton!");
        }
        else
        {
        //instantiate singleton and make sure it can't be destroyed between scenes
            instance = this;
            DontDestroyOnLoad(instance);
            playerConfigs = new List<PlayerConfiguration>();
        }
    }


    [ContextMenu ("UNJOIN")]
    public void UnjoinAll()
    {
        foreach (PlayerInput player in playerInputs)
        {
            player.enabled = false;
            //PlayerInputManager.instance.RemovePlayer(player);
        }
    }

    public void HandlePlayerJoin(PlayerInput pi)
    {
        //when new player joins add the player index to the player configuration list and set it as a child of the PlayerConfigurationManager
        Debug.Log("player joined " + pi.playerIndex);

        playerConfigs.Add(new PlayerConfiguration(pi));

        pi.gameObject.transform.SetParent(gameObject.transform);

        pi.gameObject.GetComponent<PlayerCustomIndex>().number = currentPlayersCount;
        currentPlayersCount++;
    }

    public List<PlayerConfiguration> GetPlayerConfigs()
    {
        return playerConfigs;
    }

    //-----------------------------------------------------------------------------------------------------------------For each player input create a new player input in the new scene and swich it

    public void ReassignPlayerInputs()
    {
        playerInputs = new List<PlayerInput>(GetComponentsInChildren<PlayerInput>());
        Debug.Log("number of player inputs found: " + playerInputs.Count);

        foreach (PlayerInput pi in playerInputs)
        {
            GameObject newPlayerCharacter = Instantiate(currentPlayerCharacter, transform.parent);

            PlayerInput newPlayerInput = newPlayerCharacter.GetComponent<PlayerInput>();

            string currentControlScheme = pi.currentControlScheme;
            InputDevice device = pi.devices[0];
            newPlayerInput.SwitchCurrentControlScheme(currentControlScheme, device);


            int pIndex = pi.gameObject.GetComponent<PlayerCustomIndex>().number;
            Destroy(pi.gameObject);

            newPlayerInput.gameObject.GetComponent<PlayerCustomIndex>().number = pIndex;

            Debug.Log("new playerInput custom index is: " + newPlayerInput.gameObject.GetComponent<PlayerCustomIndex>().number);
        }
    }

//-----------------------------------------------------------------------------------------------------------------PlayerConfiguration functions to set variables
public void SetPlayerName(int index, string _playerName)
    {
        playerConfigs[index].playerName = _playerName;
        Debug.Log("set player name to: " + playerConfigs[index].playerName);
    }

    public void SetPlayerPortrait(int index, Sprite _playerPortrait)
    {

    }
    public void SetPlayerPoints(int index, int _playerPoints)
    {

    }
    public void SetPlayerMaterial(int index, Material _playerMaterial)
    {

    }
    public void SetPlayerCosmetics(int index, GameObject _playerCosmetic)
    {

    }
}

//-----------------------------------------------------------------------------------------------------------------PlayerConfiguration variables
public class PlayerConfiguration //class that stores all the propreties for players
{
    public PlayerConfiguration(PlayerInput pi)
    {
        playerIndex = pi.gameObject.GetComponent<PlayerCustomIndex>().number;
        Input = pi;
    }

    //structure
    public PlayerInput Input { get;  set; }
    public int playerIndex {  get;  set; }
    public bool isReady { get; set; }

    //UI
    public string playerName { get; set; }
    public Sprite playerPortrait { get; set; }
    public int playerPoints { get; set; }

    //visuals
    public Material playerMaterial { get; set; }
    public GameObject playerCosmetics { get; set; }

}
