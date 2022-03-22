from flask import Flask,render_template,request,session,redirect,url_for,flash
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import exc
from flask_login import UserMixin
from werkzeug.security import generate_password_hash,check_password_hash
from flask_login import login_user,logout_user,login_manager,LoginManager
from flask_login import login_required,current_user
from datetime import datetime

local_server=True

app = Flask(__name__)
app.secret_key='newproject'
login_manager = LoginManager(app)
login_manager.login_view='login'


@login_manager.user_loader
def load_user(id):
    return Login.query.get(int(id))

app.config['SQLALCHEMY_DATABASE_URI']='mysql://root:@localhost/icpm'
db=SQLAlchemy(app)

class Login(UserMixin,db.Model):
    id=db.Column(db.Integer,primary_key=True)
    empid=db.Column(db.String(50))
    password=db.Column(db.String(1000))
    
    
class Customer(db.Model):
    s_no=db.Column(db.Integer,primary_key=True)
    name=db.Column(db.String(100))
    phone=db.Column(db.String(100))
    address=db.Column(db.String(100))
    
class Employee(db.Model):
    employee_id=db.Column(db.Integer,primary_key=True)
    name=db.Column(db.String(100))
    phone=db.Column(db.String(20))
    job_type=db.Column(db.String(100))
    salary=db.Column(db.Integer)
    
class Ice_cream(db.Model):
    item_id=db.Column(db.Integer,primary_key=True)
    name=db.Column(db.String(25))
    description=db.Column(db.String(1000))
    price=db.Column(db.Float)
    waiter_id=db.Column(db.Integer)
    creator_id=db.Column(db.Integer)

class Orders(db.Model):
    order_id=db.Column(db.Integer,primary_key=True)
    item_id=db.Column(db.Integer)
    s_no=db.Column(db.Integer)
    quantity=db.Column(db.Integer)
    price=db.Column(db.Float)
    time=db.Column(db.String(1000))
    
class Payment(db.Model):
    payment_id=db.Column(db.Integer,primary_key=True)
    price=db.Column(db.Float)
    payment_mode=db.Column(db.String(100))
    s_no=db.Column(db.Integer)
    emp_id=db.Column(db.Integer)
    time=db.Column(db.String(100))
    
    
class Products(db.Model):
    p_id=db.Column(db.Integer,primary_key=True)
    p_name=db.Column(db.String(100))
    quantity=db.Column(db.Integer)
    price=db.Column(db.Float)
    emp_id=db.Column(db.String(11))
    sup_id=db.Column(db.Integer)
    time=db.Column(db.String(1000))
    
class Supplier(db.Model):
    sup_id=db.Column(db.Integer,primary_key=True)
    name=db.Column(db.String(50))
    address=db.Column(db.String(100))
    phone=db.Column(db.String(15))
    
@app.route('/',methods=['POST','GET'])
def home():
    if request.method =="POST":
        p_name=request.form.get('p_name')
        quantity=request.form.get('quantity')
        price=request.form.get('price')
        emp_id=request.form.get('emp_id')
        sup_id=request.form.get('sup_id')
        now = datetime.now()
        query=db.engine.execute(f"INSERT INTO Products (p_name,quantity,price,emp_id,sup_id,time) VALUES ('{p_name}','{quantity}','{price}','{emp_id}','{sup_id}','{now}');")
        flash("Product purchase added","success")
        return render_template('home.html',query=query)
    return render_template('home.html')

@app.route('/Menu')
def Menu():
    return render_template('menu.html')

@app.route('/database')
@login_required
def database():
    return render_template('database.html')

@app.route('/login', methods=['POST','GET'])
def login():
    if request.method =="POST":
        empid=request.form.get('empid')
        password=request.form.get('password')
        if(len(password)<8 or len(password)>25):
            flash("Password must be atleast 8 characters long","danger")
            return render_template('login.html')
        login=Login.query.filter_by(empid=empid,password=password).first()
        if login:
            login_user(login)
            flash("Login successful","success")
            return redirect(url_for('home'))
        else:
            flash("invalid credentials","danger")
            return render_template('login.html')
    
    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))
    
@app.route('/orders')
@login_required
def orders():
    return render_template('orders.html')


@app.route('/cust')
@login_required
def cust():
    query=db.engine.execute(f"SELECT * FROM Customer;")
    return render_template('cust.html',query=query)

@app.route('/emp')
@login_required
def emp():
    query=db.engine.execute(f"SELECT * FROM Employee;")
    return render_template('emp.html',query=query)

@app.route('/suppl')
@login_required
def suppl():
    query=db.engine.execute(f"SELECT * FROM Supplier;")
    return render_template('suppl.html',query=query)

@app.route('/ice')
@login_required
def ice():
    query=db.engine.execute(f"SELECT * FROM Ice_cream;")
    return render_template('ice.html',query=query)

@app.route('/pay')
@login_required
def pay():
    query=db.engine.execute(f"SELECT * FROM Payment;")
    return render_template('pay.html',query=query)

@app.route('/ord')
@login_required
def ord():
    query=db.engine.execute(f"SELECT * FROM Orders;")
    return render_template('ord.html',query=query)

@app.route('/prod')
@login_required
def prod():
    query=db.engine.execute(f"SELECT * FROM Products;")
    return render_template('prod.html',query=query)


@app.route('/products')
@login_required
def products():
    return render_template('products.html')








@app.route('/item', methods=['POST','GET'])
@login_required
def item():
    if request.method == "POST":
        name=request.form.get('name')
        phone=request.form.get('phone')
        if (len(phone)>10 or len(phone)<10):
            flash("phone number should be 10 digits long","danger")
            return render_template('orders.html')
        address=request.form.get('address')
        query=db.engine.execute(f"INSERT INTO Customer (name,phone,address) VALUES ('{name}','{phone}','{address}');")
        flash("customer data added","success")
        query2=db.engine.execute(f"SELECT s_no FROM Customer;")
        query4=db.engine.execute(f"SELECT item_id FROM Ice_cream;")
        for q in query2:
            query3=q.s_no
        return render_template('item.html',query=query,query3=query3,query4=query4)
    else:
        query5=db.engine.execute(f"SELECT s_no FROM Customer;")
        for q in query5:
            query3=q.s_no
        return render_template('item.html',query3=query3)







@app.route('/add', methods=['POST','GET'])
@login_required
def add():
    if request.method == "POST":
        s_no=request.form.get('s_no')
        item_id=request.form.get('item_id')
        quantity=request.form.get('quantity')
        query1=db.engine.execute(f"SELECT price FROM Ice_cream WHERE item_id='{item_id}';")
        query2=query1.first()[0]
        price=0
        quantity=int(quantity)
        price=float(quantity*int(query2))
        now = datetime.now()
        try:
            query2=db.engine.execute(f"INSERT INTO Orders (item_id,s_no,quantity,price,time) VALUES ('{item_id}','{s_no}','{quantity}','{price}','{now}');")
            flash("order added","success")
            return render_template('add.html',query2=query2)
        except exc.SQLAlchemyError as e:
            flash("QUANTITY CANNOT BE ZERO","danger")
            query5=db.engine.execute(f"SELECT s_no FROM Customer;")
            for q in query5:
                query3=q.s_no
            return render_template('item.html',query3=query3)

@app.route('/payments', methods=['POST','GET'])
@login_required
def payments():
    query5=db.engine.execute(f"SELECT s_no FROM Customer;")
    for q in query5:
        query3=q.s_no
    query3=int(query3)
    query2=db.engine.execute(f"SELECT sum(price) FROM Orders WHERE s_no='{query3}'")
    query2=query2.first()[0]
    query2=float(query2)
    return render_template('payments.html',query2=query2,query3=query3)



@app.route('/bill', methods=['POST','GET'])
@login_required
def bill():
    if request.method == "POST":
        price=request.form.get('price')
        payment_mode=request.form.get('payment_mode')
        s_no=request.form.get('s_no')
        emp_id=request.form.get('emp_id')
        now = datetime.now()
        query=db.engine.execute(f"INSERT INTO Payment (price,payment_mode,s_no,emp_id,time) VALUES ('{price}','{payment_mode}','{s_no}','{emp_id}','{now}');")
        query1=db.engine.execute(f"SELECT c.s_no,i.item_id,i.name,i.price,o.quantity,o.price as tprice FROM Customer c,Ice_cream i,Orders o WHERE c.s_no=o.s_no AND i.item_id=o.item_id AND o.s_no='{s_no}';")
        return render_template('bill.html',query1=query1,price=price)
    return render_template('bill.html')


@app.route("/edit/<string:s_no>", methods=['POST','GET'])
@login_required
def custu(s_no):
    posts=Customer.query.filter_by(s_no=s_no).first()
    if request.method == "POST":
        name=request.form.get('name')
        phone=request.form.get('phone')
        address=request.form.get('address')
        db.engine.execute(f"UPDATE Customer SET name='{name}',phone='{phone}',address='{address}' WHERE s_no='{s_no}';")
        flash("Updated","success")
        return redirect("/cust")
    return render_template('editc.html',posts=posts)

@app.route("/delete/<string:s_no>", methods=['POST','GET'])
@login_required
def delc(s_no):
    db.engine.execute(f"DELETE FROM Customer WHERE s_no={s_no};")
    flash("Deleted","danger")
    return redirect('/cust')



@app.route("/edit/paym/<string:payment_id>", methods=['POST','GET'])
@login_required
def paym(payment_id):
    posts=Payment.query.filter_by(payment_id=payment_id).first()
    if request.method == "POST":
        price=request.form.get('price')
        payment_mode=request.form.get('payment_mode')
        s_no=request.form.get('s_no')
        emp_id=request.form.get('emp_id')
        pid=payment_id
        db.engine.execute(f"UPDATE Payment SET price='{price}',payment_mode='{payment_mode}',s_no='{s_no}',emp_id='{emp_id}' WHERE payment_id={pid};")
        flash("Updated","success")
        return redirect('/pay')
    return render_template('editp.html',posts=posts)

@app.route("/delete/paym/<string:payment_id>", methods=['POST','GET'])
@login_required
def detp(payment_id):
    db.engine.execute(f"DELETE FROM Payment WHERE payment_id={payment_id};")
    flash("Deleted","danger")
    return redirect('/pay')




@app.route('/edit/ord/<string:order_id>', methods=['POST','GET'])
@login_required
def ordr(order_id):
    posts=Orders.query.filter_by(order_id=order_id).first()
    if request.method == "POST":
        s_no=request.form.get('s_no')
        item_id=request.form.get('item_id')
        quantity=request.form.get('quantity')
        query1=db.engine.execute(f"SELECT price FROM Ice_cream WHERE item_id='{item_id}';")
        query2=query1.first()[0]
        price=0
        quantity=int(quantity)
        price=float(quantity*int(query2))
        db.engine.execute(f"UPDATE Orders SET s_no='{s_no}',item_id='{item_id}',quantity='{quantity}',price='{price}' WHERE order_id={order_id};")
        flash("Updated","success")
        return redirect('/ord')
    return render_template('edito.html',posts=posts)





@app.route("/delete/ord/<string:order_id>", methods=['POST','GET'])
@login_required
def delo(order_id):
    db.engine.execute(f"DELETE FROM Orders WHERE order_id={order_id};")
    flash("Deleted","danger")
    return redirect('/ord')


app.run(debug=True)