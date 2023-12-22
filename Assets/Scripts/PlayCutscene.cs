using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;

public class PlayCutscene : MonoBehaviour
{
    [SerializeField] PlayableDirector _director;
    [SerializeField] RetrieveArea retrieveArea;

    private void Start()
    {
        retrieveArea.OnItemGetAction += _director.Play;
    }
}
