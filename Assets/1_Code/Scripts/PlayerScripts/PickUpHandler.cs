using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PickUpHandler : MonoBehaviour
{

    [SerializeField] private LayerMask pickUpLayerMask;
    InitialMovement playerMovement;
    public Transform checkOrigin;
    public float checkRadius;
    public float maxDist;

    Transform originalPickUpParent;
    private GameObject pickUpInMouth;
    private GameObject selectedPickUp;
    Collider[] collidersInMouth;
    Collider[] pickUpCols;

    public Transform beakTransform;

    public float throwForce = 25f;
    // Start is called before the first frame update
    void Start()
    {
        playerMovement = GetComponent<InitialMovement>();
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if (playerMovement.playerIsDead)
        {
            return;
        }
    }

    public void InteractPerformed()
    {

        


        pickUpCols = null;
        pickUpCols = Physics.OverlapSphere(checkOrigin.position, checkRadius, pickUpLayerMask);
        if (pickUpCols.Length > 0)
        {
            foreach (Collider c in pickUpCols)
            {

                if (c.GetComponent<Rigidbody>())
                {
                    selectedPickUp = c.gameObject;
                }
                

                /*if (c.transform.TryGetComponent(out TaskListener tL))
                {
                    if (tL != selectedTask)
                    {
                        selectedTask = tL;
                        selectedTask.SelectedTask();
                    }
                }
                else

                {
                    selectedTask.UnSelectedTask();
                    selectedTask = null;
                }*/
            }
        }
        else
        {
            selectedPickUp = null;
            /*if (selectedTask != null)
            {
                selectedTask.UnSelectedTask();
                selectedTask = null;
            }*/

        }

        

        if (pickUpInMouth != null)
        {
            Throw();
            return;
        }


        if (selectedPickUp != null && pickUpInMouth == null)
        {

            PickUp();
        }




    }

    void PickUp()
    {

        pickUpInMouth = selectedPickUp;
        if (selectedPickUp.transform.parent != null)
        {
            originalPickUpParent = selectedPickUp.transform.parent;
        }
        if (selectedPickUp.GetComponent<Collider>())
        {
            collidersInMouth = selectedPickUp.GetComponents<Collider>();
            foreach(Collider col in collidersInMouth)
            {
                col.enabled = false;
            }
        }
        selectedPickUp.transform.parent = beakTransform;
        selectedPickUp.transform.localPosition = Vector3.zero;
        selectedPickUp.GetComponent<Rigidbody>().isKinematic = true;
        
    }

    void Throw()
    {

        if (pickUpInMouth.GetComponent<Collider>())
        {
            // = selectedPickUp.GetComponents<Collider>();
            foreach (Collider col in collidersInMouth)
            {
                col.enabled = true;
            }
        }
        if (originalPickUpParent != null)
        {
            pickUpInMouth.transform.parent = originalPickUpParent;
            originalPickUpParent = null;
        }

        pickUpInMouth.GetComponent<Rigidbody>().isKinematic = false;
        pickUpInMouth.GetComponent<Rigidbody>().AddForce(transform.forward * throwForce, ForceMode.Impulse);
        pickUpInMouth = null;
        
    }


    public void InteractCancelled()
    {

    }
}
