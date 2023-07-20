#include <stdio.h>
#include <stdlib.h>

int main(){
    //estrutura de dados
    int l, c, linha, coluna, jogador, ganhou, jogadas, opcao;
    char jogo [3][3];
 do{  
    jogador = 1; 
    ganhou = 0;
    jogadas = 0;
    //inicializador da estrutura de dados
    for (l = 0; l < 3; l++){
        for (c = 0; c < 3; c++){
            jogo [l][c] = ' ';
        }
    }

    do{
        //imprimir jogo na tela
        printf("\n\n\t 0   1   2\n\n");
        for (l = 0; l < 3; l++){
            for (c = 0; c < 3; c++){
                if(c == 0)
                printf("\t");
                printf(" %c ", jogo[l][c]);
                if (c < 2)
                printf("|");
                if (c == 2)
                printf("  %d", l);
                {
                    /* code */
                }
                
            }
            if (l < 2)
            printf("\n\t-----------");
            printf("\n");
        }
        //ler coordenadadas
        do{
            printf("Digite a linha e a coluna que deseja jogar: ");
            scanf("%d%d", &linha, &coluna);
        }while (linha < 0 || linha > 2 || coluna < 0 || coluna > 2 || jogo[linha][coluna] != ' ');
        //salvar coordenadas
        if(jogador == 1) {
                jogo[linha][coluna] = '0';
                jogador++;
        }
        else{
                jogo[linha][coluna] = 'X';
                jogador =1;
        }
        //alguem ganhou por uma linha
        if(jogo[0][0] == '0' && jogo[0][1] == '0' && jogo [0][2] == '0' ||
            jogo[1][0] == '0' && jogo[1][1] == '0' && jogo [1][2] == '0' ||
            jogo[2][0] == '0' && jogo[2][1] == '0' && jogo [2][2] == '0'){
            printf("\nJogador 1 venceu\n");
            ganhou = 1;
            }

        if(jogo[0][0] == 'X' && jogo[0][1] == 'X' && jogo [0][2] == 'X' ||
            jogo[1][0] == 'X' && jogo[1][1] == 'X' && jogo [1][2] == 'X' ||
            jogo[2][0] == 'X' && jogo[2][1] == 'X' && jogo [2][2] == 'X'){
            printf("\nJogador 2 venceu\n");
            ganhou = 1;
            }


        //alguem ganhou por uma coluna
        if(jogo[0][0] == '0' && jogo[1][0] == '0' && jogo [2][0] == '0' ||
            jogo[0][1] == '0' && jogo[1][1] == '0' && jogo [2][1] == '0' ||
            jogo[0][2] == '0' && jogo[1][2] == '0' && jogo [2][2] == '0'){
            printf("\nJogador 1 venceu\n");
            ganhou = 1;
            }

        if(jogo[0][0] == 'X' && jogo[1][0] == 'X' && jogo [2][0] == 'X' ||
            jogo[0][1] == 'X' && jogo[1][1] == 'X' && jogo [2][1] == 'X' ||
            jogo[0][2] == 'X' && jogo[1][2] == 'X' && jogo [2][2] == 'X'){
            printf("\nJogador 2 venceu\n");
            ganhou = 1;
            }


        //alguem ganhou na diagonal principal 
        if(jogo[0][0] == '0' && jogo[1][1] == '0' && jogo [2][2] == '0'){
            printf("\nJogador 1 venceu\n");
            ganhou = 1;
            }

        if(jogo[0][0] == 'X' && jogo[1][0] == 'X' && jogo [2][0] == 'X'){
            printf("\nJogador 2 venceu\n");
            ganhou = 1;
            }


        //alguem ganhou na diagonal secundaria
        if(jogo[0][2] == '0' && jogo[1][1] == '0' && jogo [2][0] == '0'){
            printf("\nJogador 1 venceu\n");
            ganhou = 1;
            }

        if(jogo[0][2] == 'X' && jogo[1][1] == 'X' && jogo [2][0] == 'X'){
            printf("\nJogador 2 venceu\n");
            ganhou = 1;
            }
    }while (ganhou == 0 && jogadas < 9);

    if(ganhou == 0)
    printf("\nEMPATE");

    printf("Digite 1 para jogar novamente");
    scanf("%d", &opcao);
 }while(opcao == 1);
    
    return 0;
}
// codigo pego no \/ 
//fonte: https://www.youtube.com/watch?v=WPVrj4CyCvM