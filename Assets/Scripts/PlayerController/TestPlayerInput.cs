// GENERATED AUTOMATICALLY FROM 'Assets/Scripts/PlayerController/TestPlayerInput.inputactions'

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.Utilities;

public class @TestPlayerInput : IInputActionCollection, IDisposable
{
    public InputActionAsset asset { get; }
    public @TestPlayerInput()
    {
        asset = InputActionAsset.FromJson(@"{
    ""name"": ""TestPlayerInput"",
    ""maps"": [
        {
            ""name"": ""Player1"",
            ""id"": ""809dd215-d85b-4eb2-802b-6209185a0706"",
            ""actions"": [
                {
                    ""name"": ""Dash"",
                    ""type"": ""Button"",
                    ""id"": ""c5296902-e1b3-4929-90ba-c0b6557d383f"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""DoSomething"",
                    ""type"": ""Button"",
                    ""id"": ""b5464c60-1b3e-4de0-b98f-dc7fd80894fe"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""HorizontalMovement"",
                    ""type"": ""PassThrough"",
                    ""id"": ""b9791dbd-bf62-4406-b256-89bc1bbe42da"",
                    ""expectedControlType"": ""Vector2"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Ragdoll"",
                    ""type"": ""Button"",
                    ""id"": ""a1e5daf2-8a04-4477-b77e-03a47365931b"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Jump"",
                    ""type"": ""Button"",
                    ""id"": ""b3cb9ea8-3700-4745-bfb3-83adbcfa8deb"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Respawn"",
                    ""type"": ""Button"",
                    ""id"": ""9e5072b6-6d73-4721-9ac9-9745f2ead223"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Interact"",
                    ""type"": ""Button"",
                    ""id"": ""d8cf01da-d028-43d1-9b2f-c9d9160593d5"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                }
            ],
            ""bindings"": [
                {
                    ""name"": """",
                    ""id"": ""97de84db-406e-4565-8207-4fb3a858e465"",
                    ""path"": ""<Gamepad>/buttonEast"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Dash"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""1a9ff855-a8ef-4484-a067-9e219d1d68cd"",
                    ""path"": ""<Gamepad>/buttonSouth"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""DoSomething"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""7a9562f0-e5b2-4392-b01a-2ad6ebaf3380"",
                    ""path"": ""<HID::Microntek              USB Joystick          >/button3"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""DoSomething"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": ""2D Vector"",
                    ""id"": ""1e745b57-29d3-4b39-92d2-daf0753f8d71"",
                    ""path"": ""2DVector"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""HorizontalMovement"",
                    ""isComposite"": true,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": ""up"",
                    ""id"": ""7c1e77ca-0405-400a-9cb4-939856a67b46"",
                    ""path"": ""<Gamepad>/leftStick/up"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""HorizontalMovement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""down"",
                    ""id"": ""492c02ac-7954-46fe-8f8d-4211493abff4"",
                    ""path"": ""<Gamepad>/leftStick/down"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""HorizontalMovement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""left"",
                    ""id"": ""2600d2e7-1c12-4f33-9686-df3b44c7fe7c"",
                    ""path"": ""<Gamepad>/leftStick/left"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""HorizontalMovement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""right"",
                    ""id"": ""3ecac229-31e2-4fb7-b2c4-34741304d1bb"",
                    ""path"": ""<Gamepad>/leftStick/right"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""HorizontalMovement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": """",
                    ""id"": ""19c813ee-122b-466d-88a9-3598517eca21"",
                    ""path"": ""<HID::Microntek              USB Joystick          >/stick"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""HorizontalMovement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""52b0eb66-e46c-4ac7-b0b6-c820db249100"",
                    ""path"": ""<Gamepad>/rightShoulder"",
                    ""interactions"": ""Press(behavior=2)"",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Ragdoll"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""2c164b3b-2c21-497d-babd-82b3a6bbddec"",
                    ""path"": ""<HID::Microntek              USB Joystick          >/button6"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Ragdoll"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""994de749-0b6e-48cd-823a-f59ef9d3d097"",
                    ""path"": ""<HID::Microntek              USB Joystick          >/button8"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Ragdoll"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""b1ad383d-4b68-4edc-a3de-cc1058df5659"",
                    ""path"": ""<Gamepad>/leftShoulder"",
                    ""interactions"": ""Hold"",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Respawn"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""463ccb29-a64b-4a4a-a313-70142f42cd48"",
                    ""path"": ""<Gamepad>/buttonSouth"",
                    ""interactions"": ""Press"",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Interact"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""1ffbdc46-f2e6-4319-99bb-f2a293292ad2"",
                    ""path"": ""<HID::Microntek              USB Joystick          >/button3"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Interact"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""c78ed65b-eeca-44d9-9c05-75ed5479f5f8"",
                    ""path"": ""<Gamepad>/buttonEast"",
                    ""interactions"": ""Press"",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Jump"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""9ebac943-e5eb-43fe-8258-bfe16b466f01"",
                    ""path"": ""<HID::Microntek              USB Joystick          >/button2"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Jump"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                }
            ]
        },
        {
            ""name"": ""Player2"",
            ""id"": ""a6898194-ec3f-4bb0-affc-6a36c5880839"",
            ""actions"": [
                {
                    ""name"": ""Dash"",
                    ""type"": ""Button"",
                    ""id"": ""dd6abcb7-38ef-4e35-98ff-134b09def0cf"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""DoSomething"",
                    ""type"": ""Button"",
                    ""id"": ""187f98c5-37e2-4b38-96c9-11e9d56a94b4"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""HorizontalMovement"",
                    ""type"": ""PassThrough"",
                    ""id"": ""2cc0cc53-9f25-43c7-8601-11e2301cd5a7"",
                    ""expectedControlType"": ""Vector2"",
                    ""processors"": """",
                    ""interactions"": """"
                }
            ],
            ""bindings"": [
                {
                    ""name"": """",
                    ""id"": ""cb650a3f-89c4-4474-8aed-266c53592d8d"",
                    ""path"": ""<Gamepad>/buttonEast"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Dash"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""e1287bf9-8ff0-4fe1-831f-9033d481a8d7"",
                    ""path"": ""<Gamepad>/buttonSouth"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""DoSomething"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": ""2D Vector"",
                    ""id"": ""45986ceb-305c-4b2f-bc67-4d9f9443c601"",
                    ""path"": ""2DVector"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""HorizontalMovement"",
                    ""isComposite"": true,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": ""up"",
                    ""id"": ""c9f3dd6a-8892-4464-a141-832679457cbc"",
                    ""path"": ""<Keyboard>/i"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""HorizontalMovement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""down"",
                    ""id"": ""10b70d89-728e-4bae-85d5-b03855038927"",
                    ""path"": ""<Keyboard>/k"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""HorizontalMovement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""left"",
                    ""id"": ""027f564b-c25c-4f30-be20-54b9b4354201"",
                    ""path"": ""<Keyboard>/j"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""HorizontalMovement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""right"",
                    ""id"": ""d1f35be1-4631-48b9-af25-0ec1bb470b4e"",
                    ""path"": ""<Keyboard>/l"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""HorizontalMovement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                }
            ]
        }
    ],
    ""controlSchemes"": []
}");
        // Player1
        m_Player1 = asset.FindActionMap("Player1", throwIfNotFound: true);
        m_Player1_Dash = m_Player1.FindAction("Dash", throwIfNotFound: true);
        m_Player1_DoSomething = m_Player1.FindAction("DoSomething", throwIfNotFound: true);
        m_Player1_HorizontalMovement = m_Player1.FindAction("HorizontalMovement", throwIfNotFound: true);
        m_Player1_Ragdoll = m_Player1.FindAction("Ragdoll", throwIfNotFound: true);
        m_Player1_Jump = m_Player1.FindAction("Jump", throwIfNotFound: true);
        m_Player1_Respawn = m_Player1.FindAction("Respawn", throwIfNotFound: true);
        m_Player1_Interact = m_Player1.FindAction("Interact", throwIfNotFound: true);
        // Player2
        m_Player2 = asset.FindActionMap("Player2", throwIfNotFound: true);
        m_Player2_Dash = m_Player2.FindAction("Dash", throwIfNotFound: true);
        m_Player2_DoSomething = m_Player2.FindAction("DoSomething", throwIfNotFound: true);
        m_Player2_HorizontalMovement = m_Player2.FindAction("HorizontalMovement", throwIfNotFound: true);
    }

    public void Dispose()
    {
        UnityEngine.Object.Destroy(asset);
    }

    public InputBinding? bindingMask
    {
        get => asset.bindingMask;
        set => asset.bindingMask = value;
    }

    public ReadOnlyArray<InputDevice>? devices
    {
        get => asset.devices;
        set => asset.devices = value;
    }

    public ReadOnlyArray<InputControlScheme> controlSchemes => asset.controlSchemes;

    public bool Contains(InputAction action)
    {
        return asset.Contains(action);
    }

    public IEnumerator<InputAction> GetEnumerator()
    {
        return asset.GetEnumerator();
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }

    public void Enable()
    {
        asset.Enable();
    }

    public void Disable()
    {
        asset.Disable();
    }

    // Player1
    private readonly InputActionMap m_Player1;
    private IPlayer1Actions m_Player1ActionsCallbackInterface;
    private readonly InputAction m_Player1_Dash;
    private readonly InputAction m_Player1_DoSomething;
    private readonly InputAction m_Player1_HorizontalMovement;
    private readonly InputAction m_Player1_Ragdoll;
    private readonly InputAction m_Player1_Jump;
    private readonly InputAction m_Player1_Respawn;
    private readonly InputAction m_Player1_Interact;
    public struct Player1Actions
    {
        private @TestPlayerInput m_Wrapper;
        public Player1Actions(@TestPlayerInput wrapper) { m_Wrapper = wrapper; }
        public InputAction @Dash => m_Wrapper.m_Player1_Dash;
        public InputAction @DoSomething => m_Wrapper.m_Player1_DoSomething;
        public InputAction @HorizontalMovement => m_Wrapper.m_Player1_HorizontalMovement;
        public InputAction @Ragdoll => m_Wrapper.m_Player1_Ragdoll;
        public InputAction @Jump => m_Wrapper.m_Player1_Jump;
        public InputAction @Respawn => m_Wrapper.m_Player1_Respawn;
        public InputAction @Interact => m_Wrapper.m_Player1_Interact;
        public InputActionMap Get() { return m_Wrapper.m_Player1; }
        public void Enable() { Get().Enable(); }
        public void Disable() { Get().Disable(); }
        public bool enabled => Get().enabled;
        public static implicit operator InputActionMap(Player1Actions set) { return set.Get(); }
        public void SetCallbacks(IPlayer1Actions instance)
        {
            if (m_Wrapper.m_Player1ActionsCallbackInterface != null)
            {
                @Dash.started -= m_Wrapper.m_Player1ActionsCallbackInterface.OnDash;
                @Dash.performed -= m_Wrapper.m_Player1ActionsCallbackInterface.OnDash;
                @Dash.canceled -= m_Wrapper.m_Player1ActionsCallbackInterface.OnDash;
                @DoSomething.started -= m_Wrapper.m_Player1ActionsCallbackInterface.OnDoSomething;
                @DoSomething.performed -= m_Wrapper.m_Player1ActionsCallbackInterface.OnDoSomething;
                @DoSomething.canceled -= m_Wrapper.m_Player1ActionsCallbackInterface.OnDoSomething;
                @HorizontalMovement.started -= m_Wrapper.m_Player1ActionsCallbackInterface.OnHorizontalMovement;
                @HorizontalMovement.performed -= m_Wrapper.m_Player1ActionsCallbackInterface.OnHorizontalMovement;
                @HorizontalMovement.canceled -= m_Wrapper.m_Player1ActionsCallbackInterface.OnHorizontalMovement;
                @Ragdoll.started -= m_Wrapper.m_Player1ActionsCallbackInterface.OnRagdoll;
                @Ragdoll.performed -= m_Wrapper.m_Player1ActionsCallbackInterface.OnRagdoll;
                @Ragdoll.canceled -= m_Wrapper.m_Player1ActionsCallbackInterface.OnRagdoll;
                @Jump.started -= m_Wrapper.m_Player1ActionsCallbackInterface.OnJump;
                @Jump.performed -= m_Wrapper.m_Player1ActionsCallbackInterface.OnJump;
                @Jump.canceled -= m_Wrapper.m_Player1ActionsCallbackInterface.OnJump;
                @Respawn.started -= m_Wrapper.m_Player1ActionsCallbackInterface.OnRespawn;
                @Respawn.performed -= m_Wrapper.m_Player1ActionsCallbackInterface.OnRespawn;
                @Respawn.canceled -= m_Wrapper.m_Player1ActionsCallbackInterface.OnRespawn;
                @Interact.started -= m_Wrapper.m_Player1ActionsCallbackInterface.OnInteract;
                @Interact.performed -= m_Wrapper.m_Player1ActionsCallbackInterface.OnInteract;
                @Interact.canceled -= m_Wrapper.m_Player1ActionsCallbackInterface.OnInteract;
            }
            m_Wrapper.m_Player1ActionsCallbackInterface = instance;
            if (instance != null)
            {
                @Dash.started += instance.OnDash;
                @Dash.performed += instance.OnDash;
                @Dash.canceled += instance.OnDash;
                @DoSomething.started += instance.OnDoSomething;
                @DoSomething.performed += instance.OnDoSomething;
                @DoSomething.canceled += instance.OnDoSomething;
                @HorizontalMovement.started += instance.OnHorizontalMovement;
                @HorizontalMovement.performed += instance.OnHorizontalMovement;
                @HorizontalMovement.canceled += instance.OnHorizontalMovement;
                @Ragdoll.started += instance.OnRagdoll;
                @Ragdoll.performed += instance.OnRagdoll;
                @Ragdoll.canceled += instance.OnRagdoll;
                @Jump.started += instance.OnJump;
                @Jump.performed += instance.OnJump;
                @Jump.canceled += instance.OnJump;
                @Respawn.started += instance.OnRespawn;
                @Respawn.performed += instance.OnRespawn;
                @Respawn.canceled += instance.OnRespawn;
                @Interact.started += instance.OnInteract;
                @Interact.performed += instance.OnInteract;
                @Interact.canceled += instance.OnInteract;
            }
        }
    }
    public Player1Actions @Player1 => new Player1Actions(this);

    // Player2
    private readonly InputActionMap m_Player2;
    private IPlayer2Actions m_Player2ActionsCallbackInterface;
    private readonly InputAction m_Player2_Dash;
    private readonly InputAction m_Player2_DoSomething;
    private readonly InputAction m_Player2_HorizontalMovement;
    public struct Player2Actions
    {
        private @TestPlayerInput m_Wrapper;
        public Player2Actions(@TestPlayerInput wrapper) { m_Wrapper = wrapper; }
        public InputAction @Dash => m_Wrapper.m_Player2_Dash;
        public InputAction @DoSomething => m_Wrapper.m_Player2_DoSomething;
        public InputAction @HorizontalMovement => m_Wrapper.m_Player2_HorizontalMovement;
        public InputActionMap Get() { return m_Wrapper.m_Player2; }
        public void Enable() { Get().Enable(); }
        public void Disable() { Get().Disable(); }
        public bool enabled => Get().enabled;
        public static implicit operator InputActionMap(Player2Actions set) { return set.Get(); }
        public void SetCallbacks(IPlayer2Actions instance)
        {
            if (m_Wrapper.m_Player2ActionsCallbackInterface != null)
            {
                @Dash.started -= m_Wrapper.m_Player2ActionsCallbackInterface.OnDash;
                @Dash.performed -= m_Wrapper.m_Player2ActionsCallbackInterface.OnDash;
                @Dash.canceled -= m_Wrapper.m_Player2ActionsCallbackInterface.OnDash;
                @DoSomething.started -= m_Wrapper.m_Player2ActionsCallbackInterface.OnDoSomething;
                @DoSomething.performed -= m_Wrapper.m_Player2ActionsCallbackInterface.OnDoSomething;
                @DoSomething.canceled -= m_Wrapper.m_Player2ActionsCallbackInterface.OnDoSomething;
                @HorizontalMovement.started -= m_Wrapper.m_Player2ActionsCallbackInterface.OnHorizontalMovement;
                @HorizontalMovement.performed -= m_Wrapper.m_Player2ActionsCallbackInterface.OnHorizontalMovement;
                @HorizontalMovement.canceled -= m_Wrapper.m_Player2ActionsCallbackInterface.OnHorizontalMovement;
            }
            m_Wrapper.m_Player2ActionsCallbackInterface = instance;
            if (instance != null)
            {
                @Dash.started += instance.OnDash;
                @Dash.performed += instance.OnDash;
                @Dash.canceled += instance.OnDash;
                @DoSomething.started += instance.OnDoSomething;
                @DoSomething.performed += instance.OnDoSomething;
                @DoSomething.canceled += instance.OnDoSomething;
                @HorizontalMovement.started += instance.OnHorizontalMovement;
                @HorizontalMovement.performed += instance.OnHorizontalMovement;
                @HorizontalMovement.canceled += instance.OnHorizontalMovement;
            }
        }
    }
    public Player2Actions @Player2 => new Player2Actions(this);
    public interface IPlayer1Actions
    {
        void OnDash(InputAction.CallbackContext context);
        void OnDoSomething(InputAction.CallbackContext context);
        void OnHorizontalMovement(InputAction.CallbackContext context);
        void OnRagdoll(InputAction.CallbackContext context);
        void OnJump(InputAction.CallbackContext context);
        void OnRespawn(InputAction.CallbackContext context);
        void OnInteract(InputAction.CallbackContext context);
    }
    public interface IPlayer2Actions
    {
        void OnDash(InputAction.CallbackContext context);
        void OnDoSomething(InputAction.CallbackContext context);
        void OnHorizontalMovement(InputAction.CallbackContext context);
    }
}
