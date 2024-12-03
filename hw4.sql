--Домашнее задание 4
--1. Создать триггеры со всеми возможными ключевыми словами, а также рассмотреть операционные триггеры (сделать проверку) 
--2. Попрактиковаться в созданиях транзакций (привести пример успешной и фейл транзакции, объяснить в комментариях почему она зафейлилась)
--3. Попробовать использовать RAISE внутри триггеров для логирования
-- Создание таблицы сотрудников

CREATE TABLE IF NOT EXISTS employees ( 
    employee_id SERIAL PRIMARY KEY, -- Идентификатор сотрудника
    name VARCHAR(50) NOT NULL, -- Имя сотрудника
    position VARCHAR(50) NOT NULL, -- Должность
    department VARCHAR(50) NOT NULL, -- Отдел
    salary NUMERIC(10, 2) NOT NULL, -- Зарплата
    manager_id INT REFERENCES employees(employee_id) -- Идентификатор менеджера
);

-- Пример данных для таблицы сотрудников
INSERT INTO employees (name, position, department, salary, manager_id)
VALUES
    ('John Doe', 'Manager', 'Sales', 92000, NULL),
    ('Jane Smith', 'Sales Associate', 'Sales', 52000, 1),
    ('Emily Davis', 'Sales Associate', 'Sales', 51000, 1),
    ('Michael Brown', 'Sales Intern', 'Sales', 31000, 2),
    ('Sarah Wilson', 'Developer', 'IT', 78000, NULL),
    ('Tom Clark', 'Intern', 'IT', 36000, 5);

-- Выборка сотрудников с ограничением
SELECT * FROM employees LIMIT 5;

-- Создание таблицы продаж
CREATE TABLE IF NOT EXISTS sales (
    sale_id SERIAL PRIMARY KEY, -- Идентификатор продажи
    employee_id INT REFERENCES employees(employee_id), -- Сотрудник
    product_id INT NOT NULL, -- Продукт
    quantity INT NOT NULL, -- Количество проданных единиц
    sale_date DATE NOT NULL -- Дата продажи
);

-- Пример данных для таблицы продаж
INSERT INTO sales (employee_id, product_id, quantity, sale_date)
VALUES
    (2, 1, 18, '2024-11-12'),
    (3, 2, 7, '2024-11-15'),
    (4, 1, 4, '2024-11-09');

-- Выборка данных о продажах с ограничением
SELECT * FROM sales LIMIT 5;

-- Создание таблицы продуктов
CREATE TABLE IF NOT EXISTS products (
    product_id SERIAL PRIMARY KEY, -- Идентификатор продукта
    name VARCHAR(50) NOT NULL, -- Название продукта
    price NUMERIC(10, 1) NOT NULL -- Цена
);

-- Пример данных для таблицы продуктов
INSERT INTO products (name, price)
VALUES
    ('BMW 3 Series', 2.5),
    ('BMW X5', 12.5),
    ('BMW M4', 8.9),
    ('BMW Z4', 5.3),
    ('BMW i8', 4.1),
    ('BMW 7 Series', 9.7);

-- Выборка продуктов с ограничением
SELECT * FROM products LIMIT 5;

-- 1. Создание триггеров

-- Триггер перед вставкой в таблицу sales
CREATE OR REPLACE FUNCTION before_insert_sales()
RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Before INSERT in sales: Employee % sold product %.', NEW.employee_id, NEW.product_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_before_insert_sales
BEFORE INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION before_insert_sales();

-- Триггер после обновления зарплаты в таблице employees
CREATE OR REPLACE FUNCTION log_salary_update()
RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Employee % salary updated from % to %.', OLD.name, OLD.salary, NEW.salary;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_after_update_employees
AFTER UPDATE OF salary ON employees
FOR EACH ROW
EXECUTE FUNCTION log_salary_update();

-- Триггер предотвращающий удаление менеджера
CREATE OR REPLACE FUNCTION prevent_manager_deletion()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.position = 'Manager' THEN
        RAISE EXCEPTION 'Managers cannot be deleted.';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_employee_delete
BEFORE DELETE ON employees
FOR EACH ROW
EXECUTE FUNCTION prevent_manager_deletion();

-- 2. Пример успешной и неудачной транзакции

-- Успешная транзакция
BEGIN;

INSERT INTO employees (name, position, department, salary, manager_id)
VALUES ('Alice Green', 'QA Tester', 'IT', 42000, 5);

COMMIT;

-- Неудачная транзакция
BEGIN;

-- Попытка вставить данные с дублирующимся первичным ключом (ошибка, так как первичный ключ должен быть уникальным)
INSERT INTO employees (employee_id, name, position, department, salary, manager_id)
VALUES (1, 'Duplicate Key', 'Tester', 'QA', 50000, NULL);

-- Эта строка не будет выполнена из-за ошибки
RAISE NOTICE 'This operation will not complete.';

COMMIT;

-- 3. Использование RAISE для логирования

-- Триггер логирования продаж
CREATE OR REPLACE FUNCTION log_sales()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.quantity > 10 THEN
        RAISE NOTICE 'Large sale: Employee % sold % units of product % on %.',
            NEW.employee_id, NEW.quantity, NEW.product_id, NEW.sale_date;
    ELSE
        RAISE NOTICE 'Regular sale: Employee % sold % units of product % on %.',
            NEW.employee_id, NEW.quantity, NEW.product_id, NEW.sale_date;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_sale_insert
AFTER INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION log_sales();

-- Проверка триггеров

-- Проверка 1. Триггер перед вставкой
INSERT INTO sales (employee_id, product_id, quantity, sale_date)
VALUES (2, 3, -5, '2024-11-18'); -- Ожидается ошибка из-за некорректного количества

INSERT INTO sales (employee_id, product_id, quantity, sale_date)
VALUES (2, 3, 5, '2024-11-18'); -- Должно пройти успешно

-- Проверка 2. Триггер после обновления
UPDATE employees
SET salary = salary + 2000
WHERE employee_id = 2;

-- Проверка 3. Триггер перед удалением
DELETE FROM employees WHERE position = 'Manager'; -- Ожидается ошибка

