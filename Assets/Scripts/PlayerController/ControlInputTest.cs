// GENERATED AUTOMATICALLY FROM 'Assets/Scripts/PlayerController/ControlInputTest.inputactions'

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.Utilities;

public class @ControlInputTest : IInputActionCollection, IDisposable
{
    public InputActionAsset asset { get; }
    public @ControlInputTest()
    {
        asset = InputActionAsset.FromJson(@"{
    ""name"": ""ControlInputTest"",
    ""maps"": [
        {
            ""name"": ""p1"",
            ""id"": ""a476f976-fef2-4cae-8d7c-3c41b9c42ff2"",
            ""actions"": [
                {
                    ""name"": ""New action"",
                    ""type"": ""Button"",
                    ""id"": ""a9140013-203b-4ae2-8bc6-b800faab6e8e"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                }
            ],
            ""bindings"": [
                {
                    ""name"": """",
                    ""id"": ""a6a176bb-fe1e-47a0-b2fb-c189de1f97dd"",
                    ""path"": ""<Keyboard>/w"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""New action"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                }
            ]
        }
    ],
    ""controlSchemes"": []
}");
        // p1
        m_p1 = asset.FindActionMap("p1", throwIfNotFound: true);
        m_p1_Newaction = m_p1.FindAction("New action", throwIfNotFound: true);
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

    // p1
    private readonly InputActionMap m_p1;
    private IP1Actions m_P1ActionsCallbackInterface;
    private readonly InputAction m_p1_Newaction;
    public struct P1Actions
    {
        private @ControlInputTest m_Wrapper;
        public P1Actions(@ControlInputTest wrapper) { m_Wrapper = wrapper; }
        public InputAction @Newaction => m_Wrapper.m_p1_Newaction;
        public InputActionMap Get() { return m_Wrapper.m_p1; }
        public void Enable() { Get().Enable(); }
        public void Disable() { Get().Disable(); }
        public bool enabled => Get().enabled;
        public static implicit operator InputActionMap(P1Actions set) { return set.Get(); }
        public void SetCallbacks(IP1Actions instance)
        {
            if (m_Wrapper.m_P1ActionsCallbackInterface != null)
            {
                @Newaction.started -= m_Wrapper.m_P1ActionsCallbackInterface.OnNewaction;
                @Newaction.performed -= m_Wrapper.m_P1ActionsCallbackInterface.OnNewaction;
                @Newaction.canceled -= m_Wrapper.m_P1ActionsCallbackInterface.OnNewaction;
            }
            m_Wrapper.m_P1ActionsCallbackInterface = instance;
            if (instance != null)
            {
                @Newaction.started += instance.OnNewaction;
                @Newaction.performed += instance.OnNewaction;
                @Newaction.canceled += instance.OnNewaction;
            }
        }
    }
    public P1Actions @p1 => new P1Actions(this);
    public interface IP1Actions
    {
        void OnNewaction(InputAction.CallbackContext context);
    }
}
