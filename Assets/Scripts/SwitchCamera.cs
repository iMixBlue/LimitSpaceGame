using System.Collections;
using System.Collections.Generic;
using Cinemachine;
using StarterAssets;
using UnityEngine;
using UnityStandardAssets.Characters.ThirdPerson;

public class SwitchCamera : MonoBehaviour
{
    public GameObject ThirdPersonFollowCamera;
    public GameObject FirstPersonFollowCamera;
    public GameObject _player;
    public GameObject caveToHouseCamera;
    public GameObject caveToHousePortal;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    private void OnTriggerEnter(Collider other) {
        if(other.gameObject.tag == "SmallPlayer"){
            ThirdPersonFollowCamera.GetComponent<CinemachineVirtualCamera>().enabled = false;
            FirstPersonFollowCamera.GetComponent<CinemachineVirtualCamera>().enabled = true;
            _player.GetComponent<ThirdPersonController>().TopClamp = 20;
            _player.GetComponent<ThirdPersonController>().BottomClamp = -89;
            caveToHouseCamera.SetActive(true);
            // Invoke("RecoverThirdPersonCamera",15f);
        }
    }
    private void OnTriggerExit(Collider other) {
        if(other.gameObject.tag == "SmallPlayer"){
            RecoverThirdPersonCamera();
        }
    }
    public void RecoverThirdPersonCamera(){
        Debug.Log("Recover Camera!");
        ThirdPersonFollowCamera.GetComponent<CinemachineVirtualCamera>().enabled = true;
        FirstPersonFollowCamera.GetComponent<CinemachineVirtualCamera>().enabled = false;
        _player.GetComponent<ThirdPersonController>().TopClamp = 70;
        _player.GetComponent<ThirdPersonController>().BottomClamp = -30;
        caveToHouseCamera.SetActive(false);
        caveToHousePortal.SetActive(false);

    }
}
