using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;


public class DialogueManager : MonoBehaviour
{
    public static DialogueManager _instance;
    public SequenceEventExecutor executor;
    public SequenceEventExecutor newExecutor;
    public bool canReturn = false;
    public bool allowReturn = false;
    public bool once = true;
    // public int a = 500;

    private void Start()
    {
        _instance = this;
        executor.Init(OnFinishedEvent);

        Debug.Log("start!");
        executor.Execute();

    }
    // Update is called once per frame
    void Update()
    {
        //canReturn && once
        //Input.GetKeyDown(KeyCode.Y)
        if (canReturn && allowReturn)
        {
            // newExecutor.Init(OnFinishedEvent2);
            // newExecutor.Execute();
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
    IEnumerator ExexutorNew()
    {
        Debug.Log(32424);
        // if (once)
        // {
            newExecutor.Init(OnFinishedEvent2);
            once = false;
        // }
        yield return new WaitForSeconds(0.5f);
        newExecutor.Execute();
        allowReturn = false;

    }

    void OnFinishedEvent(bool success)
    {
        canReturn = true;
        // newExecutor.Init(OnFinishedEvent2);
        // newExecutor.Execute();
        Debug.Log("Success!!!");
    }




    void OnFinishedEvent2(bool success)
    {
        canReturn = true;
        Debug.Log("Success222!!!");
    }
}
