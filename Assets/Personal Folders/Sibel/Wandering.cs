using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Wandering : MonoBehaviour
{
    SoundManager sM; //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
    private float currentSpeed;
    [SerializeField] private float initialSpeed = 20;
    [SerializeField] private PatrolPoint patrolPoint;
    [SerializeField] Animator anim;
    public GameObject plane;
    public Vector3 targetPosition;
    private Vector3 NpcPosition;
    // ignoriert Y > damit NPC Ziel nicht verfehlt, wenn Raft gekippt ist
    private Vector3 targetPositionY0;

    /// alles für Obstacle Avoidance
    private int numberOfRays = 7;
    private float angleOfRays = 180; //vlt Angles kleiner machen? 90 Grad?
    private float rayLength = 1;

    public float maxSpeed = 30f; //this is the speed the bird will fly away;
    public float spookSpeed = 2f;
    bool spookState;
    bool state1 = false;
    bool state2 = false;
    bool landed;
    public Rigidbody rb;
    public GameObject dieParticle;

    // die LayerMask 8 (Task)
    int layerMask = 1 << 8;

    float currentScareTimer;
    public float scareTimer = 0.6f;
    Vector3 startPosition;

    private void Awake()
    {
        
        sM = FindObjectOfType<SoundManager>(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
        currentSpeed = initialSpeed;
        startPosition = transform.position;
        transform.localPosition += new Vector3(0, 20f, 0);
        LeanTween.move(gameObject, startPosition, 3f).setEase(LeanTweenType.easeOutBounce);
        rb = GetComponent<Rigidbody>();
    }
    private void Start() 
    {
        // setzt den Ignore auf alle ausser die 8. Layer
        layerMask = ~layerMask;

        targetPosition = patrolPoint.CalculateNewSpawnPosition();
        //patrolPoint.CheckPatrolPointPosition();
        //Debug.Log("targetPos" + targetPosition);
        Wander();
    }

    private void Update() 
    {
        float distance = 10;
        Vector3 evadePosition = Vector3.zero;
        Vector3 evadeRotation = Vector3.zero;
        bool evade = false;
        // * ist performanter als / 
        float halfOfRays = numberOfRays * 0.5f;

        var rotation = this.transform.rotation;

        Wander();
        if( currentSpeed >= maxSpeed && !spookState)
        {
            spookState = true;
            FindClosestPlayer().GetComponent<PigeonMovement>().IncreaseScore(10);
            FindClosestPlayer().GetComponent<PigeonMovement>().SpawnTenParticle();
            anim.SetTrigger("flyAway");
            sM.NPCFlySound(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
            StartCoroutine(FlyAway());
            //Debug.Log("Fly Away");
        }
        for (int i = 0; i < numberOfRays; i++)
        {
            var angle = i / ((float)numberOfRays - 1) * angleOfRays - 90;

            var rotationMod = Quaternion.AngleAxis(angle, this.transform.up);
            Vector3 direction = rotation * rotationMod * Vector3.forward;

            RaycastHit hitInfo;
            Ray ray = new Ray(transform.position, direction);
            if (Physics.Raycast(ray, out hitInfo, rayLength, layerMask))
            {
                if (hitInfo.distance < distance)
                {
                    /* // please leave for future ref :D
                    float evadeAngle = 90 - Mathf.Abs(angle);
                    if (angle < 0)
                    {
                        evadeAngle *= -1;
                    }

                    var evadeRotationMod = Quaternion.AngleAxis(evadeAngle, this.transform.up);
                    evadeRotation = rotation * evadeRotationMod * Vector3.forward;

                    distance = hitInfo.distance;
                    */

                    targetPosition = patrolPoint.CalculateNewSpawnPosition();
                }
                
                //evadePosition -= (1f / numberOfRays) * direction;
                evade = true;
                //transform.position += deltaPosition * speed * Time.deltaTime;
            }            
        }

        if (evade)
        {           
            evadePosition = evadeRotation * -0.2f;
            transform.position += evadePosition * currentSpeed * Time.deltaTime;           
        }

        
    }


    private void FixedUpdate()
    {
        if (landed)
        {
            rb.AddForce(Vector3.up * -500f);
        }
    }
    // transform to position
    public void Wander()
    {
        this.transform.position += transform.TransformDirection(Vector3.forward) * currentSpeed * Time.deltaTime;
        this.transform.LookAt(new Vector3(targetPosition.x, transform.position.y, targetPosition.z));

        NpcPosition = new Vector3(transform.position.x, 0, transform.position.z);
        targetPositionY0 = new Vector3(targetPosition.x, 0, targetPosition.z);

        if ((NpcPosition - targetPositionY0).magnitude < 1)
        {
            targetPosition = patrolPoint.CalculateNewSpawnPosition();
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.tag == "Player" && other.GetComponent<PigeonMovement>().isRagdolling)
        {
            
            //run away
            //set direction to opposite until not in collider (like a bigger collider)

            if (other.GetComponent<PigeonMovement>().isRagdolling)
            {
                NPCisScared();


            }
            else if (!other.GetComponent<PigeonMovement>().isRagdolling)
            {
                ResetNPC();
            }


        }
        /*else
        {
            ResetNPC();
        }  */
    }

    public void NPCisScared()
    {
        state2 = false;
        currentScareTimer += Time.deltaTime;
        //Debug.Log("Scared");
        if (currentScareTimer >= scareTimer)
        {
            //GetComponent<Transform>().localScale = new Vector3(0.8f, 1.2f, .8f);
            currentSpeed += spookSpeed * Time.deltaTime;
            if (!state1)
            {
                //Debug.Log("Scared");
                state1 = true;
                anim.SetBool("isScared", true);
                sM.NPCStartledSound(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
            }
            
        }
    }

    void ResetNPC()
    {
        state1 = false;
        //GetComponent<Transform>().localScale = new Vector3(1, 1f, 1f);
        currentScareTimer = 0f;
        if (!state2)
        {
            //Debug.Log("not spook");
            state2 = true;
            anim.SetBool("isScared", false);
            sM.NPCStartledSoundStop(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
        }
        
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            ResetNPC();
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Ground")
        {
            sM.NPCLandingSound(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
            //Debug.Log("birb land");
            StartCoroutine(landDelay());
        }
    }
    IEnumerator landDelay()
    {
        yield return new WaitForSeconds(0.3f);
        anim.SetTrigger("land");
        GetComponent<Rigidbody>().drag = 30f;
        yield return new WaitForSeconds(1.3f);
        landed = true;
    }
    IEnumerator FlyAway()
    {
        /*for (float t = 0; t < 1; t += Time.deltaTime / 5f)
        {
            
            GetComponent<Transform>().localPosition += new Vector3(0, 50 *Time.deltaTime, 0f);
            yield return null;
        }*/
        startPosition = transform.position;
        startPosition += new Vector3(0, 30, 0);
        LeanTween.move(gameObject, startPosition, .5f).setEase(LeanTweenType.easeInQuint);
        yield return new WaitForSeconds(4f);
        Destroy(gameObject);
    }

    //Draws Rays
    private void OnDrawGizmos()
    {
        for(int i = 0; i < numberOfRays; i++)
        {
            var rotation = this.transform.rotation;
            var rotationMod = Quaternion.AngleAxis(i / ((float)numberOfRays - 1) * angleOfRays -90, this.transform.up);
            Vector3 direction = rotation * rotationMod * Vector3.forward;

            Gizmos.DrawRay(this.transform.position, direction * rayLength);
        }
    }

    public GameObject FindClosestPlayer()
    {
        GameObject[] gos;
        gos = GameObject.FindGameObjectsWithTag("Player");
        GameObject closest = null;
        float distance = Mathf.Infinity;
        Vector3 position = transform.position;
        foreach (GameObject go in gos)
        {
            Vector3 diff = go.transform.position - position;
            float curDistance = diff.sqrMagnitude;
            if (curDistance < distance)
            {
                closest = go;
                distance = curDistance;
            }
        }
        return closest;
    }

    public void DieBird()
    {
        Instantiate(dieParticle, transform.position, transform.rotation);
        Destroy(gameObject);

    }
}
