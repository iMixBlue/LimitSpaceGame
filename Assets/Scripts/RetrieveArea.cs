using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RetrieveArea : MonoBehaviour
{
    [SerializeField] GameObject _item;

    private void OnTriggerStay(Collider other)
    {
        Debug.Log("Enter!");
        if (other.CompareTag("Player") && Input.GetKeyDown(KeyCode.F))
        {
            Debug.Log("Retieved!");
            other.GetComponent<Character>().AddItem(Inventory.item.Diminution, new DiminutionExecuter(other.gameObject));
            Destroy(_item);
            Destroy(this.gameObject);
        }
    }
}
