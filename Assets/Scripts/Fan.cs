using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Fan : Bounce
{
    GameObject _fan;
    protected override float _pushForce => 10f;

    private void OnTriggerEnter(Collider other)
    {
        base.OnTriggerEnter(other);
    }

    public void StopSpin()
    {

    }
}
