/*using UnityEngine;
using UnityEditor;

public class ChangeChildrenTagsEditor : EditorWindow
{
    string newTag = "Untagged";

    [MenuItem("Tools/Change Children Tags")]
    public static void ShowWindow()
    {
        GetWindow(typeof(ChangeChildrenTagsEditor));
    }

    void OnGUI()
    {
        newTag = EditorGUILayout.TagField("New Tag:", newTag);

        if (GUILayout.Button("Change Tags"))
        {
            ChangeTags();
        }
    }

    void ChangeTags()
    {
        GameObject selectedObject = Selection.activeGameObject;

        if (selectedObject != null)
        {
            ChangeTagsRecursive(selectedObject.transform, newTag);
        }
        else
        {
            Debug.LogError("No object selected in the hierarchy");
        }
    }

    void ChangeTagsRecursive(Transform parent, string tag)
    {
        parent.gameObject.tag = tag; // Change tag of the current object

        foreach (Transform child in parent)
        {
            ChangeTagsRecursive(child, tag); // Recursively change tags for children
        }
    }
}
*/