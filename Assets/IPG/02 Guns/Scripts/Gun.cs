using Cinemachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IPG.Lecture02
{
    public class Gun : MonoBehaviour
    {
        [Header("Bullet")]
        public Transform FirePoint;
        public Bullet BulletPrefab;

        [Header("Reload")]
        [Range(0, 5)]
        public float ReloadTime; // seconds
        private float ReloadTimer; // seconds
        

        [Space]
        [Range(0, 50)]
        public float BulletSpeed; // m/s

        [Header("Sound")]
        public AudioSource AudioSource;
        public AudioClip ClipShooting;
        public AudioClip ClipCocking;

        [Header("Screenshake")]
        public CinemachineImpulseSource Impulse;

        // Update is called once per frame
        void Update()
        {
            ReloadTimer -= Time.deltaTime;

            // Mouse pressed
            if (Input.GetMouseButtonDown(0))
            {
                // Gun not ready to shoot yet
                if (ReloadTimer > 0)
                {
                    AudioSource.PlayOneShot(ClipCocking);
                    return;
                }

                // Starts reloading
                ReloadTimer = ReloadTime;

                // Shoot!
                Bullet bullet = Instantiate(BulletPrefab, FirePoint.position, FirePoint.rotation);
                bullet.Speed = BulletSpeed;

                // Sound
                AudioSource.PlayOneShot(ClipShooting);

                // Screenshake
                Impulse.GenerateImpulse();
            }
        }
    }
}