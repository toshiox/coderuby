CREATE TABLE article (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    subtitle VARCHAR(255) NOT NULL,
    resume TEXT NOT NULL,
    tags VARCHAR(255) NOT NULL,
    language VARCHAR(50) NOT NULL,
    time_read INTEGER NOT NULL CHECK (TimeRead >= 0),
    views INTEGER NOT NULL CHECK (views >= 0),
    created_at TIMESTAMP NOT NULL
);