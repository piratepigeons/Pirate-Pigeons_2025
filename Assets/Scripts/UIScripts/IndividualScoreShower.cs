using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class IndividualScoreShower : MonoBehaviour
{
    ScoreHandler sh;
    public TextMeshProUGUI scoreText;
    public int playersScore;
    public GameObject winnerGraphic;
    public bool iAmFirst;
    private void Awake()
    {
        playersScore = 0;
        UpdateText(playersScore);
        sh = GetComponentInParent<ScoreHandler>();
    }
    public void UpdateText(int score)
    {
        playersScore = score;
        scoreText.text = "" + playersScore;
    }
   public void IAmWinner()
    {
        iAmFirst = true;
    }

    public void IAmLoser()
    {
        iAmFirst = false;
    }
}
