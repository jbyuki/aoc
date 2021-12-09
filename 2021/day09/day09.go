package main

import (
  "fmt"
  "os"
  "bufio"
  "sort"
  "strconv"
)

type Pos struct {
  x int
  y int
}

func main() {
  heightmap := make([][]int, 0)

  f, _ := os.Open("input.txt")
  defer f.Close()

  s := bufio.NewScanner(f)
  for s.Scan() {
    row := make([]int, 0)
    raw := s.Text()
    for x := 0; x < len(raw); x++ {
      n,_ := strconv.Atoi(string(raw[x]))
      row = append(row, n)
    }
    heightmap = append(heightmap, row)
  }

  local_min := make([][]int, len(heightmap))
  for y := 0; y < len(heightmap); y++ {
    local_min[y] = make([]int, len(heightmap[y]))
  }

  for y := 0; y < len(heightmap); y++ {
    for x := 0; x < len(heightmap[y]); x++ {
      if x > 0 && heightmap[y][x-1] <= heightmap[y][x] {
        continue
      }

      if x < len(heightmap[y])-1 && heightmap[y][x+1] <= heightmap[y][x] {
        continue
      }

      if y > 0 && heightmap[y-1][x] <= heightmap[y][x] {
        continue
      }

      if y < len(heightmap)-1 && heightmap[y+1][x] <= heightmap[y][x] {
        continue
      }

      local_min[y][x] = 1
    }
  }

  found := make([][]int, len(heightmap))
  for y := 0; y < len(heightmap); y++ {
    found[y] = make([]int, len(heightmap[y]))
  }

  bassins := make([]int, 0)

  for y := 0; y < len(heightmap); y++ {
    for x := 0; x < len(heightmap[y]); x++ {
      if local_min[y][x] == 1 && found[y][x] == 0 {

        found[y][x] = 1

        open := make([]Pos, 0)
        open = append(open, Pos{x, y})
        
        bassin_size := 0

        for len(open) > 0 {
          cur := open[0]
          bassin_size++
          open = open[1:]

          if cur.x > 0 && found[cur.y][cur.x-1] == 0 && heightmap[cur.y][cur.x-1] < 9 {
            open = append(open, Pos{cur.x-1, cur.y})
            found[cur.y][cur.x-1] = 1
          } 
          
          if cur.x < len(heightmap[y])-1 && found[cur.y][cur.x+1] == 0 && heightmap[cur.y][cur.x+1] < 9 {
            open = append(open, Pos{cur.x+1, cur.y})
            found[cur.y][cur.x+1] = 1
          } 

          if cur.y > 0 && found[cur.y-1][cur.x] == 0 && heightmap[cur.y-1][cur.x] < 9 {
            open = append(open, Pos{cur.x, cur.y-1})
            found[cur.y-1][cur.x] = 1
          } 

          if cur.y < len(heightmap)-1 && found[cur.y+1][cur.x] == 0 && heightmap[cur.y+1][cur.x] < 9 {
            open = append(open, Pos{cur.x, cur.y+1})
            found[cur.y+1][cur.x] = 1
          }
        }

        bassins = append(bassins, bassin_size)
      }
    }
  }

  sort.Ints(bassins)

  fmt.Println(bassins[len(bassins)-1]*bassins[len(bassins)-2]*bassins[len(bassins)-3])
  fmt.Println("Done!")
}
