using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthManager : MonoBehaviour
{
    SoundManager sM;
    MusicManager musicMan;
    GameManager gm;
    public float maxHealth = 100f;
    public float health = 100f;
    public GameObject raft;
    float raftAngle; // current angle from raft
    public float raftAngleRange = 30; //get range from hingejoint
    public float deviationAngle = 2f; // change this value to set when the raft shoult lose health
    float maxAngleRange; // anglerange - deviationAngle
    public float healthDecreaseAmount = 0.2f;

    public GameObject[] raftStages;
    public Renderer warninglight;
    public Material warningMaterial;

    public float breakage1 = 20;
    public float breakage2 = 40;
    public float breakage3 = 60;
    public float breakage4 = 80;

    bool state1;
    bool state2;
    bool state3;
    bool state4;


    void Start()
    {
        sM = FindObjectOfType<SoundManager>();
        health = 0;
        gm = GameObject.FindObjectOfType<GameManager>();
        maxAngleRange = raftAngleRange - deviationAngle;
        musicMan = GameObject.FindObjectOfType<MusicManager>();
        //ChangeRaftMesh(0);
    }

    private void Update()
    {
        raftAngle = raft.transform.eulerAngles.x;
        if(raftAngle > 180f)
        {
            raftAngle -= 360f;
            raftAngle = Mathf.Abs(raftAngle);
        }

        if(raftAngle >= maxAngleRange)
        {
            HealthDecreaser(healthDecreaseAmount);
        }

        if(health > breakage1)
        {
            if (!state1)
            {
                ChangeRaftMesh(1);
                state1 = true;
            }
            

            if (health > breakage2)
            {
                if (!state2)
                {
                    ChangeRaftMesh(2);
                    state2 = true;
                }

                if (health > breakage3)
                {
                    if (!state3)
                    {
                        state3 = true;
                        ChangeRaftMesh(3);
                        warninglight.materials[1] = warningMaterial;
                        sM.DangerBellSound();

                        var materials = warninglight.materials;
                        materials[1] = warningMaterial;
                        warninglight.materials = materials;
                    }

                    if (health > breakage4)
                    {
                        if (!state4)
                        {
                            state4 = true;
                            ChangeRaftMesh(4);
                            
                        }



                    }

                }
            }
        }

        musicMan.HealthMusic(health);
        //here health fmod parameter
    }

    void ChangeRaftMesh(int number)
    {
        //floatTransform.GetComponent<MeshFilter>().mesh = floatGraphics[number];
        
        raftStages[0].SetActive(false);
        raftStages[1].SetActive(false);
        raftStages[2].SetActive(false);
        raftStages[3].SetActive(false);
        raftStages[4].SetActive(false);
        raftStages[number].SetActive(true);
        Debug.Log("particle system in raft");
    }

    public void HealthDecreaser(float decrease)
    {
        health+= decrease*Time.deltaTime;
        if(health >= 100)
        {
            sM.DangerBellSoundStop();
            gm.gameOver = true;

        }
    }
}
