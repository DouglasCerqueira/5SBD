-- Parte 1 – Junções e Produto Cartesiano (Seção 7)
-- 1. Usando a sintaxe proprietária da Oracle, exiba o nome de cada cliente junto com o número de sua conta.

SELECT c.CLIENTE_NOME, ct.CONTA_NUMERO
FROM Cliente c, Conta ct
WHERE c.CLIENTE_COD = ct.CLIENTE_CLIENTE_COD(+)
ORDER BY c.CLIENTE_NOME;

-- 2. Mostre todas as combinações possíveis de clientes e agências (produto cartesiano).

SELECT c.CLIENTE_NOME, a.AGENCIA_NOME, a.AGENCIA_CIDADE
FROM Cliente c, Agencia a
ORDER BY c.CLIENTE_NOME, a.AGENCIA_NOME;

-- 3. Usando aliases de tabela, exiba o nome dos clientes e a cidade da agência onde mantêm conta.

SELECT c.CLIENTE_NOME AS "Nome do Cliente", ag.AGENCIA_CIDADE AS "Cidade da Agência"
FROM Cliente c
JOIN Conta ct ON c.CLIENTE_COD = ct.CLIENTE_CLIENTE_COD
JOIN Agencia ag ON ct.AGENCIA_AGENCIA_COD = ag.AGENCIA_COD
ORDER BY c.CLIENTE_NOME;

-- Parte 2 – Funções de Grupo, COUNT, DISTINCT e NVL (Seção 8)
-- 4. Exiba o saldo total de todas as contas cadastradas.

SELECT 'R$ ' || TO_CHAR(SUM(NVL(SALDO, 0)), '999,999.99') AS SALDO_TOTAL
FROM Conta;

-- 5. Mostre o maior saldo e a média de saldo entre todas as contas.

SELECT 'R$ ' || TO_CHAR(MAX(SALDO), '999,999.99') AS "MAIOR_SALDO", 'R$ ' || TO_CHAR(AVG(SALDO), '999,999.99') AS "MEDIA_SALDOS"
FROM Conta;

-- 6. Apresente a quantidade total de contas cadastradas.

SELECT COUNT(*) AS "TOTAL_CONTAS_CADASTRADAS"
FROM Conta;

-- 7. Liste o número de cidades distintas onde os clientes residem.

SELECT COUNT(DISTINCT CIDADE) AS "TOTAL_CIDADES_DISTINTAS"
FROM Cliente;

-- 8. Exiba o número da conta e o saldo, substituindo valores nulos por zero.

SELECT CONTA_NUMERO, NVL(SALDO, 0) AS "Saldo"
FROM Conta;

-- Parte 3 – GROUP BY, HAVING, ROLLUP e Operadores de Conjunto (Seção 9)
-- 9. Exiba a média de saldo por cidade dos clientes.

SELECT c.CIDADE AS "Cidade", 'R$ ' || TO_CHAR(AVG(ct.SALDO), '999,999.99') AS "Média de Saldo"
FROM Cliente c
JOIN Conta ct ON c.CLIENTE_COD = ct.CLIENTE_CLIENTE_COD
GROUP BY c.CIDADE
ORDER BY
    AVG(ct.SALDO) DESC;

-- 10. Liste apenas as cidades com mais de 3 contas associadas a seus moradores.

SELECT c.CIDADE, COUNT(ct.CONTA_NUMERO) AS "Total de Contas"
FROM Cliente c
JOIN Conta ct ON c.CLIENTE_COD = ct.CLIENTE_CLIENTE_COD
GROUP BY
    c.CIDADE
HAVING
    COUNT(ct.CONTA_NUMERO) > 3
ORDER BY
    COUNT(ct.CONTA_NUMERO) DESC;

-- 11.Utilize a cláusula ROLLUP para exibir o total de saldos por cidade da agência e o total geral.

SELECT NVL(a.AGENCIA_CIDADE, 'TOTAL GERAL') AS "Cidade da Agência", 'R$ ' || TO_CHAR(SUM(c.SALDO), '999,999.99') AS "Total de Saldos", COUNT(c.CONTA_NUMERO) AS "Quantidade de Contas"
FROM Conta c
JOIN Agencia a ON c.AGENCIA_AGENCIA_COD = a.AGENCIA_COD
GROUP BY
    ROLLUP(a.AGENCIA_CIDADE)
ORDER BY
    a.AGENCIA_CIDADE;

-- 12. Faça uma consulta com UNION que combine os nomes de cidades dos clientes e das agências, sem repetições.

SELECT DISTINCT CIDADE
FROM (
    SELECT AGENCIA_CIDADE AS CIDADE FROM Agencia
    UNION
    SELECT CIDADE FROM Cliente
)
ORDER BY CIDADE;

-- Atividade Prática – SQL com Oracle APEX
-- Seção 10 – Subconsultas
-- Tema: Subconsultas de linha única, multilinha, correlacionadas, com EXISTS, NOT EXISTS e a cláusula WITH.
-- Ferramenta: Oracle APEX – SQL Workshop
-- Base de dados utilizada: Sistema bancário (agencia, cliente, conta, emprestimo)

-- Parte 1 – Subconsultas de Linha Única
-- 1. Liste os nomes dos clientes cujas contas possuem saldo acima da média geral de todas as contas registradas.

SELECT c.CLIENTE_NOME, 'R$ ' ||TO_CHAR(ct.SALDO, '999,999.99') AS "Saldo", 'R$ ' ||TO_CHAR((SELECT AVG(SALDO) FROM Conta), '999,999.99') AS "Média Geral"
FROM  Cliente c
JOIN Conta ct ON c.CLIENTE_COD = ct.CLIENTE_CLIENTE_COD
WHERE ct.SALDO > (SELECT AVG(SALDO) FROM Conta)
ORDER BY 
    ct.SALDO DESC;

-- 2. Exiba os nomes dos clientes cujos saldos são iguais ao maior saldo encontrado no banco.

SELECT c.CLIENTE_NOME, 'R$ ' || TO_CHAR(ct.SALDO, '999,999.99') AS "Saldo"
FROM Cliente c
JOIN Conta ct ON c.CLIENTE_COD = ct.CLIENTE_CLIENTE_COD
WHERE ct.SALDO = (SELECT MAX(SALDO) FROM Conta)
ORDER BY
    c.CLIENTE_NOME;

-- 3. Liste as cidades onde a quantidade de clientes é maior que a quantidade média de clientes por cidade.

SELECT CIDADE, COUNT(*) AS "Quantidade de Clientes"
FROM Cliente
GROUP BY CIDADE
HAVING
    COUNT(*) > (
        SELECT AVG(COUNT(*))
        FROM Cliente
        GROUP BY CIDADE
    )
ORDER BY
    COUNT(*) DESC;

-- Parte 2 – Subconsultas Multilinha
-- 4. Liste os nomes dos clientes com saldo igual a qualquer um dos dez maiores saldos registrados.

SELECT c.CLIENTE_NOME, 'R$ ' || TO_CHAR(ct.SALDO, '999,999.99') AS "Saldo"
FROM Cliente c
JOIN Conta ct ON c.CLIENTE_COD = ct.CLIENTE_CLIENTE_COD
WHERE
    ct.SALDO IN (
        SELECT SALDO
        FROM (
            SELECT SALDO
            FROM Conta
            ORDER BY SALDO DESC
        )
        WHERE ROWNUM <= 10
    )
ORDER BY
    ct.SALDO DESC;

-- 5. Liste os clientes que possuem saldo menor que todos os saldos dos clientes da cidade de Niterói.

SELECT c.CLIENTE_NOME
FROM Cliente c
JOIN
    Conta ct ON c.CLIENTE_COD = ct.CLIENTE_CLIENTE_COD
WHERE
    ct.SALDO < ALL (
        SELECT ct2.SALDO
        FROM Conta ct2
        JOIN Cliente c2 ON ct2.CLIENTE_CLIENTE_COD = c2.CLIENTE_COD
        WHERE UPPER(c2.CIDADE) = 'NITERÓI'
    )

-- 6. Liste os clientes cujos saldos estão entre os saldos de clientes de Volta Redonda.

SELECT c.CLIENTE_NOME
FROM Cliente c
JOIN Conta ct ON c.CLIENTE_COD = ct.CLIENTE_CLIENTE_COD
WHERE
    ct.SALDO BETWEEN (
        SELECT MIN(ct2.SALDO)
        FROM Conta ct2
        JOIN Cliente c2 ON ct2.CLIENTE_CLIENTE_COD = c2.CLIENTE_COD
        WHERE UPPER(c2.CIDADE) = 'VOLTA REDONDA'
    ) AND (
        SELECT MAX(ct3.SALDO)
        FROM Conta ct3
        JOIN Cliente c3 ON ct3.CLIENTE_CLIENTE_COD = c3.CLIENTE_COD
        WHERE UPPER(c3.CIDADE) = 'VOLTA REDONDA'
    )
    AND UPPER(c.CIDADE) != 'VOLTA REDONDA'

-- Parte 3 – Subconsultas Correlacionadas
-- 7. Exiba os nomes dos clientes cujos saldos são maiores que a média de saldo das contas da mesma agência.

SELECT
    c.CLIENTE_NOME
FROM Cliente c
JOIN Conta ct ON c.CLIENTE_COD = ct.CLIENTE_CLIENTE_COD
JOIN Agencia a ON ct.AGENCIA_AGENCIA_COD = a.AGENCIA_COD
JOIN
    (
        SELECT
            AGENCIA_AGENCIA_COD,
            AVG(SALDO) AS media_saldo
        FROM
            Conta
        GROUP BY
            AGENCIA_AGENCIA_COD
    ) agencia_media ON ct.AGENCIA_AGENCIA_COD = agencia_media.AGENCIA_AGENCIA_COD
WHERE ct.SALDO > agencia_media.media_saldo

-- 8. Liste os nomes e cidades dos clientes que têm saldo inferior à média de sua própria cidade.

SELECT c.CLIENTE_NOME, c.CIDADE
FROM Cliente c
JOIN Conta ct ON c.CLIENTE_COD = ct.CLIENTE_CLIENTE_COD
JOIN
    (
        SELECT
            cl.CIDADE,
            AVG(co.SALDO) AS media_saldo
        FROM
            Cliente cl
        JOIN
            Conta co ON cl.CLIENTE_COD = co.CLIENTE_CLIENTE_COD
        GROUP BY
            cl.CIDADE
    ) cidade_media ON c.CIDADE = cidade_media.CIDADE
WHERE
    ct.SALDO < cidade_media.media_saldo

-- Parte 4 – Subconsultas com EXISTS e NOT EXISTS
-- 9. Liste os nomes dos clientes que possuem pelo menos uma conta registrada no banco.

SELECT c.CLIENTE_NOME
FROM Cliente c
WHERE
    EXISTS (
        SELECT 1
        FROM Conta ct
        WHERE ct.CLIENTE_CLIENTE_COD = c.CLIENTE_COD
    )
ORDER BY
    c.CLIENTE_NOME;

-- 10. Liste os nomes dos clientes que ainda não possuem conta registrada no banco.

SELECT c.CLIENTE_NOME
FROM Cliente c
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Conta ct
        WHERE ct.CLIENTE_CLIENTE_COD = c.CLIENTE_COD
    )
ORDER BY
    c.CLIENTE_NOME;

-- Parte 5 – Subconsulta Nomeada com WITH
-- 11.Usando a cláusula WITH, calcule a média de saldo por cidade e exiba os clientes que possuem saldo acima da média de sua cidade.

WITH MediaPorCidade AS (
    SELECT c.CIDADE, AVG(ct.SALDO) AS MEDIA_SALDO
    FROM Cliente c
    JOIN  Conta ct ON c.CLIENTE_COD = ct.CLIENTE_CLIENTE_COD
    GROUP BY 
        c.CIDADE
)

SELECT c.CLIENTE_NOME
FROM Cliente c
JOIN  Conta ct ON c.CLIENTE_COD = ct.CLIENTE_CLIENTE_COD
JOIN MediaPorCidade m ON c.CIDADE = m.CIDADE
WHERE  ct.SALDO > m.MEDIA_SALDO
ORDER BY 
    c.CLIENTE_NOME;