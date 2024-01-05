using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lerper
{
    Transform _item;
    Transform _t0;
    Transform _t1;
    AnimationCurve _curve;
    float T = 0;
    float _speed;

    public Lerper(Transform item, Transform t0, Transform t1, AnimationCurve curve)
    {
        _item = item;
        _t0 = t0;
        _t1 = t1;
        _curve = curve;
    }

    public void ApplyLerp()
    {
        T += _speed * Time.deltaTime;
        T = Mathf.Clamp01(T);
        float t = _curve.Evaluate(T);
        _item.position = Vector3.Lerp(_t0.position, _t1.position, t);
        _item.rotation = Quaternion.Slerp(_t0.rotation, _t1.rotation, t);
        //Debug.Log(_item.position == _t1.position);
    }
    public void ToT0(float speed = 1)
    {
        _speed = -speed;
    }

    public void ToT1(float speed = 1)
    {
        _speed = speed;
    }

    public bool IsLerpRotationDone()
    {
        return _item.rotation == _t1.rotation;
    }

    
}
