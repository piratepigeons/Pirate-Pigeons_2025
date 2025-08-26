using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RaftHealth : MonoBehaviour
{
    public Slider healthBar;
    HealthManager hm;
    float maxHealth;
    float currentHealth;
    // Start is called before the first frame update
    void Awake()
    {
        hm = GameManager.FindObjectOfType<HealthManager>();
        currentHealth = hm.health;
        maxHealth = hm.health;
        healthBar.maxValue = maxHealth;

    }

    // Update is called once per frame
    void Update()
    {
        currentHealth = hm.health;
        healthBar.value = currentHealth;
    }
}
