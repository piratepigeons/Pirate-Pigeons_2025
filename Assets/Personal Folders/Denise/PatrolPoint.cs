using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PatrolPoint : MonoBehaviour
{
    public Vector3 patrolPointPosition;
    // Ref to Plane
    [SerializeField] private GameObject plane;

    private RaycastHit hit;

    // anstatt void Vector3
    public void CheckPatrolPointPosition()
    {
        if (Physics.Raycast(patrolPointPosition, Vector3.up, out hit))
        {
            //Rotation mitnehmen
            if (hit.collider.gameObject.CompareTag("Obstacle"))
            {
                CalculateNewSpawnPosition();
            }
        }
    }

    public Vector3 CalculateNewSpawnPosition()
    {
        // overkill ist nice :) #mukokuseki #hoiröne
        List<Vector3> VerticeList = new List<Vector3>(plane.GetComponent<MeshFilter>().sharedMesh.vertices);
        Vector3 leftTop = plane.transform.TransformPoint(VerticeList[0]);
        Vector3 rightTop = plane.transform.TransformPoint(VerticeList[10]);
        Vector3 leftBottom = plane.transform.TransformPoint(VerticeList[110]);
        Vector3 rightBottom = plane.transform.TransformPoint(VerticeList[120]);
        Vector3 XAxis = rightTop - leftTop;
        Vector3 ZAxis = leftBottom - leftTop;

        patrolPointPosition = leftTop + XAxis * Random.value + ZAxis * Random.value;

        CheckPatrolPointPosition();
        return patrolPointPosition;
    }

    
    private void OnDrawGizmosSelected()
    {
        List<Vector3> VerticeList = new List<Vector3>(plane.GetComponent<MeshFilter>().sharedMesh.vertices);
        Vector3 leftTop = plane.transform.TransformPoint(VerticeList[0]);
        Vector3 rightTop = plane.transform.TransformPoint(VerticeList[10]);
        Vector3 leftBottom = plane.transform.TransformPoint(VerticeList[110]);
        Vector3 rightBottom = plane.transform.TransformPoint(VerticeList[120]);

        Gizmos.color = Color.magenta;
        Gizmos.DrawSphere(leftTop, 0.5f);
        Gizmos.DrawSphere(rightTop, 0.5f);
        Gizmos.DrawSphere(leftBottom, 0.5f);
        Gizmos.DrawSphere(rightBottom, 0.5f);

        Gizmos.color = Color.white;
        Gizmos.DrawSphere(patrolPointPosition, 0.2f);
    }
    
}
