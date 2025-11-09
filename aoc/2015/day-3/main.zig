const std = @import("std");

const Point = struct { i: i32, j: i32 };

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const input = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 1024 * 1024);
    defer allocator.free(input);

    try part1(input, allocator);
    try part2(input, allocator);
}

fn part1(input: []u8, allocator: std.mem.Allocator) !void {
    var visited = std.AutoHashMap(Point, u32).init(allocator);
    defer visited.deinit();
    var pos = Point{ .i = 0, .j = 0 };
    for (input) |byte| {
        try visited.put(pos, visited.get(pos) orelse 0);
        switch (byte) {
            '^' => pos = Point{ .i = pos.i, .j = pos.j - 1 },
            'v' => pos = Point{ .i = pos.i, .j = pos.j + 1 },
            '<' => pos = Point{ .i = pos.i - 1, .j = pos.j },
            '>' => pos = Point{ .i = pos.i + 1, .j = pos.j },
            '\n' => {
                std.debug.print("Part 1: {d}\n", .{visited.count()});
            },
            else => {
                std.debug.print("Unexpected byte {x} (ascii: {c})\n", .{ byte, byte });
                std.posix.exit(0);
            },
        }
    }
}

fn part2(input: []u8, allocator: std.mem.Allocator) !void {
    var visited = std.AutoHashMap(Point, u32).init(allocator);
    defer visited.deinit();
    var isRoboSanta = false;
    var santa = Point{ .i = 0, .j = 0 };
    var roboSanta = Point{ .i = 0, .j = 0 };
    for (input) |byte| {
        const pos = if (isRoboSanta) &roboSanta else &santa;
        isRoboSanta = !isRoboSanta;
        try visited.put(pos.*, visited.get(pos.*) orelse 0);
        switch (byte) {
            '^' => pos.* = Point{ .i = pos.i, .j = pos.j - 1 },
            'v' => pos.* = Point{ .i = pos.i, .j = pos.j + 1 },
            '<' => pos.* = Point{ .i = pos.i - 1, .j = pos.j },
            '>' => pos.* = Point{ .i = pos.i + 1, .j = pos.j },
            '\n' => {
                std.debug.print("Part 2: {d}\n", .{visited.count()});
            },
            else => {
                std.debug.print("Unexpected byte {x} (ascii: {c})\n", .{ byte, byte });
                std.posix.exit(0);
            },
        }
    }
}
