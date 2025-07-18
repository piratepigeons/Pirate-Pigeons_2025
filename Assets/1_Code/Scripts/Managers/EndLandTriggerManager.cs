using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EndLandTriggerManager : MonoBehaviour
{
    public GameObject confetti;
    public float delayEndGameTime = 5f;
    bool state;
    public Transform confettiSpawn;
    public FinishPanelAnimationManager fpam;
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            Instantiate(confetti, other.transform.position, Quaternion.identity);
            LoadEndLogic();
        }
    }


    IEnumerator DelayedWinCondition()
    {

        yield return new WaitForSeconds(delayEndGameTime);
        GameStateManager.Instance.SetGameState(GameStateManager.GameState.win);
        yield return null;
    
    }


    public void PlayEndCeremony()
    {

        Instantiate(confetti, confettiSpawn.position, Quaternion.identity);
        LoadEndLogic();
    }


    void LoadEndLogic()
    {
        if (!state)
        {
            if (SoundManager.Instance != null)
            {
                SoundManager.Instance.Play_End_Whistle_Sound();
            }
            state = true;
            fpam.TriggerEndAnim();
            StartCoroutine(DelayedWinCondition());
        }
    }
        
}
