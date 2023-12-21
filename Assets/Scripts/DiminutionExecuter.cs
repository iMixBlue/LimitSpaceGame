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


    public DiminutionExecuter(GameObject player) { _player = player; }
    public void Use()
    {
        _currentScale = _player.transform.localScale;
        Debug.Log("Using diminution potion!");
        thirdPersonController = _player.GetComponent<ThirdPersonController>();
        character = _player.GetComponent<Character>();


        // Change to cutscene animation
        if (_player.transform.localScale == Vector3.one)
        {
            Debug.Log("Diminuting!");
            _player.transform.localScale = new Vector3(0.3f, 0.3f, 0.3f);
            thirdPersonController.JumpHeight = 0.6f;
            thirdPersonController.MoveSpeed = 0.8f;
            thirdPersonController.SprintSpeed = 1.8f;
            thirdPersonController._animator.runtimeAnimatorController = character.newController;
            character.virtualCamera.GetCinemachineComponent<Cinemachine3rdPersonFollow>().ShoulderOffset.y = -0.25f;
            character.virtualCamera.GetCinemachineComponent<Cinemachine3rdPersonFollow>().CameraDistance =0.8f;
        }
        else
        {
            Debug.Log("Revovering!");
            _player.transform.localScale = Vector3.one;
            // Change the position of main camera
        }
    }
}

