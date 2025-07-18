using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RepellPlayer : MonoBehaviour
{
    public Vector3 direction;
    InitialMovement movementScript;
    public float force = 1;
    private void OnTriggerStay(Collider collision)
    {
        // Check if the colliding objects have the "Player" tag
        if (collision.gameObject.CompareTag("Player"))
        {
            movementScript = collision.gameObject.GetComponent<InitialMovement>();
            movementScript.blockMovement = true;
            // Apply a force to the other collider
            Rigidbody otherRigidbody = collision.gameObject.GetComponent<Rigidbody>();
            //otherRigidbody.isKinematic = true;
            //Vector3 forceDirection = otherRigidbody.transform.position - transform.position;

            Vector3 dir = collision.transform.position - transform.position;
            otherRigidbody.AddForce(dir * force, ForceMode.Impulse);
        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            Rigidbody otherRigidbody = other.gameObject.GetComponent<Rigidbody>();
            otherRigidbody.isKinematic = false;
            movementScript = other.gameObject.GetComponent<InitialMovement>();
            movementScript.blockMovement = false;
        }
    }
}
