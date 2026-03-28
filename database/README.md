# Módulo do Banco de Dados

Este módulo foi feito para separar as atualizações do aplicativo da WEB e do banco de dados que este irá utilizar.

Aqui você encontrará as configurações e a base de questões do banco de dados SQLite que você poderá .

## Estrutura

- `data/` - Modelos de questões em JSON
- `schemas/` - Definição das tabelas
- `scripts/` - Conversão dos JSON para bancos de dados SQLite
- `outputs/` - Bancos de dados gerados em cada nível (criado na execução do script)

## Como usar este banco de dados no App

Antes do processo de Build do app, ele próprio se encarregará de construir o banco de dados no processo, e em seguida, copiar os dados necessários para `app/src/database`, estes que serão aproveitados durante a build, e permanecerão nesta pasta até que uma nova atualização no Banco de dados seja observada.

## Como usar este banco de dados no Servidor/WEB

Para o caso do servidor, no momento em que este for ir ao ar, será feita uma verificação dos arquivos em sua base de dados, mais especificamente do registro do commit mais recente, e iremos comparar este com o commit mais recente da branch main deste repositório localmente, caso difiram, então o próprio servidor começará o processo de build e posteriormente copiará o .db para si mesmo.