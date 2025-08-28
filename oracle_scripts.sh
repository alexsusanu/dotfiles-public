#!/bin/bash

# Oracle Test Environment Connection
# Usage: ./oracletest.sh 192.168.1.50
# Replace 'username' and 'password' with actual credentials
sql username/password@//$1:1521/orclpdb1

# ============================================

# Oracle Production Environment Connection  
# Usage: ./oracleprod.sh 10.0.0.100
# Replace 'username' and 'password' with actual credentials
sql username/password@//$1:1521/orclpdb1

# ============================================

# To use:
# 1. Split into separate files (oracletest.sh, oracleprod.sh)
# 2. chmod +x oracletest.sh oracleprod.sh
# 3. Update credentials in each file
# 4. Create aliases in ~/.bashrc:
#    alias oracletest='/path/to/oracletest.sh'
#    alias oracleprod='/path/to/oracleprod.sh'