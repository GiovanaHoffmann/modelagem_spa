USE spa_db;

INSERT INTO servicos (nome_servico, pacote, duracao, preco) VALUES 
('Experiência Zen', 'Pacote A', '02:00:00', 370.00),
('Massagem Relaxante', 'Pacote B', '00:50:00', 120.00),
('Experiência Refúgio', 'Pacote C', '02:30:00', 410.00),
('Massagem Terapeutica', 'Pacote D', '01:00:00', 135.00),
('Experiência Harmonia', 'Pacote E', '01:30:00', 200.00);

INSERT INTO clientes (nome, cpf, telefone) VALUES 
('João Silva', '12345678901', '43996352619'),
('Maria Souza', '23456789012', '43981261761'),
('Pedro Santos', '34567890123', '43999068794');

INSERT INTO funcionarios (nome) VALUES 
('Carlos Oliveira'),
('Ana Pereira'),
('Luiz Almeida');

-- Cada agendamento referencia um cliente e um serviço previamente inseridos
INSERT INTO agendamentos (id_cliente, id_servico, dia, horario, qtd_participantes)
VALUES 
  (1, 1, '2025-02-05', '10:00:00', 1),
  (2, 2, '2025-02-06', '14:00:00', 2),
  (3, 3, '2025-02-07', '09:30:00', 3);

-- Observe que o campo valor_final é inserido como 0, pois o trigger irá recalculá-lo automaticamente.
-- O trigger calcula: valor_final = preco do serviço + IFNULL(valor_adicional,0) - IFNULL(desconto,0)
INSERT INTO procedimentos (id_agendamento, adicional, descricao_adicional, valor_adicional, desconto, valor_final)
VALUES
  (1, FALSE, 'Sem adicional', 0, 0, 0),
  (2, TRUE, 'Com adicional', 20.00, 5.00, 0),
  (3, TRUE, 'Adicional aplicado', 30.00, 10.00, 0);

INSERT INTO procedimento_funcionarios (id_procedimento, id_funcionario) VALUES 
  (1, 1),
  (1, 2),
  (2, 2),
  (2, 3),
  (3, 1),
  (3, 3);
