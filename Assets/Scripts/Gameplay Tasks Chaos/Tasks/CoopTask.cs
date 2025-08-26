using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class CoopTask : MonoBehaviour
{
    bool plate1Collision;
    bool plate2Collision;
    public CheckPlayerCollision plate1;
    public CheckPlayerCollision plate2;
    public bool canInteract;

    public int points;
    public int range;

    public float timerForHealthDecrease = 4f;
    public float secondTimer = 1f;
    float timer;
    public float decreaseAmount = 0.005f;
    float rewardAmount;
    private float maxHealth;



    public TextMeshPro tmpText;

    public MeshRenderer objToChangeMat;
    public Material mat;
    bool changeOnce = false;

    HealthManager hm;

    int difficulty;

    // Start is called before the first frame update
    void Awake()
    {
       if((plate1 = null) || (plate2 = null))
        {
            Debug.Log("Coop Plates not Set up");
        }


        plate1 = this.gameObject.transform.GetChild(0).GetComponent<CheckPlayerCollision>();
        plate2 = this.gameObject.transform.GetChild(1).GetComponent<CheckPlayerCollision>();

        /*difficulty = PlayerPrefs.GetInt("Difficulty");
        points = (difficulty / 2) + points + Mathf.RoundToInt(Random.Range(-range, range));
        decreaseAmount = decreaseAmount + (difficulty * 0.0005f);*/

        tmpText.text = "" + points;

        hm = FindObjectOfType<HealthManager>().GetComponent<HealthManager>();
        maxHealth = hm.health;

        float v = (difficulty / 3);
        rewardAmount = points / (4 + v);

        timer = timerForHealthDecrease;

        transform.localPosition = new Vector3(transform.localPosition.x, 1f, transform.localPosition.z);
        transform.localRotation = Quaternion.Euler(0f, -90f, 0f);


    }
  

    // Update is called once per frame
    void Update()


    {
        plate1Collision = plate1.playerCollides;
        plate2Collision = plate2.playerCollides;

        if(plate1Collision && plate2Collision)
        {
            canInteract = true;
        }
        else
        {
            canInteract = false;
        }

        if(points <= 0)
        {
            TaskSolved();
        }

        timer -= Time.deltaTime;
        if (timer <= 0)
        {
            Punish();
        }
    }

    public void SubtractPoints()
    {
        if (canInteract)
        {
            points--;
            tmpText.text = "" + points;
        }
        
    }

    void ChangeMaterial()
    {
        objToChangeMat.material = mat;
    }



    void TaskSolved()
    {
        if (hm.health > maxHealth)
        {
            hm.health -= rewardAmount;
        }

        Debug.Log("Coop Task solved!");
        //FindObjectOfType<DifficultyManager>().IncreaseDifficulty();
        Destroy(gameObject);
    }

    void Punish()
    {
        hm.HealthDecreaser(decreaseAmount);
        if (!changeOnce)
        {
            changeOnce = true;
            ChangeMaterial();
        }
    }
}
