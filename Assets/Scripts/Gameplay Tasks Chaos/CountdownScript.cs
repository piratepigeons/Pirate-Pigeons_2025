using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CountdownScript : MonoBehaviour
{
    GameManager gm;
    UIManager uiM;
    public float initialTime = 60f;
    public float moreTimePerLevel = 3f;
    private float timer;
    float difficulty;
    // Start is called before the first frame update
    private void Awake()
    {
        gm = GameManager.FindObjectOfType<GameManager>();
        uiM = GameManager.FindObjectOfType<UIManager>();
    }
    void Start()
    {
        difficulty = PlayerPrefs.GetInt("Difficulty");
        timer = initialTime + (difficulty * moreTimePerLevel);
    }

    // Update is called once per frame
    void Update()
    {
        
        if(timer > 0)
        {
            timer -= Time.deltaTime;
            uiM.UpdateTimeText(timer);
        }
        else
        {
            gm.gameWon = true;
            uiM.UpdateTimeText(0);
        }
    }

    
}
