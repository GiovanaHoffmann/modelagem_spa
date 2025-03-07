# Controle de SPA - Sistema de Agendamento e Procedimentos

Este repositório contém o código SQL para um sistema de controle de um SPA, permitindo a gestão de clientes, serviços, funcionários, agendamentos e procedimentos. Além disso, o sistema inclui funcionalidades para promoções, métodos de pagamento, comissões e feedbacks, tornando a administração mais eficiente e automatizada.

**Observação:** este projeto foi desenvolvido para fins de estudo e prática, baseado na observação de um cenário real. Para compreender melhor a dinâmica do estabelecimento utilizado como referência, foi realizada uma breve entrevista com a administração do estabelecimento usado como referência.

---

## Regras de Negócio

- **Clientes:**  
  - Cada cliente possui um cadastro com informações como nome, CPF, telefone e endereço.  
  - Um cliente pode realizar vários agendamentos.  

- **Serviços:**  
  - O SPA oferece diversas experiências, cada uma com nome, pacote, duração e preço.  
  - Cada serviço pode ser agendado por vários clientes.  

- **Funcionários:**  
  - Cada funcionário possui um cadastro com nome e ID.  
  - Procedimentos podem envolver mais de um funcionário (relacionamento N:N), implementado por uma tabela associativa.  
  - Funcionários podem receber comissões com base nos procedimentos realizados.  

- **Agendamentos:**  
  - Cada agendamento está vinculado a um único cliente e a um único serviço.  
  - São registradas a data, o horário e a quantidade de participantes.  
  - O status do agendamento pode ser 'Pendente', 'Confirmado', 'Concluído' ou 'Cancelado'.  
  - O cliente pode escolher um método de pagamento no momento do agendamento.  

- **Procedimentos:**  
  - Cada agendamento gera um procedimento associado, registrando valores adicionais, descontos e o valor final.  
  - O valor final do procedimento é calculado automaticamente somando o preço do serviço ao valor adicional e subtraindo o desconto.  

- **Comissões:**  
  - Cada funcionário envolvido em um procedimento recebe uma comissão baseada em um percentual previamente definido.  

- **Feedbacks:**  
  - Após a conclusão de um agendamento, o cliente pode fornecer uma avaliação de 1 a 5 estrelas e um comentário opcional.  

- **Promoções:**  
  - O SPA pode oferecer promoções com descontos aplicados a serviços específicos dentro de um período determinado.  

---

## Funcionamento dos Triggers

O sistema conta com triggers para automatizar operações essenciais, garantindo a consistência dos dados.

### **Cálculo Automático do Valor Final do Procedimento**
1. Sempre que um novo registro é inserido na tabela `procedimentos`, o trigger `trg_procedimentos_before_insert` é acionado **antes** da inserção.  
2. O trigger busca o preço do serviço associado ao agendamento do procedimento.  
3. O valor final do procedimento é calculado somando o preço do serviço ao valor adicional (se houver) e subtraindo o desconto (se existir).  

### **Cálculo Automático das Comissões**
1. Sempre que um procedimento é registrado, o sistema calcula a comissão de cada funcionário envolvido com base no percentual definido.  
2. O valor da comissão é armazenado na tabela `comissoes`, garantindo que os pagamentos aos funcionários sejam registrados corretamente.  

---

## Estrutura do Banco de Dados

A modelagem contempla as seguintes tabelas:

- **clientes:** Armazena informações dos clientes (id, nome, CPF, telefone, email, endereço).  
- **servicos:** Contém dados dos serviços oferecidos (id, nome, pacote, duração, preço).  
- **funcionarios:** Registra os funcionários (id, nome).  
- **agendamentos:** Relaciona o cliente ao serviço agendado, incluindo data, horário, quantidade de participantes e status.  
- **procedimentos:** Associa cada agendamento a um procedimento, registrando valores adicionais, descontos e o valor final.  
- **procedimento_funcionarios:** Tabela associativa que relaciona os procedimentos aos funcionários envolvidos (relacionamento N:N).  
- **metodos_pagamento:** Registra os métodos de pagamento disponíveis.  
- **comissoes:** Armazena as comissões recebidas pelos funcionários com base nos procedimentos realizados.  
- **feedbacks:** Contém avaliações e comentários dos clientes após os agendamentos.  
- **promocoes:** Define promoções e seus períodos de validade.  
- **servicos_promocoes:** Relaciona serviços a promoções aplicáveis.  

---

# Diagrama do Banco de Dados

```mermaid
erDiagram
    CLIENTES {
      INT id_cliente PK
      VARCHAR(40) nome
      VARCHAR(12) cpf
      VARCHAR(12) telefone
      VARCHAR(100) email
      VARCHAR(255) endereco
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
      INT id_cliente FK
      INT id_servico FK
      DATE dia
      TIME horario
      INT qtd_participantes
      VARCHAR(20) status  -- Pode ser 'Pendente', 'Confirmado', 'Concluído', 'Cancelado'
      INT id_metodo_pagamento FK
    }
    PROCEDIMENTOS {
      INT id_procedimento PK
      INT id_agendamento FK
      BOOLEAN adicional
      VARCHAR(45) descricao_adicional
      FLOAT valor_adicional
      FLOAT desconto
      FLOAT valor_final
    }
    PROCEDIMENTO_FUNCIONARIOS {
      INT id_procedimento FK
      INT id_funcionario FK
    }
    METODOS_PAGAMENTO {
      INT id_metodo PK
      VARCHAR(50) metodo_nome
    }
    COMISSOES {
      INT id_comissao PK
      INT id_funcionario FK
      INT id_procedimento FK
      FLOAT percentual_comissao
      FLOAT valor_comissao
    }
    FEEDBACKS {
      INT id_feedback PK
      INT id_agendamento FK
      INT nota CHECK (nota >= 1 AND nota <= 5)
      TEXT comentario
    }
    PROMOCOES {
      INT id_promocao PK
      VARCHAR(100) nome_promocao
      TEXT descricao
      FLOAT desconto_percentual
      DATE data_inicio
      DATE data_fim
    }
    SERVICOS_PROMOCOES {
      INT id_servico FK
      INT id_promocao FK
    }

    CLIENTES ||--o{ AGENDAMENTOS : "realiza"
    SERVICOS ||--o{ AGENDAMENTOS : "oferece"
    AGENDAMENTOS ||--|| PROCEDIMENTOS : "gera"
    PROCEDIMENTOS ||--o{ PROCEDIMENTO_FUNCIONARIOS : "associa"
    FUNCIONARIOS ||--o{ PROCEDIMENTO_FUNCIONARIOS : "atua em"
    METODOS_PAGAMENTO ||--o{ AGENDAMENTOS : "utiliza"
    FUNCIONARIOS ||--o{ COMISSOES : "recebe"
    PROCEDIMENTOS ||--o{ COMISSOES : "gera"
    AGENDAMENTOS ||--o{ FEEDBACKS : "avalia"
    PROMOCOES ||--o{ SERVICOS_PROMOCOES : "aplica"
    SERVICOS ||--o{ SERVICOS_PROMOCOES : "pertence"
