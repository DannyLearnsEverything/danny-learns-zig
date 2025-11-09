const std = @import("std");

pub fn main() !void {
    std.debug.print("Mining part one... this may take a minute or so\n", .{});
    std.debug.print("Part 1: {d}\n", .{try mine("bgvyzdsv", 5)});

    std.debug.print("Mining part two... this may take a couple minutes\n", .{});
    std.debug.print("Part 2: {d}\n", .{try mine("bgvyzdsv", 6)});
}

fn mine(input: []const u8, zeros: u9) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    const allocator = gpa.allocator();
    var solution: u32 = 0;
    const limit = std.math.maxInt(u32);
    while (solution < limit) {
        const digest = try std.fmt.allocPrint(allocator, "{s}{d}", .{ input, solution });
        const hash = md5(digest);
        var zerosRemaining = zeros;
        for (hash) |byte| {
            switch (zerosRemaining) {
                0 => return solution,
                1 => {
                    if (byte < 0x10) {
                        return solution;
                    } else {
                        break;
                    }
                },
                else => {
                    if (byte == 0) {
                        zerosRemaining -= 2;
                        continue;
                    } else {
                        break;
                    }
                },
            }
        }
        solution += 1;
    }
    std.debug.print("No solution found after {d} attempts\n", .{limit});
    return 0;
}

fn md5(digest: []const u8) [16]u8 {
    var out: [16]u8 = undefined;
    var h = std.crypto.hash.Md5.init(.{});
    h.update(digest);
    h.final(&out);
    return out;
}
