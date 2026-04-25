# Formato das Questões JSON

## Introdução

Caso você queira contribuir com novas questões, ou até edição/correção, você deverá ler este documento antes para saber exatamente qual o formato que está sendo utilizado para cada tipo de questão.

Caso seja um formato novo ou um novo tipo de questão, adicione a este documento, como esta nova questão deveria ser formatada no JSON, lembre-se também de, caso necessário, revisar o `database/schemas/schema.sql`.

## Estrutura

Definimos o formato recomendado para questões no JSON, com **seções separadas por tipo de questão** (`grammar`, `vocabulary`, `kanji`, `reading`, `listening`).

> [!NOTE]
> Os marcadores de formatação de texto (como `[blank]`, `[underline_blank]`, `{texto}`, etc.) estão documentados em [DATABASE_FORMAT.md](DATABASE_FORMAT.MD). Consulte esse arquivo para entender como estruturar o texto de questões com lacunas, sublinhados e outras formatações especiais.
>
> 
Seguindo o schema normalizado em `database/schemas/schema.sql`, as questões devem seguir esta estrutura:


## Estrutura Base (Comum a Todos os Tipos)

```json
{
  "questions": [
    {
      "id": 1,
      "question_type": "kanji",
      "statement": {
          "question_command": "Texto da questão"
      },
      "alternatives": {
          "alternative_1": "Opção 1",
          "alternative_2": "Opção 2",
          "alternative_3": "Opção 3",
          "alternative_4": "Opção 4",
          "correct_alternative": 1
      },
      "media": null,
      "tags": [
        "Gramática textual"
      ]
    }
  ]
}
```

---

## Estrutura de Cada Questão

### Campos

- `id`: inteiro único no arquivo.
- `question_type`: um destes valores: `grammar`, `vocabulary`, `kanji`, `reading`, `listening`.
- `question_text`: texto principal da pergunta.
- `statement.question_command`: comando/instrução exibido ao usuário.
- `alternatives`: opções e resposta correta.
- `media`: `null` ou objeto com suporte a áudio/imagem/texto.
- `tags`: array de strings (pode ser vazio `[]`).

### Estrutura de alternativas

```json
"alternatives": {
  "alternative_1": "Opção 1",
  "alternative_2": "Opção 2",
  "alternative_3": "Opção 3",
  "alternative_4": "Opção 4",
  "correct_alternative": 1
}
```

Observações:

- `correct_alternative` deve apontar para uma alternativa válida.
- Em questões com apenas 3 opções, `alternative_4` pode ser `null`.

### Estrutura de media

Quando houver mídia associada, o padrão é:

```json
"media": {
  "audio_file_path": "listening/JT4Y/L1-Q1.mp3",
  "image_file_path": "listening/JT4Y/L1-Q1.png",
  "text_content": "Transcrição ou texto de apoio"
}
```

Quando não houver mídia, usar:

```json
"media": null
```

---

## Formatos por Tipo de Questão

### 1) grammar

#### Exemplo (preenchimento de lacuna):

```json
{
  "id": 1,
  "question_type": "grammar",
  "question_text": "まいにち　しんぶん　（[blank]）　読[よ]みます。",
  "statement": {
    "question_command": "（[blank]）　に　なに　を　いれますか。１・２・３・４　から　いちばん　いい　もの　を　ひとつ　えらんで　ください。"
  },
  "alternatives": {
    "alternative_1": "へ",
    "alternative_2": "を",
    "alternative_3": "に",
    "alternative_4": "が",
    "correct_alternative": 2
  },
  "media": null,
  "tags": [
    "Gramática textual"
  ]
}
```

#### Exemplo (ordenação de sentenças):

```json
{
    "id": 260,
    "question_type": "grammar",
    "question_text": "とうきょう　えき　で[underline_blank][underline_blank][star_underline_blank][underline_blank]　ください。",
    "statement": {
    "question_command": "[star_underline_blank]に　入[はい]る　もの　は　どれですか。１・２・３・４　から　いちばん　いい　もの　を　一[ひと]つ　えらんで　ください。"
    },
    "alternatives": {
    "alternative_1": "おりて",
    "alternative_2": "よこはまえきで",
    "alternative_3": "のって",
    "alternative_4": "でんしゃに",
    "correct_alternative": 2
    },
    "media": null,
    "tags": [
    "Gramática textual",
    "Construção de frases"
    ]
}
```

---

### 2) vocabulary

#### Exemplo (preenchimento de lacuna):

```json
{
  "id": 1,
  "question_type": "vocabulary",
  "question_text": "（[blank]）、　えいが　を　みにいきませんか？",
  "statement": {
    "question_command": "（[blank]）に　なにを　いれますか。１・２・３・４から　いちばん　いい　ものを　ひとつ　えらんで　ください。"
  },
  "alternatives": {
    "alternative_1": "ゆうべ",
    "alternative_2": "きのう",
    "alternative_3": "あした",
    "alternative_4": "おととい",
    "correct_alternative": 3
  },
  "media": null,
  "tags": [
    "Uso da Língua"
  ]
}
```

#### Exemplo (significados similares):

```json
{
    "id": 71,
    "question_type": "vocabulary",
    "question_text": "{リーさん　は　にほんご　を　ならっています。}",
    "statement": {
    "question_command": "[underline_blank]　の　ぶんと　だいたい　おなじ　いみの　ぶんが　あります。１・２・３・４から　いちばん　いい　ものを　ひとつ　えらんで　ください。"
    },
    "alternatives": {
    "alternative_1": "リーさん　は　にほんご　を　いれています。",
    "alternative_2": "リーさん　は　にほんご　を　おしえています。",
    "alternative_3": "リーさん　は　にほんご　を　やめています。",
    "alternative_4": "リーさん　は　にほんご　を　べんきょうしています。",
    "correct_alternative": 4
    },
    "media": null,
    "tags": [
    "Regra de Contexto"
    ]
},
```

> [!CAUTION]
> Note que o texto que será sublinhado, está entre chaves, isto é utilizado para a correta formatação no app.

---

### 3) kanji

#### Exemplo (kanji para leitura em hiragana):

```json
{
  "id": 1,
  "question_type": "kanji",
  "question_text": "しけん　は　{来月}　の　七月八日[しちがつようか]、木[もく]よう日[び]、九時[くじ]　から　です。",
  "statement": {
    "question_command": "[underline_blank]　の　ことばは　ひらがなで　どう　かきますか。１・２・３・４から　いちばん　いい　ものを　ひとつ　えらんで　ください。"
  },
  "alternatives": {
    "alternative_1": "くげつ",
    "alternative_2": "らいがつ",
    "alternative_3": "くがつ",
    "alternative_4": "らいげつ",
    "correct_alternative": 4
  },
  "media": null,
  "tags": [
    "Kanji Reading",
    "Usage"
  ]
}
```

#### Exemplo (hiragana para escrita em kanji):

```json
{
  "id": 16,
  "question_type": "kanji",
  "question_text": "はは　は　{まいにち}、だいがく　の　としょかん　で　はたらいています。",
  "statement": {
    "question_command": "[underline_blank]　の　ことばは　どう　かきますか。１・２・３・４から　いちばん　いい　ものを　ひとつ　えらんで　ください。"
  },
  "alternatives": {
    "alternative_1": "宙日",
    "alternative_2": "週日",
    "alternative_3": "中日",
    "alternative_4": "毎日",
    "correct_alternative": 4
  },
  "media": null,
  "tags": [
    "Transcription"
  ]
}
```

---

### 4) reading

Questões de leitura normalmente usam `media.text_content` para o texto-base.

#### Exemplo:

```json
{
  "id": 1,
  "question_type": "reading",
  "question_text": "きのう買ったかさはどんなかさですか。",
  "statement": {
    "question_command": "つぎの文章を読んで、質問に答えてください。答えは、１・２・３・４から、いちばんいいものを一つえらんでください。"
  },
  "alternatives": {
    "alternative_1": "高くておもいです。",
    "alternative_2": "安いですが、おもいです。",
    "alternative_3": "かるくてきれいです。",
    "alternative_4": "きれいですが、高いです。",
    "correct_alternative": 3
  },
  "media": {
    "audio_file_path": null,
    "image_file_path": null,
    "text_content": "Ａ：きのうかさを買いました。\nＢ：あ、そのかさですか。きれいなかさですね。高かったですか。\nＡ：いいえ。きょねん買ったのは高くておもかったですが、このかさはかるくていいです。"
  },
  "tags": []
}
```

> [!TIP]
> Quando for adicionar qualquer questão do tipo de leitura, dependendo da generalidade e reaproveitamento do texto, use um `media.text_content`.


---

### 5) listening

Questões de listening usam `media.audio_file_path` e frequentemente `media.image_file_path`.

#### Exemplo com áudio e imagem:

```json
{
  "id": 1,
  "question_type": "listening",
  "question_text": "女[おんな]　の　人[ひと]　と　男[おとこ]　の　人[ひと]　が　話[はな]しています。女[おんな]　の　人[ひと]　の　コート　は　どれ　です　か。",
  "statement": {
    "question_command": "まず　しつもん　を　聞[き]いて　ください。それから　話[はなし]　を　聞[き]いて、もんだいようしの　１　から　４　の　中[なか]　から、いちばん　いい　もの　を　一[ひと]つ　えらんで　ください。"
  },
  "alternatives": {
    "alternative_1": "1",
    "alternative_2": "2",
    "alternative_3": "3",
    "alternative_4": "4",
    "correct_alternative": 2
  },
  "media": {
    "audio_file_path": "listening/JT4Y/L1-Q1.mp3",
    "image_file_path": "listening/JT4Y/L1-Q1.png",
    "text_content": "Ａ：じゃ、私[わたし]　は　先[さき]　に　帰[かえ]ります。\nＢ：そう　です　か。じゃ、コート　を、山田[やまだ]さん　の　コート　は　どれ　です　か。\nＡ：それ　です。その　白[しろ]くて、長[なが]い　の　です。\nＢ：あ、これ　です　か。\nＡ：いいえ。その　ポケット　が　ない　ほう　です。\n女[おんな]　の　人[ひと]　の　コート　は　どれ　です　か。"
  },
  "tags": [
    "Compreensão de Pontos"
  ]
}
```

#### Exemplo com 3 alternativas (quarta nula):

```json
{
  "id": 999,
  "question_type": "listening",
  "question_text": "家へ帰ります。友達に何と言いますか。",
  "statement": {
    "question_command": "えを　見みながら　しつもんを　聞きいて　ください。→（やじるし）の　人ひとは　何なんと　言いいますか。１から３の　中なかから、いちばん　いい　ものを　一ひとつ　えらんで　ください。"
  },
  "alternatives": {
    "alternative_1": "１",
    "alternative_2": "２",
    "alternative_3": "３",
    "alternative_4": null,
    "correct_alternative": 2
  },
  "media": {
    "audio_file_path": "listening/JT4Y/L41-Q4.mp3",
    "image_file_path": "listening/JT4Y/L41-Q4.png",
    "text_content": "１：行ってきます。\n２：じゃあまた。\n３：ただいま。"
  },
  "tags": []
}
```

---
