using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EditorStateSetter : MonoBehaviour
{

    public ReferenceManager referenceManager;
    public GameObject characterAssign;
    public GameObject player_join_manager;
    public void SetPlaytestState()
    {
        referenceManager.isInEditorMode = true;
        characterAssign.SetActive(false);
        player_join_manager.SetActive(true);
    }


    public void SetPlayerselectState()
    {
        referenceManager.isInEditorMode = false;
        characterAssign.SetActive(true);
        player_join_manager.SetActive(false);
    }
}
