using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RippleOrigin : MonoBehaviour
{

[SerializeField]
GameObject rippleFx;
    

    private void AddRipples(Transform objectTransform){
        var newRipple = Instantiate(rippleFx);
        //newRipple.parent.transform = objectTransform;
        //TO DO make a list and add there and then check list to clear it when destroyed
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.layer == 3)
        {
            AddRipples(other.gameObject.transform);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        /*if(other.gameObject.layer == 3 && other.gameObject.GetComponent<ParticleSystem> != null)
        {
            var destroyable = other.gameObject.GetComponentInParent<ParticleSystem>();
        }*/
    }
}
