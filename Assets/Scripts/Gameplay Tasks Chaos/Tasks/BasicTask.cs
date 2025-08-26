using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;


public class BasicTask : MonoBehaviour
{
    SoundManager sM; //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
    public int points = 5;
    public int range = 3;

    public float timerForHealthDecrease = 4f;
    public float secondTimer = 1f;
    float timer;
    public float decreaseAmount = 0.005f;
    float rewardAmount;
    private float maxHealth;
    int difficulty;
    public GameObject particleConfetti;
    //public MeshRenderer objToChangeMat;
    //public Material mat;
    public GameObject warningParticle;
    bool changeOnce = false;

    HealthManager hm;

    public TextMeshPro tmpText;
    Vector3 normalSize;
    bool endState;

    
    private void Awake()
    {
        sM = FindObjectOfType<SoundManager>(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
        normalSize = transform.localScale;
        endState = false;
        transform.localScale = Vector3.zero;
        LeanTween.scale(gameObject, normalSize, 0.5f).setEase(LeanTweenType.easeOutElastic);

        /*difficulty = PlayerPrefs.GetInt("Difficulty");
        points = (difficulty/2 )+ points + Mathf.RoundToInt(Random.Range(-range, range));
        decreaseAmount = decreaseAmount + (difficulty * 0.0005f);*/

        points += Mathf.RoundToInt(Random.Range(-range, range));
        tmpText.text = "" + points;
        hm = FindObjectOfType<HealthManager>().GetComponent<HealthManager>();
        maxHealth = hm.health;

        //float v = (difficulty / 3);
        
        rewardAmount = points / 2;

        timer = timerForHealthDecrease;

        transform.localPosition = new Vector3(transform.localPosition.x,1.3f, transform.localPosition.z);
        transform.localRotation = Quaternion.Euler(0f, -90f, 0f);
    }

    private void FixedUpdate()
    {
        if (!endState)
        {
            if (points <= 0)
            {
                endState = true;
                StartCoroutine(DestroyTask());
            }

            timer -= Time.deltaTime;
            if (timer <= 0)
            {
                //SOUND HERE (WARNING IS A LOOP): task is becomming urgent
                //sM.DangerBellSound(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
                hm.HealthDecreaser(decreaseAmount);
                if (!changeOnce)
                {
                    sM.PigeonAnxiousSound(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
                    changeOnce = true;
                    ChangeMaterial();
                }
            }
        }
        
    }

    public void SubtractPoints() 
    {
        //SOUND HERE: Solving task
        points--;
        tmpText.text = "" +  points;
        FindClosestPlayer().GetComponent<PigeonMovement>().IncreaseScore(1);
        FindClosestPlayer().GetComponent<PigeonMovement>().SpawnOneParticle();
    }

    void ChangeMaterial()
    {
        //objToChangeMat.material = mat;
        warningParticle.SetActive(true);
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

    IEnumerator DestroyTask()
    {
        sM.PigeonFixSound(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
        //sM.WaterLeakRunningStop(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
        Debug.Log("Task solved!");
        if (hm.health > maxHealth)
        {
            hm.health -= rewardAmount;
        }
        //FindObjectOfType<DifficultyManager>().IncreaseDifficulty();
        //FindClosestPlayer().GetComponent<PigeonMovement>().IncreaseScore(3);
        
        LeanTween.scale(gameObject, Vector3.zero, 0.2f).setEase(LeanTweenType.easeInBack);
        yield return new WaitForSeconds(0.2f);
        Instantiate(particleConfetti, gameObject.transform.position, particleConfetti.transform.rotation);
        Destroy(gameObject);
    }
}
