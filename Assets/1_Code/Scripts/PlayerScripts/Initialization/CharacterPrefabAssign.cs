using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterPrefabAssign : MonoBehaviour
{
    public GameObject characterPrefabOfThisScene;

    private void Start()
    {
        PlayerConfigurationManager.instance.currentPlayerCharacter = characterPrefabOfThisScene;
        PlayerConfigurationManager.instance.ReassignPlayerInputs();
    }
}
