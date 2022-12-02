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

    pub fn outcome_points(self: *Game) u32 {
        return switch (self.player2) {
            'X' => switch (self.player1) {
                'A' => 3,
                'C' => 6,
                else => 0,
            },
            'Y' => switch (self.player1) {
                'A' => 6,
                'B' => 3,
                else => 0,
            },
            'Z' => switch (self.player1) {
                'B' => 6,
                'C' => 3,
                else => 0,
            },
            else => unreachable,
        };
    }
};

pub fn main() !void {
    var total_score: u32 = 0;
    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        var round = Game{ .player1 = line[0], .player2 = line[2] };
        total_score += round.shape_points() + round.outcome_points();
    }
    print("Total score: {}\n", .{total_score});
}
