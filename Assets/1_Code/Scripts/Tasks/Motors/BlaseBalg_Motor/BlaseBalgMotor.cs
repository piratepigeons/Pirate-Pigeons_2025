using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlaseBalgMotor : MonoBehaviour
{
    public Transform plank;
    HingeJoint plankHingeJoint;
    public float limit;
    public float currentLimit;

    bool stateSmall;
    bool stateBig;

    public int blowAmount;
    public int currentAmount;
    float blowPercent;


    public SkinnedMeshRenderer smr;
    public MultipleShapekeyManipulator msm;

    public List<PointManager> players = new List<PointManager>();

    public GameObject leftVisual;
    public GameObject rightVisual;


    public MotorTask motor;
    // Start is called before the first frame update
    void Start()
    {
        plankHingeJoint = plank.GetComponent<HingeJoint>();
        limit = plankHingeJoint.limits.max;
        stateSmall = true;
        stateBig = true;
    }

    // Update is called once per frame
    void Update()
    {
        currentLimit = plank.localEulerAngles.z;
        if(currentLimit > 180f)
        {
            currentLimit -= 360f;
        }

        if(currentLimit >= limit)
        {
            if (stateBig)
            {
                
                SetRightVisual();
                stateBig = false;
                stateSmall = true;
                IncreaseBlasebalg();
            }
            
        }

        if(currentLimit <= -limit)
        {
            if (stateSmall)
            {
                SetLeftVisual();
                stateSmall = false;
                stateBig = true;
                IncreaseBlasebalg();
            }
            
        }
    }


    void IncreaseBlasebalg()
    {
        
        if(currentAmount >= blowAmount)
        {
            LetAirOut();
            SoundManager.Instance.LetAirOut();
            return;
        }
        else
        {
            currentAmount++;
            blowPercent = (100 / blowAmount) * currentAmount;
            msm.PlayAnimation(Mathf.RoundToInt(blowPercent), 0.2f);
            SoundManager.Instance.BlasebalgSound();
        }
    }

    void SetLeftVisual()
    {
        leftVisual.SetActive(true);
        rightVisual.SetActive(false);
    }


    void SetRightVisual()
    {
        leftVisual.SetActive(false);
        rightVisual.SetActive(true);
    }
    void LetAirOut()
    {
        AwardPlayers();
        motor.OnMotorDrive();
        msm.PlaySpecialAnimation(0, 75f);
        currentAmount = 0;
        return;
    }


    void AwardPlayers()
    {
        if(players != null)
        {
            foreach(PointManager p in players)
            {
                p.AddPoints(35f);
            }
        }
    }
}
