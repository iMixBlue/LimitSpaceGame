// using UnityEngine;
// using UnityEditor;

// public class ChangeChildrenTagsEditor : EditorWindow
// {
//     string newTag = "Untagged";

//     [MenuItem("Tools/Change Children Tags")]
//     public static void ShowWindow()
//     {
//         GetWindow(typeof(ChangeChildrenTagsEditor));
//     }

//     void OnGUI()
//     {
//         newTag = EditorGUILayout.TagField("New Tag:", newTag);

//         if (GUILayout.Button("Change Tags"))
//         {
//             ChangeTags();
//         }
//     }

//     void ChangeTags()
//     {
//         GameObject selectedObject = Selection.activeGameObject;

//         if (selectedObject != null)
//         {
//             foreach (Transform child in selectedObject.transform)
//             {
//                 child.gameObject.tag = newTag;
//             }
//         }
//         else
//         {
//             Debug.LogError("No object selected in the hierarchy");
//         }
//     }
// }
