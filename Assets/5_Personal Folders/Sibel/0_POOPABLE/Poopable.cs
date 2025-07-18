using UnityEngine;
using System.Threading.Tasks;

public class Poopable : MonoBehaviour
{
    #region Variables
    const int TEXTURE_SIZE = 1024;

    private float extendsIslandOffset = 1f;

    RenderTexture extendIslandsRenderTexture;
    RenderTexture uvIslandsRenderTexture;
    RenderTexture maskRenderTexture;
    RenderTexture supportTexture;
    
    Renderer rend;

    int maskTextureID = Shader.PropertyToID("_MaskTexture");

    public RenderTexture getMask() => maskRenderTexture;
    public RenderTexture getUVIslands() => uvIslandsRenderTexture;
    public RenderTexture getExtend() => extendIslandsRenderTexture;
    public RenderTexture getSupport() => supportTexture;
    public Renderer getRenderer() => rend;
    

    #endregion
    

    void Start()
    {
        //if (gameObject.CompareTag("Player"))
        //{
            CheckChildren();
        //}
       // SetAllTextures();
    }

    async void CheckChildren()
    {
        await Task.Delay(1000);
        Transform parent = gameObject.transform;
        foreach (Transform child in parent)
        {
            if(child == enabled)
            {
                foreach (Transform subchild in child)
                {
                    if (subchild.GetComponent<Renderer>() != null && subchild == enabled)
                    {
                        Debug.Log("found:" + subchild);
                    }

                    //Debug.Log(subchild);
                }
            }
             
        }
    }
    void OnDisable(){
        ReleaseAllTextures();
    }

    #region Texture Commands

    void SetAllTextures()
    {
        maskRenderTexture = new RenderTexture(TEXTURE_SIZE, TEXTURE_SIZE, 0);
        maskRenderTexture.filterMode = FilterMode.Bilinear;

        extendIslandsRenderTexture = new RenderTexture(TEXTURE_SIZE, TEXTURE_SIZE, 0);
        extendIslandsRenderTexture.filterMode = FilterMode.Bilinear;

        uvIslandsRenderTexture = new RenderTexture(TEXTURE_SIZE, TEXTURE_SIZE, 0);
        uvIslandsRenderTexture.filterMode = FilterMode.Bilinear;

        supportTexture = new RenderTexture(TEXTURE_SIZE, TEXTURE_SIZE, 0);
        supportTexture.filterMode =  FilterMode.Bilinear;

        //rend = GetComponent<Renderer>();
        rend.material.SetTexture(maskTextureID, extendIslandsRenderTexture);

        PoopManager.instance.initTextures(this);
    }

    void ReleaseAllTextures()
    {
        maskRenderTexture.Release();
        uvIslandsRenderTexture.Release();
        extendIslandsRenderTexture.Release();
        supportTexture.Release();
    }

    #endregion
    
}
