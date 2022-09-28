# Instruções


## Montar e linkar

### Com Makefile

          all:main
          main:main.o
                    ld -o main main.o
          main.o:main.s
                    as -o main.o main.s

          
### Sem Makefile
```sh
            as -g -o main.o main.s
```
          
```sh
            ld -o main main.o
```

## Executar
          sudo ./main
          
## GDB
```sh
                    sudo gdb ./main
```
          
```sh
            b _start
```
```sh
            run
```
