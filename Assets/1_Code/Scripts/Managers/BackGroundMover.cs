using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class BackGroundMover : MonoBehaviour
{
    public static BackGroundMover Instance { get; private set; }
    public Transform startTransform;
    public Transform endTransform;
    public GameObject objectsToMoveParent;
    public Slider progressBar;


    [SerializeField]
    private float totalDistance;
    
    public float distanceReachedPercent;
    [SerializeField]
    float currentDistance;
    
    public bool goalReached;
    bool winState = false;
    
    [Header("Movement Speed")]
    [SerializeField]
    public float totalSpeed;
    public float idleSpeed;

    [SerializeField]
    bool isMotorSpeeding;//true: motorspeed false: 1
    private float speedMultiplier;
    float currentSpeedMultiplier;
    public float speedUpSpeed = 10f;
    public float speedDownSpeed = 30f;

    bool isBlocked;// true: 1 false: 0
    public float obstacleSpeedMulitplier = 1;
    public float blockWindupSpeed = 3f;


    [Header("References")]

    public EndLandTriggerManager endLandTrigger;

    private void Awake()
    {
        // If there is an instance, and it's not me, delete myself.

        if (Instance != null && Instance != this)
        {
            Destroy(this);
        }
        else
        {
            Instance = this;
        }

    }

    // Start is called before the first frame update
    void Start()
    {
        totalDistance = endTransform.position.z - startTransform.position.z;
        currentSpeedMultiplier = 1;
        speedMultiplier = 1f;
        MotorTask.OnMotorActivate += RecieveStartMotor;

        MotorTask.OnMotorEnd += RecieveEndMotor;
    }
    private void OnEnable()
    {
        DifficultyManager.OnSetDifficultyLevel += RecieveDifficultyLevel;
    }

    private void OnDisable()
    {
        MotorTask.OnMotorActivate -= RecieveStartMotor;
        MotorTask.OnMotorEnd -= RecieveEndMotor;

        DifficultyManager.OnSetDifficultyLevel -= RecieveDifficultyLevel;
    }

    void RecieveDifficultyLevel(object sender, DifficultyManager.OnLoadDifficultyArgs e)
    {
        idleSpeed = e.idleSpeed;
    }

    void RecieveEndMotor(object sender, MotorTask.OnMotorEventArgs e)
    {
        isMotorSpeeding = false;
        speedMultiplier = 1;
    }


    void RecieveStartMotor(object sender, MotorTask.OnMotorEventArgs e)
    {
        if (goalReached /*&& !winState*/)
        {
            //winState = true;
            //GameStateManager.Instance.SetGameState(GameStateManager.GameState.win);
            return;
        }
        isMotorSpeeding = true;
        speedMultiplier = e.motorSpeed;
    }


    void FixedUpdate()
    {
        if (goalReached && !winState)
        {
            winState = true;
            endLandTrigger.PlayEndCeremony();
            //GameStateManager.Instance.SetGameState(GameStateManager.GameState.win);
            return;
        }
        CalculateDistance();
        IslandMoverManager();
    }

    void IslandMoverManager()
    {

        CalculateSpeedMultipliers();


        totalSpeed = idleSpeed * currentSpeedMultiplier * Time.fixedDeltaTime * obstacleSpeedMulitplier;
        objectsToMoveParent.transform.position = new Vector3(objectsToMoveParent.transform.position.x, objectsToMoveParent.transform.position.y, objectsToMoveParent.transform.position.z - totalSpeed);
    }



    void CalculateDistance()
    {
        currentDistance = Mathf.Abs(objectsToMoveParent.transform.position.z);
        distanceReachedPercent = (100f / totalDistance) * currentDistance;
        if(MusicManager.Instance != null)
        {
            MusicManager.Instance.SetProgressMusic(distanceReachedPercent);
        }
        
        progressBar.value = distanceReachedPercent;
        if (distanceReachedPercent >= 100f)
        {
            
            goalReached = true;
            idleSpeed = 0;
        }
    }


    public void StopMovement()
    {
        isBlocked = true;
    }

    public void ContinueMovement()
    {
        isBlocked = false;
    }

    void CalculateSpeedMultipliers()
    {


        //Smooth out Stop, Start 0 to 1
        //obstacleSpeedMulitplier = SpeedSmoother(isBlocked, 1f,0f, obstacleSpeedMulitplier, blockWindupSpeed);
        if (!isBlocked)
        {
            if(obstacleSpeedMulitplier < 1)
            {
                //move towards 1;
                obstacleSpeedMulitplier += Time.fixedDeltaTime * blockWindupSpeed;
            }
            else
            {
                obstacleSpeedMulitplier = 1f;
            }
        }
        else
        {
            if(obstacleSpeedMulitplier > 0)
            {
                //move towards 0;
                obstacleSpeedMulitplier -= Time.fixedDeltaTime * blockWindupSpeed;
            }

            else
            {
                obstacleSpeedMulitplier = 0f;
            }
        }

        //Smooth out Motor Move: 1 to speedMultiplier
        //currentSpeedMultiplier = SpeedSmoother(isMotorSpeeding, speedMultiplier, 1f, currentSpeedMultiplier, speedUpSpeed);

        if (isMotorSpeeding)
        {
            if (currentSpeedMultiplier < speedMultiplier)
            {
                //move towards 1;
                currentSpeedMultiplier += Time.fixedDeltaTime * speedUpSpeed;
            }
            else
            {
                currentSpeedMultiplier = speedMultiplier;
            }
        }
        else
        {
            if (currentSpeedMultiplier > 1)
            {
                //move towards 0;
                currentSpeedMultiplier -= Time.fixedDeltaTime * speedDownSpeed;
            }
            else
            {
                currentSpeedMultiplier = 1f;
            }
        }
        /*if (currentTimer > 0)
        {
            currentTimer -= Time.fixedDeltaTime;
        }
        else
        {
            speedMultiplier = 1f;
        }*/
    }


    float SpeedSmoother(bool boolToCheck,float floatToApproach, float lowerLimit, float floatToChange, float changeSpeed)
    {
        if (!boolToCheck)
        {
            if (floatToChange <= lowerLimit)
            {
                //move towards 0;
                floatToChange -= Time.fixedDeltaTime * changeSpeed;
                
            }
        }
        else
        {
            if (floatToChange < floatToApproach)
            {
                //move towards floatToChange;
                floatToChange += Time.fixedDeltaTime * changeSpeed;
            }
            
        }
        return floatToChange;
    }
}
