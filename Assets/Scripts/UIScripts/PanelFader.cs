using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PanelFader : MonoBehaviour
{
    public GameObject visuals;

    private void Awake()
    {
        visuals.GetComponent<CanvasGroup>().alpha = 0;
    }
    private void OnEnable()
    {
        visuals.SetActive(true);
        LeanTween.alphaCanvas(visuals.GetComponent<CanvasGroup>(), 1, 0.2f).setEase(LeanTweenType.easeInOutSine);
    }

    private void OnDisable()
    {
        
        LeanTween.alphaCanvas(visuals.GetComponent<CanvasGroup>(), 0, 0.2f).setEase(LeanTweenType.easeInOutSine);
        visuals.SetActive(false);
        //StartCoroutine(DelayedDeactivate());
        
    }

    IEnumerator DelayedDeactivate()
    {
        yield return new WaitForSeconds(0.5f);
        visuals.SetActive(false);
    }
}
