using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StormManager : MonoBehaviour
{
    public Vector2[] stormCells;
    bool hasStormCellsToSpawn;
    int currentIndex;
    bool hasNextIndex;
    float nextStormCellSpawn;
    float nextStormCellEnd;
    bool isInStorm;

    public GameObject stormCellSprite;
    [Tooltip("Should be the fillarea of the slider")]
    public Transform warningSignParent;
    public RectTransform sliderTransform;
    float sliderOffset;
    float sliderHeight;
    // Start is called before the first frame update
    void Start()
    {

        sliderOffset = warningSignParent.GetComponent<RectTransform>().offsetMin.x;
        if (stormCells.Length <= 0)
        {
            hasStormCellsToSpawn = false;
            return;
        }
        hasStormCellsToSpawn = true;



        sliderHeight = sliderTransform.rect.height;
        currentIndex = 0;
        nextStormCellSpawn = stormCells[currentIndex].x;
        nextStormCellEnd = stormCells[currentIndex].y;
        hasNextIndex = CheckIfNextIndex();
        if (hasNextIndex)
        {
            InstatiateWarningSigns();
        }
    }

    void InstatiateWarningSigns()
    {
        foreach (Vector2 f in stormCells)
        {
            GameObject sign = Instantiate(stormCellSprite, warningSignParent);
            float newYPos = ((sliderHeight / 100f) * f.x) - sliderOffset;
            sign.GetComponent<RectTransform>().anchoredPosition = new Vector3( 0f, newYPos, 0f);
            sign.GetComponent<RectTransform>().sizeDelta = new Vector2(94f, ((sliderHeight / 100f)*(f.y-f.x)) - sliderOffset);
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (!hasStormCellsToSpawn)
        {
            return;
        }
        if (!hasNextIndex)
        {
            this.enabled = false;
            return;
        }

        if (!isInStorm && BackGroundMover.Instance.distanceReachedPercent >= nextStormCellSpawn)
        {
            EnableCurrentStorm();
            CalculateNextStormExit();

        }
        if(isInStorm && BackGroundMover.Instance.distanceReachedPercent >= nextStormCellEnd)
        {
            ExitCurrentStorm();
            CalculateNextStormStart();
        }
    }


    void CalculateNextStormExit()
    {
        nextStormCellEnd = stormCells[currentIndex].y;

    }
    void CalculateNextStormStart()
    {
        currentIndex++;
        hasNextIndex = CheckIfNextIndex();
        if (hasNextIndex)
        {
            nextStormCellSpawn = stormCells[currentIndex].x;
        }
        else
        {
            return;
        }

    }

    bool CheckIfNextIndex()
    {
        if (stormCells.Length > currentIndex)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    void EnableCurrentStorm()
    {
        isInStorm = true;
        GameStateManager.Instance.SetGameState(GameStateManager.GameState.storm);
    }


    void ExitCurrentStorm()
    {
        isInStorm = false;
        GameStateManager.Instance.SetGameState(GameStateManager.GameState.game);

    }
}
