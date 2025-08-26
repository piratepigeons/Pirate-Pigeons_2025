using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SinkBoat : MonoBehaviour
{
    private void OnEnable()
    {
        LeanTween.moveLocalY(gameObject, -500, 30f);
    }
}
