// https://adventofcode.com/2022/day/6

const std = @import("std");
const ArrayList = std.ArrayList;
const input = @embedFile("input.txt");
const print = std.debug.print;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var unique_chars = std.AutoHashMap(u8, void).init(gpa.allocator());
    defer unique_chars.deinit();

    var idx: u32 = 4;
    while (idx < input.len) : (idx += 1) {
        var chunk = input[idx - 4 .. idx];
        try unique_chars.put(chunk[3], {});
        try unique_chars.put(chunk[2], {});
        try unique_chars.put(chunk[1], {});
        try unique_chars.put(chunk[0], {});
        if (unique_chars.count() == 4) {
            print("First marker after character {d}\n", .{idx});
            break;
        }
        unique_chars.clearAndFree();
    }
}
