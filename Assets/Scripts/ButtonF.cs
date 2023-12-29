using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ButtonF : MonoBehaviour
{
    public GameObject FanObj;
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
            }
        }
    }
}
