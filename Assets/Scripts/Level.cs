using System;
using UnityEngine;

public class Level : MonoBehaviour
{
    [SerializeField] int pointsPerLevel = 200;
    int experiencePonts = 0;

    public event Action onLevelUpAction;
    public event Action onExperienceChanged;

    public void GainExperience (int ponts)
    {
        int level = GetLevel();
        experiencePonts += ponts;
        if (onExperienceChanged != null)
        {
            onExperienceChanged();
        }
        if (GetLevel() > level)
        {
            if (onLevelUpAction != null)
            {
                onLevelUpAction();
            }
        }
    }

    public int GetExperience()
    {
        return experiencePonts;
    }

    public int GetLevel()
    {
        return (experiencePonts / pointsPerLevel) + 1;
    }
}
