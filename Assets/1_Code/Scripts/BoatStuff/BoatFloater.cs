using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoatFloater : MonoBehaviour
{
    Floating floater;
    float newOffset;

    private void Start()
    {
        floater = GetComponent<Floating>();
        if(HealthManager.Instance != null)
        {
            newOffset = HealthManager.Instance.highFloatOffset;
        }
        else { newOffset = floater.offset; }
        
        SetNewOffset();
    }

    private void OnEnable()
    {
        
            HealthManager.OnUpdateHealthLevel += RecieveHealthUpdate;
        
        
        
    }

    private void OnDisable()
    {
       
            HealthManager.OnUpdateHealthLevel -= RecieveHealthUpdate;
        
        
    }


    void RecieveHealthUpdate(object sender, HealthManager.OnHealthUpdateEventArgs e)
    {
        newOffset = e.newFloaterOffset;
        SetNewOffset();
    }

    void SetNewOffset()
    {
        floater.offset = newOffset;
    }


}
