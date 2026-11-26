# fa20-proj2-starter

```
.
├── inputs (test inputs)
├── outputs (some test outputs)
├── README.md
├── src
│   ├── argmax.s (partA)
│   ├── classify.s (partB)
│   ├── dot.s (partA)
│   ├── main.s (do not modify)
│   ├── matmul.s (partA)
│   ├── read_matrix.s (partB)
│   ├── relu.s (partA)
│   ├── utils.s (do not modify)
│   └── write_matrix.s (partB)
├── tools
│   ├── convert.py (convert matrix files for partB)
│   └── venus.jar (RISC-V simulator)
└── unittests
    ├── assembly (contains outputs from unittests.py)
    ├── framework.py (do not modify)
    └── unittests.py (partA + partB)
```


## Here's what I did in project 2:

被 partB 卡死了。

首先是输入，因为对 Calling Convention 不够敬畏卡了至少一个钟。

没有在自己定义的函数中保存 ra ，，，，

然后还有，已经有 fread ，我还使用循环读入。。那个版本也保留了。

最后采取了直接 fread 整个数组，哦对的对的。

最后的 classify.s 写成石山代码了

包括但不限于： s6 原本用于存放结果矩阵的，结果忘记用了。

还有神秘的破坏抽象屏障的在 matmul 函数外面就判断矩阵是否合法，因为我的寄存器不够用了（笑哭）

然后 venus 调试器，根本无法 fopen ，愤怒。

采用本地古法调试，分段输出想看的调试值，累累。

总之就是非常坐牢

手写 unittest 不知道何意味。 最后的 test classify 开摆了。

我觉得我写的代码量已经可以证明我完成了这个 proj 。

在根目录下，运行

```
java -jar tools/venus.jar src/main.s -ms -1 inputs/mnist/bin/m0.bin inputs/mnist/bin/m1.bin inputs/mnist/bin/inputs/mnist_input8.bin  outputs/test_mnist_main/student_mnist_outputs.bin
```

可以看看自己 MNIST 的结果，基本上都是对的。