# coding: utf-8
from __future__ import absolute_import
import tornado.web

class BaseHandler(tornado.web.RequestHandler):
    def get(self):
        raise tornado.web.HTTPError(404)

    # self.write_errorをオーバーライド
    def write_error(self, status_code, exc_info=None, **kwargs):
        self.set_header('Content-Type', 'text/html; charset="utf-8"') # 適宜content-typeを宣言(optional)
        if status_code == 503:
            # 直接書いてもいいし、
            self.finish('<h1>503 Service Temporarily Unavailable</h1>')
        elif status_code == 404:
            # テンプレートを別途用意してもいい
            self.render('404.html')

from .DefaultView import *
from .ProgramView import *
