#!/usr/bin/env python3

import sys
import os
import json


# thx to IceArrow256
# https://github.com/IceArrow256/ia256utilities/blob/master/ia256utilities/filesystem.py
def load_json(path, default_dict=True):
    """
    Loads a json file and returns it as a dictionary or list
    """
    if os.path.exists(path) and os.path.isfile(path):
        with open(path, encoding="utf8") as file:
            data = json.load(file)
        file.close()
        return data
    else:
        if default_dict:
            return {}
        else:
            return []


if __name__ == "__main__":
    if len(sys.argv) == 2:
        json = load_json(sys.argv[1])
        print(f"\nTransactions:\t\t\t{json['transactions']}\n"
              f"Successful transactions:\t{json['successful_transactions']}\n"
              f"Failed transactions:\t\t{json['failed_transactions']}\n"
              f"Server availability:\t\t{json['availability']} %\n"
              f"Elapsed time:\t\t\t{json['elapsed_time']} sec\n"
              f"Longest transaction:\t\t{json['longest_transaction']} sec\n"
              f"Shortest transaction:\t\t{json['shortest_transaction']} sec\n"
              )
