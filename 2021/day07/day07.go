package main

import (
  "fmt"
  "os"
  "bufio"
  "strings"
  "strconv"
  "math"
)

func abs(x int) int {
  if x < 0 {
    return -x
  }
  return x
}

func min(x int, y int) int {
  if x < y {
    return x
  }
  return y
}

func max(x int, y int) int {
  if x > y {
    return x
  }
  return y
}

func evalFuel(pos []int, mu int) int {
  var fuel int
  fuel = 0

  for _, num := range pos {
    N := abs(num - mu) + 1
    fuel += N*(N-1)/2
  }
  return fuel
}

func main() {
  f, _ := os.Open("input.txt")
  defer f.Close()

  s := bufio.NewScanner(f)
  s.Scan()

  result := strings.Split(s.Text(), ",")
  crabs := make([]int, len(result))

  min_pos := math.MaxInt32
  max_pos := 0
  for i, num := range result {
    n,_ := strconv.Atoi(num)
    crabs[i] = n
    min_pos = min(n, min_pos)
    max_pos = max(n, max_pos)
  }

  best := math.MaxInt32
  for mu := min_pos; mu <= max_pos; mu++ {
    fuel := evalFuel(crabs, mu)
    if fuel < best {
      best = fuel
    }
  }
  fmt.Println(best)
  fmt.Println("Done!")
}
