# oxmysql

Use this rule when performing database operations in FiveM with oxmysql.

oxmysql replaces mysql-async and ghmattimysql with a promise-based API, named placeholders, and improved MySQL 8 compatibility.

## Setup

Add to `fxmanifest.lua`:

```lua
server_script '@oxmysql/lib/MySQL.lua'
```

Ensure `oxmysql` starts before any resource that uses it:

```bash
start oxmysql
start ox_lib
start my_resource
```

Connection string in `server.cfg`:

```bash
set mysql_connection_string "mysql://root:password@localhost:3306/fivem"
# Or semicolon-separated:
set mysql_connection_string "user=root;password=12345;host=localhost;port=3306;database=fivem"
```

## Query Functions

### MySQL.query

Execute a query returning multiple rows.

```lua
local results = MySQL.query.await('SELECT * FROM users WHERE job = ?', {'police'})
for i = 1, #results do
    print(results[i].name)
end
```

### MySQL.insert

Insert a row and return the insert id.

```lua
local id = MySQL.insert.await('INSERT INTO users (name, job) VALUES (?, ?)', {'John', 'police'})
print('Inserted user with id:', id)
```

### MySQL.update

Update rows and return affected row count.

```lua
local affected = MySQL.update.await('UPDATE users SET job = ? WHERE name = ?', {'ems', 'John'})
print('Updated', affected, 'rows')
```

### MySQL.scalar

Return a single value.

```lua
local count = MySQL.scalar.await('SELECT COUNT(*) FROM users WHERE job = ?', {'police'})
print('Police officers:', count)
```

### MySQL.single

Return a single row.

```lua
local user = MySQL.single.await('SELECT * FROM users WHERE identifier = ?', {identifier})
if user then
    print(user.name, user.job)
end
```

### MySQL.prepare

Pre-compiled statement for repeated execution.

```lua
local result = MySQL.prepare.await('SELECT * FROM users WHERE identifier = ?', {identifier})
```

### MySQL.transaction

Execute multiple queries atomically.

```lua
local queries = {
    {'UPDATE accounts SET balance = balance - ? WHERE id = ?', {amount, fromAccount}},
    {'UPDATE accounts SET balance = balance + ? WHERE id = ?', {amount, toAccount}},
}

local success = MySQL.transaction.await(queries)
if success then
    print('Transfer completed')
end
```

### MySQL.rawExecute

Execute raw SQL without parameter checking.

```lua
MySQL.rawExecute('ALTER TABLE users ADD COLUMN age INT')
```

## Named Placeholders

Use `:name` syntax for readability and safety:

```lua
MySQL.query.await('SELECT * FROM users WHERE job = :job AND grade = :grade', {
    job = 'police',
    grade = 3
})
```

## Upserting

Use `ON DUPLICATE KEY UPDATE` for insert-or-update:

```lua
MySQL.prepare.await(
    'INSERT INTO inventories (owner, name, data) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE data = VALUES(data)',
    {owner, dbId, inventory}
)
```

## Convars

```bash
# Slow query warning threshold (ms)
set mysql_slow_query_warning 150

# Debug all queries
set mysql_debug true

# Debug specific resources only
set mysql_debug ["ox_core", "ox_inventory"]
```

## Best Practices

1. **Always use `.await` in async contexts** — Prevents callback hell
2. **Use named placeholders** — More readable and prevents parameter order mistakes
3. **Use `MySQL.prepare` for repeated queries** — Better performance
4. **Use transactions for multi-step operations** — Ensures atomicity
5. **Handle nil returns** — `MySQL.single.await` returns nil if no row found
6. **Use upserts instead of check-then-insert** — Fewer queries, race-condition safe
7. **Avoid `MySQL.rawExecute` for user input** — No parameter sanitization
