def calcular_imc(peso, altura):
    # O IMC é calculado dividindo o peso em kg pela altura ao quadrado em metros
    imc = peso / (altura ** 2)
    return imc

def interpretar_imc(imc):
    if imc < 18.5:
        return "Abaixo do peso"
    elif imc < 24.9:
        return "Peso normal"
    elif imc < 29.9:
        return "Sobrepeso"
    elif imc < 34.9:
        return "Obesidade Grau I"
    elif imc < 39.9:
        return "Obesidade Grau II"
    else:
        return "Obesidade Grau III"

def main():
    try:
        peso = float(input("Digite o seu peso (em kg): "))
        altura = float(input("Digite a sua altura (em metros): "))
        imc = calcular_imc(peso, altura)
        print(f"O seu IMC é: {imc:.2f}")
        classificacao = interpretar_imc(imc)
        print(f"Classificação: {classificacao}")
    except ValueError:
        print("Valores inválidos. Certifique-se de digitar números válidos para peso e altura.")

if __name__ == "__main__":
    main()



# EXEMPLO DE COMO USAR
# PESO 100.00 
# ALTURA 1.80 
# TEM QUE COLOCAR OS PONTO