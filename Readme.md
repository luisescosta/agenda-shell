# Agenda de Contatos

**Escreva uma agenda em shell script que atenda aos seguintes requisitos de negócio**:

 - Cadastrar nome e telefone;
 - Permitir busca;
 - Listagem de nome e número;
 - Criar novo arquivo de contatos;
 - Ter menu de todas opções acima com opção de saída.
 - Possuir Persistência em arquivo;
 - Solicitar senha para acesso


**Requisitos técnicos:**
 - Utilize arquivos de textos para cadastro de nomes e telefones
 - Utilizem Zenity para desenvolvimento da interface gráfica de TODAS as
   interações que existam com usuário.
 - Solicitar abertura de arquivo ou criação de novo arquivo em caso de
   nova agenda;
 - Deve haver uma biblioteca com funções para cada uma das funções
   necessárias a execução dos requisitos acima;
 - O script principal deve utilizar a biblioteca criada;

## Como usar?

    . agenda.sh

## Contatos e Senha

**Arquivo de contatos**

    agendas/<Nome Agenda>/agenda.txt

**Local onde fica a senha escolhida**

    agendas/<Nome Agenda>/senha.txt
