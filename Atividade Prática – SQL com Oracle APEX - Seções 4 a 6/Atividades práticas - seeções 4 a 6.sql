-- Parte 1 – Funções de Caracteres, Números e Datas (Seção 4)

-- 1. Exiba os nomes dos clientes com todas as letras em maiúsculas.

SELECT UPPER(CLIENTE_NOME) AS NOME_MAIUSCULO
FROM Cliente;

-- 2. Exiba os nomes dos clientes formatados com apenas a primeira letra maiúscula.

SELECT UPPER(SUBSTR(CLIENTE_NOME, 1, 1)) || LOWER(SUBSTR(CLIENTE_NOME, 2)) AS NOME_FORMATADO
FROM Cliente;

-- 3. Mostre as três primeiras letras do nome de cada cliente.

SELECT SUBSTR(CLIENTE_NOME, 1, 3) AS TRES_PRIMEIRAS_LETRAS
FROM Cliente;

-- 4. Exiba o número de caracteres do nome de cada cliente.

SELECT CLIENTE_NOME, LENGTH(CLIENTE_NOME) AS NUMERO_CARACTERES
FROM Cliente;

-- 5. Apresente o saldo de todas as contas, arredondado para o inteiro mais próximo.

SELECT CONTA_NUMERO, ROUND(SALDO) AS SALDO_ARREDONDADO
FROM Conta;

-- 6. Exiba o saldo truncado, sem casas decimais.

SELECT CONTA_NUMERO, TRUNC(SALDO) AS SALDO_TRUNCADO
FROM Conta;

-- 7. Mostre o resto da divisão do saldo da conta por 1000.

SELECT CONTA_NUMERO, SALDO, MOD(SALDO, 1000) AS RESTO_DIVISAO_1000
FROM Conta;

-- 8. Exiba a data atual do servidor do banco.

SELECT TO_CHAR(SYSDATE, 'DD/MM/YYYY') AS DATA_ATUAL_SERVIDOR
FROM DUAL;

-- 9. Adicione 30 dias à data atual e exiba como "Data de vencimento simulada".

SELECT TO_CHAR(SYSDATE, 'DD/MM/YYYY') AS DATA_ATUAL, TO_CHAR(SYSDATE + 30, 'DD/MM/YYYY') AS DATA_VENCIMENTO_SIMULADA
FROM DUAL;

-- 10. Exiba o número de dias entre a data de abertura da conta e a data atual.

-- Parte 2 – Conversão de Dados e Tratamento de Nulos (Seção 5)

-- 11. Apresente o saldo de cada conta formatado como moeda local.

SELECT CONTA_NUMERO, 'R$ ' || TO_CHAR(SALDO, '999,999.99') AS SALDO_FORMATADO
FROM Conta;

-- 12. Converta a data de abertura da conta para o formato 'dd/mm/yyyy'.



-- 13. Exiba o saldo da conta e substitua valores nulos por 0.

SELECT CONTA_NUMERO, NVL(SALDO, 0) AS SALDO_ATUAL
FROM Conta;

-- 14. Exiba os nomes dos clientes e substitua valores nulos na cidade por 'Sem cidade'.

SELECT CLIENTE_NOME, NVL(CIDADE, 'Sem cidade') AS CIDADE
FROM Cliente;

-- 15. Classifique os clientes em grupos com base em sua cidade:
-- o 'Região Metropolitana' se forem de Niterói
-- o 'Interior' se forem de Resende
-- o 'Outra Região' para as demais cidades

SELECT CLIENTE_NOME,
    CASE 
        WHEN CIDADE = 'Niterói' THEN 'Região Metropolitana'
        WHEN CIDADE = 'Resende' THEN 'Interior'
        ELSE 'Outra Região'
    END AS REGIAO
FROM Cliente;

-- Parte 3 – Junções entre Tabelas (Seção 6)

-- 16.Exiba o nome de cada cliente, o número da conta e o saldo correspondente.

SELECT c.CLIENTE_NOME, ct.CONTA_NUMERO, ct.SALDO
FROM Cliente c
JOIN Conta ct ON c.CLIENTE_COD = ct.CLIENTE_CLIENTE_COD

-- 17. Liste os nomes dos clientes e os nomes das agências onde mantêm conta.

SELECT c.CLIENTE_NOME, a.AGENCIA_NOME
FROM Cliente c
JOIN Conta ct ON c.CLIENTE_COD = ct.CLIENTE_CLIENTE_COD
JOIN Agencia a ON ct.AGENCIA_AGENCIA_COD = a.AGENCIA_COD

-- 18. Mostre todas as agências, mesmo aquelas que não possuem clientes vinculados (junção
externa esquerda).

SELECT a.AGENCIA_NOME, a.AGENCIA_CIDADE
FROM Agencia a
LEFT JOIN Conta ct ON a.AGENCIA_COD = ct.AGENCIA_AGENCIA_COD
LEFT JOIN Cliente c ON ct.CLIENTE_CLIENTE_COD = c.CLIENTE_COD
GROUP BY
    a.AGENCIA_NOME, a.AGENCIA_CIDADE



