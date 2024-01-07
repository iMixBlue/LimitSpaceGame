using System.Collections;
using System.Collections.Generic;
using StarterAssets;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityStandardAssets.Characters.ThirdPerson;

public class MyUIManager : MonoBehaviour
{
    public GameObject StopMenu;
    private bool stopMenuBool = false;
    public GameObject player;
    // Start is called before the first frame update
    void Start()
    {
        Time.timeScale = 1;
        stopMenuBool = false;
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;
    }

    // Update is called once per frame

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            stopMenuBool = !stopMenuBool;
            if (stopMenuBool)
            {
                Time.timeScale = 0;
                Cursor.lockState = CursorLockMode.None;
            }
            else
            {
                Time.timeScale = 1;
                Cursor.lockState = CursorLockMode.Locked;
            }
            Cursor.visible = stopMenuBool;
            player.GetComponent<ThirdPersonController>().enabled = !stopMenuBool;
            StopMenu.SetActive(stopMenuBool);
        }
    }
    public void ReloadScene()
    {
        Time.timeScale = 1;
        SceneManager.LoadScene(1);
    }
    public void ReturnStartMenu(){
        Time.timeScale = 1;
        SceneManager.LoadScene(0);
    }
}
