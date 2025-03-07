USE spa_db;

SELECT * FROM clientes;

SELECT * FROM servicos;

-- Listar agendamentos com informações do cliente e do serviço
SELECT 
    a.id_agendamento, 
    c.nome AS nome_cliente, 
    s.nome_servico, 
    a.dia, 
    a.horario, 
    a.qtd_participantes
FROM agendamentos a
JOIN clientes c ON a.id_cliente = c.id_cliente
JOIN servicos s ON a.id_servico = s.id_servico;

-- Listar procedimentos com valor final e detalhes do serviço
SELECT 
    p.id_procedimento, 
    a.id_agendamento, 
    s.nome_servico, 
    p.valor_adicional, 
    p.desconto, 
    p.valor_final
FROM procedimentos p
JOIN agendamentos a ON p.id_agendamento = a.id_agendamento
JOIN servicos s ON a.id_servico = s.id_servico;

--  Listar os funcionários envolvidos em um determinado procedimento
SELECT 
    pf.id_procedimento, 
    f.nome AS nome_funcionario
FROM procedimento_funcionarios pf
JOIN funcionarios f ON pf.id_funcionario = f.id_funcionario
WHERE pf.id_procedimento = 1;		

-- Listar procedimentos que possuem valor adicional ou desconto aplicado
SELECT 
    p.id_procedimento, 
    a.id_agendamento, 
    s.nome_servico, 
    p.valor_adicional, 
    p.desconto, 
    p.valor_final
FROM procedimentos p
JOIN agendamentos a ON p.id_agendamento = a.id_agendamento
JOIN servicos s ON a.id_servico = s.id_servico
WHERE p.valor_adicional > 0 OR p.desconto > 0;

-- Listar Agendamentos para um dia específico
SELECT * FROM agendamentos
WHERE dia = '2025-02-06';

-- faturamento por mes
SELECT 
    YEAR(a.dia) AS ano,
    MONTH(a.dia) AS mes,
    SUM(p.valor_final) AS faturamento_total
FROM agendamentos a
JOIN procedimentos p ON a.id_agendamento = p.id_agendamento
GROUP BY ano, mes
ORDER BY ano, mes;

-- servicos mais procurados baseado na qtd de agendamentos
SELECT 
    s.nome_servico, 
    COUNT(a.id_agendamento) AS total_agendamentos
FROM agendamentos a
JOIN servicos s ON a.id_servico = s.id_servico
GROUP BY s.nome_servico
ORDER BY total_agendamentos DESC;


-- funcionarios com mais comissoes
SELECT 
    f.nome, 
    SUM(c.valor_comissao) AS total_comissao
FROM funcionarios f
JOIN comissoes c ON f.id_funcionario = c.id_funcionario
GROUP BY f.nome
ORDER BY total_comissao DESC;


-- avaliacoes / feedbacks
SELECT 
    c.nome AS nome_cliente, 
    AVG(f.nota) AS media_nota,
    COUNT(f.id_feedback) AS total_feedback
FROM feedbacks f
JOIN agendamentos a ON f.id_agendamento = a.id_agendamento
JOIN clientes c ON a.id_cliente = c.id_cliente
GROUP BY c.nome
ORDER BY media_nota DESC;
