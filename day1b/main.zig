// https://adventofcode.com/2022/day/1

const std = @import("std");
const input = @embedFile("input.txt");
const print = std.debug.print;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var calories_per_elf = std.ArrayList(u32).init(allocator);
    defer calories_per_elf.deinit();

    var calories: u32 = 0;
    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |entry| {
        if (entry.len > 0) {
            calories += try std.fmt.parseUnsigned(u32, entry, 10);
        } else {
            try calories_per_elf.append(calories);
            calories = 0;
        }
    }

    var res = calories_per_elf.toOwnedSlice();
    std.sort.sort(u32, res, {}, std.sort.desc(u32));
    print("Sum: {d}\n", .{res[0] + res[1] + res[2]});
}
