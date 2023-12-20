using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DiminutionExecuter : Usable
{
    GameObject _player;
    Vector3 _currentScale;

    public DiminutionExecuter(GameObject player) { _player = player; }
    public void Use()
    {
        _currentScale = _player.transform.localScale;
        Debug.Log("Using diminution potion!");

        // Change to cutscene animation
        if (_player.transform.localScale == Vector3.one)
        {
            Debug.Log("Diminuting!");
            _player.transform.localScale = new Vector3(0.3f, 0.3f, 0.3f);
            // Change the position of main camera
        }
        else
        {
            Debug.Log("Revovering!");
            _player.transform.localScale = Vector3.one;
            // Change the position of main camera
        }
    }
}
