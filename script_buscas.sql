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

