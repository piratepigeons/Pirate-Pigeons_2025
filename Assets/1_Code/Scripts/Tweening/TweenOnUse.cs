using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TweenOnUse : MonoBehaviour
{
    public LeanTweenType tweenType;
    public float tweenSpeed;
    [Tooltip("leave empty to tween this game object")]
    public GameObject objectToTween;
    public float moveAmt = 1.2f;
    Vector3 startPos;

    private void Start()
    {
        if (objectToTween == null)
        {
            objectToTween = gameObject;
        }
        startPos = objectToTween.transform.localPosition;
    }

    public void Move()
    {
        LeanTween.cancel(objectToTween);
        objectToTween.transform.localPosition = startPos;
        LeanTween.moveLocal(objectToTween, startPos + (Vector3.one* moveAmt), tweenSpeed).setEase(tweenType);
    }

    public void EndMove()
    {
        LeanTween.cancel(objectToTween);
    }
}
