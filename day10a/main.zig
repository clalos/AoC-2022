const std = @import("std");
const input = @embedFile("input.txt");
const print = std.debug.print;

pub fn main() !void {
    var start_time = std.time.nanoTimestamp();
    defer print("Total time: {d} nsecs\n", .{std.time.nanoTimestamp() - start_time});

    var total_signal_strength: i32 = 0;
    var x: i32 = 1;
    var cicle: i32 = 0;
    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        if (std.mem.eql(u8, line[0..4], "noop")) {
            cicle += 1;
            if (cicle == 20 or @rem((cicle + 20), 40) == 0) total_signal_strength += x * cicle;
            continue;
        }
        var i: u32 = 0;
        while (i < 2) : (i += 1) {
            cicle += 1;
            if (cicle == 20 or @rem((cicle + 20), 40) == 0) total_signal_strength += x * cicle;
            x += if (i == 1) try std.fmt.parseInt(i32, line[5..], 10) else 0;
        }
    }

    print("Total strength: {d}\n", .{total_signal_strength});
}