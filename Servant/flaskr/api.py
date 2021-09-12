from flask import Blueprint, request, abort
from .db import get_db
from .jwt import get_userJWT
from .util import query2Json, JWTverification, getUserID

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

# ttl: Products
@Products.route('/description/<int:product_id>', methods=('GET','POST'))
def get_product_description(product_id=1):
    sql = """SELECT name, amount, price FROM Products WHERE id=%i"""
    para = product_id
    json = query2Json(sql=sql,para=para, abort400=True)
    return json

@Products.route('/list/<string:user_input>')
def get_list_product_description(user_input):
    sql = """SELECT name, amount, price, barcode FROM Products WHERE name LIKE '%s'"""
    para = "%" + user_input + "%"
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

# ttl: Orders
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


