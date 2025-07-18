using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class BoatManager : MonoBehaviour
{
    float currentXRot;
    float currentZRot;

    float boatHurtAnglesFirst;
    float boatHurAnglesSecond;
    float healthRemoveAmt;
    float currentShakeWaitTimer;
    public float shakeTimeInterval;
    public ShakeTween shaker;

    public GameObject boatVisuals;

    public Floating[] floaters;

    private void Start()
    {
        currentShakeWaitTimer = shakeTimeInterval;
        
    }

    
    private void OnEnable()
    {
        DifficultyManager.OnSetDifficultyLevel += RecieveDifficultyChange;

        if(ReferenceManager.Instance != null)
        {
            ReferenceManager.Instance.OnPlayerJoined += UpdateDisplacementAmt;
        }


    }


    
    private void OnDisable()
    {
        DifficultyManager.OnSetDifficultyLevel -= RecieveDifficultyChange;
        if (ReferenceManager.Instance != null)
        {
            ReferenceManager.Instance.OnPlayerJoined -= UpdateDisplacementAmt;
        }
    }

    void RecieveDifficultyChange(object sender, DifficultyManager.OnLoadDifficultyArgs e)
    {
        boatHurtAnglesFirst = e.boatHurtAngle.x;
        boatHurAnglesSecond = e.boatHurtAngle.y;
        SetFloaterDistance(sender, e);
        healthRemoveAmt = e.healthRemoveAmount;
    }


    void SetFloaterDistance(object sender, DifficultyManager.OnLoadDifficultyArgs e)
    {
        floaters[0].transform.localPosition = new Vector3(floaters[0].transform.localPosition.x, floaters[0].transform.localPosition.y, -e.balanceFloaterDistance);
        floaters[1].transform.localPosition = new Vector3(floaters[1].transform.localPosition.x, floaters[1].transform.localPosition.y, -e.balanceFloaterDistance);
        floaters[2].transform.localPosition = new Vector3(floaters[2].transform.localPosition.x, floaters[2].transform.localPosition.y, e.balanceFloaterDistance);
        floaters[3].transform.localPosition = new Vector3(floaters[3].transform.localPosition.x, floaters[3].transform.localPosition.y, e.balanceFloaterDistance);
    }
    void UpdateDisplacementAmt(object sender, System.EventArgs e)
    {
        foreach (Floating f in floaters)
        {
            f.displacementAmount = 2 + ( .25f*ReferenceManager.Instance.playerCount);
        }
    }
    // Update is called once per frame
    void LateUpdate()
    {
        currentXRot = transform.localEulerAngles.x;
        if(currentXRot > 180f)
        {
            currentXRot -= 360f;
        }
        currentZRot = transform.localEulerAngles.z;
        if (currentZRot > 180f)
        {
            currentZRot -= 360f;
        }

        if (Mathf.Abs(currentXRot) >= boatHurtAnglesFirst || Mathf.Abs(currentZRot) >= boatHurtAnglesFirst)
        {
            HealthManager.Instance?.RemoveHealth(healthRemoveAmt/2);

            if (Mathf.Abs(currentXRot) >= boatHurAnglesSecond || Mathf.Abs(currentZRot) >= boatHurAnglesSecond)
            {
                HealthManager.Instance?.RemoveHealth(healthRemoveAmt / 2);
                Debug.Log("Second coming of christ");
            }
            else
            {
                Debug.Log("normal die");
            }
                currentShakeWaitTimer -= Time.deltaTime;
            if(currentShakeWaitTimer <= 0)
            {
                currentShakeWaitTimer = shakeTimeInterval;
                shaker.ShakeObject();
                SoundManager.Instance?.BreakageSound();
            }

        }
    }

}
