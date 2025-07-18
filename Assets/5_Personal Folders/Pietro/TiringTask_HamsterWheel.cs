using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TiringTask_HamsterWheel : MonoBehaviour
{
    [SerializeField] private Hamsterwheel hamsterwheelRef;
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
        if (other.CompareTag("Player_SmallerHitbox"))
        {
            initialMovementRef.currentStamina -= 2;
        }
    }
}
