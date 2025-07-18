using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlagSpeedChanger : MonoBehaviour
{
    public Cloth[] flags;
    

    public void FastFlags()
    {
        foreach(Cloth f in flags)
        {
            f.externalAcceleration = new Vector3(-25, 0, -50);
        }
    }

    public void SlowFlags()
    {
        foreach (Cloth f in flags)
        {
            f.externalAcceleration = new Vector3(-25, 0,-5 );
        }
    }


}
