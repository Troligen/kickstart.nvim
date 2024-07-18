import sys

def adjust_table(table):
    # Determine the maximum length of entries in each column
    max_lengths = [max(len(str(item)) for item in col) for col in zip(*table)]

    # Adjust each entry to match the maximum length
    adjusted_table = []
    for row in table:
        adjusted_row = []
        for i, item in enumerate(row):
            if item[0] != "|":
                item = item.rstrip("|")
                if "---" in str(item):
                    item = item.rstrip(" ")
                    adjusted_row.append(str(item).ljust(max_lengths[i] - 2, "-") + " |")
                    continue
                adjusted_row.append(str(item).ljust(max_lengths[i] -1 ) + "|")
                continue

            if "---" in str(item):
                adjusted_row.append(str(item).ljust(max_lengths[i], "-").ljust(2))
                continue
            adjusted_row.append(str(item).ljust(max_lengths[i]))
        adjusted_table.append(adjusted_row)

    return adjusted_table


def read_table():
    input_text = sys.stdin.read()
    lines = input_text.strip().split("\n")
    table = [line.split(" | ") for line in lines]
    return table

def write_table(table):
    output = ""
    for row in table:
        output = output + " | ".join(row) + "\n"
    print(output)
    

def main():
    table = read_table()
    adjusted_table = adjust_table(table)
    write_table(adjusted_table)



if __name__ == "__main__":
    main()
