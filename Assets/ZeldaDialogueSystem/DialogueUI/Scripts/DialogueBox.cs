using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System;

public class DialogueBox : MonoBehaviour
{
    [Header("Components")]
    [SerializeField] private Image _background;
    [SerializeField] private Widget _widget;
    [SerializeField] private TextMeshProUGUI _speaker;
    [SerializeField] private AdvancedText _content;
    [SerializeField] private Widget _nextCursorWidget;
    [SerializeField] private Animator _nextCursorAnimator;
    private static readonly int _click = Animator.StringToHash("Click");

    [Header("Configs")]
    [SerializeField] private Sprite[] _backgroundStyles;

    public bool _interactable;
    private bool _printFinished;
    private bool _canQuickShow;
    private bool _autoNext;

    private bool CanQuickShow => !_printFinished && _canQuickShow;
    private bool CanNext => _printFinished;

    public Action<bool> OnNext; // bool参数代表下一句话是否强制直接显示
    // public SequenceEventExecutor executor;

    private void Awake()
    {
        _content.OnFinished = PrintFinished;
    }
    private void Start() {
        // Debug.Log(1);
        // gameObject.SetActive(true);
        // _content.OnFinished = PrintFinished;
        // executor.Init(OnFinishedEvent);
        // executor.Execute();
    }
    void OnFinishedEvent(bool success)
    {
        // playerCharacter.SetInputEnabled(true);
    }
    private void PrintFinished()
    {
        if (_autoNext)
        {
            _interactable = false;
            OnNext(false);
        }
        else
        {
            _interactable = true;
            _printFinished = true;
            _nextCursorWidget.Fade(1, 0.2f, null);
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (_interactable) UpdateInput();
    }

    private void UpdateInput()
    {

        if (Input.GetButtonDown("Cancel") || Input.GetMouseButtonDown(1))
        {
            if (CanQuickShow)
            {
                _content.QuickShowRemaining();
                PrintFinished();
            }
            else if (CanNext)
            {
                _interactable = false;
                _nextCursorAnimator.SetTrigger(_click);
                _nextCursorWidget.Fade(0, 0.5f, null);
                OnNext(true);
            }
        }
        else if (Input.GetButtonDown("Submit") ||Input.GetMouseButtonDown(0))
        {
            if (CanNext)
            {
                _interactable = false;
                _nextCursorAnimator.SetTrigger(_click);
                _nextCursorWidget.Fade(0, 0.5f, null);
                OnNext(false);
            }
        }
    }

    public void Open(Action<bool> nextEvent, int boxStyle = 0)
    {
        OnNext = nextEvent;
        _background.sprite = _backgroundStyles[boxStyle];

        if (!gameObject.activeSelf)
        {
            gameObject.SetActive(true);
            _widget.RenderOpacity = 0;
            _widget.Fade(1, 0.2f, null);
            _speaker.SetText("");
            _content.Initialise();
        }

        _nextCursorWidget.RenderOpacity = 0;
        OnNext(false);
    }
    public void Close(Action onClosed)
    {
        _widget.Fade(0, 0.4f, () =>
        {
            gameObject.SetActive(false);
            onClosed?.Invoke();
        });
    }

    public IEnumerator PrintDialogue(string content, string speaker, bool needTyping = true,
        bool autoNext = false, bool canQuickShow = true)
    {
        _interactable = false;
        _printFinished = false;

        if (_content.text != "")
        {
            _content.Disappear();
            yield return new WaitForSecondsRealtime(0.3f);
        }

        _canQuickShow = canQuickShow;
        _autoNext = autoNext;
        _speaker.SetText(speaker);

        if (needTyping)
        {
            _interactable = true;
            _content.StartCoroutine(_content.SetText(content, AdvancedText.DisplayType.Typing));
        }
        else
        {
            _content.StartCoroutine(_content.SetText(content, AdvancedText.DisplayType.Fading));
        }
    }
}
