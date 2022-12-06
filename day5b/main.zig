// https://adventofcode.com/2022/day/5

const std = @import("std");
const ArrayList = std.ArrayList;
const input = @embedFile("input.txt");
const print = std.debug.print;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var stacks = std.AutoHashMap(usize, ArrayList(u8)).init(gpa.allocator());

    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        if (line[1] == '1') {
            break;
        }
        var i: u32 = 1;
        var stack_index: u32 = 1;
        while (i < line.len) : (i += 4) {
            if (line[i] != ' ') {
                if (!stacks.contains(stack_index)) try stacks.put(stack_index, ArrayList(u8).init(gpa.allocator()));

                var stack = stacks.get(stack_index).?;
                try stack.append(line[i]);
                try stacks.put(stack_index, stack);
            }
            stack_index += 1;
        }
    }

    var iterator = stacks.iterator();
    while (iterator.next()) |entry| {
        std.mem.reverse(u8, entry.value_ptr.items);
    }

    lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        if (!std.mem.eql(u8, line[0..4], "move")) continue;

        var step_parts = std.mem.split(u8, line, " ");
        _ = step_parts.next().?; // move
        var quantity = try std.fmt.parseUnsigned(u32, step_parts.next().?, 10);
        _ = step_parts.next().?; // from
        var from = try std.fmt.parseUnsigned(u32, step_parts.next().?, 10);
        _ = step_parts.next().?; // to
        var to = try std.fmt.parseUnsigned(u32, step_parts.next().?, 10);

        var from_stack = stacks.get(from).?;
        var to_stack = stacks.get(to).?;
        try to_stack.appendSlice(from_stack.items[from_stack.items.len - quantity ..]);
        from_stack.shrinkAndFree(from_stack.items.len - quantity);

        try stacks.put(from, from_stack);
        try stacks.put(to, to_stack);
    }

    var i: u32 = 1;
    print("Crates on top: ", .{});
    defer print("\n", .{});
    while (i <= stacks.count()) : (i += 1) {
        var stack = stacks.get(i).?;
        print("{u}", .{stack.pop()});
    }
}
