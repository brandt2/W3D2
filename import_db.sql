DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;
PRAGMA foreign_keys = ON;

CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY(author_id) REFERENCES users(id)
);

CREATE TABLE question_follows(
    users_id INTEGER NOT NULL,
    questions_id INTEGER NOT NULL,

    FOREIGN KEY(users_id) REFERENCES users(id)
    FOREIGN KEY(questions_id) REFERENCES questions(id)
);

CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    subject_question_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    writer_id INTEGER NOT NULL,
    reply_body TEXT NOT NULL,

    FOREIGN KEY(subject_question_id) REFERENCES questions(id)
    FOREIGN KEY(parent_reply_id) REFERENCES replies(id)
    FOREIGN KEY(writer_id) REFERENCES users(id)
);

CREATE TABLE question_likes(
    likes_users_id INTEGER NOT NULL,
    likes_questions_id INTEGER NOT NULL,

    FOREIGN KEY (likes_users_id) REFERENCES users(id)
    FOREIGN KEY (likes_questions_id) REFERENCES questions(id)
);

INSERT INTO 
    users(fname, lname)
VALUES
    ('Brandon', 'Tran'),
    ('Ari', 'Ghlichloo'),
    ('Brian', 'Tan'),
    ('Arya', 'Gomez'),
    ('Don', 'Ton'),
    ('Rico', 'Lich'),
    ('Bran', 'Ran'),
    ('Ira', 'Loo');


INSERT INTO 
    questions(title, body, author_id)
VALUES 
    ('What is life?', 'Coding', 
    (SELECT id FROM users WHERE fname = 'Brandon' AND lname = 'Tran')),
    ('Where is life?', '825 Battery St.', 
    (SELECT id FROM users WHERE fname = 'Ari' AND lname = 'Ghlichloo')),
    ('When is life?', '9am-6pm', 
    (SELECT id FROM users WHERE fname = 'Brian' AND lname = 'Tan')),
    ('How is life?', 'Horrible and Tiring', 
    (SELECT id FROM users WHERE fname = 'Arya' AND lname = 'Gomez')),
    ('Is life?', 'idk', 
    (SELECT id FROM users WHERE fname = 'Don' AND lname = 'Ton')),
    ('Who is life?', 'The Computer', 
    (SELECT id FROM users WHERE fname = 'Rico' AND lname = 'Lich'));



INSERT INTO 
    question_follows(users_id, questions_id)
VALUES 
    ((SELECT id FROM users WHERE fname = 'Brandon' AND lname = 'Tran'),
     (SELECT id FROM questions WHERE title = 'What is life?')),

     ((SELECT id FROM users WHERE fname = 'Ari' AND lname = 'Ghlichloo'),
     (SELECT id FROM questions WHERE title = 'Where is life?')),

     ((SELECT id FROM users WHERE fname = 'Brian' AND lname = 'Tan'),
     (SELECT id FROM questions WHERE title = 'When is life?')),

     ((SELECT id FROM users WHERE fname = 'Arya' AND lname = 'Gomez'),
     (SELECT id FROM questions WHERE title = 'How is life?')),

     ((SELECT id FROM users WHERE fname = 'Don' AND lname = 'Ton'),
     (SELECT id FROM questions WHERE title = 'Is life?')),

     ((SELECT id FROM users WHERE fname = 'Rico' AND lname = 'Lich'),
     (SELECT id FROM questions WHERE title = 'Who is life?'));



INSERT INTO 
    replies(subject_question_id, parent_reply_id, writer_id, reply_body)
VALUES 
    ((SELECT id FROM questions WHERE title = 'What is life?'),
    (SELECT id FROM replies WHERE parent_reply_id = id),
    (SELECT id FROM users WHERE fname = 'Ari' AND lname = 'Ghlichloo'), 'Can''t help ya bruh'),

    ((SELECT id FROM questions WHERE title = 'Where is life?'),
    (SELECT id FROM replies WHERE parent_reply_id = id),
    (SELECT id FROM users WHERE fname = 'Brian' AND lname = 'Tan'), 'App Academy'),

    ((SELECT id FROM questions WHERE title = 'When is life?'),
    (SELECT id FROM replies WHERE parent_reply_id = id),
    (SELECT id FROM users WHERE fname = 'Arya' AND lname = 'Gomez'), 'every day bruh'),

    ((SELECT id FROM questions WHERE title = 'How is life?'),
    (SELECT id FROM replies WHERE parent_reply_id = id),
    (SELECT id FROM users WHERE fname = 'Don' AND lname = 'Ton'), 'zombie'),

    ((SELECT id FROM questions WHERE title = 'Is life?'),
    (SELECT id FROM replies WHERE parent_reply_id = id),
    (SELECT id FROM users WHERE fname = 'Rico' AND lname = 'Lich'), 'life is'),

    ((SELECT id FROM questions WHERE title = 'Who is life?'),
    (SELECT id FROM replies WHERE parent_reply_id = id),
    (SELECT id FROM users WHERE fname = 'Bran' AND lname = 'Ran'), 'Evil');



INSERT INTO 
    question_likes(likes_users_id, likes_questions_id)
VALUES 
    ((SELECT id FROM users WHERE fname = 'Brandon' AND lname = 'Tran'), 
    (SELECT id FROM questions WHERE title = 'What is life?')),

    ((SELECT id FROM users WHERE fname = 'Brandon' AND lname = 'Tran'), 
    (SELECT id FROM questions WHERE title = 'What is life?')),

    ((SELECT id FROM users WHERE fname = 'Brandon' AND lname = 'Tran'), 
    (SELECT id FROM questions WHERE title = 'What is life?')),

    ((SELECT id FROM users WHERE fname = 'Brandon' AND lname = 'Tran'), 
    (SELECT id FROM questions WHERE title = 'What is life?')),

    ((SELECT id FROM users WHERE fname = 'Brandon' AND lname = 'Tran'), 
    (SELECT id FROM questions WHERE title = 'What is life?')),

    ((SELECT id FROM users WHERE fname = 'Brandon' AND lname = 'Tran'), 
    (SELECT id FROM questions WHERE title = 'What is life?'));



