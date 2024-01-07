using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeController : MonoBehaviour
{
    [SerializeField] Animator _animator;
    [SerializeField] RuntimeAnimatorController _controller;

    public void SetController()
    {
        _animator.runtimeAnimatorController = _controller;
    }
}
