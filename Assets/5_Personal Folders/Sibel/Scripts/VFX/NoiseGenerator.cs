using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Clay
{
    public class NoiseGenerator : MonoBehaviour
    {
        [SerializeField] float noiseScale = 1f;
        [SerializeField] float amplitude = 5f;
        [SerializeField] float frequency = 0.005f;
        [SerializeField] int octaves = 8;
        [SerializeField, Range(0f, 1f)] float groundPercent = 0.2f;
        ComputeBuffer _weightsBuffer;
        public ComputeShader NoiseShader;
        
        private void Awake() {
            CreateBuffers();
        }
        private void OnDestroy() {
            ReleaseBuffers();
        }

        void CreateBuffers() {
            _weightsBuffer = new ComputeBuffer(
                GridMetrics.PointsPerChunk * GridMetrics.PointsPerChunk * GridMetrics.PointsPerChunk, sizeof(float)
            );
        }

        void ReleaseBuffers() {
            _weightsBuffer.Release();
        }
        
        public float[] GetNoise() {
            float[] noiseValues =
                new float[GridMetrics.PointsPerChunk * GridMetrics.PointsPerChunk * GridMetrics.PointsPerChunk];

            NoiseShader.SetBuffer(0, "_Weights", _weightsBuffer);

            NoiseShader.SetInt("_ChunkSize", GridMetrics.PointsPerChunk);
            NoiseShader.SetFloat("_NoiseScale", noiseScale);
            NoiseShader.SetFloat("_Amplitude", amplitude);
            NoiseShader.SetFloat("_Frequency", frequency);
            NoiseShader.SetInt("_Octaves", octaves);
            NoiseShader.SetFloat("_GroundPercent", groundPercent);


            NoiseShader.Dispatch(
                0, GridMetrics.PointsPerChunk / GridMetrics.NumThreads, GridMetrics.PointsPerChunk / GridMetrics.NumThreads, GridMetrics.PointsPerChunk / GridMetrics.NumThreads
            );

            _weightsBuffer.GetData(noiseValues);

            return noiseValues;
        }
    }
}