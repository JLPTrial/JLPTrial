# Guia de Contribuição - JLPTrial

Obrigado por se interessar em contribuir com o JLPTrial! Este guia cobre as melhores práticas para cada tipo de contribuição.

## Índice

- [Guia de Contribuição - JLPTrial](#guia-de-contribuição---jlptrial)
  - [Índice](#índice)
  - [Parte 1: Boas Práticas](#parte-1-boas-práticas)
    - [Etiqueta](#etiqueta)
    - [Ambiente de Desenvolvimento](#ambiente-de-desenvolvimento)
  - [Parte 2: Trabalhando com Issues](#parte-2-trabalhando-com-issues)
    - [Como Abrir uma Issue](#como-abrir-uma-issue)
    - [Antes de Submeter](#antes-de-submeter)
    - [Para Mais Informações](#para-mais-informações)
  - [Parte 3: Contribuindo com Código](#parte-3-contribuindo-com-código)
    - [Quando Modificar o Código](#quando-modificar-o-código)
    - [Nunca modifique o código para:](#nunca-modifique-o-código-para)
    - [Processo de Contribuição](#processo-de-contribuição)
    - [Comentários no Código](#comentários-no-código)
      - [Commits](#commits)
      - [Executando Testes](#executando-testes)
  - [Dúvidas?](#dúvidas)

## Parte 1: Boas Práticas

### Etiqueta

Ao contribuir para o JLPTrial, lembre-se:

- Escreva títulos claros e concisos para as Issues
  - Não coloque a descrição inteira no título da issue
- Evite duplicações
  - Verifique se a issue ou PR que você quer abrir já existe
- Uma coisa por vez
  - Uma issue ou PR por problema/feature
- Qualidade primeiro
  - Priorize código bem escrito e testado

> [!TIP]
> Use a barra de busca antes de abrir uma nova issue. Muitas vezes, alguém já reportou o mesmo problema!

### Ambiente de Desenvolvimento

Antes de começar a contribuir:

1. Clone o repositório: `git clone https://github.com/JLPTrial/JLPTrial.git`
2. Entre no ambiente do projeto com DevBox: `devbox shell`
3. Siga as instruções em [docs/SETUP.MD](SETUP.MD) para configurar o ambiente
4. Execute o setup inicial: `devbox run setup`
5. Verifique se consegue iniciar os módulos com os comandos do DevBox (ex.: `devbox run startDev`)

> [!TIP]
> Não comece a trabalhar sem ter o ambiente completamente configurado segundo o modelo do DevBox. Isso pode causar inconsistências na execução entre a sua máquina e a da equipe.

## Parte 2: Trabalhando com Issues

### Como Abrir uma Issue

1. Acesse a aba [Issues](https://github.com/JLPTrial/JLPTrial/issues) do repositório
2. Clique em **New Issue**
3. Escolha o template apropriado que melhor descreve sua necessidade
4. Preencha todos os campos obrigatórios com o máximo de detalhes
5. Submeta a issue

> [!IMPORTANT]
> Todos os campos marcados como obrigatórios no template devem ser preenchidos. Issues incompletas podem ser fechadas.

### Antes de Submeter

- Procure duplicatas 
    - Use a barra de busca para verificar se a issue já foi reportada
- Complete o checklist 
    - Preencha todos os campos solicitados no template
- Seja específico 
    - Quanto mais detalhes, melhor poderemos ajudar

### Para Mais Informações

Para uma descrição detalhada de cada tipo de issue disponível, consulte [docs/ISSUES.MD](ISSUES.MD).

## Parte 3: Contribuindo com Código

### Quando Modificar o Código

Você deve modificar o código quando:

- Corrigir um bug reportado e confirmado
- Implementar uma feature que foi solicitada e aprovada em uma issue
- Melhorar a qualidade do código existente (refatoração, otimização)
- Atualizar documentação que está desatualizada ou incompleta

> [!TIP]
> Sempre abra uma issue antes de começar a trabalhar. Assim, a discussão pode acontecer antes do trabalho ser feito!

### Nunca modifique o código para:

- Adicionar funcionalidades não solicitadas
- Mudar estilos visuais sem discussão prévia
- Refatorar código sem abrir uma issue de manutenção
- Mergear grandes mudanças sem review

> [!CAUTION]
> PRs que violarem essas regras podem ser rejeitadas sem revisão. Sempre discuta antes de implementar!

### Processo de Contribuição

1. Crie uma issue primeiro - Descreva o que você pretende fazer
2. Aguarde feedback
3. Faça um fork do repositório
4. Clone seu fork localmente: `git clone seu-fork-url`
5. Crie uma branch descritiva:
   - `fix/nome-do-bug` para correções
   - `feature/nome-da-funcionalidade` para novas features
   - `docs/descricao` para documentação
6. Implemente suas mudanças com commits bem descritos
7. Execute as validações locais (lint e testes)
8. Push para seu fork
9. Abra um Pull Request (PR) referenciando a issue original

### Comentários no Código

Escreva comentários úteis, não óbvios:

Evite:
```typescript
// Incrementa counter
counter++;

// Verifica se user é nulo
if (user != null) { ... }

// Teste - remove depois
console.log(data); // REMOVER!
```

Prefira:
```typescript
// Incrementa o contador de tentativas para calcular pontuação final
counter++;

// User pode ser nulo se não autenticado ainda
if (user != null) { ... }

// Valida se o formato da data segue padrão ISO 8601
if (validateISODate(data)) { ... }
```

> [!TIP]
> Comentários devem explicar o "por quê", não o "o quê". O código já diz o que está fazendo!

#### Commits

Escreva mensagens de commit claras e descritivas:

```bash
fix: corrigir validação de formulário de login
feature: adicionar contador de questões respondidas
docs: atualizar instruções de instalação
test: adicionar testes para serviço de autenticação
```

> [!IMPORTANT]
> Commits devem ser atômicos - cada commit deve representar uma mudança lógica única.

#### Executando Testes

Sempre execute os testes antes de criar uma PR:

```bash
# App (lint)
cd app && npm run lint

# Web (lint)
cd web && npm run lint

# Backend (testes)
cd server && pytest
```

Seu código deve:
- Passar em todos os testes existentes
- Incluir novos testes para funcionalidades novas
- Manter a cobertura de testes consistente

> [!CAUTION]
> Nenhuma PR será aceita se os testes não passarem. Garanta que seu código está funcionando!

## Dúvidas?

Se tiver dúvidas sobre como contribuir:

- Abra uma issue perguntando
- Consulte a documentação do projeto
- Converse com algum dos membros da equipe