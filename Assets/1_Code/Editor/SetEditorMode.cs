#if UNITY_EDITOR
using UnityEngine;
using UnityEditor;


[CustomEditor(typeof(EditorStateSetter))]
public class SetEditorMode : Editor
{
    public override void OnInspectorGUI()
    {
        

        EditorStateSetter setter = (EditorStateSetter)target;
        GUILayout.Space(10f);
        if (GUILayout.Button("Set Editor to Test State", GUILayout.Height(50), GUILayout.Width(200)))
        {
            setter.SetPlaytestState();
        }
        GUILayout.Space(10f);
        if (GUILayout.Button("Reset to Player Select State", GUILayout.Height(50), GUILayout.Width(200)))
        {
            setter.SetPlayerselectState();
        }

        GUILayout.Space(50f);
        DrawDefaultInspector();
    }
}

#endif
