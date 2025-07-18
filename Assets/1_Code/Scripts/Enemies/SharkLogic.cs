using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class SharkLogic : MonoBehaviour
{
    NavMeshAgent nma;
    public GameObject[] p;
    public List<GameObject> players = new List<GameObject>();
    public List<InitialMovement> initialMovements = new List<InitialMovement>();
    public GameObject currentTarget;
    bool arePlayersInWater;
    public Transform originPoint;


    void Start()
    {
        p = GameObject.FindGameObjectsWithTag("Player");
        nma = GetComponent<NavMeshAgent>();
        foreach(GameObject g in p)
        {
            if(g.TryGetComponent<InitialMovement>(out InitialMovement i))
            {
                players.Add(g);
                initialMovements.Add(i);
            }
        }


        TimeTickSystem.OnTick_5 += CheckIfPlayersInWater;
        
        
}



    private void OnDisable()
    {
        TimeTickSystem.OnTick_5 -= CheckIfPlayersInWater;
    }




    private void Update()
    {

        if (arePlayersInWater)
        {
            if(currentTarget == null)
            {
                if(players == null)
                {
                    arePlayersInWater = false;
                    return;
                }
                GetPlayerTarget();
            }
            GoToPlayer();
        }
        else
        {
            currentTarget = null;
            ReturnToOrigin();
            
        }
        
    }
    



    public void GoToPlayer()
    {
        SetTarget(currentTarget.transform);
    }

    public void ReturnToOrigin()
    {
        SetTarget(originPoint);
    }

    public void SetTarget(Transform newTarget)
    {
        // Check if the distances are bigger than 0.1, then move ai towards target
        if (Vector3.Distance(transform.position, newTarget.position) > 0.10f)
        {
            nma.SetDestination(newTarget.position);
        }
    }
    void GetPlayerTarget()
    {
        currentTarget = players[Mathf.RoundToInt(Random.Range(0, players.Count - 1))];
    }

    void CheckIfPlayersInWater(object sender, TimeTickSystem.OnTickEventArgs e)
    {
        p = GameObject.FindGameObjectsWithTag("Player");
        nma = GetComponent<NavMeshAgent>();
        foreach (GameObject g in p)
        {
            if (g.TryGetComponent<InitialMovement>(out InitialMovement i))
            {
                players.Add(g);
                initialMovements.Add(i);
            }
        }

        arePlayersInWater = false;
        if(initialMovements == null)
        {
            arePlayersInWater = false;
        }
        foreach(InitialMovement i in initialMovements)
        {
            if (i.isPlayerNearWater)
            {
                arePlayersInWater = true;
            }
        }
    }
}
