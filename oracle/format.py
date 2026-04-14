import csv
import json
import re
import os
import sys

def extract_fields(csv_path):
    results = []

    with open(csv_path, newline='', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            # Extract date from startzeit_ist
            date = row['startzeit_ist'][:10]  # YYYY-MM-DD

            # Parse param_request JSON (double-quoted style)
            req_raw = row['param_request']
            req = json.loads(req_raw)
            invoice_tenant_id = req.get('INVOICE_TENANT_ID', '')
            address_id = req.get('ADDRESS_ID', '')

            # Extract message from param_response
            resp_raw = row['param_response']
            # Parse the JSON blob inside CONTENT={...}
            content_match = re.search(r'CONTENT=(\{.*\})', resp_raw, re.DOTALL)
            if not content_match:
                continue
            content_json = json.loads(content_match.group(1))
            message = content_json.get('message', '')

            # Remove the prefix
            prefix = 'Client request(POST https://api.paypal.com/v2/checkout/orders) invalid: '
            if message.startswith(prefix):
                message = message[len(prefix):]

            # Extract the part after UNPROCESSABLE_ENTITY:
            entity_match = re.search(r'UNPROCESSABLE_ENTITY:\s*(.*?)(?:\.?"?\s*$|"?\s*$)', message, re.DOTALL)
            if entity_match:
                message = entity_match.group(1).strip().rstrip('"').strip()

            results.append({
                'date': date,
                'address_id': address_id,
                'invoice_tenant_id': invoice_tenant_id,
                'error': message,
            })

    return results


def format_output(results):
    lines = []
    for i, r in enumerate(results):
        lines.append(f"Date: {r['date']}")
        lines.append(f"ADDRESS_ID: {r['address_id']}")
        lines.append(f"INVOICE_TENANT_ID: {r['invoice_tenant_id']}")
        lines.append(f"Error: {r['error']}")
        if i < len(results) - 1:
            lines.append('')
    return '\n'.join(lines)


def main():
    csv_path = sys.argv[1] if len(sys.argv) > 1 else 'output.csv'
    csv_path = os.path.abspath(csv_path)

    results = extract_fields(csv_path)
    output = format_output(results)

    print(output)

    # Write to ../result/output.txt relative to the csv file's directory
    csv_dir = os.path.dirname(csv_path)
    result_dir = os.path.join(csv_dir, '..', 'result')
    os.makedirs(result_dir, exist_ok=True)
    out_path = os.path.join(result_dir, 'output.txt')
    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(output)
    print(f"\n[Saved to {os.path.abspath(out_path)}]", file=sys.stderr)


if __name__ == '__main__':
    main()
