-- Таблица курсов
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,       -- Название курса
    is_exam BOOLEAN DEFAULT FALSE,    -- Признак экзаменационного курса
    min_grade INTEGER,                -- Минимальная оценка
    max_grade INTEGER                 -- Максимальная оценка
);

-- Таблица групп
CREATE TABLE groups (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,  -- Полное название группы
    short_name VARCHAR(50),           -- Сокращенное название группы
    students_ids INTEGER[]            -- Идентификаторы студентов в группе
);

-- Таблица студентов
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,  -- Имя студента
    last_name VARCHAR(50) NOT NULL,   -- Фамилия студента
    group_id INTEGER REFERENCES groups(id), -- Идентификатор группы
    courses_ids INTEGER[]             -- Идентификаторы курсов студента
);

-- Таблица оценок для одного курса
CREATE TABLE course_grades (
    student_id INTEGER REFERENCES students(id),   -- Идентификатор студента
    course_id INTEGER REFERENCES courses(id),     -- Идентификатор курса
    grade INTEGER,                                -- Оценка
    grade_str VARCHAR(50),                        -- Оценка в текстовом виде
    PRIMARY KEY (student_id, course_id)
);

-- Таблица курсов заполнение
INSERT INTO courses (name, is_exam, min_grade, max_grade) VALUES
('Математика', TRUE, 0, 100),
('Физика', TRUE, 0, 100),
('История', FALSE, 0, 50),
('Информатика', TRUE, 0, 100),
('Биология', FALSE, 0, 100);

INSERT INTO groups (full_name, short_name, students_ids) VALUES
('Инженерная группа', 'ИНЖ', ARRAY[1, 2]),
('Научная группа', 'НАУЧ', ARRAY[3, 4, 5]),
('Группа гуманитариев', 'ГУМ', ARRAY[6, 7, 8]);

INSERT INTO students (first_name, last_name, group_id, courses_ids) VALUES
('Алиса', 'Иванова', 1, ARRAY[1, 2, 4]),
('Борис', 'Смирнов', 1, ARRAY[2, 3]),
('Виктор', 'Кузнецов', 2, ARRAY[1, 3, 5]),
('Галина', 'Петрова', 2, ARRAY[1, 4]),
('Дмитрий', 'Попов', 2, ARRAY[1, 5]),
('Елена', 'Соколова', 3, ARRAY[2, 3]),
('Жанна', 'Волкова', 3, ARRAY[3, 5]),
('Иван', 'Николаев', 3, ARRAY[4, 5]);

INSERT INTO course_grades (student_id, course_id, grade, grade_str) VALUES
(1, 1, 85, 'Отлично'),
(1, 2, 78, 'Хорошо'),
(1, 4, 90, 'Отлично'),
(2, 2, 80, 'Хорошо'),
(2, 3, 45, 'Неудовлетворительно'),
(3, 1, 70, 'Хорошо'),
(3, 3, 50, 'Удовлетворительно'),
(3, 5, 65, 'Удовлетворительно'),
(4, 1, 95, 'Отлично'),
(4, 4, 82, 'Хорошо'),
(5, 1, 72, 'Хорошо'),
(5, 5, 48, 'Неудовлетворительно'),
(6, 2, 55, 'Удовлетворительно'),
(6, 3, 75, 'Хорошо'),
(7, 3, 60, 'Удовлетворительно'),
(7, 5, 40, 'Неудовлетворительно'),
(8, 4, 85, 'Отлично'),
(8, 5, 90, 'Отлично');

--Пример фильтрации: Выбор студентов с оценками "Отлично" или "Хорошо"
SELECT s.first_name, s.last_name, g.grade, g.grade_str
FROM students s
JOIN course_grades g ON s.id = g.student_id
WHERE g.grade_str IN ('Отлично', 'Хорошо');

--Пример агрегации: Количество студентов по каждому типу оценок в курсе

SELECT c.name AS course_name, g.grade_str, COUNT(g.student_id) AS student_count
FROM courses c
JOIN course_grades g ON c.id = g.course_id
GROUP BY c.name, g.grade_str
ORDER BY c.name, g.grade_str;


--Пример агрегации: Средняя оценка по каждому курс
SELECT c.name AS course_name, AVG(g.grade) AS average_grade
FROM courses c
JOIN course_grades g ON c.id = g.course_id
GROUP BY c.name;

--Дополнительный пример: Средняя оценка студентов в каждой группе
SELECT gr.full_name AS group_name, AVG(cg.grade) AS average_grade
FROM groups gr
JOIN students st ON gr.id = st.group_id
JOIN course_grades cg ON st.id = cg.student_id
GROUP BY gr.full_name;






