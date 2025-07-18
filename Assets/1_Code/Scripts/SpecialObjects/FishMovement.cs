using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(Rigidbody))]
public class FishMovement : MonoBehaviour
{
    public Animator anim;
    int randomWaitTime = 0;
    int currentTimer = 0;
    public float jumpStrength = 10;
    bool isGrounded;
    Rigidbody rb;
    Vector3 randomRot;
    // Start is called before the first frame update
    void Start()
    {
        
        rb = GetComponent<Rigidbody>();
        
        

        
    }

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
        if (rb == null)
        {
            return;
        }
        if (currentTimer > 0)
        {
            currentTimer--;
        }
        else
        {

            randomWaitTime = Mathf.RoundToInt(Random.Range(1f, 3f));
            currentTimer = randomWaitTime;
            if (isGrounded)
            {
                randomRot.x = Random.Range(-90f, 90f);
                //randomRot.y = Random.Range(-90f, 90f);
                randomRot.z = Random.Range(-90f, 90f);
                rb.AddForce(Vector3.up * jumpStrength, ForceMode.Impulse);
                rb.AddTorque(randomRot * 0.1f, ForceMode.Impulse);
                anim.SetTrigger("Jump");
            }

        }
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Floor") || other.CompareTag("Water"))
        {
            isGrounded = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Floor") || other.CompareTag("Water"))
        {
            isGrounded = false;
        }
    }
}
