using Godot;
using System;

public partial class pearlminigamemain : Node2D
{
    public Sprite2D pinca, pegador;
	public Vector2 targetPos, targetPosP;
	public bool pincag=false, pegadorg=false;
	public bool pLocked = false, pPicked = false;
	public Camera2D camera;
	public Area2D pearlarea, centerpearl;
	public Vector2 pearlpos;
	public bool colliding = false;
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
	{
		pinca = GetNode("pinca") as Sprite2D;
		pegador = GetNode("pegador") as Sprite2D;
		targetPos = new Vector2(pinca.Position.X, 800);
		targetPosP = new Vector2(pegador.Position.X, 800);
        camera = GetParent().GetNode("Camera2D") as Camera2D;
		pearlarea = GetNode("Oyster").GetNode("Area2D") as Area2D;
		pearlarea = GetNode("Oyster").GetNode("Area2D2") as Area2D;
		pearlpos = new Vector2(pearlarea.GlobalPosition.X - 200, pearlarea.GlobalPosition.Y);
        InitGame();
    }

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		
    }

    public override void _PhysicsProcess(double delta)
	{
		if (colliding)
		{
            Input.WarpMouse(pearlpos);
            camera.Call("ApplyShake", 20f);
        }

        if (!pLocked)
        {
            if (pincag)
            {
                pinca.Position = pinca.Position.MoveToward(GetGlobalMousePosition(), (float)(5000f * delta));
                pinca.Rotation = -Mathf.Pi / 2;
                targetPosP = new Vector2(576, 700);
            }
            else
            {
                pinca.Position = pinca.Position.MoveToward(targetPos, (float)(1000f * delta));
                pinca.Rotation = 0;
                targetPosP = new Vector2(676, 700);
            }
        }


        if (pegadorg)
        {
            pegador.Position = pegador.Position.MoveToward(GetGlobalMousePosition(), (float)(5000f * delta));
            pegador.Rotation = 0;
            if (!pLocked) targetPos = new Vector2(576, 600);
        }
        else
        {
            pegador.Position = pegador.Position.MoveToward(targetPosP, (float)(1000f * delta));
            pegador.Rotation = -1.3f;
            if (!pLocked) targetPos = new Vector2(476, 600);
        }


        if (Input.IsActionJustPressed("clickDir"))
        {
            pincag = false;
            pegadorg = false;
            if (!pLocked) pinca.Position = new Vector2(476, 800);
            pegador.Position = new Vector2(676, 900);
        }
    }


    public void pincaEvent(Vector2 position)
	{
		pLocked = true;
		pinca.Position = position;
		camera.Call("ApplyShake", 20f);
	}

	public void pegadorEvent()
	{
		pPicked = true;
	}

	public void InitGame()
	{
		Visible = true;
        targetPos = new Vector2(pinca.Position.X, 600);
        targetPosP = new Vector2(pegador.Position.X, 700);
    }

	public void pincaPressed()
	{
		pincag = true;
		pegadorg = false;
	}

	public void TweezersPressed()
	{
		pegadorg = true;
		pincag = false;
	}

	public void onArea2DEntered(Area2D area)
	{
		if (area.GetParent().Name == "pinca")
		{
			Vector2 contactPoint = new Vector2(pearlarea.GlobalPosition.X + 200, pearlarea.GlobalPosition.Y);
            pincaEvent(contactPoint);
		}
	}

	public void onArea2DEnteredPearl(Area2D area)
	{
		if(pLocked && area.GetParent().Name == "pegador")
		{
			pegadorEvent();
		}
	}

	public void onArea2dEnteredWall(Area2D area)
	{
		if(pPicked && pLocked && area.GetParent().Name == "pegador")
		{
			colliding = true;
        }
	}
	public void onArea2dExitedWall(Area2D area)
	{
        if (pPicked && pLocked && area.GetParent().Name == "pegador")
        {
            colliding = false;
        }
    }
}
