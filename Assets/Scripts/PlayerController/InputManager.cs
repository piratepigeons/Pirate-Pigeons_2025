using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InputManager : MonoBehaviour
{
    [SerializeField] Movement movement;

    TestPlayerInput controls;
    TestPlayerInput.Player1Actions groundMovement;

    Vector2 horizontalInput;

    private void Awake() {
        controls = new TestPlayerInput();
        groundMovement = controls.Player1;
        groundMovement.HorizontalMovement.performed += ctx => horizontalInput = ctx.ReadValue<Vector2>();

    }

    private void Update() {
        movement.ReceiveInput(horizontalInput);
    }
    private void OnEnable() {
        controls.Enable();
    }

    private void OnDisable() {
        controls.Disable();
    }

}
