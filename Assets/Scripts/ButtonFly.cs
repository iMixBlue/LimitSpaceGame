using UnityEngine;

public class ButtonFly : MonoBehaviour
{
    public float amplitude = 0.5f; // 浮动的幅度
    public float frequency = 1f; // 浮动的频率

    private Vector3 startPos;

    void Start()
    {
        this.amplitude = Random.Range(0.13f, 0.15f);
        this.frequency = Random.Range(0.2f, 0.3f);
        startPos = transform.position;
    }

    void Update()
    {
             float tempPos = amplitude * Mathf.Sin(Time.time * Mathf.PI * frequency);
             transform.position = startPos + Vector3.up * tempPos;
        // 计算上下浮动的新位置
       
    }
}
