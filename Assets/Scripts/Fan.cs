using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Fan : Bounce
{
    [SerializeField] float _rotateSpeed;
    protected override float _pushForce => 10f;

    private void OnTriggerEnter(Collider other)
    {
        // Bounce back effect
        if (other.gameObject.tag == "SmallPlayer") { OnDied(); }
    }
    void OnDied(){
        // Teleport to the last saved point
    }

    private void Update() {
        this.transform.Rotate(Vector3.up,_rotateSpeed * Time.deltaTime, Space.Self);
    }

    public void StopSpin()
    {
        this.enabled = false;
    }
}
