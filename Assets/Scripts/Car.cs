using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Car : MonoBehaviour
{
    float _power = 0;
    float _powerThreshold = 0.2f;
    float _powerAddAmount = 12;
    float _powerLoseAmount = 1;
    [SerializeField] float forceMagnitude = 8f;
    [SerializeField] Transform _UnwoundTransform;
    [SerializeField] Transform _fullWoundTransform;
    [SerializeField] Transform _firePoint;
    [SerializeField] Transform _clockwork;
    [SerializeField] AudioSource _engineAudio;
    Transform _driver;
    Lerper _clockworkLerper;
    bool _isPlayerInCar = false;
    bool _ejected = false;

    private void Start()
    {
        _firePoint = transform.GetChild(0);
        _clockwork = transform.GetChild(1);
        _clockworkLerper = new Lerper(_clockwork, _UnwoundTransform, _fullWoundTransform, AnimationCurve.Linear(0f, 0f, 1f, 1f));
    }
    private void Update()
    {
        _power -= _powerLoseAmount * Time.deltaTime;
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
        if (_isPlayerInCar && _driver != null && !_ejected)
        {
            _driver.transform.position = _firePoint.transform.position;
        }
        if (GetComponent<Rigidbody>().velocity.magnitude < 0.1f)
        {

        }
    }
    private void OnTriggerStay(Collider other)
    {
        // Press F to enter the car
        if (other.CompareTag("SmallPlayer"))
        {
            Debug.Log("Player entered£¡");
            _driver = other.transform;
            if (Input.GetKeyDown(KeyCode.F)){
                _engineAudio.Play();
                other.GetComponent<Character>().SetInCarState();
                //other.transform.position = _firePoint.transform.position;
                _isPlayerInCar = true;
            }
            //Debug.Log("Add speed: " + _powerLoseSpeed * Time.deltaTime + "Add speed: " + _powerAddSpeed * Time.deltaTime);
        }

        // If in the car, press E to wind the clockwork
        if (_isPlayerInCar)
        {
            if (Input.GetKeyDown(KeyCode.E))
            {
                _power += _powerAddAmount * Time.deltaTime;

                if (_clockworkLerper.IsLerpRotationDone())      // Eject when fully-wound
                {
                    GetComponent<BoxCollider>().enabled = false;
                    Eject();
                }
            }
            _driver.transform.position = _firePoint.transform.position;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            // Debug.Log("Player exited£¡");
            UnwindClockwork();
        }
    }

    void Eject()
    {
        Debug.Log("Eject!");
        Rigidbody rb = gameObject.GetComponent<Rigidbody>();
        Vector3 forceDirection = gameObject.transform.forward * forceMagnitude;
        rb.AddForce(forceDirection, ForceMode.Impulse);
        StartCoroutine(PushPlayerOffCar(1));
    }

    void WindClockwork() { _clockworkLerper.ToT1(); }

    void UnwindClockwork() { _clockworkLerper.ToT0(); }

    IEnumerator PushPlayerOffCar(float seconds)
    {
        yield return new WaitForSeconds(seconds);
        _ejected = true;
        _isPlayerInCar = false;
        _driver.GetComponent<Character>().SetMinitate();
        _engineAudio.Stop();
    }
}
