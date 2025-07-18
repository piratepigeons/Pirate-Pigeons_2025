using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SubMotorV3 : MonoBehaviour
{
    public bool baloonIsFull;
    public SkinnedMeshRenderer smr;
    float currentValue;

    bool cantUseBaloons;

    public float deflateSpeed = 25f;
    public float inflateAmount = 15f;

    // Start is called before the first frame update
    void Start()
    {
        currentValue = 0;
        smr.SetBlendShapeWeight(0, currentValue);
    }

    private void OnEnable()
    {
        MotorTask.OnMotorActivate += CanUseB;
        MotorTask.OnMotorEnd += CantUseB;

    }


    private void OnDisable()
    {
        MotorTask.OnMotorActivate -= CanUseB;
        MotorTask.OnMotorEnd -= CantUseB;
    }

    void CanUseB (object sender, MotorTask.OnMotorEventArgs e)
    {
        cantUseBaloons = true;
    }

    void CantUseB (object sender, MotorTask.OnMotorEventArgs e)
    {
        cantUseBaloons = false;
    }

    // Update is called once per frame
    void Update()
    {
        if(currentValue > 00)
        {

            currentValue -= Time.deltaTime * deflateSpeed;
            if(currentValue <= 0)
            {
                currentValue = 0;
            }
            smr.SetBlendShapeWeight(0, currentValue);
        }

        if (cantUseBaloons)
        {
            baloonIsFull = false;
            return;
        }
        if (currentValue >= 90)
        {
            baloonIsFull = true;
        }
        else
        {
            baloonIsFull = false;
        }
    }


    public void Inflate()
    {


        if (cantUseBaloons)
        {
            return;
        }
        if(SoundManager.Instance != null)
        {
            SoundManager.Instance.BlasebalgSound();
        }
        if (currentValue <= 100f)
        {
            currentValue += inflateAmount;
            
            if( currentValue >= 100f)
            {
                currentValue = 100f;
                //Balloon is full!
            }
            smr.SetBlendShapeWeight(0, currentValue);
        }

        
    }
}
