using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TentacleWeakpointLogic : MonoBehaviour
{
    public float waterSurfaceHeight;
    float currentHeight;
    public TentacleManager tm;
    // Start is called before the first frame update
    



    private void OnEnable()
    {
        TimeTickSystem.OnTick_5 += RecieveTickEvent;


    }



    private void OnDisable()
    {
        TimeTickSystem.OnTick_5 -= RecieveTickEvent;
    }


    void RecieveTickEvent(object sender, TimeTickSystem.OnTickEventArgs e)
    {
        CheckIfTentacleInWater();
    }


    void CheckIfTentacleInWater()
    {
        currentHeight = transform.position.y;
        if (currentHeight <= waterSurfaceHeight)
        {
            tm.KillTentacle();
        }
    }
    
}

