using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using static UnityEngine.InputSystem.InputAction;

public class Menu_PlayerMovement : MonoBehaviour
{
    public Menu_InitialMovement movement;

    public PlayerAnimationHandler pigeonAnimator;


    public void OnInflate(CallbackContext context)
    {
        if (context.performed)
        {
            movement.OnInflatePerformed(context);
            pigeonAnimator.SetInflation();
        }
        else if (context.canceled)
        {
            movement.OnInflateCancelled(context);
            pigeonAnimator.UnSetInflation();
        }
    }

    public void OnInteract(CallbackContext context)
    {
        if (context.performed)
        {
            //taskHandler.OnInteractPerformed(context);
            pigeonAnimator.TriggerPeck();
            movement.OnInteractPerformed(context);
        }
        else if (context.canceled)
        {
            //taskHandler.OnInteractCancelled(context);
        }
    }

    public void OnJump(CallbackContext context)
    {
        if (context.performed)
        {
            movement.OnJumpPerformed(context);
            pigeonAnimator.TriggerJump();
        }
        else if (context.canceled)
        {
            movement.OnJumpCancelled(context);
        }
    }

    public void OnMove(CallbackContext context)
    {
        if (context.performed)
        {
            movement.OnMovementPerformed(context);
            pigeonAnimator.SetWalk();
        }
        else if (context.canceled)
        {
            movement.OnMovementCancelled(context);
            pigeonAnimator.UnSetWalk();
        }
    }
}
