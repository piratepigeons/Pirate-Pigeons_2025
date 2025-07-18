using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GeneralEnemySpawner : MonoBehaviour
{
    public float[] enemySpawnPlaces;
    bool hasThingsToSpawn;
    int currentIndex;
    bool hasNextIndex;
    float currentProgress;
    float nextEnemySpawnPlace;



    public FlyingFishManager fishManager;

    public GameObject warningSprite;
    [Tooltip("Should be the fillarea of the slider")]
    public Transform warningSignParent;
    public RectTransform sliderTransform;
    float sliderOffset;
    float sliderHeight;
    // Start is called before the first frame update
    void Start()
    {
        sliderOffset = warningSignParent.GetComponent<RectTransform>().offsetMin.x;
        if (enemySpawnPlaces.Length <= 0)
        {
            hasThingsToSpawn = false;
            return;
        }
        hasThingsToSpawn = true;
        sliderHeight = sliderTransform.rect.height;
        currentIndex = 0;
        nextEnemySpawnPlace = enemySpawnPlaces[currentIndex];
        hasNextIndex = CheckIfNextIndex();
        if (hasNextIndex)
        {
            InstatiateWarningSigns();
        }
    }

    void InstatiateWarningSigns()
    {

        foreach (float f in enemySpawnPlaces)
        {
            GameObject sign = Instantiate(warningSprite, warningSignParent);
            float newYPos = ((sliderHeight / 100f) * f) - sliderOffset;
            sign.GetComponent<RectTransform>().anchoredPosition = new Vector3(0, newYPos, 0f);
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (!hasThingsToSpawn)
        {
            return;
        }
        if (!hasNextIndex)
        {
            this.enabled = false;
            return;
        }

        if (BackGroundMover.Instance.distanceReachedPercent >= nextEnemySpawnPlace)
        {
            SpawnEnemy();
            CalculateNextPlace();

        }
    }
    void CalculateNextPlace()
    {
        currentIndex++;
        hasNextIndex = CheckIfNextIndex();
        if (hasNextIndex)
        {
            nextEnemySpawnPlace = enemySpawnPlaces[currentIndex];
        }
        else
        {
            return;
        }

    }

    bool CheckIfNextIndex()
    {
        if (enemySpawnPlaces.Length > currentIndex)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    void SpawnEnemy()
    {

        fishManager.SpawnFish();
    }
}
