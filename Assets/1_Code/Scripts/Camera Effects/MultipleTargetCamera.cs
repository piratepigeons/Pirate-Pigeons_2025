using System.Collections;
using System.Collections.Generic;
using UnityEditor.Experimental.GraphView;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class MultipleTargetCamera : MonoBehaviour
{
    public List<Transform> targets;

    public Vector3 cameraOffset;
    public float smoothTime = 0.5f;

    private Vector3 velocity;
    private Camera cam;
    private int lastPCount = 0;

    public float minZoom = 40f;
    public float maxZoom = 10f;
    public float zoomLimiter = 50f;

    private void Start()
    {
        cam = GetComponent<Camera>();
        foreach (GameObject player in GameObject.FindGameObjectsWithTag("Player"))
        {
            if (player != null) { targets.Add(player.transform); }
        }
    }

    private void Update()
    {
        if(PlayerConfigurationManager.instance.currentPlayersCount != lastPCount)
        {
            foreach (GameObject player in GameObject.FindGameObjectsWithTag("Player"))
            {
                if (player != null && !targets.Contains(player.transform)) { targets.Add(player.transform); }
            }
            lastPCount = PlayerConfigurationManager.instance.currentPlayersCount;
        }
    }

    private void LateUpdate()
    {
        if(targets.Count == 0) return;

        Move();
        Zoom();
    }

    private void Move()
    {
        Vector3 newPositionPoint = new Vector3(GetCenterPoint().x + cameraOffset.x,cameraOffset.y,cameraOffset.z);
        transform.position = Vector3.SmoothDamp(transform.position, newPositionPoint, ref velocity, smoothTime);
    }

    private void Zoom()
    {
        float newZoom = Mathf.Lerp(maxZoom, minZoom, GetGreatestDistance()/ zoomLimiter);
        cam.fieldOfView = Mathf.Lerp(cam.fieldOfView, newZoom, Time.deltaTime);
    }

    float GetGreatestDistance()
    {
        var bounds = new Bounds(targets[0].position, Vector3.zero);
        for (int i = 1; i < targets.Count; i++)
        {
            bounds.Encapsulate(targets[i].position);
        }

        return bounds.size.x;
    }

    Vector3 GetCenterPoint()
    {
        if(targets.Count == 1)
        {
            return targets[0].position;
        }

        var bounds = new Bounds(targets[0].position, Vector3.zero);
        for (int i = 1; i<targets.Count; i++)
        {
            bounds.Encapsulate(targets[i].position);
        }

        return bounds.center;
    }
}
