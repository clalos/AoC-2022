const std = @import("std");
const input = @embedFile("input.txt");
const print = std.debug.print;
const ArrayList = std.ArrayList;

pub fn main() !void {
    var start_time = std.time.nanoTimestamp();
    defer print("Total time: {d} nsecs\n", .{std.time.nanoTimestamp() - start_time});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var grid = ArrayList(ArrayList(u8)).init(gpa.allocator());
    defer grid.deinit();

    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        var row = ArrayList(u8).init(gpa.allocator());
        for (line) |tree| {
            try row.append(tree);
        }
        try grid.append(row);
    }

    var highest_scenic_score: u32 = 0;
    var col: u32 = 1;
    var row: u32 = 1;
    while (row < grid.items.len - 1) : (row += 1) {
        while (col < grid.items.len - 1) : (col += 1) {
            var candidate = grid.items[row].items[col];

            // Left
            var left_trees = ArrayList(u8).init(gpa.allocator());
            try left_trees.appendSlice(grid.items[row].items[0..col]);
            std.mem.reverse(u8, left_trees.items);
            var left_score: u32 = 0;
            for (left_trees.items) |tree| {
                left_score += 1;
                if (tree >= candidate) break;
            }

            // Right
            var right_trees = grid.items[row].items[col + 1 ..];
            var right_score: u32 = 0;
            for (right_trees) |tree| {
                right_score += 1;
                if (tree >= candidate) break;
            }

            // Top
            var top_trees = ArrayList(u8).init(gpa.allocator());
            var top_score: u32 = 0;
            for (grid.items[0..row]) |cur_row| try top_trees.append(cur_row.items[col]);
            std.mem.reverse(u8, top_trees.items);
            for (top_trees.items) |tree| {
                top_score += 1;
                if (tree >= candidate) break;
            }

            // Bottom
            var bottom_trees = ArrayList(u8).init(gpa.allocator());
            var bottom_score: u32 = 0;
            for (grid.items[row + 1 ..]) |cur_row| try bottom_trees.append(cur_row.items[col]);
            for (bottom_trees.items) |tree| {
                bottom_score += 1;
                if (tree >= candidate) break;
            }

            var scenic_score = left_score * right_score * top_score * bottom_score;
            highest_scenic_score = if (scenic_score > highest_scenic_score) scenic_score else highest_scenic_score;
        }
        col = 1;
    }

    print("Highest scenic score: {d}\n", .{highest_scenic_score});
}
