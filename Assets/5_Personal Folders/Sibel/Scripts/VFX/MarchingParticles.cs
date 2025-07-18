using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

namespace Clay
{
    //[ExecuteInEditMode]
    public class MarchingParticles : MonoBehaviour
    {
        bool smoothRender = true;
        //bool flatShaded;

        MeshFilter meshFilter;
        MeshCollider meshCollider;

        public float particleSurface = 0.5f;
        public int width = 32;
        public int height = 8;
        float[,,] particleFloats;

        List<Vector3> vertices = new List<Vector3>();
        List<int> triangles = new List<int>();

        private void Start()
        {
            meshFilter = GetComponent<MeshFilter>();
            meshCollider = GetComponent<MeshCollider>();
            //transform.tag = "VFX";
            particleFloats = new float[width + 1, height + 1, width + 1];
            PopulateNoise();
            CreateMeshData();

        }

        private void Update()
        {
            if (Input.GetKeyDown(KeyCode.Space))
            {
                PopulateNoise();
                CreateMeshData();
            }
        }

        void CreateMeshData()
        {
            ClearMeshData();
            
            for (int x = 0; x < width; x++)
            {
                for (int y = 0; y < height; y++)
                {
                    for (int z = 0; z < width; z++)
                    {

                        MarchCube(new Vector3Int(x, y, z));

                    }
                }
            }

            BuildMesh();

        }
        void PopulateNoise()
        {
            for (int x = 0; x < width + 1; x++)
            {
                for (int z = 0; z < width + 1; z++)
                {
                    for (int y = 0; y < height + 1; y++)
                    {

                        // Get a terrain height using regular old Perlin noise.
                        float thisHeight = (float)height * Mathf.PerlinNoise((float)x / 16f * 1.5f + 0.001f,
                            (float)z / 16f * 1.5f + 0.001f);

                        // Set the value of this point in the terrainMap.
                        particleFloats[x, y, z] = (float)y - thisHeight;

                    }
                }
            }
        }

        void MarchCube(Vector3Int position)
        {
            //sample values at each corner of the cube
            float[] cube = new float[8];
            for (int i = 0; i < 8; i++)
            {

                cube[i] = SampleNoise(position + MarchingUtils.CornerTable[i]);

            }

            // Get the configuration index of this cube.
            int configIndex = GetCubeConfiguration(cube);

            // If the configuration of this cube is 0 or 255 (completely inside the terrain or completely outside of it) we don't need to do anything.
            if (configIndex == 0 || configIndex == 255)
                return;

            // Loop through the triangles. There are never more than 5 triangles to a cube and only three vertices to a triangle.
            int edgeIndex = 0;
            for (int i = 0; i < 5; i++)
            {
                for (int p = 0; p < 3; p++)
                {

                    // Get the current indice. We increment triangleIndex through each loop.
                    int indice = MarchingUtils.TriangleTable[configIndex, edgeIndex];

                    // If the current edgeIndex is -1, there are no more indices and we can exit the function.
                    if (indice == -1)
                        return;

                    // Get the vertices for the start and end of this edge.
                    Vector3 vert1 = position + MarchingUtils.CornerTable[MarchingUtils.EdgeIndexes[indice, 0]];
                    Vector3 vert2 = position + MarchingUtils.CornerTable[MarchingUtils.EdgeIndexes[indice, 1]];

                    Vector3 vertPosition;
                    if (smoothRender)
                    {

                        // Get the terrain values at either end of our current edge from the cube array created above.
                        float vert1Sample = cube[MarchingUtils.EdgeIndexes[indice, 0]];
                        float vert2Sample = cube[MarchingUtils.EdgeIndexes[indice, 1]];

                        // Calculate the difference between the terrain values.
                        float difference = vert2Sample - vert1Sample;

                        // If the difference is 0, then the terrain passes through the middle.
                        if (difference == 0)
                            difference = particleSurface;
                        else
                            difference = (particleSurface - vert1Sample) / difference;

                        // Calculate the point along the edge that passes through.
                        vertPosition = vert1 + ((vert2 - vert1) * difference);


                    }
                    else
                    {

                        // Get the midpoint of this edge.
                        vertPosition = (vert1 + vert2) / 2f;

                    }
/*
                    if (flatShaded)
                    {

                        vertices.Add(vertPosition);
                        triangles.Add(vertices.Count - 1);

                    }
                    else*/
                        triangles.Add(VertForIndice(vertPosition));

                    edgeIndex++;

                }
            }
        }

        int GetCubeConfiguration(float[] cube)
        {

            // Starting with a configuration of zero, loop through each point in the cube and check if it is below the terrain surface.
            int configurationIndex = 0;
            for (int i = 0; i < 8; i++)
            {

                // If it is, use bit-magic to the set the corresponding bit to 1. So if only the 3rd point in the cube was below
                // the surface, the bit would look like 00100000, which represents the integer value 32.
                if (cube[i] > particleSurface)
                    configurationIndex |= 1 << i;

            }

            return configurationIndex;

        }

        public void PlaceTerrain(Vector3 pos)
        {

            Vector3Int v3Int = new Vector3Int(Mathf.CeilToInt(pos.x), Mathf.CeilToInt(pos.y), Mathf.CeilToInt(pos.z));
            particleFloats[v3Int.x, v3Int.y, v3Int.z] = 0f;
            CreateMeshData();

        }

        public void RemoveTerrain(Vector3 pos)
        {

            Vector3Int v3Int =
                new Vector3Int(Mathf.FloorToInt(pos.x), Mathf.FloorToInt(pos.y), Mathf.FloorToInt(pos.z));
            particleFloats[v3Int.x, v3Int.y, v3Int.z] = 1f;
            CreateMeshData();

        }

        float SampleNoise(Vector3Int point)
        {
            return particleFloats[point.x, point.y, point.z];
        }

        int VertForIndice(Vector3 vert)
        {

            // Loop through all the vertices currently in the vertices list.
            for (int i = 0; i < vertices.Count; i++)
            {
                // If we find a vert that matches ours, then simply return this index.
                if (vertices[i] == vert)
                    return i;
            }

            // If we didn't find a match, add this vert to the list and return last index.
            vertices.Add(vert);
            return vertices.Count - 1;

        }

        void ClearMeshData()
        {
            vertices.Clear();
            triangles.Clear();
        }

        void BuildMesh()
        {
            Mesh mesh = new Mesh();
            mesh.vertices = vertices.ToArray();
            mesh.triangles = triangles.ToArray();
            mesh.RecalculateNormals();
            meshFilter.mesh = mesh;
            meshCollider.sharedMesh = mesh;
        }

    }
}