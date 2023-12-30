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
    
    public DiminutionExecuter(GameObject player) {
        _player = player;
    }
    public void Use()
    {
        Debug.Log("Using diminution potion!");
        
        // Change to cutscene animation
        if (_player.transform.localScale == Vector3.one || _player.transform.localScale == Vector3.zero)
        {
            Debug.Log("Diminuting!");
            _player.transform.localScale = new Vector3(0.1f, 0.1f, 0.1f);
            _player.tag = "SmallPlayer";
            SetMiniDetail();
        }
        else if (_player.transform.localScale == new Vector3(0.1f, 0.1f, 0.1f))
        {
            Debug.Log("Revovering!");
            _player.transform.localScale = Vector3.one;
            // Change back to normal physic set
        }
    }

    public void SetMiniDetail()
    {
        ThirdPersonController thirdPersonController = _player.GetComponent<ThirdPersonController>();

        thirdPersonController.MoveSpeed = 0.2f;
        thirdPersonController.SprintSpeed = 0.5335f;
        thirdPersonController.JumpHeight = 0.25f;
        thirdPersonController.Gravity = -2.5f;
        thirdPersonController.GroundedOffset = -0.014f;
        thirdPersonController.GroundedRadius = 0.028f;
        Character character = _player.GetComponent<Character>();
        character.virtualCamera.GetCinemachineComponent<Cinemachine3rdPersonFollow>().CameraDistance = 0.5f;
        character.virtualCamera.GetCinemachineComponent<Cinemachine3rdPersonFollow>().ShoulderOffset.y = -0.25f;

        thirdPersonController._animator.runtimeAnimatorController = character.miniController;
    }
}

