const std = @import("std");
const input = @embedFile("input.txt");
const print = std.debug.print;

const Coord = struct {
    x: u32 = 500,
    y: u32 = 500,
};

pub fn main() !void {
    var start_time = std.time.nanoTimestamp();
    defer print("Total time: {d} nsecs\n", .{std.time.nanoTimestamp() - start_time});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var unique_positions = std.AutoHashMap(Coord, void).init(gpa.allocator());
    defer unique_positions.deinit();

    var snake: [10]Coord = undefined;
    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        var motion = std.mem.split(u8, line, " ");
        var dir: u8 = line[0];
        _ = motion.next().?;
        var steps: u32 = try std.fmt.parseUnsigned(u32, motion.next().?, 10);

        var i: u32 = 0;
        while (i < steps) : (i += 1) {
            // Move head
            switch (dir) {
                'R' => snake[0].y += 1,
                'U' => snake[0].x -= 1,
                'L' => snake[0].y -= 1,
                'D' => snake[0].x += 1,
                else => unreachable,
            }

            var k: u32 = 1;
            while (k < snake.len) : (k += 1) {
                var front = snake[k - 1];
                // Move body point if necessary
                if (distance(front.x, snake[k].x) < 2 and distance(front.y, snake[k].y) < 2) continue; // Don't move if it's already close
                if (front.x > snake[k].x) snake[k].x += 1;
                if (front.x < snake[k].x) snake[k].x -= 1;
                if (front.y > snake[k].y) snake[k].y += 1;
                if (front.y < snake[k].y) snake[k].y -= 1;
            }

            // Save tail position
            try unique_positions.put(snake[9], {});
        }
    }

    print("Visited positions {d}\n", .{unique_positions.count()});
}

fn distance(x: u32, y: u32) u32 {
    return if (x > y) x - y else y - x;
}