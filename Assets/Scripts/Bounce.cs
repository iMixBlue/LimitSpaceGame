using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bounce : MonoBehaviour
{
    protected virtual float _pushForce => 10f;

    protected void OnTriggerEnter(Collider other)
    {
        // Bounce back
    }
}
