using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneChanger : MonoBehaviour
{
    public CanvasGroup blackscreen;
    float fadeTime = 0.5f;
    public float longFadeTime = 1.5f;
    public string mainMenuName;
    public string characterSelectSceneName;
    public string levelSelectSceneName;

    //public string Level_n_SceneName;

    public string loseScreenName;
    public string winScreenName;
    bool state;


    // Start is called before the first frame update
    void Start()
    {
        blackscreen.alpha = 1;
        FadeBlackScreenOut();

        
    }

    private void OnEnable()
    {
        GameStateExecutor.OnStateLose += RecieveLoseState;

        GameStateExecutor.OnStateWin += RecieveWinState;
    }

    private void OnDisable()
    {
        GameStateExecutor.OnStateLose -= RecieveLoseState;

        GameStateExecutor.OnStateWin -= RecieveWinState;
    }



    void RecieveWinState(object sender, GameStateExecutor.OnChangeGameStateEventArgs e)
    {
        if (!state)
        {
            fadeTime = longFadeTime;
            state = true;
            Debug.Log("Recieved Win");
            LoadWinScene();
            Debug.Log("Recieved Winxyz");
        }
    }


    void RecieveLoseState(object sender, GameStateExecutor.OnChangeGameStateEventArgs e)
    {
        if (!state)
        {
            fadeTime = longFadeTime;
            state = true;
            Debug.Log("Recieved Win");
            LoadLoseScene();
        }
    }

    public void LoadMainMenu()
    {
        Loader(mainMenuName);
    }

    public void LoadCharacterSelection()
    {
        Loader(characterSelectSceneName);
    }

    [ContextMenu("Load Game")]
    public void LoadGame(string sceneToLoad)
    {
        Loader(sceneToLoad);
    }

    public void LoadLoseScene()
    {
        Loader(loseScreenName);
    }

    public void LoadWinScene()
    {
        Loader(winScreenName);
    }







    void Loader(string name)
    {
        FadeBlackScreenIn();
        LeanTween.delayedCall(fadeTime, () => DelayedLoader(name));
    }
    
    void DelayedLoader(string name)
    {
        SceneManager.LoadSceneAsync(name);
    }



    public void ExitGame()
    {
        FadeBlackScreenIn();
        LeanTween.delayedCall(fadeTime, Quitter);
    }

    void Quitter()
    {
        Application.Quit();
    }


    void FadeBlackScreenIn()
    {
        if(blackscreen != null)
        {
            LeanTween.alphaCanvas(blackscreen, 1, fadeTime).setEase(LeanTweenType.easeInCirc);
        }
        
    }


    void FadeBlackScreenOut()
    {
        if (blackscreen != null)
        {
            LeanTween.alphaCanvas(blackscreen, 0, fadeTime).setEase(LeanTweenType.easeOutCirc);
        }
        
    }

}
