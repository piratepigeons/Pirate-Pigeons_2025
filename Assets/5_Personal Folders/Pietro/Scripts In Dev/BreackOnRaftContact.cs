using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class BreackOnRaftContact : MonoBehaviour
{
    private Camera m_camera;
    [SerializeField] private GameObject breackingParticles;
    [SerializeField] private GameObject visuals;

    
    private Transform camTransform;
    private Transform originalPos;
    // How long the object should shake for.
    public float shakeDuration = 0f;
    // Amplitude of the shake. A larger value shakes the camera harder.
    public float shakeAmount = 0.7f;
    public float decreaseFactor = 1.0f;
    

    public UnityEvent eventsToCall;

    private void Start()
    {
        gameObject.GetComponent<BoxCollider>().enabled = true;
        breackingParticles.SetActive(false);

        m_camera = Camera.main;
        camTransform = m_camera.transform;
        originalPos = camTransform;
    }

    private void Update()
    {
        if (shakeDuration > 0)
        {
            camTransform.position = originalPos.position + Random.insideUnitSphere * shakeAmount;

            shakeDuration -= Time.deltaTime * decreaseFactor;
        }
        else
        {
            shakeDuration = 0f;
            camTransform.position = originalPos.position;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Floor"))
        {
            gameObject.GetComponent<BoxCollider>().enabled = false;
            visuals.SetActive(false);
            breackingParticles.SetActive(true);

            shakeDuration = 0.6f;
            eventsToCall.Invoke();
        }
    }
}
