using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Character : MonoBehaviour
{
    Inventory _inventory;
    RespawnManager _respawnManager;

    private void Start()
    {
        _inventory = new Inventory();
        _respawnManager = new RespawnManager(this.gameObject);
    }

    public void AddItem(string name, Usable item)
    {
        _inventory.AddItem(name, item);
    }
    public void UseItem(string item) { _inventory.GetItem(item).Use(); }
    public void ReceiveCoin() { _inventory.ReceiveCoin(); }

    public int CurrentCoin() { return _inventory.CurrentCoin(); }

    // Store position when reach check point
    public void StoreRespawnPosition (Vector3 pos) { _respawnManager.StorePosition(pos); }

    public void Respawn() { _respawnManager.Respawn(); }
}
