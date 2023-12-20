using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DiminutionExecuter : MonoBehaviour, Usable
{
    GameObject _player;
    Vector3 _currentScale;

    void Start()
    {
        _currentScale = _player.transform.localScale;
    }
    public DiminutionExecuter(GameObject player) { _player = player; }
    public void Use()
    {
        // Change to cutscene animation
        if (_player.transform.localScale == Vector3.one)
        {
            _player.transform.localScale = new Vector3(0.3f, 0.3f, 0.3f);
        }
        else
        {
            _player.transform.localScale = Vector3.one;
        }
    }
}
