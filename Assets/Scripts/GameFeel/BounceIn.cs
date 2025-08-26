using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BounceIn : MonoBehaviour
{
    public float delay = 1f;
    Vector3 startPos;
    private void Awake()
    {
        startPos = transform.position;
        gameObject.GetComponent<CanvasGroup>().alpha = 0;
    }

    private void OnEnable()
    {
        StartCoroutine(BounceInCoroutine());
    }

    IEnumerator BounceInCoroutine()
    {
        transform.position += new Vector3(0, 250, 0);
        
        yield return new WaitForSeconds(delay);
        LeanTween.alphaCanvas(gameObject.GetComponent<CanvasGroup>(), 1, 0.4f);
        LeanTween.move(gameObject, startPos, 0.7f).setEase(LeanTweenType.easeOutBounce);
    }
}
