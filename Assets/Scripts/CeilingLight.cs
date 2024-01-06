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
    public bool inCeiling = false;
    public bool inCeiling2 = false;
    public Transform cameraBasePoint;
    public Transform climbPosition1;
    public Transform climbPosition2;
    public Transform climbPosition3;
    public Transform climbPosition4;
    public GameObject parent;
    public float swingSpeed = 30f;  // 摇晃的速度
    public float swingAngle = 30f;  // 摇晃的角度

    private bool isSwingingRight = true;
    private float currentRotationZ;
    private float targetRotationZ;
    // Start is called before the first frame update
    void Start()
    {
        targetRotationZ = swingAngle;
    }

    // Update is called once per frame
    void Update()
    {
        if (inCeiling && Input.GetKeyDown(KeyCode.F))
        {
            // Debug.Log(1);
            this.gameObject.transform.DetachChildren();
            player.GetComponent<ThirdPersonController>().enabled = true;
            player.GetComponent<Animator>().runtimeAnimatorController = runtimeAnimatorControllerBackup;
        }

        

    }
    private void FixedUpdate() {
        if (isSwingingRight)
        {
            currentRotationZ += swingSpeed * Time.deltaTime;
        }
        else
        {
            currentRotationZ -= swingSpeed * Time.deltaTime;
        }

        // 更新物体的旋转
        parent.transform.rotation = Quaternion.Euler(parent.transform.rotation.eulerAngles.x, parent.transform.rotation.eulerAngles.y, currentRotationZ);

        // 检查是否达到目标旋转
        if (Mathf.Abs(currentRotationZ - targetRotationZ) < 0.5f)
        {
            isSwingingRight = !isSwingingRight;
            targetRotationZ = -targetRotationZ;
        }
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "SmallPlayer")
        {
            // Debug.Log(1);
            inCeiling2 = true;
            inCeiling = true;
            float distance1 = Mathf.Abs(Vector3.Distance(cameraBasePoint.position, climbPosition1.position));
            float distance2 = Mathf.Abs(Vector3.Distance(cameraBasePoint.position, climbPosition2.position));
            float distance3 = Mathf.Abs(Vector3.Distance(cameraBasePoint.position, climbPosition3.position));
            float distance4 = Mathf.Abs(Vector3.Distance(cameraBasePoint.position, climbPosition4.position));
            float minDistance = Mathf.Min(distance1, Mathf.Min(distance2, Mathf.Min(distance3, distance4)));
            if (minDistance == distance1)
            {
                // Debug.Log(1);
                player.transform.parent = this.gameObject.transform;
                player.GetComponent<ThirdPersonController>().enabled = false;
                player.GetComponent<Animator>().runtimeAnimatorController = runtimeAnimatorController;
                Vector3 position = climbPosition1.position - cameraBasePoint.position;
                // Debug.Log(position);
                player.transform.position += position;
            }
            if (minDistance == distance2)
            {
                // Debug.Log(2);
                player.transform.parent = this.gameObject.transform;
                player.GetComponent<ThirdPersonController>().enabled = false;
                player.GetComponent<Animator>().runtimeAnimatorController = runtimeAnimatorController;
                Vector3 position = climbPosition2.position - cameraBasePoint.position;
                // Debug.Log(position);
                player.transform.position += position;
            }
            if (minDistance == distance3)
            {
                // Debug.Log(3);
                player.transform.parent = this.gameObject.transform;
                player.GetComponent<ThirdPersonController>().enabled = false;
                player.GetComponent<Animator>().runtimeAnimatorController = runtimeAnimatorController;
                Vector3 position = climbPosition3.position - cameraBasePoint.position;
                // Debug.Log(position);

                player.transform.position += position;
            }
            if (minDistance == distance4)
            {
                // Debug.Log(4);
                player.transform.parent = this.gameObject.transform;
                player.GetComponent<ThirdPersonController>().enabled = false;
                player.GetComponent<Animator>().runtimeAnimatorController = runtimeAnimatorController;
                Vector3 position = climbPosition4.position - cameraBasePoint.position;
                // Debug.Log(position);

                player.transform.position += position;
            }

        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "SmallPlayer")
        {
            inCeiling = false;
            inCeiling2 = false;
            // player.GetComponent<ThirdPersonController>().enabled = true;
            // player.GetComponent<Animator>().runtimeAnimatorController = runtimeAnimatorControllerBackup;
        }
    }
    private void OnTriggerStay(Collider other)
    {

    }

}
