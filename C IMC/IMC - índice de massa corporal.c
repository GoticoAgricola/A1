#include <stdio.h>

int main() {
    float peso, altura, imc;

    printf("Calculadora de IMC\n");
    printf("Digite o seu peso (em kg): ");
    scanf("%f", &peso);

    printf("Digite a sua altura (em metros): ");
    scanf("%f", &altura);

    // Cálculo do IMC
    imc = peso / (altura * altura);

    printf("Seu IMC é: %.2f\n", imc);

    // Interpretando o resultado
    if (imc < 18.5) {
        printf("Você está abaixo do peso ideal.\n");
    } else if (imc >= 18.5 && imc < 25) {
        printf("Seu peso está dentro da faixa considerada normal.\n");
    } else if (imc >= 25 && imc < 30) {
        printf("Você está com sobrepeso.\n");
    } else {
        printf("Você está com obesidade.\n");
    }

    return 0;
}


// EXEMPLO DE COMO USAR
// PESO 100.00 
// ALTURA 1.80 
// TEM QUE COLOCAR OS PONTO




