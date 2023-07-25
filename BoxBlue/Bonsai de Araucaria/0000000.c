#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    int n = 10; //atribuindo valor para a variavel
    float n2 = 6.79; //float e uma variavel que possui casas decimais
    char letra = 'a'; //variavel do tipo caracter 
    char frase[10] = "Bom Dia!";
    double n3 = 1.23456; //variavel real com precisao dupla

    int valor1, valor2, soma, sub, mult, di, numero, resto;
    /*
    //usos do comando printf com diversas variaveis
    printf("oi mundo!\n");
    printf("Exibindo numero inteiro %d\n", n);
    printf("Exibindo um numero real %f\n", n2);
    printf("Exibindo o caracter %c\n", letra);
    printf("%s\n", frase);
    printf("Exibindo variavel do tipo double %f\n", n3);
    printf("Valores: %d %f %c %s %f\n", n, n2, letra, frase, n3);

    //utilizacao do scanf
    printf("Digite um numero inteiro: ");
    scanf("%d", &valor1); 
    printf("Digite outro numero inteiro: ");
    scanf("%d", &valor2); 

    //operadores aritmeticos
    soma = valor1 + valor2;
    sub = valor1 - valor2;
    mult = valor1 * valor2;
    di = valor1 / valor2;
    printf("Valor da soma de %d + %d = %d \n", valor1, valor2, soma);
    printf("Valor da subtracao de %d - %d = %d \n", valor1, valor2, sub);
    printf("Valor da multiplicacao de %d * %d = %d \n", valor1, valor2, mult);
    printf("Valor da divisao de %d / %d = %d \n", valor1, valor2, di);
    */

    printf("Digite outro numero inteiro: ");
    scanf("%d", &numero);

    resto = numero % 2;

    printf("Resto da divisao: %d\n", resto);



    system("pause"); //somente windows
    return 0;

}