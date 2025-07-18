using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FMODUnity;
public class SoundManager : MonoBehaviour
{
    private FMOD.Studio.EventInstance UI_Button, UI_Selection, UI_PlayerR;
    private FMOD.Studio.EventInstance waterLeakStart, waterLeakRunning, danger_bell;
    private FMOD.Studio.EventInstance blasebalg, letAirOut;
    private FMOD.Studio.EventInstance motorStart, motorRun, motorEvent, boatBreakage;

    private FMOD.Studio.EventInstance ambientEvent;
    private FMOD.Studio.EventInstance thunder;
    private FMOD.Studio.EventInstance seagulls;


    private FMOD.Studio.EventInstance pigeon_vic, pigeon_fix, pigeon_defeat, pigeon_drown, pigeon_fatroll, pigeon_toc, pigeon_fattransform, pigeon_anxious, pigeon_walk, pigeon_swim, pigeon_task_fix_increment;

    private FMOD.Studio.EventInstance NPC_lands, NPC_startled, NPC_flyaway;

    private FMOD.Studio.EventInstance end_whistle, start_whistle;


    public static SoundManager Instance { get; private set; }
    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(this);
        }
        else
        {
            Instance = this;
        }

        #region Pigeons
        pigeon_anxious = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Pigeons/Pigeon_Anxious");
        pigeon_fattransform = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Pigeons/Pigeon_FatTransform");
        pigeon_toc = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Pigeons/Pigeon_Toc");
        pigeon_fatroll = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Pigeons/Pigeon_FatRoll");
        pigeon_drown = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Pigeons/Pigeon_Drown");
        pigeon_defeat = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Pigeons/Pigeon_Defeat");
        pigeon_fix = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Pigeons/Pigeon_Fix");
        pigeon_task_fix_increment = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Pigeons/Pigeon_FixLeak");
        pigeon_vic = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Pigeons/Pigeon_Victory");
        pigeon_walk = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Pigeons/Pigeon_Walk");
        pigeon_swim = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Pigeons/Pigeon_Swim");

        #endregion
        #region Tasks
        motorStart = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Raft/Motor_Starting3");
        motorRun = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Raft/Motor_Running");
        danger_bell = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Raft/Danger_Bell");
        waterLeakRunning = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Raft/Leak_Water");
        waterLeakStart = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Raft/Leak_Appear");
        blasebalg = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Raft/Blasebalg");
        letAirOut = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Raft/LetAirOut");
        boatBreakage = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Raft/Breakage");

        #endregion
        #region NPC
        NPC_lands = FMODUnity.RuntimeManager.CreateInstance("event:/FX/NPC/NPC_Land");
        NPC_flyaway = FMODUnity.RuntimeManager.CreateInstance("event:/FX/NPC/NPC_flyaway");
        NPC_startled = FMODUnity.RuntimeManager.CreateInstance("event:/FX/NPC/NPC_Startled");
        #endregion

        #region SFX
        thunder = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Ambient/Ambient_Thunder");
        seagulls = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Ambient/Ambient_Seagulls");
        ambientEvent = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Ambient/Ambient_Storm");
        end_whistle = FMODUnity.RuntimeManager.CreateInstance("event:/FX/SFX/WinWhistle");
        start_whistle = FMODUnity.RuntimeManager.CreateInstance("event:/FX/SFX/StartWhistle");
        #endregion
        motorEvent = FMODUnity.RuntimeManager.CreateInstance("event:/FX/Ambient/WindEvent");
        
        UI_Button = FMODUnity.RuntimeManager.CreateInstance("event:/FX/UI/UI_Button");
        UI_Selection = FMODUnity.RuntimeManager.CreateInstance("event:/FX/UI/UI_Selection");
        UI_PlayerR  = FMODUnity.RuntimeManager.CreateInstance("event:/FX/UI/UI_PlayerR");
        DontDestroyOnLoad(this.gameObject);
    }


    void DisableSoundsOnSceneChange()
    {
        LeanTween.delayedCall(0.5f, DelayedDisable);
    }

    void DelayedDisable()
    {
        Debug.Log("disabled all extra sounds");
        MotorRunningStop();
        StopAmbient();
        StopWindSound();
        WaterLeakRunningStop();
        DangerBellSoundStop();
        PigeonFatRollingSoundStop();
        PigeonStopWalk();
        PigeonStopSwim();
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



    void RecieveLoseState(object sender, GameStateExecutor.OnChangeGameStateEventArgs e)
    {
        DisableSoundsOnSceneChange();
    }

    void RecieveWinState(object sender, GameStateExecutor.OnChangeGameStateEventArgs e)
    {
        DisableSoundsOnSceneChange();
    }
    /* void Start()
     {

     }*/


    #region PigeonSounds
    public void PigeonPeckSound()
    {
        pigeon_toc.start();
    }
    public void PigeonFatRollingSound()
    {
        pigeon_fatroll.start();
    }
    public void PigeonFatRollingSoundStop()
    {
        pigeon_fatroll.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
    }
    public void PigeonDrownSound()
    {
        pigeon_drown.start();
    }
    public void PigeonDefeatSound()
    {
        pigeon_defeat.start();
    }
    public void PigeonFixSound()
    {
        pigeon_fix.start();
    }

    public void PigeonFixIncrement()
    {
        pigeon_task_fix_increment.start();
    }



    public void PigeonVictorySound()
    {
        pigeon_vic.start();
    }
    public void PigeonFatTransformSound()
    {
        pigeon_fattransform.start();
    }
    public void PigeonAnxiousSound()
    {
        pigeon_anxious.start();
    }

    public void PigeonStartWalk()
    {
        pigeon_walk.start();
    }
    public void PigeonStopWalk()
    {
        pigeon_walk.stop(FMOD.Studio.STOP_MODE.IMMEDIATE);
    }


    public void PigeonStartSwim()
    {
        pigeon_swim.start();
    }


    public void PigeonStopSwim()
    {
        pigeon_swim.stop(FMOD.Studio.STOP_MODE.IMMEDIATE);
    }
    #endregion

    #region AmbientSounds
    public void ThunderSound()
    {

        thunder.start();

    }
    public void SeagullSound()
    {

        seagulls.start();

    }

    public void PlayWindSound()
    {
        motorEvent.start();
    }
    public void StopWindSound()
    {
        motorEvent.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
    }
    public void PlayAmbientSounds()
    {
        ambientEvent.start();
    }
    public void StopAmbient()
    {
        ambientEvent.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
    }
    public void AmbientSoundsSwitch(int ambientNr)
    {
        ambientEvent.setParameterByName("Stormy", ambientNr);
    }
    #endregion

    #region NPCSounds
    public void NPCLandingSound()
    {
        NPC_lands.start();
    }
    public void NPCStartledSound()
    {
        NPC_startled.start();
    }
    public void NPCStartledSoundStop()
    {
        NPC_startled.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
    }
    public void NPCFlySound()
    {
        NPC_flyaway.start();
    }
    #endregion

    #region TaskSounds
    public void WaterLeakStart()
    {
        waterLeakStart.start();
    }

    public void WaterLeakRunningStart()
    {
        waterLeakRunning.start();
    }
    public void WaterLeakRunningStop()
    {
        waterLeakRunning.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
    }

    public void LetAirOut()
    {
        letAirOut.start();
    }

    public void BlasebalgSound()
    {
        blasebalg.start();
    }

    public void MotorStart()
    {
        motorStart.start();
    }
    public void MotorRunningStart()
    {
        motorRun.start();
    }

    public void MotorRunningStop()
    {
        motorRun.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
    }
    public void DangerBellSound()
    {
        danger_bell.start();
    }
    public void DangerBellSoundStop()
    {
        danger_bell.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
    }

    public void MotorSwitch(int motorNr)
    {
        motorEvent.setParameterByName("WindSpeed", motorNr);
    }


    public void BreakageSound()
    {
        boatBreakage.start();
    }
    #endregion

    #region SFX

    public void Play_End_Whistle_Sound()
    {
        end_whistle.start();
    }


    public void Play_Start_Whistle_Sound()
    {
        start_whistle.start();
    }

    #endregion

    #region UI
    public void UIButtonPlay()
    {
        UI_Button.start();
    }


    public void UIButtonSelect()
    {
        UI_Selection.start();
    }

    public void UIPlayerReadySound()
    {
        UI_PlayerR.start();
    }
    #endregion

}
