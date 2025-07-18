using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FMODUnity;

public class MusicManager : MonoBehaviour
{

    public FMOD.Studio.EventInstance em;
    public EventReference mainMusic;
    public int playerAmt;
    public float health;
    public float progress;
    public static MusicManager Instance { get; private set; }


    private void Awake()
    {



        if (Instance != null && Instance != this)
        {
            em.stop(FMOD.Studio.STOP_MODE.IMMEDIATE);
            Destroy(this);
        }
        else
        {
            Instance = this;
        }
    }


    private void OnEnable()
    {
        em = RuntimeManager.CreateInstance(mainMusic);
        StartMusic();
        DontDestroyOnLoad(this.gameObject);
        GameStateManager.OnStateChanged += UpdateState;

        HealthManager.OnUpdateHealthVisual += UpdateHealthVisual;
    }

    private void OnDisable()
    {
        GameStateManager.OnStateChanged -= UpdateState;

        HealthManager.OnUpdateHealthVisual -= UpdateHealthVisual;
    }

    void UpdateHealthVisual(object sender, HealthManager.OnHealthUpdateEventArgs e)
    {
        SetHealthMusic(100f - e.currentHealth);
    }

    void UpdateState(object sender, GameStateManager.OnChangeGameStateEventArgs e)
    {
        //Debug.Log("Set music state to: " + e.state.ToString());
        if(e.state == GameStateManager.GameState.menu)
        {
            SetHealthMusic(100);
        }
        SetMusicStatus(e.state.ToString());
    }

    [ContextMenu("Set all")]
    public void SetAll()
    {
        
        SetPlayerCountMusic(playerAmt);
        SetHealthMusic(health);
        SetProgressMusic(progress);
    }

    

    public void StartMusic()
    {
        em.start();
    }

    public void SetMusicStatus(string state)
    {
        
        em.setParameterByNameWithLabel("status", state);
       // Debug.Log("set music to this state: " + state);
    }

    public void SetPlayerCountMusic(int players)
    {
        em.setParameterByName("select", players);
    }

    public void SetHealthMusic(float currentHealth)
    {
        em.setParameterByName("health", currentHealth);
    }
    public void SetProgressMusic(float currentProgress)
    {
        em.setParameterByName("progress", currentProgress);
    }




    [Header("Right click this variable name!")]
    [SerializeField]
    [ContextMenuItem("Get a random scale", "RandomeScale")]
    private float randomsScale;

    void RandomeScale()
    {
        randomsScale = Random.Range(0.0f, 5.0f);
    }


    public void EndMusic()
    {
        em.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
    }


}
