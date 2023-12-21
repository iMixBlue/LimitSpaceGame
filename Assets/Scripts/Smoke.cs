using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Smoke : Bounce
{
    [SerializeField] ParticleSystem smoke;
    protected override float _pushForce => 10f;

    private void Update()
    {
        PlaySmokeEffect();
    }

    private void OnTriggerEnter(Collider other)
    {
        base.OnTriggerEnter(other);
        /*if (other.CompareTag("Player"))
        {
            Debug.Log("Player enter!");

            Rigidbody playerRigidbody = other.GetComponent<Rigidbody>();

            if (playerRigidbody != null)
            {
                Debug.Log("Player has Rigidbody!");
                Vector3 pushDirection = -other.transform.forward;

                playerRigidbody.AddForce(pushDirection * pushForce, ForceMode.Impulse);
            }
        }*/
    }

    private void PlaySmokeEffect()
    {
        // Play smoke effect
    }

    // Stop smoke effect
    public void StopEject()
    {

    }

}
