using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ArtificialGravity : MonoBehaviour
{
    private Rigidbody rb;
    bool useGravity;
    public float gravityForce;
    // Start is called before the first frame update
    void Awake()
    {
        rb = GetComponent<Rigidbody>();
        useGravity = rb.useGravity;
        rb.useGravity = false;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if (useGravity) rb.AddForce(Physics.gravity * (gravityForce));
    }
}
