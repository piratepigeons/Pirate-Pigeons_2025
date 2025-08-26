using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterSpeed : MonoBehaviour
{
    public Material waterMaterial;
    public float nextWaterSpeed = 1;

    [SerializeField] private float lerpTime;
    private float currentWaterSpeed;

    private void Start()
    {
        waterMaterial = GetComponent<Renderer>().material;
    }

    
    /*private void OnGUI()
    {
        if(GUILayout.Button("Change water speed"))
        {
            ChangeWaterSpeed(5f);
        }
    }*/
    

    public void ChangeWaterSpeed(float duration)
    {
        StartCoroutine(ChangeWaterSpeedRoutine(duration));
    }

    private IEnumerator ChangeWaterSpeedRoutine(float duration)
    {
        Debug.Log("Change Water Speed To: " + duration);

        for (float t = 0; t <= 1; t += Time.deltaTime / duration)
        {
            currentWaterSpeed = waterMaterial.GetFloat("WaterSpeed");
            waterMaterial.SetFloat("WaterSpeed", Mathf.Lerp(currentWaterSpeed, nextWaterSpeed, lerpTime * Time.deltaTime));
            yield return null;
        }

        yield return null;           
    }
}
