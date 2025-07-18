using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(Rigidbody))]
public class EggManager : MonoBehaviour
{
    
    public Rigidbody rb;
    public float force = 50f;
    public GameObject crackedEggObject;
    bool state;
    // Start is called before the first frame update
    void Start()
    {
        if(rb == null)
        {
            rb = GetComponent<Rigidbody>();
        }
        rb.AddForce(Vector3.down * force, ForceMode.Impulse);
    }


    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Floor"))
        {
            if (!state)
            {
                state = true;
                StartCoroutine(CrackEgg(other));
            }
            
        }
    }


    IEnumerator CrackEgg(Collider other)
    {
        yield return new WaitForSeconds(0.1f);
        GameObject cracc;
        cracc = Instantiate(crackedEggObject, transform.position, Quaternion.identity);
        //cracc.transform.SetParent(other.transform, true);
        //cracc.transform.parent = other.gameObject.transform;
        Destroy(gameObject);
    }
   
}
