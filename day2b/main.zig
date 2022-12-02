// https://adventofcode.com/2022/day/2

const std = @import("std");
const input = @embedFile("input.txt");
const print = std.debug.print;

const Game = struct {
    player1: u8,
    player2: u8,

    pub fn shape_points(self: *Game) u32 {
        return switch (self.player2) {
            'X' => 1,
            'Y' => 2,
            'Z' => 3,
            else => unreachable,
        };
    }
};

pub fn main() !void {
    var total_score: u32 = 0;
    var wanted_outcome: i8 = undefined;
    var outcome_points: u32 = 0;

    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        wanted_outcome = switch (line[2]) {
            'X' => -1,
            'Y' => 0,
            else => 1,
        };
        outcome_points = switch (wanted_outcome) {
            1 => 6,
            0 => 3,
            else => 0,
        };
        var round = Game{ .player1 = line[0], .player2 = choose_shape(line[0], wanted_outcome) };
        total_score += round.shape_points() + outcome_points;
    }
    print("Total score: {}\n", .{total_score});
}

fn choose_shape(player1_play: u8, wanted_outcome: i8) u8 {
    return switch (player1_play) {
        'A' => switch (wanted_outcome) {
            1 => 'Y',
            0 => 'X',
            else => 'Z',
        },
        'B' => switch (wanted_outcome) {
            1 => 'Z',
            0 => 'Y',
            else => 'X',
        },
        'C' => switch (wanted_outcome) {
            1 => 'X',
            0 => 'Z',
            else => 'Y',
        },
        else => unreachable,
    };
}
