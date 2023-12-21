using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Car : MonoBehaviour
{
    int _power = 0;
    int _maxPower = 20;

    private void OnTriggerStay(Collider other)
    {
        // Change to if entered the car
        if (true)
        {
            if(Input.GetKeyDown(KeyCode.E)) {
                if (_power < _maxPower)
                {
                    _power++;
                }
                else
                {
                    Eject();
                }
            }
        }
    }

    void Eject()
    {

    }


}
