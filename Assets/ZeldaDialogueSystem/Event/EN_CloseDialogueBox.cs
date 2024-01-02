using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

[CreateAssetMenu(fileName = "Node_", menuName = "Event/Message/Close Dialogue Box")]
public class EN_CloseDialogueBox : EventNodeBase
{
    public override void Execute()
    {
        base.Execute();
        if (!DialogueManager._instance.allowReturn)
        {
            // 没选Return的结束逻辑
            // if (SceneManager.GetActiveScene().buildIndex == 4)
            // {
            //     UIManager.DisplayFinalCG();
            // }
            // if (SceneManager.GetActiveScene().buildIndex == 3)
            // {
            //     UIManager.SetChangeSceneButton();
            // }
        }
        ZeldaUIManager.CloseDialogueBox();
        state = NodeState.Finished;

        OnFinished(true);
    }
}
