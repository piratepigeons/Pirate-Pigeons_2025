using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MultipleShapekeyManipulator : MonoBehaviour
{
    public SkinnedMeshRenderer[] smrs;
    public AnimationCurve Curve;
    public AnimationCurve specialCurve;
    float shapekeyValue;
    float currentAnimCurveValue;
    public float speed = 5f;
    public int shapeKeyToManipulate = 0;

    bool playingSpecialAnimation;

    float timeElapsed;
    float lerpDuration = 0.2f;
    //float startValue = 0;
    //float endValue = 10;
    float valueToLerp;
    public void PlayAnimation(int value, float durationTime)
    {
        shapekeyValue = value;
        lerpDuration = durationTime;
    }

    public void PlaySpecialAnimation(int value, float durationTime)
    {
        playingSpecialAnimation = true;
        shapekeyValue = value;
        lerpDuration = durationTime;
    }

    void Update()
    {
        if(playingSpecialAnimation)
        {

            PlayAnimation(specialCurve, true);
            return;
        }
        PlayAnimation(Curve, false);
        
        return;




        if (currentAnimCurveValue < shapekeyValue)
        {
            shapekeyValue -= (speed * 100) * Time.deltaTime;
            currentAnimCurveValue = Curve.Evaluate(shapekeyValue / 100) * 100;
            foreach (SkinnedMeshRenderer s in smrs)
            {
                s.SetBlendShapeWeight(shapeKeyToManipulate, currentAnimCurveValue);
            }

        }

    }


    void PlayAnimation(AnimationCurve curve, bool isSpecial)
    {
        if (Mathf.Abs(shapekeyValue - currentAnimCurveValue) >= 0.1f)
        {

            currentAnimCurveValue = Mathf.Lerp(currentAnimCurveValue, shapekeyValue, timeElapsed / lerpDuration);
            timeElapsed += Time.deltaTime;

            valueToLerp = curve.Evaluate(currentAnimCurveValue / 100) * 100;
            //currentAnimCurveValue = Mathf.Lerp(shapekeyValue, currentAnimCurveValue, Time.deltaTime*speed);
            foreach (SkinnedMeshRenderer s in smrs)
            {
                s.SetBlendShapeWeight(shapeKeyToManipulate, valueToLerp);
            }
        }

        else
        {
            if (isSpecial)
            {
                playingSpecialAnimation = false;
            }
            timeElapsed = 0;
            valueToLerp = shapekeyValue;
        }
    }
}
