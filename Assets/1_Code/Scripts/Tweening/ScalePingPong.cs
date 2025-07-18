using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScalePingPong : MonoBehaviour
{
    public LeanTweenType tweencurve;
    public Vector3 scaleTo;
    public float interval = 0.5f;
    // Start is called before the first frame update
    void Start()
    {
        LeanTween.scale(gameObject, scaleTo, interval).setLoopPingPong().setEase(tweencurve);
    }
}
