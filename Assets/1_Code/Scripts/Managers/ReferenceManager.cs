using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
public class ReferenceManager : MonoBehaviour
{
    public static ReferenceManager Instance { get; private set; }

    public GameObject PointHolderAnchorReference;
    
    public GameObject[] players;
    public int playerCount;

    public event EventHandler OnPlayerJoined;
    public bool isInEditorMode;
    private void Awake()
    {

        if (Instance != null && Instance != this)
        {
            Destroy(this);
        }
        else
        {
            Instance = this;
        }
        

    }
    private void Start()
    {
        for (int i = PointHolderAnchorReference.transform.childCount - 1; i >= 0; i--)
        {
            Destroy(PointHolderAnchorReference.transform.GetChild(i).gameObject);
        }
    }
    public void UpdatePlayerCount()
    {
        OnPlayerJoined?.Invoke(this, EventArgs.Empty);
    }
}
