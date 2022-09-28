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
            as -o display.o display.s
        ```
        ```sh
            ld -o display display.o
        ```

## Executar
          sudo ./main
