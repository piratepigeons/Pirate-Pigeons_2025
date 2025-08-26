using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ImprovedMotorTask : MonoBehaviour
{
    ProgressionManager pm;
    public int progressionAmount = 15;

    public float motorUseAmount = 5f;
    public float windUpDownTime = 5f;
    public Material waterMat;
    public WaterSpeed wSpeed;

    [SerializeField]
    private AnimationCurve speedCurve;

    float waterSpeed;
    public float waterSpeedTarget = 0.2f;
    float timer;
    public bool countdown;
    bool state;
    public Image graphic;
    bool loadingMotor;


    Animator anim;

    public MeshRenderer materialToChange;

    public Camera cam;
    float currentFOV;
    public float normalFOV = 52;
    public float speedyFOV = 54;
    public float normalFlagSpeed = -5f;
    public float fastFlagSpeed = -100f;
    public Cloth[] flags;
    int flagAmount;


    //THIS IS JUST A BACKUP!

    void Awake()
    {
        timer = motorUseAmount;
        pm = FindObjectOfType<ProgressionManager>().GetComponent<ProgressionManager>();
        anim = GetComponent<Animator>();
        graphic.fillAmount = 0;
        waterMat.SetFloat("WaterSpeed", 0f);
        currentFOV = normalFOV;
        cam.fieldOfView = currentFOV;
        flagAmount = flags.Length;
        /*for (int i = 0; i < flagAmount; i++)
        {
            cloths[i] = flags[i].GetComponent<Cloth>();
        }*/
    }


    public void UseMotor()
    {
        //pm.Progression(progressionAmount);
        loadingMotor = true;
        //StartCoroutine("LoadMotorWithCurve");
        Debug.Log("Yes");
    }

    public void UnUseMotor()
    {
        loadingMotor = false;
        Debug.Log("no");
    }

    void ActivateMotor()
    {
        anim.SetBool("isRunning", true);
        //waterSpeed = Mathf.SmoothStep(0f, waterSpeedTarget, 2f);
        //waterMat.SetFloat("WaterSpeed", waterSpeed);
        ChangeValuesForMovement(speedyFOV, waterSpeedTarget);
        ChangeFlagAcceleration(fastFlagSpeed);

    }



    void DeactivateMotor()
    {
        anim.SetBool("isRunning", false);
        //waterMat.SetFloat("WaterSpeed", 0f);
        cam.fieldOfView = normalFOV;
        ChangeValuesForMovement(normalFOV, 0.001f);
        ChangeFlagAcceleration(normalFlagSpeed);
        if (ChangeValuesForMovement(normalFOV, 0.001f))
        {
            countdown = false;
            timer = motorUseAmount;
            pm.isProgressing = false;
        }
    }

    void ChangeFlagAcceleration(float speed)
    {
        for (int i = 0; i < flagAmount; i++)
        {
            flags[i].externalAcceleration = new Vector3(0, 0, speed);
        }
    }

    bool ChangeValuesForMovement(float wantedFOV, float wantedSpeed)
    {
        currentFOV = Mathf.MoveTowards(currentFOV, wantedFOV, windUpDownTime * Time.deltaTime);
        cam.fieldOfView = currentFOV;
        //Debug.LogWarning("dont forget to speed up scrolling texture again");


        waterSpeed = (Mathf.MoveTowards(waterSpeed, wantedSpeed, (windUpDownTime / 5f) * Time.deltaTime));
        waterMat.SetFloat("WaterSpeed", waterSpeed);
        //wSpeed.nextWaterSpeed = wantedSpeed;

        if (currentFOV == normalFOV)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    private void Update()
    {
        if (loadingMotor)
        {
            //graphic.fillAmount += 1f * Time.deltaTime;
            graphic.fillAmount += Mathf.Lerp(0, 1, speedCurve.Evaluate(Time.deltaTime / 2));
            if (graphic.fillAmount >= 1f)
            {
                countdown = true;
            }
        }
        //wenn nicht aufgeladen wird, wird grafik zurück gesetzt
        else
        {
            graphic.fillAmount -= 4f * Time.deltaTime;
        }



        if (countdown)
        {
            pm.isProgressing = true;
            ActivateMotor();
            timer -= Time.deltaTime;
            if (timer <= 0)
            {

                DeactivateMotor();
            }
        }
    }

    IEnumerator LoadMotorWithCurve()
    {
        graphic.fillAmount += 1f * Time.deltaTime;
        float startFloat = graphic.fillAmount;
        float endFloat = 1f;
        for (float t = 0; t < 1; t += Time.deltaTime / 3f)
        {
            graphic.fillAmount = Mathf.Lerp(startFloat, endFloat, speedCurve.Evaluate(t));
            yield return null;
        }
    }

    /*IEnumerator AnimateSpeed()
    {
        Debug.Log("start animation " + Time.frameCount);

        Vector3 startPos = transform.position;
        Vector3 endPos = transform.position + targetPositionDelta;

        for (float t = 0; t < 1; t += Time.deltaTime / duration)
        {
            Vector3 currentPos = Vector3.Lerp(startPos, endPos, easeCurve.Evaluate(t));
            transform.position = currentPos;
            yield return null;
        }

        Debug.Log("end animation " + Time.frameCount);
    }*/
}
