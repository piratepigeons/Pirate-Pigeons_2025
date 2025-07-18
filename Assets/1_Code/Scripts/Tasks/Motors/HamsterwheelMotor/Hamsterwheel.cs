using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Hamsterwheel : MonoBehaviour
{
    public enum HorizontalPosition
    {
        left,
        right
    }
    
    public HorizontalPosition currentPosition;

    float direction;

    public Steering steering;
    public GameObject wheelToRotate;
    public float maxSpeed;
    public float speedIncrease = 0.5f;
    public float speedDecrease = 1.5f;
    public float speedThreshhold = 0.1f;
    public float hamsterWheelSpeed;
    
    Vector3 newRotation;
    // Start is called before the first frame update
    void Start()
    {
        switch (currentPosition)
        {
            case HorizontalPosition.left:
                direction = 1;
                break;
            case HorizontalPosition.right:
                direction = -1;
                break;
            default:
                direction = 1;
                break; 
        }
    }
    public void RecieveSpeedIncrease(bool isForward)
    {
        if (isForward)
        {
            hamsterWheelSpeed += speedIncrease;
        }
        else
        {
            hamsterWheelSpeed -= speedIncrease;
        }
        
        if(hamsterWheelSpeed >= maxSpeed)
        {
            hamsterWheelSpeed = maxSpeed;
        }
        if(hamsterWheelSpeed <= -maxSpeed)
        {
            hamsterWheelSpeed = -maxSpeed;
        }
    }
    // Update is called once per frame
    void Update()
    {
        if(hamsterWheelSpeed  > speedThreshhold)
        {
            hamsterWheelSpeed -= Time.deltaTime * speedDecrease;
        }

        else if(hamsterWheelSpeed < -speedThreshhold)
        {
            hamsterWheelSpeed += Time.deltaTime * speedDecrease;
        }
        else { hamsterWheelSpeed = 0; }
        newRotation.x += Time.deltaTime * (hamsterWheelSpeed*2f) * direction;


        if(newRotation.x > 360f)
        {
            newRotation.x -= 360f;
        }

        else if(newRotation.x < -360f)
        {
            newRotation.x += 360f;
        }
        wheelToRotate.transform.localRotation = Quaternion.Euler(newRotation);
        switch (currentPosition)
        {
            case HorizontalPosition.left:
                steering.hWheelLSpeed = hamsterWheelSpeed/12;
                break;
            case HorizontalPosition.right:
                steering.hWheelRSpeed = hamsterWheelSpeed/12;
                break;
            default:
                steering.hWheelLSpeed = hamsterWheelSpeed/12;
                break;
        }

    }
}
