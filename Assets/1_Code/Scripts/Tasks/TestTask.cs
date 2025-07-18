using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestTask : MonoBehaviour
{
    bool state;
    Vector3 startSize;
    private void Start()
    {
        startSize = transform.localScale;
    }
    public void Yall()
    {
        state = true;
        transform.localScale = Vector3.zero;
        LeanTween.scale(gameObject, startSize, 0.2f).setEase(LeanTweenType.easeOutBack);
    }

    public void TaskTest2(int i, float f)
    {
        Debug.Log("TEST: " + i + f);
    }
}
