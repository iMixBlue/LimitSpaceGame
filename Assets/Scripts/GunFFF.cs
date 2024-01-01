using System.Collections;
using System.Collections.Generic;
using Cinemachine;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Rendering.Universal;

public class GunFFF : MonoBehaviour
{
    public GameObject gunAllObj;
    // public GameObject player;
    public GameObject MainCamera;
    public GameObject PlayerFollowCamera;
    public GameObject FirstFollowCamera;
    public bool inGunGame = false;
    public bool canPreesF = false;
    public bool have3Gold = false;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(have3Gold){
            if(inGunGame){
            if(Input.GetKeyDown(KeyCode.F)){
                inGunGame = false;
                gunAllObj.SetActive(false);
                FirstFollowCamera.GetComponent<CinemachineVirtualCamera>().enabled = false;
                // player.SetActive(true);
                MainCamera.SetActive(true);
                PlayerFollowCamera.SetActive(true);
            }
        }
         if(this.canPreesF){
             if(Input.GetKeyDown(KeyCode.F)){
                Debug.Log("Press F");
                gunAllObj.SetActive(true);
                FirstFollowCamera.GetComponent<CinemachineVirtualCamera>().enabled = true;
                // player.SetActive(false);
                MainCamera.SetActive(false);
                PlayerFollowCamera.SetActive(false);
                inGunGame = true;
            }
        }
        }
        
    }
    private void OnTriggerEnter(Collider other) {
        if(other.gameObject.tag == "SmallPlayer"){
            canPreesF = true;
            Debug.Log("InGunArea!");
            
        }
    }
    private void OnTriggerStay(Collider other) {
        // Debug.Log("Stay in Gun Area!");
        //&& !inGunGame
       
       
    }
    private void OnTriggerExit(Collider other) {
        if(other.gameObject.tag == "SmallPlayer"){
            canPreesF = false;
        }
    }
    

}
