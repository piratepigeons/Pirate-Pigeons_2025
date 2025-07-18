using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using UnityEngine;

public class DifficultyTriggerScript : MonoBehaviour
{
    [SerializeField] private GameObject buttonUp;
    [SerializeField] private GameObject[] buttonDown;

    public bool easy;
    public bool medium;
    public bool hard;
    public bool ultra;


    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            buttonUp.SetActive(false);
            foreach (var button in buttonDown) { button.SetActive(true); }
            if(SoundManager.Instance!= null)
            {
                SoundManager.Instance.UIButtonPlay();
            }
            //set difficulty here

            //to read use PlayerPrefs.GetInt("Difficulty", 0) and it will give the int between 0-3 by default 0
            if(easy)
            {
                PlayerPrefs.SetInt("Difficulty", 0);
            }else if(medium)
            {
                PlayerPrefs.SetInt("Difficulty", 1);
            }
            else if(hard) 
            {
                PlayerPrefs.SetInt("Difficulty", 2);
            }

            else if (ultra)
            {
                PlayerPrefs.SetInt("Difficulty", 3);
            }
        }
    }
}
