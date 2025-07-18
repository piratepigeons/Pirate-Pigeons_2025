using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FinishPanelAnimationManager : MonoBehaviour
{
    public Animator anim;

    private void Start()
    {
        if(SoundManager.Instance != null)
        {
            SoundManager.Instance.Play_Start_Whistle_Sound();
        }
    }
    public void TriggerEndAnim()
    {
        anim.SetTrigger("endGame");
    }
}
