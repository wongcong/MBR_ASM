编译器:NASM
虚拟机:BOCHS

文件夹BOOT\与MBR\均实现作业内容
*.ASM	源程序
*.BIN	用NASM编译得到的二进制文件
*.IMG	bochs镜像
*.bxrc  bochs配置文件，可与*.IMG配合启动

由于MBR中分区表的存在，使得程序无法太大
因此做成两个:
BOOT\	可直接将BOOT.BIN写至磁盘的MBR，能够成功引导执行，交互简单
MBR\	代码过长，占用分区表部分空间，因此无法写至磁盘引导，但可通过bochs虚拟机运行，有较好的交互

BOOT仅为MBR的精简版
