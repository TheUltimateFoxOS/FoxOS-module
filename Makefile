OBJDIR = lib
BUILDDIR = bin

QEMUFLAGS_BIOS = -machine q35 -smp 4 -drive file=foxos.img -m 1G -cpu qemu64 -serial stdio -soundhw pcspk -netdev user,id=u1,hostfwd=tcp::9999-:9999 -device e1000,netdev=u1 -object filter-dump,id=f1,netdev=u1,file=dump.dat

FOX_GCC_PATH=/usr/local/foxos-x86_64_elf_gcc

FOXOS_PATH=$(HOME)/FoxOS

build: kernel-headers
	@-mkdir $(BUILDDIR)
	@-mkdir $(OBJDIR)

	make -C src TOOLCHAIN_BASE=$(FOX_GCC_PATH)

img: build foxos.img
	sh disk.sh $(FOX_GCC_PATH)

img-local: build
	make -C $(FOXOS_PATH) TOOLCHAIN_BASE=$(FOX_GCC_PATH) img
	cp $(FOXOS_PATH)/foxos.img . -v

	sh disk.sh $(FOX_GCC_PATH)

mac-img: build foxos.img
	sh mac-disk.sh $(FOX_GCC_PATH)

run-bios: img
	qemu-system-x86_64 $(QEMUFLAGS_BIOS)

run-bios-debug: img-local
	qemu-system-x86_64 $(QEMUFLAGS_BIOS) -S -s 

run-bios-local: img-local
	qemu-system-x86_64 $(QEMUFLAGS_BIOS)

clean:
	@rm -r $(BUILDDIR)
	@rm -r $(OBJDIR)
	@rm -r kernel-headers
	@mkdir $(BUILDDIR)
	@mkdir $(OBJDIR)

.PHONY: build

kernel-headers:
	@-rm -r kernel-headers
	curl -OL https://github.com/TheUltimateFoxOS/FoxOS-kernel/releases/download/latest/kernel-headers.zip
	unzip kernel-headers.zip -d kernel-headers
	rm kernel-headers.zip

foxos.img:
	@-rm foxos.img
	curl -OL https://github.com/TheUltimateFoxOS/FoxOS/releases/download/latest/foxos.img