using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Floating : MonoBehaviour
{
    public Rigidbody rb;
    public float depthBeforeSubmerged = 1f;
    public float displacementAmount = 3f;
    public int floaterCount = 1;
    public float waterDrag = 0.99f;
    public float waterAngularDrag = 0.5f;

    //we have to get the height of the wave that is under it
    float waveHeight = 0;
    public float offset;
    public Transform water;
    private void Start()
    {
        if(water == null)
        {
            water = GameObject.Find("Water").transform;
            if(water == null)
            {
                Debug.LogError("There is no GameObject called 'Water'");
            }
        }
        if(rb == null)
        {
            rb = GetComponent<Rigidbody>();
        }
        if(rb == null)
        {
            rb = GetComponentInParent<Rigidbody>();
        }
    }

    
    private void FixedUpdate()
    {
        if(water == null)
        {
            return;
        }
        waveHeight = water.position.y + offset;
        rb.AddForceAtPosition(Physics.gravity / floaterCount, transform.position, ForceMode.Acceleration);
        if (transform.position.y < waveHeight)
        {
            float displacementMultiplier = Mathf.Clamp01((waveHeight - transform.position.y) / depthBeforeSubmerged) * displacementAmount;
            rb.AddForceAtPosition(new Vector3(0f, Mathf.Abs(Physics.gravity.y) * displacementMultiplier, 0f), transform.position, ForceMode.Acceleration);
            rb.AddForce(displacementMultiplier * -rb.velocity * waterDrag * Time.fixedDeltaTime, ForceMode.VelocityChange);
            rb.AddTorque(displacementMultiplier * -rb.angularVelocity * waterAngularDrag * Time.fixedDeltaTime, ForceMode.VelocityChange);
        }
    }
}
