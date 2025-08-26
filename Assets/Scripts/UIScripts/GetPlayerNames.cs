using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GetPlayerNames : MonoBehaviour
{
    public string[] names;
    public string[] scores;
    void Start()
    {
        for (int i = 0; i < 3; i++)
        {
            //var score = scores[i];
            names[i] = PlayerPrefs.GetString("Place" + i.ToString());
            //Debug.Log("Player " + i + "place:");
            scores[i] = PlayerPrefs.GetString("Score" + i.ToString());
            //Debug.Log("playerscore " + i);

            if (names[i].EndsWith("met"))
            {
                Debug.Log("gourr" + i);
            }

            else if (names[i].EndsWith("ent"))
            {
                Debug.Log("egg" + i);
            }

            else if (names[i].EndsWith("eld"))
            {
                Debug.Log("garf" + i);
            }

            else if (names[i].EndsWith("ard"))
            {
                Debug.Log("hawk" + i);
            }
        }


        
    }
}
