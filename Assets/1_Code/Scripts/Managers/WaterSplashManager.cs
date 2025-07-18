using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterSplashManager : MonoBehaviour
{
    public ParticleSystem waterRipples;
   // Vector3 waterRipplesStartSize;
    public bool hasWaterripplesOnStart;
    //public LeanTweenType tweenType;
    //public float tweenTime = 0.2f;

    private void Start()
    {
        /*waterRipplesStartSize = waterRipples.transform.localScale;
        waterRipples.SetActive(hasWaterripplesOnStart);*/

        if (!hasWaterripplesOnStart)
        {
            waterRipples.Stop();
        }
    }
    public void OnWaterEnter()
    {
        waterRipples.Play();
        /*waterRipples.SetActive(true);
        waterRipples.transform.localScale = Vector3.zero;
        LeanTween.scale(waterRipples, waterRipplesStartSize, tweenTime).setEase(tweenType);*/
    }


    public void OnWaterExit()
    {
        waterRipples.Stop();
       /* LeanTween.scale(waterRipples, Vector3.zero, tweenTime).setEase(tweenType);
        LeanTween.delayedCall(tweenTime, DelayedDisable);*/

    }

    /*void DelayedDisable()
    {
        waterRipples.SetActive(false);
    }*/

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Water"))
        {
            OnWaterEnter();
        }
    }


    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Water"))
        {
            OnWaterExit();
        }
    }



    
}
