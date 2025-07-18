
using UnityEngine;

[CreateAssetMenu(fileName = "Player Data", menuName = "ScriptableObjects/PlayerDataScriptableObject")]
public class PlayerData : ScriptableObject
{
    public string playerName;

    public Sprite playerPortrait;
    public Sprite playerHatSprite;
    public GameObject playerModel;
    public GameObject playerInflatedModel;
    public Mesh hat;
    public Material playerMat;

    public int points;

}
