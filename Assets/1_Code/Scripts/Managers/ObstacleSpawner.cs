using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObstacleSpawner : MonoBehaviour
{
    public float[] tentacleSpawnPlaces;
    bool hasThingsToSpawn;
    int currentIndex;
    bool hasNextIndex;
    float currentProgress;
    float nextTentacleSpawnPlace;
    public TentacleManager tentacle;

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
        if (tentacleSpawnPlaces.Length <= 0)
        {
            hasThingsToSpawn = false;
            return;
        }
        hasThingsToSpawn = true;
        sliderHeight = sliderTransform.rect.height;
        currentIndex = 0;
        nextTentacleSpawnPlace = tentacleSpawnPlaces[currentIndex];
        hasNextIndex = CheckIfNextIndex();
        if (hasNextIndex)
        {
            InstatiateWarningSigns();
        }
    }

    void InstatiateWarningSigns()
    {
        
        foreach(float f in tentacleSpawnPlaces)
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

        if( BackGroundMover.Instance.distanceReachedPercent >= nextTentacleSpawnPlace)
        {
            EnableCurrentTentacle();
            CalculateNextPlace();
            
        }
    }
    void CalculateNextPlace()
    {
        currentIndex++;
        hasNextIndex = CheckIfNextIndex();
        if (hasNextIndex)
        {
            nextTentacleSpawnPlace = tentacleSpawnPlaces[currentIndex];
        }
        else
        {
            return;
        }
        
    }

    bool CheckIfNextIndex()
    {
        if (tentacleSpawnPlaces.Length > currentIndex)
        {
            return  true;
        }
        else
        {
            return false;
        }
    }

    void EnableCurrentTentacle()
    {

        tentacle.EnableTentacle();
    }

}
