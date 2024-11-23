using Godot;
using System;

public partial class pearlminigamemain : Node2D
{
    public Sprite2D pinca, pegador;
	public Vector2 targetPos, targetPosP;
	public bool pincag=false, pegadorg=false;
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
	{
		pinca = GetNode("pinca") as Sprite2D;
		pegador = GetNode("pegador") as Sprite2D;
		targetPos = new Vector2(pinca.Position.X, 800);
		targetPosP = new Vector2(pegador.Position.X, 800);
        InitGame();
    }

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (pincag)
		{
			pinca.Position = GetGlobalMousePosition();
			targetPosP = new Vector2(576, 600);
        }
		else
		{
            pinca.Position = pinca.Position.MoveToward(targetPos, (float)(1000f * delta));
            targetPosP = new Vector2(676, 600);
        }

		if (pegadorg)
		{
			pegador.Position = GetGlobalMousePosition();
            targetPos = new Vector2(576, 600);
        }
		else
		{
            pegador.Position = pegador.Position.MoveToward(targetPosP, (float)(1000f * delta));
            targetPos = new Vector2(476, 600);
        }
        

        if (Input.IsActionJustPressed("clickDir"))
		{
			pincag = false;
			pegadorg = false;
			pinca.Position = new Vector2(476, 800);
			pegador.Position = new Vector2(676, 800);

        }
    }

	public void InitGame()
	{
		Visible = true;
        targetPos = new Vector2(pinca.Position.X, 600);
        targetPosP = new Vector2(pegador.Position.X, 600);
    }

	public void pincaPressed()
	{
		pincag = true;
	}

	public void TweezersPressed()
	{
		pegadorg = true;
	}
}
