using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OceanHelper : MonoBehaviour
{
    public BackGroundMover bgm;
    public float speed;
    //public float speedBoost;
    private float _wavesMoved = 0;
    public Material oceanWater;
    public bool isManipulating;
    public float modifyer;
    
    void Start()
    {
        //def wave z and set to 0
        _wavesMoved = 0f;
        oceanWater.SetFloat("_wavesZ", 0f);
    }

    void Update()
    {
        if (isManipulating)
        {
            speed = bgm.totalSpeed * modifyer;
        }
       
        //wavez += (thingstomove * wavespeed)
        //get speed / movement from other script
        oceanWater.SetFloat("_wavesZ", _wavesMoved += (Time.deltaTime * speed));
    }
}
