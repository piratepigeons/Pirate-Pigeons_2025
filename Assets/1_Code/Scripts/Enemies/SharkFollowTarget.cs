using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SharkFollowTarget : MonoBehaviour
{
    public Transform targetToFollow;

    public float moveSpeed = 2f;
    public float rotationSpeed = 5f;

    float distance;
    Vector3 targetDirection;
    Vector3 newDirection;

    public float distanceBuffer = 1f;

    private void FixedUpdate()
    {
        GoToTarget(targetToFollow);
        RotateTowardsPoint(targetToFollow);
        

    }




    public void RotateTowardsPoint(Transform target)
    {

        // Determine which direction to rotate towards
        targetDirection = target.position - transform.position;
        // Rotate the forward vector towards the target direction by one step
        newDirection = Vector3.RotateTowards(transform.forward, targetDirection, Time.fixedDeltaTime * rotationSpeed, 0.0f);

        // Draw a ray pointing at our target in
        Debug.DrawRay(transform.position, newDirection, Color.red);

        // Calculate a rotation a step closer to the target and applies rotation to this object
        transform.rotation = Quaternion.LookRotation(newDirection);
    }


    public void GoToTarget(Transform newTarget)
    {
        distance = Vector3.Distance(transform.position, newTarget.position);
        // Check if the target is out of range of the buffer, move it towards target
        if (distance > distanceBuffer)
        {
            transform.position += transform.forward * Time.fixedDeltaTime * moveSpeed;
        }
    }

   
}
