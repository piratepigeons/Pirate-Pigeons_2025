using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class PointManager : MonoBehaviour
{
    PlayerData pd;
    public float currentPoints;
    TextMeshProUGUI pointText;
    Image portrait;
    Image hatSprite;
    public GameObject individualPointManager;
    public Transform particleSpawn;
    public GameObject plusOneParticle;
    public GameObject plusThreeParticle;
    public GameObject plus10Particle;
    public GameObject plus35Particle;
    public GameObject plus50Particle;
    public GameObject minus20Particle;

    private void Awake()
    {
        SceneManager.sceneLoaded += OnSceneLoaded;
    }


    private void OnDisable()
    {
        SceneManager.sceneLoaded -= OnSceneLoaded;
    }
    void OnSceneLoaded(Scene scene, LoadSceneMode mode)
    {
        pd = GetComponent<PlayerIndex>().myPlayerData;
        if(ReferenceManager.Instance == null)
        {
            return;
        }
        GameObject ipm = Instantiate(individualPointManager, ReferenceManager.Instance.PointHolderAnchorReference.transform);
        pointText = ipm.GetComponentInChildren<TextMeshProUGUI>();
        portrait = ipm.GetComponent<Image>();
        hatSprite = GetChildImage(ipm);
        UpdatePlayerPortrait(pd.playerPortrait, pd.playerHatSprite);
        pd.points = 0;
        UpdatePointText();
    }
    public  void InitializeStats()
    {
        if (ReferenceManager.Instance == null)
        {
            return;
        }
        pd = GetComponent<PlayerIndex>().myPlayerData;
        GameObject ipm = Instantiate(individualPointManager, ReferenceManager.Instance.PointHolderAnchorReference.transform);
        pointText = ipm.GetComponentInChildren<TextMeshProUGUI>();
        portrait = ipm.GetComponent<Image>();
        hatSprite = GetChildImage(ipm);
        UpdatePlayerPortrait(pd.playerPortrait, pd.playerHatSprite);
        pd.points = 0;
        UpdatePointText();
    }

    Image GetChildImage(GameObject parent)
    {
        Image[] images = parent.GetComponentsInChildren<Image>();
        foreach(Image img in images)
        {
            if (img.gameObject != parent)
            {
                return img;
            }
        }
        return null;
    }

    public void AddPoints(float pointAmount)
    {

        currentPoints += pointAmount;

        switch (Mathf.RoundToInt(pointAmount))
        {
            case 50:
                Instantiate(plus50Particle, particleSpawn.position, Quaternion.identity);
                break;

            case 35:
                Instantiate(plus35Particle, particleSpawn.position, Quaternion.identity);
                break;

            case 10:
                Instantiate(plus10Particle, particleSpawn.position, Quaternion.identity);
                break;

            case 3:
                Instantiate(plusThreeParticle, particleSpawn.position, Quaternion.identity);
                break;

            case -20:
                Instantiate(minus20Particle, particleSpawn.position, Quaternion.identity);
                break;
            default:
                Instantiate(plusOneParticle, particleSpawn.position, Quaternion.identity);
                break;

        }
        pd.points = Mathf.RoundToInt(currentPoints);
        UpdatePointText();
    }

    void UpdatePointText()
    {
        pointText.text = Mathf.RoundToInt(currentPoints).ToString("0000");
    }

    public void UpdatePlayerPortrait(Sprite newPortrait, Sprite hat)
    {
        portrait.sprite = newPortrait;
        hatSprite.sprite = hat;
    }
}
