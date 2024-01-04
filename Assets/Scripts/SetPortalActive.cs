using System.Collections;
using System.Collections.Generic;
using Cinemachine;
using StarterAssets;
using UnityEngine;
using UnityStandardAssets.Characters.ThirdPerson;

public class SetPortalActive : MonoBehaviour
{
    public GameObject portalA;
    public GameObject portalB;
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "SmallPlayer" ||other.gameObject.tag == "Player")
        {
            portalA.transform.GetChild(0).gameObject.SetActive(true);
            portalA.transform.GetChild(1).gameObject.SetActive(true);
            portalB.transform.GetChild(0).gameObject.SetActive(true);
            portalB.transform.GetChild(1).gameObject.SetActive(true);
        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "SmallPlayer" || other.gameObject.tag == "Player")
        {
            portalA.transform.GetChild(0).gameObject.SetActive(false);
            portalA.transform.GetChild(1).gameObject.SetActive(false);
            portalB.transform.GetChild(0).gameObject.SetActive(false);
            portalB.transform.GetChild(1).gameObject.SetActive(false);
        }
    }

}
