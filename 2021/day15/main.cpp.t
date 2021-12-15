##day15
@main.cpp=
@includes
@variables

auto main() -> int
{
  @read_input
  @expand_grid
  @find_shortest_path
  @show_result
  return 0;
}

@includes+=
#include <fstream>

@read_input+=
std::ifstream in("input.txt");
if(!in.is_open()) {
  std::cerr << "No open" <<std::endl;
  return EXIT_FAILURE;
}

@read_line_by_line
@set_width_and_height

@includes+=
#include <string>
#include <vector>

@read_line_by_line+=
std::string line;
while(std::getline(in, line)) {
  @add_row_grid
}

@variables+=
std::vector<std::vector<int>> grid;

@add_row_grid+=
std::vector<int> row;
for(int i=0; i<(int)line.size(); ++i) {
  @add_number_to_row
}
grid.push_back(std::move(row));

@add_number_to_row+=
char c = line[i];
row.push_back((int)(c - '0'));

@variables+=
int width, height;

@set_width_and_height+=
width = grid[0].size();
height = grid.size();

@includes+=
#include <iostream>

@show_result+=
std::cout << "Puzzle " << width << "x" << height << std::endl;

@variables+=
struct Pos
{
  int x,y;
};

@includes+=
#include <queue>

@variables+=
std::vector<std::vector<int>> best;

@find_shortest_path+=
auto cmp = [](const Pos& left, const Pos& right) { return best[left.y][left.x] > best[right.y][right.x]; };
std::priority_queue<Pos, std::vector<Pos>, decltype(cmp)> open { cmp };
open.push(Pos{0, 0});

best.resize(height);
for(int i=0; i<height; ++i) {
  best[i].resize(width, -1);
}
best[0][0] = 0;

while(open.size() > 0) {
  @pop_last_from_open
  if(risk > 9*width+9*height) {
    continue;
  }
  // std::cout << open.size() << " " << cur.x << " " << cur.y << " " << risk << std::endl;
  @check_neighbours
}

@pop_last_from_open+=
Pos cur = open.top();
int risk = best[cur.y][cur.x];
open.pop();

@includes+=
#include <array>

@find_shortest_path-=
std::array<Pos, 4> disp {
  Pos{0, 1},
  Pos{1, 0},
  Pos{-1, 0},
  Pos{0, -1}
};

@check_neighbours+=
for(auto& d : disp) {

  int nx = cur.x+d.x;
  int ny = cur.y+d.y;

  if(nx < 0 || nx >= width || ny < 0 || ny >= height) {
    continue;
  }

  if(best[ny][nx] == -1 || best[ny][nx] > risk+grid[ny][nx]) {
    if(ny == height-1 && nx == width-1) {
      std::cout << "end " << risk+grid[ny][nx] << std::endl;
    }
    best[ny][nx] = risk+grid[ny][nx];
    // std::cout << "pushed " << risk+grid[ny][nx] << std::endl;
    open.push(Pos{nx,ny});
  }
}

@show_result+=
std::cout << "Answer: " << best[height-1][width-1] << std::endl;

@expand_grid+=
grid.resize(height*5);
for(int y=0; y<height*5; ++y) {
  grid[y].resize(width*5);
}

for(int y=0; y<height*5; ++y) {
  for(int x=0; x<width*5; ++x) {
    int offset = y/height + x/width;
    @add_grid_with_offset
  }
}

width *= 5;
height *= 5;

@add_grid_with_offset+=
grid[y][x] = grid[y%height][x%width] + offset;
while(grid[y][x] > 9) {
  grid[y][x] -= 9;
}
