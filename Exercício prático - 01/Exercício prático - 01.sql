-- 1. Liste todos os alunos matriculados no curso de "Banco de Dados".

SELECT a.aluno_id, a.nome, a.email FROM aluno a
JOIN matricula m ON a.aluno_id = m.aluno_id
JOIN curso c ON m.curso_id = c.curso_id
WHERE c.curso_id = 101;

-- 2. Liste todos os cursos com carga horária maior que 40 horas.

SELECT c.curso_id, c.titulo, c.carga_horaria FROM curso c
WHERE c.carga_horaria > 40;

-- 3. Liste os alunos que ainda não receberam nota.

SELECT a.aluno_id, a.nome, a.email FROM aluno a
JOIN matricula m ON a.aluno_id = m.aluno_id
WHERE m.nota is NULL;

-- 4. Liste as matrículas realizadas depois do dia 01/01/2024.

SELECT m.aluno_id, m.curso_id, m.data_matricula, m.nota FROM matricula m
WHERE m.data_matricula > '01-01-2024';

-- 5. Mostre os cursos com carga horária entre 30 e 60 horas.

SELECT c.curso_id, c.titulo, c.carga_horaria FROM curso c
WHERE c.carga_horaria BETWEEN 30 AND 60;

-- 6. Liste os alunos com e-mails do domínio @gmail.com.

SELECT a.aluno_id, a.nome, a.email FROM aluno a
WHERE a.email LIKE '%@gmail.com'

-- 7. Liste o nome do aluno, título do curso e data da matrícula.

SELECT a.nome, c.titulo, m.data_matricula FROM aluno a
JOIN matricula m ON a.aluno_id = m.aluno_id
JOIN curso c ON m.curso_id = c.curso_id;

-- 8. Liste os alunos e as notas que receberam em cada curso.

SELECT a.aluno_id, a.nome, a.email, c.titulo, m.nota FROM aluno a
JOIN matricula m ON a.aluno_id = m.aluno_id
JOIN curso c ON m.curso_id = c.curso_id;

-- 9. Mostre os cursos que o aluno chamado "João Silva" está matriculado.

SELECT c.curso_id, c.titulo, c.carga_horaria FROM curso c
JOIN matricula m ON c.curso_id = m.curso_id
JOIN aluno a ON m.aluno_id = a.aluno_id
WHERE a.nome = 'João Silva';

-- 10. Liste os títulos dos cursos que possuem mais de um aluno matriculado.

SELECT c.titulo FROM curso c
JOIN matricula m ON c.curso_id = m.curso_id
GROUP BY c.titulo
HAVING COUNT(m.curso_id) > 1;

-- 11. Mostre todos os alunos sem matrícula em nenhum curso.

SELECT a.aluno_id, a.nome, a.email FROM aluno a
JOIN matricula m ON a.aluno_id = m.aluno_id
GROUP BY a.aluno_id, a.nome, a.email
HAVING COUNT(m.curso_id) = 0;

-- 12. Mostre os cursos sem nenhum aluno matriculado.

SELECT c.curso_id, c.titulo, c.carga_horaria FROM curso c
JOIN matricula m ON c.curso_id = m.curso_id
GROUP BY c.curso_id, c.titulo, c.carga_horaria
HAVING COUNT(m.aluno_id) = 0;

-- 13. Liste os nomes dos alunos e a quantidade de cursos em que estão matriculados.

SELECT a.nome, COUNT(m.curso_id) AS quantidade_cursos FROM matricula m
JOIN aluno a ON m.aluno_id = a.aluno_id
GROUP BY a.nome;







