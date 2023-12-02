using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HealthPresenter : MonoBehaviour
{
    [SerializeField] Health health;
    [SerializeField] Slider healthBar;

    private void Start()
    {
        health.onHealthChanged += UpdateUI;
        UpdateUI();
    }

    void UpdateUI()
    {
        healthBar.value = health.GetHealth() / health.GetFullHealth();
    }
}
