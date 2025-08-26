using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class PigeonMovement : MonoBehaviour
{

    //private float moveSpeed = 3f;

    SoundManager sM; //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
    
    private float jumpSpeed = 90f;
    [SerializeField]
    private float normalJumpSpeed = 90f;

    [SerializeField]
    private float heavyJumpSpeed = 130f;

    [SerializeField]
    private float initialWeight = 8f;

    [SerializeField]
    private float heavyWeight = 12f;

    [SerializeField]
    private GameObject playerGraphics;

    [SerializeField]
    private GameObject puffedUpGraphics;

    [SerializeField]
    private GameObject puffParticle;

    [SerializeField]
    private GameObject RespawnGraphic;
    [SerializeField]
    private GameObject NameGraphic;

    [SerializeField]
    private Animator anim;

    [SerializeField]
    private float moveSpeed = 10f;

    [SerializeField]
    private float slowMoveSpeed = 2f;

    [SerializeField]
    private SkinnedMeshRenderer puffedUpMesh;
    [SerializeField]
    private SkinnedMeshRenderer normalMesh;

    [SerializeField]
    private Material goldMat;

    [SerializeField]
    private GameObject winnercrownNormal;
    [SerializeField]
    private GameObject winnercrownFat;

    [SerializeField]
    private GameObject walkSound;

    private Material normalMat;

    private float currentMoveSpeed;

    bool isGrounded;
    bool isDrowning;
    public bool isRagdolling;
    //bool isSwimming;
    bool isRespawning;
    public bool isPressed;
    public bool isPushing;
    float pushTimeAmount = 0.2f;
    float pushTimer;

    bool jumpRequest;
    public bool isJumping;

    public float respawnDelay = 3f;
    public float drownDelay = 3f;
    public float drownTimer;

    public float fallMultiplier = 2.5f;
    public float lowJumpMultiplier = 2f;
    float respawnTimer;

    
    private GameObject focussedTask;
    private GameObject motorTask;

    private Rigidbody rb;

    private Vector3 moveDirection = Vector3.zero;
    private Vector2 inputVector = Vector2.zero;

    private Vector3 jumpVector = Vector3.zero;

    Vector3 playerStart;


    public int score;
    //the panels have to be named: PersonalPlayerScore[playerindex]
    public GameObject individualScorePanel;
    IndividualScoreShower iSS;
    public int playerIndex;

    float calculateFirstTimerIntervall = 2f;
    float currentFirstTimer;

    public GameObject oneParticle;
    public GameObject tenParticle;
    public GameObject fiftyParticle;

    bool walk1;
    bool walk2;

    private void Awake()
    {
        sM = FindObjectOfType<SoundManager>(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
        currentFirstTimer = calculateFirstTimerIntervall;
        pushTimer = pushTimeAmount;
        currentMoveSpeed = moveSpeed;
        score = 0;
        rb = GetComponent<Rigidbody>();
        jumpVector = new Vector3(0.0f, 2.0f, 0.0f);

        jumpSpeed = normalJumpSpeed;
        rb.mass = initialWeight;
        isRespawning = false;
        isDrowning = false;
        respawnTimer = respawnDelay;
        drownTimer = respawnDelay;
        playerGraphics.SetActive(true);

        playerStart = transform.position;

        isGrounded = false;
        RespawnGraphic.SetActive(false);
        NameGraphic.SetActive(true);
    }

    private void Start()
    {
        playerIndex = GetComponent<PigeonInputHandler>().pIndex;
        string playerScorePanelName = playerIndex + "PersonalPlayerScore";
        individualScorePanel = GameObject.Find(playerScorePanelName);
        iSS = individualScorePanel.GetComponent<IndividualScoreShower>();
        normalMat = normalMesh.material;
    }
    public void IncreaseScore(int amount)
    {
       
        score += amount;
        iSS.UpdateText(score);
        
    }

    public void SpawnOneParticle()
    {
        Instantiate(oneParticle, new Vector3(transform.position.x, transform.position.y + 4f, transform.position.z), transform.rotation);
    }

    public void SpawnTenParticle()
    {
        Instantiate(tenParticle, new Vector3(transform.position.x, transform.position.y + 4f, transform.position.z), transform.rotation);
    }

    public void SpawnFiftyParticle()
    {
        Instantiate(fiftyParticle, new Vector3(transform.position.x, transform.position.y + 4f, transform.position.z), transform.rotation);
    }

    public void DecreaseScore(int amount)
    {
        score -= amount;
        iSS.UpdateText(score);
        
    }


    // Update is called once per frame
    void Update()
    {
        currentFirstTimer -= Time.deltaTime;
        if(currentFirstTimer <= 0)
        {
            currentFirstTimer = calculateFirstTimerIntervall;
            CalculateFirst();
        }
        
        
        if (!isRagdolling && !isRespawning)
        {

            //IMPLEMENT SWIMMING
            //if (!isSwimming)
            {
               // rb.useGravity = true;
                moveDirection = new Vector3(inputVector.x * currentMoveSpeed, rb.velocity.y, inputVector.y * currentMoveSpeed);
            }
            
           /* else
            {
                moveDirection = new Vector3(inputVector.x * 5, 0, inputVector.y * 5);
            }*/



            //moveDirection = transform.TransformDirection(moveDirection);


            //moveDirection *= moveSpeed*Time.deltaTime;

            //transform.Translate(moveDirection);


            transform.LookAt(transform.position + new Vector3(moveDirection.x, 0, moveDirection.z));

        }
        if(inputVector != Vector2.zero)
        {
            anim.SetBool("walking", true);
            if (!walk1)
            {
                walk1 = true;
                walk2 = false;
                walkSound.SetActive(true);
                /*sM.PigeonStartWalk(); //--------------------------------------------------------------------------------------- Sebi Sound
                Debug.Log("Walk");*/
            }
            
        }
        else
        {
            anim.SetBool("walking", false);
            if (!walk2 || !isGrounded)
            {
                walk2 = true;
                walk1 = false;
                walkSound.SetActive(false);
                /*sM.PigeonStopWalk(); //--------------------------------------------------------------------------------------- Sebi Sound
                Debug.Log("no walk");*/
            }
            
        }

        if (isDrowning)
        {
            DrownPlayer();
        }
        /*if (isRespawning)
        {
            InitiateGameOver();
        }*/

        if (isGrounded)
        {
            anim.SetBool("grounded", true);
        }
        else
        {
            anim.SetBool("grounded", false);
        }

        /*if (isPressed)
        {
            pushTimer -= Time.deltaTime;
            if (pushTimer <= 0)
            {
                isPushing = true;

            }
            if (isPushing)
            {
                anim.SetBool("pushing", true);
                currentMoveSpeed = slowMoveSpeed;
            }

        }
        else
        {
            isPushing = false;
            pushTimer = pushTimeAmount;
            if (!isPushing)
            {
                currentMoveSpeed = moveSpeed;
                anim.SetBool("pushing", false);
            }

        }*/

    }

    public void GiveForceToPlayer()
    {
        rb.AddForce(Vector3.up * 70, ForceMode.Impulse);
        rb.AddForce(Vector3.back * 500f , ForceMode.Impulse);
        Debug.Log("FORCE");
    }
    
    private void FixedUpdate()
    {

        if (!isRagdolling && !isRespawning)
        {
            rb.velocity = moveDirection;
        }

        if (jumpRequest)
        {
            rb.AddForce(Vector3.up * jumpSpeed, ForceMode.Impulse);
            anim.SetTrigger("jump");
            jumpRequest = false;
        }

        if(rb.velocity.y < 0)
        {
            // rb.gravityScale = 2.5f;
            rb.velocity += Vector3.up * Physics.gravity.y * (fallMultiplier - 1) * Time.deltaTime;// * Time.deltaTime;
        }else if( rb.velocity.y > 0 && !isJumping)
        {
            rb.velocity += Vector3.up * Physics.gravity.y * (lowJumpMultiplier - 1) * Time.deltaTime;
        }

        

    }
    void CalculateFirst()
    {
        if (iSS.iAmFirst)
        {
            ChangeToWinner();
        }
        else
        {
            ChangeToNormal();
        }
    }
    public void ChangeToWinner()
    {
        /*normalMesh.material = goldMat;
        puffedUpMesh.material = goldMat;*/
        winnercrownFat.SetActive(true);
        winnercrownNormal.SetActive(true);
    }

    public void ChangeToNormal()
    {
        /*normalMesh.material = normalMat;
         puffedUpMesh.material = normalMat;*/
        winnercrownFat.SetActive(false);
        winnercrownNormal.SetActive(false);
    }

    public void SetInputvector(Vector2 direction)
    {
        inputVector = direction;

    }

    public void Jump()
    {
        if (isGrounded)
        {
            //  rb.AddForce(jumpVector * jumpSpeed, ForceMode.Impulse);
            jumpRequest = true;
        }

    }



    //ragdollbutton was pressed > uncheck xyz rb restrictions so that character will ragdoll
    public void Ragdoll()
    {
        sM.PigeonFatTransformSound(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
        sM.PigeonFatRollingSound(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
        isRagdolling = true;
        rb.mass = heavyWeight;
        
        if (!isRespawning)
        {
            puffedUpGraphics.SetActive(true);
            playerGraphics.SetActive(false);
            Instantiate(puffParticle, transform.position, transform.rotation, transform);
        }
        GetComponent<SphereCollider>().enabled = true;
        rb.freezeRotation = false;
        jumpSpeed = heavyJumpSpeed;
    }


    //ragdollbutton was released > player stands up and xyz locked again
    public void UnRagdoll()
    {
        sM.PigeonFatRollingSoundStop();  //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
        isRagdolling = false;
        rb.mass = initialWeight;
        puffedUpGraphics.SetActive(false);
        playerGraphics.SetActive(true);
        GetComponent<SphereCollider>().enabled = false;
        rb.freezeRotation = true;
        transform.rotation = Quaternion.identity;

        jumpSpeed = normalJumpSpeed;
    }


    //check ragdoll status and set or reset rotation of player
    void SetRagdollstate(bool state)
    {
        //Debug.Log("RagdollState: " + state);
        rb.freezeRotation = state;

    }

    



    /*void InitiateGameOver()
    {


        respawnTimer -= Time.deltaTime;
        if (respawnTimer <= 0)
        {
            isRespawning = false;

            respawnTimer = respawnDelay;
            RespawnPlayer();
        }


    }

    void DrownPlayer()
    {
        drownDelay -= Time.deltaTime;
        if (drownDelay <= 0)
        {
            sM.PigeonDrownSound(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
            playerGraphics.SetActive(false);
            puffedUpGraphics.SetActive(false);
            RespawnGraphic.SetActive(true);
            drownDelay = drownTimer;

            isDrowning = false;
            isRespawning = true;
            score -= 10;
        }
    }

    void RespawnPlayer()
    {
        transform.position = playerStart;
        playerGraphics.SetActive(true);
        RespawnGraphic.SetActive(false);
    }*/

    void DrownPlayer()
    {
        isDrowning = false;
        isRespawning = true;
        sM.PigeonDrownSound(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
        playerGraphics.SetActive(false);
        puffedUpGraphics.SetActive(false);
        RespawnGraphic.SetActive(true);
        NameGraphic.SetActive(false);
        //transform.position =playerStart;
        GameObject respawnClone;
        respawnClone =  Instantiate(RespawnGraphic, playerStart, Quaternion.identity);
        respawnClone.GetComponentInChildren<TextMeshPro>().text = "P" + (playerIndex + 1).ToString() + ": Respawning";
        score -= 10;
        StartCoroutine(RespawnPlayer(respawnClone));
    }

    IEnumerator RespawnPlayer(GameObject clone)
    {
        yield return new WaitForSeconds(drownDelay);
        transform.position = playerStart;
        playerGraphics.SetActive(true);
        NameGraphic.SetActive(true);
        isRespawning = false;
        Destroy(clone);
    }



    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Ground")
        {
            isGrounded = true;
        }
        if (other.tag == "GameOver")
        {
            isDrowning = true;
        }

        
        if (other.tag == "Task")
        {
            focussedTask = other.gameObject;
        }

        if(other.tag == "Motor")
        {
            motorTask = other.gameObject;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Ground")
        {
            isGrounded = false;
        }

        if (other.tag == "GameOver")
        {
            isDrowning = false;
        }

        if (other.tag == "Task")
        {
            focussedTask = null;
        }

        if (other.tag == "Motor")
        {
            motorTask.GetComponent<CoopMotorSubtask>().UnUseMotor();
            motorTask = null;
        }

        

    }


    //Here come the Tasks
    public void Interact()
    {
        isPressed = true;
        anim.SetTrigger("interact");
        sM.PigeonPeckSound(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
        if (focussedTask != null)
        {
            //focussedTask.GetComponent<BasicTask>().points--;
            if (focussedTask.GetComponent<BasicTask>() != null)
            {
                focussedTask.GetComponent<BasicTask>().SubtractPoints();
            }

            if (focussedTask.GetComponent<CoopTaskSubtractFromParent>() != null)
            {
                focussedTask.GetComponent<CoopTaskSubtractFromParent>().SubtractMainTaskPoints();
            }

            if (focussedTask.GetComponent<SeamonsterTask>() != null)
            {
                focussedTask.GetComponent<SeamonsterTask>().HitMonster();
            }
            

        }

        if(motorTask != null)
        {
            if (motorTask.GetComponent<CoopMotorSubtask>() != null)
            {
                motorTask.GetComponent<CoopMotorSubtask>().UseMotor();
            }
        }
    }

    public void UnInteract()
    {
        isPressed = false;

        //Just motor stuff here
        if (motorTask != null)
        {
            
            if (motorTask.GetComponent<CoopMotorSubtask>() != null)
            {
                motorTask.GetComponent<CoopMotorSubtask>().UnUseMotor();
            }

        }
    }
}
