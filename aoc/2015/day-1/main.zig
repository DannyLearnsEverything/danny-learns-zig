const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    const cwd = std.fs.cwd();
    const fileContents = try cwd.readFileAlloc(alloc, "input.txt", 1024 * 1024);
    defer alloc.free(fileContents);

    const floor = part1(fileContents);
    std.debug.print("Part 1: {d}\n", .{floor});

    const position = part2(fileContents);
    std.debug.print("Part 2: {d}\n", .{position});
}

fn part1(input: []const u8) i32 {
    var i: i32 = 0;
    for (input) |byte| {
        if (byte == '(') i += 1;
        if (byte == ')') i -= 1;
    }
    return i;
}

test "part 1 examples" {
    try std.testing.expectEqual(0, part1("(())"));
    try std.testing.expectEqual(0, part1("()()"));
    try std.testing.expectEqual(3, part1("((("));
    try std.testing.expectEqual(3, part1("(()(()("));
    try std.testing.expectEqual(3, part1("))((((("));
    try std.testing.expectEqual(-1, part1("())"));
    try std.testing.expectEqual(-1, part1("))("));
    try std.testing.expectEqual(-3, part1(")))"));
    try std.testing.expectEqual(-3, part1(")())())"));
}

fn part2(input: []const u8) i32 {
    var position: i32 = 0;
    var floor: i32 = 0;
    for (input) |byte| {
        position += 1; // 1-indexed output
        if (byte == '(') floor += 1;
        if (byte == ')') floor -= 1;
        if (floor == -1) return position;
    }
    return position;
}

test "part 2 examples" {
    try std.testing.expectEqual(1, part2(")"));
    try std.testing.expectEqual(5, part2("()())"));
}
