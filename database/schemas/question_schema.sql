--------------------------------------------------
-- TABELA PRINCIPAL DE QUESTÕES
--------------------------------------------------
CREATE TABLE questions (
  id INTEGER PRIMARY KEY,

  alternative_id INTEGER NOT NULL,

  media_id INTEGER,

  statement_id INTEGER NOT NULL,

  question_text TEXT NOT NULL,

  question_type TEXT NOT NULL
    CHECK (question_type IN ('grammar', 'vocabulary', 'kanji', 'reading', 'listening')),

  FOREIGN KEY (alternative_id) REFERENCES alternatives(id) ON DELETE CASCADE,
  FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE SET NULL,
  FOREIGN KEY (statement_id) REFERENCES statement(id) ON DELETE CASCADE
);

CREATE TABLE tags (
  id INTEGER PRIMARY KEY,

  name TEXT NOT NULL UNIQUE
);

--------------------------------------------------
-- MARCADORES DE QUESTÕES
--------------------------------------------------
CREATE TABLE question_tags (
  question_id INTEGER NOT NULL,

  tag_id INTEGER NOT NULL,

  PRIMARY KEY (question_id, tag_id),

  FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);

--------------------------------------------------
-- ENUNCIADOS
--------------------------------------------------
CREATE TABLE statement (
  id INTEGER PRIMARY KEY,

  statement_text TEXT NOT NULL
);

--------------------------------------------------
-- TEXTOS (READING)
--------------------------------------------------
CREATE TABLE media_text (
  id INTEGER PRIMARY KEY,

  question_text TEXT NOT NULL
);


--------------------------------------------------
-- ALTERNATIVAS
--------------------------------------------------
CREATE TABLE alternatives (
  id INTEGER PRIMARY KEY,

  alternative_1 TEXT NOT NULL,

  alternative_2 TEXT NOT NULL,

  alternative_3 TEXT NOT NULL,

  alternative_4 TEXT,

  correct_alternative INTEGER NOT NULL CHECK (correct_alternative BETWEEN 1 AND 4)
);

--------------------------------------------------
-- MÍDIA (ÁUDIO / IMAGEM)
--------------------------------------------------
CREATE TABLE media (
  id INTEGER PRIMARY KEY,

  text_media_id INTEGER,

  image_file_path TEXT,

  audio_file_path TEXT,

  FOREIGN KEY (text_media_id) REFERENCES media_text(id) ON DELETE SET NULL,

  CHECK (
    text_media_id IS NOT NULL
    OR image_file_path IS NOT NULL
    OR audio_file_path IS NOT NULL
  )
);

--------------------------------------------------
-- ÍNDICES (PERFORMANCE)
--------------------------------------------------

CREATE INDEX idx_questions_type
  ON questions(question_type);

CREATE INDEX idx_questions_statement
  ON questions(statement_id);

CREATE INDEX idx_questions_alternative
  ON questions(alternative_id);

CREATE INDEX idx_questions_media
  ON questions(media_id);

CREATE INDEX idx_question_tags_question
  ON question_tags(question_id);

CREATE INDEX idx_question_tags_tag
  ON question_tags(tag_id);
