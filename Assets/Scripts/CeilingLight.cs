using System.Collections;
using System.Collections.Generic;
using StarterAssets;
using UnityEngine;
using UnityStandardAssets.Characters.ThirdPerson;

public class CeilingLight : MonoBehaviour
{
    public GameObject player;
    public RuntimeAnimatorController runtimeAnimatorController;
    public RuntimeAnimatorController runtimeAnimatorControllerBackup;
    private bool inCeiling = false;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
         if(inCeiling && Input.GetKeyDown(KeyCode.Space)){
            // Debug.Log(1);
            player.GetComponent<ThirdPersonController>().enabled = true;
            player.GetComponent<Animator>().runtimeAnimatorController = runtimeAnimatorControllerBackup;
        }
    }
    private void OnTriggerEnter(Collider other) {
        if(other.tag == "SmallPlayer"){
        inCeiling= true;
            player.GetComponent<ThirdPersonController>().enabled = false;
            player.GetComponent<Animator>().runtimeAnimatorController = runtimeAnimatorController;
        }
    }
    private void OnTriggerExit(Collider other) {
        if(other.tag == "SmallPlayer"){
            inCeiling= false;
            player.GetComponent<ThirdPersonController>().enabled = true;
            player.GetComponent<Animator>().runtimeAnimatorController = runtimeAnimatorControllerBackup;
        }
    }
    private void OnTriggerStay(Collider other) {
       
    }
    
}
