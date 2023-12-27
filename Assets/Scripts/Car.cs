using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Car : MonoBehaviour
{
    float _power = 0;
    float _powerThreshold = 0.2f;
    float _powerAddSpeed = 10;
    float _powerLoseSpeed = 1;
    float _maxPower = 20;
    [SerializeField] Transform _clockwork;
    [SerializeField] Transform _UnwoundTransform;
    [SerializeField] Transform _fullWoundTransform;
    Lerper _clockworkLerper;
    [SerializeField] float windTimes = 20f;

    private void Start()
    {
        _clockworkLerper = new Lerper(_clockwork, _UnwoundTransform, _fullWoundTransform, AnimationCurve.Linear(0f, 0f, 1f, 1f));
    }
    private void Update()
    {
        _power -= _powerLoseSpeed * Time.deltaTime;
        _power = Mathf.Clamp01(_power);
        //UnwindClockwork();
        _clockworkLerper.ApplyLerp();
        //Debug.Log(_power);
        if (_power >= _powerThreshold)
        {
            //Debug.Log("Spinning!");
            WindClockwork();
        }
        else
        {
            UnwindClockwork();
        }
    }
    private void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("SmallPlayer"))
        {
            Debug.Log("Player entered£¡");
            if (Input.GetKeyDown(KeyCode.E))
            {
                _power += _powerAddSpeed * Time.deltaTime;

                if (_clockworkLerper.IsLerpRotationDone())
                {
                    GetComponent<BoxCollider>().enabled = false;
                    Eject();
                }
            }
            //Debug.Log("Add speed: " + _powerLoseSpeed * Time.deltaTime + "Add speed: " + _powerAddSpeed * Time.deltaTime);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            Debug.Log("Player exited£¡");
            UnwindClockwork();
        }
    }

    void Eject()
    {
        Debug.Log("Eject!");
    }

    void WindClockwork()
    {
        _clockworkLerper.ToT1();
    }

    void UnwindClockwork()
    {
        _clockworkLerper.ToT0();
    }
}
