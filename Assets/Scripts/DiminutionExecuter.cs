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
        if (_player.transform.localScale == Vector3.one)
        {
            Debug.Log("Diminuting!");
            _player.transform.localScale = new Vector3(0.1f, 0.1f, 0.1f);
            _player.tag = "SmallPlayer";
            SetMiniDetail();
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
        ThirdPersonController thirdPersonController = _player.GetComponent<ThirdPersonController>();

        thirdPersonController.MoveSpeed = 0.2f;
        thirdPersonController.SprintSpeed = 0.5335f;
        thirdPersonController.JumpHeight = 0.12f;
        thirdPersonController.Gravity = -2.5f;

        Character character = _player.GetComponent<Character>();

        thirdPersonController._animator.runtimeAnimatorController = character.miniController;
    }
}

