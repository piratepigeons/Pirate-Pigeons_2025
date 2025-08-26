using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour
{
    [SerializeField] CharacterController controller;
    [SerializeField] float speed = 11f;
    public Transform groundCheck;
    public LayerMask groundMask;
    public float gravity = -9.81f;
    public float groundDistance = 0.2f;

    Vector2 horizontalInput;
    private Vector3 velocity;
    private bool isGrounded;

    private void Update() {

        //isGrounded = Physics.CheckSphere(groundCheck.position, groundDistance, groundMask);
        //if(isGrounded && velocity.y <0) {
        //    velocity.y = -2f;
        //}
        
        Vector3 horizontalVelocity = (Vector3.right * horizontalInput.x + Vector3.forward * horizontalInput.y) * speed;
        controller.Move(horizontalVelocity * Time.deltaTime);
        //velocity.y += gravity * Time.deltaTime;
        //controller.Move(velocity * Time.deltaTime);

    }
    public void ReceiveInput (Vector2 input) {
        horizontalInput = input;
        //Debug.Log(horizontalInput);
    }
}
