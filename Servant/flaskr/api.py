from flask import Blueprint, request, abort
from .db import get_db
from .jwt import get_userJWT
from .util import query2Json, JWTverification, getUserID, getUserAuthority

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

# ttl: Users
@Users.route('/description/<int:user_id>', methods=('GET', 'POST'))
def get_user_description(user_id=1):
    """
    Parameters:
    user_id             前端请求的用户ID
    """
    sql = """SELECT phone, name FROM Users WHERE id = %i"""
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
            newSql = '''SELECT id FROM Users WHERE phone="%s"''' % (user['phone'])
            cursor = db.execute(newSql)
            dictData = [row[0] for row in cursor.fetchall()]
            db_userID = int(dictData[0])
            return "JWT:" + JWT + ";ID:" + str(db_userID)

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

# ttl: Products
@Products.route('/description/<int:product_id>', methods=('GET','POST'))
def get_product_description(product_id=1):
    sql = """SELECT id, name, amount, price FROM Products WHERE id=%i"""
    para = product_id
    json = query2Json(sql=sql,para=para, abort400=True)
    return json

@Products.route('/Flist/<string:user_input>')
def get_list_product_description(user_input):
    sql = """SELECT id, name, amount, price, barcode FROM Products WHERE name LIKE '%s'"""
    para = "%" + user_input + "%"
    json = query2Json(sql=sql, para=para, abort400=True)
    return json

@Products.route('/Ftype/<int:product_type>')
def get_product_description_by_type(product_type):
    sql = """SELECT id, name, amount, price, barcode FROM Products WHERE type=%i"""
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
        sql = '''INSERT INTO Products(name, amount, price, vipPrice, type) VALUES ("%s", %i, %f, %f, "%s")''' % (product['name'], product['amount'], product['price'], product['vipPrice'], product['type'])
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
        sqlCode = '''UPDATE Products SET name=\'%s\', price=%f, vipPrice=%f, type=%i WHERE id=%i''' % (product['name'], product['price'], product['vipPrice'], product['type'], product['productID'])
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
        sql = '''SELECT userID, productID, amount, price, description, type FROM Orders WHERE id=%i'''
        para = order['orderID']
        json = query2Json(sql=sql, para=para, abort400=True)
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
        sql = '''SELECT userID, productID, amount, price, description, type FROM Orders WHERE productID=%i'''
        para = order['productID']
        json = query2Json(sql=sql, para=para, abort400=True)
        return json

@Orders.route('descriptionByUser', methods=('GET','POST'))
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
        sql = '''SELECT userID, productID, amount, price, description, type FROM Orders WHERE userID=%i'''
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
        sql = '''INSERT INTO Orders(userID, productID, amount, price, type) VALUES (%i, %i, %i, %f, %i)''' % (order['id'], order['productID'], order['amount'], order['price'], order['type'])
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
