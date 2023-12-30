using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Smoke : Bounce
{
    [SerializeField] ParticleSystem _smoke;


    void Start()
    {
        StartCoroutine(PlayPauseCycle());
    }

    IEnumerator PlayPauseCycle()
    {
        while (true)
        {
            _smoke.Play();
            GetComponent<BoxCollider>().enabled = true;
            yield return new WaitForSeconds(1f);

            _smoke.Stop();
            GetComponent <BoxCollider>().enabled = false;
            yield return new WaitForSeconds(1f);
        }
    }

    public void StopSmoke()
    {
        StopCoroutine(PlayPauseCycle());
    }

}
