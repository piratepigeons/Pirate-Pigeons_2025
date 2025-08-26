using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.InputSystem;
using UnityEngine.Rendering;
using UnityEngine.UI;

public class GameManager : MonoBehaviour
{
    public bool gameOver = false;
    public bool gameWon = false;
    bool startLoadingSequence = false;
    public bool dangerState = false;
    bool state;
    public CanvasGroup blackscreen;
    public CanvasGroup whitescreen;
    public SinkBoat floatObject;
    public bool returnToMain;

    public float loadTime = 3f;
    float timer;
    public GameObject gameOverPanel;
    public GameObject winnerPannel;
    public GameObject warningPanel;
    public Volume badWeatherPostProcess;
    public Volume goodWeatherPP;
    public ScoreHandler sh;
    [SerializeField]
    AnimationCurve fadeCurve;
    public bool aaa;


    private void Awake()
    {
        timer = loadTime;
        gameOverPanel.SetActive(false);
        winnerPannel.SetActive(false);
        badWeatherPostProcess.weight = 0;
        goodWeatherPP.weight = 1f;
        LeanTween.alphaCanvas(blackscreen, 0, 0.4f).setEase(LeanTweenType.easeInOutQuint);
    }

    // Update is called once per frame
    void Update()
    {
        if(!startLoadingSequence)
        if (gameOver)
        {
                startLoadingSequence = true;
                Wandering[] npcs = FindObjectsOfType(typeof(Wandering)) as Wandering[];
                foreach (Wandering singleNPC in npcs)
                {
                    singleNPC.DieBird();
                }
                //ResetScore();
                StartCoroutine(LoadLoseScreen());

            /*gameOverPanel.SetActive(true);
                startLoadingSequence = true;*/
            
        }
        else if (gameWon)
        {
                startLoadingSequence = true;


                
                //GetComponent<DifficultyManager>().IncreaseDifficulty();
                /*winnerPannel.SetActive(true);
                startLoadingSequence = true;*/
                StartCoroutine(LoadWinScreen());
            }

        if (dangerState)
        {
            //warningPanel.SetActive(true);
            if (state)
            {
                StartCoroutine(FadePostProcess(0, 1));
                GetComponent<SpawnTasks>().DecreaseSpawnTime();
                GetComponentInChildren<NPCSpawner>().SpeedIntervallUp();
                state = false;
            }
        }
        else
        {
            //warningPanel.SetActive(false);
            
            if (!state)
            {
                StartCoroutine(FadePostProcess(1, 0));
                GetComponent<SpawnTasks>().NormalSpawnTime();
                GetComponentInChildren<NPCSpawner>().SlowIntervallDown();
                state = true;
            }
        }



       /* if(startLoadingSequence)
        {
            timer -= Time.deltaTime;
        }




        if(timer < 0)
        {
            LoadLevel();
        }*/
    }
    IEnumerator LoadWinScreen()
    {

        sh.SortAndSaveScores();
        //fade in blackscreen, sound
        FadeInBlackscreen(2, whitescreen);
        yield return new WaitForSeconds(3f);
        SceneManager.LoadScene("ResultScreen");
    }

    IEnumerator LoadLoseScreen()
    {

        sh.SortAndSaveScores();
        //fade in blackscreen, sound
        floatObject.enabled = true;
        FadeInBlackscreen(3, blackscreen);
        yield return new WaitForSeconds(4f);
        SceneManager.LoadScene("LosingScreen");
    }

    public void FadeInBlackscreen(float fadeTime, CanvasGroup screen)
    {
        LeanTween.alphaCanvas(screen, 1, fadeTime).setEase(LeanTweenType.easeOutExpo);
    }
    void LoadLevel()
    {
        if (returnToMain)
        {
            Destroy(FindObjectOfType<PlayerInputManager>().gameObject);
            SceneManager.LoadScene("TestCharacterScreen");
        }
        else
        {
            SceneManager.LoadScene("SampleScene");
        }
        
    }


    void ResetScore()
    {
        PlayerPrefs.SetInt("Difficulty", 0);
    }

    IEnumerator FadePostProcess(float oldState, float newState)
    {
        
        for (float t = 0; t < 1; t += Time.deltaTime / 1f)
        {
            
            badWeatherPostProcess.weight = Mathf.Lerp(oldState, newState, fadeCurve.Evaluate(t));
            goodWeatherPP.weight = Mathf.Lerp(newState, oldState, fadeCurve.Evaluate(t));
            yield return null;
        }
        badWeatherPostProcess.weight = newState;
        goodWeatherPP.weight = oldState;
        /*LeanTween.value(badWeatherPostProcess.weight, oldState, newState, 1f);
        LeanTween.value(goodWeatherPP.weight, newState, oldState);
        yield return null;*/
    }
}
