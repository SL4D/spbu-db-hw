--БД "Магазин компьютерных комплектующих"
-- Таблица продуктов
CREATE TABLE IF NOT EXISTS products (
    product_id SERIAL PRIMARY KEY, -- Идентификатор продукта
    name VARCHAR(100) NOT NULL, -- Название продукта
    category VARCHAR(50) NOT NULL, -- Категория (CPU, GPU и т.д.)
    brand VARCHAR(50) NOT NULL, -- Бренд
    price NUMERIC(10, 2) NOT NULL CHECK (price > 0), -- Цена
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0) -- Количество на складе
);

-- Таблица клиентов
CREATE TABLE IF NOT EXISTS customers (
    customer_id SERIAL PRIMARY KEY, -- Идентификатор клиента
    name VARCHAR(100) NOT NULL, -- Имя клиента
    email VARCHAR(100) NOT NULL UNIQUE, -- Электронная почта
    phone VARCHAR(15), -- Телефон
    address TEXT -- Адрес
);

-- Таблица заказов
CREATE TABLE IF NOT EXISTS orders (
    order_id SERIAL PRIMARY KEY, -- Идентификатор заказа
    customer_id INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE, -- Клиент
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Дата заказа
    total_amount NUMERIC(10, 2) NOT NULL CHECK (total_amount >= 0) -- Общая сумма заказа
);

-- Таблица позиций в заказе
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id SERIAL PRIMARY KEY, -- Идентификатор позиции
    order_id INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE, -- Заказ
    product_id INT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE, -- Продукт
    quantity INT NOT NULL CHECK (quantity > 0), -- Количество
    unit_price NUMERIC(10, 2) NOT NULL CHECK (unit_price > 0) -- Цена за единицу
);

-- Таблица поставщиков
CREATE TABLE IF NOT EXISTS suppliers (
    supplier_id SERIAL PRIMARY KEY, -- Идентификатор поставщика
    name VARCHAR(100) NOT NULL, -- Название поставщика
    contact_info TEXT -- Контактная информация
);

-- Таблица поставок
CREATE TABLE IF NOT EXISTS supplier_products (
    supplier_id INT NOT NULL REFERENCES suppliers(supplier_id) ON DELETE CASCADE, -- Поставщик
    product_id INT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE, -- Продукт
    supply_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Дата поставки
    quantity INT NOT NULL CHECK (quantity > 0), -- Количество
    PRIMARY KEY (supplier_id, product_id) -- Композитный ключ
);

-- Заполнение данными
--Заполнение таблицы products
INSERT INTO products (name, category, brand, price, stock_quantity)
VALUES
    ('Intel Core i9-12900K', 'CPU', 'Intel', 529.99, 50),
    ('AMD Ryzen 9 7950X', 'CPU', 'AMD', 699.99, 40),
    ('NVIDIA GeForce RTX 4090', 'GPU', 'NVIDIA', 1599.99, 20),
    ('AMD Radeon RX 7900 XTX', 'GPU', 'AMD', 999.99, 25),
    ('Corsair Vengeance DDR5 32GB', 'RAM', 'Corsair', 189.99, 100),
    ('Samsung 980 Pro 1TB', 'SSD', 'Samsung', 149.99, 75),
    ('Seagate BarraCuda 2TB', 'HDD', 'Seagate', 59.99, 200),
    ('ASUS ROG Strix Z790-E', 'Motherboard', 'ASUS', 399.99, 30),
    ('Cooler Master Hyper 212', 'Cooling', 'Cooler Master', 49.99, 150),
    ('EVGA 850W Power Supply', 'PSU', 'EVGA', 129.99, 60);
  
--Заполнение таблицы customers
   INSERT INTO customers (name, email, phone, address)
VALUES
    ('John Smith', 'john.smith@example.com', '123-456-7890', '123 Main St, Springfield'),
    ('Jane Doe', 'jane.doe@example.com', '987-654-3210', '456 Elm St, Shelbyville'),
    ('Alice Johnson', 'alice.j@example.com', '321-654-9870', '789 Oak St, Metropolis'),
    ('Bob Brown', 'bob.brown@example.com', '654-321-0987', '101 Pine St, Gotham'),
    ('Charlie White', 'charlie.w@example.com', '555-555-5555', '202 Birch St, Star City'),
    ('Diana Prince', 'diana.p@example.com', '111-222-3333', '303 Cedar St, Themyscira'),
    ('Eve Adams', 'eve.adams@example.com', '444-666-7777', '404 Maple St, Central City'),
    ('Frank Taylor', 'frank.t@example.com', '888-999-0000', '505 Aspen St, Coast City'),
    ('Grace Hall', 'grace.h@example.com', '222-333-4444', '606 Spruce St, Keystone City'),
    ('Henry King', 'henry.k@example.com', '333-444-5555', '707 Walnut St, Smallville');

--Заполнение таблицы orders
INSERT INTO orders (customer_id, order_date, total_amount)
VALUES
    (1, '2024-11-01', 2000.99),
    (2, '2024-11-02', 1500.50),
    (3, '2024-11-03', 999.99),
    (4, '2024-11-04', 250.00),
    (5, '2024-11-05', 1200.75),
    (6, '2024-11-06', 3000.10),
    (7, '2024-11-07', 899.99),
    (8, '2024-11-08', 450.25),
    (9, '2024-11-09', 2999.99),
    (10, '2024-11-10', 1000.00);
   
--Заполнение таблицы order_items
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
    (1, 1, 1, 529.99),
    (1, 3, 1, 1599.99),
    (2, 2, 1, 699.99),
    (2, 6, 1, 149.99),
    (3, 4, 1, 999.99),
    (4, 8, 1, 399.99),
    (5, 5, 2, 189.99),
    (6, 10, 3, 129.99),
    (7, 7, 1, 59.99),
    (8, 9, 2, 49.99);

--Заполнение таблицы suppliers
INSERT INTO suppliers (name, contact_info)
VALUES
    ('Tech Distributors Inc.', 'techd@example.com'),
    ('Global Hardware Supply', 'ghs@example.com'),
    ('PC Hardware World', 'pchardware@example.com'),
    ('Elite Components Ltd.', 'elitecomponents@example.com'),
    ('Prime Electronics', 'primeelectronics@example.com'),
    ('MegaParts Co.', 'megaparts@example.com'),
    ('BestSupply Corp.', 'bestsupply@example.com'),
    ('HighTech Partners', 'hightech@example.com'),
    ('Advanced Hardware Inc.', 'advancedhw@example.com'),
    ('FirstRate Supplies', 'firstrate@example.com');

--Заполнение таблицы supplier_products
INSERT INTO supplier_products (supplier_id, product_id, supply_date, quantity)
VALUES
    (1, 1, '2024-11-01', 30),
    (1, 3, '2024-11-01', 10),
    (2, 2, '2024-11-05', 20),
    (2, 4, '2024-11-05', 15),
    (3, 5, '2024-11-07', 50),
    (3, 6, '2024-11-07', 40),
    (4, 7, '2024-11-10', 100),
    (4, 8, '2024-11-10', 50),
    (5, 9, '2024-11-15', 200),
    (5, 10, '2024-11-15', 100);
    
   
 -- Задание 2.	Временные	структуры	и	представления,	способы	валидации	запросов.
   
--1) Создаем временную таблицу для популярных продуктов за последние 30 дней
CREATE TEMP TABLE high_sales_products AS
SELECT 
    p.product_id,
    p.name AS product_name,
    SUM(oi.quantity) AS total_quantity
	FROM 
    	products p
	JOIN 
    	order_items oi ON p.product_id = oi.product_id
	JOIN 
    	orders o ON oi.order_id = o.order_id
	WHERE 
    	o.order_date >= CURRENT_DATE - INTERVAL '30 days'
	GROUP BY 
    	p.product_id, p.name;

-- Проверяем содержимое временной таблицы
SELECT * FROM high_sales_products LIMIT 10;

--2) Создаем временную таблицу, которая сохраняет сводные данные по продажам для анализа в рамках текущей сессии.
CREATE TEMP TABLE temp_sales_summary AS
SELECT 
    o.order_date::DATE AS order_date,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.unit_price * oi.quantity) AS total_sales
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
GROUP BY 
    o.order_date::DATE;
   
--Проверяем содержимое временной таблицы
   SELECT * FROM temp_sales_summary LIMIT 10;

--3) Создаем CTE для анализа продаж сотрудников
WITH customer_sales_stats AS (
    SELECT 
        c.customer_id,
        c.name AS customer_name,
        COUNT(o.order_id) AS total_orders,
        AVG(o.total_amount) AS avg_order_value
    FROM 
        customers c
    JOIN 
        orders o ON c.customer_id = o.customer_id
    WHERE 
        o.order_date >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY 
        c.customer_id, c.name
)
SELECT 
    customer_id, 
    customer_name, 
    total_orders, 
    avg_order_value
FROM 
    customer_sales_stats;

--4) Топ-3 продуктов по продажам за текущий и прошлый месяц
WITH monthly_sales AS (
    SELECT 
        p.name AS product_name,
        DATE_TRUNC('month', o.order_date) AS sales_month,
        SUM(oi.quantity) AS total_quantity
    FROM 
        products p
    JOIN 
        order_items oi ON p.product_id = oi.product_id
    JOIN 
        orders o ON oi.order_id = o.order_id
    GROUP BY 
        p.name, DATE_TRUNC('month', o.order_date)
)
SELECT 
    product_name, 
    sales_month, 
    total_quantity
FROM (
    SELECT 
        product_name, 
        sales_month, 
        total_quantity,
        ROW_NUMBER() OVER (PARTITION BY sales_month ORDER BY total_quantity DESC) AS rank
    FROM 
        monthly_sales
) ranked_sales
WHERE 
    rank <= 3
ORDER BY 
    sales_month, rank;


--5) Анализ производительности запроса с трассировкой Считаем общее количество проданных единиц каждого продукта.
 EXPLAIN ANALYZE
SELECT 
    p.product_id, 
    p.name AS product_name, 
    SUM(oi.quantity) AS total_quantity
FROM 
    products p
JOIN 
    order_items oi ON p.product_id = oi.product_id
GROUP BY 
    p.product_id, p.name
ORDER BY 
    total_quantity DESC
LIMIT 10;

--Limit  (cost=52.71..52.73 rows=10 width=230) (actual time=0.059..0.062 rows=10 loops=1)
--  ->  Sort  (cost=52.71..53.11 rows=160 width=230) (actual time=0.058..0.060 rows=10 loops=1)
--        Sort Key: (sum(oi.quantity)) DESC
--        Sort Method: quicksort  Memory: 25kB
--        ->  HashAggregate  (cost=47.65..49.25 rows=160 width=230) (actual time=0.048..0.052 rows=10 loops=1)
--              Group Key: p.product_id
--              Batches: 1  Memory Usage: 40kB
--              ->  Hash Join  (cost=13.60..40.85 rows=1360 width=226) (actual time=0.034..0.040 rows=10 loops=1)
--                    Hash Cond: (oi.product_id = p.product_id)
--                    ->  Seq Scan on order_items oi  (cost=0.00..23.60 rows=1360 width=8) (actual time=0.010..0.011 rows=10 loops=1)
--                    ->  Hash  (cost=11.60..11.60 rows=160 width=222) (actual time=0.017..0.017 rows=20 loops=1)
--                          Buckets: 1024  Batches: 1  Memory Usage: 10kB
--                          ->  Seq Scan on products p  (cost=0.00..11.60 rows=160 width=222) (actual time=0.008..0.011 rows=20 loops=1)
--Planning Time: 0.189 ms
--Execution Time: 0.101 ms

--6) Представление для отчета о продуктах на складе
CREATE VIEW stock_status AS
SELECT 
    p.product_id,
    p.name AS product_name,
    p.category,
    p.brand,
    p.price,
    p.stock_quantity,
    COALESCE(SUM(sp.quantity), 0) AS total_supplied
FROM 
    products p
LEFT JOIN 
    supplier_products sp ON p.product_id = sp.product_id
GROUP BY 
    p.product_id, p.name, p.category, p.brand, p.price, p.stock_quantity;

--Проверка представления
   SELECT * FROM stock_status LIMIT 10;
  
--7) Представление для анализа заказов клиентов
CREATE VIEW customer_order_summary AS
SELECT 
    c.customer_id,
    c.name AS customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM 
    customers c
LEFT JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.name;

--Проверка представления
SELECT * FROM customer_order_summary LIMIT 10;

--8) Валидация запросов
CREATE OR REPLACE FUNCTION validate_stock()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.quantity > (SELECT stock_quantity FROM products WHERE product_id = NEW.product_id)) THEN
        RAISE EXCEPTION 'Недостаточно товара на складе для продукта ID %', NEW.product_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_stock
BEFORE INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION validate_stock();

--9) Валидация общего количества в заказе
CREATE OR REPLACE FUNCTION validate_order_total()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.total_amount <> (
        SELECT SUM(oi.quantity * oi.unit_price)
        FROM order_items oi
        WHERE oi.order_id = NEW.order_id
    )) THEN
        RAISE EXCEPTION 'Общая сумма заказа не совпадает с суммой позиций заказа для заказа ID %', NEW.order_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_order_total
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION validate_order_total();
