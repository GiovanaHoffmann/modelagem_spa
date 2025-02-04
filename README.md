# Controle de SPA - Sistema de Agendamento e Procedimentos

Este repositório contém o código SQL para um sistema de controle de um SPA, que gerencia o cadastro de clientes, serviços, funcionários, agendamentos e procedimentos. O sistema automatiza o cálculo do valor final dos procedimentos, garantindo que os dados sejam inseridos e calculados de forma consistente.

---

## Regras de Negócio

- **Clientes:**  
  - Cada cliente possui cadastro com informações como nome e CPF.  
  - Um cliente pode realizar vários agendamentos.

- **Serviços:**  
  - O SPA oferece diversos serviços (ou experiências), cada um com nome, pacote, duração e preço.  
  - Cada serviço pode ser agendado por vários clientes.

- **Funcionários:**  
  - Cada funcionário possui cadastro com informações essenciais, como o nome.  
  - Um procedimento pode envolver mais de um funcionário (relacionamento N:N), implementado por uma tabela associativa.

- **Agendamentos:**  
  - Cada agendamento está vinculado a um único cliente e a um único serviço.  
  - São registradas a data, o horário e a quantidade de participantes, permitindo que um cliente agende o serviço para mais de uma pessoa.

- **Procedimentos:**  
  - Cada agendamento possui um procedimento associado que registra se o serviço foi realizado, se houve valor adicional e se foi aplicado algum desconto.  
  - O procedimento reúne informações do agendamento, do serviço prestado e dos funcionários envolvidos.  
  - O valor final do procedimento é obtido somando o preço do serviço com o valor adicional e subtraindo o desconto.

---

## Funcionamento do Trigger

O sistema utiliza um trigger para automatizar o cálculo do valor final dos procedimentos, garantindo que esse valor seja sempre consistente e calculado automaticamente.

**Como o trigger funciona:**

1. **Execução Automática:**  
   Sempre que um novo registro é inserido na tabela `procedimentos`, o trigger `trg_procedimentos_before_insert` é acionado **antes** da inserção.

2. **Busca do Preço do Serviço:**  
   O trigger realiza uma consulta que cruza as tabelas `agendamentos` e `servicos` para recuperar o preço do serviço associado ao agendamento do procedimento em questão. Esse preço é armazenado em uma variável interna.

3. **Cálculo do Valor Final:**  
   Com o preço do serviço obtido, o trigger soma o valor adicional (caso exista) e subtrai o desconto (caso seja informado). Essa operação é realizada utilizando funções como `IFNULL` para tratar valores nulos, garantindo que se não houver valor adicional ou desconto, o sistema considere 0 nesses casos.  
   Por fim, o resultado é atribuído automaticamente ao campo `valor_final` do novo registro na tabela `procedimentos`.

Esse mecanismo automatiza o processo de cálculo e assegura que o valor final seja sempre derivado dos dados atualizados do serviço, dos adicionais e dos descontos aplicados.

---

## Estrutura do Banco de Dados

A modelagem contempla as seguintes tabelas:

- **clientes:** Armazena informações dos clientes (id, nome, CPF).  
- **servicos:** Contém dados dos serviços oferecidos (id, nome, pacote, duração e preço).  
- **funcionarios:** Registra os dados dos funcionários (id, nome).  
- **agendamentos:** Relaciona o cliente ao serviço agendado, incluindo data, horário e quantidade de participantes.  
- **procedimentos:** Associa cada agendamento a um procedimento, registrando informações adicionais, como valor adicional, desconto e valor final.  
- **procedimento_funcionarios:** Tabela associativa que relaciona os procedimentos aos funcionários envolvidos, implementando o relacionamento N:N.

---

# Diagrama do Banco de Dados

```mermaid
erDiagram
    CLIENTES {
      INT id_cliente PK
      VARCHAR(40) nome
      VARCHAR(12) cpf
    }
    SERVICOS {
      INT id_servico PK
      VARCHAR(45) nome_servico
      VARCHAR(45) pacote
      TIME duracao
      FLOAT preco
    }
    FUNCIONARIOS {
      INT id_funcionario PK
      VARCHAR(45) nome
    }
    AGENDAMENTOS {
      INT id_agendamento PK
      INT id_cliente
      INT id_servico
      DATE dia
      TIME horario
      INT qtd_participantes
    }
    PROCEDIMENTOS {
      INT id_procedimento PK
      INT id_agendamento
      BOOLEAN adicional
      VARCHAR(45) descricao_adicional
      FLOAT valor_adicional
      FLOAT desconto
      FLOAT valor_final
    }
    PROCEDIMENTO_FUNCIONARIOS {
      INT id_procedimento
      INT id_funcionario
    }

    CLIENTES ||--o{ AGENDAMENTOS : realiza
    SERVICOS ||--o{ AGENDAMENTOS : oferece
    AGENDAMENTOS ||--|| PROCEDIMENTOS : gera
    PROCEDIMENTOS ||--o{ PROCEDIMENTO_FUNCIONARIOS : associa
    FUNCIONARIOS ||--o{ PROCEDIMENTO_FUNCIONARIOS : atua em

