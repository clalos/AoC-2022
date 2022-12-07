// https://adventofcode.com/2022/day/7

const std = @import("std");
const ArrayList = std.ArrayList;
const input = @embedFile("input.txt");
const print = std.debug.print;

const File = struct {
    name: []const u8,
    size: u32,
};

const Folder = struct {
    name: []const u8,
    parent: ?*Folder,
    files: ArrayList(File),
    folders: ArrayList(Folder),
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    var is_ls = false;
    var root = Folder{
        .name = "/",
        .parent = null,
        .files = ArrayList(File).init(gpa.allocator()),
        .folders = ArrayList(Folder).init(gpa.allocator()),
    };
    var cur_dir: *Folder = &root;

    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        if (line[0] == '$') {
            var command_parts = std.mem.split(u8, line, " ");
            _ = command_parts.next().?;
            var command_name = command_parts.next().?;

            is_ls = std.mem.eql(u8, command_name, "ls");
            if (is_ls) continue;

            var command_param = command_parts.next().?;
            if (std.mem.eql(u8, command_param, "/")) {
                cur_dir = &root;
                continue;
            }

            if (std.mem.eql(u8, command_param, "..")) {
                // Go to parent
                cur_dir = cur_dir.parent.?;
                continue;
            }

            // Move to folder
            // 1) check if folder is in the children
            var found_child = false;
            for (cur_dir.folders.items) |child, idx| {
                if (std.mem.eql(u8, child.name, command_param)) {
                    cur_dir = &cur_dir.folders.items[idx];
                    found_child = true;
                    break;
                }
            }
            if (found_child) continue;

            // 2) if not a child, add folder to the children and move to it
            try cur_dir.folders.append(Folder{
                .name = command_param,
                .parent = cur_dir,
                .files = ArrayList(File).init(gpa.allocator()),
                .folders = ArrayList(Folder).init(gpa.allocator()),
            });
            cur_dir = &cur_dir.folders.items[cur_dir.folders.items.len - 1];
            continue;
        }

        var res_parts = std.mem.split(u8, line, " ");
        var res_part1 = res_parts.next().?;
        var res_part2 = res_parts.next().?;

        if (std.mem.eql(u8, res_part1, "dir")) {
            // Search for dir, if not found create it
            var found_dir = false;
            for (cur_dir.folders.items) |folder, idx| {
                if (std.mem.eql(u8, folder.name, res_part2)) {
                    cur_dir = &cur_dir.folders.items[idx];
                    found_dir = true;
                    break;
                }
            }
            if (found_dir) continue;

            try cur_dir.folders.append(Folder{
                .name = res_part2,
                .parent = cur_dir,
                .files = ArrayList(File).init(gpa.allocator()),
                .folders = ArrayList(Folder).init(gpa.allocator()),
            });
        } else {
            // Append file under cur_dir if not exists
            var file_found = false;
            for (cur_dir.files.items) |file| {
                if (std.mem.eql(u8, file.name, res_part2)) {
                    file_found = true;
                    break;
                }
            }
            if (file_found) continue;

            try cur_dir.files.append(File{
                .name = res_part2,
                .size = try std.fmt.parseUnsigned(u32, res_part1, 10),
            });
        }
    }

    const filesystem_space = 70000000;
    const wanted_unused_space = 30000000;
    var folder_sizes = ArrayList(u32).init(gpa.allocator());
    var total_size = try calculateTotalSize(root, &folder_sizes);
    var unused_space = filesystem_space - total_size;
    var amount_to_free = wanted_unused_space - unused_space;

    var smallest: u32 = total_size;
    for (folder_sizes.items) |folder_size| {
        smallest = if (folder_size >= amount_to_free and folder_size < smallest) folder_size else smallest;
    }
    print("Size of smallest directory to remove: {d}\n", .{smallest});
}

fn calculateTotalSize(dir: Folder, folders_size: *ArrayList(u32)) !u32 {
    var dir_size: u32 = 0;
    for (dir.files.items) |file| {
        dir_size += file.size;
    }

    for (dir.folders.items) |folder| {
        dir_size += try calculateTotalSize(folder, folders_size);
    }

    try folders_size.append(dir_size);
    return dir_size;
}
