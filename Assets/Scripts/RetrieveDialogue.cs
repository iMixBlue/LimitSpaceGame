using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RetrieveDialogue : MonoBehaviour
{
    public bool canDiaplayDialogue = false;
    public bool canDisplayDialogueForFirstCoin = false;
    public bool canDisplayDialogueForSecondCoin = false;

    // Start is called before the first frame update
    private void OnTriggerStay(Collider other)
    {
        // Debug.Log("Enter!");
        if ((other.CompareTag("Player") || other.CompareTag("SmallPlayer")))
        {
        }
        if ((other.CompareTag("Player") || other.CompareTag("SmallPlayer"))&& Input.GetKeyDown(KeyCode.F))
        {
            canDisplayDialogueForFirstCoin = true;
            canDisplayDialogueForSecondCoin = true;
        }

    }
    private void OnTriggerExit(Collider other) {
         if ((other.CompareTag("Player") || other.CompareTag("SmallPlayer")))
        {
            canDiaplayDialogue = false;
            canDisplayDialogueForFirstCoin = false;
            canDisplayDialogueForSecondCoin = false;
        }
    }
    public void SetCanDisplayDialogue(){
        canDiaplayDialogue = true;
    }
}
