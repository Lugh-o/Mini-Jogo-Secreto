using Godot;
using System;
using System.Net.NetworkInformation;

public partial class Interactables : Node2D
{
	private PackedScene pearlGameScene;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
        pearlGameScene = GD.Load<PackedScene>("res://scenes/pearl_minigame/pearl_minigame.tscn");
    }

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{

	}

    public void OnPearlClicked()
	{
        GetTree().ChangeSceneToPacked(pearlGameScene);
    }
}
