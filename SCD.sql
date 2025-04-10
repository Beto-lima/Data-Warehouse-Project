-- Slowly Changing Dimension
-- (Type 1) Performing update without keep history

SELECT * FROM dw.dim_customers;
UPDATE dw.dim_customers
SET
    --informe 
WHERE --informe filter

--------------------------------------------------------------

--(Type 2) Keeps a history of changes

ALTER TABLE dw.dim_product ADD COLUMN begin_date DATE;
ALTER TABLE dw.dim_product ADD COLUMN end_date DATE;
ALTER TABLE dw.dim_product ADD COLUMN active BOOLEAN DEFAULT true;

--If there have been changes, the current record will be closed and a new one inserted

    CREATE OR REPLACE FUNCTION dw.update_dim_product(v_id_product INT, v_name VARCHAR, v_id_category INT, v_current_date DATE)
    RETURNS VOID AS $$
    BEGIN
        --Verify if exists a change 
        IF EXISTS (
            SELECT 1 FROM dw.dim_product
            WHERE id_product = v_id_product AND active
            AND (name <> v_name OR id_category <> v_id_category)
        ) THEN
            -- Close current record
            UPDATE dw.dim_product
            SET end_date = v_current_date, active = false
            WHERE id_product = v_id_product AND active;
            --Insert the new record
            INSERT INTO dw.dim_product (id_product, name, id_category, begin_date, end_date, active)
            VALUES (v_id_product, v_name, v_id_category, v_current_date, NULL, true);
        END IF;
    END;
    $$ LANGUAGE plpgsql;

-- Run function
SELECT dw.update_dim_product(101, 'Smartphone X Pro 2', 2, CURRENT_DATE);
-------------------------------------------------------------------
