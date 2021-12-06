package main

import (
  "fmt"
  "os"
  "bufio"
  "strings"
  "strconv"
)

func main() {
  f, _ := os.Open("input.txt")
  defer f.Close()

  s := bufio.NewScanner(f)

  state := make([]int, 0)
  s.Scan()
  start_str := strings.Split(s.Text(), ",")
  for _, str := range(start_str) {
    num, _ := strconv.Atoi(str)
    state = append(state, num)
  }

  total_day := 256
  total_count := len(state)
  new_born := make([]int, total_day)

  for _, num := range(state) {
    idx := num
    for idx < total_day {
      new_born[idx]++
      idx += 7
    }
  }

  for day, n := range(new_born) {
    total_count += n

    idx := day+9
    for idx < total_day {
      new_born[idx] += n
      idx += 7
    }
  }

  fmt.Println(total_count)
  fmt.Println("Done!")
}
