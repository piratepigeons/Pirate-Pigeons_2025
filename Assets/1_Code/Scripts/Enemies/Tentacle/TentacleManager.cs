using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TentacleManager : MonoBehaviour
{
    public int maxHealth;

    public int currentHealth;

    public GameObject tentacleObject;
    public GameObject inbetweenTentacle;
    public GameObject animatedTentacle;

    public GameObject tentacleTarget;
    public GameObject weakPoint;
    public Transform resetTentaclePosition;
    public Transform resetTentacleTargetPos;
    public GameObject deathParticle;

    [Header("Tentacle Bone References")]
    public Animator tentacleAnim;
    public float transitionTime; 
    
    public Transform physicsBoneBase;
    public Transform[] physicsBones;

    public Transform inbetweenBoneBase;
    public Transform[] inbetweenBones;

    public Transform animatedBoneBase;
    public Transform[] animatedBones;
    


    private void Start()
    {
        currentHealth = maxHealth;
        DisableTentacle();
    }
    public void HurtTentacle()
    {
        currentHealth--;
        if (SoundManager.Instance != null)
        {
            SoundManager.Instance.PigeonFixIncrement();
        }
        LeanTween.scale(tentacleObject, Vector3.one * 1.2f, 0.4f).setEase(LeanTweenType.punch);
        if(currentHealth <= 0)
        {
            KillTentacle();
        }
    }


    [ContextMenu("Enable")]
    public void EnableTentacle()
    {
        BackGroundMover.Instance.StopMovement();
        MotorBlockerManager.Instance.BlockMotor();
        currentHealth = maxHealth;
        tentacleObject.SetActive(true);
        //weakPoint.SetActive(true);
    }


    [ContextMenu("Disable")]
    void DisableTentacle()
    {
        MotorBlockerManager.Instance.UnBlockMotor();
        BackGroundMover.Instance.ContinueMovement() ;

        tentacleObject.SetActive(false);
        inbetweenTentacle.SetActive(false);
        animatedTentacle.SetActive(false);
        
        tentacleObject.transform.position = resetTentaclePosition.position;
        tentacleTarget.transform.position = resetTentacleTargetPos.position;

        currentHealth = maxHealth;
    }


    void TentacleDieAnimation()
    {
        MotorBlockerManager.Instance.UnBlockMotor();
        BackGroundMover.Instance.ContinueMovement();

        tentacleObject.SetActive(false);
        inbetweenTentacle.SetActive(true);

        /*tentacleObject.transform.position = resetTentaclePosition.position;
        tentacleTarget.transform.position = resetTentacleTargetPos.position;*/

        StartCoroutine(SmoothMoveBones());
        currentHealth = maxHealth;
    }

    public void KillTentacle()
    {
        currentHealth = 0;
        SoundManager.Instance.PigeonFixSound();
        Instantiate(deathParticle, tentacleObject.transform.position, Quaternion.identity);
        TentacleDieAnimation();
        //DisableTentacle();

        weakPoint.SetActive(false);
    }



    [ContextMenu("Fill up Tentacle Arrays")]
    public void SetTentacleArray()
    {
        physicsBones = physicsBoneBase.GetComponentsInChildren<Transform>();
        inbetweenBones = inbetweenBoneBase.GetComponentsInChildren<Transform>();
        animatedBones = animatedBoneBase.GetComponentsInChildren<Transform>();
    }


    IEnumerator SmoothMoveBones()
    {

        
        //Set Start positions & rotations Arrays for Lerp 
        Vector3[] positions = new Vector3[inbetweenBones.Length];
        Quaternion[] rotations = new Quaternion[inbetweenBones.Length];

        // Set inbetweenBones to the initial positions and rotations of physicsBones
        for (int i = 0; i < inbetweenBones.Length; i++)
        {
            inbetweenBones[i].position = physicsBones[i].position;
            inbetweenBones[i].rotation = physicsBones[i].rotation;

            positions[i] = inbetweenBones[i].position;
            rotations[i] = inbetweenBones[i].rotation;

        }

        float elapsedTime = 0f;

        while (elapsedTime < transitionTime)
        {
            float t = elapsedTime / transitionTime;
            
            for (int i = 0; i < inbetweenBones.Length; i++)
            {
                inbetweenBones[i].position = Vector3.Lerp(positions[i], animatedBones[i].position, t);
                inbetweenBones[i].rotation = Quaternion.Slerp(rotations[i], animatedBones[i].rotation, t);

            }

            elapsedTime += Time.deltaTime;
            yield return null;
        }

        // Ensure all bones reach their final positions and rotations
        for (int i = 0; i < inbetweenBones.Length; i++)
        {
            inbetweenBones[i].position = animatedBones[i].position;
            inbetweenBones[i].rotation = animatedBones[i].rotation;
        }

        inbetweenTentacle.SetActive(false);
        animatedTentacle.SetActive(true);
        tentacleAnim.SetBool("Die", true);
    }



   
}
