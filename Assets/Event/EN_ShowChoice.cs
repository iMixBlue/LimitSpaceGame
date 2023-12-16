using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

[Serializable]
public class ChoiceData
{
    public string Content;
    public bool bQuickLocate;
    // 音效？
}

[CreateAssetMenu(fileName ="Node_",menuName ="Event/Message/Show Choices")]
public class EN_ShowChoice : EventNodeBase
{
    public int DefaultSelectIndex = 0;
    public ChoiceData[] datas;
    public SequenceEventExecutor[] executors;


    public override void Init(Action<bool> onFinishedEvent)
    {
        base.Init(onFinishedEvent);
        foreach (var item in executors)
        {
            if (null != item)
            {
                item.Init(OnFinished);
            }
        }
    }
    public override void Execute()
    {
        base.Execute();
        // 显示所有的选项
        ZeldaUIManager.CreateDialogueChocies(datas, OnChoiceConfirm, DefaultSelectIndex);
    }
    private void OnChoiceConfirm(int index)
    {
        if (index < executors.Length && null != executors[index])
        {
            executors[index].Execute();
        }
        else
        {
            OnFinished(true);
        }
    }
}
