using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CoopMotorSubtask : MonoBehaviour
{
    /*[SerializeField]
    private Image graphic;*/


    public Renderer lanternMat;


    bool loadingHalfTub = false;
    public bool activated;
    float fillAmount;

    private void Awake()
    {
        fillAmount = 0;
        lanternMat.material.SetFloat("fillingAmount", fillAmount);
    }

    private void Update()
    {
        if (loadingHalfTub)
        {
            
            if (fillAmount >= 1f)
            {
                activated = true;
            }
        }
        else
        {
            if(fillAmount > 0)
            {
                fillAmount -= Time.deltaTime;
            }
            
            activated = false;
        }

       lanternMat.material.SetFloat("fillingAmount", fillAmount);
    }

    public void AwardPlayer()
    {
        FindClosestPlayer().GetComponent<PigeonMovement>().IncreaseScore(25);
        FindClosestPlayer().GetComponent<PigeonMovement>().SpawnFiftyParticle();
    }

    public void UseMotor()
    {
        loadingHalfTub = true;
        fillAmount += 0.2f;
        gameObject.transform.localScale -= new Vector3(0.1f, 0f, 0);
        LeanTween.scaleX(gameObject, 0.3f, 0.1f).setEase(LeanTweenType.linear);
        LeanTween.scaleX(gameObject, 0.7f, 0.1f).setEase(LeanTweenType.easeOutBounce).setDelay(0.1f);

    }

    public void UnUseMotor()
    {
        loadingHalfTub = false;
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
}

