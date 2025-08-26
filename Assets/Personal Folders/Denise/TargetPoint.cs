using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TargetPoint : MonoBehaviour
{
    private Vector3 collision = Vector3.zero;
    private Vector3 positionAdjustment;


    public GameObject lastHit;
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (Physics.Raycast(transform.position, Vector3.down, out RaycastHit hit))
        {
            if (hit.collider.gameObject.CompareTag("Ground"))
            {
                positionAdjustment = hit.transform.position;
                transform.position = new Vector3(positionAdjustment.x, positionAdjustment.y + 1, positionAdjustment.z);
            }
        }


        /*
        Ray ray = new Ray(this.transform.position, this.transform.up);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit, 100))
        {
            lastHit = hit.transform.gameObject;
            collision = hit.point;
        }
    }

    
    private void OnDrawGizmos()
    {
        Gizmos.color = Color.white;
        Gizmos.DrawSphere(collision, 0.2f);
        Debug.Log("blup");
    }
    */
    }
}
