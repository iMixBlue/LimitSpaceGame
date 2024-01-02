using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(CanvasGroup))]
public class Widget : MonoBehaviour
{
    private CanvasGroup _canvasGroup;

    [SerializeField] private AnimationCurve _fadingCurve = AnimationCurve.EaseInOut(0,0,1,1);

    public float RenderOpacity
    {
        get => _canvasGroup.alpha;
        set => _canvasGroup.alpha = value;
    }

    private void Awake()
    {
        _canvasGroup = GetComponent<CanvasGroup>();
    }

    private Coroutine _fadeCoroutine;
    public void Fade(float opacity, float duration, Action onFinished)
    {
        if (duration <= 0)
        {
            _canvasGroup.alpha = opacity;
            onFinished?.Invoke();
        }
        else
        {
            if (_fadeCoroutine != null)
            {
                StopCoroutine(_fadeCoroutine);
            }

            _fadeCoroutine = StartCoroutine(Fading(opacity, duration, onFinished));
        }
    }

    private IEnumerator Fading(float opacity, float duration, Action onFinished)
    {
        float timer = 0;
        float start = RenderOpacity;
        while (timer < duration)
        {
            timer = Mathf.Min(duration, timer + Time.unscaledDeltaTime);
            RenderOpacity = Mathf.Lerp(start, opacity, _fadingCurve.Evaluate(timer / duration));
            yield return null;
        }
        onFinished?.Invoke();
    }
}
