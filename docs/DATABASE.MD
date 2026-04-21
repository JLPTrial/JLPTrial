# Formato Recomendado para Questões JSON

## Introdução

Caso você queira contribuir com novas questões, ou até edição/correção, você deverá ler este documento antes para saber exatamente qual o formato que está sendo utilizado para cada tipo de questão.

Caso seja um formato novo ou um novo tipo de questão, adicione a este documento, como esta nova questão deveria ser formatada no JSON, lembre-se também de, caso necessário, revisar o `database/schemas/schema.sql`.

## Estrutura

Definimos o formato recomendado para questões no JSON, com **seções separadas por tipo de questão** (`grammar`, `vocabulary`, `kanji`, `reading`, `listening`).

Com base no schema normalizado em `database/schemas/schema.sql`, as questões devem seguir esta estrutura:

## Estrutura Base (Comum a Todos os Tipos)

```json
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
  "tags": [1, 2]
}
```

### Campos

- `id`: identificador único da questão
- `question_type`: tipo da questão (`grammar`, `vocabulary`, `kanji`, `reading`, `listening`)
- `statement.question_command`: enunciado do tipo de queestão
- `alternatives`: alternativas e índice da correta
- `media`: objeto opcional caso a questão precise de mais informações seja áudio, imagem ou mais texto (`null` quando não houver)
- `tags`: array de IDs de tags

---

## Formatos por Tipo de Questão

### 1) `grammar`

1. Preencha os espaços: Questões que envolvem apenas um espaço em branco, e possibilidades para preencher aquele espaço

```json
{
  "id": 101,
  "question_type": "grammar",
  "question_text": "わたし ([blank]) 学校へ行きます。",
  "statement": {
    "question_command": "（[blank]）に　なにを　いれますか。１・２・３・４から　いちばん　いい　ものを　ひとつ　えらんで　ください。"
  },
  "alternatives": {
    "alternative_1": "は",
    "alternative_2": "を",
    "alternative_3": "に",
    "alternative_4": "で",
    "correct_alternative": 1
  },
  "media": null,
  "tags": null
}
```

2. Ordene a frase: Questões que envolvem quatro espaços em branco, e devemos escolher a resposta que melhor se encaixa no espaço marcado.

```json
{
  "id": 260,
  "question_type": "grammar",
  "question_text": "とうきょうえきで [underline_blank]　[underline_blank]　[star_underline_blank]　[underline_blank]　ください。",
  "statement": {
    "question_command": "[star_underline_blank]　に　入る　ものは　どれですか。１・２・３・４から　いちばん　いい　ものを　一つ　えらんで　ください。"
  },
  "alternatives": {
    "alternative_1": "おりて",
    "alternative_2": "よこはまえきで",
    "alternative_3": "のって",
    "alternative_4": "でんしゃに",
    "correct_alternative": 2
  },
  "media": null,
  "tags": null
}
```

3. Texto em partes: Questões que envolvem um texto, e diversos espaços em branco marcados com `「１」` até `「５」`, cada espaço em branco deve ser uma entrada distinta

```json
{
  "id": 246,
  "question_type": "grammar",
  "question_text": "「１」に何を入れますか。",
  "statement": {
    "question_command": "「１」から「５」　に　何を　入れますか。文章の　意味を　考えて、１・２・３・４から　いちばん　いい　ものを　一つ　えらんで　ください。"
  },
  "alternatives": {
    "alternative_1": "ちいさいです",
    "alternative_2": "ひろいです",
    "alternative_3": "あかるいです",
    "alternative_4": "にぎやかです",
    "correct_alternative": 1
  },
  "media": {
    "audio_file_path": null,
    "image_file_path": null,
    "text_content": "わたしはおうです。中国から来ました。けんしゅうせいです。わたしのへやは４０３です。４かいにあります。「１」が、きれいです。\n\nセンターにしょくどうがあります。いろいろなりょうりがあります。ちゅうかりょうりもあります。\nわたしはまいにちセンターの「２」ごはんを食べます。とても「３」。\n\nセンターから駅まで「４」１０分です。えきの近くに「５」あります。たいへんにぎやかです。"
  },
  "tags": null
}
```

### 2) `vocabulary`

1. Preencha os espaços: Questões que envolvem apenas um espaço em branco, e você deve escolher a alternativa que mais faz sentido ao contexto da frase

```json
{
  "id": 260,
  "question_type": "vocabulary",
  "question_text": "（[blank]）えいがをみにいきませんか？",
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
  "tags": null
}
```

2. Escolha o sinônimo: Questões que envolvem apenas um espaço em branco, e você deve escolher a alternativa que mais faz sentido ao contexto da frase

```json
{
  "id": 230,
  "question_type": "vocabulary",
  "question_text": "{あさこうえんをさんぽしました。}",
  "statement": {
    "question_command": "[underline_blank]　の　ぶんと　だいたい　おなじ　いみの　ぶんが　あります。１・２・３・４から　いちばん　いい　ものを　ひとつ　えらんで　ください。"
  },
  "alternatives": {
    "alternative_1": "あさこうえんをとびました。",
    "alternative_2": "あさこうえんをまがりました。",
    "alternative_3": "あさこうえんをはしりました。",
    "alternative_4": "あさこうえんをあるきました。",
    "correct_alternative": 4
  },
  "media": null,
  "tags": null
}
```

> [!CAUTION]
> Note que o texto que será sublinhado, está entre chaves, isto é utilizado para a correta formatação no app.

### 3) `kanji`

1. Leitura de Kanji: Dada uma sentença, e um Kanji sublinhado, escolha a opção que corresponde a sua leitura em Hiragana

```json
{
  "id": 92,
  "question_type": "kanji",
  "question_text": "一日は二十四時間です。そして、一時間は{六十分}で、一分は六十びょうです。",
  "statement": {
    "question_command": "[underline_blank]　の　ことばは　ひらがなで　どう　かきますか。１・２・３・４から　いちばん　いい　ものを　ひとつ　えらんで　ください。"
  },
  "alternatives": {
    "alternative_1": "ろくじゅうふん",
    "alternative_2": "ろくじゅうぷん",
    "alternative_3": "ろっくじゅっぷん",
    "alternative_4": "ろくじゅっぷん",
    "correct_alternative": 4
  },
  "media": null,
  "tags": []
}
```

2. Leitura de Hiragana: Dada uma sentença, e uma palavra em hiragana sublinhada, escolha a opção que corresponde a sua respectiva escrita em Kanji ou em Katakana

```json
{
  "id": 136,
  "question_type": "kanji",
  "question_text": "このへやは{せまい}です。",
  "statement": {
    "question_command": "[underline_blank]　の　ことばは　どう　かきますか。１・２・３・４から　いちばん　いい　ものを　ひとつ　えらんで　ください。"
  },
  "alternatives": {
    "alternative_1": "広い",
    "alternative_2": "小い",
    "alternative_3": "高い",
    "alternative_4": "狭い",
    "correct_alternative": 4
  },
  "media": null,
  "tags": []
}
```

> [!CAUTION]
> Note que o texto que será sublinhado, está entre chaves, isto é utilizado para a correta formatação no app.

### 4) `reading`

> [!TIP]
> Quando for adicionar qualquer questão do tipo de leitura, dependendo da generalidade e reaproveitamento do texto, use um `media.text_content`.


1. Texto com preenchimento: Questões em que temos um texto ou um diálogo e diversos espaços em branco, e a partir do texto, deduzir qual a sentença que seria dita em dado instante.


```json
{
  "id": 401,
  "question_type": "reading",
  "question_text": "[ 1 ] には何を入れますか。",
  "statement": {
    "question_command": "[ 1 ] から [ 5 ] に　なにを　いれますか。１・２・３・４から　いちばん　いい　ものを　ひとつ　えらんで　ください。"
  },
  "alternatives": {
    "alternative_1": "時計を買ったから、だいじょうぶです",
    "alternative_2": "時計を買ったのに、起きられないんです",
    "alternative_3": "お金がないから、時計が買えないんです",
    "alternative_4": "店に行ったのに、いい時計がなかったんです",
    "correct_alternative": 2
  },
  "media": {
    "audio_file_path": null,
    "image_file_path": null,
    "text_content": "さとう：今月から仕事の時間が早くなったそうだね。\nすぐき：ええ。でも、朝仕事の時間に間に合わなくて…\nさとう：えっ、間に合わない？\nすずき：[ 1 ]。さとう：ふん、どんなとけい？\nすずき：大きな音が出る時計です。ベッドのそばに四つおきました。\nさとう：へえ、四つも！いっしょに音が　出たら、とても大きいね。\nすずき：ええ、妹に [ 2 ] とおこられました。わたしも音は聞こえるんですが、すぐ止めてまたねてしまうんです。\nさとう：そうか。\nすずき：妹に　おこられても　いいから、早く　起きたいんです。どうしたらいいでしょうか。\nさとう：そうだね。まず、時計は [ 3 ]ようにするといいよ。たとえば、6時に起きたかったら5時50分に。\nすずき：10分前ですね。\nさとう：そう。それから、時計をいろいろな場所におくといいよ。四つの時計がぜんぶちがう場所にあったら、音を止めるために起きなければならないから。\nすずき：なるほど！そうですね。すぐにやってみます。
"
  },
  "tags": null
}
```

> [!TIP]
> Caso um ou mais dos itens de uma questão tenha uma imagem em específico, adicione apenas na entrada daquela questão em específico, o path para a imagem em `media.image_file_path`.

```json
{
  "id": 78,
  "question_type": "reading",
  "question_text": "「しつもん」この人のアパートはどれですか。",
  "statement": {
    "question_command": "つぎの文章を読んで、質問に答えてください。答えは、１・２・３・４から、いちばんいいものを一つえらんでください。"
  },
  "alternatives": {
    "alternative_1": "１",
    "alternative_2": "２",
    "alternative_3": "３",
    "alternative_4": "４",
    "correct_alternative": 4
  },
  "media": {
    "audio_file_path": null,
    "image_file_path": "reading/JT4Y/R13-Q7",
    "text_content": "せんしゅう、あたらしいアパートにはいりました。わたしのへやは２かいです。となりには、今だれもすんでいません。１かいには、おばあさんとおとこの大学生がすんでいます。３かいにもだれかいますが、まだどんな人かしりません。"
  },
  "tags": null
}
```

**Observação:** O padrão para a nomenclatura das questões é: `{database original}/{inicial do question_type}{numero da questão}-Q{numero do subitem}`, com todas as letras maiúsculas. (Caso a questão seja de autoria sua, utilize o identificador que desejar para a `database original`).

2. Interpretação: Questões em que temos um texto e em seguida, diversas questões sobre a compreensão do texto. (Em tese é apenas texto e perguntas)

```json
{
  "id": 410,
  "question_type": "reading",
  "question_text": "この町のアパ－トの説明で正しいものはどれですか。",
  "statement": {
    "question_command": "つぎの文章を読んで、質問に答えてください。答えは、１・２・３・４から、いちばんいいものを一つえらんでください。"
  },
  "alternatives": {
    "alternative_1": "今はペットといっしょに住めるアパ－トのほうが多い。",
    "alternative_2": "今はペットといっしょに住めないアパ－トのほうが多い。",
    "alternative_3": "今はほとんどのアパ－トでペットといっしょに住めない。",
    "alternative_4": "今はどんなアパ－トでもペットといっしょに住める。",
    "correct_alternative": 1
  },
  "media": {
    "audio_file_path": null,
    "image_file_path": null,
    "text_content": "さいきん犬やねこなどのペットといっしょに住めるアパ－トがふえてきています。10年前、この町にはペットと住めるアパ－トがほとんどありませんでしたが、去年はぜんぶのアパ－トの半分以上になりました。そして、今もふえつづけているそうです。\n先月花田さんとおくさんがこの町のアパ－トにひっこしてきました。ひっこしてから、犬2ひきといっしょに住んでいます。花田さんは65さいで仕事を　やめてから元気がありませんでしたが、犬といっしょにいて気持ちが明るくなったそうです。おくさんは体がじょうぶになりました。ひっこす前は足が悪くて、ほとんど家の中にいましたが、今は毎日犬といっしょにさんぽしています。二人は、いやなことがあっても、かわいい2ひきを見ると気持ちがやさしくなって、毎日楽しくせいかつできると言っています。\nわたしは今までペットがほしいと思ったことが　ありませんでした。ペットは毎日世話がたいへんです。食べ物やトイレの世話があるし、病気のときは病院につれて行かなければなりません。でも、花田さんの話を聞いて、わたしもペットと住んでみたいと思いました。
"
  },
  "tags": null
}
```

### 5) `listening`

**Observação:** Em todos os casos desta seção, sempre haverá um áudio, e talvez uma imagem, com isso, opte por utilizar `media.audio_file_path` e `media.image_file_path`, para além disso, se você quiser adicionar uma transcrição do texto no áudio, utilize `media.audio_file_path`.

1. Audio e Relação com imagens: Nesta questão, você ouvirá um dialogo, e terá uma imagem a sua frente, você deverá escolher o item na imagem que corresponde ao perguntado no áudio.

```json
{
  "id": 1,
  "question_type": "listening",
  "question_text": "女の人がタクシーの男の人と話しています。タクシーはどの道を行きますか。",
  "statement": {
    "question_command": "まず　しつもんを　聞きいて　ください。それから　話はなしを　聞きいて、もんだいようしの　１から４の　中なかから、いちばん　いい　ものを　一ひとつ　えらんで　ください。"
  },
  "alternatives": {
    "alternative_1": "１",
    "alternative_2": "２",
    "alternative_3": "３",
    "alternative_4": "４",
    "correct_alternative": 2
  },
  "media": {
    "image_file_path": "listening/JT4Y/L43-Q1",
    "image_file_path": "listening/JT4Y/L43-Q1",
    "text_content": "男：あの先の橋を渡りますか？\nいいえ、あそこ右に曲がって。\n男：橋は渡らないんですね。\nええ、次の窓を曲がってまっすぐ行ってください。\n男：はい、わかりました。\nしつもん：タクシーはどの道を行きますか。"
  },
  "tags": null
}
```

2. Resposta a diálogo: Nesta questão, você ouvirá um dialogo, e na imagem, terá uma seta indicando o seu personagem, você deverá pensar como ele responderia a primeira parte do diálogo dadas as alternativas e o contexto.

```json
{
  "id": 2,
  "question_type": "listening",
  "question_text": "家へ帰ります。友達に何と言いますか。",
  "statement": {
    "question_command": "えを　見みながら　しつもんを　聞きいて　ください。\n→（やじるし）の　人ひとは　何なんと　言いいますか。１から３の　中なかから、いちばん　いい　ものを　一ひとつ　えらんで　ください。"
  },
  "alternatives": {
    "alternative_1": "１",
    "alternative_2": "２",
    "alternative_3": "３",
    "alternative_4": null,
    "correct_alternative": 2
  },
  "media": {
    "image_file_path": "listening/JT4Y/L41-Q4",
    "image_file_path": "listening/JT4Y/L41-Q4",
    "text_content": "１：行ってきます。\n２：じゃあまた。 \n３：ただいま。"
  },
  "tags": null
}
```

> [!TIP]
> Eventualmente, questões nessa parte tem apenas três alternativas, e o modelo já prevê isso, então pode deixar a quarta alternativa como `null`


3. Diálogo e Interpretação: Neste tipo de questão, você tem um diálogo, em geral longo, em que os personagens fazem, ou decidem alguma coisa, seu objetivo é de ouvir a pergunta, e depois, dado a conversa, responder a pergunta feita no começo.

```json
{
  "id": 3,
  "question_type": "listening",
  "question_text": "女の学生と男の学生が話しています。 2人は明日どこで会いますか？",
  "statement": {
    "question_command": "まず　しつもんを　聞きいて　ください。そのあと、もんだいようしを　見みて　ください。読よむ　時間じかんが　あります。それから　話はなしを　聞きいて、もんだいようしの　１から４の　中なかから、いちばん　いい　ものを　一ひとつ　えらんで　ください。"
  },
  "alternatives": {
    "alternative_1": "こうえん",
    "alternative_2": "えき",
    "alternative_3": "きっさてん",
    "alternative_4": "レストラン",
    "correct_alternative": 3
  },
  "media": {
    "image_file_path": "listening/JT4Y/L40-Q5",
    "image_file_path": "listening/JT4Y/L40-Q5",
    "text_content": "女の学生：明日の夜、一緒にサッカーを見に行きませんか？ \n男の学生：いいですね。どこで会いましょうか。\n女の学生：5時に駅で会いませんか？\n男の学生：駅は人が多いですよ。\n女の学生：そうですね。じゃあ、駅の前の喫茶店はどうですか？\nはい、そうしましょう。あ、サッカーを見てから近くのレストランで晩御飯を食べませんか？\n女の学生：ええ、じゃあ明日5時に会いましょう。 "
  },
  "tags": null
}
```