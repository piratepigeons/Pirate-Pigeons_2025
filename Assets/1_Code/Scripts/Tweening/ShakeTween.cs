using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class ShakeTween : MonoBehaviour
{

    public Transform objectToShake;
    public float shakeStrength = 0.75f;
    public float shakeTime = 0.01f;
    public int vibrato = 10;
    public void ShakeObject()
    {
        objectToShake.DOShakePosition(shakeTime, shakeStrength, vibrato);
        objectToShake.DOShakeRotation(shakeTime, shakeStrength, vibrato);
        
        // LeanTween.moveLocal(boatVisuals, Vector3.one, 0.65f).setEaseShake();
    }

    public void ShakeOverTime(float time)
    {
        objectToShake.DOShakePosition(time, shakeStrength, vibrato);
        objectToShake.DOShakeRotation(time, shakeStrength, vibrato);
    }
}
