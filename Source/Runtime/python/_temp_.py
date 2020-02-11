
class myclass(object):
     def speak(self):
          print("%s 说：我今年%s岁" % (self.name, self.age))
     

#类student 实例化一个对象john
john = myclass()
# 给对象添加属性
john.name = "约翰"
john.age = 19
# 调用类中的 speak()方法
john.speak()
