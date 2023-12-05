using UnityEngine;
using UnityEditor;

public class TagSetter : EditorWindow
{
    [MenuItem("Tools/Set Tag to Player")]
    static void SetTagToPlayer()
    {
        foreach (GameObject obj in Selection.gameObjects)
        {
            SetTagRecursively(obj, "Player");
        }
    }

    static void SetTagRecursively(GameObject obj, string tag)
    {
        obj.tag = tag;
        foreach (Transform child in obj.transform)
        {
            SetTagRecursively(child.gameObject, tag);
        }
    }
}
