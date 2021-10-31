# FoxOS-module

This is a template for a FoxOS-module.  

## Building

```bash
make build
```

This will download the kernel headers and compile the module. The final module will be placed in the `bin/module.o` file.  

## Making an img file

On linux:
```bash
make img
```
On MacOS:
```bash
make mac-img
```

## Development

```bash
make run-bios
make run-bios-local
```

This command can be used to run the module in a virtual machine.

## Debugging

Make sure you have a working copy of the FoxOS source tree in the ~/FoxOS directory or override the default in the Makefile.

To launch qemu in debug mode:
```bash
make run-bios-debug
```

To attach gdb to the running qemu (in the FoxOS directory):
```bash
make debug
```
Make sure to not enable the boot vm option. Also note that you can only debug the kernel in qemu.
