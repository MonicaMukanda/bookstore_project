-- 1. Create the database
CREATE DATABASE bookstore_db;
USE bookstore_db;

-- 2. Create book_language table
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(100) UNIQUE NOT NULL
);

-- 3. Create publisher table
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(255) UNIQUE NOT NULL
);

-- 4. Create book table
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    language_id INT,
    publisher_id INT,
    publication_year YEAR,
    ISBN VARCHAR(20) UNIQUE,
    price DECIMAL(10,2),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

-- 5. Create author table
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(255) NOT NULL
);

-- 6. Create book_author (many-to-many relationship between books and authors)
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id), -- Composite key
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- 7. Create customer table
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20)
);

-- 8. Create address_status table
CREATE TABLE address_status (
    address_status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) UNIQUE NOT NULL -- e.g.'current','old'
);

-- 9. Create country table
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) UNIQUE NOT NULL
);

-- 10. Create address table
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street_address VARCHAR(255),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- 11.Create customer_address (Many-to-Many relationship between customers and addresses)
CREATE TABLE customer_address (
    customer_id INT,
    address_id INT,
    address_status_id INT,
    PRIMARY KEY (customer_id, address_id), -- Composite Key
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (address_status_id) REFERENCES address_status(address_status_id)
);

-- 12.Create order_status
CREATE TABLE order_status (
    order_status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(50) UNIQUE NOT NULL -- e.g., 'pending', 'shipped', 'delivered'
);

-- 13.Create shipping_method
CREATE TABLE shipping_method (
    shipping_method_id INT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(50) UNIQUE NOT NULL -- e.g., 'Standard', 'Express'
);

-- 14.Create customer order
CREATE TABLE cust_order (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    shipping_method_id INT,
    order_status_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id),
    FOREIGN KEY (order_status_id) REFERENCES order_status(order_status_id)
);

-- 15.Create order_line
CREATE TABLE order_line (
    order_line_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    book_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)

);

-- 16.Create order_history (Keeps track of order status changes)
CREATE TABLE order_history (
    order_history_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    order_status_id INT,
    update_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (order_status_id) REFERENCES order_status(order_status_id)
);


-- DATABASE ACCESS MANAGEMENT

-- Create user with read-only access
CREATE USER 'bookstore_staff'@'localhost' IDENTIFIED BY 'staff_password';

-- Create admin user with full access
CREATE USER 'bookstore_admin'@'localhost' IDENTIFIED BY 'admin_password';

-- Grant SELECT only to staff
GRANT SELECT ON bookstore_db.* TO 'bookstore_staff'@'localhost';

-- Grant full privileges to admin
GRANT ALL PRIVILEGES ON bookstore_db.* TO 'bookstore_admin'@'localhost';

-- Save the changes
FLUSH PRIVILEGES;


-- QUERYING FOR INSIGHTS


-- 1. Top 5 best-selling books
SELECT 
    b.title,
    SUM(ol.quantity) AS total_sold
FROM 
    order_line ol
JOIN 
    book b ON ol.book_id = b.book_id
GROUP BY 
    b.title
ORDER BY 
    total_sold DESC
LIMIT 5;

-- 2. Total revenue per book
SELECT 
    b.title,
    SUM(ol.quantity * ol.price) AS total_revenue
FROM 
    order_line ol
JOIN 
    book b ON ol.book_id = b.book_id
GROUP BY 
    b.title
ORDER BY 
    total_revenue DESC;

-- 3. Most frequent customers
SELECT 
    c.first_name, 
    c.last_name, 
    COUNT(o.order_id) AS total_orders
FROM 
    customer c
JOIN 
    cust_order o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id
ORDER BY 
    total_orders DESC
LIMIT 5;

-- 4. Orders by status
SELECT 
    os.status_name, 
    COUNT(co.order_id) AS total_orders
FROM 
    cust_order co
JOIN 
    order_status os ON co.order_status_id = os.order_status_id
GROUP BY 
    os.status_name;

-- 5. Book count per publisher
SELECT 
    p.publisher_name, 
    COUNT(b.book_id) AS total_books
FROM 
    publisher p
JOIN 
    book b ON p.publisher_id = b.publisher_id
GROUP BY 
    p.publisher_name;
