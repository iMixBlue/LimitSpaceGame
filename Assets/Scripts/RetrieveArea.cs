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
        // Debug.Log("Enter!");
        if ((other.CompareTag("Player") || other.CompareTag("SmallPlayer")) && Input.GetKeyDown(KeyCode.F))
        {
            // Debug.Log("Retieved!");
            switch (_item.tag){
                case "Diminution":
                    other.gameObject.tag = "SmallPlayer";
                    DiminutionExecuter potion = new DiminutionExecuter(other.gameObject);
                    other.GetComponent<Character>().AddItem(Inventory.item.Diminution, potion);
                    Debug.Log("Diminution Retrieved!");
                    OnItemGetAction?.Invoke();      // Play cutscene
                    OnItemGetAction = null;
                    potion.SetMiniDetail();
                    break;
                case "Restore":
                    other.gameObject.tag = "Player";
                    OnItemGetAction?.Invoke();
                    OnItemGetAction = null;
                    DiminutionExecuter potionInInventory = other.GetComponent<Character>().GetItem(Inventory.item.Diminution) as DiminutionExecuter;
                    potionInInventory.SetNormalDetail();
                    break;
                case "Coin":
                    other.GetComponent<Character>().ReceiveCoin();
                    break;
            }
            
            Destroy(_item);
            Destroy(this.gameObject.GetComponent<RetrieveArea>());
        }
    }
}
