using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MusicManager : MonoBehaviour
{

    SoundManager sM;
    private FMOD.Studio.EventInstance instance;
    public string menuScreen = "MainMenuScreen";
    public string characterScreen = "TestCharacterScreen";
    public string gameScreen = "SampleScene";
    public string winScreen = "ResulScreen";
    public string lossScreen = "LosingScreen";
    PlayerJoinCounter playerJoin;
    public bool startedCounter = false;
    ProgressionManager progMan;
    public bool musicPlaying = false;
    // Start is called before the first frame update
    void Start()
    {
        sM = FindObjectOfType<SoundManager>();
        instance = FMODUnity.RuntimeManager.CreateInstance("event:/music/music");
        ChangeBackgroundMusic(0);
        instance.start();
        musicPlaying = true;
        
        DontDestroyOnLoad(this.gameObject);
    }

    // Update is called once per frame
    void Update()
    {
        if(SceneManager.GetActiveScene().name == characterScreen) {
            ChangeBackgroundMusic(1);
        } else if (SceneManager.GetActiveScene().name == menuScreen) {
            ChangeBackgroundMusic(0);
        } else if (SceneManager.GetActiveScene().name == gameScreen)
        {
            sM.PlayWindSound();
            sM.PlayAmbientSounds();
            PlayerCountMusic(4);
        } else if(SceneManager.GetActiveScene().name == winScreen || SceneManager.GetActiveScene().name == lossScreen)
        {
            sM.StopWindSound();
            sM.StopAmbient();
            sM.DangerBellSoundStop();
            instance.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
            musicPlaying = false;
        }

    }
    //instance.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
    void ChangeBackgroundMusic(int thisMusic) {
        instance.setParameterByName("game_status", thisMusic);
    }
    public void MusicStormChanger(int gameState)
    {
        instance.setParameterByName("game_status", gameState);
    }
    public void HealthMusic(float healthNr)
    {
        instance.setParameterByName("health", healthNr);
    }

    public void PlayerCountMusic(int players)
    {
        instance.setParameterByName("playerselect", players);
    }
}
