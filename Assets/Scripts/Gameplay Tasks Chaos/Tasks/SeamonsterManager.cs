using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SeamonsterManager : MonoBehaviour
{
    public Animator[] anims;
    public bool activate;
    public float timeLength = 10;
    public float timer;

    private void Awake()
    {
        timer = timeLength;
        ActivateHand();

    }
    private void Update()
    {
        timer -= Time.deltaTime;
        if(timer <= 0)
        {
            ActivateHand();
            timer = timeLength;
        }
        
    }

    void ActivateHand()
    {
        for (int i = 0; i < anims.Length; i++)
        {
            anims[i].SetTrigger("GoDown");
        }
        
    }
}
