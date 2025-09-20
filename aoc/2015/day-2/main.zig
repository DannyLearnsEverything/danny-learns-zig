const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    const input = try std.fs.cwd().readFileAlloc(alloc, "input.txt", 1024 * 1024);
    defer alloc.free(input);

    var head: usize = 0;
    head = indexOfFirstDigit(input, head);
}

fn isDigit(c: u8) bool {
    return c >= '0' and c <= '9';
}

fn indexOfFirstDigit(input: []const u8, start: usize) usize {
    var i: usize = start;
    while (!isDigit(input[i])) {
        i += 1;
    }
    return i;
}

test "indexOfFirstDigitAfter" {
    try std.testing.expectEqual(0, indexOfFirstDigit("123", 0));
    try std.testing.expectEqual(1, indexOfFirstDigit("a123", 0));
    try std.testing.expectEqual(2, indexOfFirstDigit("aa123", 0));
    try std.testing.expectEqual(1, indexOfFirstDigit("1123", 1));
    try std.testing.expectEqual(2, indexOfFirstDigit("1a123", 1));
    try std.testing.expectEqual(3, indexOfFirstDigit("1aa123", 1));
}

fn charToDigit(c: u8) i8 {
    return @intCast(c - '0');
}

fn parseInt(input: []const u8, start: usize, end: usize) struct { i32, usize } {
    var head = indexOfFirstDigit(input, start);
    var value: i32 = 0;
    while (true) {
        const c = input[head];
        if (!isDigit(c)) {
            return .{ value, head };
        }
        const digit = charToDigit(input[head]);
        value = 10 * value + digit;
        head += 1;
    }

    return .{ value, head };
}

test "parseInt" {
    try std.testing.expectEqualDeep(.{ 123, 4 }, parseInt("123", 0));
}
