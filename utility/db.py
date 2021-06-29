#!/usr/bin/env python3

# =================================================================
#
#   MODULE: utility:db
#   LOCAL ENTRY POINT: .
#
#   utility
#   |-- common.sh
#   |-- db.py *CURRENT*
#   |-- utility.sh
#
#   COMMENT: python DB log accessor
#
# =================================================================

import argparse
import datetime
import sqlite3


class DB:
    conn = None

    @staticmethod
    def connect(path):
        DB.conn = sqlite3.connect(path)

    @staticmethod
    def cursor():
        return DB.conn.cursor()

    @staticmethod
    def close():
        DB.conn.close()

    @staticmethod
    def init_db():
        query = f'''
        CREATE TABLE IF NOT EXISTS diploma_module (
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,

            UNIQUE(name)
        )
        '''
        DB.cursor().execute(query)

        query = f'''
        CREATE TABLE IF NOT EXISTS diploma_log (
            id INTEGER PRIMARY KEY,
            datetime DATETIME,
            message TEXT,
            status TEXT,
            module_id INTEGER,

            FOREIGN KEY(module_id) REFERENCES diploma_module(id)
        )
        '''
        DB.cursor().execute(query)

        DB.conn.commit()

    @staticmethod
    def log(module, datetime, message, status):
        query = f'''
            INSERT OR IGNORE INTO diploma_module(name) VALUES('{module}')
        '''
        DB.cursor().execute(query)

        query = f'''
        INSERT INTO diploma_log (module_id,datetime,message,status)
        SELECT id,'{datetime}','{message}','{status}' FROM diploma_module
        WHERE name='{module}'
        '''
        DB.cursor().execute(query)

        DB.conn.commit()

    @staticmethod
    def get_all():
        cursor = DB.cursor()
        query = f'''
            SELECT * FROM diploma_log
            ORDER BY datetime DESC
        '''

        cursor.execute(query)
        return cursor.fetchall()

    @staticmethod
    def get_by_date_range(date_start, date_end):
        cursor = DB.cursor()
        query = f'''
            SELECT * FROM diploma_log
            WHERE datetime BETWEEN '{date_start}' AND '{date_end}'
            ORDER BY datetime DESC
        '''

        cursor.execute(query)
        return cursor.fetchall()

    @staticmethod
    def get_by_module(module):
        cursor = DB.cursor()
        query = f'''
            SELECT * FROM diploma_log
            WHERE module='{module}'
            ORDER BY datetime DESC
        '''

        cursor.execute(query)
        return cursor.fetchall()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="DBMS sqlite wrapper for diploma")
    parser.add_argument('-f', '--file', help='path to database', type=str)
    parser.add_argument('-l', '--log', help='save log to database', nargs='+')
    parser.add_argument('-a', '--all', help='select all', action='store_true')
    parser.add_argument('-d', '--by-date-range',
                        help='select by datetime range', nargs='+')
    parser.add_argument('-m', '--by-module',
                        help='select by module', nargs='+')
    args = parser.parse_args()

    DB.connect(args.file)
    DB.init_db()

    if args.log:
        module = args.log[0]
        datetime = datetime.datetime.now().isoformat()
        message = args.log[1]
        status = args.log[2]

        DB.log(module, datetime, message, status)

    if args.by_date_range:
        date_start = args.by_date_range[0]
        date_end = args.by_date_range[1]

        print('%-10s | %-30s | %-40s | %-10s' %
              ('id', 'module', 'datetime', 'status'))
        print('-'*120)
        for elem in DB.get_by_date_range(date_start, date_end):
            print('-'*120)
            print('%-10s | %-30s | %-40s | %-10s' %
                  (elem[0], elem[1], elem[2], elem[4]))
            print('-'*120)
            print(elem[3])
            print('='*120)
            print()

    if args.by_module:
        module = args.by_module[0]

        print('\n' + '-'*120)
        print(f'\n{module} - SUMMARY')
        print('\n' + '-'*120)
        print('%-10s | %-40s | %-10s' % ('id', 'datetime', 'status'))
        print('-'*120)
        for elem in DB.get_by_module(module):
            print('-'*120)
            print('%-10s | %-40s | %-10s' % (elem[0], elem[2], elem[4]))
            print('-'*120)
            print('\n' + elem[3] + '\n')
            print('='*120)
            print()

    if args.all:
        print('\n' + '-'*120)
        print(f'\nSUMMARY')
        print('\n' + '-'*120)
        print('%-10s | %-30s | %-40s | %-10s' %
              ('id', 'module', 'datetime', 'status'))
        print('-'*120)
        for elem in DB.get_all():
            print('-'*120)
            print('%-10s | %-30s | %-40s | %-10s' %
                  (elem[0], elem[1], elem[2], elem[4]))
            print('-'*120)
            print('\n' + elem[3] + '\n')
            print('='*120)
            print()

else:
    pass
