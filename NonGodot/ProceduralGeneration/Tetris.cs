using Godot;
using System;

public class Tetris : TileMap
{
    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";
    private PackedScene lightTileScene = (PackedScene)ResourceLoader.Load("res://Scenes/Level_components/light_tile.tscn");
    private string a = "test";
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        //this.set_cellv(new Vector2(-4,-4), 2);
        string a = "test";
        c_array_to_tiles([1,2,1,3]);

    }


    public Color c_index_to_color(int c_index)
    {
        GD.Seed((ulong)c_index);
        //GD.Print(c_index,(ulong)c_index);
        float r = GD.Randf(), g = GD.Randf(), b = GD.Randf();
        float m = GD.Randf()>0.5 ? Math.Min(1/r,Math.Min(1/g,1/b)) : 1;
        return new Color(m*r,m*g,m*b);
    }


    public void add_colored_tile(int x, int y, int c_index, int tileSize = 16)
    {
        Node2D newTile = (Node2D)lightTileScene.Instance();
        newTile.Modulate = c_index_to_color(c_index);
        newTile.Position = new Vector2(x*tileSize, y*tileSize);
        AddChild(newTile);
    }


    public void color_sample()
    {
        for (int i = 0; i < 100; i++)
        {
            add_colored_tile(-i%19,-i/19,i);
        }
    }

    public class TetrisTile
    {
        int test;
    }

    public void c_array_to_tiles(Array[] tile)
    {

    }



//  public override void _Process(float delta)
}

class copy_placeholder
{

}
