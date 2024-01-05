using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;


public class DialogueManager : MonoBehaviour
{
    public static DialogueManager _instance;
    public SequenceEventExecutor executor;
    public SequenceEventExecutor returnnableExecutor;

    public SequenceEventExecutor executor2;
    public SequenceEventExecutor executor3;
    public SequenceEventExecutor executor4;
    public SequenceEventExecutor executor5;
    public bool canReturn = false;
    public bool allowReturn = false;
    public bool once = true;
    public bool executeOnce = true;
    //Here are the GameObjects getting bool to trigger the dialogue box
    public GameObject CeilingLightMain;
    public GameObject executeSeq4Obj;
    public GameObject executeSeq5Obj;
    // public int a = 500;

    private void Start()
    {
        _instance = this;
        executor.Init(OnFinishedEvent);

        Debug.Log("start!");
        executor.Execute();

        // executor3.Init(OnFinishedEvent3);
    }
    // Update is called once per frame
    void Update()
    {
        if (CeilingLightMain.GetComponent<CeilingLight>().inCeiling)
        {
            if (executeOnce)
            {
                StartCoroutine(ExexutorExecutor(executor3, OnFinishedEvent3));
            }
        }
        if(executeSeq4Obj.GetComponent<ExecuteSeq4>().inExecuteSeq4Area){
            if (executeOnce)
            {
                StartCoroutine(ExexutorExecutor(executor4, OnFinishedEvent4));
            }
        }
        if(executeSeq5Obj.GetComponent<ExecuteSeq5>().outExecuteSeq5Area){
            if (executeOnce)
            {
                StartCoroutine(ExexutorExecutor(executor5, OnFinishedEvent5));
            }
        }
        //canReturn && once
        //Input.GetKeyDown(KeyCode.Y)
        if (canReturn && allowReturn)
        {
            // returnnableExecutor.Init(OnFinishedEvent2);
            // returnnableExecutor.Execute();
            StartCoroutine(ExexutorNew());
            canReturn = false;
            // a --;
            // Debug.Log(33333);    
        }
    }
    public static IEnumerator WaitForSeconds(float duration, Action action)
    {
        yield return new WaitForSeconds(duration);
        action?.Invoke();
    }
    IEnumerator ExexutorExecutor(SequenceEventExecutor exe, Action<bool> onFE)
    {
        Debug.Log(89775);
        if (executeOnce)
        {
            executeOnce = false;
            exe.Init(onFE);
            yield return new WaitForSeconds(0.25f);
            exe.Execute();
        }


    }
    IEnumerator ExexutorNew()
    {
        Debug.Log(32424);
        // if (once)
        // {
        returnnableExecutor.Init(OnFinishedEvent2);
        once = false;
        // }
        yield return new WaitForSeconds(0.5f);
        returnnableExecutor.Execute();
        allowReturn = false;

    }

    void OnFinishedEvent(bool success)
    {
        canReturn = true;
        executeOnce = true;
    }
    void OnFinishedEvent2(bool success)
    {
        executeOnce = true;
    }
    void OnFinishedEvent3(bool success)
    {
        executeOnce = true;
    }
     void OnFinishedEvent4(bool success)
    {
        executeOnce = true;
    }
     void OnFinishedEvent5(bool success)
    {
        executeOnce = true;
    }
    
}
