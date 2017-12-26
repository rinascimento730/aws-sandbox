# coding: utf-8
from __future__ import absolute_import
from . import BaseHandler
import tornado.web

class IndexHandler(BaseHandler):
    def get(self):
        self.render('index.html')

class PythonHandler(BaseHandler):
    def get(self):
        self.render('python.html')

class PHPHandler(BaseHandler):
    def get(self):
        self.render('php.html')

class RubyHandler(BaseHandler):
    def get(self):
        self.render('ruby.html')