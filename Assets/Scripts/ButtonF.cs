using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ButtonF : MonoBehaviour
{
    public GameObject FanObj;
    public GameObject smoke1;
    public GameObject smoke2;
    public GameObject smoke3;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    // private void OnTriggerEnter(Collider other) {
    //     if(other.gameObject.tag == "SmallPlayer"){
    //         if(Input.GetKeyDown(KeyCode.F)){
    //             Debug.Log(1);
    //             FanObj.GetComponent<Fan>().StopSpin();
    //         }
    //     }
    // }
    private void OnTriggerStay(Collider other) {
        if(other.gameObject.tag == "SmallPlayer"){
            if(Input.GetKeyDown(KeyCode.F)){
                Debug.Log("Stay in ButtonF");
                FanObj.GetComponent<Fan>().StopSpin();
                smoke1.GetComponent<Smoke>().StopSmoke();
                smoke2.GetComponent<Smoke>().StopSmoke();
                smoke3.GetComponent<Smoke>().StopSmoke();
                GetComponent<BoxCollider>().enabled = false;
            }
        }
    }
}
