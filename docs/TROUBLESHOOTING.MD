# Troubleshooting

Este documento reúne os problemas mais comuns durante a configuração e execução do projeto, junto com a solução recomendada.

Caso encontre um problema novo e que não esteja coberto nesta página, por favor nos informe abrindo uma Issue para que possamos te ajudar.

## 1. Problema com o Nix ao rodar o DevBox

### Descrição

Ao executar `devbox shell`, pode aparecer uma mensagem como:

```bash
Nix is not installed. Devbox will attempt to install it.

Press enter to continue or ctrl-c to exit.
```

Também pode acontecer de uma instalação manual do Nix reclamar que a versão não é a esperada.

### Solução

1. Instale a versão indicada pelo projeto com:

```bash
curl -L https://releases.nixos.org/nix/nix-2.18.0/install | sh
```

2. Se a instalação parecer travada em `evaluating derivation 'github:NixOS...`, pressione `Enter` algumas vezes.
3. Aguarde a instalação terminar. É normal demorar.
4. Se ao final o prompt ficar parecido com `(.venv) (devbox) <seu usuario>@<path>`, então deu certo.

> [!NOTE]  
> Esse procedimento pode demorar um pouco mais se estiver usando o WSL.