using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public enum NodeState
{
    Waiting,
    Executing,
    Finished
}

public class EventNodeBase : ScriptableObject
{
    protected Action<bool> OnFinished; // bool参数代表节点执行是否成功
    [HideInInspector] public NodeState state;

    public virtual void Init(Action<bool> onFinishedEvent)
    {
        OnFinished = onFinishedEvent;
        state = NodeState.Waiting;
    }

    public virtual void Execute() 
    {
        if (state != NodeState.Waiting) return;
        state = NodeState.Executing;
    } 
}
