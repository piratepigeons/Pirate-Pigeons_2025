using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WinPanelAnimation : MonoBehaviour
{
    public GameObject winPanel;
    public List<GameObject> allPanelVisuals = new List<GameObject>();
    List<GameObject> individualPanels = new List<GameObject>();
    //GameObject[] individualPanels;
    public float timeDelay;
    public float tweenTime;
    public LeanTweenType tweenType;

    public void PlayStartupAnim()
    {
        for (int i = 0; i < allPanelVisuals.Count; i++)
        {
            //Transform child = winPanel.transform.GetChild(i);
            if (allPanelVisuals[i].activeInHierarchy)
            {
                individualPanels.Add(allPanelVisuals[i]);
            }
        }
        //for (int i = individualPanels.Count-1; i >= 0; i--)

            for (int i = 0; i < individualPanels.Count; i++)
        {
            Debug.Log(i);
            Vector3 endPosition = individualPanels[i].transform.localPosition;
            individualPanels[i].transform.localPosition = endPosition + (Vector3.up * 800f);
            StartCoroutine(FallDownAnim(i * timeDelay, endPosition, individualPanels[i]));
           // LeanTween.moveLocal(individualPanels[i], endPosition, i + timeDelay).setEase(tweenType);
        }
    }



    IEnumerator FallDownAnim(float waitTime, Vector3 endPos, GameObject panel)
    {
        yield return new WaitForSeconds(waitTime);
        LeanTween.moveLocal(panel, endPos, tweenTime).setEase(tweenType);
    }
}
