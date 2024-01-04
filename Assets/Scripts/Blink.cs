using System.Collections;
using System.Collections.Generic;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Blink : MonoBehaviour
{
    private int count = 0;
    private int a = 0;
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    private void FixedUpdate()
    {
        count++;
        if (count > 10)
        {
            a++;
            if (a == 1)
            {
                GetComponent<TMP_Text>().color = new Color(1, 1, 1, 0.0f);

            }
            else
            {
                GetComponent<TMP_Text>().color = new Color(1, 1, 1, 1.0f);

            }
            if(a >=5){
                a = 0;
            }
            count = 0;
        }
    }
    private void Update() {
        if(Input.anyKeyDown){
            SceneManager.LoadScene(0);
        }
    }
}
