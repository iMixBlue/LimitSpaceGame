using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Fan : Bounce
{
    GameObject _fan;
    public float _rotateSpeed;
    [SerializeField]
    private bool canRotateBool = true;
    protected override float _pushForce => 10f;

    private void OnTriggerEnter(Collider other)
    {
        base.OnTriggerEnter(other);
    }
    public void OnDied(){
        //把主角传送回上一个存档点
    }
    private void OnCollisionEnter(Collision other) {
        if(other.gameObject.tag == "SmallPlayer"){
             if(canRotateBool){
                 OnDied();
             }
        }
    }
    private void Update() {
        if(canRotateBool){
        this.transform.Rotate (Vector3.up,_rotateSpeed*Time.deltaTime,Space.Self);
        }
    }

    public void StopSpin()
    {
        this.canRotateBool = false;
    }
}
