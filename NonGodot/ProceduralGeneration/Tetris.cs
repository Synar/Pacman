using Godot;
using System;
using System.Collections.Generic;

public class Tetris : TileMap
{
    private PackedScene lightTileScene = (PackedScene)ResourceLoader.Load("res://Scenes/Level_components/light_tile.tscn");
    private string a = "test";
    // Called when the node enters the scene tree for the first time.
    private TetrisTile[,] test_map;
    private Dictionary<int, int> colorCount = new Dictionary<int, int>();
    private Random rnd = new Random();

    public override void _Ready()
    {
        //this.set_cellv(new Vector2(-4,-4), 2);
        test_map = new TetrisTile[10,10];
        for (int i = 0; i < test_map.GetLength(0); i += 1)
        {
            for (int j = 0; j < test_map.GetLength(1); j += 1)
            {
                TetrisTile tile = new TetrisTile(this, i-10, j-10);
                test_map[i, j] = tile;
                if (colorCount.ContainsKey(tile.c_index))
                {
                    colorCount[tile.c_index] += 1;
                }
                else
                {
                    colorCount.Add(tile.c_index, 1);
                }
            }
        }


        for (int k = 0; k < 350; k += 1)
        {
            int i1 = rnd.Next(0,test_map.GetLength(0)), i2 = rnd.Next(0,test_map.GetLength(0));
            int j1 = rnd.Next(0,test_map.GetLength(1)), j2 = rnd.Next(0,test_map.GetLength(1));
            try_swap (test_map, i1, j1, i2, j2, false);
        }
        for (int k = 0; k < 100; k += 1)
        {
            int i1 = rnd.Next(0,test_map.GetLength(0)), i2 = rnd.Next(0,test_map.GetLength(0));
            int j1 = rnd.Next(0,test_map.GetLength(1)), j2 = rnd.Next(0,test_map.GetLength(1));
            try_swap (test_map, i1, j1, i2, j2, false);
        }

        foreach (TetrisTile tile in test_map)
        {
            tile.show();
        }
        //color_sample();


        //c_array_to_tiles(new TetrisTile[] {new TetrisTile(1),new TetrisTile(1),new TetrisTile(1),new TetrisTile(1)});
        //List<List<TetrisTile>> listijozerji = new List<List<TetrisTile>> {new List,}
    }


    public void _input(InputEvent Event)
    {
        if (Event.IsActionPressed("escape_menu"))
        {
            GD.Print("i fozej");
            for (int k = 0; k < 10; k += 1)
            {
                int i1 = rnd.Next(0,test_map.GetLength(0)), i2 = rnd.Next(0,test_map.GetLength(0));
                int j1 = rnd.Next(0,test_map.GetLength(1)), j2 = rnd.Next(0,test_map.GetLength(1));
                try_swap (test_map, i1, j1, i2, j2, true);
            }

            foreach (TetrisTile tile in test_map)
            {
                tile.show();
            }
        }
    }


    public void try_swap(TetrisTile[,] tmap, int i, int j, int i2, int j2, bool test)
    {
        int nx = tmap.GetLength(0);
        int ny = tmap.GetLength(1);
        if (i >= nx || i2 >= nx || j >= ny || j2 >= ny || i < 0 || i2 < 0 || j < 0 || j2 < 0) return;

        int p1_c_index = tmap[i,j].c_index;
        int p2_c_index = tmap[i2,j2].c_index;
        double p1 = calc_prob(p1_c_index), p2 = calc_prob(p2_c_index);
        //GD.Print(rnd.NextDouble(), "  ", p2, "  ", p1, "  ", p2/p1);
        //void swap(i,j,i2,j2)
        colorCount[p1_c_index] -= 1;
        colorCount[p2_c_index] += 1;
        tmap[i,j].c_index = p2_c_index;
        //swap(i,j,i2,j2);
        double p1_post = calc_prob(p1_c_index), p2_post = calc_prob(p2_c_index);
        if (test) GD.Print("p2: ", p2, "  p1: ", p1, "  p1_post: ", p1_post, "  p2_post: ", p2_post, " p1_post/p1: ", p1_post/p1, " p2_post/p2: ", p2_post/p2);
        if (!(rnd.NextDouble() < p1_post/p1) || !(rnd.NextDouble() < p2_post/p2)) //(p2 > p1)
        {
            if (test) GD.Print("failure");
            colorCount[p1_c_index] += 1;
            colorCount[p2_c_index] -= 1;
            tmap[i,j].c_index = p1_c_index;
        }
    }


    public double calc_prob(int c_index)//(TetrisTile[,] tmap, int i, int j)
    {
        //new Dictionary<int, int>
        switch (colorCount[c_index])
        {
            case 0: return 1;
            case 1: return 0.0005;
            case 2: return 0.01;
            case 3: return 0.2;
            case 4: return 0.8;
            case 5: return 0.1;
            default: return 0.0000000000001;
        }
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
        public int x, y, c_index;
        Tetris parent;
        public TetrisTile(Tetris parent_, int x_, int y_, int c_index_ = -1)
        {
            parent = parent_;
            x = x_;
            y = y_;
            c_index = (c_index_ != -1) ? c_index_ : (x+y) * (x+y+1) /2 + x;
        }

        public void show()
        {
            parent.add_colored_tile(x, y, c_index);
        }
    }


    public class TetrisMap
    {
        int test;
        public TetrisMap(int i)
        {
            test = i;
        }


    }


    public void c_array_to_tiles(TetrisTile[] tiles)
    {
        foreach (TetrisTile tile in tiles)
        {

        }
    }



//  public override void _Process(float delta)
}

class copy_placeholder
{

}
