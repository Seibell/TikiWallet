CREATE TABLE IF NOT EXISTS accounts (
    id SERIAL PRIMARY KEY,
    phone_number NUMERIC UNIQUE NOT NULL,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    is_loggedin BOOL DEFAULT TRUE,
    online_balance NUMERIC DEFAULT 0
);

CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY,
    from_user INT NOT NULL,
    to_user INT NOT NULL,
    value NUMERIC NOT NULL,
    transaction_on TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (from_user) REFERENCES accounts(id)
        ON DELETE CASCADE,
    FOREIGN KEY (to_user) REFERENCES accounts(id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS otp (
    id SERIAL PRIMARY KEY,
    otp INT NOT NULL,
    created_on TIMESTAMP DEFAULT NOW()
);