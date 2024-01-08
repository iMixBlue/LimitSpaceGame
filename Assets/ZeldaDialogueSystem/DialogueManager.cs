using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityStandardAssets.Characters.ThirdPerson;
using StarterAssets;
using UnityEngine.UI;


public class DialogueManager : MonoBehaviour
{
    public GameObject finalThanksCG;
    public AudioSource audioSource;
    public Slider slider;
    public static DialogueManager _instance;
    public SequenceEventExecutor executor;
    public SequenceEventExecutor returnnableExecutor;

    public SequenceEventExecutor executor2;
    public SequenceEventExecutor executor3;
    public SequenceEventExecutor executor4;
    public SequenceEventExecutor executor5;
    public SequenceEventExecutor executor6;
    public SequenceEventExecutor executor7;
    public SequenceEventExecutor executor8;
    public SequenceEventExecutor executor9;
    public SequenceEventExecutor executor10;
    public SequenceEventExecutor executor11;
    public SequenceEventExecutor executor12;
    public bool canReturn = false;
    public bool allowReturn = false;
    public bool once = true;
    public bool executeOnce = true;
    public bool canDisplaySeq10 = false;
    public GameObject player;
    //Here are the GameObjects getting bool to trigger the dialogue box
    public GameObject CeilingLightMain;
    public GameObject executeSeq4Obj;
    public GameObject executeSeq5Obj;
    public GameObject RetrieveDialogueObj;
    public GameObject RetrieveDialogueObjForFirstCoin;
    public GameObject RetrieveDialogueObjForSecondCoin;
    public GameObject ExecuteSeq8Obj;
    public GameObject ExecuteSeq9Obj;
    public GameObject ExecuteSeq11Obj;
    public GameObject ExecuteSeq12Obj;
    [SerializeField] GameObject _portalObstacle;
    // public int a = 500;

    private void Start()
    {
        player.GetComponent<ThirdPersonController>().enabled = false;
        _instance = this;
        executor.Init(OnFinishedEvent);
        executor.Execute();
    }
    public void SetBgmVolume(){
        audioSource.volume = slider.value;
    }
    public void SetCanDisplaySeq10()
    {
        canDisplaySeq10 = true;
    }
    // Update is called once per frame
    void Update()
    {
        if (RetrieveDialogueObj.GetComponent<RetrieveDialogue>().canDiaplayDialogue)
        {
            if (executeOnce)
            {
                StartCoroutine(ExexutorExecutor(executor2, OnFinishedEvent2));
                RetrieveDialogueObj.GetComponent<RetrieveDialogue>().canDiaplayDialogue = false;
            }
        }
        // if (CeilingLightMain.GetComponent<CeilingLight>().inCeiling2)
        // {
        //     if (executeOnce)
        //     {
        //         StartCoroutine(ExexutorExecutor(executor3, OnFinishedEvent3));
        //         CeilingLightMain.GetComponent<CeilingLight>().inCeiling2 = false;
        //     }
        // }
        if (executeSeq4Obj.GetComponent<ExecuteSeq4>().inExecuteSeq4Area)
        {
            if (executeOnce)
            {
                StartCoroutine(ExexutorExecutor(executor4, OnFinishedEvent4));
                executeSeq4Obj.GetComponent<ExecuteSeq4>().inExecuteSeq4Area = false;
            }
        }
        if (executeSeq5Obj.GetComponent<ExecuteSeq5>().outExecuteSeq5Area)
        {
            if (executeOnce)
            {
                StartCoroutine(ExexutorExecutor(executor5, OnFinishedEvent5));
                executeSeq5Obj.GetComponent<ExecuteSeq5>().outExecuteSeq5Area = false;
            }
        }
        if (RetrieveDialogueObjForFirstCoin.GetComponent<RetrieveDialogue>().canDisplayDialogueForFirstCoin)
        {
            if (executeOnce)
            {
                StartCoroutine(ExexutorExecutor(executor6, OnFinishedEvent6));
                RetrieveDialogueObjForFirstCoin.GetComponent<RetrieveDialogue>().canDisplayDialogueForFirstCoin = false;
            }
        }
        if (RetrieveDialogueObjForSecondCoin.GetComponent<RetrieveDialogue>().canDisplayDialogueForSecondCoin)
        {
            if (executeOnce)
            {
                StartCoroutine(ExexutorExecutor(executor7, OnFinishedEvent7));
                RetrieveDialogueObjForSecondCoin.GetComponent<RetrieveDialogue>().canDisplayDialogueForSecondCoin = false;
            }
        }
        if (ExecuteSeq8Obj.GetComponent<ExeSeq8>().inExecuteSeq8Area)
        {
            if (executeOnce)
            {
                StartCoroutine(ExexutorExecutor(executor8, OnFinishedEvent8));
                ExecuteSeq8Obj.GetComponent<ExeSeq8>().inExecuteSeq8Area = false;
            }
        }
        if (ExecuteSeq9Obj.GetComponent<Tiny1Controller>().canDisplaySeq9)
        {
            if (executeOnce)
            {
                StartCoroutine(ExexutorExecutor(executor9, OnFinishedEvent9));
                ExecuteSeq9Obj.GetComponent<Tiny1Controller>().canDisplaySeq9 = false;
            }
        }
        if (canDisplaySeq10)
        {
            if (executeOnce)
            {
                StartCoroutine(ExexutorExecutor(executor10, OnFinishedEvent10));
                canDisplaySeq10 = false;
            }
        }
        if (ExecuteSeq11Obj.GetComponent<ExeSeq11>().inExecuteSeq11Area)
        {
            if (executeOnce)
            {
                StartCoroutine(ExexutorExecutor(executor11, OnFinishedEvent11));
                ExecuteSeq11Obj.GetComponent<ExeSeq11>().inExecuteSeq11Area = false;
            }
        }
        if (ExecuteSeq12Obj.GetComponent<ExeSeq12>().outExecuteSeq12Area)
        {
            if (executeOnce)
            {
                StartCoroutine(ExexutorExecutor(executor12, OnFinishedEvent12));
                ExecuteSeq12Obj.GetComponent<ExeSeq12>().outExecuteSeq12Area = false;
            }
        }
        //canReturn && once
        //Input.GetKeyDown(KeyCode.Y)
        // if (canReturn && allowReturn)
        // {
        //     // returnnableExecutor.Init(OnFinishedEvent2);
        //     // returnnableExecutor.Execute();
        //     StartCoroutine(ExexutorNew());
        //     canReturn = false;
        //     // a --;
        //     // Debug.Log(33333);    
        // }
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
            player.GetComponent<ThirdPersonController>().enabled = false;
            executeOnce = false;
            exe.Init(onFE);
            yield return new WaitForSeconds(0.25f);
            exe.Execute();
        }
    }
    // IEnumerator ExexutorNew()
    // {
    //     Debug.Log(32424);
    //     // if (once)
    //     // {
    //     returnnableExecutor.Init(OnFinishedEvent2);
    //     once = false;
    //     // }
    //     yield return new WaitForSeconds(0.5f);
    //     returnnableExecutor.Execute();
    //     allowReturn = false;

    // }

    void OnFinishedEvent(bool success)
    {
        // canReturn = true;
        executeOnce = true;
        player.GetComponent<ThirdPersonController>().enabled = true;
    }
    void OnFinishedEvent2(bool success)
    {
        Debug.Log(12345);
        player.GetComponent<ThirdPersonController>().enabled = true;
        Destroy(RetrieveDialogueObj.GetComponent<BoxCollider>());
        executeOnce = true;
    }
    void OnFinishedEvent3(bool success)
    {
        // player.GetComponent<ThirdPersonController>().enabled = true;
        executeOnce = true;
        Destroy(CeilingLightMain.GetComponent<BoxCollider>());
    }
    void OnFinishedEvent4(bool success)
    {
        player.GetComponent<ThirdPersonController>().enabled = true;
        executeOnce = true;
        Destroy(executeSeq4Obj.GetComponent<BoxCollider>());
    }
    void OnFinishedEvent5(bool success)
    {
        player.GetComponent<ThirdPersonController>().enabled = true;
        executeOnce = true;
        Destroy(executeSeq5Obj.GetComponent<BoxCollider>());
    }
    void OnFinishedEvent6(bool success)
    {
        player.GetComponent<ThirdPersonController>().enabled = true;
        executeOnce = true;
        Destroy(RetrieveDialogueObjForFirstCoin.GetComponent<BoxCollider>());
    }
    void OnFinishedEvent7(bool success)
    {
        player.GetComponent<ThirdPersonController>().enabled = true;
        executeOnce = true;
        Destroy(RetrieveDialogueObjForSecondCoin.GetComponent<BoxCollider>());
    }
    void OnFinishedEvent8(bool success)
    {
        player.GetComponent<ThirdPersonController>().enabled = true;
        executeOnce = true;
        Destroy(ExecuteSeq8Obj.GetComponent<BoxCollider>());
    }
    void OnFinishedEvent9(bool success)
    {
        player.GetComponent<ThirdPersonController>().enabled = true;
        executeOnce = true;
        Destroy(ExecuteSeq9Obj.GetComponent<BoxCollider>());
    }
    void OnFinishedEvent10(bool success)
    {
        player.GetComponent<ThirdPersonController>().enabled = true;
        executeOnce = true;
    }
    void OnFinishedEvent11(bool success)
    {
        player.GetComponent<ThirdPersonController>().enabled = true;
        executeOnce = true;
        Destroy(ExecuteSeq11Obj.GetComponent<BoxCollider>());
    }
    void OnFinishedEvent12(bool success)
    {
        player.GetComponent<ThirdPersonController>().enabled = true;
        executeOnce = true;
        Destroy(ExecuteSeq12Obj.GetComponent<BoxCollider>());
        try
        {
            if (finalThanksCG != null)
            {
                finalThanksCG.SetActive(true);
            }
            _portalObstacle.SetActive(false);
        }
        catch { }

    }
}
