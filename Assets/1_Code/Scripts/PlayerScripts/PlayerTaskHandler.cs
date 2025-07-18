using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using static UnityEngine.InputSystem.InputAction;
using UnityEngine.InputSystem;

public class PlayerTaskHandler : MonoBehaviour
{

    //private CustomInput input = null;

    [Header("Tasks")]
    [SerializeField] private LayerMask taskLayerMask;
    public Transform checkOrigin;
    public float checkRadius;
    public float maxDist;
    private TaskListener selectedTask;
   
    Collider[] taskCols;



    [Header("Focus")]
    public Transform focusCheckOrigin;
    public float focusRadius;
    Collider[] furtherTaskCols;
    TaskListener closestFocusTask;
    float minDistance;


    [Header("Egg Stuff")]
    public Transform eggHatch;
    public GameObject eggObject;

    

    [Header("other references")]
    public InitialMovement playerMovement;

    PickUpHandler pickUp;
    PointManager pm;

    private void Awake()
    {
        // input = new CustomInput();
        pm = GetComponent<PointManager>();
    }

    #region OnEnable/Disable
    private void OnEnable()
    {
        pickUp = GetComponent<PickUpHandler>();
       /* input.Enable();

        input.Player.Interact.performed += OnInteractPerformed;
        input.Player.Interact.canceled += OnInteractCancelled;*/
    }

    private void OnDisable()
    {
        /*input.Disable();

        input.Player.Interact.performed -= OnInteractPerformed;
        input.Player.Interact.canceled -= OnInteractCancelled;*/
    }
    #endregion
    private void FixedUpdate()
    {
        HandleInteractions();
        HandleFocus();
    }
    void HandleInteractions()
    {
        if (playerMovement.playerIsDead)
        {
            return;
        }
        
        taskCols = null;
        taskCols = Physics.OverlapSphere(checkOrigin.position, checkRadius, taskLayerMask);
        if (taskCols.Length > 0)
        {
            foreach (Collider c in taskCols)
            {
                if (c.transform.TryGetComponent(out TaskListener tL))
                {
                    if (tL != selectedTask)
                    {
                        selectedTask = tL;
                        selectedTask.SelectedTask(transform);
                    }
                }
                else

                {
                    selectedTask.UnSelectedTask();
                    selectedTask = null;
                }
            }
        }
        else
        {
            if (selectedTask != null)
            {
                selectedTask.UnSelectedTask();
                selectedTask = null;
            }

        }

    }
    void HandleFocus()
    {
        if (playerMovement.playerIsDead)
        {
            return;
        }


        minDistance = Mathf.Infinity;
        furtherTaskCols = null;
        furtherTaskCols = Physics.OverlapSphere(focusCheckOrigin.position, focusRadius, taskLayerMask);
        if (furtherTaskCols.Length > 0)
        {
            foreach (Collider c in furtherTaskCols)
            {
                if (c.transform.TryGetComponent(out TaskListener tL))
                {
                    float dist = Vector3.Distance(transform.position, tL.transform.position);
                    if(dist < minDistance)
                    {
                        closestFocusTask = tL;
                        minDistance = dist;
                    }
                    
                }
                /*else

                {
                    closestFocusTask = null;
                }*/
            }

            if(closestFocusTask != null)
            {
                playerMovement.MoveTowardsTask(closestFocusTask.transform);
            }
        }
        else
        {
            if (closestFocusTask != null)
            {
                closestFocusTask = null;
            }

        }

    }

    #region EggStuff
    
    
    /*bool EggCheck()
    {
        Collider[] col = Physics.OverlapSphere(waterChecker.position, waterCheckerRadius);

        if (col == null)
        {
            return false;
        }
        foreach (Collider c in col)
        {
            if (c.gameObject.CompareTag("Egg"))
            {

                return true;
                //col.Remove(c);
            }

        }

        return false;

    }

    void Slip()
    {
        return;
    }*/

    #endregion


    public void OnInteractPerformed(CallbackContext value)
    {
        SoundManager.Instance.PigeonPeckSound();
        if (selectedTask != null)
        {
            selectedTask.PerformTasks();
            if (selectedTask.awardsPoints)
            {
                if(pm!= null)
                {
                    pm.AddPoints(selectedTask.pointsToAward);
                }
                
            }
        }

        if (!playerMovement.isGrounded)
        {
            //Instantiate(eggObject, eggHatch.transform.position, eggHatch.transform.rotation);
        }

        pickUp.InteractPerformed();
    }
   public  void OnInteractCancelled(CallbackContext value)
    {
        pickUp.InteractCancelled();
    }

    public void OnFocusPerformed(CallbackContext value)
    {
        //HandleFocus();
    }

    public void OnFocusCancelled(CallbackContext value)
    {
       // furtherTaskCols = null;
    }

    private void OnDrawGizmos()
    {

      
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(checkOrigin.position, checkRadius);
        Gizmos.color = Color.blue;
        Gizmos.DrawWireSphere(focusCheckOrigin.position, focusRadius);
    }
}
