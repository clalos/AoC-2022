const std = @import("std");
const input = @embedFile("input.txt");
const print = std.debug.print;

pub fn main() !void {
    var most_calories: u32 = 0;
    var calories: u32 = 0;
    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |entry| {
        if (entry.len > 0) {
            calories += try std.fmt.parseUnsigned(u32, entry, 10);
        } else {
            most_calories = if (calories > most_calories) calories else most_calories;
            calories = 0;
        }
    }
    print("Calories: {}\n", .{most_calories});
}
