#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]){
    float altura, peso,imc;
    printf("Informe sua altura: ");
    scanf("%f",&altura);
    printf("Informe seu peso: ");
    scanf("%f",&peso);
    imc = peso /(altura * altura);
    printf("IMC: %.2f\n",imc);
    if(imc<=18.5)
    { 
        printf("Voce esta abaixo do peso!!");
    }
    else
    {
        if(imc<=25)
        {
            printf("Voce esta com peso normal");
        }
        else
        {
            if(imc<=30)
            {
                printf("Voce esta acima do peso!");
            }
            else
            {
                printf("Voce esta obeso!");
            }
        }
    }
    
    return 0;
}