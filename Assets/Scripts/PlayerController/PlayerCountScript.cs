using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerCountScript : MonoBehaviour
{
   
    LoadMenuIfNoPlayer script;
    private void Awake()
    {
        script = FindObjectOfType<LoadMenuIfNoPlayer>().GetComponent<LoadMenuIfNoPlayer>();
        script.AddPoints();
    }

}
