using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ProgressionManager : MonoBehaviour
{
    GameManager gm;
    public int finalLength = 1000;
    public float motorSpeed = 15f;
    public float idleSpeed = 1f;

    //X-Value when wave starts, y-Value when wave ends
    public Vector2 firstStop = new Vector2(150, 200);
    public Vector2 secondStop = new Vector2(360, 440);
    public Vector2 thirdStop = new Vector2(700, 830);
    public float currentLength = 0;
    public Slider progressionBar;

    public bool isProgressing;
    public ParticleSystem rain;
    public int gameState;

    MusicManager musMan; //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
    SoundManager sM; //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL

    
    private void Awake()
    {
        sM = FindObjectOfType<SoundManager>();  //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
        musMan = FindObjectOfType<MusicManager>(); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
        gm = GetComponent<GameManager>();
        currentLength = 0;
        progressionBar.maxValue = finalLength;
        gameState = 2;
    }

   

    // Update is called once per frame
    void Update()
    {
        if ((currentLength >= firstStop.x && currentLength <= firstStop.y) || (currentLength >= secondStop.x && currentLength <= secondStop.y) || (currentLength >= thirdStop.x && currentLength <= thirdStop.y))
        {
            sM.AmbientSoundsSwitch(0);
            sM.SeagullSound();
            gm.dangerState = true;
            rain.Play();
            gameState = 3;
            //ambientEvent.setParameterByName("storm", 1);
        }
        else
        {
            sM.AmbientSoundsSwitch(1);
            sM.ThunderSound();
            gm.dangerState = false;
            rain.Stop();
            gameState = 2;
            //ambientEvent.setParameterByName("storm", 0);

        }
        if (isProgressing)
        {
            //currentLength += motorSpeed * Time.deltaTime;
            Progression(motorSpeed);
            
        }
        else
        {
            Progression(idleSpeed);
        }
        musMan.MusicStormChanger(gameState); //-------------------------------------------------------------------------------------------------------------------------------- VON SIBEL
        UpdateProgressbarGraphic();
    }
    public void Progression(float amount)
    {
        amount *= Time.deltaTime;
        currentLength += amount;
        UpdateProgressbarGraphic();
        if (currentLength >= finalLength)
        {
            gm.gameWon = true;
            Debug.Log("I WON!");
        }
    }

    void UpdateProgressbarGraphic()
    {
        progressionBar.value = currentLength;
    }
}
