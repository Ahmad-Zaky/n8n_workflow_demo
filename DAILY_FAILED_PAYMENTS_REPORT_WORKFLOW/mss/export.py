import pymssql
import csv
import argparse

parser = argparse.ArgumentParser(description='MSSQL to CSV exporter')
parser.add_argument('--host',     required=True,  help='Database host')
parser.add_argument('--user',     required=True,  help='Database username')
parser.add_argument('--password', required=True,  help='Database password')
parser.add_argument('--database', required=True,  help='Database name')
parser.add_argument('--query',    required=True,  help='SQL query to execute')
parser.add_argument('--output',   default='output.csv', help='Output CSV file (default: output.csv)')
args = parser.parse_args()

conn = pymssql.connect(
    server=args.host,
    user=args.user,
    password=args.password,
    database=args.database
)
cursor = conn.cursor()
cursor.execute(args.query.strip().rstrip(';'))

with open(args.output, "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow([col[0] for col in cursor.description])
    writer.writerows(cursor)

conn.close()

print(f"Done! SQL Query Output saved to {args.output}")