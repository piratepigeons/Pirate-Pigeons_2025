using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowMastHealth : MonoBehaviour
{
    public HealthManager hm;
    float health;
    public Transform healthIndicator;
    public float startHeight = 0;
    public float endHeight = 12f;
    float inbetweenHeight;
    float currentHeight;
    // Start is called before the first frame update
    void Start()
    {
        inbetweenHeight = startHeight - endHeight;
    }

    // Update is called once per frame
    void Update()
    {
        health = 100 - hm.health;
        currentHeight = (health / 100f) * inbetweenHeight;
        healthIndicator.localPosition = new Vector3(healthIndicator.localPosition.x, currentHeight, healthIndicator.localPosition.z);
    }
}
