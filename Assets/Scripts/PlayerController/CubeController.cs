using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using TMPro;

public class CubeController : MonoBehaviour
{
    Vector3 playerStart;
    Vector2 i_movement;
    Vector3 jump;

    
    bool isRagdolling;
    bool isGrounded;
    bool isDrowning;
    bool isRespawning;


    Rigidbody rb;
    
    public TextMeshPro tmpText;

    public GameObject playerGraphics;

    
    public float jumpForce = 2.0f;
    public float respawnDelay = 3f;
    public float drownDelay = 3f;
    public float drownTimer;
    float respawnTimer;
    float movespeed = 10f;

    //public CharacterController charCont;

    // Start is called before the first frame update
    void Awake()
    {
        isRespawning = false;
        isDrowning = false;
        respawnTimer = respawnDelay;
        drownTimer = respawnDelay;
        playerGraphics.SetActive(true);

        playerStart = transform.position;
        tmpText.text="Player " + Mathf.RoundToInt(Random.Range(0f, 150f));
        isGrounded = true;
        isRagdolling = false;
        rb = GetComponent<Rigidbody>();
        jump = new Vector3(0.0f, 2.0f, 0.0f);
        
    }

    // Update is called once per frame
    void Update()
    {
        if (!isRagdolling && !isRespawning)
        {
            Move();
        }
        if (isDrowning)
        {
            DrownPlayer();
        }
        if (isRespawning)
        {
            InitiateGameOver();
        }
    }


    public void Move()
    {
        Vector3 movement = new Vector3(i_movement.x, 0, i_movement.y) * movespeed * Time.deltaTime;
        transform.Translate(movement);
        //charCont.Move(movement);
    }
    private void OnHorizontalMovement(InputValue value)
    {
        i_movement = value.Get<Vector2>();
        //Debug.Log("p1 moving");
    }
   

    //ragdollbutton was pressed/released > check or uncheck current ragdoll state so that character will fall to ground or stand up again
    public void OnRagdoll()
    {
        SetRagdollstate(isRagdolling);
        if (!isRagdolling)
        {
            isRagdolling = true;
        }
        else
        {
            isRagdolling = false;
            transform.rotation = Quaternion.identity;
        }

        
        

    }


    //check ragdoll status and set or reset rotation of player
    void SetRagdollstate(bool state)
    {
        rb.freezeRotation = state;
        
    }

    //recieve jump command
    void OnJump()
    {
        if (isGrounded)
        {

            Jump();
        }
        
    }

    public void Jump()
    {
        rb.AddForce(jump * jumpForce, ForceMode.Impulse);
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Ground")
        {
            isGrounded = true;
        }
        if(other.tag == "GameOver")
        {
            isDrowning = true;
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

    }

    
    void InitiateGameOver()
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
            playerGraphics.SetActive(false);
            drownTimer = drownDelay;

            isDrowning = false;
            isRespawning = true;

        }
    }

    void RespawnPlayer()
    {
        transform.position = playerStart;
        playerGraphics.SetActive(true);
    }
}
