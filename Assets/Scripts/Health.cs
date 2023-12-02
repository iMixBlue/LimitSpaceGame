using System;
using UnityEngine;

public class Health : MonoBehaviour
{
    int health = 100;
    int fullHealth = 100;
    float currentHealth = 0;

    public event Action onHealthChanged;

    private void Awake()
    {
        ResetHealth();
    }

    private void OnEnable()
    {
        GetComponent<Level>().onLevelUpAction += ResetHealth;
    }

    private void OnDisable()
    {
        GetComponent<Level>().onLevelUpAction -= ResetHealth;
    }

    public float GetHealth()
    {
        return health;
    }

    public float GetFullHealth()
    {
        return fullHealth;
    }

    void ResetHealth()
    {
        currentHealth = fullHealth;
        if (onHealthChanged != null)
        {
            onHealthChanged();
        }
    }

    void GetDemage(float damage)
    {
        currentHealth -= damage;
        if (onHealthChanged != null)
        {
            onHealthChanged();
        }
    }
}
