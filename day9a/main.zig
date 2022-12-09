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

    var head_pos = Coord{};
    var tail_pos = Coord{};

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
                'R' => head_pos.y += 1,
                'U' => head_pos.x -= 1,
                'L' => head_pos.y -= 1,
                'D' => head_pos.x += 1,
                else => unreachable,
            }

            // Move tail if necessary
            if (distance(head_pos.x, tail_pos.x) < 2 and distance(head_pos.y, tail_pos.y) < 2) continue; // Don't move if it's already close
            switch (dir) {
                'R' => tail_pos.y += 1,
                'U' => tail_pos.x -= 1,
                'L' => tail_pos.y -= 1,
                'D' => tail_pos.x += 1,
                else => unreachable,
            }

            // Move tail also diagonally if necessary
            if (dir == 'R' or dir == 'L') {
                if (head_pos.x > tail_pos.x) tail_pos.x += 1;
                if (head_pos.x < tail_pos.x) tail_pos.x -= 1;
            }
            if (dir == 'U' or dir == 'D') {
                if (head_pos.y > tail_pos.y) tail_pos.y += 1;
                if (head_pos.y < tail_pos.y) tail_pos.y -= 1;
            }

            // Save tail position
            try unique_positions.put(tail_pos, {});
        }
    }

    print("Visited positions {d}\n", .{unique_positions.count() + 1});
}

fn distance(x: u32, y: u32) u32 {
    return if (x > y) x - y else y - x;
}
