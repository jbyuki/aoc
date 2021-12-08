package main

import (
  "fmt"
  "bufio"
  "os"
  "strings"
)

func count_easy(digits []string) int {
  count := 0
  for _, word := range digits {
    digit := strings.Trim(word, " ")
    switch len(digit) {
    case 2:
      count++
    case 3:
      count++
    case 4:
      count++
    case 7:
      count++
    }
  }
  return count
}

func same_char(a string, b string) string {
  for _, ai := range a {
    for _, bi := range b {
      if ai == bi {
        return string(ai)
      }
    }
  }
  return ""
}

func diff_char(a string, b string) string {
  for _, ai := range a {
    found := false
    for _, bi := range b {
      if ai == bi {
        found = true
        break
      }
    }

    if !found {
      return string(ai)
    }
  }
  return ""
}

func deduce(digits []string) string {
  var dig_1, dig_7, dig_4, dig_8 string
  var dig_960 = make([]string, 0)
  var dig_235 = make([]string, 0)
  for _, word := range digits {
    digit := strings.Trim(word, " ")
    switch len(digit) {
    case 2:
      dig_1 = digit
    case 3:
      dig_7 = digit
    case 4:
      dig_4 = digit
    case 5:
      dig_235 = append(dig_235, digit)
    case 6:
      dig_960 = append(dig_960, digit)
    case 7:
      dig_8 = digit
    }
  }

  code_a := diff_char(dig_7, dig_1)


  var code_c string
  var dig_6 string
  for _, digit := range dig_960 {
    code_c = diff_char(dig_1, digit)
    if code_c != "" {
      dig_6 = digit
      break
    }
  }

  var code_d string
  for _, digit := range dig_960 {
    if digit != dig_6 {
      code_d = diff_char(dig_4, digit)
      if code_d != "" {
        break
      }
    }
  }

  var code_f string
  if code_c[0] == dig_1[0] {
    code_f = string(dig_1[1])
  } else {
    code_f = string(dig_1[0])
  }

  var dig_2 string
  for _, digit := range dig_235 {
    needle := diff_char(code_f, digit)
    if needle != "" {
      dig_2 = digit
      break
    }
  }

  dig_35 := ""
  for _, digit := range dig_235 {
    if dig_2 != digit {
      dig_35 = dig_35 + digit
    }
  }

  code_e := diff_char(dig_8, dig_35)
  code_b := diff_char(dig_4, dig_2 + code_f)
  code_g := diff_char(dig_2, code_a+code_c+code_d+code_e)

  return code_a+code_b+code_c+code_d+code_e+code_f+code_g
}

func decode(display []string, code string) int {
  result := 0
  for _, word := range(display) {
    digit := strings.Trim(word, " ")


    dig_code := 0
    for _, l := range(code) {
      dig_code *= 2
      ind := strings.Index(digit, string(l))
      if ind != -1 {
        dig_code += 1
      }
    }

    result *= 10

    switch dig_code {
    case 127:
      result += 8
    case 123:
      result += 9
    case 93:
      result += 2
    case 119:
      result += 0
    case 58:
      result += 4
    case 82:
      result += 7
    case 18:
      result += 1
    case 111:
      result += 6
    case 107:
      result += 5
    case 91:
      result += 3
    }
  }
  return result
}

func main() {
  f, _ := os.Open("input.txt")
  defer f.Close()

  s := bufio.NewScanner(f)
  total_count := 0
  sum := 0
  for s.Scan() {
    t := strings.Split(s.Text(), "|")
    total_count += count_easy(strings.Split(t[1], " "))
    code := deduce(strings.Split(t[0], " "))
    result := decode(strings.Split(strings.Trim(t[1], " "), " "), code)
    sum += result
  }

  fmt.Printf("total easy count : %d\n", total_count)
  fmt.Printf("total sum : %d\n", sum)
}
