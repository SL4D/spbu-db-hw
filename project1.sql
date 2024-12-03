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
   
-- Проверить данные в таблице products
SELECT * FROM products LIMIT 10;

-- Проверить данные в таблице customers
SELECT * FROM customers LIMIT 10;

-- Проверить данные в таблице orders
SELECT * FROM orders LIMIT 10;

-- Проверить данные в таблице order_items
SELECT * FROM order_items LIMIT 10;

-- Проверить данные в таблице suppliers
SELECT * FROM suppliers LIMIT 10;

-- Проверить данные в таблице supplier_products
SELECT * FROM supplier_products LIMIT 10;


--Задание 1: Простые запросы и агрегации

--1) Получить список всех продуктов с ценой выше $500:
SELECT * 
FROM products 
WHERE price > 500 
LIMIT 10;

--2) Посчитать общее количество продуктов в каждой категории:
SELECT category, COUNT(*) AS total_products
FROM products
GROUP BY category
LIMIT 10;

--3) Вывести информацию о клиентах, которые сделали заказы дороже $1000
SELECT c.*
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.total_amount > 1000
LIMIT 10;

--4) Найти продукт с наибольшим количеством на складе:
SELECT name, stock_quantity
FROM products
ORDER BY stock_quantity DESC
LIMIT 1;

--5) Подсчет общего количества продаж для каждого продукта:
SELECT product_id, SUM(quantity) AS total_quantity
FROM order_items
GROUP BY product_id
LIMIT 10;

--6) Средняя сумма заказов
SELECT customer_id, AVG(total_amount) AS average_order_value
FROM orders
GROUP BY customer_id
LIMIT 10;
