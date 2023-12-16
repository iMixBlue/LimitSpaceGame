using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using System;

public class ZeldaUIManager : MonoBehaviour
{
    private static ZeldaUIManager _instance;
    private void Awake()
    {
        if (_instance != null)
        {
            Destroy(gameObject);
            return;
        }
        _instance = this;
        _instance._pfbButtonA = Resources.Load<GameObject>("UI/Button/ButtonA");
        HideCursorA();
        DontDestroyOnLoad(gameObject);
    }

    private Selectable _currentSelectable;
    public static void SetCurrentSelectable(Selectable obj)
    {
        _instance._currentSelectable = obj;
    }
    private void Update()
    {
        if (EventSystem.current.currentSelectedGameObject == null)
        {
            if (null != _instance._currentSelectable)
            {
                _instance._currentSelectable.Select();
            }
        }
    }

    [SerializeField] private DialogueBox _dialogueBox;
    public static void OpenDialogueBox(Action<bool> onNextEvent, int boxStyle = 0)
    {
        _instance._dialogueBox.Open(onNextEvent, boxStyle);
    }
    public static void CloseDialogueBox()
    {
        _instance._dialogueBox.Close(null);

        
    }
    public static void PrintDialogue(DialogueData data)
    {
        _instance._dialogueBox.StartCoroutine(_instance._dialogueBox.PrintDialogue(
            data.Content,
            data.Speaker,
            data.NeedTyping,
            data.AutoNext,
            data.CanQuickShow
            ));
    }

    [SerializeField] private RectTransform _cursorA;
    private static readonly int Click = Animator.StringToHash("Click");
    public static void UpdateCursorA(Vector3 position)
    {
        if (!_instance._cursorA.gameObject.activeSelf)
        {
            _instance._cursorA.gameObject.SetActive(true);
        }
        _instance._cursorA.position = position;
    }
    public static void ClickCursorA()
    {
        _instance._cursorA.GetComponentInChildren<Animator>().SetTrigger(Click);
    }
    public static void HideCursorA()
    {
        _instance._cursorA.gameObject.SetActive(false);
    }

    private GameObject _pfbButtonA;
    [SerializeField] private ChoicePanel _choicePanel;
    public static void CreateDialogueChocies(ChoiceData[] datas, Action<int> onConfirmEvent, int defaultSelectIndex)
    {
        for (int i = 0; i < datas.Length; i++)
        {
            AdvancedButtonA button = Instantiate(_instance._pfbButtonA).GetComponent<AdvancedButtonA>();
            button.gameObject.name = "ButtonA" + i;
            button.Init(datas[i].Content, i, onConfirmEvent);
            _instance._choicePanel.AddButton(button);
        }
        _instance._choicePanel.Open(defaultSelectIndex);
    }
}
