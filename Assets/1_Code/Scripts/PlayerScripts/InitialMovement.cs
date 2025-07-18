using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEngine.InputSystem.InputAction;
using UnityEngine.SceneManagement;


[SelectionBase]
public class InitialMovement : MonoBehaviour
{
    [Header("BlockMovement")]
    public bool blockMovement;

    [Header("Movement")]
    [SerializeField]
    public float normalSpeed;
    public float ragdollSpeed;
    public Vector2 inputVector = Vector2.zero;
    Vector3 moveDirection;
    Vector3 moveVector;
    Vector3 intermediateRotationInflation;
    public Vector3 debugVector;

    public bool isTired = false;
    public float tiredSpeed;
    public float MaxStamina;
    public float currentStamina;

    float currentSpeed;

    [Header("Physics & Overlap Checkers")]
    
    
    Rigidbody rb;
    public Rigidbody headRb;
    float t;
    public Transform waterChecker;
    public GameObject floater;
    public float waterCheckerRadius = 1f;
    public bool waterCheckBool;

    public bool isPlayerNearWater;

    [Header("Momentum")]


    public float acceleration = 15;
    public float decceleration = 5f;

    float momentum = 0.5f;

    public float jumpUpMomentum = 0.1f;
    public float fallDownMomentum = 0.02f;
    float currentAirMultiplierMomentum;
    float currentWaterMultiplierMomentum;
    public float waterMomentumMultiplier = 4f;

    public float normalWeigth;
    public float heavyWeigth;

    [Header ("Jumping")]
    

    public float gravityScale;
    public float jumpStrength,normalJumpStrength, heavyJumpStrength , fallMultiplier, lowJumpMultiplier;
    bool jumpRequest, jumpButtonHold, inflateButtonHold;
    
    float globalGravity = -9.81f;
    public bool isGrounded;
    float currentGroundcheckSize;
    public float normalGroundCheckSize = 0.2f;
    public float heavyGroundCheckSize = 1f;
    public Transform groundChecker;
    

    [Header("Ragdolling")]
    
    public GameObject inflatedGraphics;
    public GameObject normalGraphics;
    public float force, forceRadius;
    Vector3 inflatedGraphicsSize;

    

    [Header("Death")]
    public bool playerIsDead;
    public GameObject playerVisuals;
    public Transform respawnPoint;
    public GameObject respawnGraphic;
    public Transform waitingPoint;
    public float respawnTime;
    public GameObject deathParticle;

    [Header("References")]
    public PlayerAnimationHandler playerAnim;
    public PointManager pm;
    public MoveWithWater mwm;

    private void Awake()
    {
        rb = GetComponent<Rigidbody>();
        if(headRb == null)
        {
            headRb = GetComponentInChildren<Rigidbody>();
        }


    }

    
    private void Start()
    {
        if(respawnPoint == null)
        {
            respawnPoint = GameObject.FindGameObjectWithTag("Respawn").transform;
        }
        if (waitingPoint == null)
        {
            waitingPoint = GameObject.FindGameObjectWithTag("WaitingPoint").transform;
        }

        inflatedGraphicsSize = Vector3.one;// inflatedGraphics.transform.localScale;
        inflatedGraphics.transform.localScale = Vector3.zero;
        currentSpeed = normalSpeed;
        jumpStrength = normalJumpStrength;
        rb.mass = normalWeigth;
        currentGroundcheckSize = normalGroundCheckSize;

        currentStamina = MaxStamina;
    }


    private void FixedUpdate()
    {
        if(gameObject == null)
        {
            return;
        }
        if (blockMovement)
        {
            return;
        }

        

        #region swimming


        if (InBoundingBoxCheck())
        {
            mwm.shouldMoveWithWater = false;
        }
        else
        {
            mwm.shouldMoveWithWater = true;
        }
        if (WaterCheck())
        {
            waterCheckBool = true;
            currentWaterMultiplierMomentum = waterMomentumMultiplier;
            playerAnim.SetSwim();
        }
        else
        {
            currentWaterMultiplierMomentum = 1f;
            waterCheckBool = false;
            playerAnim.UnSetSwim();
        }

        if (isNearWater())
        {
            isPlayerNearWater = true;
        }
        else
        {
            isPlayerNearWater = false;
        }
        #endregion

        #region jumping
        if (Groundcheck())
        {
            isGrounded = true;
        }
        else
        {
            isGrounded = false;
        }


        if (jumpRequest && isGrounded)
        {
            rb.AddForce(Vector3.up * jumpStrength, ForceMode.Impulse);
            headRb.AddForce(Vector3.up * jumpStrength/2, ForceMode.Impulse);
            jumpRequest = false;


        }


        //if falling
        if (rb.velocity.y < 0)
        {
            // rb.gravityScale = 2.5f;
            rb.velocity += Vector3.up * Physics.gravity.y * (fallMultiplier - 1) * Time.deltaTime;// * Time.deltaTime;
            if (!isGrounded)
            {
                currentAirMultiplierMomentum = fallDownMomentum;
            }
        }
        //if rising
        else if (rb.velocity.y >= 0 )
        {

            //and jumpbutton is let go;
            if (!jumpButtonHold)
            {
                rb.velocity += Vector3.up * Physics.gravity.y * (fallMultiplier - 1) * Time.deltaTime;
                
            }
            //if jumpbutton is pressed
            else
            {
                rb.velocity += Vector3.up * Physics.gravity.y * (lowJumpMultiplier - 1) * Time.deltaTime;

            }

            if (!isGrounded)
            {
                currentAirMultiplierMomentum = jumpUpMomentum;
            }

        }
        #endregion

        #region tiredness
        if(currentStamina <=0)
        {
            isTired = true;
        }
        if (currentStamina >= MaxStamina)
        {
            isTired = false;
        }

        if (isTired)
        {
            currentSpeed = tiredSpeed;
            currentStamina += 3;
        }else currentSpeed = normalSpeed;
        #endregion

        #region movement and momentum
        if (isGrounded)
        {
            currentAirMultiplierMomentum = 1f;
        }
        t = Time.fixedDeltaTime * momentum * currentAirMultiplierMomentum * currentWaterMultiplierMomentum;
        moveDirection.x = inputVector.x;
        moveDirection.z = inputVector.y;
        moveVector.x = Mathf.Lerp(moveVector.x, moveDirection.x, t);
        moveVector.z = Mathf.Lerp(moveVector.z, moveDirection.z, t);
        
        rb.velocity = new Vector3(moveVector.x * currentSpeed, rb.velocity.y, moveVector.z * currentSpeed);
        #endregion

        #region floating
        if (!waterCheckBool)
        {
            floater.SetActive(false);
        }
        if(waterCheckBool && !isGrounded)
        {
            floater.SetActive(true);
        }
        #endregion

        if (!inflateButtonHold)
        {
            transform.LookAt(transform.position + new Vector3(moveDirection.x, 0, moveDirection.z));
        }

    }



    #region focus on nearest task
    public void MoveTowardsTask(Transform focusOrigin)
    {
       
        Vector3 rotDir = focusOrigin.transform.position - transform.position;
        rotDir.y = 0f;
        //rotDir.x = 0f;
        if(rotDir != Vector3.zero) // Prevents LookRotation from producing NaNs
        {
            transform.rotation = Quaternion.LookRotation(rotDir);
        }


        // "focusOrigin" is the Transform of the closest object
        Vector3 moveDir = (transform.position - focusOrigin.position).normalized;
        
        Vector3 teleportPosition = focusOrigin.position + moveDir * 4f; // 4 units away from the closest object
        transform.position = teleportPosition;
    }


    #endregion
    private void OnDrawGizmos()
    {
        
        Debug.DrawRay(transform.position, debugVector * 2f, Color.blue);
        Debug.DrawRay(groundChecker.position, Vector3.down * 2f, Color.blue);
        Gizmos.DrawWireSphere(groundChecker.position, normalGroundCheckSize);
        Gizmos.DrawWireSphere(transform.position, forceRadius);
        Gizmos.DrawWireSphere(waterChecker.position, waterCheckerRadius);
    }
    #region GroundCollisionCheck

    bool Groundcheck()
    {
       
       // RaycastHit[] hits = Physics.RaycastAll(groundChecker.position, Vector3.down, 2f); //
        Collider[] col = Physics.OverlapSphere(groundChecker.position, currentGroundcheckSize);

        if (col == null)
        {
            return false;
        }
        foreach (Collider c in col)
        {
            if(c.gameObject.CompareTag("Floor"))
            {
                
                return true;
                //col.Remove(c);
            }

        }

        return false;
        
    }
    #endregion

    #region WaterCheck

    bool WaterCheck()
    {
        Collider[] col = Physics.OverlapSphere(waterChecker.position, waterCheckerRadius);

        if (col == null)
        {
            return false;
        }
        foreach (Collider c in col)
        {
            if (c.gameObject.CompareTag("Water"))
            {

                return true;
                //col.Remove(c);
            }

        }

        return false;

    }

    bool InBoundingBoxCheck()
    {
        Collider[] col = Physics.OverlapSphere(waterChecker.position, waterCheckerRadius);

        if (col == null)
        {
            return false;
        }
        foreach (Collider c in col)
        {
            if (c.gameObject.CompareTag("MoveWithBoat"))
            {

                return true;
                //col.Remove(c);
            }

        }

        return false;

    }

    bool isNearWater()
    {
        Collider[] col = Physics.OverlapSphere(waterChecker.position, waterCheckerRadius*4f);

        if (col == null)
        {
            return false;
        }
        foreach (Collider c in col)
        {
            if (c.gameObject.CompareTag("Water"))
            {

                return true;
                //col.Remove(c);
            }

        }

        return false;

    }
    #endregion

    

    #region Performed/Cancelled

    

    public void OnMovementPerformed(CallbackContext value)
    {
        momentum = acceleration;
        inputVector = value.ReadValue<Vector2>();
        //if(water)
        if (isPlayerNearWater)
        {
            SoundManager.Instance.PigeonStartSwim();
            

        }
        else
        {
            SoundManager.Instance.PigeonStartWalk();
        }
        
    }

    public void OnMovementCancelled(CallbackContext value)
    {
        inputVector = Vector2.zero;
        momentum = decceleration;
        SoundManager.Instance.PigeonStopWalk();
        SoundManager.Instance.PigeonStopSwim();

    }

    public void OnJumpPerformed (CallbackContext value)
    {
        jumpButtonHold = true;
        jumpRequest = true;
        
    }
    public void OnJumpCancelled(CallbackContext value)
    {
        jumpButtonHold = false;
        jumpRequest = false;
        
    }

    public void OnInflatePerformed(CallbackContext value)
    {
        if (blockMovement)
        {
            return;
        }
        Inflation();
    }

    public void OnInflateCancelled(CallbackContext value)
    {
        if (blockMovement)
        {
            return;
        }
        CancelInflation();
    }
    #endregion






    #region Inflation
    void Inflation()
    {
        SoundManager.Instance.PigeonFatTransformSound();
        SoundManager.Instance.PigeonFatRollingSound();

        inflatedGraphics.SetActive(true);
        normalGraphics.SetActive(false);
        inflateButtonHold = true;
        rb.mass = heavyWeigth;
        jumpStrength = heavyJumpStrength;
        //Knockback(force, forceRadius);
        rb.freezeRotation = false;
        LeanTween.scale(inflatedGraphics, inflatedGraphicsSize, 0.2f).setEase(LeanTweenType.easeOutElastic);
        currentSpeed = ragdollSpeed;
        currentGroundcheckSize = heavyGroundCheckSize;
        if (isGrounded)
        {
            rb.AddForce(Vector3.up * jumpStrength / 2, ForceMode.Impulse);
            
        }
        //Debug.Log("FORCE");
    }

    void CancelInflation()
    {
        SoundManager.Instance.PigeonFatRollingSoundStop();
        inflateButtonHold = false;
        rb.mass = normalWeigth;

        jumpStrength = normalJumpStrength;
        LeanTween.scale(inflatedGraphics, Vector3.zero, 0.1f).setEase(LeanTweenType.easeInOutSine);
        LeanTween.delayedCall(0.1f, DisableInflatedGraphics);
        rb.freezeRotation = true;
        currentSpeed = normalSpeed;


        intermediateRotationInflation = transform.rotation.eulerAngles;
        intermediateRotationInflation.x = 0;
        intermediateRotationInflation.z = 0;
        currentGroundcheckSize = normalGroundCheckSize;
        LeanTween.rotate(gameObject, intermediateRotationInflation, 0.3f).setEase(LeanTweenType.easeOutBack);
        //transform.position + new Vector3(moveDirection.x, 0, moveDirection.z);
    }

    public void DisableInflatedGraphics()
    {
        if (inflatedGraphics != null)
        {
            inflatedGraphics.SetActive(false);
            normalGraphics.SetActive(true);
        }
        
    }

    #endregion


    #region DEATH
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("KillZone"))
        {
            KillPlayer();
        }
    }
    void InstantiateDeathCloud()
    {
        Instantiate(deathParticle, transform.position, Quaternion.identity);
        SoundManager.Instance.PigeonFatTransformSound();
    }
    void KillPlayer()
    {
        if(respawnGraphic != null)
        {
            respawnGraphic.SetActive(true);
        }
        
        if(pm != null)
        {
            pm.AddPoints(-20f);
        }
        InstantiateDeathCloud();
        SoundManager.Instance.PigeonDrownSound();

        blockMovement = true;
        playerIsDead = true;
        //pI.ShowDeathGraphic();
        playerVisuals.SetActive( false);
        //transform.position = waitingPoint.position;
        rb.isKinematic = true;
        transform.position = waitingPoint.position;
        StartCoroutine(DelayEnable());
    }

    IEnumerator DelayEnable()
    {
        /*yield return new WaitForSeconds(respawnTime / 2);
        transform.position = waitingPoint.position;*/
        yield return new WaitForSeconds(respawnTime);
        rb.isKinematic = false;
        playerIsDead = false;
        playerVisuals.SetActive(true);

        MovePlayerToSpawnPoint();
        //pI.showArrow = true;
        blockMovement = false;
        if (respawnGraphic != null)
        {
            respawnGraphic.SetActive(false);
        }
    }
    #endregion

    public void MovePlayerToSpawnPoint()
    {
        transform.position = respawnPoint.position;
        transform.rotation = Quaternion.Euler(0f, 180f, 0f);
        InstantiateDeathCloud();
    }

    void Knockback(float force, float radius)
    {
        Collider[] colliders = Physics.OverlapSphere(transform.position, radius);
        
        Rigidbody rigg;
        foreach (Collider nearby in colliders)
        {
            Debug.Log(nearby.name);
            /*if(nearby.gameObject == this.gameObject)
            {
                return;
            }*/
            rigg = nearby.GetComponent<Rigidbody>();
            if(rigg != null)
            {
                rigg.AddExplosionForce(force, transform.position, radius);
            }
        }

        /*if (isGrounded)
        {
            rb.AddForce(Vector3.up * jumpStrength, ForceMode.Impulse);
        }*/
        
    }
}
