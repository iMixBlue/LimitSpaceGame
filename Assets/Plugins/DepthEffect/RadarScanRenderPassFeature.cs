using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class RadarScanRenderPassFeature : ScriptableRendererFeature
{
    //RenderPass由URP自带RenderObjects深度精简而来，去除了所有开放参数改为定值。
    //屏蔽了TransparentFX层，将透明/半透明/顶点偏移物体加入该层屏蔽，不覆盖扫描材质。
    class RadarScanRenderPass : ScriptableRenderPass
    {
        public Material material;

        DrawingSettings drawingSettings;
        FilteringSettings m_FilteringSettings;
        RenderStateBlock m_RenderStateBlock;
        public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
        {
            List<ShaderTagId> m_ShaderTagIdList = new List<ShaderTagId>();
            m_ShaderTagIdList.Add(new ShaderTagId("UniversalForward"));

            drawingSettings = CreateDrawingSettings(m_ShaderTagIdList, ref renderingData, SortingCriteria.CommonOpaque);
            drawingSettings.overrideMaterial = material;
            drawingSettings.overrideMaterialPassIndex = 0;

            m_FilteringSettings = new FilteringSettings(RenderQueueRange.opaque, ~(1 << 1));

            m_RenderStateBlock = new RenderStateBlock(RenderStateMask.Nothing);
        }

        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            context.DrawRenderers(renderingData.cullResults, ref drawingSettings, ref m_FilteringSettings, ref m_RenderStateBlock);
        }
        public override void OnCameraCleanup(CommandBuffer cmd)
        {
        }
    }

    RadarScanRenderPass m_ScriptablePass;

    public static RadarScanRenderPassFeature instance;

    public Material material = null;

    float startTime = 0;
    float duration = 0;

    public override void Create()
    {
        instance = this;
        startTime = 0;
        duration = 0;
        m_ScriptablePass = new RadarScanRenderPass();
        m_ScriptablePass.material = material;
        m_ScriptablePass.renderPassEvent = RenderPassEvent.AfterRenderingTransparents;
    }
    private void OnDestroy()
    {
        startTime = 0;
        duration = 0;
    }
    //触发时将中心点/持续时间/开始时间传入，其他参数在材质中修改
    public void Scan(Vector3 _center, float _duration = 500f)
    {
        startTime = Time.time;
        duration = _duration;
        // material.SetVector("_Center", _center);
        // material.SetFloat("_StartTime", startTime);
        // material.SetFloat("_Duration", duration);
    }
    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        //只有触发后的一定持续时间内,才启用RenderPass
        if ((startTime + duration) > Time.time)
            renderer.EnqueuePass(m_ScriptablePass);
    }
    
}