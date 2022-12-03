// https://adventofcode.com/2022/day/3

const std = @import("std");
const input = @embedFile("input.txt");
const print = std.debug.print;

pub fn main() !void {
    var i: u32 = 0;
    var priorities_sum: u32 = 0;

    var lines = std.mem.split(u8, input, "\n");
    var group = [_][]const u8{ "", "", "" };
    while (lines.next()) |rucksack| {
        group[i] = rucksack;
        i += 1;
        if (i % 3 == 0) {
            var found = false;
            for (group[0]) |char0| {
                for (group[1]) |char1| {
                    if (char0 == char1) {
                        for (group[2]) |char2| {
                            if (char0 == char2) {
                                priorities_sum += if (std.ascii.isLower(char1)) char1 - 96 else char1 - 38;
                                found = true;
                                break;
                            }
                        }
                    }
                    if (found) break;
                }
                if (found) break;
            }
            i = 0;
        }
    }

    print("Priorities sum: {}\n", .{priorities_sum});
}
