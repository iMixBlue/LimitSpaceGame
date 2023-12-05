using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalCamera : MonoBehaviour
{
    public Transform playerCamera;
    public Transform portal;
    public Transform otherPortal;

    private void Update()
    {
        Vector3 playerOffestFromPortal = playerCamera.position - otherPortal.position;
        transform.position = portal.position + playerOffestFromPortal;

        float angularDifferenceBetweenPortalRotations = Quaternion.Angle(portal.rotation, otherPortal.rotation);

        Quaternion portalRotationalDifference = Quaternion.AngleAxis(angularDifferenceBetweenPortalRotations, Vector3.up);
        Vector3 newCameraDirection = portalRotationalDifference * (playerCamera.forward);
        Vector3 upDirection = portalRotationalDifference * playerCamera.up;
        transform.rotation = Quaternion.LookRotation(newCameraDirection, Vector3.up);
    }
}
