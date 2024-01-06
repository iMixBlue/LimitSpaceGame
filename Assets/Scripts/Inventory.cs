using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Inventory
{
    Dictionary<item, Usable> _inventory = new Dictionary<item, Usable>();
    int _coin = 0;
    public enum item
    {
        Diminution
    }

    public void AddItem(item theItem, Usable item)
    {
        Debug.Log(theItem.ToString() + " " + "Added!");
        _inventory.Add(theItem, item);
    }
    public Usable GetItem(item theItem) {  return _inventory[theItem]; }

    public void ReceiveCoin() { _coin++; }

    public int CurrentCoin() { return _coin; }

    public int GetInventoryCount() { return _inventory.Count; }
}
