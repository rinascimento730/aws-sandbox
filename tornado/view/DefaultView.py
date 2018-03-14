# coding: utf-8
from __future__ import absolute_import
from . import BaseHandler
import tornado.web

class MainHandler(BaseHandler):
    def get(self):
        self.write("Hello, world")

class SubHandler(BaseHandler):
    def get(self, url):
        name = self.get_argument('name', 'World')
        self.render('default.html', name=name)