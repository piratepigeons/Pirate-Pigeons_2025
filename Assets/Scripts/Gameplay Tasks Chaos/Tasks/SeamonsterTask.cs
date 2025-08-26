using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SeamonsterTask : MonoBehaviour
{
    Animator anim;
    public int hits = 3;
    int hitsLeft;
    // Start is called before the first frame update
    void Awake()
    {
        anim = GetComponentInParent<Animator>();
        hitsLeft = hits;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void ActivateMonster()
    {
        anim.SetTrigger("GoDown");
    }

    public void HitMonster()
    {
        hitsLeft--;
        if (hitsLeft <= 0)
        {
            DeactivateMonster();
        }
    }

    public void DeactivateMonster()
    {
        hitsLeft = hits;
        anim.SetTrigger("GoUp");
    }
}
