// https://adventofcode.com/2022/day/6

const std = @import("std");
const ArrayList = std.ArrayList;
const input = @embedFile("input.txt");
const print = std.debug.print;
const marker_size = 14;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var unique_chars = std.AutoHashMap(u8, void).init(gpa.allocator());
    defer unique_chars.deinit();

    var idx: u32 = marker_size;
    while (idx < input.len) : (idx += 1) {
        var chunk = input[idx - marker_size .. idx];
        var char_count: u32 = marker_size;
        while (char_count > 0) : (char_count -= 1) {
            try unique_chars.put(chunk[char_count - 1], {});
        }
        if (unique_chars.count() == marker_size) {
            print("First marker after character {d}\n", .{idx});
            break;
        }
        unique_chars.clearAndFree();
    }
}