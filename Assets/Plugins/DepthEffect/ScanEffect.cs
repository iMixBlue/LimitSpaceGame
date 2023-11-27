using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

[ExecuteInEditMode]
public class ScanEffect : MonoBehaviour
{

    public Material ScanMat;

    public float ScanSpeed = 20;

    private float scanTimer = 0;

    private Camera scanCam;
    private bool beginScan ;
    float scanStart = 0f;

    // Start is called before the first frame update
    void Awake()
    {
        scanCam = GetComponent<Camera>();
        //scanCam.depthTextureMode = DepthTextureMode.Depth;

    }
    private void Start()
    {
        scanTimer = 0;
        ScanMat.SetFloat("_ScanDepth", scanTimer);
        beginScan = false;
    }

    private void Update()
    {
        if (Keyboard.current.fKey.wasPressedThisFrame)
        {
            // Debug.Log(1);
            scanTimer = 0;
            beginScan = true;
        }
        if (beginScan)
        {
            scanTimer += Time.deltaTime * ScanSpeed;
            ScanMat.SetFloat("_ScanDepth", scanTimer);
        }
        

    }
    private void FixedUpdate()
    {
        if (beginScan)
        {
            scanStart++;
            if (scanStart > 250)
            {
                scanStart = 0;
                ScanMat.SetFloat("_ScanDepth", 0);
                beginScan = false;
            }
        }
    }

    //private void OnRenderImage(RenderTexture source, RenderTexture destination)
    //{
    //    ScanMat.SetFloat("_CamFar", GetComponent<Camera>().farClipPlane);
    //    Graphics.Blit(source, destination, ScanMat);
    //}




}
