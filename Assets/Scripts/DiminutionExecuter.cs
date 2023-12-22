using System.Collections;
using System.Collections.Generic;
using Cinemachine;

// using Cinemachine;
using StarterAssets;
using UnityEngine;
using UnityStandardAssets.Characters.ThirdPerson;

public class DiminutionExecuter : Usable
{
    GameObject _player;
    Vector3 _currentScale;
    ThirdPersonController thirdPersonController;
    Character character;


    public DiminutionExecuter(GameObject player) {
        _player = player;
        thirdPersonController = _player.GetComponent<ThirdPersonController>();
        character = _player.GetComponent<Character>();
    }
    public void Use()
    {


        _currentScale = _player.transform.localScale;
        Debug.Log("Using diminution potion!");
        


        // Change to cutscene animation
        if (_player.transform.localScale == Vector3.one)
        {
            Debug.Log("Diminuting!");
            _player.transform.localScale = new Vector3(0.1f, 0.1f, 0.1f);
<<<<<<< Updated upstream
            _player.tag = "SmallPlayer";
            thirdPersonController.JumpHeight = 0.4f;
            thirdPersonController.MoveSpeed = 1.2f;
            thirdPersonController.SprintSpeed = 0.4f;
            thirdPersonController._animator.runtimeAnimatorController = character.newController;
            character.virtualCamera.GetCinemachineComponent<Cinemachine3rdPersonFollow>().ShoulderOffset.y = -0.35f;
            character.virtualCamera.GetCinemachineComponent<Cinemachine3rdPersonFollow>().CameraDistance = 0.5f;
=======
            SetMiniDetail();
>>>>>>> Stashed changes
        }
        else
        {
            Debug.Log("Revovering!");
            _player.transform.localScale = Vector3.one;
            // Change back to normal physic set
        }
    }

    public void SetMiniDetail()
    {
        thirdPersonController.MoveSpeed = 0.2f;
        thirdPersonController.SprintSpeed = 0.5335f;
        thirdPersonController.JumpHeight = 0.12f;
        thirdPersonController.Gravity = -1.5f;

        thirdPersonController._animator.runtimeAnimatorController = character.miniController;
    }
}

