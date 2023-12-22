using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RetrieveArea : MonoBehaviour
{
    [SerializeField] GameObject _item;
    public event Action OnItemGetAction;

    private void OnTriggerStay(Collider other)
    {
        Debug.Log("Enter!");
        if (other.CompareTag("Player") && Input.GetKeyDown(KeyCode.F))
        {
            Debug.Log("Retieved!");
            switch (_item.tag){
                case "Diminution":
                    other.gameObject.tag = "SmallPlayer";
                    DiminutionExecuter potion = new DiminutionExecuter(other.gameObject);
                    other.GetComponent<Character>().AddItem(Inventory.item.Diminution, potion);
                    Debug.Log("Diminution Retrieved!");
                    OnItemGetAction?.Invoke();
                    OnItemGetAction = null;
                    potion.SetMiniDetail();
                    break;
                case "Coin":
                    other.GetComponent<Character>().ReceiveCoin();
                    break;
            }
            
            Destroy(_item);
            Destroy(this.gameObject);
        }
    }
}
