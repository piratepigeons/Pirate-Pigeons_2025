using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoatBreakageManager : MonoBehaviour
{
    public MeshFilter raftMeshfilter;
    public MeshFilter ropeMeshfilter;
    public Mesh[] boatBreakageStates;
    public Mesh[] ropeBreakageStates;
    float previousHealth;

    int threshholdAmts;
    float[] threshholds;

    float nextLowerThreshhold;
    float nextHigherThreshhold;
    int currentIndex;
    private void Start()
    {

        previousHealth = HealthManager.Instance.maxHealth;
        threshholdAmts = boatBreakageStates.Length - 1;
        threshholds = new float[threshholdAmts];
        for (int i = 0; i < threshholdAmts; i++)
        {


            threshholds[i] = (previousHealth - ((previousHealth / (threshholdAmts + 1)) * i)) - (previousHealth / (threshholdAmts + 1));


        }

        currentIndex = 0;
        CalculateThreshholds(currentIndex);
        HealthManager.OnUpdateHealthVisual += RecieveHealthUpdate;
    }

    private void OnEnable()
    {
        


       

        
    }

    private void OnDisable()
    {

        HealthManager.OnUpdateHealthVisual -= RecieveHealthUpdate;
    }


    void RecieveHealthUpdate(object sender, HealthManager.OnHealthUpdateEventArgs e)
    {
        if(e.currentHealth <= 0)
        {
            return;
        }
        //Debug.Log(e.currentHealth);
        if(e.currentHealth <= previousHealth)
        {
            CompareDown(e.currentHealth);
        }
        else
        {
            CompareUp(e.currentHealth);
        }

        previousHealth = e.currentHealth;
    }


    //if you lose health
    void CompareDown(float currentHealth)
    {
        if(nextLowerThreshhold > currentHealth)
        {
            currentIndex++;
            SetBoatGraphics();
            CalculateThreshholds(currentIndex);
        }
        
    }

    //if gaining health
    void CompareUp(float currentHealth)
    {
        if (nextHigherThreshhold < currentHealth)
        {
            currentIndex--;
            SetBoatGraphics();
            
            CalculateThreshholds(currentIndex);
        }
        
    }


    void CalculateThreshholds(int index)
    {
        if(index <= 0)
        {
            nextLowerThreshhold = threshholds[0];
            nextHigherThreshhold = HealthManager.Instance.maxHealth;
        }
        
        else if(index >= threshholdAmts)
        {
            currentIndex = threshholdAmts;
            nextLowerThreshhold = 0;
            nextHigherThreshhold = threshholds[threshholdAmts-1]; ;
        }
        else
        {
            nextLowerThreshhold = threshholds[index];
            nextHigherThreshhold = threshholds[index-1];
        }
    }


    void SetBoatGraphics()
    {
        raftMeshfilter.mesh = boatBreakageStates[currentIndex];
        ropeMeshfilter.mesh = ropeBreakageStates[currentIndex];
    }
}
