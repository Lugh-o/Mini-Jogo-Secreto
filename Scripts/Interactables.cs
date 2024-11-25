using Godot;
using System;
using System.Net.NetworkInformation;

public partial class Interactables : Node2D
{
	private PackedScene pearlGameScene;
	private PackedScene pearlCleaningScene;
	private PackedScene pearlShopScene;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
        pearlGameScene = GD.Load<PackedScene>("res://scenes/pearl_harvesting/pearl_harvesting.tscn");
		pearlCleaningScene = GD.Load<PackedScene>("res://scenes/pearl_cleaning/pearl_cleaning.tscn");
		pearlShopScene = GD.Load<PackedScene>("res://scenes/pearl_shop/pearl_shop.tscn");
    }

    public void OnPearlClicked()
	{
        GetTree().ChangeSceneToPacked(pearlGameScene);
    }

	public void OnPearlCleaningClicked()
	{
		GetTree().ChangeSceneToPacked(pearlCleaningScene);
	}

	public void OnPearlShopClicked()
	{
		GetTree().ChangeSceneToPacked(pearlShopScene);
	}
}
