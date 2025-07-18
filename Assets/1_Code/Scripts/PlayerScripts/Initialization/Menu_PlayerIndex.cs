using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Menu_PlayerIndex : MonoBehaviour
{
    public PlayerData[] allPlayerData;
    public PlayerData myPlayerData;
    public int currentIndex;

    public Transform playerVisualsSpawn;
    public GameObject temporaryPlayerVisuals;


    // public Mesh[] hats;

    PlayerReferenceHolder prh;
    public MeshFilter mf;

    public GameObject tempInflatedVisuals;
    //public GameObject[] playerInflatedVisuals;
    public GameObject InflatedVisualsHolder;

    public GameObject[] respawnPoints;


    public MeshFilter inflatedHatMr;
    public MeshRenderer mr;
    public PlayerAnimationHandler pah;

    Menu_InitialMovement im;

    // public Material[] materials;


    private void Start()
    {

        respawnPoints = GameObject.FindGameObjectsWithTag("Respawn");


        pah = GetComponent<PlayerAnimationHandler>();

        im = GetComponent<Menu_InitialMovement>();

        if (GetComponent<PlayerCustomIndex>() != null)
        {
            currentIndex = GetComponent<PlayerCustomIndex>().number;
        }


        myPlayerData = allPlayerData[currentIndex];
        GameObject newPlayerVisuals = Instantiate(myPlayerData.playerModel, /*respawnPoints[currentIndex].transform.position, Quaternion.Euler(0f, 180f, 0f),*/ playerVisualsSpawn);
        temporaryPlayerVisuals.SetActive(false);
        prh = newPlayerVisuals.GetComponentInChildren<PlayerReferenceHolder>();
        pah.pigeonAnimator = prh.playerAnim;
        mf = prh.hatMeshFilter;
        mr = prh.hatMeshRenderer;

        
       // mf.mesh = myPlayerData.hat;
        mr.material = myPlayerData.playerMat;


        im.respawnPoint = respawnPoints[currentIndex].transform;
        im.MovePlayerToSpawnPoint();


        //GameObject newPlayerInflatedVisuals = Instantiate(myPlayerData.playerInflatedModel, /*Vector3.zero, Quaternion.identity,*/ tempInflatedVisuals.transform);
        //newPlayerInflatedVisuals.transform.parent = InflatedVisualsHolder.transform;
        //newPlayerInflatedVisuals.transform.localScale = new Vector3(1.0f, 1.0f, 1.0f);

        tempInflatedVisuals.GetComponent<SkinnedMeshRenderer>().sharedMesh = myPlayerData.playerInflatedModel.GetComponentInChildren<SkinnedMeshRenderer>().sharedMesh;

        //Transform[] children = tempInflatedVisuals.GetComponentsInChildren<Transform>();
        //Transform childWithTag = children.FirstOrDefault(child => child.CompareTag("Hat"));



        //inflatedHatMr = childWithTag.GetComponent<MeshFilter>();
        //tempInflatedVisuals.SetActive(false);
        LoadNewHat();
       

    }


    public void LoadNewHat()
    {
        mf.mesh = myPlayerData.hat;
        inflatedHatMr.mesh = myPlayerData.hat;

    }
}
