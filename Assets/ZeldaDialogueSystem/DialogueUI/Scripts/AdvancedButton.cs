using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using System;

public class AdvancedButton : Button
{
    protected override void Awake()
    {
        onClick.AddListener(OnClickEvent);
    }
    public override void OnPointerEnter(PointerEventData eventData)
    {
        base.OnPointerEnter(eventData);
        Select();
    }

    public override void OnSelect(BaseEventData eventData)
    {
        base.OnSelect(eventData);
        ZeldaUIManager.SetCurrentSelectable(this);
    }
    protected int _index;
    protected virtual void OnClickEvent() { }

    public Action<int> OnConfirm; // int参数代表自身的下标序号
    public virtual void Init(string content, int index, Action<int> onConfirmEvent)
    {
        _index = index;
        OnConfirm += onConfirmEvent;
    }
    public void Confirm()
    {
        OnConfirm(_index);
    }
}
