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

    var visible = grid.items.len * 4 - 4;
    var col: u32 = 1;
    var row: u32 = 1;
    var is_visible = false;
    while (row < grid.items.len - 1) : (row += 1) {
        while (col < grid.items.len - 1) : (col += 1) {
            var candidate = grid.items[row].items[col];

            // Left
            var left_trees = ArrayList(u8).init(gpa.allocator());
            try left_trees.appendSlice(grid.items[row].items[0..col]);
            std.sort.sort(u8, left_trees.items, {}, std.sort.desc(u8));
            is_visible = candidate > left_trees.items[0];

            // Right
            if (!is_visible) {
                var right_trees = ArrayList(u8).init(gpa.allocator());
                try right_trees.appendSlice(grid.items[row].items[col + 1 ..]);
                std.sort.sort(u8, right_trees.items, {}, std.sort.desc(u8));
                is_visible = candidate > right_trees.items[0];
            }

            // Top
            if (!is_visible) {
                var top_trees = ArrayList(u8).init(gpa.allocator());
                for (grid.items[0..row]) |cur_row| try top_trees.append(cur_row.items[col]);
                std.sort.sort(u8, top_trees.items, {}, std.sort.desc(u8));
                is_visible = candidate > top_trees.items[0];
            }

            // Bottom
            if (!is_visible) {
                var bottom_trees = ArrayList(u8).init(gpa.allocator());
                for (grid.items[row + 1 ..]) |cur_row| try bottom_trees.append(cur_row.items[col]);
                std.sort.sort(u8, bottom_trees.items, {}, std.sort.desc(u8));
                is_visible = candidate > bottom_trees.items[0];
            }

            if (is_visible) visible += 1;
        }
        col = 1;
        is_visible = false;
    }

    print("Visible trees: {d}\n", .{visible});
}
