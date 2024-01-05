using System.Collections;
using System.Collections.Generic;
using Cinemachine;
using StarterAssets;
using UnityEngine;

public class Character : MonoBehaviour
{
    Inventory _inventory;
    RespawnManager _respawnManager;
    public CinemachineVirtualCamera virtualCamera;
    public RuntimeAnimatorController miniController; 

    private void Start()
    {
        _inventory = new Inventory();
        _respawnManager = new RespawnManager(this.gameObject);
    }

    private void Update()
    {
        /*if (Input.GetKeyDown(KeyCode.E))
        {
            UseItem(Inventory.item.Diminution);
        }*/
    }

    public void AddItem(Inventory.item theItem, Usable item)
    {
        _inventory.AddItem(theItem, item);
    }
    public void UseItem(Inventory.item theItem) { _inventory.GetItem(theItem).Use(); }

    public Usable GetItem(Inventory.item theItem) { return _inventory.GetItem(theItem); }

    //public Usable GetItem(Inventory.item theItem) { return _inventory.GetItem(theItem); }
    public void ReceiveCoin() { _inventory.ReceiveCoin(); Debug.Log("Coin Received!"); }

    public int CurrentCoin() { return _inventory.CurrentCoin(); }

    // Store position when reach check point
    public void StoreRespawnPosition (Vector3 pos) { _respawnManager.StorePosition(pos); }

    public void Respawn() { _respawnManager.Respawn(); }

    public int GetInventoryCount() {  return _inventory.GetInventoryCount(); }

    public void SetInCarState()
    {
        GetComponent<ThirdPersonController>().MoveSpeed = 0;
        GetComponent<ThirdPersonController>().SprintSpeed = 0;
        GetComponent<ThirdPersonController>().JumpHeight = 0;
        transform.localScale = Vector3.zero;
        GetComponent<CharacterController>().enabled = false;
    }

    public void SetMinitate()
    {
        Debug.Log("Mini state set!");
        GetComponent<ThirdPersonController>().MoveSpeed = 0.2f;
        GetComponent<ThirdPersonController>().SprintSpeed = 0.5335f;
        GetComponent<ThirdPersonController>().JumpHeight = 0.25f;
        transform.localScale = new Vector3(0.1f, 0.1f, 0.1f);
        GetComponent<CharacterController>().enabled = true;
    }
}
