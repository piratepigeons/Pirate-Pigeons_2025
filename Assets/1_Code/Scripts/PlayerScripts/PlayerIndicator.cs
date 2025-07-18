using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerIndicator : MonoBehaviour
{
    [SerializeField]
    private Transform targetObject;
    [SerializeField]
    private GameObject arrowVisuals;

    [SerializeField]
    private float arrowVisualsGrowSpeed;

    [SerializeField]
    private LeanTweenType arrowTweenType;

    private Vector3 targetViewportPosition;
    bool isObjectVisible;
    public bool showArrow = true;
    Vector2 screenCenter;
    Vector2 targetScreenPosition;
    Vector2 arrowDirection;
    Vector2 arrowPosition;


    [SerializeField]
    private float padding = 50f;
    float minX;
    float maxX;
    float minY;
    float maxY;

    float distanceToEdge;
    float angle;
    Quaternion targetRotation;

    bool enableState;
    bool disableState;

    Vector3 graphicStartScale;

    public GameObject playerArrowGraphic;
    public GameObject playerDeathGraphic;

    private void Start()
    {
        if(targetObject == null)
        {
            targetObject = GameObject.FindGameObjectWithTag("Player").transform;
        }
        screenCenter = new Vector2(Screen.width, Screen.height) * 0.5f;
        enableState = false;
        disableState = false;
        graphicStartScale = arrowVisuals.transform.localScale;
        SetDeathGraphic(false);
    }
    void Update()
    {




        targetViewportPosition = Camera.main.WorldToViewportPoint(targetObject.position);

        isObjectVisible = targetViewportPosition.x > 0 && targetViewportPosition.x < 1
            && targetViewportPosition.y > 0 && targetViewportPosition.y < 1 && targetViewportPosition.z > 0;

        if (!isObjectVisible && showArrow)
        {
            targetScreenPosition = Camera.main.WorldToScreenPoint(targetObject.position);

            arrowDirection = ((Vector2)targetScreenPosition - screenCenter).normalized;

            minX = padding;
            maxX = Screen.width - padding;
            minY = padding;
            maxY = Screen.height - padding;

            arrowPosition = targetScreenPosition;

            // Check if the arrow is outside the screen boundaries
            if (targetScreenPosition.x < minX || targetScreenPosition.x > maxX || targetScreenPosition.y < minY || targetScreenPosition.y > maxY)
            {
                // Clamp the arrow position to the nearest screen edge
                arrowPosition.x = Mathf.Clamp(arrowPosition.x, minX, maxX);
                arrowPosition.y = Mathf.Clamp(arrowPosition.y, minY, maxY);
            }
            else
            {
                // Calculate the arrow position along the screen edge
                distanceToEdge = Mathf.Min(targetScreenPosition.x - minX, maxX - targetScreenPosition.x, targetScreenPosition.y - minY, maxY - targetScreenPosition.y);
                arrowPosition += arrowDirection * distanceToEdge;
            }

            transform.position = arrowPosition;

            angle = Mathf.Atan2(arrowDirection.y, arrowDirection.x) * Mathf.Rad2Deg;
            targetRotation = Quaternion.Euler(0f, 0f, angle);

            transform.rotation = targetRotation;
            if (!enableState)
            {
                enableState = true;
                EnableVisuals();
            }

        }
        else
        {
            if (!disableState)
            {
                disableState = true;
                DisableVisuals();
            }
        }
    }


    void EnableVisuals()
    {
        disableState = false;
        LeanTween.scale(arrowVisuals, graphicStartScale, arrowVisualsGrowSpeed).setEase(arrowTweenType);
        // Show the arrow indicator
        arrowVisuals.SetActive(true);
    }

    void DisableVisuals()
    {
        enableState = false;
        // Hide the arrow indicator if the object is visible

        LeanTween.scale(arrowVisuals, Vector3.zero, arrowVisualsGrowSpeed).setEase(arrowTweenType);

        LeanTween.delayedCall(arrowVisualsGrowSpeed, DelayedDisable);

    }

    void DelayedDisable()
    {
        arrowVisuals.SetActive(false);
    }


    void SetDeathGraphic(bool state)
    {
        playerDeathGraphic.SetActive(state);
        playerArrowGraphic.SetActive(!state);
    }
    public void ShowDeathGraphic()
    {
        StartCoroutine(DelayedDeathGraphic());
    }

    IEnumerator DelayedDeathGraphic()
    {
        SetDeathGraphic(true);
        yield return new WaitForSeconds(2f);
        DisableVisuals();
        yield return new WaitForSeconds(1f);
        SetDeathGraphic(false);
    }

}
