CREATE TABLE articleContent (
    Id SERIAL PRIMARY KEY,
    ArticleId INTEGER NOT NULL,
    Content VARCHAR NOT NULL,
    CreatedAt TIMESTAMP NOT NULL
);