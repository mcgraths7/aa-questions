DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL,
  is_instructor INTEGER NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO 
  users (fname, lname, is_instructor)
VALUES 
  ('Steven', 'McGrath', 0),
  ('Anthony', 'Lagasi', 0),
  ('Juan', 'Pol', 0),
  ('Jeff', 'Katz', 1)
;

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('An interesting title...', 'Some content', (
    SELECT id 
    FROM users
    WHERE fname = 'Steven' AND lname = 'McGrath')),
  ('What is the airspeed velocity of an unladen swallow?', 'Asking for a friend...', (
    SELECT id
    FROM users
    WHERE fname = 'Anthony' AND lname = 'Lagasi'
  )),
  ('What is the capital of Assyria?', 
  'Need help ASAP or this crazy old man is going to toss me into the gorge', (
    SELECT id
    FROM users
    WHERE fname = 'Juan' AND lname = 'Pol'
  )),
  ('How old is Senko?', 'Asking for an anonymous R34 artist...', (
    SELECT id 
    FROM users
    WHERE fname = 'Steven' AND lname = 'McGrath'));

INSERT INTO
  replies (body, user_id, question_id, parent_reply_id)
VALUES
  ('Shut up, nerd!', 3, 1, NULL),
  ('What do you mean? An African or European swallow?', 1, 2, NULL),
  ('What, I don''t know th... AAAAGGGGHHHH!!!', 2, 2, 2),
  ('African of course!', 3, 2, 2),
  ('No you fool, it''s European!', 1, 2, 4);

-- Users
-- id          fname       lname       is_instructor
-- ----------  ----------  ----------  -------------
-- 1           Steven      McGrath     0
-- 2           Anthony     Lagasi      0
-- 3           Juan        Pol         0
-- 4           Jeff        Katz        1

-- Questions
-- id          title                    body          user_id
-- ----------  -----------------------  ------------  ----------
-- 1           An interesting title...  Some content  1
-- 2           What is the airspeed ve  Asking for a  2
-- 3           What is the capital of   Need help AS  3
-- 4           How old is Senko?        Asking for a  1

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (1, 2),
  (1, 3),
  (2, 1),
  (2, 4),
  (3, 1),
  (3, 3),
  (4, 2),
  (4, 1);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (2, 2),
  (3, 1),
  (2, 1),
  (2, 4),
  (3, 2),
  (3, 3),
  (4, 2),
  (4, 1);