using UnityEngine;

public class UpdateShaderScreenSize : MonoBehaviour
{
    public Material material;

    void Update()
    {
        if (material != null)
        {
            material.SetVector("_ScreenSize", new Vector4(Screen.width, Screen.height, 0, 0));
            material.SetFloat("_TimeValue", Time.time);
        }
    }
}
