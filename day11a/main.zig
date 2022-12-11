const std = @import("std");
const input = @embedFile("input.txt");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const eql = std.mem.eql;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const Monkey = struct {
    items: ArrayList(u32) = ArrayList(u32).init(gpa.allocator()),
    inspections: u32 = 0,
    operation: ?u32 = null,
    operation_operand: []const u8 = undefined,
    op_test: u32 = undefined,
    true_branch: u32 = undefined,
    false_branch: u32 = undefined,
};

pub fn main() !void {
    var start_time = std.time.nanoTimestamp();
    defer print("Total time: {d} nsecs\n", .{std.time.nanoTimestamp() - start_time});

    var monkeys = ArrayList(Monkey).init(gpa.allocator());
    defer monkeys.deinit();
    var cur_monkey: Monkey = undefined;

    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        if (eql(u8, line[0..6], "Monkey")) {
            cur_monkey = Monkey{};
            continue;
        }
        if (eql(u8, line[2..16], "Starting items")) {
            var items = std.mem.split(u8, line[18..], ", ");
            while (items.next()) |item| try cur_monkey.items.append(try std.fmt.parseUnsigned(u32, item, 10));
            continue;
        }
        if (eql(u8, line[2..11], "Operation")) {
            var op = std.mem.splitBackwards(u8, line, " ");
            var operation = op.next().?;
            cur_monkey.operation = if (!eql(u8, operation, "old")) try std.fmt.parseUnsigned(u32, operation, 10) else null;
            cur_monkey.operation_operand = op.next().?;
            continue;
        }
        if (eql(u8, line[2..6], "Test")) {
            var t = std.mem.splitBackwards(u8, line, " ");
            cur_monkey.op_test = try std.fmt.parseUnsigned(u32, t.next().?, 10);
            continue;
        }
        if (eql(u8, line[7..11], "true")) {
            var target_monkey = std.mem.splitBackwards(u8, line, " ");
            cur_monkey.true_branch = try std.fmt.parseUnsigned(u32, target_monkey.next().?, 10);
            continue;
        }
        if (eql(u8, line[7..12], "false")) {
            var target_monkey = std.mem.splitBackwards(u8, line, " ");
            cur_monkey.false_branch = try std.fmt.parseUnsigned(u32, target_monkey.next().?, 10);
            try monkeys.append(cur_monkey);
        }
    }

    const rounds = 20;
    var i: u32 = 0;
    while (i < rounds) : (i += 1) {
        for (monkeys.items) |monkey, idx| {
            for (monkey.items.items) |item_worry_level| {
                monkeys.items[idx].inspections += 1;
                var worry_level: u32 = 0;
                if (eql(u8, monkey.operation_operand, "*")) {
                    worry_level = if (monkey.operation != null) item_worry_level * monkey.operation.? else item_worry_level * item_worry_level;
                } else {
                    worry_level = if (monkey.operation != null) item_worry_level + monkey.operation.? else item_worry_level * 2;
                }
                worry_level /= 3;
                if (worry_level % monkey.op_test == 0) {
                    try monkeys.items[monkey.true_branch].items.append(worry_level);
                } else {
                    try monkeys.items[monkey.false_branch].items.append(worry_level);
                }
            }
            monkeys.items[idx].items.clearAndFree();
        }
    }

    var inspections = ArrayList(u32).init(gpa.allocator());
    defer inspections.deinit();
    for (monkeys.items) |monkey| {
        try inspections.append(monkey.inspections);
    }
    std.sort.sort(u32, inspections.items, {}, std.sort.desc(u32));

    print("Level of monkey business: {d}\n", .{inspections.items[0] * inspections.items[1]});
}
