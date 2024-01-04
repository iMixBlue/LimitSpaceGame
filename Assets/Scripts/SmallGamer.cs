using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SmallGamer : MonoBehaviour
{
    public Camera MainCamera;
    public GameObject ThirdpersonFollowCamera;
    public GameObject SmallGamerCamera;
    public GameObject gamerCharacter;
    public GameObject _player;
    private bool inTrigger = false;
    public bool once = true;
    public GameObject RestartText;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(inTrigger && once){
            if(Input.GetKeyDown(KeyCode.F)){
                MainCamera.gameObject.SetActive(false);
                ThirdpersonFollowCamera.SetActive(false);
                SmallGamerCamera.SetActive(true);
                _player.SetActive(false);
                gamerCharacter.GetComponent<Tiny1Controller>().enabled = true;
                RestartText.SetActive(true);
                once = false;
            }
        }
        
    }
    private void OnTriggerEnter(Collider other) {
        if(other.gameObject.tag == "SmallPlayer"){
            inTrigger = true;
            Debug.Log("Enter Small Game!");
        }
    }
}
