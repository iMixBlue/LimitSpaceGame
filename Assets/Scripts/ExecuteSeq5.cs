using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ExecuteSeq5 : MonoBehaviour
{
    public bool outExecuteSeq5Area = false;
    // Start is called before the first frame update
   private void OnTriggerEnter(Collider other) {
    // inExecuteSeq4Area = true;
   }
   private void OnTriggerExit(Collider other) {
    outExecuteSeq5Area = true;
   }
}
