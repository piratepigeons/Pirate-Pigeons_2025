using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAnimationHandler : MonoBehaviour
{
    public Animator pigeonAnimator;

    private void Start()
    {
        if(pigeonAnimator == null) pigeonAnimator = GetComponentInChildren<Animator>();
    }

    public void TriggerPeck()
    {
        if (pigeonAnimator == null) return;
        pigeonAnimator.SetTrigger("Peck");
    }


    public void TriggerJump()
    {
        if (pigeonAnimator == null) return;
        pigeonAnimator.SetTrigger("Jump");
    }

    public void SetWalk()
    {
        if (pigeonAnimator == null) return;
        pigeonAnimator.SetBool("IsWalking", true);
    }

    public void UnSetWalk()
    {
        pigeonAnimator.SetBool("IsWalking", false);
    }


    public void SetSwim()
    {
        pigeonAnimator.SetBool("InWater", true);
    }

    public void UnSetSwim()
    {
        pigeonAnimator.SetBool("InWater", false);
    }

    public void SetAirTime()
    {
        pigeonAnimator.SetBool("IsInAir", true);
    }

    public void UnsetAirTime()
    {
        pigeonAnimator.SetBool("IsInAir", false);
    }

    public void SetInflation()
    {
        if (pigeonAnimator == null) return;
        pigeonAnimator.SetBool("IsInflated", true);
    }

    public void UnSetInflation()
    {
        pigeonAnimator.SetBool("IsInflated", false);
    }


}
