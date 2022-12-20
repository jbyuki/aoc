@*=
@includes
@functions
@variables

auto main() -> int
{
	@set_input
	@for_three_blueprint_find_quality_level
}

@includes+=
#include <iostream>
#include <string>
#include <vector>
#include <array>

@set_input+=
using blueprint = std::array<std::array<int, 4>, 4>;
std::vector<blueprint> blueprints {
	{{
			{{ 3, 0, 0, 0 }},
			{{ 4, 0, 0, 0 }},
			{{ 4, 13, 0, 0 }},
			{{ 3, 0, 7, 0 }},
	}},
		{{
		{{ 4, 0, 0, 0 }},
		{{ 4, 0, 0, 0 }},
		{{ 4, 20, 0, 0 }},
		{{ 2, 0, 12, 0 }},
	}},
	{ {
			{{ 3, 0, 0, 0 }},
			{{ 3, 0, 0, 0 }},
			{{ 3, 9, 0, 0 }},
			{{ 3, 0, 7, 0 }},
	}}
};

@for_three_blueprint_find_quality_level+=
int answer = 1;
for(int i=0; i<3; ++i) {
	auto& costs = blueprints[i];
	@set_initial

	while(true) {
		@prune_on_first_geode_robot_buy
		@compute_how_much_tick_until_can_buy
		@if_wait_after_end_figureout_geodes_at_end_and_go_to_next

		if(can_buy) {
			@advance_ticks_and_buy
			@goto_next_buy_additionnal
		}
	}

	std::cout << "BEST " << best << std::endl;
	answer *= best;
}
std::cout << "ANSWER " << answer << std::endl;
std::cout << "Done" << std::endl;

@set_initial+=
std::array<int, 4> ores { 0, 0, 0, 0 };
std::vector<int> buy { 3 };
std::vector<int> waits;
int tick = 0;
std::array<int, 4> robots { 1, 0, 0, 0 };
int best = 0;

@compute_how_much_tick_until_can_buy+=
int next_buy = buy.back();
bool can_buy = true;
int wait = 0;
for(int j=0; j<4; ++j) {
	if(robots[j] == 0) {
		if(costs[next_buy][j] > 0) {
			can_buy = false;
			break;
		}
	} else {
		wait = std::max((int)std::ceil((float)(costs[next_buy][j] - ores[j])/(float)robots[j]), wait);
	}
}

wait = wait + 1;

@variables+=
int total = 32;

@if_wait_after_end_figureout_geodes_at_end_and_go_to_next+=
if(wait + tick >= total || !can_buy) {
	int score = ores[3] + (total - tick) * robots[3];
	if(score > best) {
		std::cout << score << std::endl;
	}
	best = std::max(best, score);
	can_buy = false;
	@go_to_next_failed_to_buy
}

@advance_ticks_and_buy+=
for(int j=0; j<4; ++j) {
	ores[j] += wait*robots[j] - costs[next_buy][j];
}


tick += wait;
@register_best_first_buy
robots[next_buy]++;
waits.push_back(wait);

@go_to_next_failed_to_buy+=
bool still_continue = false;
while(buy.size() > 0) {
	int bought = buy.back();
	buy.pop_back();
	@buy_next_if_possible
	if(buy.size() > 0) {
		@unbuy_last_one_and_go_backward
	}
}

if(!still_continue) {
	std::cout << "FINISHED" << std::endl;
	break;
}

@unbuy_last_one_and_go_backward+=
bought = buy.back();
int waited = waits.back();
tick -= waited;

robots[bought]--;

for(int j=0; j<4; ++j) {
	ores[j] += -waited*robots[j] + costs[bought][j];
}

waits.pop_back();

@buy_next_if_possible+=
if(bought > 0) {
	buy.push_back(bought - 1);
	still_continue = true;
	break;
}

@goto_next_buy_additionnal+=
buy.push_back(3);

@set_initial+=
std::vector<int> best_first_buy;
for(int i=0; i<=total; ++i) {
	best_first_buy.push_back(total+1);
}

@register_best_first_buy+=
if(next_buy == 3) {
	best_first_buy[robots[3]] = std::min(best_first_buy[robots[3]], tick);
}

@prune_on_first_geode_robot_buy+=
if(best_first_buy[robots[3]] < tick) {
	@go_to_next_failed_to_buy
	continue;
}
