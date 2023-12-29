using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Car : MonoBehaviour
{
    float _power = 0;
    float _powerThreshold = 0.2f;
    float _powerAddSpeed = 10   ;
    float _powerLoseSpeed = 1;
    [SerializeField] Transform _clockwork;
    [SerializeField] Transform _UnwoundTransform;
    [SerializeField] Transform _fullWoundTransform;
    Lerper _clockworkLerper;
    [SerializeField] Transform _firePoint;
    public float forceMagnitude = 8f;
    bool _isPlayerInCar = false;
    bool _ejected = false;
    Transform _player;

    private void Start()
    {
        _clockworkLerper = new Lerper(_clockwork, _UnwoundTransform, _fullWoundTransform, AnimationCurve.Linear(0f, 0f, 1f, 1f));
        _firePoint = transform.GetChild(0);
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
        if (_isPlayerInCar && _player != null && !_ejected)
        {
            _player.transform.position = _firePoint.transform.position;
        }
        if (GetComponent<Rigidbody>().velocity.magnitude < 0.1f)
        {

        }
    }
    private void OnTriggerStay(Collider other)
    {
        // Player enter the car
        if (other.CompareTag("SmallPlayer"))
        {
            Debug.Log("Player entered£¡");
            _player = other.transform;
            if (Input.GetKeyDown(KeyCode.F)){
                other.GetComponent<Character>().SetInCarState();
                //other.transform.position = _firePoint.transform.position;
                _isPlayerInCar = true;
            }
            //Debug.Log("Add speed: " + _powerLoseSpeed * Time.deltaTime + "Add speed: " + _powerAddSpeed * Time.deltaTime);
        }

        // Player wind the clockwork
        if (_isPlayerInCar)
        {
            if (Input.GetKeyDown(KeyCode.E))
            {
                _power += _powerAddSpeed * Time.deltaTime;

                if (_clockworkLerper.IsLerpRotationDone())
                {
                    GetComponent<BoxCollider>().enabled = false;
                    Eject();
                }
            }
            _player.transform.position = _firePoint.transform.position;
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
        Rigidbody rb = gameObject.GetComponent<Rigidbody>();
        Vector3 forceDirection = gameObject.transform.forward * forceMagnitude;
        rb.AddForce(forceDirection, ForceMode.Impulse);
        StartCoroutine(SetGetOffCar(1));
    }

    void WindClockwork()
    {
        _clockworkLerper.ToT1();
    }

    void UnwindClockwork()
    {
        _clockworkLerper.ToT0();
    }

    IEnumerator SetGetOffCar(float seconds)
    {
        yield return new WaitForSeconds(seconds);
        _ejected = true;
        _isPlayerInCar = false;
        _player.GetComponent<Character>().SetMinitate();
    }
}
