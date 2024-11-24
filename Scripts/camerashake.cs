using Godot;
using System;
using static Godot.OpenXRInterface;

public partial class camerashake : Camera2D
{
    //Noise Setup to Shake Camera
    private FastNoiseLite noise = new FastNoiseLite();
    //private float noiseShake = 40f;
    private RandomNumberGenerator rand = new RandomNumberGenerator();
    private float noiseI = 0;
    private float shakeStrength = 0f;
    private float shakeDecay = 5f;
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
	{
        noise.Seed = (int)rand.Randi();
    }

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
        //Shake Camera
        shakeStrength = Mathf.Lerp(shakeStrength, 0, (float)(shakeDecay * delta));
        if (shakeStrength < 0) shakeStrength = 0;
        Offset = GetNoiseOffset((float)delta);
    }
    public Vector2 GetNoiseOffset(float delta)
    {
        noiseI += shakeStrength;
        return new Vector2(noise.GetNoise2D(1, noiseI) * shakeStrength, noise.GetNoise2D(100, noiseI) * shakeStrength);
    }

    public void ApplyShake(float noiseShake)
    {
        shakeStrength = noiseShake;
    }
}
