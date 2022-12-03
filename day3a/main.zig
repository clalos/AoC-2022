// https://adventofcode.com/2022/day/3

const std = @import("std");
const input = @embedFile("input.txt");
const print = std.debug.print;

pub fn main() !void {
    var priorities_sum: u32 = 0;
    var lines = std.mem.split(u8, input, "\n");

    while (lines.next()) |rucksack| {
        var comp1 = rucksack[0 .. rucksack.len / 2];
        var comp2 = rucksack[rucksack.len / 2 ..];
        var found: bool = false;
        for (comp1) |comp1_item| {
            for (comp2) |comp2_item| {
                if (comp1_item == comp2_item) {
                    priorities_sum += if (std.ascii.isLower(comp1_item)) comp1_item - 96 else comp1_item - 38;
                    found = true;
                    break;
                }
            }
            if (found) break;
        }
    }

    print("Priorities sum: {}\n", .{priorities_sum});
}
