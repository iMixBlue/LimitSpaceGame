using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PortalTextureSetup : MonoBehaviour
{
    public Camera cameraA;
    public Camera cameraB;
    public Material cameraAMat;
    public Material cameraBMat;

    void Start()
    {
        if (cameraA.targetTexture != null)
        {
            cameraA.targetTexture.Release();
        }
        cameraA.targetTexture = new RenderTexture(Screen.width, Screen.height, 24);
        cameraAMat.mainTexture = cameraA.targetTexture;

        if ( cameraB.targetTexture != null )
        {
            cameraB.targetTexture.Release();
        }
        cameraB.targetTexture = new RenderTexture(Screen.width, Screen.height, 24);
        cameraBMat.mainTexture = cameraB.targetTexture;
    }
    
}
