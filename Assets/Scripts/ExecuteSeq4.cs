using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ExecuteSeq4 : MonoBehaviour
{
    public bool inExecuteSeq4Area = false;
    // Start is called before the first frame update
   private void OnTriggerEnter(Collider other) {
    if(other.gameObject.tag == "SmallPlayer"){
inExecuteSeq4Area = true;
    }
    
   }
   private void OnTriggerExit(Collider other) {
    if(other.gameObject.tag == "SmallPlayer"){
    inExecuteSeq4Area = false;}
   }
}
