using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using TMPro;

public class MotorTask : MonoBehaviour
{
    //public TextMeshProUGUI text;
    public class OnMotorEventArgs : EventArgs
    {
        public float motorSpeed;
    }
    float motorUseTime;
    float motorSpeed = 10f;
    public static  event EventHandler<OnMotorEventArgs> OnMotorActivate;
    public static event EventHandler<OnMotorEventArgs> OnMotorEnd;
    
    public ShakeTween shaker;
    public ParticleSystem[] particlesToPlay;

    public bool blockMotor;

    private void OnEnable()
    {
        DifficultyManager.OnSetDifficultyLevel += SetDifficulty;
        MotorBlockerManager.OnMotorBlock += BlockMotor;
        MotorBlockerManager.OnMotorUnBlock += UnBlockMotor;
    }

    private void OnDisable()
    {
        DifficultyManager.OnSetDifficultyLevel -= SetDifficulty;
        MotorBlockerManager.OnMotorBlock -= BlockMotor;
        MotorBlockerManager.OnMotorUnBlock -= UnBlockMotor;
    }


    public void SetDifficulty (object sender, DifficultyManager.OnLoadDifficultyArgs e)
    {
        motorSpeed = e.motorSpeed;
        motorUseTime = e.motorTime;
    }

    void BlockMotor(object sender, MotorBlockerManager.OnMotorBlockEventArgs e)
    {
        blockMotor = true;
    }

    void UnBlockMotor(object sender, MotorBlockerManager.OnMotorBlockEventArgs e)
    {
        blockMotor = false;
    }

   
    public void OnMotorDrive()
    {
        if(blockMotor)
        {
            return;
        }
        if (OnMotorActivate != null) OnMotorActivate(this, new OnMotorEventArgs { motorSpeed = motorSpeed});
        shaker.ShakeOverTime(motorUseTime);
        foreach (ParticleSystem p in particlesToPlay)
        {
            p.Play();
        }
        if (SoundManager.Instance != null) 
        {
            SoundManager.Instance.MotorStart();
            SoundManager.Instance.MotorRunningStart();
            SoundManager.Instance.LetAirOut();
        }
        StartCoroutine(EndMotor());
            
    }


    IEnumerator EndMotor()
    {
        yield return new WaitForSeconds(motorUseTime);
        foreach(ParticleSystem p in particlesToPlay)
        {
            p.Stop();
        }
        if (SoundManager.Instance != null)
        {
            SoundManager.Instance.MotorRunningStop();
        }
        if (OnMotorEnd != null) OnMotorEnd(this, new OnMotorEventArgs { motorSpeed = motorSpeed });
    }
}
