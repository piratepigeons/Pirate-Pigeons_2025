using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;


public class UIManager : MonoBehaviour
{
    GameManager gm;
    public TextMeshProUGUI levelText;

    public TextMeshProUGUI timerText;
    private void Awake()
    {
        gm = GameManager.FindObjectOfType<GameManager>();
        UpdateLevelText(PlayerPrefs.GetInt("Difficulty"));
    }

    public void UpdateLevelText(int difficulty)
    {
        levelText.text = "Difficulty: " + difficulty;
    }

    public void UpdateTimeText(float time)
    {
        timerText.text = "" + Mathf.RoundToInt(time).ToString("00");
    }


}
