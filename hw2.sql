--Создание таблицы student_courses
CREATE TABLE student_courses (
    id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(id),
    course_id INTEGER REFERENCES courses(id),
    UNIQUE (student_id, course_id)  -- Уникальное отношение для предотвращения дублирования
);

--Создание таблицы group_courses
CREATE TABLE group_courses (
    id SERIAL PRIMARY KEY,
    group_id INTEGER REFERENCES groups(id),
    course_id INTEGER REFERENCES courses(id),
    UNIQUE (group_id, course_id)  -- Уникальное отношение для предотвращения дублирования
);

--Заполнение таблиц student_courses
INSERT INTO student_courses (student_id, course_id) VALUES
(1, 1), (1, 2), (1, 4),
(2, 2), (2, 3),
(3, 1), (3, 3), (3, 5),
(4, 1), (4, 4),
(5, 1), (5, 5),
(6, 2), (6, 3),
(7, 3), (7, 5),
(8, 4), (8, 5);

--Заполнение таблицы group_courses
INSERT INTO group_courses (group_id, course_id) VALUES
(1, 1), (1, 2), (1, 4),
(2, 1), (2, 3), (2, 5),
(3, 2), (3, 3), (3, 4), (3, 5);

--Удаление неактуальных полей с помощью ALTER TABLE
ALTER TABLE students DROP COLUMN courses_ids;

--Уникальное ограничение на поле name в таблице courses
ALTER TABLE courses ADD CONSTRAINT unique_course_name UNIQUE (name);

--Индексирование поля group_id в таблице students
CREATE INDEX idx_students_group_id ON students(group_id);
-- Комментарий:
-- Этот индекс ускоряет выполнение запросов, которые фильтруют или соединяют таблицу students по group_id.
-- Например, запросы вида SELECT * FROM students WHERE group_id = ? или JOIN на group_id будут выполняться быстрее,
-- так как база данных будет использовать индекс для быстрого поиска подходящих строк.
-- В результате, вместо полного сканирования таблицы, база данных использует индекс для перехода
-- к нужной части данных, что улучшает производительность.
--промежуточная таблица student_courses
SELECT s.first_name, s.last_name, c.name AS course_name
FROM students s
JOIN student_courses sc ON s.id = sc.student_id
JOIN courses c ON sc.course_id = c.id;

--Запрос на студентов с средней оценкой выше, чем у любого другого студента в их группе
SELECT s.first_name, s.last_name, AVG(cg.grade) AS avg_grade
FROM students s
JOIN course_grades cg ON s.id = cg.student_id
JOIN groups g ON s.group_id = g.id
GROUP BY s.id, s.first_name, s.last_name
HAVING AVG(cg.grade) > (
    SELECT MAX(avg_other.avg_grade)
    FROM (
        SELECT s2.group_id, s2.id AS student_id, AVG(cg2.grade) AS avg_grade
        FROM students s2
        JOIN course_grades cg2 ON s2.id = cg2.student_id
        WHERE s2.group_id = s.group_id AND s2.id != s.id
        GROUP BY s2.group_id, s2.id
    ) AS avg_other
);

--Подсчет количества студентов на каждом курсе
SELECT c.name AS course_name, COUNT(sc.student_id) AS student_count
FROM courses c
JOIN student_courses sc ON c.id = sc.course_id
GROUP BY c.name;

--Нахождение средней оценки на каждом курсе
SELECT c.name AS course_name, AVG(cg.grade) AS average_grade
FROM courses c
JOIN course_grades cg ON c.id = cg.course_id
GROUP BY c.name;

