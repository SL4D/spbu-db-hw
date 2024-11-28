CREATE TABLE IF NOT EXISTS employees (
    employee_id SERIAL PRIMARY KEY, -- Идентификатор сотрудника
    name VARCHAR(50) NOT NULL, -- Имя сотрудника
    position VARCHAR(50) NOT NULL, -- Должность
    department VARCHAR(50) NOT NULL, -- Отдел
    salary NUMERIC(10, 2) NOT NULL, -- Зарплата
    manager_id INT REFERENCES employees(employee_id) -- Идентификатор менеджера
);

-- Пример данных
INSERT INTO employees (name, position, department, salary, manager_id)
VALUES
    ('John Doe', 'Manager', 'Sales', 92000, NULL),
    ('Jane Smith', 'Sales Associate', 'Sales', 52000, 1),
    ('Emily Davis', 'Sales Associate', 'Sales', 51000, 1),
    ('Michael Brown', 'Sales Intern', 'Sales', 31000, 2),
    ('Sarah Wilson', 'Developer', 'IT', 78000, NULL),
    ('Tom Clark', 'Intern', 'IT', 36000, 5);

-- Выборка данных с лимитом
SELECT * FROM employees LIMIT 5;


CREATE TABLE IF NOT EXISTS sales (
    sale_id SERIAL PRIMARY KEY, -- Идентификатор продажи
    employee_id INT REFERENCES employees(employee_id), -- Сотрудник
    product_id INT NOT NULL, -- Продукт
    quantity INT NOT NULL, -- Количество проданных единиц
    sale_date DATE NOT NULL -- Дата продажи
);

-- Пример данных
INSERT INTO sales (employee_id, product_id, quantity, sale_date)
VALUES
    (2, 1, 18, '2024-11-12'),
    (2, 2, 12, '2024-11-14'),
    (2, 3, 10, '2024-10-28'),
    (3, 1, 8, '2024-11-10'),
    (3, 4, 7, '2024-11-15'),
    (3, 5, 5, '2024-11-16'),
    (4, 1, 4, '2024-11-09'),
    (4, 3, 6, '2024-11-08'),
    (4, 6, 3, '2024-11-05'),
    (4, 2, 2, '2024-11-06');

-- Выборка данных с лимитом
SELECT * FROM sales LIMIT 5;

CREATE TABLE IF NOT EXISTS products (
    product_id SERIAL PRIMARY KEY, -- Идентификатор продукта
    name VARCHAR(50) NOT NULL, -- Название продукта
    price NUMERIC(10, 1) NOT NULL -- Цена
);

-- Пример данных
INSERT INTO products (name, price)
VALUES
    ('BMW 3 Series', 2.5),
    ('BMW X5', 12.5),
    ('BMW M4', 8.9),
    ('BMW Z4', 5.3),
    ('BMW i8', 4.1),
    ('BMW 7 Series', 9.7);

-- Выборка данных с лимитом
SELECT * FROM products LIMIT 5;

--Домашнее задание №3
--1) Создайте временную таблицу high_sales_products, которая будет содержать продукты, проданные в количестве более 10 единиц за последние 7 дней. Выведите данные из таблицы high_sales_products 
--2) Создайте CTE employee_sales_stats, который посчитает общее количество продаж и среднее количество продаж для каждого сотрудника за последние 30 дней. Напишите запрос, который выводит сотрудников с количеством продаж выше среднего по компании 
--3) Используя CTE, создайте иерархическую структуру, показывающую всех сотрудников, которые подчиняются конкретному менеджеру
--4) Напишите запрос с CTE, который выведет топ-3 продукта по количеству продаж за текущий месяц и за прошлый месяц. В результатах должно быть указано, к какому месяцу относится каждая запись
--5) Создайте индекс для таблицы sales по полю employee_id и sale_date. Проверьте, как наличие индекса влияет на производительность следующего запроса, используя трассировку (EXPLAIN ANALYZE)
--6) Используя трассировку, проанализируйте запрос, который находит общее количество проданных единиц каждого продукта.


--Задание 1:
--Создайте временную таблицу high_sales_products, содержащую продукты, проданные в количестве более 10 единиц за последние 7 дней. Выведите данные из этой таблицы.
CREATE TEMP TABLE high_sales_products AS
SELECT product_id, SUM(quantity) AS total_quantity
FROM sales
WHERE sale_date >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY product_id
HAVING SUM(quantity) > 10;

-- Вывод данных из временной таблицы
SELECT * FROM high_sales_products LIMIT 5;

-- Удаление временной таблицы после использования
DROP TABLE high_sales_products;

--Задание 2:
--Создайте CTE employee_sales_stats, который подсчитает общее количество продаж и среднее количество продаж для каждого сотрудника за последние 30 дней. Напишите запрос, который выводит сотрудников с количеством продаж выше среднего по компании.
WITH employee_sales_stats AS (
    SELECT 
        e.employee_id, 
        e.name AS employee_name,
        AVG(s.quantity) AS avg_sales, 
        SUM(s.quantity) AS total_sales
    FROM sales s
    JOIN employees e ON s.employee_id = e.employee_id
    WHERE s.sale_date >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY e.employee_id, e.name
)
SELECT 
    employee_name, 
    avg_sales, 
    total_sales
FROM employee_sales_stats
WHERE total_sales > (SELECT COALESCE(AVG(total_sales), 0) FROM employee_sales_stats)
LIMIT 10;

--Задание 3:
--Создайте иерархическую структуру, показывающую всех сотрудников, которые подчиняются конкретному менеджеру.
WITH employee_hierarchy AS (
    SELECT 
        e1.name AS manager, 
        e2.name AS employee
    FROM employees e1
    JOIN employees e2 ON e1.employee_id = e2.manager_id
)
SELECT * FROM employee_hierarchy LIMIT 5;

--Задание 4:
--Создайте CTE, который выведет топ-3 продукта по количеству продаж за текущий месяц и за прошлый месяц. В результатах должно быть указано, к какому месяцу относится каждая запись.
WITH 
top_products_current_month AS (
    SELECT 
        s.product_id, 
        p.name AS product_name, 
        SUM(s.quantity) AS total_quantity,
        ROW_NUMBER() OVER (ORDER BY SUM(s.quantity) DESC) AS row_num
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    WHERE EXTRACT(MONTH FROM s.sale_date) = EXTRACT(MONTH FROM CURRENT_DATE)
      AND EXTRACT(YEAR FROM s.sale_date) = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY s.product_id, p.name
),
top_products_previous_month AS (
    SELECT 
        s.product_id, 
        p.name AS product_name, 
        SUM(s.quantity) AS total_quantity,
        ROW_NUMBER() OVER (ORDER BY SUM(s.quantity) DESC) AS row_num
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    WHERE EXTRACT(MONTH FROM s.sale_date) = EXTRACT(MONTH FROM CURRENT_DATE) - 1
      AND EXTRACT(YEAR FROM s.sale_date) = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY s.product_id, p.name
)
SELECT 
    'Текущий месяц' AS month, 
    product_id, 
    product_name,
    total_quantity
FROM top_products_current_month
WHERE row_num <= 3
UNION ALL
SELECT 
    'Прошлый месяц' AS month, 
    product_id, 
    product_name,
    total_quantity
FROM top_products_previous_month
WHERE row_num <= 3
ORDER BY month, total_quantity DESC
LIMIT 6;

--Задание 5:
--Создайте индекс для таблицы sales по полям employee_id и sale_date. Проверьте, как наличие индекса влияет на производительность следующего запроса с использованием трассировки.
-- Запрос без индекса
EXPLAIN ANALYZE 
SELECT * FROM sales 
WHERE employee_id = 2 AND sale_date BETWEEN '2024-11-01' AND CURRENT_DATE;

-- Создание индекса
CREATE INDEX idx_employee_id_sale_date ON sales (employee_id, sale_date);

-- Запрос с индексом
EXPLAIN ANALYZE 
SELECT * FROM sales 
WHERE employee_id = 2 AND sale_date BETWEEN '2024-11-01' AND CURRENT_DATE;

-- Удаление индекса (по необходимости)
DROP INDEX idx_employee_id_sale_date;

--Seq Scan on sales  (cost=0.00..44.00 rows=1 width=20) (actual time=0.009..0.011 rows=2 loops=1)
  --Filter: ((sale_date >= '2024-11-01'::date) AND (employee_id = 2) AND (sale_date <= CURRENT_DATE))
  --Rows Removed by Filter: 8
--Planning Time: 0.057 ms
--Execution Time: 0.021 ms

--Задание 6:
--Используя трассировку, проанализируйте запрос, который находит общее количество проданных единиц каждого продукта.
-- Запрос для подсчета общего количества проданных единиц
EXPLAIN ANALYZE
SELECT product_id, SUM(quantity) AS total_sales
FROM sales
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 5;

--Limit  (cost=1.42..1.43 rows=5 width=12) (actual time=0.030..0.031 rows=5 loops=1)
  -- ->  Sort  (cost=1.42..1.44 rows=10 width=12) (actual time=0.029..0.029 rows=5 loops=1)
        --Sort Key: (sum(quantity)) DESC
        --Sort Method: quicksort  Memory: 25kB
        -- ->  HashAggregate  (cost=1.15..1.25 rows=10 width=12) (actual time=0.023..0.024 rows=6 loops=1)
              --Group Key: product_id
              --Batches: 1  Memory Usage: 24kB
             -- ->  Seq Scan on sales  (cost=0.00..1.10 rows=10 width=8) (actual time=0.013..0.015 rows=10 loops=1)
--Planning Time: 0.069 ms
--Execution Time: 0.055 ms

--Планировочное время (Planning Time) показывает, сколько времени потребовалось серверу для составления плана выполнения запроса.
--Время выполнения (Execution Time) указывает на фактическое время выполнения запроса.