using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScoreHandler : MonoBehaviour
{
    public IndividualScoreShower[] scores;
    public Transform bestPlayer;
    int highestcount = 0;
    public bool state;
    public float refreshTime = 1f;
    public float currentTime;

    public PigeonMovement pm;
    public int playerAmount;
    private void Awake()
    {
        playerAmount = PlayerPrefs.GetInt("Players");
        Debug.Log(playerAmount);
        currentTime = refreshTime;
        for (int i = 0; i < 4; i++)
        {
            PlayerPrefs.SetString("Place" + i.ToString(), "");
            PlayerPrefs.SetString("Score" + i.ToString(), "0");
        }

        //foreach 
        if(playerAmount == 2)
        {
            scores[2].gameObject.SetActive(false);
            scores[3].gameObject.SetActive(false);
        }else if(playerAmount == 3)
        {
            scores[3].gameObject.SetActive(false);
        }
    }
    public void RecalculatePlayerOrder()
    {
        highestcount = 0;
        
        foreach (IndividualScoreShower score in scores)
        {
            score.winnerGraphic.SetActive(false);
            score.GetComponent<IndividualScoreShower>().IAmLoser();
            if (highestcount <= score.playersScore)
            {
                
                highestcount = score.playersScore;
                bestPlayer = score.transform;
                bestPlayer.SetAsFirstSibling();
                
            }
            

        }
        bestPlayer.GetComponent<IndividualScoreShower>().IAmWinner();
        bestPlayer.GetComponent<IndividualScoreShower>().winnerGraphic.SetActive(true);
    }

    public void SortAndSaveScores()
    {
        List<KeyValuePair<string, int>> scores = new List<KeyValuePair<string, int>>();
        PigeonMovement[] pigeons =  FindObjectsOfType<PigeonMovement>();
        foreach(PigeonMovement pm in pigeons)
        {
            PigeonInputHandler pIH = pm.GetComponent<PigeonInputHandler>();
            scores.Add(new KeyValuePair<string, int> (pIH.PlayerName, pm.score));
        }
        scores.Sort((scores1, scores2) => scores1.Value.CompareTo(scores2.Value));
        scores.Reverse();
        for (int i = 0; i < scores.Count; i++)
        {
            var score = scores[i];
            PlayerPrefs.SetString("Place" + i.ToString(), score.Key);
            //Debug.Log("Player " + i + "place:" +  score.Key);
            PlayerPrefs.SetString("Score" + i.ToString(), score.Value.ToString());
            //Debug.Log("playerscore " + i + score.Value);
        }
    }
    private void Update()
    {
        currentTime -= Time.deltaTime;
        if (currentTime <= 0)
        {
            currentTime = refreshTime;
            state = false;
            RecalculatePlayerOrder();
        }
    }
}
