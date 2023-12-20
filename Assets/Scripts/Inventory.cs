using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Inventory : MonoBehaviour
{
    Dictionary<string, Usable> _inventory = new Dictionary<string, Usable>();
    int _coin = 0;

    public void AddItem(string name, Usable item)
    {
        _inventory.Add(name, item);
    }
    public Usable GetItem(string name) {  return _inventory[name]; }

    public void ReceiveCoin() { _coin++; }

    public int CurrentCoin() { return _coin; }
}
