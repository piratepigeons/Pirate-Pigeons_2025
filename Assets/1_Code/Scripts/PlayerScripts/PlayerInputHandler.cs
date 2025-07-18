using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using static UnityEngine.InputSystem.InputAction;
using UnityEngine.InputSystem;
using System;

public class PlayerInputHandler : MonoBehaviour
{
    private CustomInput input = null;

    private PlayerConfiguration playerConfig;
    [SerializeField] private SkinnedMeshRenderer skinnedMeshRenderer;


    public class OnInputEventArgs : EventArgs
    {
        public CallbackContext value;
    }
    public static event EventHandler<OnInputEventArgs> OnMovemenPerformed_Event;
    public static event EventHandler<OnInputEventArgs> OnMovementCancelled_Event;
    /*public static event EventHandler<OnInputEventArgs> OnInflatePerformed_Event;
    public static event EventHandler<OnInputEventArgs> OnInflateCancelled_Event;
    public static event EventHandler<OnInputEventArgs> OnJumpPerformed_Event;
    public static event EventHandler<OnInputEventArgs> OnJumpCancelled_Event;
    public static event EventHandler<OnInputEventArgs> OnInteractPerformed_Event;
    public static event EventHandler<OnInputEventArgs> OnInteractCancelled_Event;*/


    /*private void Awake()
    {
        input = new CustomInput();
    }
    #region OnEnable/Disable
    private void OnEnable()
    {
        input.Enable();
        input.Player.Movement.performed += OnMovementPerformed;
        input.Player.Movement.canceled += OnMovementCancelled;
        input.Player.Inflate.performed += OnInflatePerformed;
        input.Player.Inflate.canceled += OnInflateCancelled;
        input.Player.Jump.performed += OnJumpPerformed;
        input.Player.Jump.canceled += OnJumpCancelled;
        input.Player.Interact.performed += OnInteractPerformed;
        input.Player.Interact.canceled += OnInteractCancelled;
    }

    private void OnDisable()
    {
        input.Disable();
        input.Player.Movement.performed -= OnMovementPerformed;
        input.Player.Movement.canceled -= OnMovementCancelled;
        input.Player.Inflate.performed -= OnInflatePerformed;
        input.Player.Inflate.canceled -= OnInflateCancelled;
        input.Player.Jump.performed -= OnJumpPerformed;
        input.Player.Jump.canceled -= OnJumpCancelled;
        input.Player.Interact.performed -= OnInteractPerformed;
        input.Player.Interact.canceled -= OnInteractCancelled;
    }
    #endregion





    public void InitializePlayer(PlayerConfiguration pc)
    {
        playerConfig = pc;

    }*/

    public void OnInteractPerformed(CallbackContext value)
    {
       // if (OnTick_5 != null) OnTick_5(this, new OnTickEventArgs { tick = tick });
        if (OnMovemenPerformed_Event != null) OnMovemenPerformed_Event(this, new OnInputEventArgs { value = value });
    }
    public void OnInteractCancelled(CallbackContext value)
    {
        if (OnMovementCancelled_Event != null) OnMovementCancelled_Event(this, new OnInputEventArgs { value = value });
    }





   /* void OnMovementPerformed(CallbackContext value)
    {
        
    }

    void OnMovementCancelled(CallbackContext value)
    {
        

    }

    void OnJumpPerformed(CallbackContext value)
    {
        

    }
    void OnJumpCancelled(CallbackContext value)
    {
        

    }

    void OnInflatePerformed(CallbackContext value)
    {

    }

    void OnInflateCancelled(CallbackContext value)
    {

    }*/
}
