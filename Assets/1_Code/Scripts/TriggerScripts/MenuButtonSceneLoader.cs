using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;
using TMPro;

public class MenuButtonSceneLoader : MonoBehaviour
{
    //[SerializeField] private string sceneToLoad;
    [SerializeField] private GameObject timerCanvas;
    [SerializeField] private TMP_Text text;
    [SerializeField] private TMP_Text text2;

    [SerializeField] private SceneChanger sceneChanger;
    private float timer = 3.9f;

    [SerializeField] private int currentPlayersOnPlatform;
    private int necessaryPlayersOnPlatform;
    bool state;

    private void Start()
    {
        timerCanvas.SetActive(false);
        text2.gameObject.SetActive(false);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player")) currentPlayersOnPlatform += 1;
        if(SoundManager.Instance != null)
        {
            SoundManager.Instance.UIButtonSelect();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player")) currentPlayersOnPlatform -= 1;
    }

    private void Update()
    {
        necessaryPlayersOnPlatform = PlayerConfigurationManager.instance.currentPlayersCount;

        if (necessaryPlayersOnPlatform > 1 && currentPlayersOnPlatform == necessaryPlayersOnPlatform)
        {
            //start countdown
            timerCanvas.SetActive(true);
            timer -= Time.deltaTime;

            if (timer > 1)
            {
                text.gameObject.SetActive(true);
                text2.gameObject.SetActive(false);
            }
            else if (timer < 1)
            {
                text.gameObject.SetActive(false);
                text2.gameObject.SetActive(true);
                StartGameLoadScene();
            }

            if (timer < -1) StartGameLoadScene();

        }else
        {
            //stop countdown
            timerCanvas.SetActive(false);
            timer = 3;
        }
        
        text.text = timer.ToString("F0");
    }

    public void StartGameLoadScene()
    {
        if (!state)
        {
            state = true;
            PlayerConfigurationManager.instance.GetComponent<PlayerInputManager>().DisableJoining();
            sceneChanger.LoadGame();
            {
                SoundManager.Instance.PigeonFixSound();
            }
        }
        
        //SceneManager.LoadScene(sceneToLoad);
    }
}
