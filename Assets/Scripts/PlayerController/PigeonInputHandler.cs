using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.InputSystem;
using static UnityEngine.InputSystem.InputAction;
using TMPro;


public class PigeonInputHandler : MonoBehaviour
{
    private PlayerConfiguration playerConfig;
    private PigeonMovement pMovement;


    [SerializeField]
    private SkinnedMeshRenderer playerMesh;

    [SerializeField]
    private SkinnedMeshRenderer puffedUpMesh;

    [SerializeField]
    private Transform hatHolder;

    [SerializeField]
    private Transform fatHatHolder;


    [SerializeField]
    private TextMeshPro playerName;

    private TestPlayerInput controls;

    public int pIndex;
    public string PlayerName => playerName.text;

    void Awake()
    {
        /*playerInput = GetComponent<PlayerInput>();
        var movers = FindObjectOfType<PigeonMovement>();
        var index = playerInput.playerIndex;
        pMovement = movers.FirstOrDefault(m => m.GetPlayerIndex() == index);*/

        
        pMovement = GetComponent<PigeonMovement>();
        controls = new TestPlayerInput();
    }

    public void InitializePlayer(PlayerConfiguration pc)
    {
        playerConfig = pc;


        //get pigeon materials, exchange one, reassign materials to pigeon(renderer)
        var materials = playerMesh.materials;
        materials[0] = pc.PlayerMaterial;
        playerMesh.materials = materials;

        puffedUpMesh.material = pc.PuffedUpMaterial;

        //assign Playername
        playerName.text = pc.PlayerName;
        playerConfig.Input.onActionTriggered += Input_onActionTriggered;
        pIndex = pc.PlayerIndex;
        Instantiate(pc.PlayerHat, hatHolder);
        Instantiate(pc.PlayerHat, fatHatHolder);
    }


    //Hier bei jeder neuen Aktion neue funktion callen (zb Jump)
    private void Input_onActionTriggered(CallbackContext obj)
    {
        if(obj.action.name == controls.Player1.HorizontalMovement.name)
        {
            OnHorizontalMovement(obj);
            //OnJump(obj);
        }

        if(obj.action.name == controls.Player1.Jump.name)
        {
            OnJump(obj);
        }

        if (obj.action.name == controls.Player1.Ragdoll.name)
        {
            OnRagdoll(obj);
        }

        if (obj.action.name == controls.Player1.Interact.name)
        {
            OnInteract(obj);
        }

    }

    public void OnHorizontalMovement(CallbackContext context)
    {
        if(pMovement != null)
        {
            pMovement.SetInputvector(context.ReadValue<Vector2>());
        }
        
    }

    public void OnJump(CallbackContext context)
    {
        if (context.performed)
        {
            pMovement.Jump();

            pMovement.isJumping = true;
        }
        if (context.canceled)
        {
            pMovement.isJumping = false;
        }


    }

    public void OnRagdoll(CallbackContext context)
    {
        if (context.performed)
        {

            pMovement.Ragdoll();
        }

        if (context.canceled)
        {

            pMovement.UnRagdoll();
        }

    }

    public void OnInteract(CallbackContext context)
    {
        if (context.performed)
        {
            pMovement.Interact();
        }
        if (context.canceled)
        {
            pMovement.UnInteract();
        }
    }
}
