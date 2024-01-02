using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

[Serializable]
public class DialogueData
{
    public string Speaker;
    [Multiline] public string Content;
    public bool AutoNext;
    public bool NeedTyping;
    public bool CanQuickShow;

}

[CreateAssetMenu(fileName = "Node_",menuName ="Event/Message/Show Dialogue")]
public class EN_ShowDialogue : EventNodeBase
{
    public DialogueData[] datas;
    public int boxStyle = 0;
    private int _index;

    public override void Execute()
    {
        base.Execute();
        _index = 0;

        ZeldaUIManager.OpenDialogueBox(ShowNextDialogue, boxStyle);
    }

    private void ShowNextDialogue(bool forceDiplayDirectly)
    {
        if (_index < datas.Length)
        {
            DialogueData data = new DialogueData()
            {
                Speaker = datas[_index].Speaker,
                Content = datas[_index].Content,
                CanQuickShow = datas[_index].CanQuickShow,
                AutoNext = datas[_index].AutoNext,
                NeedTyping = !forceDiplayDirectly && datas[_index].NeedTyping
            };
            ZeldaUIManager.PrintDialogue(data);
            _index++;
        }
        else
        {
            state = NodeState.Finished;
            OnFinished(true);
        }
    }
}
