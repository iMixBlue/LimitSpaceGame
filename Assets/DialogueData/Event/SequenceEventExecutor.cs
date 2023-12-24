using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

[CreateAssetMenu(fileName = "Executor_",menuName ="Event/Sequence Executor")]
public class SequenceEventExecutor : ScriptableObject
{
    public Action<bool> OnFinished; // bool参数代表执行器执行是否成功

    private int _index;
    public EventNodeBase[] nodes;

    public void Init(Action<bool> onFinishedEvent)
    {
        _index = 0;

        foreach (EventNodeBase item in nodes)
        {
            if (null != item)
            {
                item.Init(OnNodeFinished);
            }
        }

        OnFinished = onFinishedEvent;
    }

    private void OnNodeFinished(bool success)
    {
        if (success)
        {
            ExecuteNextNode();
        }
        else
        {
            OnFinished(false);
        }
    }

    private void ExecuteNextNode()
    {
        if (_index < nodes.Length)
        {
            if (nodes[_index].state == NodeState.Waiting)
            {
                _index++; // _index = 4
                nodes[_index - 1].Execute(); //关闭对话框节点
            }
        }
        else
        {
            OnFinished(true);
        }
    }

    public void Execute()
    {
        foreach (var node in nodes)
        {
            node.state = NodeState.Waiting;
        }
        _index = 0;
        ExecuteNextNode();
    }
}
