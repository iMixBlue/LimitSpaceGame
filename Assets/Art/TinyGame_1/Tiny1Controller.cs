using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UIElements;
using UnityStandardAssets._2D;

public class ObservableQueue<T> : Queue<T>
{
    
    // 定义事件，用于元素被加入队列时触发
    public event Action<T> OnEnqueue;

    // 重写Enqueue方法，在加入新元素时触发事件
    public new void Enqueue(T item)
    {
        base.Enqueue(item);
        OnEnqueue?.Invoke(item);
    }
}
public class Tiny1Controller : MonoBehaviour
{
    public Tiny1UIManager uiManager;
    public float moveSpeed = 5f;
    ObservableQueue<Vector3> moveDirections;
    private Vector3 currentDirection = Vector3.zero;
    private int inputCount = 0;
    private const int maxInputCount = 4;
    private bool isMoving = false;
    public GameObject SmallGamer;
    public GameObject SmallGamerCanvas;
    public GameObject GunFFF;
    private Vector3 position;
    private Vector3 rotation;
    public bool canDisplaySeq9 = false;
    [SerializeField] AudioSource _coinAudio;

    private void Start()
    {
        position = transform.position;
        rotation = transform.rotation.eulerAngles;
        moveDirections = new ObservableQueue<Vector3>();
        moveDirections.OnEnqueue += UpdateArrowUI;
    }
      void UpdateArrowUI(Vector3 direction)
    {
        int inputCount = moveDirections.Count - 1; // 获取当前输入的索引
        if (inputCount >= 0 && inputCount < uiManager.arrowImages.Length)
        {
            Sprite arrowSprite = null;

            // 确定使用哪个箭头素材
            if (direction == Vector3.forward) arrowSprite = uiManager.leftArrow;
            else if (direction == Vector3.back) arrowSprite = uiManager.rightArrow;
            else if (direction == Vector3.left) arrowSprite = uiManager.downArrow;
            else if (direction == Vector3.right) arrowSprite = uiManager.upArrow;

            // 更新UI
            if (arrowSprite != null)
            {
                Color newColor = uiManager.arrowImages[inputCount].color;
                newColor.a = 255;
                uiManager.arrowImages[inputCount].color = newColor;
                uiManager.arrowImages[inputCount].sprite = arrowSprite;
            }
        }
    }
    public void Restart(){
        Sprite arrowSprite = null;
        isMoving = false;
        inputCount = 0;
        moveDirections.Clear();
        for(int i=0; i<4;i++){
                Color newColor = uiManager.arrowImages[i].color;
                newColor.a = 0;
                uiManager.arrowImages[i].color = newColor;
                uiManager.arrowImages[i].sprite = arrowSprite;
        }
        transform.position = position;
        transform.rotation = Quaternion.Euler(rotation);

    }

    void Update()
    {
        if(Input.GetKeyDown(KeyCode.R)){
            Restart();
        }

        if (inputCount < maxInputCount)
        {
            if (Input.GetKeyDown(KeyCode.W)) { moveDirections.Enqueue(Vector3.right); inputCount++; }
            if (Input.GetKeyDown(KeyCode.A)) { moveDirections.Enqueue(Vector3.forward); inputCount++; }
            if (Input.GetKeyDown(KeyCode.S)) { moveDirections.Enqueue(Vector3.left); inputCount++; }
            if (Input.GetKeyDown(KeyCode.D)) { moveDirections.Enqueue(Vector3.back); inputCount++; }
        }

        if (inputCount == maxInputCount && !isMoving)
        {
            if (moveDirections.Count > 0)
            {
                currentDirection = moveDirections.Dequeue();
                isMoving = true;
            }
        }

        if (isMoving)
        {
            transform.Translate(currentDirection * moveSpeed * Time.deltaTime);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
         if (other.gameObject.tag == "Tiny1Wall" && moveDirections.Count > 0)
            {
                // 改变移动方向
                Debug.Log(1);
                currentDirection = moveDirections.Dequeue();
            }
        if (other.gameObject.tag == "Tiny1End")
        {
            GunFFF.GetComponent<GunFFF>().have3Gold = true;
            // 游戏胜利
            uiManager.winText.GetComponent<TMP_Text>().text = "   You Win !";
            canDisplaySeq9 = true;
            // Time.timeScale = 0;
            try{
                _coinAudio.Play();
                SmallGamer.GetComponent<SmallGamer>().ThirdpersonFollowCamera.SetActive(true);
                SmallGamer.GetComponent<SmallGamer>().MainCamera.gameObject.SetActive(true);
                SmallGamer.GetComponent<SmallGamer>().SmallGamerCamera.SetActive(false);
                SmallGamer.GetComponent<SmallGamer>()._player.SetActive(true);
                SmallGamer.GetComponent<SmallGamer>().gamerCharacter.GetComponent<Tiny1Controller>().enabled = false;
                SmallGamer.GetComponent<SmallGamer>().once = true;
                SmallGamer.GetComponent<SmallGamer>().RestartText.SetActive(false);
                SmallGamer.GetComponent<SmallGamer>().enabled = false;
                SmallGamer.transform.GetChild(0).GetChild(0).gameObject.SetActive(false);
                SmallGamerCanvas.SetActive(false);
            }catch{}
            // Debug.Log("You Win!");
        }
    }
}

