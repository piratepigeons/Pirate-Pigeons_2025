using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class WinCalculationManager : MonoBehaviour
{
    public PlayerData[] playerDatas;
    public WinScorePanelReferences[] wsprs;
    public Transform scorepanelParent;
    public GameObject scorePanel;
    public WinPanelAnimation winPanelAnimation;

    class PlayerScore
    {
        public int id;
        public int score;
    }

    PlayerScore[] playerScores;
    PlayerScore[] sortedScores;
    
    // Start is called before the first frame update
    void Start()
    {
        playerScores = new PlayerScore[]
        {
            new PlayerScore{id = 0, score = playerDatas[0].points},
            new PlayerScore{id = 1, score = playerDatas[1].points},
            new PlayerScore{id = 2, score = playerDatas[2].points},
            new PlayerScore{id = 3, score = playerDatas[3].points}
        };
        System.Array.Sort(playerScores, (a, b) => a.score.CompareTo(b.score));
        //sortedScores = playerScores.OrderBy<>
        for(int i = 0; i < playerScores.Length; i++)
        {


            int index;
            index = playerScores[i].id;
            wsprs[i].playerName.text = playerDatas[index].playerName;
            wsprs[i].portraitSprite.sprite = playerDatas[index].playerPortrait;
            wsprs[i].hatSprite.sprite = playerDatas[index].playerHatSprite;
            wsprs[i].score.text = playerDatas[index].points.ToString("0000");
            if(playerDatas[index].points == 0)
            {
                wsprs[i].gameObject.SetActive(false);
                wsprs[i].holder.SetActive(false);
            }
        }

        winPanelAnimation.PlayStartupAnim();
    }

}
