import mysql.connector
import json

# MySQL Connection Details
db_config = {
    'host': 'firewall.platform1.co.za',
    'user': 'llew',
    'password': 'BCqmkPsND9zhmoYiMF9v',
    'database': 'lpr_admin_portal'
}

# Query to get camera details
query = """
SELECT 
    host, port, username, password
FROM 
    camera_profile
WHERE 
    is_activated = 1
AND
    is_vpn = 'false'
ORDER BY 
    id DESC;
"""

# def test_connection():
#     conn = mysql.connector.connect(**db_config)
#     cursor = conn.cursor()
#     cursor.execute("SHOW TABLES;")
#     print("Tables in the database:", cursor.fetchall())
#     cursor.close()
#     conn.close()

# if __name__ == "__main__":
#     test_connection()

def fetch_camera_hosts():
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)
    cursor.execute(query)
    results = cursor.fetchall()  # Fetch all rows
    # print("Raw query results:", results)  # Log raw rows
    hosts = [row['host'] for row in results if row['host']]  # Filter valid hosts
    cursor.close()
    conn.close()
    print("Extracted hosts:", hosts)  # Log extracted hosts
    return hosts

def generate_blackbox_targets(hosts, output_file):
    targets = [{"targets": hosts, "labels": {"job": "camera-ping"}}]
    with open(output_file, 'w') as f:
        json.dump(targets, f, indent=2)

if __name__ == "__main__":
    hosts = fetch_camera_hosts()
    generate_blackbox_targets(hosts, "blackbox_targets.json")