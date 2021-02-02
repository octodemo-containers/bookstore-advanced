CREATE TABLE IF NOT EXISTS books (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL UNIQUE,
    author CHARACTER(50),
    image TEXT,
    rating INTEGER,
    CONSTRAINT bounded_rating CHECK (rating >= 0 AND rating <= 5)
);

INSERT INTO books (
    title,
    author,
    image,
    rating
) VALUES (
    'Scrum: The Art of Doing Twice the Work in Half the Time',
    'Jeff Sutherland',
    'scrum.jpg',
    3
) ON CONFLICT DO NOTHING;

INSERT INTO books (
    title,
    author,
    image,
    rating
) VALUES (
    'The Lean Startup: How Constant Innovation Creates Radically Successful Businesses',
    'Eric Ries',
    'lean.jpg',
    3
) ON CONFLICT DO NOTHING;

INSERT INTO books (
    title,
    author,
    image,
    rating
) VALUES (
    'Crossing the Chasm',
    'Geoffrey A. Moore',
    'chasm.jpg',
    3
) ON CONFLICT DO NOTHING;

INSERT INTO books (
    title,
    author,
    image,
    rating
) VALUES (
    'The Pragmatic Programmer: From Journeyman to Master',
    'David Thomas',
    'pragmatic.jpg',
    3
) ON CONFLICT DO NOTHING;

INSERT INTO books (
    title,
    author,
    image,
    rating
) VALUES (
    'The Mythical Man-Month: Essays on Software Engineering',
    'Frederick P. Brooks Jr.',
    'month.jpg',
    3
) ON CONFLICT DO NOTHING;

INSERT INTO books (
    title,
    author,
    image,
    rating
) VALUES (
    'Don''t Make Me Think, Revisited: A Common Sense Approach to Web Usability',
    'Steve Krug',
    'think.jpg',
    3
) ON CONFLICT DO NOTHING;
