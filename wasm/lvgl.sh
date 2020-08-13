#!/usr/bin/env bash
# Build LVGL for WebAssembly

# Stop the script on error, echo all commands
set -e -x

# Build LVGL app: wasm/lvgl.html, lvgl.js, lvgl.wasm
make -j

# Build sample app: wasm/test.html, test.js, test.wasm
emcc wasm/test.c -s WASM=1 -o wasm/test.html

# Build Rust modules
cargo build --target=wasm32-unknown-emscripten

# Build sample Rust app: wasm/test_rust.html, test_rust.js, test_rust.wasm
emcc \
    wasm/test_rust.c \
    -s WASM=1 \
    -s "EXPORTED_FUNCTIONS=[ '_main', '_test_c', '_test_rust', '_test_rust2', '_test_rust3' ]" \
    -o wasm/test_rust.html \
    target/wasm32-unknown-emscripten/debug/liblvgl_wasm_rust.a

# Dump the WebAssembly modules
wasm-objdump -x wasm/lvgl.wasm >wasm/lvgl.txt
wasm-objdump -x wasm/test.wasm >wasm/test.txt
wasm-objdump -x wasm/test_rust.wasm >wasm/test_rust.txt
