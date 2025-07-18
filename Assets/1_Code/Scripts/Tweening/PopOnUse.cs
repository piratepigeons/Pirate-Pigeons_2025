using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PopOnUse : MonoBehaviour
{
    public LeanTweenType tweenType;
    public float tweenSpeed;
    [Tooltip("leave empty to tween this game object")]
    public GameObject objectToTween;
    public float tweenAmount = 1.2f;
    Vector3 startSize;

    private void Start()
    {
        if(objectToTween == null)
        {
            objectToTween = gameObject;
        }
        startSize = objectToTween.transform.localScale;
        //objectToTween.transform.localScale *= tweenAmount;
    }

    public void Pop()
    {
        LeanTween.cancel(objectToTween);
        objectToTween.transform.localScale = startSize * tweenAmount;
        LeanTween.scale(objectToTween, startSize, tweenSpeed).setEase(tweenType);
    }
}
