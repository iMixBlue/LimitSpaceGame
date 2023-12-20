using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RespawnManager : MonoBehaviour
{
    GameObject _player;
    Vector3 _respawnPosition;

    public RespawnManager(GameObject player) {  _player = player; }
    public void StorePosition(Vector3 pos) { _respawnPosition = pos;}

    public void Respawn()
    {
        _player.transform.position = _respawnPosition;
    }
}
