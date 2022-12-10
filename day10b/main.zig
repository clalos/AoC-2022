const std = @import("std");
const input = @embedFile("input.txt");
const print = std.debug.print;

pub fn main() !void {
    var start_time = std.time.nanoTimestamp();
    defer print("Total time: {d} nsecs\n", .{std.time.nanoTimestamp() - start_time});

    var crt_screen = std.mem.zeroes([6][40]u8);
    var x: i32 = 1;
    var row: u32 = 0;
    var cicle: u32 = 0;
    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        if (std.mem.eql(u8, line[0..4], "noop")) {
            var crt_h_pos: i32 = std.math.cast(i32, cicle - (row * 40)).?;
            crt_screen[row][std.math.cast(u32, crt_h_pos).?] = if (crt_h_pos - 1 == x or crt_h_pos == x or crt_h_pos + 1 == x) '#' else '.';
            cicle += 1;
            if (@rem(cicle, 40) == 0) row += 1;
            continue;
        }
        var i: u32 = 0;
        while (i < 2) : (i += 1) {
            var crt_h_pos: i32 = std.math.cast(i32, cicle - (row * 40)).?;
            crt_screen[row][std.math.cast(u32, crt_h_pos).?] = if (crt_h_pos - 1 == x or crt_h_pos == x or crt_h_pos + 1 == x) '#' else '.';
            cicle += 1;
            x += if (i == 1) try std.fmt.parseInt(i32, line[5..], 10) else 0;
            if (@rem(cicle, 40) == 0) row += 1;
        }
    }

    for (crt_screen) |r| {
        for (r) |value| {
            print("{u}", .{value});
        }
        print("\n", .{});
    }
}
