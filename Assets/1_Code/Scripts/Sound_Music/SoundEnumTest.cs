using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FMODUnity;

public class SoundEnumTest : MonoBehaviour
{
    public FMOD.Studio.EventInstance em;
    public EventReference mainMusic;
    public SoundState state;
    public enum SoundState { Water, Break, Bird};
    private void Start()
    {
        em = RuntimeManager.CreateInstance(mainMusic);
    }
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.F))
        {
            Debug.Log("SOUND");
            //em.setParameterByNameWithLabel
            //em.setParameterByName("EnumPara", 1);
            em.setParameterByNameWithLabel("EnumPara", state.ToString());
            em.set3DAttributes(FMODUnity.RuntimeUtils.To3DAttributes(gameObject.transform));
            em.start();
        }
    }
}
