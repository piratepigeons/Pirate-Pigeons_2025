using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FixHamsterWheelTask : MonoBehaviour
{
    public float takeAwayAmount;

    public float currentBrokenLevel;
    public float startBrokenLevel;

    public bool brokenState = false;

    [SerializeField] private HamsterwheelBreacker hamsterwheelBreackerRef;

    private void OnEnable()
    {
        ResetBrokenLevel();
    }

    public void ResetBrokenLevel()
    {
        currentBrokenLevel = startBrokenLevel;
        brokenState = false;
    }

    public void DecreaseBrokenLevel()
    {
        if (SoundManager.Instance != null)
        {
            SoundManager.Instance.PigeonFixIncrement();
        }
        if (currentBrokenLevel > 0)
        {
            currentBrokenLevel -= takeAwayAmount;
        }
        else
        {
            if (!brokenState)
            {
                brokenState = true;
                hamsterwheelBreackerRef.RepairWheel();
                gameObject.SetActive(false);
            }
        }
    }
}
