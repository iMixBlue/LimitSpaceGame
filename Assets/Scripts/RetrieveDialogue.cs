using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RetrieveDialogue : MonoBehaviour
{
    public bool canDiaplayDialogue = false;

    // Start is called before the first frame update
    private void OnTriggerStay(Collider other)
    {
        // Debug.Log("Enter!");
        if ((other.CompareTag("Player") || other.CompareTag("SmallPlayer")) && Input.GetKeyDown(KeyCode.F))
        {
            canDiaplayDialogue = true;
        }
    }
}
