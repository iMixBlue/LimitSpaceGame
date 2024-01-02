using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using TMPro;
using UnityEngine;
using System;

public class RubyData
{
    public RubyData(int startIndex, string content)
    {
        StartIndex = startIndex;
        RubyContent = content;
        EndIndex = StartIndex;
    }
    public int StartIndex { get; }
    public int EndIndex { get; set; }
    public string RubyContent { get; }
}
public class AdvancedTextPreprocessor : ITextPreprocessor
{
    public Dictionary<int, float> IntervalDictionary;
    public List<RubyData> RubyList;

    public bool TryGetRubyStartFrom(int index, out RubyData data)
    {
        data = new RubyData(0, "");
        foreach (var item in RubyList)
        {
            if (item.StartIndex == index)
            {
                data = item;
                return true;
            }
        }

        return false;
    }
    public AdvancedTextPreprocessor()
    {
        IntervalDictionary = new Dictionary<int, float>();
        RubyList = new List<RubyData>();
    }
    public string PreprocessText(string text)
    {
        IntervalDictionary.Clear();
        RubyList.Clear();

        string processingText = text;
        string pattern = "<.*?>";
        Match match = Regex.Match(processingText, pattern);
        while (match.Success)
        {
            string label = match.Value.Substring(1, match.Length - 2);

            if (float.TryParse(label, out float result))
            {
                IntervalDictionary[match.Index - 1] = result;
            }
            else if (Regex.IsMatch(label, "^r=.+"))
            {
                RubyList.Add(new RubyData(match.Index, label.Substring(2)));
            }
            else if (label == "/r")
            {
                if (RubyList.Count > 0)
                {
                    RubyList[RubyList.Count - 1].EndIndex = match.Index - 1;
                }
            }

            processingText = processingText.Remove(match.Index, match.Length);
            
            if (Regex.IsMatch(label, "^sprite=.+"))
            {
                processingText = processingText.Insert(match.Index, "*");
            }

            match = Regex.Match(processingText, pattern);
        }

        processingText = text;
        // .    代表任意字符！！！
        // *    代表前一个字符出现零次或多次
        // +    代表前一个字符出现一次或多次
        // ?    代表前一个字符出现零次或一次
        pattern = @"(<(\d+)(\.\d+)?>)|(</r>)|(<r=.*?>)";
        processingText = Regex.Replace(processingText, pattern, "");
        return processingText;
    }
}

[RequireComponent(typeof(Widget))]
public class AdvancedText : TextMeshProUGUI
{
    public enum DisplayType
    {
        Default,
        Fading,
        Typing
    }

    private Widget _widget;

    protected override void Awake()
    {
        base.Awake();
        _widget = GetComponent<Widget>();
    }

    public AdvancedText()
    {
        textPreprocessor = new AdvancedTextPreprocessor();
    }

    private AdvancedTextPreprocessor SelfPreprocessor => (AdvancedTextPreprocessor) textPreprocessor;

    public Action OnFinished;
    private Coroutine _typingCoroutine;
    private int _typingIndex;
    private float _defaultInterval = 0.06f;

    public void Initialise()
    {
        SetText("");
        ClearRubyText();
    }
    public void Disappear(float duration = 0.2f)
    {
        _widget.Fade(0, duration, null);
    }

    private void SetRubyText(RubyData data)
    {
        GameObject pfb = Resources.Load<GameObject>("RubyText");
        GameObject ruby = Instantiate(pfb, transform);
        ruby.GetComponent<TextMeshProUGUI>().SetText(data.RubyContent);
        ruby.GetComponent<TextMeshProUGUI>().color = textInfo.characterInfo[data.StartIndex].color;
        ruby.transform.localPosition = (textInfo.characterInfo[data.StartIndex].topLeft +
                                        textInfo.characterInfo[data.EndIndex].topRight) / 2;
    }
    private void SetAllRubyText()
    {
        foreach (var item in SelfPreprocessor.RubyList)
        {
            SetRubyText(item);
        }
    }
    private void ClearRubyText()
    {
        foreach (var item in GetComponentsInChildren<TextMeshProUGUI>())
        {
            if (item != this)
            {
                Destroy(item.gameObject);
            }
        }
    }

    public void QuickShowRemaining()
    {
        if (_typingCoroutine != null)
        {
            StopCoroutine(_typingCoroutine);

            for (; _typingIndex < m_characterCount; _typingIndex++)
            {
                StartCoroutine(FadeInCharacter(_typingIndex));                
            }
        }
    }
    
    public IEnumerator SetText(string content, DisplayType type, float fadingDuration = 0.2f)
    {
        if (_typingCoroutine != null) 
        {
            StopCoroutine(_typingCoroutine);
        }
        ClearRubyText();
        SetText(content);
        yield return null;

        switch (type)
        {
            case DisplayType.Default:
                _widget.RenderOpacity = 1;
                SetAllRubyText();
                OnFinished?.Invoke();
                break;
            case DisplayType.Fading:
                _widget.Fade(1, fadingDuration, OnFinished.Invoke);
                SetAllRubyText();
                break;
            case DisplayType.Typing:
                _widget.Fade(1, fadingDuration, null);
                _typingCoroutine = StartCoroutine(Typing());
                break;
            default:
                break;
        }
    }

    IEnumerator Typing()
    {
        ForceMeshUpdate();
        for (int i = 0; i < m_characterCount; i++)
        {
            SetSingleCharacterAlpha(i,0);
        }

        _typingIndex = 0;
      
        while (_typingIndex < m_characterCount)
        {
            StartCoroutine(FadeInCharacter(_typingIndex));
            
            if (SelfPreprocessor.IntervalDictionary.TryGetValue(_typingIndex, out float result))
            {
                yield return new WaitForSecondsRealtime(result);
            }
            else
            {
                yield return new WaitForSecondsRealtime(_defaultInterval);
            }

            _typingIndex++;
        }

        OnFinished.Invoke();
    }

    // newAlpha范围是 0-255！！！
    private void SetSingleCharacterAlpha(int index, byte newAlpha)
    {
        TMP_CharacterInfo charInfo = textInfo.characterInfo[index];
        if (!charInfo.isVisible)
        {
            return;
        }
        int matIndex = charInfo.materialReferenceIndex;
        int vertIndex = charInfo.vertexIndex;
        for (int i = 0; i < 4; i++)
        {
            textInfo.meshInfo[matIndex].colors32[vertIndex + i].a = newAlpha;
        }
        UpdateVertexData();
    }

    IEnumerator FadeInCharacter(int index, float duration = 0.2f)
    {
        if (SelfPreprocessor.TryGetRubyStartFrom(index, out RubyData data))
        {
            SetRubyText(data);
        }
        
        if (duration <= 0)
        {
            SetSingleCharacterAlpha(index,255);
        }
        else
        {
            float timer = 0;
            while (timer < duration)
            {
                timer = Mathf.Min(duration, timer + Time.unscaledDeltaTime);
                SetSingleCharacterAlpha(index, (byte)(255 * timer / duration));
                yield return null;
            }
        }
    }
}
