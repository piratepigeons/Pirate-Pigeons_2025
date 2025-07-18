using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HamsterwheelBreacker : MonoBehaviour
{
    [SerializeField] private Hamsterwheel hamsterwheelRef;

    [SerializeField] private float wheelDurability = 1000;
    [SerializeField] private float minWheelDurability = 1000;
    [SerializeField] private float maxWheelDurability = 3000;

    [SerializeField] private bool wheelIsBroken;
    [SerializeField] private GameObject[] wheelPedals;
    [SerializeField] private ParticleSystem wheelBrokenPS;

    [SerializeField] private GameObject FixWheelTask;

    private void Start()
    {
        wheelDurability = Random.Range(minWheelDurability, maxWheelDurability);
        wheelIsBroken = false;
        foreach (var wheelPedal in wheelPedals)
        {
            wheelPedal.SetActive(true);
        }
        wheelBrokenPS.Stop();
    }

    private void FixedUpdate()
    {
        if(hamsterwheelRef.hamsterWheelSpeed > 0) 
        {
            wheelDurability -= 1;
        }
        if (wheelDurability <= 0)
        {
            foreach (var wheelPedal in wheelPedals)
            {
                wheelPedal.SetActive(false);
            }
            if (!wheelIsBroken)
            {
                wheelBrokenPS.Play();
                FixWheelTask.SetActive(true);
                wheelIsBroken = true;
            }
        }
    }

    public void RepairWheel()
    {
        foreach (var wheelPedal in wheelPedals)
        {
            wheelPedal.SetActive(true);
        }
        wheelBrokenPS.Stop();
        wheelDurability = Random.Range(minWheelDurability, maxWheelDurability);
        wheelIsBroken = false;

    }
}
