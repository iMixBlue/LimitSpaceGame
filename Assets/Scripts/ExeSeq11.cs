using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ExeSeq11 : MonoBehaviour
{
    // Start is called before the first frame update
    public bool inExecuteSeq11Area = false;
    // Start is called before the first frame update
   private void OnTriggerEnter(Collider other) {
    if(other.gameObject.tag == "SmallPlayer" || other.gameObject.tag == "Player"){
    inExecuteSeq11Area = true;}
   }
   private void OnTriggerExit(Collider other) {
    if(other.gameObject.tag == "SmallPlayer" || other.gameObject.tag == "Player"){
    inExecuteSeq11Area = false;}
   }
}
