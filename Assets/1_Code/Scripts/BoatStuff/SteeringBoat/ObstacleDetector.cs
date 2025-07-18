using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObstacleDetector : MonoBehaviour
{
    public ShakeTween shaker;
    public Steering steering;
    //public BoxCollider boxCol;
    public enum Direction
    {
        CheckNorth,
        CheckEast,
        CheckSouth,
        CheckWest
    }


    public Direction currentDirection;
    private void OnTriggerEnter(Collider collision)
    {
        if (collision.CompareTag("Island"))
        {
            
            switch (currentDirection)
            {
                case Direction.CheckNorth:
                    steering.isCollidingFront = true;
                    shaker.ShakeOverTime(0.1f);
                    // Perform actions specific to North
                    break;

                case Direction.CheckEast:
                    steering.isCollidingRight = true;
                    // Perform actions specific to East
                    break;

                case Direction.CheckSouth:
                    shaker.ShakeOverTime(0.05f);
                    steering.isCollidingBack = true;
                    // Perform actions specific to South
                    break;

                case Direction.CheckWest:
                    steering.isCollidingLeft = true;
                    // Perform actions specific to West
                    break;

                default:
                    steering.isCollidingFront = true;

                    break;
            }
          
        }
    }


    private void OnTriggerExit(Collider collision)
    {
        if (collision.CompareTag("Island"))
        {
            switch (currentDirection)
            {
                case Direction.CheckNorth:
                    steering.isCollidingFront = false;
                    // Perform actions specific to North
                    break;

                case Direction.CheckEast:
                    steering.isCollidingRight = false;
                    // Perform actions specific to East
                    break;

                case Direction.CheckSouth:
                    steering.isCollidingBack = false;
                    // Perform actions specific to South
                    break;

                case Direction.CheckWest:
                    steering.isCollidingLeft = false;
                    // Perform actions specific to West
                    break;

                default:
                    steering.isCollidingFront = false;
                    break;
            }
        }
    }

    /*void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.dra
        Gizmos.DrawWireCube(transform.position, boxCol.size);
    }*/
}
