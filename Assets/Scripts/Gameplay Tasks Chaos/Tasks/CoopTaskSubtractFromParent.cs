using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CoopTaskSubtractFromParent : MonoBehaviour
{
    CoopTask ct;

    private void Awake()
    {
        ct = GetComponentInParent<CoopTask>();
    }

    public void SubtractMainTaskPoints()
    {
        ct.SubtractPoints();
    }
}
