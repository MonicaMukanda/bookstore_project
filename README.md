# bookstore_project
# Bookstore Database

This project is designed to create a relational database to manage a bookstore's inventory, customers, orders, and transactions. The database includes various tables for storing data such as book details, author information, customer profiles, and more. It also includes roles and permissions to manage access securely.

## Overview

The **Bookstore Database** will allow a bookstore to efficiently manage the following key operations:
- Book management (titles, authors, publishers, and languages)
- Customer management (customer profiles, addresses)
- Order management (orders, order statuses, shipping methods)
- Security through user roles (admin and customer roles)

## Database Structure

### 1. **book**
Contains details about the books in the bookstore.

- `book_id` (INT): Primary key for identifying the book.
- `title` (VARCHAR): The title of the book.
- `language_id` (INT): Foreign key linking to the **book_language** table.
- `publisher_id` (INT): Foreign key linking to the **publisher** table.
- `publication_year` (YEAR): The year the book was published.
- `ISBN` (VARCHAR): International Standard Book Number, unique to each book.
- `price` (DECIMAL): Price of the book.

### 2. **book_language**
Stores information about the languages available for books.

- `language_id` (INT): Primary key for identifying the language.
- `language_name` (VARCHAR): Name of the language (e.g., English, Spanish).

### 3. **publisher**
Stores information about book publishers.

- `publisher_id` (INT): Primary key for identifying the publisher.
- `publisher_name` (VARCHAR): Name of the publisher.

### 4. **author**
Contains information about authors.

- `author_id` (INT): Primary key for identifying the author.
- `author_name` (VARCHAR): Name of the author.

### 5. **book_author**
Many-to-many relationship between books and authors.

- `book_id` (INT): Foreign key linking to the **book** table.
- `author_id` (INT): Foreign key linking to the **author** table.

### 6. **customer**
Contains information about customers.

- `customer_id` (INT): Primary key for identifying the customer.
- `first_name` (VARCHAR): Customer's first name.
- `last_name` (VARCHAR): Customer's last name.
- `email` (VARCHAR): Customer's email address (unique).
- `phone` (VARCHAR): Customer's phone number.

### 7. **customer_address**
Many-to-many relationship between customers and addresses.

- `customer_id` (INT): Foreign key linking to the **customer** table.
- `address_id` (INT): Foreign key linking to the **address** table.
- `address_status_id` (INT): Foreign key linking to the **address_status** table.

### 8. **address**
Stores details about customer addresses.

- `address_id` (INT): Primary key for identifying the address.
- `street_address` (VARCHAR): Street address of the customer.
- `city` (VARCHAR): City of the customer.
- `postal_code` (VARCHAR): Postal code of the address.
- `country_id` (INT): Foreign key linking to the **country** table.

### 9. **country**
Stores information about countries.

- `country_id` (INT): Primary key for identifying the country.
- `country_name` (VARCHAR): Name of the country (e.g., Kenya, USA).

### 10. **address_status**
Stores status information for addresses.

- `address_status_id` (INT): Primary key for identifying the address status.
- `status_name` (VARCHAR): Status of the address (e.g., "current", "old").

### 11. **order_status**
Stores status information for orders.

- `order_status_id` (INT): Primary key for identifying the order status.
- `status_name` (VARCHAR): Name of the status (e.g., "pending", "shipped", "delivered").

### 12. **shipping_method**
Stores information about shipping methods.

- `shipping_method_id` (INT): Primary key for identifying the shipping method.
- `method_name` (VARCHAR): Name of the shipping method (e.g., "Standard", "Express").

### 13. **cust_order**
Contains customer order details.

- `order_id` (INT): Primary key for identifying the order.
- `customer_id` (INT): Foreign key linking to the **customer** table.
- `order_date` (DATE): Date when the order was placed.
- `shipping_method_id` (INT): Foreign key linking to the **shipping_method** table.
- `order_status_id` (INT): Foreign key linking to the **order_status** table.

### 14. **order_line**
Contains details about the books in each order.

- `order_line_id` (INT): Primary key for identifying the order line.
- `order_id` (INT): Foreign key linking to the **cust_order** table.
- `book_id` (INT): Foreign key linking to the **book** table.
- `quantity` (INT): Quantity of the book ordered.
- `price` (DECIMAL): Price of the book at the time of the order.

### 15. **order_history**
Keeps track of changes to the status of an order.

- `order_history_id` (INT): Primary key for identifying the order history entry.
- `order_id` (INT): Foreign key linking to the **cust_order** table.
- `order_status_id` (INT): Foreign key linking to the **order_status** table.
- `update_timestamp` (TIMESTAMP): The time the status change was recorded.

## Security

Roles and permissions have been created to manage access securely:
- **Admin Role**: Has full access to all database operations.
- **Customer Role**: Has read-only access to book details and orders.

