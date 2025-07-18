
using UnityEngine;
[CreateAssetMenu(fileName = "Hat Data", menuName = "ScriptableObjects/HatDataScriptableObject")]
public class HatChangerData : ScriptableObject
{
    public string hatName;
    public Mesh hatMesh;
    public Sprite hatSprite;
}
