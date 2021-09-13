from .db import get_db
from flask import abort
import json

def query2Json(sql, para, abort400=False, returnNull=False): # Query database and return json
    """
    Parameters:
    sql         str, The sql statement
    para        str, The parameter for the sql statement
    abort400    bool, A boolean variable, if cannot find the corresponding item then abort HTTP 400 error.
    returnNull  bool, Return -1 if cannot find the corresponding item.
                    - abort400 and returnNull cannot both be true at the same time
    """
    db = get_db()
    cursor = db.execute(sql % para)
    dictData = [dict(row) for row in cursor.fetchall()] # Translate the data from cursor to python dictionary
    if abort400 == True: # Abort HTTP400 Error if find empty
        if not dictData: # Empty dictionary evaluate to False in python
            abort(400)
    if returnNull == True: # Return -1 if find empty
        if not dictData:
            return -1
    return json.dumps(dictData)

def JWTverification(JWT, userID):
    """
    Parameters:
    JWT         str, JWT input from the frontend
    userID      int, ID of the user for verificating its JWT
    """
    # Find the JWT stored in the server corresponding with the input
    sql = '''SELECT jwt FROM Users WHERE id=%i''' % userID
    db = get_db()
    cursor = db.execute(sql)
    dictData = [row[0] for row in cursor.fetchall()]
    db_JWT = str(dictData[0])
    # Equal to frontend input then return True
    if db_JWT == JWT:
        return True
    else:
        return False

def getUserID(para):
    """
    Parameters:
    para        str, Parameter for filtering the userID
                Parameter needs to contain \" when utilizing string data
    """
    db = get_db()
    cursor = db.execute("SELECT id FROM Users WHERE %s" % para)
    dictData = [row[0] for row in cursor.fetchall()]
    userID = int(dictData[0])
    return userID

def getUserAuthority(userID) -> int:
    """
    Parameters:
    userID      int, ID of the user
    """
    sql = '''SELECT authority FROM Users WHERE id = %i''' % userID
    db = get_db()
    cursor = db.execute(sql)
    dictData = [row[0] for row in cursor.fetchall()]
    return int(dictData[0])
