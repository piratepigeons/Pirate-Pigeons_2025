using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pulsate : MonoBehaviour
{
    public Vector3 size = new Vector3(.9f, .9f, .9f);
    public float intervall = 0.5f;
    // Start is called before the first frame update
    void Start()
    {
        LeanTween.scale(gameObject, size, intervall).setLoopPingPong().setEase(LeanTweenType.easeOutSine);
    }
}
