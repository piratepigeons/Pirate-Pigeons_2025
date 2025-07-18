using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnParticlesOn : MonoBehaviour
{
    [SerializeField] private GameObject particles;

    private void Start()
    {
        SpawnParticles();
    }


    public void SpawnParticles()
    {
        GameObject ps = Instantiate(particles, transform);
        ps.transform.localScale = new Vector3(0.5f, 0.5f, 0.5f);
        ps.transform.parent = null;
    }
}
