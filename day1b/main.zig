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
    std.sort.sort(u32, res, {}, std.sort.asc(u32));
    print("Sum: {d}\n", .{res[res.len - 1] + res[res.len - 2] + res[res.len - 3]});
}
