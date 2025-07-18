using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovePingPong : MonoBehaviour
{
    public Vector3 offset;
    public float interval = 0.5f;
    // Start is called before the first frame update
    void Start()
    {
        LeanTween.move(gameObject, offset, interval).setLoopPingPong();
    }
}
