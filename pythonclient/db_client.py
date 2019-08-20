#!/usr/bin/env python
# -*- coding: utf-8 -*-
""" A client for Yelukerest, primarily to be used by faculty for
    bulk administration connecting directly to the database.
"""
import os
import click
import ldap3
import psycopg2
from names import get_student_nickname
from models import quiz
import ruamel.yaml as ruamel_yaml
import datetime
from jinja2 import Template


def read_yaml(filehandle):
    """ Reads a YAML file from the file system
    """

    yaml = ruamel_yaml.YAML(typ="safe", pure=True)
    data = yaml.load(filehandle)
    return data


@click.group()
@click.pass_context
def database(ctx):
    """ A function that groups together various commands and
        passes along a database connection in the context.
    """
    try:
        dburl = os.environ['DATABASE_URL']
    except KeyError:
        raise Exception("you must provide a DATABASE_URL in the environment")
    conn = psycopg2.connect(dburl)
    ctx.obj['conn'] = conn


def get_ldap_connection(host, user, password):
    """ Returns a connection to the LDAP host
    """
    server = ldap3.Server(host)
    conn = ldap3.Connection(server, user, password, auto_bind=True)
    return conn


def do_ldap_search(conn, netid):
    """ Search Yale LDAP for a particular netid. On the command
        line this would be something like the following:
        ldapsearch \
            -H ldaps://ad.its.yale.edu:3269 \
            -D cn=s_klj39,OU=Non-Netids,OU=Users-OU,dc=yu,dc=yale,dc=edu \
            -w $LDAP_PASS "(&(objectclass=Person)(CN=klj39))"
    """
    search_base = ""
    search_filter = "(&(objectclass=Person)(CN={0}))".format(netid)
    attributes = "*"
    conn.search(search_base, search_filter, attributes=attributes)
    try:
        return conn.entries[0]
    except IndexError:
        return None


def ldapget(result, key):
    """ Get a value from the LDAP result using a key. Return None
        if the key does not exist
    """
    try:
        return str(getattr(result, key))
    except ldap3.core.exceptions.LDAPKeyError:
        return None


def known_as_is_redundant(known_as, name):
    if not known_as:
        return False
    if known_as.lower() in set([x.lower() for x in name.split()]):
        return True
    if " " in known_as and known_as in name:
        return True
    return False


@database.command()
@click.pass_context
def getuserldap(ctx):
    """ Fill in info from Yale LDAP for all students
    """
    try:
        ldap_host = os.environ['LDAP_HOST']
        ldap_user = os.environ['LDAP_USER']
        ldap_pass = os.environ['LDAP_PASS']
    except KeyError:
        print("You must provide the following in the environment: LDAP_HOST, LDAP_USER, LDAP_PASS")

    conn = ctx.obj['conn']
    cur = conn.cursor()
    statement = 'SELECT netid FROM data.user'
    cur.execute(statement)
    netids = set([row[0] for row in cur.fetchall()])
    conn.commit()

    ldap_conn = get_ldap_connection(ldap_host, ldap_user, ldap_pass)
    for netid in netids:
        print('------------------' + netid)
        result = do_ldap_search(ldap_conn, netid)
        if result:
            print(result)
            known_as = ldapget(result, 'knownAs')
            name = ldapget(result, 'cn')
            if known_as_is_redundant(known_as, name):
                known_as = None
            last_name = ldapget(result, 'sn')
            email = ldapget(result, 'mail')
            organization = ldapget(result, 'o')
            print(", ".join(str(s)
                            for s in [name, known_as, last_name, email, organization]))
            cur = conn.cursor()
            statement = 'UPDATE data.user SET known_as = %s, name = %s, email = %s, lastname = %s, organization = %s WHERE netid = %s'
            cur.execute(statement, (known_as, name, email,
                                    last_name, organization, netid))
            conn.commit()


@database.command()
@click.pass_context
@click.argument('netid')
@click.argument('role')
@click.argument('nickname')
def adduser(ctx, netid, role, nickname):
    """ Add a user to the database

        Run like `honcho run python ./db_client.py adduser klj39 faculty short-owl`
    """
    conn = ctx.obj['conn']
    cur = conn.cursor()
    statement = 'INSERT INTO data.user (netid, role, nickname) VALUES (%s, %s, %s)'
    cur.execute(statement, (netid, role, nickname))
    conn.commit()


@database.command()
@click.pass_context
@click.argument('infile', type=click.File('r'))
def addstudents(ctx, infile):
    """ Add students from a list of netids

        Run like `honcho run python ./db_client.py addstudents filename`
    """
    users = [line.strip() for line in infile]
    conn = ctx.obj['conn']
    return addlistofstudents(conn, users)


@database.command()
@click.pass_context
@click.argument('student')
def addstudent(ctx, student):
    """ Add a student by netid
        Run like `honcho run python ./db_client.py addstudent klj12`
    """
    users = [student.strip()]
    conn = ctx.obj['conn']
    return addlistofstudents(conn, users)


def addlistofstudents(conn, students):
    """ Add a list of students

    Arguments:
        conn {sql connection} -- connection to the postgres database
        students {list} -- list of student netids, each of which a string
    """

    cur = conn.cursor()
    statement = 'SELECT nickname FROM data.user'
    cur.execute(statement)
    existing_nicknames = set([row[0] for row in cur.fetchall()])
    conn.commit()

    cur = conn.cursor()
    statement = 'SELECT netid FROM data.user'
    cur.execute(statement)
    existing_netids = set([row[0] for row in cur.fetchall()])
    conn.commit()

    for netid in students:
        if netid in existing_netids:
            continue
        tries = 0
        new_nickname = None
        while tries == 0 or new_nickname in existing_nicknames:
            new_nickname = get_student_nickname()
            tries += 1

        cur = conn.cursor()
        statement = 'INSERT INTO data.user (netid, role, nickname) VALUES (%s, %s, %s)'
        cur.execute(statement, (netid, "student", new_nickname))
        conn.commit()


@database.command()
@click.pass_context
@click.argument('quiz_id', type=click.INT)
def grade_quiz(ctx, quiz_id):
    """ Grades a quiz
    """
    conn = ctx.obj['conn']
    quiz.grade(conn, quiz_id)


@database.command()
@click.pass_context
def grade_quizzes(ctx):
    """ Grades all quizzes that are closed and not draft
    """
    conn = ctx.obj['conn']
    gradable_quiz_ids = quiz.get_gradable_quiz_ids(conn)
    for quiz_id in gradable_quiz_ids:
        quiz.grade(conn, quiz_id)


def delete_missing_meetings(cursor, slugs):
    """ Deletes all meetings that are not in a list of slugs

    Arguments:
        cursor {psycopg2 cursor} -- A database cursor
        slugs {list} -- List of meeting slugs we want to keep
    """
    query = """
        DELETE FROM data.meeting
        WHERE slug NOT IN %s;
    """
    cursor.execute(query, (tuple(slugs),))


def parse_timedelta(td):
    h, m = map(int, td.split(":"))
    return datetime.timedelta(hours=h, minutes=m)


@database.command()
@click.pass_context
@click.argument('infile', type=click.File('r'))
@click.option('--timedelta')
def update_meetings(ctx, infile, timedelta):
    """ Updates all meetings in the database. This takes a YAML-formatted
        list of meetings. Any meetings in the database with slugs that are
        not in the input YAML file will be deleted. Those that exist will
        be updated. Those that are new will be added.
    """
    conn = ctx.obj['conn']
    meetings = read_yaml(infile)

    if timedelta:
        td = parse_timedelta(timedelta)
        for m in meetings:
            m["begins_at"] += td

    try:
        with conn.cursor() as cur:
            delete_missing_meetings(cur, [m['slug'] for m in meetings])
            do_upsert(cur, "data.meeting", "slug", meetings)
        conn.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        conn.rollback()
    finally:
        conn.close()


def delete_missing_assignments(cursor, slugs):
    """ Deletes all assignments that are not in a list of slugs

    Arguments:
        cursor {psycopg2 cursor} -- A database cursor
        slugs {list} -- List of assignment slugs we want to keep
    """
    query = """
        DELETE FROM data.assignment
        WHERE slug NOT IN %s;
    """
    cursor.execute(query, (tuple(slugs),))


def nonchild(d):
    """ Returns a copy of a dictionary where any key prefixed with "child:"
        is removed.
    """
    return {k: v for k, v in d.items() if not k.startswith('child:')}


def do_upsert(cursor, table, conflict_condition, rows):
    """ Upserts rows.

    Arguments:
        cursor {psygopg2 cursor} -- A database cursor
        table {string} -- table in which to upsert
        conflict_condition {string} -- confict condition for UPDATE
        rows {list} -- the data to upsert, a list of dictionaries
    """
    base_query = """
        INSERT INTO {} ({})
        VALUES ({})
        ON CONFLICT ({})
        DO UPDATE
        SET {};
    """

    def make_query(assignment):
        keys = assignment.keys()
        return base_query.format(
            table,
            ','.join(keys),
            ','.join('%({})s'.format(k) for k in keys),
            conflict_condition,
            ','.join('{}=EXCLUDED.{}'.format(k, k) for k in keys)

        )
    for row in rows:
        q = make_query(row)
        cursor.execute(q, row)


def prepare_assignment(class_number, assignment):
    """ Removes children and runs body of assignment through jinja2.

    Arguments:
        class_number {string} -- Class number, like 656 or 660
        assignment {dictionary} -- Assignment info
    """
    template = Template(assignment['body'])
    assignment['body'] = template.render(class_number=class_number)
    return nonchild(assignment)


def upsert_assignments(cursor, class_number, assignments):
    """ Upserts assignments. Each assignment may have different
        columns specified. Though, each must have a 'slug' column
        or an exception will be raised.

    Arguments:
        cursor {psygopg2 cursor} -- A database cursor
        assignments {list} -- list of assignments
    """
    do_upsert(cursor, "data.assignment", "slug",
              [prepare_assignment(class_number, a) for a in assignments])

    all_fields = []
    for assignment in assignments:
        fields = assignment.get("child:assignment_fields", [])
        for field in fields:
            field["assignment_slug"] = assignment["slug"]
        all_fields.extend(fields)

    delete_query = """
        DELETE FROM data.assignment_field
        WHERE (slug, assignment_slug) NOT IN %s
    """
    keys = tuple(
        (f["slug"], f["assignment_slug"]) for f in all_fields)
    cursor.execute(delete_query, (keys, ))

    do_upsert(cursor, 'data.assignment_field',
              'slug, assignment_slug', all_fields)


@database.command()
@click.pass_context
@click.argument('class_number')
@click.argument('infile', type=click.File('r'))
def update_assignments(ctx, class_number, infile):
    """ Updates all assignments in the database. This takes a YAML-formatted
        list of assignments. Any assignments in the database with slugs that are
        not in the input YAML file will be deleted. Those that exist will
        be updated. Those that are new will be added.
    """
    conn = ctx.obj['conn']
    assignments = read_yaml(infile)

    try:
        with conn.cursor() as cur:
            delete_missing_assignments(cur, [m['slug'] for m in assignments])
            upsert_assignments(cur, class_number, assignments)
        conn.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        conn.rollback()
        raise
    finally:
        conn.close()


if __name__ == "__main__":
     # pylint: disable=unexpected-keyword-arg, no-value-for-parameter
    database(obj={})
