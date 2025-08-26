using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EndingLoseAnimTween : MonoBehaviour 
{
    public CanvasGroup blackScreen;
    public GameObject buttons;
    public CanvasGroup mainCanvas;
   // public GameObject ResultManagerObj;
    Vector3 startingButtonPos;
    private void Awake()
    {
        startingButtonPos = buttons.transform.position;
    }
    private void OnEnable()
    {
        StartCoroutine(LosingCoroutine());
    }

    IEnumerator LosingCoroutine()
    {
        LeanTween.alphaCanvas(blackScreen, 0, 0.3f).setEase(LeanTweenType.easeInQuint);
        yield return new WaitForSeconds(2.5f);
        LeanTween.alphaCanvas(mainCanvas, 1, 0.5f).setEase(LeanTweenType.easeInQuint);
        //ResultManagerObj.SetActive(true);
        yield return new WaitForSeconds(0.5f);
        buttons.SetActive(true);
        buttons.transform.position -= new Vector3(0, 150, 0);
        LeanTween.move(buttons, startingButtonPos, 0.5f).setEase(LeanTweenType.easeOutBounce);
    }
}
