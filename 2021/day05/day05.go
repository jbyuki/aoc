package main

import (
  "os"
  "fmt"
)

type wind struct {
  x0 int
  y0 int
  x1 int
  y1 int
}

func main() {
  f, _ := os.Open("input.txt")
  defer f.Close()

  var winds []wind

  for {
    var x0, y0, x1, y1 int
    _, err := fmt.Fscanf(f, "%d,%d -> %d,%d\n", &x0, &y0, &x1, &y1)
    if err != nil {
      break
    }

    if x0 > x1 && y0 == y1 {
      x0, x1 = x1, x0
    } else if y0 > y1 && x0 == x1 {
      y0, y1 = y1, y0
    }

    winds = append(winds, wind{x0, y0, x1, y1})
  }

  max_x, max_y := 0, 0
  for _, wind := range winds {
    if wind.x0 > max_x {
      max_x = wind.x0
    }

    if wind.x1 > max_x {
      max_x = wind.x1
    }

    if wind.y0 > max_y {
      max_y = wind.y0
    }

    if wind.y1 > max_y {
      max_y = wind.y1
    }
  }

  sea := make([][]int, max_y+1)
  for i := range sea {
    sea[i] = make([]int, max_x+1)
  }

  for _, wind := range winds {
    if wind.x0 == wind.x1 {
      for y := wind.y0; y <= wind.y1; y++ {
        sea[y][wind.x0]++
      }
    } else if wind.y0 == wind.y1 {
      for x := wind.x0; x <= wind.x1; x++ {
        sea[wind.y0][x]++
      }
    } else {
      len_x := wind.x1 - wind.x0
      if len_x < 0 {
        len_x = -len_x 
      }

      len_y := wind.y1 - wind.y0
      if len_y < 0 {
        len_y = -len_y
      }

      dx := (wind.x1 - wind.x0)/len_x
      dy := (wind.y1 - wind.y0)/len_y

      for i := 0; i <= len_x; i++ {
        sea[wind.y0+dy*i][wind.x0+dx*i]++
      }
    }
  }

  answer := 0
  for y := 0; y <= max_y; y++ {
    for x := 0; x <= max_x; x++ {
      if sea[y][x] >= 2 {
        answer++
      }
    }
  }

  fmt.Printf("Answer is %d\n", answer)
}
