CREATE TABLE article (
    Id SERIAL PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Subtitle VARCHAR(255) NOT NULL,
    Resume TEXT NOT NULL,
    Tags VARCHAR(255) NOT NULL,
    Language VARCHAR(50) NOT NULL,
    TimeRead INTEGER NOT NULL CHECK (TimeRead >= 0),
    Views INTEGER NOT NULL CHECK (views >= 0),
    CreatedAt TIMESTAMP NOT NULL
);