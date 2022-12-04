// https://adventofcode.com/2022/day/4

const std = @import("std");
const input = @embedFile("input.txt");
const print = std.debug.print;

const Section = struct {
    from: u32,
    to: u32,

    pub fn isContainedIn(self: *Section, target: *Section) bool {
        return (self.from >= target.from and self.to <= target.to) or
            (self.to >= target.from and self.to <= target.to);
    }
};

pub fn main() !void {
    var overlaps: u32 = 0;

    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        var pairs = std.mem.split(u8, line, ",");
        var first_elf_sections = std.mem.split(u8, pairs.next().?, "-");
        var second_elf_sections = std.mem.split(u8, pairs.next().?, "-");
        var first_sec = Section{
            .from = try std.fmt.parseUnsigned(u32, first_elf_sections.next().?, 10),
            .to = try std.fmt.parseUnsigned(u32, first_elf_sections.next().?, 10),
        };
        var second_sec = Section{
            .from = try std.fmt.parseUnsigned(u32, second_elf_sections.next().?, 10),
            .to = try std.fmt.parseUnsigned(u32, second_elf_sections.next().?, 10),
        };
        overlaps += if (first_sec.isContainedIn(&second_sec) or second_sec.isContainedIn(&first_sec)) 1 else 0;
    }

    print("Overlaps: {}\n", .{overlaps});
}
