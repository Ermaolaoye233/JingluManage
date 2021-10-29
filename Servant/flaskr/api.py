from flask import Blueprint, request, abort
from .db import get_db
from .jwt import get_userJWT
from .util import query2Json, JWTverification, getUserID, getUserAuthority
from datetime import datetime

class NestedBlueprint(object): # Object for creating nested blueprint
    def __init__(self, blueprint, prefix):
        '''
        Parameters:
        blueprint  The parent blueprint
        prefix     The prefix for the nested blueprint
        '''
        super(NestedBlueprint, self).__init__()
        self.blueprint = blueprint
        self.prefix = '/' + prefix

    # Route nested blueprint
    def route(self, rule, **options):
        rule = self.prefix + rule
        return self.blueprint.route(rule, **options)

# 路由蓝图
APIblueprint = Blueprint('api', __name__, url_prefix='/api')
Users = NestedBlueprint(APIblueprint, 'Users')
Products = NestedBlueprint(APIblueprint, 'Products')
Orders = NestedBlueprint(APIblueprint, 'Orders')
Types = NestedBlueprint(APIblueprint, 'Types')

# ttl: Users
@Users.route('/description/<int:user_id>', methods=('GET', 'POST'))
def get_user_description(user_id=1):
    """
    Parameters:
    user_id             前端请求的用户ID
    """
    sql = """SELECT * FROM Users WHERE id = %i"""
    para = user_id
    json = query2Json(sql=sql, para=para, abort400=True)
    return json

@Users.route('/allUser', methods=('GET','POST'))
def get_all_user():
    sql = """SELECT phone, name FROM Users%s"""
    para = "" # Empty parameter
    json = query2Json(sql=sql,para=para, abort400=True)
    return json

@Users.route('/login', methods=('GET', 'POST'))
def user_login():
    """
    JSON Requirement
    phone     str, phone number of the user
    password  str, password of the user
    """
    if request.method == 'POST':
        user = request.json
        sql = '''SELECT password FROM Users WHERE phone="%s"''' % (user['phone'])
        db = get_db()
        cursor = db.execute(sql)
        dictData = [row[0] for row in cursor.fetchall()]
        if len(dictData) > 0:
            db_userPassword = str(dictData[0])
            input_userPassword = str(user['password'])
        else:
            abort(400)
        if db_userPassword == input_userPassword:
            para = "phone == \"%s\"" % user['phone']
            JWT = get_userJWT(getUserID(para = para))
            db.commit()
            db.execute('''UPDATE Users SET jwt="%s" WHERE phone="%s"''' % (JWT, user['phone']))
            db.commit()
            newSql = '''SELECT id, phone, name, jwt FROM Users WHERE phone="%s"'''
            para = user['phone']
            json = query2Json(sql=newSql, para=para, abort400=True)
            return json
        else:
            abort(401)

@Users.route('/updatePassword', methods=('GET','POST'))
def update_password():
    """
    JSON Requirement
    oriPassword str, Original password stored in the database
    newPassword str, New password to be set
    id      int, ID of the user who wants to update their password
    """
    if request.method == 'POST':
        user = request.json
        db = get_db()
        cursor = db.execute("SELECT password FROM Users WHERE id=%i" % user["id"])
        dictData = [row[0] for row in cursor.fetchall()]
        db_userPassword = str(dictData[0])
        # Password Verification
        if db_userPassword != user['oriPassword']:
            return "IncorrectInput"
        db.commit()
        db.execute('''UPDATE Users SET password="%s" WHERE id=%i''' % (user['newPassword'], user['id']))
        db.commit()
        return "Succeed"

@Users.route('/calculateTotalIncome/<int:user_id>')
def get_user_total_income(user_id=1):
    sql = """SELECT SUM(price) FROM Orders WHERE userID = %i AND type = 1"""
    para = user_id
    db = get_db()
    cursor = db.execute(sql % para)
    dictData = [dict(row) for row in cursor.fetchall()]
    sumPriceDict = dictData.pop()
    return str(sumPriceDict['SUM(price)'])

@Users.route('/calculateThisMonthIncome/<int:user_id>')
def get_user_this_month_income(user_id=1):
    now = datetime.now()
    formatedTime = now.strftime("%Y-%m")
    sql = '''SELECT SUM(price) FROM Orders WHERE userID = %i AND type = 1 AND strftime('%%Y-%%m', time) = "%s"''' % (user_id, formatedTime)
    db = get_db()
    cursor = db.execute(sql)
    dictData = [dict(row) for row in cursor.fetchall()]
    sumPriceDict = dictData.pop()
    return str(sumPriceDict['SUM(price)'])

# ttl: Products
@Products.route('/description/<int:product_id>', methods=('GET','POST'))
def get_product_description(product_id=1):
    sql = """SELECT id, name, amount, inPrice, price, vipPrice, barcode, type FROM Products WHERE id=%i"""
    para = product_id
    json = query2Json(sql=sql,para=para, abort400=True)
    return json

@Products.route('/descriptionLatest', methods=('GET','POST'))
def get_product_description_latest():
    """
    JSON Requirement
    id      ID of the userID
    jwt     jwt stored in the frontend
    """
    if request.method == 'POST':
        product = request.json
        #JWT verification
        if not JWTverification(JWT = str(product['jwt']), userID = int(product['id'])):
            abort(401)
        sql = '''SELECT * FROM Products WHERE id IN (SELECT productID FROM Orders)'''
        para = ()
        json = query2Json(sql=sql, para=para)
        return json


@Products.route('/Flist/<string:user_input>')
def get_list_product_description(user_input):
    sql = """SELECT id, name, amount, inPrice, price, vipPrice, barcode, type FROM Products WHERE name LIKE '%s'"""
    para = "%" + user_input + "%"
    json = query2Json(sql=sql, para=para, abort400=True)
    return json

@Products.route('/Ftype/<int:product_type>')
def get_product_description_by_type(product_type):
    sql = """SELECT id, name, amount, inPrice, price, vipPrice, barcode, type FROM Products WHERE type=%i"""
    para = product_type
    json = query2Json(sql=sql, para=para, abort400=True)
    return json

@Products.route('/addProduct', methods=('GET','POST'))
def add_product():
    """
    JSON Requirement
    id      ID of the user wants to add the product
    jwt     jwt stored in the frontend
    name    name of the product
    inPrice the price taken to purchase the product
    price   price of the product
    vipPrice vipPrice of the product
    type    type of the product
    """
    if request.method == 'POST':
        product = request.json
        # JWT verification
        if not JWTverification(JWT = str(product['jwt']), userID = int(product['id'])):
            abort(401)
        db = get_db()
        sql = '''INSERT INTO Products(name, amount, inPrice, price, vipPrice, type) VALUES ("%s", %i, %f, %f, %f, "%s")''' % (product['name'], product['amount'], product['inPrice'], product['price'], product['vipPrice'], product['type'])
        db.execute(sql)
        db.commit()
        return 'Succeed'

@Products.route('/updateProduct', methods=('GET', 'POST'))
def update_product():
    """
    JSON Requirement
    id      ID of the user wants to update the product's record
    jwt     jwt stored in the frontend
    productID ID of the product being update_product
    name    new name
    inPrice new inPrice
    price   new price
    vipPrice new vipPrice
    type    new type
    """
    if request.method == 'POST':
        product = request.json
        # JWT verification
        if not JWTverification(JWT = str(product['jwt']), userID = int(product['id'])):
            abort(401)
        db = get_db()
        sqlCode = '''UPDATE Products SET name=\'%s\', inPrice=%f ,price=%f, vipPrice=%f, type=%i WHERE id=%i''' % (product['name'], product['inPrice'],product['price'], product['vipPrice'], product['type'], product['productID'])
        userAuthority = getUserAuthority(product['id'])
        if userAuthority == 0: # 员工
            content = 'update product with id:' + str(product['productID'])
            sql = '''INSERT INTO Requests(userID, request, sql) VALUES(%i,\"%s\",\"%s\")''' % (product['id'], content, sqlCode)
            db.execute(sql)
            db.commit()
            return "SucceedRequested"
        if userAuthority == 1:
            db.execute(sqlCode)
            db.commit()
            return "Succeed"


# ttl: Orders
@Orders.route('/description', methods=('GET','POST'))
def get_order_description():
    """
    JSON Requirement
    id      ID of the user
    jwt     jwt stored in the frontend
    orderID ID of the order
    """
    if request.method == 'POST':
        order = request.json
        #JWT verification
        if not JWTverification(JWT = str(order['jwt']), userID = int(order['id'])):
            abort(401)
        sql = '''SELECT id, userID, productID, amount, price, description, type, time FROM Orders WHERE id=%i'''
        para = order['orderID']
        json = query2Json(sql=sql, para=para, abort400=True)
        return json

@Orders.route('/descriptionLatest', methods=('GET','POST'))
def get_order_description_latest():
    """
    JSON Requirement
    id      ID of the userID
    jwt     jwt stored in the frontend
    """
    if request.method == 'POST':
        order = request.json
        #JWT verification
        if not JWTverification(JWT = str(order['jwt']), userID = int(order['id'])):
            abort(401)
        sql = '''SELECT * FROM(
        SELECT * FROM Orders ORDER BY id DESC LIMIT 4
        ) ORDER BY id ASC'''
        para = ()
        json = query2Json(sql=sql, para=para)
        return json

@Orders.route('/descriptionByProduct', methods=('GET', 'POST'))
def get_order_description_by_productID():
    """
    JSON Requirement
    id      ID of the user
    jwt     jwt stored in the frontend
    productID ID of the product
    """
    if request.method == 'POST':
        order = request.json
        #JWT verification
        if not JWTverification(JWT = str(order['jwt']), userID = int(order['id'])):
            abort(401)
        sql = '''SELECT id, userID, productID, amount, price, description, type, time FROM Orders WHERE productID=%i'''
        para = order['productID']
        json = query2Json(sql=sql, para=para, abort400=True)
        return json

@Orders.route('/descriptionByDay', methods=('GET','POST'))
def get_order_description_by_day():
    """
    JSON Requirement
    id      use id
    jwt     jwt stored in the frontend
    date    date of the request orders
    prodSpec product specific?
    userSpec user specific?
    productID   ID of the product
    userID  ID of the user 
    """
    if request.method == 'POST':
        order = request.json
        #JWT verfication
        if not JWTverification(JWT = str(order['jwt']), userID = int(order['id'])):
            abort(401)
        sql = ""
        para = ()
        if order['prodSpec']==0 and order['userSpec'] == 0:
            sql = '''SELECT id, userID, productID, amount, price, description, type, time FROM Orders WHERE time LIKE "%s"'''
            para = order['date'] + "%"
        if order['prodSpec'] == 1:
            sql = '''SELECT id, userID, productID, amount, price, description, type, time FROM Orders WHERE time LIKE "%s" AND productID=%i'''
            para = (order['date'] + "%", order['productID'])
        if order['userSpec'] == 1:
            sql = '''SELECT id, userID, productID, amount, price, description, type, time FROM Orders WHERE time LIKE "%s" AND userID=%i'''
            para = (order['date'] + "%", order['userID'])
        json = query2Json(sql=sql,para=para)
        return json

@Orders.route('/descriptionByUser', methods=('GET','POST'))
def get_order_description_by_userID():
    """
    JSON Requirement
    id      ID of the user
    jwt     jwt stored in the frontend
    userID  ID of the user who place the order
    """
    if request.method == 'POST':
        order = request.json
        #JWT verification
        if not JWTverification(JWT = str(order['jwt']), userID = int(order['id'])):
            abort(401)
        sql = '''SELECT * FROM Orders WHERE userID=%i'''
        para = order['userID']
        json = query2Json(sql=sql, para=para, abort400=True)
        return json    


@Orders.route('/addOrder', methods=('GET','POST'))
def add_order():
    """
    JSON Requirement
    id      ID of the user wants to add order
    jwt     jwt stored in the frontend
    amount  amount of the product in the order  
    productID ID of the product being ordered
    type    type of the order
    price   total price of the order
    time    time of the order
    """
    if request.method == 'POST' :
        order = request.json
        #JWT verification
        if not JWTverification(JWT = str(order['jwt']), userID = int(order['id'])):
            abort(401)
        db = get_db()
        # 进货
        if order['type'] == 0:
            sql = '''UPDATE Products SET amount = amount + %i WHERE id=%i''' % (order['amount'], order['productID'])
        else: # 出货
            sql = '''UPDATE Products SET amount = amount - %i WHERE id=%i''' % (order['amount'], order['productID'])
        db.execute(sql)
        db.commit()
        sql = '''INSERT INTO Orders(userID, productID, amount, price, type, time) VALUES (%i, %i, %i, %f, %i, %s)''' % (order['id'], order['productID'], order['amount'], order['price'], order['type'], order['time'])
        db.execute(sql)
        db.commit()
        return "Succeed"

@Orders.route('/updateOrder', methods=('GET','POST'))
def update_order():
    """
    JSON Requirement
    id      ID of the user wants to update an order's record
    jwt     jwt stored in the frontend
    orderID ID of the order user wants to change
    productID ID of the product being affected IMMUTABLE
    amount  amount of the product in the ordered
    oriAmount original amount of this order
    price   total price of the order
    type    type of the order IMMUTABLE
    """
    if request.method == 'POST':
        order = request.json
        #JWT verification
        if not JWTverification(JWT = str(order['jwt']), userID = int(order['id'])):
            abort(401)
        db = get_db()
        sqlCode = '''UPDATE Orders SET amount=%i, price=%f, type=%i WHERE id=%i''' % (order['amount'], order['price'], order['type'], order['orderID'])
        userAuthority = getUserAuthority(order['id'])
        if userAuthority == 0: # 员工
            content = 'update order with id:' + str(order['orderID'])
            sql = '''INSERT INTO Requests(userID, request, sql) VALUES(%i, "%s", "%s")''' % (order['id'], content, sqlCode)
            db.execute(sql)
            db.commit()
            return "SucceedRequested"
        if userAuthority >= 1: # 管理
            if order['type'] == 0: # 进货
                 lessAmount = order['oriAmount'] - order['amount']
                 sql = '''UPDATE Products SET amount = amount - %i WHERE id=%i''' % (lessAmount, order['productID'])
            else: # 出货
                lessAmount = order['oriAmount'] - order['amount']
                sql = '''UPDATE Products SET amount = amount + %i WHERE id=%i''' % (lessAmount, order['productID'])
            db.execute(sql)
            db.commit()
            db.execute(sqlCode)
            db.commit()
            return "Succeed"

@Orders.route('/delete', methods=('GET','POST'))
def delete_order():
    """
    JSON Requirement
    id      ID of the user wants to delete the order
    jwt     jwt stored in the frontend
    orderID ID of the order being delete_order
    """
    if request.method == 'POST':
        order = request.json
        #JWT verification
        if not JWTverification(JWT = str(order['jwt']), userID = int(order['id'])):
            abort(401)
        db = get_db()
        sqlCode = '''DELETE FROM Orders WHERE id=%i''' % order['orderID']
        userAuthority = getUserAuthority(order['id'])
        if userAuthority == 0: # 员工
            content = 'delete order record with id:' + str(order['orderID'])
            sql = '''INSERT INTO Requests(userID, request, sql) VALUES(%i, "%s", "%s")''' % (order['id'], content, sqlCode)
            db.execute(sql)
            db.commit()
            return "SucceedRequested"
        if userAuthority == 1: # 管理
            db.execute(sqlCode)
            db.commit()
            return "Succeed"

# ttl: Types
@Types.route('/getAll')
def get_types():
    sqlCode = '''SELECT * FROM Types'''
    para = ()
    json = query2Json(sql=sqlCode, para=para)
    return json

@Types.route('/addType', methods=('GET','POST'))
def add_type():
    """
    JSON Requirement
    id  ID of the user stored in the frontend
    jwt jwt stored in the frontend
    name name of the new type
    """
    if request.method == 'POST':
        data = request.json
        #JWT verification
        if not JWTverification(JWT = str(data['jwt']), userID = int(data['id'])):
            abort(401)
        db = get_db()
        sqlCode = '''INSERT INTO Types(type) VALUES (%s)''' % data['name']
        db.execute(sqlCode)
        db.commit()
        return 'Succeed'

@Types.route('/changeName', methods=('GET','POST'))
def update_type():
    """
    JSON Requirement
    id id stored in the frontend
    jwt jwt stored in the frontend
    typeID id of the type
    name name of the new type
    """
    if request.method == 'POST':
        data = request.json
        #JWT verification
        if not JWTverification(JWT = str(data['jwt']), userID = int(data['id'])):
            abort(401)
        db = get_db()
        sqlCode = '''UPDATE Products SET name=\'%s\' WHERE id = %i''' % (data['name'], data['typeID'])
        db.execute(sqlCode)
        db.commit()
        return "Succeed"

