using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadMenuIfNoPlayer : MonoBehaviour
{
    public PlayerCountScript player;
    public int playerCount;
    float timer = 0.1f;


    void Update()
    {
        if(timer > 0)
        {
            timer -= Time.deltaTime;
        }

        
        else if (playerCount == 0)
        {
            //Debug.Log(playerCount);
            SceneManager.LoadScene("MainMenuScreen");
        }
    }
   public void AddPoints()
    {
        playerCount++;
    }
}
