using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class FinalResultsSorter : MonoBehaviour
{
    public TextMeshProUGUI[] playerNames;
    public TextMeshProUGUI[] playerScores;
    public Image[] playerImagePlaces;
    public Sprite[] sprites;
    public GameObject[] buttons;
    public string[] names;

    private void Awake()
    {
        if(PlayerPrefs.GetInt("Players") == 2)
        {
            buttons[2].SetActive(false);
            buttons[3].SetActive(false);
        }
        else if(PlayerPrefs.GetInt("Players") == 3)
        {
            buttons[3].SetActive(false);
        }
        for(int i = 0; i < 4; i++)
        {
            playerNames[i].text = PlayerPrefs.GetString("Place" + i.ToString());
            playerScores[i].text = PlayerPrefs.GetString("Score" + i.ToString());

            names[i] = PlayerPrefs.GetString("Place" + i.ToString());

            if (names[i].EndsWith("met"))
            {
                Debug.Log("gourr" + i);
                playerImagePlaces[i].sprite = sprites[0];
            }

            else if (names[i].EndsWith("ent"))
            {
                Debug.Log("egg" + i);
                playerImagePlaces[i].sprite = sprites[2];
            }

            else if (names[i].EndsWith("eld"))
            {
                Debug.Log("garf" + i);
                playerImagePlaces[i].sprite = sprites[1];
            }

            else if (names[i].EndsWith("ard"))
            {
                Debug.Log("hawk" + i);
                playerImagePlaces[i].sprite = sprites[3];
            }

            else
            {
                playerImagePlaces[i].transform.SetAsLastSibling();
            }
        }
    }
}
