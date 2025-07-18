using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HamsterwheelAccelerator : MonoBehaviour
{
    public Hamsterwheel hWheel;
    //public float speedIncreaser;
    public bool isForward;

    [SerializeField] private InitialMovement initialMovementRef;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player_SmallerHitbox"))
        {
            initialMovementRef = other.gameObject.GetComponentInParent<InitialMovement>();
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if(other.CompareTag("Player_SmallerHitbox"))
        {
            if(!initialMovementRef.isTired)
            {
                hWheel.RecieveSpeedIncrease(isForward);
            }
        }
    }
}
