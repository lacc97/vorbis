const std = @import("std");

const Build = std.Build;

pub fn build(b: *Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const ogg_dep = b.dependency("ogg", .{
        .target = target,
        .optimize = optimize,
    });

    const lib_vorbis = b.addStaticLibrary(.{
        .name = "vorbis",
        .target = target,
        .optimize = optimize,
    });
    lib_vorbis.addIncludePath(.{ .path = "include" });
    lib_vorbis.addIncludePath(.{ .path = "lib" });
    lib_vorbis.addCSourceFiles(&vorbis_sources, &.{});
    lib_vorbis.linkLibC();
    lib_vorbis.linkLibrary(ogg_dep.artifact("ogg"));
    lib_vorbis.installHeader("include/vorbis/codec.h", "vorbis/codec.h");
    b.installArtifact(lib_vorbis);

    const lib_vorbisenc = b.addStaticLibrary(.{
        .name = "vorbisenc",
        .target = target,
        .optimize = optimize,
    });
    lib_vorbisenc.addIncludePath(.{ .path = "lib" });
    lib_vorbisenc.addCSourceFiles(&vorbisenc_sources, &.{});
    lib_vorbisenc.linkLibC();
    lib_vorbisenc.linkLibrary(lib_vorbis);
    lib_vorbisenc.installHeader("include/vorbis/vorbisenc.h", "vorbis/vorbisenc.h");
    b.installArtifact(lib_vorbisenc);

    const lib_vorbisfile = b.addStaticLibrary(.{
        .name = "vorbisfile",
        .target = target,
        .optimize = optimize,
    });
    lib_vorbisfile.addIncludePath(.{ .path = "lib" });
    lib_vorbisfile.addCSourceFiles(&vorbisfile_sources, &.{});
    lib_vorbisfile.linkLibC();
    lib_vorbisfile.linkLibrary(lib_vorbis);
    lib_vorbisfile.installHeader("include/vorbis/vorbisfile.h", "vorbis/vorbisfile.h");
    b.installArtifact(lib_vorbisfile);
}

const vorbis_sources = [_][]const u8{
    "lib/mdct.c",
    "lib/smallft.c",
    "lib/block.c",
    "lib/envelope.c",
    "lib/window.c",
    "lib/lsp.c",
    "lib/lpc.c",
    "lib/analysis.c",
    "lib/synthesis.c",
    "lib/psy.c",
    "lib/info.c",
    "lib/floor1.c",
    "lib/floor0.c",
    "lib/res0.c",
    "lib/mapping0.c",
    "lib/registry.c",
    "lib/codebook.c",
    "lib/sharedbook.c",
    "lib/lookup.c",
    "lib/bitrate.c",
};

const vorbisenc_sources = [_][]const u8{
    "lib/vorbisenc.c",
};
const vorbisfile_sources = [_][]const u8{
    "lib/vorbisfile.c",
};
