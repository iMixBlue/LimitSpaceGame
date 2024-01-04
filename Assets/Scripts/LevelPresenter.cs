using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class LevelPresenter : MonoBehaviour
{
    [SerializeField] Level level;
    [SerializeField] TextMeshProUGUI levelText;
    [SerializeField] TextMeshProUGUI experienceText;
    // Start is called before the first frame update
    void Start()
    {
        level.onExperienceChanged += UpdateUI;
        UpdateUI();
    }

    private void UpdateUI()
    {
        // levelText.text = $"Level: {level.GetLevel()}";
        experienceText.text = $"XP: {level.GetExperience()}";
    }
}
