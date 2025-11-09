const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    const input = try std.fs.cwd().readFileAlloc(alloc, "input.txt", 1024 * 1024);
    defer alloc.free(input);

    var totalAreaAllBoxes: u32 = 0;
    var totalRibbonLength: u32 = 0;

    var dimensionIndex: u2 = 0;
    var dimensions = [_]u16{0} ** 3;
    for (input) |byte| {
        switch (byte) {
            '0'...'9' => {
                dimensions[dimensionIndex] *= 10;
                dimensions[dimensionIndex] += (byte - '0');
            },
            'x' => {
                dimensionIndex += 1;
            },
            '\n' => {
                // Newline indicates we're done with the sequence
                const length, const width, const height = dimensions;

                // Part 1
                const topArea = length * width;
                const frontArea = height * width;
                const rightArea = height * length;
                const minSideArea = min3(topArea, frontArea, rightArea);
                const totalBoxArea = 2 * (topArea + frontArea + rightArea) + minSideArea;
                totalAreaAllBoxes += totalBoxArea;

                // Part 2
                const topPerimeter = 2 * (length + width);
                const frontPerimeter = 2 * (height + width);
                const rightPerimeter = 2 * (height + length);
                const minPerimeter = min3(topPerimeter, frontPerimeter, rightPerimeter);
                const volume = length * width * height;
                const totalBoxRibbonLength = minPerimeter + volume;
                totalRibbonLength += totalBoxRibbonLength;

                // Reset for the next line
                dimensionIndex = 0;
                dimensions = [_]u16{0} ** 3;
            },
            else => {
                try out("Unhandled byte {x} as ascii:{c}\n", .{ byte, byte });
                std.posix.exit(0);
            },
        }
    }

    try out("Part 1: {d}\n", .{totalAreaAllBoxes});
    try out("Part 2: {d}\n", .{totalRibbonLength});
}

fn min3(a: u16, b: u16, c: u16) u16 {
    return @min(a, @min(b, c));
}

fn out(comptime fmt: []const u8, args: anytype) !void {
    var stdout_buffer: [1024 * 1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    var stdout = &stdout_writer.interface;
    try stdout.print(fmt, args);
    try stdout.flush();
}
