using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MotorTask : MonoBehaviour
{
    SoundManager sM; //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
    ProgressionManager pm;
    public int progressionAmount = 15;

    public float motorUseAmount = 5f;
    public float windUpDownTime = 5f;
    public Material waterMatStill;
    public Material waterMatFast;
    public WaterSpeed wSpeed;

    [SerializeField]
    private AnimationCurve speedCurve;

    [SerializeField]
    private AnimationCurve speedDownCurve;

    float waterTransparencyFast = 0;
    float waterTransparencyStill = 1;
    
    public float waterSpeedTarget = 0.2f;
    float timer;
    public bool countdown;
    bool state;
    bool otherState = false;

    [SerializeField]
    private Image graphicLeft;
    

    bool loadingMotor;

    
    public CoopMotorSubtask[] coopSubtasks;

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

    public Rigidbody raftRB;
    void Awake()
    {
        sM = FindObjectOfType<SoundManager>(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
        timer = motorUseAmount;
        pm = FindObjectOfType<ProgressionManager>().GetComponent<ProgressionManager>();
        anim = GetComponent<Animator>();
        //graphicLeft.fillAmount = 0;
        waterMatStill.SetFloat("transparency", 1f);
        waterMatFast.SetFloat("transparency", 0f);
        currentFOV = normalFOV;
        cam.fieldOfView = currentFOV;
        flagAmount = flags.Length;
        state = false;
        /*for (int i = 0; i < flagAmount; i++)
        {
            cloths[i] = flags[i].GetComponent<Cloth>();
        }*/
    }

    
    /*public void UseMotor()
    {
        //pm.Progression(progressionAmount);
        loadingMotor = true;
        //StartCoroutine("LoadMotorWithCurve");
    }

    public void UnUseMotor()
    {
        loadingMotor = false;
    }*/

    

    void ChangeFlagAcceleration(float speed)
    {
        for(int i = 0; i< flagAmount; i++)
        {
            flags[i].externalAcceleration = new Vector3 (-25, 0, speed);
        } 
    }

    

    private void Update()
    {
        /* if (loadingMotor)
         {
             graphicLeft.fillAmount += 1f * Time.deltaTime;
             //graphic.fillAmount += Mathf.Lerp(0, 1, speedCurve.Evaluate(Time.deltaTime / 2));
             if (graphicLeft.fillAmount >= 1f)
             {
                 countdown = true;
             }
         }
         //wenn nicht aufgeladen wird, wird grafik zurück gesetzt
         else
         {
             graphicLeft.fillAmount -= 4f * Time.deltaTime;
         }*/

        
        if(coopSubtasks[0].activated && coopSubtasks[1].activated)
        {
            
            countdown = true;
        }

        if (countdown)
        {
            pm.isProgressing = true;
            //raftRB.AddTorque(-transform.forward * 1.5f, ForceMode.Acceleration);
            Debug.Log("Progressing");
            //ActivateMotor
            if (!state)
            {
                state = true;
                coopSubtasks[0].AwardPlayer();
                coopSubtasks[1].AwardPlayer();
                //ActivateMotor();
                StartCoroutine(AnimateSpeed(true, fastFlagSpeed, speedyFOV, 1f, 0f, false, speedCurve));
                sM.PigeonFixSound();  //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
                sM.MotorStart(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
                sM.MotorRunningStart(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
                sM.MotorSwitch(1);
                GiveForceToRigidBodies();

            }
            
            timer -= Time.deltaTime;
            if(timer <= 0)
            {
                countdown = false;
                pm.isProgressing = false;
                timer = motorUseAmount;
                state = false;

                //DeactivateMotor
                if (!otherState)
                {
                    otherState = true;

                    StartCoroutine(AnimateSpeed(false, normalFlagSpeed, normalFOV, 0f, 1f, true, speedCurve)); //StartCoroutine(AnimateSpeed(false, normalFlagSpeed, normalFOV, 0f, 1f, true, speedDownCurve));
                    sM.MotorRunningStop(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
                    sM.MotorSwitch(0);
                }
                
            }
        }
        else
        {
            anim.SetBool("isRunning", false);
        }
    }

    void GiveForceToRigidBodies()
    {
        PigeonMovement[] allPlayers = FindObjectsOfType(typeof(PigeonMovement)) as PigeonMovement[];
        foreach (PigeonMovement singlePlayer in allPlayers)
        {
            singlePlayer.GiveForceToPlayer();
        }
        raftRB.AddTorque(Vector3.left * 1000f, ForceMode.Impulse);
    }

    IEnumerator AnimateSpeed(bool animState, float flagSpeed, float targetFOV, float targetSpeed, float invertedTargetTransparency, bool reset, AnimationCurve curve)
    {
        anim.SetBool("isRunning", animState);
        ChangeFlagAcceleration(flagSpeed);
        for (float t = 0; t < 1; t += Time.deltaTime / 3f)
        {
            currentFOV = Mathf.Lerp(currentFOV, targetFOV, curve.Evaluate(t)); //Mathf.MoveTowards(currentFOV, wantedFOV, windUpDownTime * Time.deltaTime);
            cam.fieldOfView = currentFOV;
            //Debug.LogWarning("dont forget to speed up scrolling texture again");

            waterTransparencyStill = Mathf.Lerp(waterTransparencyStill, invertedTargetTransparency, curve.Evaluate(t));
            waterTransparencyFast = Mathf.Lerp(waterTransparencyFast, targetSpeed, curve.Evaluate(t));//(Mathf.MoveTowards(waterSpeed, wantedSpeed, (windUpDownTime / 5f) * Time.deltaTime));
            waterMatFast.SetFloat("transparency", waterTransparencyFast);
            waterMatStill.SetFloat("transparency", waterTransparencyStill);

            yield return null;
        }
        if (reset)
        {

            otherState = false;
        }
    }

    /*bool ChangeValuesForMovement(float wantedFOV,float wantedSpeed)
    {
        currentFOV = Mathf.MoveTowards(currentFOV, wantedFOV, windUpDownTime * Time.deltaTime);
        cam.fieldOfView = currentFOV;
        //Debug.LogWarning("dont forget to speed up scrolling texture again");


        waterSpeed = (Mathf.MoveTowards(waterSpeed, wantedSpeed, (windUpDownTime/5f) * Time.deltaTime));
        waterMat.SetFloat("WaterSpeed", waterSpeed);
        //wSpeed.nextWaterSpeed = wantedSpeed;

        if(currentFOV == normalFOV)
        {
            return true;
        }
        else
        {
            return false;
        }
    }*/


    void ActivateMotor()
    {
        anim.SetBool("isRunning", true);
        //waterSpeed = Mathf.SmoothStep(0f, waterSpeedTarget, 2f);
        //waterMat.SetFloat("WaterSpeed", waterSpeed);
        //ChangeValuesForMovement(speedyFOV, waterSpeedTarget);
        waterMatFast.SetFloat("transparency", 1);
        waterMatStill.SetFloat("transparency", 0);
        ChangeFlagAcceleration(fastFlagSpeed);

    }

    /*
    
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
            state = false;
        }
    }*/



    /*IEnumerator LoadMotorWithCurve()
    {
        graphicLeft.fillAmount += 1f * Time.deltaTime;
        float startFloat = graphicLeft.fillAmount;
        float endFloat = 1f;
        for (float t = 0; t < 1; t += Time.deltaTime / 10f)
        {
            graphicLeft.fillAmount = Mathf.Lerp(startFloat, endFloat, speedCurve.Evaluate(t));
            yield return null;
        }
    }*/


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
