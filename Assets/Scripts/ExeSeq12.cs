using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ExeSeq12 : MonoBehaviour
{
    // Start is called before the first frame update
    public bool outExecuteSeq12Area = false;
    // Start is called before the first frame update
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "SmallPlayer" || other.gameObject.tag == "Player")
        {
            outExecuteSeq12Area = false;
        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "SmallPlayer" || other.gameObject.tag == "Player")
        {
            outExecuteSeq12Area = true;
        }
    }
}
