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
    
   
--  Задание 3 Триггеры	и	транзакции
   
  -- 1) Триггер перед вставкой в таблицу orders: проверка, чтобы общая сумма была больше 100
CREATE OR REPLACE FUNCTION check_order_total()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.total_amount < 100 THEN
        RAISE EXCEPTION 'Total order amount must be at least 100. Current amount: %', NEW.total_amount;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_orders
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION check_order_total();

--Проверка триггера перед вставкой:
INSERT INTO orders (customer_id, total_amount) 
VALUES (1, 50);

-- 2) Триггер после обновления в таблице products: логирование изменений stock_quantity
CREATE OR REPLACE FUNCTION log_product_update()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.stock_quantity != OLD.stock_quantity THEN
        RAISE NOTICE 'Stock quantity changed for product_id %: % -> %', 
            NEW.product_id, OLD.stock_quantity, NEW.stock_quantity;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_update_products
AFTER UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION log_product_update();

-- Изменение количества на складе продукта
UPDATE products 
SET stock_quantity = stock_quantity - 5 
WHERE product_id = 1;

-- 3) Триггер предотвращающий удаление записей из таблицы products
CREATE OR REPLACE FUNCTION prevent_product_deletion()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Deletion of products is not allowed. Attempted to delete product_id: %', OLD.product_id;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_delete_products
BEFORE DELETE ON products
FOR EACH ROW
EXECUTE FUNCTION prevent_product_deletion();

-- Попытка удалить продукт
DELETE FROM products WHERE product_id = 2; -- Должно вызвать ошибку


-- 4) Триггер для проверки минимального остатка на складе перед удалением записи
CREATE OR REPLACE FUNCTION check_min_stock_on_delete()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.stock_quantity < 10 THEN
        RAISE EXCEPTION 'Cannot delete product_id % as stock quantity is below minimum threshold (10). Current stock: %', 
            OLD.product_id, OLD.stock_quantity;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_delete_products_min_stock
BEFORE DELETE ON products
FOR EACH ROW
EXECUTE FUNCTION check_min_stock_on_delete();

-- Уменьшение остатка до значения ниже порога
UPDATE products SET stock_quantity = 5 WHERE product_id = 2;
-- Увеличение остатка
UPDATE products SET stock_quantity = 15 WHERE product_id = 2; -- Должно пройти успешно

-- 5) Триггер для логирования изменений в таблице orders
CREATE OR REPLACE FUNCTION log_order_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        RAISE NOTICE 'Order updated: order_id % -> Total amount changed from % to %', 
            NEW.order_id, OLD.total_amount, NEW.total_amount;
    ELSIF TG_OP = 'DELETE' THEN
        RAISE NOTICE 'Order deleted: order_id %', OLD.order_id;
    END IF;
    RETURN NULL; -- Для AFTER триггеров можно возвращать NULL
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_orders_changes
AFTER UPDATE OR DELETE ON orders
FOR EACH ROW
EXECUTE FUNCTION log_order_changes();

-- Обновление общей суммы заказа
UPDATE orders SET total_amount = 1800.50 WHERE order_id = 1;
-- Удаление заказа
DELETE FROM orders WHERE order_id = 1;


-- 6) Использование транзакций
BEGIN;
--Создание нового заказа
DO $$
DECLARE
    NEW_ORDER_ID INT; -- Объявление переменной для хранения идентификатора заказа
BEGIN
    -- Вставляем заказ и получаем его ID
    INSERT INTO orders (customer_id, total_amount)
    VALUES (1, 1500.00)
    RETURNING order_id INTO NEW_ORDER_ID;

    -- Добавление позиций в заказ
    INSERT INTO order_items (order_id, product_id, quantity, unit_price)
    VALUES 
        (NEW_ORDER_ID, 3, 1, 1599.99); -- NVIDIA GeForce RTX 4090

    -- Проверка и обновление запасов
    DECLARE
        product_record RECORD;
    BEGIN
        FOR product_record IN 
            SELECT product_id, quantity 
            FROM order_items 
            WHERE order_id = NEW_ORDER_ID
        LOOP
            -- Проверяем наличие на складе
            IF (SELECT stock_quantity FROM products WHERE product_id = product_record.product_id) < product_record.quantity THEN
                RAISE EXCEPTION 'Insufficient stock for product_id %. Transaction will be rolled back.', product_record.product_id;
            END IF;

            -- Списываем товары со склада
            UPDATE products
            SET stock_quantity = stock_quantity - product_record.quantity
            WHERE product_id = product_record.product_id;
        END LOOP;
    END;
END $$;
COMMIT;


