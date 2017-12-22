# coding: utf-8
import tornado.web

class IndexHandler(tornado.web.RequestHandler):
    def get(self):
        self.render('index.html')

class PythonHandler(tornado.web.RequestHandler):
    def get(self):
        self.render('python.html')

class PHPHandler(tornado.web.RequestHandler):
    def get(self):
        self.render('php.html')

class RubyHandler(tornado.web.RequestHandler):
    def get(self):
        self.render('ruby.html')