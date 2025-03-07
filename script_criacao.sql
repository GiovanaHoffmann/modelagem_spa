CREATE DATABASE IF NOT EXISTS spa_db;
USE spa_db;

-- (Opcional) Remove as tabelas se elas já existirem para evitar erros
DROP TABLE IF EXISTS procedimento_funcionarios;
DROP TABLE IF EXISTS procedimentos;
DROP TABLE IF EXISTS agendamentos;
DROP TABLE IF EXISTS funcionarios;
DROP TABLE IF EXISTS servicos;
DROP TABLE IF EXISTS clientes;

-- Criação das Tabelas
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(40) NOT NULL,
    cpf VARCHAR(12) NOT NULL UNIQUE,
    telefone VARCHAR(12) NOT NULL
);

CREATE TABLE servicos (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    nome_servico VARCHAR(45) NOT NULL,
    pacote VARCHAR(45),
    duracao TIME, 
    preco FLOAT
);

CREATE TABLE funcionarios (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL
);

CREATE TABLE agendamentos (
    id_agendamento INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_servico INT NOT NULL,
    dia DATE NOT NULL,
    horario TIME NOT NULL,
    qtd_participantes INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_servico) REFERENCES servicos(id_servico)
);

CREATE TABLE procedimentos (
    id_procedimento INT AUTO_INCREMENT PRIMARY KEY,
    id_agendamento INT NOT NULL UNIQUE,  -- garante que cada agendamento se relacione com apenas um procedimento
    adicional BOOLEAN DEFAULT FALSE,
    descricao_adicional VARCHAR(45),
    valor_adicional FLOAT,
    desconto FLOAT,
    valor_final FLOAT NOT NULL,
    FOREIGN KEY (id_agendamento) REFERENCES agendamentos(id_agendamento)
);

-- Tabela associativa para ligar procedimentos e funcionários (relacionamento N:N)
CREATE TABLE procedimento_funcionarios (
    id_procedimento INT NOT NULL,
    id_funcionario INT NOT NULL,
    PRIMARY KEY (id_procedimento, id_funcionario),
    FOREIGN KEY (id_procedimento) REFERENCES procedimentos(id_procedimento),
    FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id_funcionario)
);

DELIMITER //
CREATE TRIGGER trg_procedimentos_before_insert
BEFORE INSERT ON procedimentos
FOR EACH ROW
BEGIN
    DECLARE preco_servico FLOAT; 
    -- Busca o preço do serviço relacionado ao agendamento do procedimento
    SELECT s.preco 
      INTO preco_servico
      FROM agendamentos a
      JOIN servicos s ON a.id_servico = s.id_servico
     WHERE a.id_agendamento = NEW.id_agendamento;
    
    SET NEW.valor_final = preco_servico + IFNULL(NEW.valor_adicional, 0) - IFNULL(NEW.desconto, 0);
END;
//
DELIMITER ;

-- Incluir o endereço e e-mail dos clientes
ALTER TABLE clientes
ADD COLUMN email VARCHAR(100),
ADD COLUMN endereco VARCHAR(255);

-- Adicionar uma coluna para o status do agendamento
ALTER TABLE agendamentos
ADD COLUMN status ENUM('Pendente', 'Confirmado', 'Concluído', 'Cancelado') DEFAULT 'Pendente';

CREATE TABLE metodos_pagamento (
    id_metodo INT AUTO_INCREMENT PRIMARY KEY,
    metodo_nome VARCHAR(50) NOT NULL
);

-- Alterar a tabela agendamentos para associar o método de pagamento
ALTER TABLE agendamentos
ADD COLUMN id_metodo_pagamento INT,
ADD FOREIGN KEY (id_metodo_pagamento) REFERENCES metodos_pagamento(id_metodo);

-- controle de comissão dos funcionários com base no valor dos serviços
CREATE TABLE comissoes (
    id_comissao INT AUTO_INCREMENT PRIMARY KEY,
    id_funcionario INT,
    id_procedimento INT,
    percentual_comissao FLOAT,
    valor_comissao FLOAT,
    FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id_funcionario),
    FOREIGN KEY (id_procedimento) REFERENCES procedimentos(id_procedimento)
);

CREATE TABLE feedbacks (
    id_feedback INT AUTO_INCREMENT PRIMARY KEY,
    id_agendamento INT,
    nota INT CHECK (nota >= 1 AND nota <= 5),
    comentario TEXT,
    FOREIGN KEY (id_agendamento) REFERENCES agendamentos(id_agendamento)
);


