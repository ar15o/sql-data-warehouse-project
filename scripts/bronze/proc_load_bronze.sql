/*
===============================================================================
Load Bronze Layer
===============================================================================
Script Purpose:
    Loads data into the bronze schema from CSV source files.
    
Note:
    Data was loaded manually using pgAdmin's Import/Export tool
    instead of BULK INSERT since this project uses PostgreSQL.
    
Tables Loaded:
    - bronze.crm_cust_info
    - bronze.crm_prd_info
    - bronze.crm_sales_details
    - bronze.erp_cust_az12
    - bronze.erp_loc_a101
    - bronze.erp_px_cat_g1v2
===============================================================================
*/
