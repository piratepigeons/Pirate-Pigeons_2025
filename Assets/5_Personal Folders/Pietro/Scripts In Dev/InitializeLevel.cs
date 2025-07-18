using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class InitializeLevel : MonoBehaviour
{
    [SerializeField] private Transform[] playerSpawns;
    [SerializeField] private GameObject[] Players;

    [SerializeField] private GameObject playerPrefab;

    // Assuming you have references to the old Player Input components
    List<PlayerInput> oldPlayerInputs;

    // References to the new Player Input components in the new scene
    List<PlayerInput> newPlayerInputs;

    private void Start()
    {
       /* var playerConfigs = PlayerConfigurationManager.instance.GetPlayerConfigs().ToArray();
        for(int i = 0; i < playerConfigs.Length; i++)
        {
            var player = Instantiate(playerPrefab, playerSpawns[i].position, playerSpawns[i].rotation, gameObject.transform);
            //player.GetComponent<MultiplayerMovement>().InitializePlayer(playerConfigs[i]);
        }*/



        

        for (int i = 0; i < oldPlayerInputs.Count; i++)
        {
            // Get the current control scheme and devices from the old Player Input component
            string currentControlScheme = oldPlayerInputs[i].currentControlScheme;
            List<InputDevice> devices = new List<InputDevice>(oldPlayerInputs[i].devices);

            // Assign the controller to the new Player Input component
           // newPlayerInputs[i].SwitchCurrentControlScheme(currentControlScheme, devices);
        }
    }
}


/*using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;

public class PlayerManager : MonoBehaviour
{
    public static PlayerManager Instance;

    public List<PlayerInput> playerInputs;

    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
    }

    public void TransitionToNewScene(string newSceneName)
    {
        SceneManager.sceneLoaded += OnSceneLoaded;
        SceneManager.LoadScene(newSceneName);
    }

    private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
    {
        SceneManager.sceneLoaded -= OnSceneLoaded;
        ReassignPlayerInputs();
    }

    private void ReassignPlayerInputs()
    {
        List<PlayerInput> newPlayerInputs = FindNewPlayerInputsInScene();

        for (int i = 0; i < playerInputs.Count; i++)
        {
            string currentControlScheme = playerInputs[i].currentControlScheme;
            List<InputDevice> devices = new List<InputDevice>(playerInputs[i].devices);
            newPlayerInputs[i].SwitchCurrentControlScheme(currentControlScheme, devices);
        }
    }

    private List<PlayerInput> FindNewPlayerInputsInScene()
    {
        PlayerInput[] newPlayerInputsArray = FindObjectsOfType<PlayerInput>();
        List<PlayerInput> newPlayerInputs = new List<PlayerInput>(newPlayerInputsArray);
        newPlayerInputs.Sort((a, b) => a.playerIndex.CompareTo(b.playerIndex));
        return newPlayerInputs;
    }
}*/
