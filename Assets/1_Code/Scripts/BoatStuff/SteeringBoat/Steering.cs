using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Steering : MonoBehaviour
{
    [Header("AutoMove")]
    public bool moveForwardAutomatically;
    public float autoForwardSpeed;
    float currentAutoSpeed;

    [Space]
    [Header("References")]
    public Transform raft;
    public Transform rotatingBackGround;
    public Transform movingBackground;
    [Header("Move Speed")]
    public float moveSpeedMultiplier = 30f;
    float moveSpeedToApproach;
    float currentActiveSpeed;
    public float maxForwardSpeed = 25f;
    public float maxBackwardsSpeed = -3;
    float currentZRot;
    float totalSpeed;
    [Space]
    [Header("Steering:")]
    
    
    
    [Space]
    
    [Header("Rotation Steering")]
    public bool useRotaionSteering;
    [Tooltip("controls how high the rotation speed can get")] // 150 - 400 f
    public float rotationSpeedMultiplier = 1f;
    [Tooltip("controlls how quick the rotation speed changes (inertia) less means quicker control")] //   (0.2 - 5f)
    public float rotationInertia = 180f; 

    float currentRotationSpeed;
    float rotationSpeedToApproach;
    float currentHamsterwheelTorque = 1;

    [Header("Slide Steering")]
    public bool useSlideSteering;
    [Tooltip("controls how high the slide speed can get ")] // (150 - 400f)
    public float slideSpeedMultiplier = 118f; 
    [Tooltip("controlls how quick the slide speed changes (inertia)")] //  (0.2 - 5f)
    public float slideInertia = 2; 
    [Range(0f, 1f)]
    [Tooltip("controls how much the total Speed influences the left/right steering")]
    public float speedInfluence; 
    [Tooltip("controls at which total Speed you have max  left/right steering abillity")] // (10 - 25f)
    public float speedInfluenceCeiling = 15f;
    public float slideRotationSensitivity = 2f;
    float speedModificationFactor;
    float boundDistance;
    float slideRotateSpeedToApproach;
    
    float currentSidewaysSpeed;
    float currentXRot;

    [Space]
    [Header("Internal Values")]
    public float hWheelLSpeed;
    public float hWheelRSpeed;
    float canMoveMultiplier;

    public bool isCollidingFront;
    public bool isCollidingBack;
    public bool isCollidingLeft;
    public bool isCollidingRight;

    float vel;
    float rotVel;
    float slideVel;


    private void Start()
    {
        currentAutoSpeed = 0;
    }
    // Update is called once per frame
    void Update()
    {
        #region forward/backward movement
        currentZRot = raft.localEulerAngles.z;
        if (currentZRot > 180f)
        {
            currentZRot -= 360f;
        }
       // moveSpeedToApproach = (currentZRot / 2) * moveSpeedMultiplier;


        if(hWheelLSpeed * hWheelRSpeed > 0 && hWheelRSpeed > 1 && hWheelLSpeed > 1)
        {
            canMoveMultiplier = 1;

        }
        else
        {
           // canMoveMultiplier = 0;
        }
        moveSpeedToApproach = (hWheelLSpeed + hWheelRSpeed) * canMoveMultiplier;

        currentActiveSpeed = Mathf.SmoothDamp(currentActiveSpeed, moveSpeedToApproach, ref vel, 35*Time.deltaTime);
        if (moveForwardAutomatically)
        {
            currentAutoSpeed = autoForwardSpeed;
        }
        

        /*if(currentSpeed > maxForwardSpeed)
        {
            currentSpeed = maxForwardSpeed;
        }*/
        if(currentActiveSpeed <= maxBackwardsSpeed)
        {
            currentActiveSpeed = maxBackwardsSpeed;
        }

        if (isCollidingFront)
        {
            if(currentActiveSpeed > 0)
            {
                currentActiveSpeed = 0;
            }
            if (currentAutoSpeed > 0)
            {
                currentAutoSpeed = 0;
            }
            
            


        }
        if (isCollidingBack)
        {
            if (currentActiveSpeed < 0)
            {
                currentActiveSpeed = 0;
            }
            if (currentAutoSpeed < 0)
            {
                currentAutoSpeed = 0;
            }
        }
        /*if (!isCollidingFront)
        {
            ForwardMovement(-10f);
        }*/

        totalSpeed = currentActiveSpeed + currentAutoSpeed;
        ForwardMovement(-totalSpeed);
        /*if (moveForwardAutomatically)
        {
            ForwardMovement(-currentAutoSpeed);
        }*/
        /*
         * 
         *
         *
         */

        #endregion


        #region left/right steering
        currentHamsterwheelTorque = hWheelLSpeed + (hWheelRSpeed * -1f);
        currentXRot = raft.localEulerAngles.x;


        if (currentXRot > 180f)
        {
            currentXRot -= 360f;
        }
        if (useRotaionSteering)
        {
            TurnRotation();
        }
        if(useSlideSteering)
        {
            SlideRotation();
        }
        
        /*
         * 
         * 
         * 
         */

        #endregion


    }

    void TurnRotation()
    {
        rotationSpeedToApproach = /*(currentXRot / 6) * */rotationSpeedMultiplier * currentHamsterwheelTorque;
        currentRotationSpeed = Mathf.SmoothDamp(currentRotationSpeed, rotationSpeedToApproach, ref rotVel, rotationInertia * Time.deltaTime);
        
        if (isCollidingLeft && currentRotationSpeed > 0)
        {
            currentRotationSpeed = 0;
        }

        if (isCollidingRight && currentRotationSpeed < 0)
        {
            currentRotationSpeed = 0;
        }
        RotateAroundAxis(Vector3.up, -currentRotationSpeed);
    }

    void SlideRotation()
    {
        slideRotateSpeedToApproach = (currentXRot / slideRotationSensitivity) * slideSpeedMultiplier /** currentHamsterwheelTorque*/;
        currentSidewaysSpeed = Mathf.SmoothDamp(currentSidewaysSpeed, slideRotateSpeedToApproach, ref slideVel, slideInertia * Time.deltaTime);
        speedModificationFactor = Mathf.Lerp(1f, Mathf.Clamp01(Mathf.Abs(totalSpeed) / speedInfluenceCeiling), speedInfluence);
        currentSidewaysSpeed *= speedModificationFactor;
        if (isCollidingRight && currentSidewaysSpeed > 0)
        {
            currentSidewaysSpeed = 0;
        }

        if (isCollidingLeft && currentSidewaysSpeed < 0)
        {
            currentSidewaysSpeed = 0;
        }
        SidewaysMovement(-currentSidewaysSpeed);
    }

    void SidewaysMovement(float speed)
    {
        Vector3 currentPos = movingBackground.position;
        movingBackground.position = new Vector3(currentPos.x + speed * Time.deltaTime, currentPos.y, currentPos.z);
    }

    void ForwardMovement(float speed)
    {
        Vector3 currentPos = movingBackground.position;
        movingBackground.position = new Vector3(currentPos.x, currentPos.y, currentPos.z + speed * Time.deltaTime);
    }

    void RotateAroundAxis(Vector3 axis,float speed)
    {
        // Rotate the transform around the specified axis
        rotatingBackGround.Rotate(axis, speed * Time.deltaTime);
    }
}
