using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class TimeTickSystem : MonoBehaviour
{
    public class OnTickEventArgs : EventArgs
    {
        public int tick;
    }
    public static event EventHandler<OnTickEventArgs> OnTick;
    public static event EventHandler<OnTickEventArgs> OnTick_5; //every Second
    private const float TICK_TIMER_MAX = 0.2f;
    private int tick;
    private float tickTimer;


    private void Awake()
    {
        tick = 0;
    }

    private void Update()
    {
        tickTimer += Time.deltaTime;
        if (tickTimer >= TICK_TIMER_MAX)
        {
            tickTimer -= TICK_TIMER_MAX;
            tick++;
            if (OnTick != null) OnTick(this, new OnTickEventArgs { tick = tick });

            if (tick % 5 == 0)
            {
                if (OnTick_5 != null) OnTick_5(this, new OnTickEventArgs { tick = tick });
            }
        }
    }
}
