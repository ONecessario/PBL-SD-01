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
            as -o main.o main.s
          ```
          ```sh
            ld -o main main.o
          ```

## Executar
          sudo ./main
