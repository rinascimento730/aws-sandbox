# coding: utf-8
import tornado.web

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Hello, world")

class SubHandler(tornado.web.RequestHandler):
    def get(self):
        name = self.get_argument('name', 'World')
        self.render('default.html', name=name)