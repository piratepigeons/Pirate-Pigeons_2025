using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MotorPointManager : MonoBehaviour
{
    public float pointsToAward;
    public List<PointManager> players = new List<PointManager>();




    private void OnEnable()
    {
        MotorTask.OnMotorActivate += AwardPlayers;
    }
    private void OnDisable()
    {
        MotorTask.OnMotorActivate -= AwardPlayers;
    }
    void AwardPlayers(object sender, MotorTask.OnMotorEventArgs e)
    {
        if (players != null)
        {
            foreach (PointManager p in players)
            {
                p.AddPoints(pointsToAward);
            }
        }
    }
}
