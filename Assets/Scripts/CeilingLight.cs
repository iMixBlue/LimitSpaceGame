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
    public Transform cameraBasePoint;
    public Transform climbPosition1;
    public Transform climbPosition2;
    public Transform climbPosition3;
    public Transform climbPosition4;
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
            float distance1 = Mathf.Abs(Vector3.Distance(cameraBasePoint.position,climbPosition1.position));
            float distance2 = Mathf.Abs(Vector3.Distance(cameraBasePoint.position,climbPosition2.position));
            float distance3 = Mathf.Abs(Vector3.Distance(cameraBasePoint.position,climbPosition3.position));
            float distance4 = Mathf.Abs(Vector3.Distance(cameraBasePoint.position,climbPosition4.position));
            float minDistance = Mathf.Min(distance1,Mathf.Min(distance2,Mathf.Min(distance3,distance4)));
            if(minDistance == distance1){
                Debug.Log(1);
                Vector3 position = climbPosition1.position - cameraBasePoint.position;
                Debug.Log(position);
                player.transform.position += position;
            }
            if(minDistance == distance2){
                Debug.Log(2);
                Vector3 position = climbPosition2.position - cameraBasePoint.position;
                Debug.Log(position);
                player.transform.position += position;
            }
            if(minDistance == distance3){
                Debug.Log(3);
                Vector3 position = climbPosition3.position - cameraBasePoint.position;
                Debug.Log(position);

                player.transform.position += position;
            }
            if(minDistance == distance4){
                Debug.Log(4);
                Vector3 position = climbPosition4.position - cameraBasePoint.position;
                Debug.Log(position);

                player.transform.position += position;
            }
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
