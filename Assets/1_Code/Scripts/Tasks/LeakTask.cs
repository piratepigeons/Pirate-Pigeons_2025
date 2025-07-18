using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LeakTask : MonoBehaviour
{
    public SkinnedMeshRenderer[] smr;
    public GameObject foamParent;
    public float takeAwayAmount;
    public float currentLeakLevel;
    public float currentPercent;
    public float biggestScale = 100f;
    [Tooltip ("value is in %")]
    public float smallestScale = 40;
    public float startLeakLevel;
    public GameObject visuals;
    Vector3 startScale;


    bool winState = false;
    bool destroyState = false;

    public GameObject fixParticle;

    [Header("Health Removal")]
    public float leakHealtRemoveStartTime = 2f;
    public GameObject healthRemoveWarning;
    bool healthRemoveState;

    float healthRemoveAmt;
    float difficultyRemoveAmt;
    public float healthRemoveAmtConstant = 0.01f;

    


    


    // Start is called before the first frame update
    void Start()
    {
        startScale = visuals.transform.localScale;
        currentLeakLevel = startLeakLevel;
        currentPercent = biggestScale;
        CalculatePercent();
        StartUpAnim();

        DifficultyManager.OnSetDifficultyLevel += RecieveDifficultyLevel;
        healthRemoveAmt = healthRemoveAmtConstant * healthRemoveAmtConstant;
    }

    private void OnEnable()
    {

        GameStateExecutor.OnStateWin += RecieveWinState;
    }

    private void OnDisable()
    {

        GameStateExecutor.OnStateWin -= RecieveWinState;
        DifficultyManager.OnSetDifficultyLevel -= RecieveDifficultyLevel;

    }

    void RecieveDifficultyLevel(object sender, DifficultyManager.OnLoadDifficultyArgs e)
    {
        difficultyRemoveAmt = e.healthRemoveAmount;
    }



    void RecieveWinState(object sender, GameStateExecutor.OnChangeGameStateEventArgs e)
    {
        if (!winState)
        {
            winState = true;
            StartCoroutine(DelayedShrink());
        }
    }


    IEnumerator DelayedShrink()
    {
        yield return new WaitForSeconds(Random.Range(0, 0.3f));
        ShrinkAndVanish();
        yield return null;
    }

    // Update is called once per frame
    void Update()
    {
        if(leakHealtRemoveStartTime > 0)
        {
            leakHealtRemoveStartTime -= Time.deltaTime;
            return;
        }
        if (!healthRemoveState)
        {
            healthRemoveState = true;
            healthRemoveWarning.SetActive(true);
        }
        HealthManager.Instance.RemoveHealth(healthRemoveAmt);
    }

    public void DecreaseLeakLevel()
    {
        if(SoundManager.Instance != null)
        {
            SoundManager.Instance.PigeonFixIncrement();
        }
        if(currentLeakLevel > 0)
        {
            currentLeakLevel -= takeAwayAmount;
            CalculatePercent();
            UpdateLeakVisual();
        }
        else
        {
            if (!destroyState)
            {
                destroyState = true;
                FixLeak();
            }
            
        }
        
    }

    void StartUpAnim()
    {
        visuals.transform.localScale = Vector3.zero;
        LeanTween.scale(visuals, startScale, 0.3f).setEase(LeanTweenType.easeOutBack);
        if(SoundManager.Instance != null)
        {
            SoundManager.Instance.WaterLeakStart();
            SoundManager.Instance.WaterLeakRunningStart();
        }
        UpdateLeakVisual();
    }

    void FixLeak()
    {

        HealthManager.Instance.AddHealth();
        ShrinkAndVanish();
    }

    void ShrinkAndVanish()
    {
        if (SoundManager.Instance != null)
        {
            SoundManager.Instance.WaterLeakRunningStop();
            SoundManager.Instance.PigeonFixSound();
        }
        Instantiate(fixParticle, transform.position, Quaternion.identity);
        LeanTween.scale(visuals, Vector3.zero, 0.2f).setEase(LeanTweenType.easeInBack);
        LeanTween.delayedCall(0.3f, DelayedDeleter);
    }

    void DelayedDeleter()
    {
        LeanTween.cancel(gameObject);
        Destroy(gameObject);
    }

    void CalculatePercent()
    {

        currentPercent = (100f / startLeakLevel) * currentLeakLevel;// (currentPercent / currentLeakLevel) * startLeakLevel;
    }

    void UpdateLeakVisual()
    {
       // foamParent.transform.localScale = Vector3.one *(currentPercent / 100f);

        visuals.transform.localScale = Vector3.one * ((((currentPercent / biggestScale) * (biggestScale - smallestScale)) + smallestScale) /biggestScale);
       /* foreach(SkinnedMeshRenderer skinned in smr)
        {
            skinned.SetBlendShapeWeight(0, 100 - currentPercent);
        }*/
    }
}
