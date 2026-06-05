# Configuração do Ambiente de Desenvolvimento

Este projeto usa **DevBox** para criar um ambiente de desenvolvimento isolado com todas as ferramentas necessárias.

O guia de configuração inicial a partir daqui, irá assumir que você está usando um Sistema Operacional Linux

## Dependências

- Android Studio / Android SDK (API 28)
- Android Emulator (opcional)
- DevBox
- Node.js 22 LTS - (Instalado pelo DevBox)
- pnpm - (Instalado pelo DevBox)
- Java JDK 17 - (Instalado pelo DevBox)
- Python 3 - (Instalado pelo DevBox)
- Build tools - (Instalado pelo DevBox)
- Watchman - (Instalado pelo DevBox)
- Git - (Instalado pelo DevBox)

As dependências de Node/Python do projeto são instaladas pelos comandos de setup do DevBox.

Das quais, apenas o Android Studio, Android Emulator e o DevBox devem ser instaladas primeiro de forma manual.

# Instalação de Dependências

Caso tenha qualquer problema na instalação de qualquer componente, refira-se a página de troubleshooting para os problemas mais comuns.

Se ainda assim não encontrar ou não conseguir resolver o problema, não hesite em contactar algum dos membros da equipe de desenvolvimento.

## 1. Android Studio

O Android SDK possibilita a compilação do aplicativo para Android. O Android Studio inclui o SDK e opcionalmente o Android Emulator.

### 1. Instalação

1. Baixe o [Android Studio](https://developer.android.com/studio)

2. Descompacte o arquivo e o mova para a pasta opt/ com o comando:
```bash
tar -xzf android-studio-*.tar.gz
sudo mv android-studio /opt/
```

Após isso, execute o script em:

~~~bash
/opt/android-studio/bin/studio.sh
~~~

Prossiga com a instalação normal do Android Studio

### 2. Configuração

1. Abra o Android Studio e vá até a pagina SDK Manager

2. Instale o SDK **API 28** (Android 9)

3. Na aba SDK Tools, instale:
   - Android SDK Build-Tools
   - Android SDK Platform-Tools
   - Android Emulator (opcional, para debugging)

## 2. DevBox

O DevBox é um Gerenciador de ambientes de desenvolvimento que permite que instalações feitas para o desenvolvimento deste aplicativo não interfiram com demais outras partes do seu sistema.

### 1. Instalação

1. Baixe o DevBox com o comando:

```bash
curl -fsSL https://get.jetify.com/devbox | bash
```

### 2. Configuração

1. Copie o .env.example para o .env através do comando:

~~~bash
cp .env.example .env
~~~

2. Atualize o "ANDROID_HOME" para seu Android SDK (Opcional)

Faça isso apenas se por alguma razão, você instalou o SDK em um caminho diferente do padrão, ou seja, um caminho diferente de:

~~~
/home/seuUsuário/Android/Sdk
~~~

Dica: 
Você pode conferir o path correto na barra superior do Menu SDK Manager no Android Studio

3. Preencha as variáveis obrigatórias no `.env`

Variáveis mínimas recomendadas para o flavor `dev`:

```bash
APP_FLAVOR=dev
DEV_BACKEND_HOST=localhost
DEV_BACKEND_PORT=8000
DEV_WEB_HOST=0.0.0.0
DEV_WEB_PORT=5173
DEV_MOBILE_API_HOST=127.0.0.1
DEV_MOBILE_API_PORT=8000
DEV_BACKEND_CORS_ORIGINS=http://localhost:5173,http://127.0.0.1:5173

# Preencha as variáveis abaixo com as do seu App Firebase
VITE_FIREBASE_API_KEY=""
VITE_FIREBASE_AUTH_DOMAIN=""
VITE_FIREBASE_PROJECT_ID=""
VITE_FIREBASE_STORAGE_BUCKET=""
VITE_FIREBASE_MESSAGING_SENDER_ID=""
VITE_FIREBASE_APP_ID=""

# Ou mantenha como False para fazer com que o Backend não valide o login a cada requisição.
SECURE_REQUEST=False
```



Para produção, preencha também as variáveis `PROD_*` no mesmo arquivo.

4. **NUNCA** sob hipótese alguma faça commit do `.env`

## Setup do Projeto

### 1. Iniciar o DevBox

Dentro da pasta raiz do projeto, execute

```bash
devbox shell
```   


### 2. Instalar dependências

```bash
devbox run setup
```

Este comando executa o setup completo de App, Backend e Web.

- Web (`web/`)
- App/Android (`app/`)
- Backend FastAPI (`server/`)

### 3. Comandos do DevBox

Setup por parte:

```bash
devbox run setup [--web|--db|--database|--app|--server]
```

Ou faça tudo de uma vez com:
```bash
devbox run setup
```

Inicialização dos serviços:

```bash
devbox run startBackend # Inicializa apenas o servidor FastAPI
devbox run startWeb # Inicializa apenas o site  
devbox run startDev  # Inicializa ambos ao mesmo tempo
```

Mobile (debug/build):

```bash
devbox run startAndroid
devbox run buildAndroid
```

Para limpar artefatos gerados (dependências, caches e builds):

```bash
devbox run clean
```

Ou específico por módulo

```bash
devbox run clean [--app|--database|--devbox|--server|--web]
```

### 4. Fluxo recomendado para desenvolvimento

Depois do setup, use os comandos abaixo:

```bash
# Backend + Web juntos
devbox run startDev

# Ou separadamente
devbox run startBackend
devbox run startWeb

# Mobile Android em debug
devbox run startAndroid
```
