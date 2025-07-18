using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEngine.InputSystem.InputAction;

[SelectionBase]
public class Menu_InitialMovement : MonoBehaviour
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

    float currentSpeed;

    [Header("Momentum and Physics")]

    public float acceleration = 15;
    public float decceleration = 5f;
    Rigidbody rb;
    float t;


    float momentum = 0.5f;
    float momentumAirMultiplier;


    public float normalWeigth;
    public float heavyWeigth;

    [Header("Jumping")]


    public float gravityScale;
    public float jumpStrength, normalJumpStrength, heavyJumpStrength, fallMultiplier, lowJumpMultiplier;
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



    [Header("References")]
    public PlayerAnimationHandler playerAnim;
    public Transform respawnPoint;


    private void Awake()
    {
        rb = GetComponent<Rigidbody>();

        /*if (pI == null)
        {
            pI = GameObject.FindGameObjectWithTag("PlayerIndicator").GetComponent<PlayerIndicator>();
        }*/

    }


    private void Start()
    {
        if (respawnPoint == null)
        {
            respawnPoint = GameObject.FindGameObjectWithTag("Respawn").transform;
        }
        inflatedGraphicsSize = inflatedGraphics.transform.localScale;
        inflatedGraphics.transform.localScale = Vector3.zero;
        currentSpeed = normalSpeed;
        jumpStrength = normalJumpStrength;
        rb.mass = normalWeigth;
        currentGroundcheckSize = normalGroundCheckSize;

        if(SoundManager.Instance!= null)
        {
            SoundManager.Instance.UIPlayerReadySound();
        }
        //set player amount music
        SetPlayerAmtMusic();
    }


    void SetPlayerAmtMusic()
    {
        if (MusicManager.Instance != null)
        {
            MusicManager.Instance.playerAmt++;
            MusicManager.Instance.SetPlayerCountMusic(MusicManager.Instance.playerAmt);

        }
    }

    private void FixedUpdate()
    {
        if (gameObject == null)
        {
            return;
        }
        if (blockMovement)
        {
            return;
        }

        #region Jumping
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
            jumpRequest = false;
        }


        //if falling
        if (rb.velocity.y < 0)
        {
            // rb.gravityScale = 2.5f;
            rb.velocity += Vector3.up * Physics.gravity.y * (fallMultiplier - 1) * Time.deltaTime;// * Time.deltaTime;
            if (!isGrounded)
            {
                momentumAirMultiplier = 0.02f;
            }
        }
        //if rising
        else if (rb.velocity.y >= 0)
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
                momentumAirMultiplier = 0.1f;
            }

        }
        #endregion


        #region movement and momentum
        if (isGrounded)
        {
            momentumAirMultiplier = 1f;
        }
        t = Time.fixedDeltaTime * momentum * momentumAirMultiplier;
        moveDirection.x = inputVector.x;
        moveDirection.z = inputVector.y;
        moveVector.x = Mathf.Lerp(moveVector.x, moveDirection.x, t);
        moveVector.z = Mathf.Lerp(moveVector.z, moveDirection.z, t);

        rb.velocity = new Vector3(moveVector.x * currentSpeed, rb.velocity.y, moveVector.z * currentSpeed);
        #endregion

        if (!inflateButtonHold)
        {
            transform.LookAt(transform.position + new Vector3(moveDirection.x, 0, moveDirection.z));
        }

    }


    /*

    private void OnDrawGizmos()
    {

        Debug.DrawRay(transform.position, debugVector * 2f, Color.blue);
        Debug.DrawRay(groundChecker.position, Vector3.down * 2f, Color.blue);
        Gizmos.DrawWireSphere(groundChecker.position, normalGroundCheckSize);
        Gizmos.DrawWireSphere(transform.position, forceRadius);
        Gizmos.DrawWireSphere(waterChecker.position, waterCheckerRadius);
    }*/
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
            if (c.gameObject.CompareTag("Floor"))
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
       
        SoundManager.Instance.PigeonStartWalk();


    }

    public void OnMovementCancelled(CallbackContext value)
    {
        inputVector = Vector2.zero;
        momentum = decceleration;
        SoundManager.Instance.PigeonStopWalk();
        SoundManager.Instance.PigeonStopSwim();

    }

    public void OnJumpPerformed(CallbackContext value)
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


    public void OnInteractPerformed(CallbackContext value)
    {
        if (blockMovement)
        {
            return;
        }
        SoundManager.Instance.PigeonPeckSound();
    }


    #endregion






    #region inflation
    void Inflation()
    {
        SoundManager.Instance.PigeonFatTransformSound();
        SoundManager.Instance.PigeonFatRollingSound();

        inflatedGraphics.SetActive(true);
        normalGraphics.SetActive(false);
        inflateButtonHold = true;
        rb.mass = heavyWeigth;
        jumpStrength = heavyJumpStrength;
        Knockback(force, forceRadius);
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


    void Knockback(float force, float radius)
    {
        Collider[] colliders = Physics.OverlapSphere(transform.position, radius);
        Rigidbody rigg;
        foreach (Collider nearby in colliders)
        {
            /*if(nearby.gameObject == this.gameObject)
            {
                return;
            }*/
            rigg = nearby.GetComponent<Rigidbody>();
            if (rigg != null)
            {
                rigg.AddExplosionForce(force, transform.position, radius);
            }
        }

        /*if (isGrounded)
        {
            rb.AddForce(Vector3.up * jumpStrength, ForceMode.Impulse);
        }*/

    }


    public void MovePlayerToSpawnPoint()
    {
        transform.position = respawnPoint.position;
        transform.rotation = Quaternion.Euler(0f, 180f, 0f);
    }
}
