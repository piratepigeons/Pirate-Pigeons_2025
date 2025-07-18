using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerIndex : MonoBehaviour
{
    public PlayerData[] allPlayerData;
    public PlayerData myPlayerData;
    public int currentIndex;

    public Transform playerVisualsSpawn;
    public GameObject temporaryPlayerVisuals;

    public GameObject tempInflatedVisuals;
    public GameObject InflatedVisualsHolder;

    // public Mesh[] hats;

    PlayerReferenceHolder prh;
    public MeshFilter mf;

    public MeshFilter inflatedHatMr;
    public MeshRenderer mr;
    public PlayerAnimationHandler pah;
    public PickUpHandler puh;

    //public Sprite[] playerVisuals;

    public PointManager pm;

    public GameObject[] respawnPoints;

    InitialMovement im;

   // public Material[] materials;


    private void Start()
    {
        pah = GetComponent<PlayerAnimationHandler>();


        im = GetComponent<InitialMovement>();
        respawnPoints = GameObject.FindGameObjectsWithTag("Respawn");
        if (ReferenceManager.Instance != null)
        {
            //here the playerindex is set if you're not coming from the player select screen
            ReferenceManager.Instance.playerCount++;
            currentIndex = ReferenceManager.Instance.playerCount - 1;
            ReferenceManager.Instance.UpdatePlayerCount();



            // here the correct player index is assigned it you're coming from the player select screen
            if (ReferenceManager.Instance.isInEditorMode)
            {
                if (GetComponent<PlayerCustomIndex>() != null)
                {
                    currentIndex = GetComponent<PlayerCustomIndex>().number;
                }
            }
            
        }
        
        foreach(PlayerData pd in allPlayerData)
        {
            pd.points = 0;
        }



        myPlayerData = allPlayerData[currentIndex];
        GameObject newPlayerVisuals = Instantiate(myPlayerData.playerModel, /*Vector3.zero, Quaternion.identity,*/ playerVisualsSpawn);
        temporaryPlayerVisuals.SetActive(false);
        prh = newPlayerVisuals.GetComponentInChildren<PlayerReferenceHolder>();
        pah.pigeonAnimator = prh.playerAnim;
        mf = prh.hatMeshFilter;
        mr = prh.hatMeshRenderer;

        puh.beakTransform = prh.beakTarget;


        mf.mesh = myPlayerData.hat;
        mr.material = myPlayerData.playerMat;
        im.respawnPoint = respawnPoints[currentIndex].transform;
        im.respawnGraphic = respawnPoints[currentIndex].transform.GetChild(0).gameObject;
        im.MovePlayerToSpawnPoint();
        pm.InitializeStats();
        //pm.UpdatePlayerPortrait(myPlayerData.playerPortrait);


        tempInflatedVisuals.GetComponent<SkinnedMeshRenderer>().sharedMesh = myPlayerData.playerInflatedModel.GetComponentInChildren<SkinnedMeshRenderer>().sharedMesh;

        LoadNewHat();
    }

    public void LoadNewHat()
    {
        mf.mesh = myPlayerData.hat;
        inflatedHatMr.mesh = myPlayerData.hat;

    }
}
