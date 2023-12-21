using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Trampoline : Bounce
{
    GameObject _trampoline;
    protected override float _pushForce => 10f;

    private void OnTriggerEnter(Collider other)
    {
        base.OnTriggerEnter(other);
        PlayBounceAnimation();
    }

    public void PlayBounceAnimation()
    {

    }
}
