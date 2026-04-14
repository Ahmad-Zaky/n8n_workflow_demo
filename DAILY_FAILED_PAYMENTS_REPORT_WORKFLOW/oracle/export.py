import oracledb
import csv
import argparse

parser = argparse.ArgumentParser(description='Oracle SQL to CSV exporter')
parser.add_argument('--user',     required=True,  help='Database username')
parser.add_argument('--password', required=True,  help='Database password')
parser.add_argument('--dsn',      required=True,  help='DSN in format host:port/service')
parser.add_argument('--query',    required=True,  help='SQL query to execute')
parser.add_argument('--output',   default='output.csv', help='Output CSV file (default: output.csv)')
args = parser.parse_args()

conn = oracledb.connect(user=args.user, password=args.password, dsn=args.dsn)

cursor = conn.cursor()
cursor.execute(args.query.strip().rstrip(';'))
cursor.execute(args.query)

with open(args.output, "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow([col[0] for col in cursor.description])
    writer.writerows(cursor)

conn.close()

print(f"Done! Output saved to {args.output}")
