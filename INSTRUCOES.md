# Instruções


## Montar e linkar

### Com Makefile

          all:main
          main:main.o
                    ld -o main main.o
          main.o:main.s
                    as -o main.o main.s

          
# Sem Makefile
          ```sh
          as main.s -o main.o
          ```sh
          ld main.o -o main
          ```sh

## Executar
          sudo ./main
